# CameraConfig

**文件路径：** `Classes/Player/camera_config.gd`  
**继承自：** `Resource`

## 功能概述

第一人称摄像机的全量配置资源。以 `.tres` 文件形式在编辑器中创建，涵盖 FOV、鼠标灵敏度、头部摆动、武器晃动、转动延迟、速度倾斜、落地冲击弹簧和呼吸摆动八个模块的参数。由 `PlayerCameraController` 在初始化时读取，通过 `PlayerConfig.camera_config` 字段引用。

## 配置参数（@export var）

### 视角控制

| 字段 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `fov` | `float` | `90.0` | 第一人称视野角度（度） |
| `mouse_sensitivity` | `float` | `0.003` | 鼠标灵敏度（弧度/像素），约为中低灵敏度 |
| `max_vertical_angle` | `float` | `1.4` | 垂直视角最大角度（弧度），≈ 80° |
| `max_speed_reference` | `float` | `3.5` | bob/tilt 振幅归一化参考速度（m/s），**必须与 `PlayerConfig.run_speed` 保持一致** |
| `walk_speed_reference` | `float` | `1.5` | bob 频率切换阈值（m/s），**必须与 `PlayerConfig.walk_speed` 保持一致** |

### 头部摆动（bob）

| 字段 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `bob_enabled` | `bool` | `true` | 是否启用头部摆动 |
| `bob_min_speed` | `float` | `0.1` | 触发摆动的最低水平速度（m/s），低于此值不产生 bob |
| `bob_run_threshold_multiplier` | `float` | `1.1` | 奔跑频率触发阈值倍率：`h_speed > walk_speed_reference × multiplier` 时切换为奔跑频率 |
| `bob_frequency_walk` | `float` | `1.8` | 走路摆动频率（Hz），应与 `PlayerConfig.gait_frequency_walk` 一致以保持视觉同步 |
| `bob_frequency_run` | `float` | `2.5` | 奔跑摆动频率（Hz），应与 `PlayerConfig.gait_frequency_run` 一致 |
| `bob_amplitude_vertical` | `float` | `0.015` | 垂直摆动幅度（m），实际幅度 = `bob_amplitude_vertical × speed_t` |
| `bob_return_speed` | `float` | `8.0` | 停止移动后摆动归零的 lerp 速度；**此参数内部无 clamp，勿设过大（> 60 × FPS_min⁻¹）否则在帧率低时可能过冲** |

### 武器晃动（sway）

| 字段 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `sway_enabled` | `bool` | `true` | 是否启用武器晃动；**关闭后 `weapon_lag_enabled` 也同时失效**（见注意事项） |
| `sway_look_amount` | `float` | `0.005` | 鼠标横向（左右）驱动的武器横滚晃动量（弧度） |
| `sway_look_amount_pitch` | `float` | `0.005` | 鼠标纵向（上下）驱动的武器俯仰晃动量（弧度） |
| `sway_move_amount` | `float` | `0.06` | 移动时武器偏移基础量（m），与缩放系数相乘得实际偏移 |
| `sway_move_scale_horizontal` | `float` | `0.01` | 横向移动偏移缩放系数；实际偏移 = `local_vel.x × sway_move_amount × scale` |
| `sway_move_scale_vertical` | `float` | `0.005` | 纵向移动偏移缩放系数；**空中时 local_vel.y 非零，会产生额外偏移，与落地冲击叠加** |
| `sway_speed` | `float` | `6.0` | 武器晃动归位的 lerp 速度 |

### 转动延迟（weapon lag）

