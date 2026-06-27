# PlayerAnimationController

**文件路径：** `Classes/Player/player_animation_controller.gd`  
**继承自：** `Node`

## 功能概述

根据玩家运动状态驱动 `AnimationPlayer`，内部维护一个七状态显式状态机（IDLE / WALK / RUN / JUMP / FALL / LAND / DEATH），通过监听 `PlayerMovementController` 和 `BasePlayer` 的信号触发状态转换，避免因每帧轮询导致的动画抖动。

## 初始化

### `initialize(player: CharacterBody3D, movement: PlayerMovementController, model_manager: PlayerModelManager) -> void`

- **调用时机：** 由 `BasePlayer` 在模型加载完成后调用，需保证 `PlayerModelManager.animator` 已有效。
- **参数：**
  - `player` — `CharacterBody3D` 实例，用于查询 `is_on_floor()` 和速度。
  - `movement` — `PlayerMovementController`，提供 `jumped` / `landed` / `started_running` / `stopped_running` 信号及 `is_running()` 方法。
  - `model_manager` — `PlayerModelManager`，从中取得 `animator` 引用。
- 使用 `is_connected()` 守卫防止热重载（`reload_model`）时信号重复连接。
- 初始化结束后自动过渡到 `IDLE` 状态。

## 信号（Signals）

该类无公开信号。

## 公开属性（Properties）

该类无公开属性。

## 公开方法（Methods）

该类无公开方法，所有驱动逻辑通过信号回调和 `_process()` 内部触发。

## 状态机说明

| 状态 | 对应动画常量 | 进入条件 |
|------|------------|---------|
| `IDLE` | `"idle"` | 地面静止（水平速度² ≤ 0.04） |
| `WALK` | `"walk"` | 地面移动且未奔跑 |
| `RUN` | `"run"` | 收到 `started_running` 信号且不在空中/死亡 |
| `JUMP` | `"jump"` | 收到 `jumped` 信号 |
| `FALL` | `"fall"` | 离开地面且未处于跳跃状态（被动坠落） |
| `LAND` | `"land"` | 收到 `landed` 信号，持续 0.3 秒后自动恢复 |
| `DEATH` | `"death"` | 收到 `died` 信号，不做任何自动切换 |

## 依赖关系

- **依赖：**
  - `PlayerMovementController` — 监听 `jumped` / `landed` / `started_running` / `stopped_running` 信号，调用 `is_running()`
  - `PlayerModelManager` — 获取 `AnimationPlayer` 引用
  - `BasePlayer`（`CharacterBody3D`）— 监听 `died` / `revived` 信号，查询 `is_on_floor()` 和 `velocity`
  - `GlobalLogger` — 用于调试日志输出
- **被依赖：**
  - `BasePlayer` — 持有该节点并调用 `initialize()`

## 注意事项

- 动画名称通过顶部常量（`ANIM_IDLE` 等）映射，在 `AnimationPlayer` 中创建同名动画即可自动生效；若动画不存在只会打印调试日志，不会报错崩溃。
- `LAND` 状态有 0.3 秒（`LAND_RECOVERY_TIME`）的强制保持时间，期间忽略其他地面状态转换，计时结束后调用 `_resolve_ground_state()` 恢复正确状态。
- `DEATH` 状态是终态，`_process()` 中不做任何自动切换，只能通过 `revived` 信号退出。
- 被动坠落（非跳跃离地）的检测依赖 `_was_on_floor` 与当前帧 `is_on_floor()` 的差值，在帧率极低时存在漏检风险。
- `_resolve_ground_state()` 的速度阈值为水平速度平方 `0.04`（即水平速度约 0.2 单位/秒），低于此值视为静止。
