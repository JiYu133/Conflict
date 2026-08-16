# PlayerCollisionController

**文件：** `classes/player/player_collision_controller.gd`

## 职责

`PlayerCollisionController` 是 `BasePlayer` 主环境碰撞胶囊的唯一所有者。它负责创建 `PlayerCollisionShape`、根据角色当前体积调整上下边界，以及同步姿态造成的模型 Y 偏移。

`PlayerModelManager` 只加载模型，`PlayerMovementController` 只处理位移；两者都不得创建、替换或修改主胶囊。

## 自动尺寸

```text
HealthSystem.get_active_hitboxes()（注入 Callable）
                 ↓
BodyHitbox.get_vertical_bounds(BasePlayer)
                 ↓
当前全部 hitbox 的最低/最高 Y
                 ↓
通用安全余量 + 逐帧速度限制
                 ↓
PlayerCollisionShape
```

H 键显示的 `BodyHitbox` 会跟随骨骼和动画，因此新增趴下、翻滚或其他动作时无需新增对应的胶囊高度配置。医疗系统仍独占 hitbox 的创建/销毁生命周期；碰撞控制器只通过只读 Callable 和几何接口取样，不持有 `HealthSystem` 类型。

医疗 hitbox 不覆盖脚底，所以主胶囊底边固定在站立配置的地面接触面；最高/最低 hitbox 用于计算当前所需高度。若某动作的 hitbox 低于该接触面，超出的体积会保守地加到胶囊上方，避免把 `CharacterBody3D` 推入地面。

## 通用配置

这些参数位于 `MovementConfig`，对所有动作生效，而不是逐动画配置：

| 字段 | 作用 |
|---|---|
| `hitbox_driven_collision` | 是否启用实时 hitbox 取样；关闭或无 hitbox 时使用姿态 fallback |
| `collision_bounds_margin` | 最高边界外的安全余量 |
| `collision_bounds_follow_speed` | 胶囊上下边界每秒最大变化，防止一帧突变 |
| `collision_bounds_min_height` / `max_height` | Godot 胶囊合法范围和异常姿态保护 |

`prone_capsule_height`、`crouch_capsule_height` 等旧字段只用于模型尚未加载、死亡时 hitbox 被销毁或显式关闭自动尺寸时的 fallback。

## 测试

- `tests/hitbox_driven_collision_check.tscn`：验证唯一所有权、实际 hitbox 包围和未知动作下的限速追随。
- `tests/prone_exit_collision_check.tscn`：验证 fallback 路径在趴下起身时不突变、不改变胶囊底边。
- `tests/live_prone_collision_check.tscn`：运行真实趴下/起身动画，检查胶囊、角色根节点和相机逐帧轨迹。
