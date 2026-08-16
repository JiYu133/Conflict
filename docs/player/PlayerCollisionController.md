# PlayerCollisionController

**文件：** `classes/player/player_collision_controller.gd`

## 职责与组件边界

`PlayerCollisionController` 是 `BasePlayer` 主环境碰撞胶囊 `PlayerCollisionShape` 的唯一所有者。它只知道三项内容：所属 `CharacterBody3D`、`MovementConfig` 和一个返回 `AABB` 的 `Callable`。

它不知道 `StanceController`、`PlayerModelManager`、`HealthSystem`、`BodyHitbox` 或动画名称，也不会直接调用这些组件的方法。

```text
BodyHitbox（HealthSystem 私有节点）
        ↓ HealthSystem 内部合并
player-local AABB 值
        ↓ 注入 Callable
PlayerCollisionController
        ↓ geometry_changed(纯数值信号)
调试 / 测试 / 未来消费者
```

`BasePlayer` 是组合根，负责把 `HealthSystem.get_collision_envelope` 注入碰撞组件，并把 stance 信号转换成模型 Y 偏移和无 hitbox 时的 fallback 高度。跨组件接线集中在这里；业务组件之间不互相持有。

## 3D 动态拟合

旧实现只取 hitbox 的最低/最高 Y，无法知道趴下的人体沿地面占据多长范围。当前流程使用所有 H 键可见 `BodyHitbox` 的完整 3D 包络：

1. `BodyHitbox.get_bounds()` 计算单个形状在玩家局部空间中的 `AABB`。
2. `HealthSystem.get_collision_envelope()` 合并全部 hitbox，只返回 `AABB` 值，不暴露节点。
3. 碰撞控制器比较包络 X/Y/Z 三轴长度。
4. 连续稳定数帧后，最长轴成为胶囊主轴。
5. 站立/下蹲通常选择 Y 轴；趴下包络沿 X 或 Z 更长时，同一胶囊自动平放。
6. 对 AABB 的八个角点计算到胶囊中轴线段的距离，搜索满足全部角点的最小半径/高度组合。

这里没有 `if prone` 或逐动画碰撞高度表；翻滚、倒地或未来动作只要改变骨骼 hitbox 分布，就会经过同一拟合流程。

医疗 hitbox 不覆盖脚底，因此胶囊的地面接触面固定在站立配置的底边。竖直胶囊使用“固定底边到最高 hitbox”的高度；水平胶囊也以同一底边为锚点，并同时包住 AABB 的上下、左右和前后角点。胶囊旋转时使用“球半径 + 中段在世界 Y 上的投影”计算真实垂直半高，再调整中心 Y；两种方向都不会把 `CharacterBody3D` 瞬间顶起或落下。

`collision_bounds_max_height` 和 `collision_bounds_max_radius` 是正常动画数据的首选保护范围。如果首选范围无法包含输入包络，控制器会扩大搜索范围；完整包围人体优先于静默截断碰撞体。如果异常包络已经低于配置地面、导致地面锚定在数学上无解，则降级为以包络中心定位的精确胶囊，而不是漏掉身体。`contains_envelope(AABB)` 提供只读断言接口，测试会逐角验证实际胶囊。

## 防抖与限速

| 字段 | 作用 |
|---|---|
| `hitbox_driven_collision` | 启用 3D hitbox 包络；关闭或无包络时使用 fallback |
| `collision_bounds_margin` | 包络三个轴外的通用安全余量 |
| `collision_bounds_follow_speed` | 胶囊高度、半径和水平中心每秒最大变化 |
| `collision_bounds_min_height` / `max_height` | Godot 胶囊下限与正常数据的首选高度上限 |
| `collision_bounds_max_radius` | 正常数据的首选半径上限；无法包围时允许扩大 |
| `collision_axis_switch_ratio` | 新主轴相对当前轴所需的长度优势 |
| `collision_axis_switch_stability_frames` | 主轴候选需连续稳定的物理帧；过滤单帧 T-pose |
| `collision_axis_follow_speed_degrees` | 竖直/水平轴之间的最大旋转速度 |

`CapsuleShape3D` 要求 `height >= 2 × radius`。控制器按扩大/缩小方向选择属性写入顺序，并在每帧限速内同时满足这个约束，避免 Godot 自动改写另一属性造成隐藏跳变。

包络最多以 30 Hz 采样，并使用位置/尺寸 epsilon 缓存。姿态稳定且拟合结果未变化时不会写 `CapsuleShape3D`、旋转或位移，也不会重复发送 `geometry_changed`；这避免每个 bot 在 idle 时持续触发 PhysicsServer 形状更新。

扩大、旋转或横向移动碰撞体之前，控制器用候选胶囊执行 `intersect_shape` 空间查询，并排除角色自身。查询失败时保持当前合法形状，只发送一次 `transition_blocked`。`BasePlayer` 作为组合根把该信号转发为 `StanceController.reject_collision_transition()`，姿态回滚到趴下或原站姿；碰撞组件和姿态组件仍不互相持有。

## Fallback

`set_fallback_height(float)` 是纯数值接口。模型尚未加载、hitbox 暂时不存在或自动拟合关闭时，`BasePlayer` 根据当前姿态混合写入 fallback；`prone_capsule_height`、`crouch_capsule_height` 等旧字段只服务这条降级路径，不参与正常的动态拟合。

## 测试

- `tests/hitbox_driven_collision_check.tscn`：验证医疗系统只发布 AABB、唯一碰撞所有权、八角点包围、未知 3D 包络限速、自动拟合水平胶囊，以及 steady-state 不重复写 physics shape。
- `tests/prone_exit_collision_check.tscn`：验证无 hitbox fallback 在趴下起身时平滑、脚底不漂移，并验证低天花板会拒绝扩张且姿态回滚。
- `tests/live_prone_collision_check.tscn`：运行真实趴下/起身动画，检查竖直→水平→竖直主轴、半径/高度/旋转限速、相机、角色根节点和地面接触。
