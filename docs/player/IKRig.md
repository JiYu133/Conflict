# IKRig（玩家 IK：双臂握枪 + 双脚贴地）

**文件：** `classes/player/ik/`

| 文件 | 内容 |
|------|------|
| `ik_rig.gd` | `IKRig`：唯一的 IK 子系统，持有两个 modifier，维护执行顺序与权重 |
| `arm_ik.gd` | `ArmIK`：单条手臂（手腕目标 → 肘部 → 求解 → 手腕朝向 → 握枪手指） |
| `leg_ik.gd` | `LegIK`：单条腿（地面检测 → 贴地目标 → 求解 → 脚踝倾斜） |
| `two_bone_ik.gd` | `TwoBoneIK`：两骨解析求解与骨骼旋转工具（纯数学，可单测） |
| `ik_rig_config.gd` | `IKRigConfig`：骨骼链、权重、可达范围、握枪手指参考动画、脚部参数 |

**回归测试：** `tests/ik_rig_check.tscn`

## 执行顺序

骨骼上只有两个 IK modifier，由 `IKRig` 排序（新 modifier 加入骨骼时自动重排）：

```
SpineAimModifier → ForceBodyModifier → IKLegs → IKArms → PhysicalBoneSimulator3D
```

- 腿在手臂之前：骨盆下沉会平移整个上半身，手臂必须在最终躯干上求解。
- 场景里不需要任何 `TwoBoneIK3D`、目标或 pole 节点；骨骼链来自 `IKRigConfig`。
- 其它代码不要对这些 modifier 调用 `move_child`。

## 双臂

每只手的目标都是**手腕骨骼的世界变换**（位置 + 朝向）。每帧手臂阶段：

1. 刷新武器姿态（`PlayerCameraController.refresh_weapon_pose()`）
2. 右手（扳机手）：武器挂点 `WeaponMount` 在动画右手上，腰射时武器载体与挂点重合。
   保持「右手 ↔ 挂点」的相对关系；ADS、后坐、晃动移动武器载体时右手随之移动。
3. 左手（扶枪手）：武器上的 **`LeftHandWristTarget`** 就是左手腕的位置与朝向。
   超出手臂长度 96% 时沿枪管向枪托滑动，最多 12 cm。
4. 两骨求解：肘部朝向动画手臂当前的弯曲方向（保留动画特征，跟随瞄准、蹲伏、趴下）。
5. 手腕转到目标朝向，手指套用握枪姿态（`grip_pose_animation` 第 0 帧）。

权重：持枪时为 1（手始终在枪上）；冲刺为 `sprint_arm_weight`；死亡 / 布娃娃立即为 0。
左手再乘以 `WeaponConfig.left_hand_ik_weight`。

### 调整左手

只需要移动 / 旋转护木或武器场景里的 `LeftHandWristTarget`：它的变换就是左手腕。
`IKRig.capture_support_hand_marker()` 返回当前手腕在该 Marker 父节点空间中的变换，
可用来把一个满意的动画姿态直接写回 Marker。

## 双脚

1. 物理帧：从动画脚踝和角色中心向下检测地面。
2. 目标 = 动画脚踝 + 竖直方向的「脚下地面 − 身体下地面」：平地上与动画一致，台阶 / 斜坡上随地面变化。
3. 比支撑脚高出 3.5–12 cm 的脚逐渐释放；整体蹲低不算抬脚。
4. 着地脚超出腿长 99% 时骨盆下沉（快沉慢起，最多 20 cm）；平地上骨盆不动，镜头不额外晃动。
5. 两骨求解（膝盖朝向动画弯曲方向），脚踝按地面法线倾斜（最多 25°）。

趴下时双脚逐渐释放；死亡 / 布娃娃时立即释放。

## 接入（BasePlayer）

| 时机 | 调用 |
|------|------|
| `_ready` | `ik_rig.initialize(self, model_manager, player_config.ik_config, camera_controller)` |
| 模型加载后 | `ik_rig.bind_skeleton(model_manager.skeleton)` |
| 换武器 | `ik_rig.set_weapon(weapon, weapon.config.left_hand_ik_weight)` |
| 每帧 | `ik_rig.update(delta, 存活且非布娃娃, 趴下, 冲刺)` |

## 已知的内容限制

- 腰射时武器跟随动画右手。`walk_fwd` 等行走片段部分周期会把武器带到左臂够不到的位置，
  滑动后仍够不到时手臂伸直指向手腕目标；测试里计为 `unreachable`，不算求解错误。
- `ak_74m.tscn` 的 `LeftHandWristTarget` 仍是旧值（与 `LeftHandGrip` 相同），使用前需按上面的方法重新标定。
