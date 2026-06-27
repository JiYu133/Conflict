# CameraConfig

**文件路径：** `Classes/Player/camera_config.gd`
**继承自：** `Resource`

## 功能概述

第一人称摄像机的全量配置资源。以 `.tres` 文件形式在编辑器中创建，涵盖 FOV、鼠标灵敏度、头部摆动、武器晃动、速度倾斜、落地冲击弹簧和呼吸摆动七个模块的参数。由 `PlayerCameraController` 在初始化时读取，通过 `PlayerConfig.camera_config` 字段引用。

## 配置参数（@export var）

### 视角控制

| 字段 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `fov` | `float` | `90.0` | 第一人称视野角度（度） |
| `mouse_sensitivity` | `float` | `0.003` | 鼠标灵敏度（弧度/像素），约为中低灵敏度 |
| `max_vertical_angle` | `float` | `1.4` | 垂直视角最大角度（弧度），≈ 80° |
| `max_speed_reference` | `float` | `3.5` | bob/tilt 振幅归一化参考速度（m/s），应与 `PlayerConfig.run_speed` 一致 |
| `walk_speed_reference` | `float` | `1.5` | bob 频率切换的步行速度阈值（m/s），应与 `PlayerConfig.walk_speed` 一致 |

### 头部摆动（bob）

| 字段 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `bob_enabled` | `bool` | `true` | 是否启用头部摆动 |
| `bob_frequency_walk` | `float` | `1.8` | 走路摆动频率（Hz） |
| `bob_frequency_run` | `float` | `2.5` | 奔跑摆动频率（Hz） |
| `bob_amplitude_vertical` | `float` | `0.015` | 垂直摆动幅度（m） |
| `bob_amplitude_horizontal` | `float` | `0.008` | 水平摆动幅度（m），约为垂直幅度的一半，产生 figure-8 轨迹 |
| `bob_return_speed` | `float` | `8.0` | 停止移动后摆动归零的插值速度 |

### 武器晃动（sway）

| 字段 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `sway_enabled` | `bool` | `true` | 是否启用武器晃动 |
| `sway_look_amount` | `float` | `0.015` | 鼠标转动时武器偏移量（弧度） |
| `sway_move_amount` | `float` | `0.06` | 移动时武器偏移量（m），模拟持枪重量感 |
| `sway_speed` | `float` | `6.0` | 武器归位插值速度 |

### 速度倾斜（tilt）

| 字段 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `tilt_enabled` | `bool` | `true` | 是否启用速度倾斜 |
| `tilt_max_angle` | `float` | `0.04` | 最大倾斜角度（弧度），≈ 2.3° |
| `tilt_speed` | `float` | `6.0` | 倾斜归位的插值速度 |

### 落地冲击（land impact）

| 字段 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `land_impact_enabled` | `bool` | `true` | 是否启用落地冲击效果 |
| `land_impact_impulse` | `float` | `0.04` | 落地时位置弹簧初速度（m/s） |
| `land_impact_stiffness` | `float` | `180.0` | 落地位置弹簧刚度 |
| `land_impact_damping` | `float` | `24.0` | 落地位置弹簧阻尼，接近临界阻尼（≈26.8），回弹一次即止 |
| `jump_lift_impulse` | `float` | `0.02` | 起跳时摄像机上抬初速度（m/s） |
| `land_pitch_impulse` | `float` | `0.06` | 落地时 pitch 弹簧前点冲量（弧度/s） |
| `land_pitch_stiffness` | `float` | `200.0` | pitch 弹簧刚度 |
| `land_pitch_damping` | `float` | `26.0` | pitch 弹簧阻尼，接近临界阻尼（≈28.3） |
| `jump_pitch_impulse` | `float` | `0.025` | 起跳时 pitch 弹簧后仰冲量（弧度/s） |
| `land_impact_velocity_scale` | `float` | `0.12` | 落地冲击按下落速度缩放的系数，设为 0 则固定幅度 |

### 呼吸晃动（breathe）

| 字段 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `breathe_enabled` | `bool` | `false` | 是否启用呼吸效果，默认关闭 |
| `breathe_frequency` | `float` | `0.3` | 呼吸频率（Hz），约 18 次/分钟 |
| `breathe_amplitude_vertical` | `float` | `0.004` | 呼吸垂直振幅（m） |
| `breathe_amplitude_horizontal` | `float` | `0.0015` | 呼吸水平漂移振幅（m） |
| `breathe_max_speed` | `float` | `0.5` | 超过此速度（m/s）时呼吸效果完全淡出 |

## 依赖关系

- **依赖：** 无（纯数据资源）
- **被依赖：** `PlayerConfig`（通过 `camera_config` 字段引用）、`PlayerCameraController`（初始化时读取）

## 注意事项

- `max_speed_reference` 和 `walk_speed_reference` 需与 `PlayerConfig` 中对应的速度值手动保持同步，两份资源之间没有自动绑定机制。
- 落地弹簧的临界阻尼公式为 `2 * sqrt(stiffness)`：位置弹簧临界值约 26.8，pitch 弹簧约 28.3；当前默认值均略低于临界，效果为回弹一次即止。
- `breathe_enabled` 默认为 `false`，开启后仅在低速或静止时有效，超过 `breathe_max_speed` 后平滑淡出。
