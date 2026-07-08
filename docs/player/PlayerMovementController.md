# PlayerMovementController

**文件路径：** `Classes/Player/player_movement_controller.gd`
**继承自：** `Node`

## 功能概述

处理玩家（`CharacterBody3D`）的全部移动逻辑。在 `_physics_process` 中每帧运行，实现地面移动、空中漂移、跳跃与重力。相较于基础移动系统，新增了起步爆发、步态波动、基于 dot product 的转向减速、停止卸力以及横向/后退方向速度上限五项机制。由 `BasePlayer._initialize_subsystems()` 创建并初始化。

## 初始化

### `initialize(player: CharacterBody3D, config: PlayerConfig) -> void`

传入玩家根节点和配置资源。将内部速度向量 `_velocity` 清零，存储两个引用供后续每帧使用。必须在节点进入场景树后、首个 `_physics_process` 执行前调用。

## 信号（Signals）

| 信号 | 参数 | 触发时机 |
|------|------|---------|
| `jumped` | 无 | 玩家按下跳跃键且在地面时 |
| `landed` | 无 | `is_on_floor()` 出现上升沿（从空中落回地面的第一帧） |
| `started_running` | 无 | 从非奔跑状态进入奔跑状态时 |
| `stopped_running` | 无 | 松开 sprint 或 move_forward 时 |

## 公开属性（Properties）

| 属性 | 类型 | 说明 |
|------|------|------|
| （无公开导出属性） | — | 全部状态均为私有变量 |

## 公开方法（Methods）

### `initialize(player: CharacterBody3D, config: PlayerConfig) -> void`

见"初始化"章节。

### `is_running() -> bool`

返回当前是否处于奔跑状态，供外部系统（如摄像机控制器、动画控制器）查询。

## 内部逻辑说明

每帧 `_physics_process` 按以下顺序执行：

1. **读取输入方向** — 从 `move_left/right/forward/backward` 四轴合成二维输入向量
2. **Sprint 信号检测** — 在地面/空中均有效，松开 sprint 立即发出 `stopped_running`
3. **地面水平速度**
   - 根据 sprint 状态选择 `walk_speed` 或 `run_speed` 作为基础速度
   - 横向移动乘以 `lateral_speed_ratio`，后退乘以 `backward_speed_ratio`
   - 通过 dot product 计算速度方向与输入方向夹角，进行转向减速
   - 起步边沿触发爆发计时器，短暂提升速度倍率
   - 使用 `move_toward` 向目标速度加速
   - 在速度方向叠加 sin 波动（步态波动），模拟重心摆动
   - 无输入时以 `stop_brake_strength` 快速制动并重置步态相位
4. **空中水平速度** — 使用 `air_acceleration` / `air_deceleration` 进行有限空中控制
5. **跳跃** — `jump` 动作刚按下且在地面时，设置 `_velocity.y` 并发出 `jumped`
6. **重力** — 不在地面时每帧累减 `gravity * delta`；落地后将 `_velocity.y` 钳制到 `PlayerConfig.floor_snap_velocity`（默认 `-0.5`），防止下坡时向下速度持续累积
7. **应用移动** — 写入 `_player.velocity` 并调用 `move_and_slide()`，再将碰撞后实际速度同步回 `_velocity`
8. **落地检测** — 检测 `is_on_floor()` 上升沿并发出 `landed`

## 依赖关系

- **依赖：** `PlayerConfig`（读取全部速度/物理参数）、`CharacterBody3D`（调用 `move_and_slide()`）、Godot 内置 `Input` 单例
- **被依赖：** `BasePlayer`（创建并持有引用）、`PlayerCameraController`（监听 `jumped`/`landed` 信号用于落地冲击效果）、`PlayerAnimationController`（查询 `is_running()`）

## 注意事项

- 步态波动直接修改速度向量，会影响 `PlayerCameraController` 读取的速度值，进而轻微影响头部摆动振幅计算。
- 转向减速公式使用世界空间 XZ 平面的二维 dot product，急转弯（≈90°）约损失 35–50% 速度，取决于 `turn_decel_factor` 的值。
- `_velocity` 在每帧末从 `_player.velocity` 同步回来，确保碰撞响应（如撞墙停速）被正确反映到下一帧的计算中。
