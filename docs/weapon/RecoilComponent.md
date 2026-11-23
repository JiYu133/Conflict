# RecoilComponent

**文件路径：** `classes/weapon/recoil_component.gd`

**继承自：** `Node`

RecoilPhysicsModel 计算同一发的线性/角冲量与俯仰/偏航角速度。组件保留自身阻尼角度状态；骨骼受力和镜头弹簧各自消费 physical_recoil_applied 信号。

| 方法 | 行为 |
|---|---|
| `initialize(cfg, am = null)` | 创建模型并重建武器/配件物理数据 |
| `rebuild_physics()` | 配件变化后重算模型，重置本组件角度/速度 |
| `apply_recoil(control_multiplier = 1.0)` | 累加单发角速度，发物理冲量数据 |
| `set_control_multiplier(value)` | 调整本组件后续回正刚度/阻尼倍率 |
| `reset()` | 清零本组件角度/速度 |
| `get_recoil_offset()` / `get_recoil_horizontal_offset()` | 返回本组件 pitch/yaw 偏移，单位为度 |
| `get_physics_snapshot()` | 模型快照，供 UI/调试读取 |

不存在 get_camera_pitch_offset()/get_camera_yaw_offset()。PlayerCameraController 监听射击信号后运行独立视觉弹簧，不按帧读取上述角度 getter。

信号数据为 linear_impulse_local（N·s）、angular_impulse_local（N·m·s）、angular_velocity（Vector2，rad/s）。BaseWeapon 交给 BasePlayer.apply_weapon_recoil()，由 [ForceSystem](../player/ForceSystem.md) 分配到有效肩/手骨骼；相机独立订阅同一发结果。

BaseWeapon._apply_attachment_change() 触发重建；数据来自 BarrelConfig、StockConfig、GripConfig、MuzzleDeviceConfig 和 WeaponConfig。旧 recoil_vertical/kick_* 仅为兼容数据。当前模型 receiver COM 分子仍缺少质量权重，该 P3 数据问题尚未在本轮文档工作中修复。
