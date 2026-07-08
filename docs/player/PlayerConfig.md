# PlayerConfig

**文件路径：** `Classes/Player/player_config.gd`
**继承自：** `Resource`

## 功能概述

玩家的全局配置资源。以 `.tres` 文件形式在编辑器中创建并填写，涵盖移动物理参数、运动手感微调、碰撞体尺寸、子配置资源引用（摄像机、模型查找规则）以及初始武器。由 `BasePlayer` 在初始化时读取并分发给各子系统。

## 配置参数（@export var）

### 移动参数

| 字段 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `walk_speed` | `float` | `1.5` | 行走速度（m/s），参考负重士兵战术行走 1.2–1.5 m/s |
| `run_speed` | `float` | `3.5` | 奔跑速度（m/s），参考负重士兵持续跑步 3.5–4.0 m/s |
| `ground_acceleration` | `float` | `6.0` | 地面加速度（m/s²），起步约需 0.6s 到达步行速度 |
| `jump_force` | `float` | `3.2` | 跳跃初速度（m/s） |
| `gravity` | `float` | `9.8` | 重力加速度（m/s²） |
| `air_acceleration` | `float` | `1.0` | 空中加速度（m/s²） |
| `air_deceleration` | `float` | `2.0` | 空中减速度（m/s²） |
| `input_dead_zone` | `float` | `0.1` | 输入死区阈值，低于此长度的方向向量视为无输入（适用于摇杆/键盘） |
| `floor_snap_velocity` | `float` | `-0.5` | 落地时 Y 速度钳制值，防止下坡累积下冲速度；不宜设为 0（会导致台阶弹跳）或过大负值（会穿地） |
| `backward_dot_threshold` | `float` | `-0.3` | 后退判定 dot product 阈值，低于此值视为向后移动，乘以 `backward_speed_ratio` 限速 |
| `lateral_dot_threshold` | `float` | `0.7` | 横移判定 dot product 阈值，高于此值视为纯侧移，乘以 `lateral_speed_ratio` 限速 |
| `turn_decel_min_speed` | `float` | `0.01` | 启用转向减速的最低速度（m/s）；**注意**：代码中比较的是 `length_squared() > value²`，因此此字段的语义是速度（m/s），不是 length_squared |
| `air_input_threshold` | `float` | `0.1` | 空中加速/减速切换的目标速度阈值（m/s）；低于此值使用 `air_deceleration`，高于则用 `air_acceleration` |

### 运动手感

| 字段 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `burst_strength` | `float` | `1.2` | 起步爆发峰值速度倍率 |
| `burst_duration` | `float` | `0.12` | 起步爆发持续时间（秒） |
| `gait_frequency_walk` | `float` | `1.8` | 走路步频（Hz），约 108 步/分 |
| `gait_frequency_run` | `float` | `2.5` | 跑步步频（Hz），约 150 步/分 |
| `gait_amplitude_walk` | `float` | `0.06` | 走路速度波动振幅（m/s） |
| `gait_amplitude_run` | `float` | `0.12` | 跑步速度波动振幅（m/s） |
| `turn_decel_factor` | `float` | `0.85` | 转向减速强度，0.0 = 不减速，1.0 = 完全余弦削减 |
| `stop_brake_strength` | `float` | `5.0` | 停止制动强度（m/s²），避免瞬间急停 |
| `lateral_speed_ratio` | `float` | `0.8` | 横向（纯侧移）速度上限比例 |
| `backward_speed_ratio` | `float` | `0.7` | 后退速度上限比例 |

### 模型配置

| 字段 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `model_scene` | `PackedScene` | `null` | 玩家 3D 模型场景（.tscn / .glb） |
| `model_config` | `ModelLookupConfig` | `null` | 节点查找规则资源 |
| `camera_config` | `CameraConfig` | `null` | 摄像机与视角效果配置资源 |
| `collision_shape_height` | `float` | `1.8` | 碰撞胶囊体高度（m） |
| `collision_shape_radius` | `float` | `0.4` | 碰撞胶囊体半径（m） |

### 武器配置

| 字段 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `starting_weapon` | `WeaponConfig` | `null` | 初始武器配置资源 |

## 依赖关系

- **依赖：** `ModelLookupConfig`、`CameraConfig`、`WeaponConfig`
- **被依赖：** `BasePlayer`、`PlayerMovementController`、`PlayerCameraController`、`FootIKController`

## 注意事项

- `walk_speed` 和 `run_speed` 的值需与 `CameraConfig.walk_speed_reference` / `max_speed_reference` 保持一致，否则头部摆动的频率切换和振幅归一化会出现偏差。
- `model_scene` 为空时 `BasePlayer._ready()` 不会调用 `load_model()`，所有依赖模型加载完成后才初始化的子系统（布娃娃、动画控制器、武器挂载）将不可用。
- `turn_decel_min_speed` 是速度单位（m/s），代码中比较 `h_vel_2d.length_squared() > turn_decel_min_speed²`，因此将此值设为 `0.1` 表示 0.1 m/s 阈值，而不是 `0.01`（0.01 的平方 = 0.0001，等效于 0.01 m/s，几乎任何移动都会触发转向减速）。
- `floor_snap_velocity` 不应设为正值或 0；它的唯一作用是防止 `move_and_slide` 在楼梯/斜坡上因连续落地帧而累积向下速度。