| 字段 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `weapon_lag_enabled` | `bool` | `true` | 是否启用转动延迟；仅在 `sway_enabled = true` 时生效 |
| `weapon_lag_scale` | `float` | `0.0015` | 鼠标移动量转换为滞后角度的系数（弧度/像素/弧度-灵敏度）；会随 `mouse_sensitivity` 变化而线性缩放 |
| `weapon_lag_max` | `float` | `0.12` | 最大滞后角度（弧度），≈ 7°；**实际可见峰值低于此值**，因为同帧内会执行 lerp 归零（见注意事项） |
| `weapon_lag_return_speed` | `float` | `6.0` | 滞后复位速度（lerp speed），值越大复位越快、延迟感越弱 |

### 速度倾斜（tilt）

| 字段 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `tilt_enabled` | `bool` | `true` | 是否启用速度倾斜 |
| `tilt_max_angle` | `float` | `0.04` | 最大倾斜角度（弧度），≈ 2.3° |
| `tilt_speed` | `float` | `6.0` | 倾斜归位的 lerp 速度 |

### 落地冲击（land impact）

| 字段 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `land_impact_enabled` | `bool` | `true` | 是否启用落地冲击效果 |
| `land_impact_impulse` | `float` | `0.04` | 落地时位置弹簧初速度（m/s） |
| `land_impact_stiffness` | `float` | `180.0` | 落地位置弹簧刚度；临界阻尼 ≈ `2 × sqrt(stiffness)` ≈ 26.8 |
| `land_impact_damping` | `float` | `24.0` | 落地位置弹簧阻尼，接近临界阻尼，回弹一次即止 |
| `jump_lift_impulse` | `float` | `0.02` | 起跳时摄像机上抬初速度（m/s） |
| `land_pitch_impulse` | `float` | `0.06` | 落地时 pitch 弹簧前点冲量（弧度/s） |
| `land_pitch_stiffness` | `float` | `200.0` | pitch 弹簧刚度；临界阻尼 ≈ 28.3 |
| `land_pitch_damping` | `float` | `26.0` | pitch 弹簧阻尼，接近临界阻尼 |
| `jump_pitch_impulse` | `float` | `0.025` | 起跳时 pitch 弹簧后仰冲量（弧度/s） |
| `land_impact_velocity_scale` | `float` | `0.12` | 落地冲击按下落速度缩放系数；设为 0 则固定幅度，不随坠落高度变化 |

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

- **速度参数需与 PlayerConfig 手动同步。** `max_speed_reference`、`walk_speed_reference`、`bob_frequency_walk`、`bob_frequency_run` 应分别与 `PlayerConfig.run_speed`、`walk_speed`、`gait_frequency_walk`、`gait_frequency_run` 保持一致。两个 Resource 之间没有自动绑定，数值不同步会导致摆动频率和振幅与实际移动速度不匹配。

- **`sway_enabled = false` 会同时屏蔽 `weapon_lag_enabled`。** 两者共用同一个早返路径，关闭 sway 后 weapon lag 的积累逻辑不会执行，即使单独开启 `weapon_lag_enabled` 也无效果。

- **`weapon_lag_max` 是上限而非稳态值。** 同一帧内代码先累积再 lerp 归零，导致可见的峰值约为 `weapon_lag_max × (1 − lag_t)`，持续快速转动时稳态值低于上限。调大 `weapon_lag_max` 或调小 `weapon_lag_return_speed` 均可增强可见效果。

- **`bob_return_speed` 的 lerp t 无上界保护。** 代码为 `lerp(offset, ZERO, delta × bob_return_speed)`，delta 过大时 t > 1 会导致偏移过冲（翻转符号）。建议保持 `bob_return_speed < 50`，或在极端低帧环境下降低此值。

- **落地弹簧的临界阻尼公式：** `2 × sqrt(stiffness)`。位置弹簧临界值约 26.8，pitch 弹簧约 28.3；当前默认值均略低于临界，效果为回弹一次即止。超过临界阻尼后弹簧变为过阻尼（缓慢爬回），失去弹性手感。

- **弹簧参数在 `initialize()` 时写入，运行时修改 CameraConfig 不会自动同步。** 需手动赋值 `_land_spring.stiffness` 等属性才能热更新。
