# DebugAPI

`DebugAPI` 是进程内、与 UI 无关的运行时调试入口，供 AI、无头测试和控制台共用。它不建立网络服务，也不负责解析控制台字符串。

## 初始化

```gdscript
var api := DebugAPI.new(get_tree())
var snapshot := api.get_runtime_snapshot()
```

所有操作返回结构化字典：

```gdscript
{"ok": true, "code": "ok", "message": "", "data": {}}
```

失败时 `code` 可用于机器判断，例如 `player_not_found`、`weapon_not_found`、`invalid_time_scale` 和 `unknown_action`。

## 调用约定

- 创建方式：`var api := DebugAPI.new(get_tree())`；API 是 `RefCounted`，不需要加入场景树。
- 默认目标：省略 `target` 时使用当前场景发现的第一个 `BasePlayer`；多玩家/多 Bot 时传入明确节点。
- 返回值：始终检查 `result.get("ok", false)`；失败时根据 `result.get("code")` 分支，不解析 `message`。
- 等待方式：涉及物理、动画、输入消费时优先 `await api.await_physics_frames(n)`；只等待场景树更新时使用 `await api.await_frames(n)`。
- JSON：快照和报告只包含数字、字符串、布尔值、数组和字典；`Vector3` 会编码为 `{x, y, z}`。

## 查询接口

| 接口 | 返回内容 |
|---|---|
| `get_current_scene()` | 当前场景根节点 |
| `find_node(path)` | 按 NodePath 查找节点，找不到返回 `null` |
| `find_group_nodes(group)` | 指定 group 的节点数组 |
| `find_players()` / `get_bot_list()` | 玩家节点 / Bot 的稳定摘要列表 |
| `get_scene_tree_summary()` | 场景名、节点数、玩家数和 Bot 列表 |
| `get_player_snapshot(target)` | 位置、速度、存活、血量、医疗状态、姿态、体力、姿态快照和武器 |
| `get_posture_snapshot(target)` | 当前动画名/进度、转身状态/进度、身体 yaw、视角 yaw、趴下过渡和翻滚进度；`turn` 内含趴下转身方向、爬行标记、实际播放速率、剩余角度和阻断原因 |
| `get_weapon_snapshot(target)` | 武器名、弹匣、备弹、膛内、射击模式和枪机状态 |
| `get_runtime_snapshot()` | 场景、玩家、武器、Bot、时间倍率和树摘要 |

## 常用调用

```gdscript
var result := api.set_player_position(Vector3(0, 1, 0))
var weapon := api.get_weapon_snapshot()
api.set_ammo(10, 60, true)
api.set_player_health(75.0)
api.inject_action("move_forward", true)
api.inject_action("move_forward", false)
await api.await_physics_frames(3)
```

`get_player_snapshot()`、`get_weapon_snapshot()` 和 `get_runtime_snapshot()` 只返回可 JSON 序列化的数据。等待接口使用引擎帧/物理帧，不依赖真实帧率。

姿态回归测试应在动作注入后等待物理帧，再读取 `get_posture_snapshot()`。动画字段在模型或动画组件尚未加载时使用空字符串/零值；这表示“尚未就绪”，不是 API 崩溃。

```gdscript
var posture := api.get_posture_snapshot()
api.assert_equal(posture.get("ok", false), true, "posture_snapshot_available")
var data: Dictionary = posture.get("data", {})
api.assert_equal(data.get("is_prone_transitioning", false), false, "prone_transition_finished")
```

## 操作接口

| 类别 | 接口 |
|---|---|
| 时间 | `set_time_scale(value)`、`restore_time_scale()`、`await_frames(n)`、`await_physics_frames(n)`、`await_seconds(seconds)` |
| 输入 | `inject_action(action, pressed, strength)`、`tap_action(action)`、`inject_mouse_motion(relative)`、`inject_mouse_button(button, pressed)` |
| 玩家 | `set_player_position(position)`、`set_player_stance(value)`、`set_player_health(percent)`、`add_wound(part, severity, bleed)`、`clear_wounds()`、`revive()`、`kill()` |
| 武器 | `set_ammo(magazine, reserve, chambered, release_bolt)`、`press_trigger()`、`release_trigger()`、`reload()`、`cycle_fire_mode()`、`set_aiming(value)` |
| Bot | `set_bot_velocity(id, velocity)`、`kill_bot(id)`、`remove_bot(id)` |

玩家和武器操作在目标不存在或组件未初始化时返回失败，不抛出未处理异常。

## 结果和错误码

成功结果格式：

```json
{"ok":true,"code":"ok","message":"","data":{}}
```

常见失败码：

| code | 含义 |
|---|---|
| `player_not_found` | 当前场景没有可用玩家，或传入目标无效 |
| `weapon_not_found` | 玩家没有已装备武器 |
| `health_not_initialized` / `ammo_not_initialized` | 对应组件还没有完成初始化 |
| `invalid_health` / `invalid_ammo` / `invalid_stance` | 参数超出允许范围 |
| `invalid_time_scale` | 时间倍率不在 `0.05..4.0` |
| `unknown_action` | InputMap 中不存在指定 action |
| `bot_manager_not_found` / `bot_not_found` | Bot 管理器或 Bot ID 不存在 |

## 断言和无头测试

```gdscript
api.assert_equal(api.set_time_scale(0.5).get("ok", false), true, "time_scale")
print(JSON.stringify(api.get_assertion_report()))
```

断言结果保存在 API 实例中。报告字段 `total`、`passed`、`failed`、`results`、`duration_ms` 和 `status` 可直接交给外部 AI/脚本；`results` 中每项含 `name`、`actual` 和 `expected`。

推荐的 AI 测试循环：

```gdscript
var before := api.get_runtime_snapshot()
var changed := api.set_player_position(Vector3(2, 1, -4))
if not changed.get("ok", false):
	push_error(JSON.stringify(changed))
await api.await_physics_frames(1)
var after := api.get_player_snapshot()
api.assert_equal(after.get("ok", false), true, "snapshot_available")
```

运行专用测试：

```text
godot --headless --path . --scene res://tests/headless_debug_api_runner.tscn
```

测试输出一行 JSON，包含 `total`、`passed`、`failed`、`results`、`duration_ms` 和 `status`。通过退出码 `0`，失败退出码非零。

## 控制台映射

现有控制台继续负责字符串解析和用户可读文本，核心操作由 DebugAPI 执行。对应关系包括：`status` → `get_player_snapshot`、`timescale` → `set_time_scale`、`health` → `set_player_health`、`teleport` → `set_player_position`、`give_ammo` → `set_ammo`、`press_trigger`/`release_trigger` → 同名武器接口。

## 扩展约定

新增系统时，在 API 中增加空目标检查、结构化错误码和快照字段；不要让 API 依赖 CanvasLayer、控制台文本或 UI 生命周期。接口属于 Debug 构建能力，正式发行版应通过构建配置决定是否暴露调试入口。
