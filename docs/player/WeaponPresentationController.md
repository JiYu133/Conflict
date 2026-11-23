# WeaponPresentationController

**文件路径：** `classes/player/controller/weapon_presentation_controller.gd`

武器姿态跟随动画右手 WeaponMount，再向眼部 ADS 锚点插值，并叠加呼吸、移动、视角惯性与遮挡收枪。武器实际枪口随姿态移动，仍是发射原点与方向的权威来源。

## 接入

| 方法 | 行为 |
|---|---|
| `initialize(state_provider: Callable)` | 注入玩家当前状态；关闭自主 process，由组合根/IK 调用更新 |
| `setup_weapon_rig(weapon_mount, pose_parent)` | 创建 top_level WeaponPoseRoot 和子 WeaponSwayPivot，返回支点 |
| `bind_weapon(weapon)` | 绑定武器及 WeaponConfig.presentation_config，清理惯性/遮挡状态 |
| `ensure_pose_current(delta = 0.0)` | 每渲染帧最多更新一次，供组合根及 IKRig 手臂阶段调用 |
| `set_obstruction_target(value)` | 设置 0–1 遮挡目标；权重、阈值和探测半径有独立 getter |
| `get_pose_root()/get_pose_source()/get_sway_pivot()` | 查询展示载体、动画源挂点和武器支点 |

载体独立于求解后的手骨，避免「手 → 武器 → 手」反馈。动画源挂点在求解前刷新。ADS 锚点存在时将武器对齐到 view；没有锚点时使用完整 ads_center_offset（含 Z），不再只写 X/Y。

state_provider 返回 active、view（Transform3D）、ads_blend、stability、local_velocity，可选 ads_breath_pose。BasePlayer 组合当前相机、体力及 AimBreathingController 状态；缺省值见源码。WeaponPresentationConfig 管理腰射/ADS 呼吸、移动、惯性以及遮挡阈值；角度字段注明 degrees，变换内部为弧度。

默认 BasePlayer 已创建 WeaponObstructionDetector 并连接 obstruction_changed → set_obstruction_target；开火按平滑权重与阈值进行门控。测试为 ads_system_runner、aim_breathing_runner、player_components_runner，见 [Testing](../Testing.md)。
