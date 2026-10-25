# CameraConfig

**文件路径：** `classes/player/config/camera_config.gd`

**继承自：** `Resource`

由 PlayerConfig.camera_config 引用，当前只包含 FOV/鼠标限幅、头部位置弹簧、视觉后坐弹簧与偏移。旧 bob、breathing、weapon lag、tilt、land-impact 字段已移除。下表为脚本默认值，实际 .tres 可覆盖。

| 字段 | 类型 | 脚本默认值 |
|---|---|---|
| `fov` | `float` | `90.0` |
| `near_plane` | `float` | `0.01` |
| `mouse_sensitivity` | `float` | `0.003` |
| `max_vertical_angle` | `float` | `1.4` |
| `recoil_pitch_stiffness` | `float` | `180.0` |
| `recoil_pitch_damping` | `float` | `24.0` |
| `recoil_yaw_stiffness` | `float` | `220.0` |
| `recoil_yaw_damping` | `float` | `28.0` |
| `recoil_max_pitch_rad` | `float` | `0.18` |
| `recoil_max_yaw_rad` | `float` | `0.10` |
| `recoil_ads_stiffness_multiplier` | `float` | `2.0` |
| `spring_stiffness_h` | `float` | `500.0` |
| `spring_damping_h` | `float` | `40.0` |
| `spring_stiffness_v` | `float` | `120.0` |
| `spring_damping_v` | `float` | `20.0` |
| `ads_stiffness_multiplier` | `float` | `2.0` |
| `head_offset` | `Vector3` | `Vector3(0.07, 0.1, -0.15)` |
| `ragdoll_eye_offset` | `Vector3` | `Vector3(0.0, 0.06, 0.08)` |


头部过滤使用 spring_stiffness_h/v、spring_damping_h/v、head_offset。recoil_* 控制独立视觉后坐，recoil_ads_stiffness_multiplier 为旧资源兼容字段，不参与 ADS 回正；ads_stiffness_multiplier 与 ragdoll_eye_offset 仍导出但未被当前控制器读取。

参见 [PlayerCameraController](PlayerCameraController.md) 和 [WeaponPresentationController](WeaponPresentationController.md)。
