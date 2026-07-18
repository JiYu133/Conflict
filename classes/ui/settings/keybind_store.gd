class_name KeybindStore
extends RefCounted

# ============================================================
# 键位存储（纯静态，无 Autoload）
# 功能：定义可重绑定的输入动作清单，负责在 InputMap 与用户配置
#       文件（user://keybinds.cfg）之间读写键位覆盖。
# 用法：SettingsMenu._ready() 调用 apply_saved() 于启动时套用；
#       重绑定后调用 save_action()/save_all() 持久化；
#       reset_action()/reset_all() 从 ProjectSettings 默认值恢复。
# 设计：遵循 §6.2「减少 Autoload」——不新增全局单例，键位在
#       游戏场景内的 SettingsMenu 首次就绪时套用一次（_applied 守卫）。
# ============================================================

const SAVE_PATH := "user://keybinds.cfg"
const CONFIG_SECTION := "keybinds"

## 可重绑定动作清单：{ action, display（中文·英文）, category, debug_only? }
## 顺序即 UI 显示顺序；category 用于分组标题；
## debug_only 为 true 的条目仅在 debug 构建的设置菜单中显示。
## 每个动作单键绑定（重绑定覆盖旧键）。姿态微调默认绑定滚轮，可改绑单个按键。
const ACTIONS: Array[Dictionary] = [
	{ "action": "move_forward",  "display": "前进 Forward",     "category": "移动 MOVEMENT" },
	{ "action": "move_backward", "display": "后退 Backward",    "category": "移动 MOVEMENT" },
	{ "action": "move_left",     "display": "左移 Strafe Left", "category": "移动 MOVEMENT" },
	{ "action": "move_right",    "display": "右移 Strafe Right","category": "移动 MOVEMENT" },
	{ "action": "jump",          "display": "跳跃 Jump",        "category": "移动 MOVEMENT" },
	{ "action": "sprint",        "display": "奔跑 Sprint",      "category": "移动 MOVEMENT" },
	{ "action": "crouch",        "display": "蹲姿 Crouch",      "category": "移动 MOVEMENT" },
	{ "action": "stance_raise",  "display": "姿态升高 Stance Up",   "category": "姿态微调 STANCE" },
	{ "action": "stance_lower",  "display": "姿态降低 Stance Down", "category": "姿态微调 STANCE" },
	{ "action": "fire",          "display": "开火 Fire",        "category": "战斗 COMBAT" },
	{ "action": "aim",           "display": "瞄准 Aim",         "category": "战斗 COMBAT" },
	{ "action": "reload",        "display": "换弹 Reload",      "category": "战斗 COMBAT" },
	{ "action": "toggle_free_cam", "display": "DEBUG: 进入自由视角 Enter Free Cam", "category": "调试 DEBUG", "debug_only": true },
]

static var _applied: bool = false


## 启动时套用一次已保存的键位覆盖（幂等）。
static func apply_saved() -> void:
	if _applied:
		return
	_applied = true
	var cfg := ConfigFile.new()
	if cfg.load(SAVE_PATH) != OK:
		return  # 无存档 → 保留 project.godot 默认键位
	for entry in ACTIONS:
		var action: String = entry["action"]
		if not InputMap.has_action(action):
			continue
		var encoded = cfg.get_value(CONFIG_SECTION, action, null)
		if encoded == null:
			continue
		var events := _decode_events(encoded)
		if events.is_empty():
			continue
		InputMap.action_erase_events(action)
		for ev in events:
			InputMap.action_add_event(action, ev)


## 把某动作当前的 InputMap 事件写入存档。
static func save_action(action: String) -> void:
	var cfg := ConfigFile.new()
	cfg.load(SAVE_PATH)  # 忽略失败：不存在则新建
	cfg.set_value(CONFIG_SECTION, action, _encode_events(InputMap.action_get_events(action)))
	cfg.save(SAVE_PATH)


## 全量保存所有可重绑定动作。
static func save_all() -> void:
	var cfg := ConfigFile.new()
	cfg.load(SAVE_PATH)
	for entry in ACTIONS:
		var action: String = entry["action"]
		if InputMap.has_action(action):
			cfg.set_value(CONFIG_SECTION, action, _encode_events(InputMap.action_get_events(action)))
	cfg.save(SAVE_PATH)


## 把某动作恢复为 project.godot 默认键位（从 ProjectSettings 读取，
## 不受运行时 InputMap 改动影响），并从存档中移除覆盖。
static func reset_action(action: String) -> void:
	var default_events := _project_default_events(action)
	InputMap.action_erase_events(action)
	for ev in default_events:
		InputMap.action_add_event(action, ev)
	var cfg := ConfigFile.new()
	cfg.load(SAVE_PATH)
	if cfg.has_section_key(CONFIG_SECTION, action):
		cfg.erase_section_key(CONFIG_SECTION, action)
		cfg.save(SAVE_PATH)


## 恢复全部动作为默认键位并清空存档。
static func reset_all() -> void:
	for entry in ACTIONS:
		var action: String = entry["action"]
		if not InputMap.has_action(action):
			continue
		var default_events := _project_default_events(action)
		InputMap.action_erase_events(action)
		for ev in default_events:
			InputMap.action_add_event(action, ev)
	DirAccess.remove_absolute(SAVE_PATH)


## 把动作重绑定到单个新事件（覆盖式，替换全部现有事件）。
static func rebind_action(action: String, event: InputEvent) -> void:
	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, event)
	save_action(action)


## 返回动作当前主要绑定的可读文本（用于键帽显示）。
static func describe_action(action: String) -> String:
	if not InputMap.has_action(action):
		return "—"
	for ev in InputMap.action_get_events(action):
		var label := describe_event(ev)
		if label != "":
			return label
	return "未绑定"


## 返回单个事件的简短可读标签。
static func describe_event(event: InputEvent) -> String:
	if event is InputEventKey:
		var kc: int = (event as InputEventKey).physical_keycode
		if kc == 0:
			kc = (event as InputEventKey).keycode
		return OS.get_keycode_string(kc)
	if event is InputEventMouseButton:
		match (event as InputEventMouseButton).button_index:
			MOUSE_BUTTON_LEFT:   return "鼠标左键 LMB"
			MOUSE_BUTTON_RIGHT:  return "鼠标右键 RMB"
			MOUSE_BUTTON_MIDDLE: return "鼠标中键 MMB"
			MOUSE_BUTTON_WHEEL_UP:   return "滚轮上"
			MOUSE_BUTTON_WHEEL_DOWN: return "滚轮下"
			_: return "鼠标键 %d" % (event as InputEventMouseButton).button_index
	return ""


## 返回与指定动作共用任一按键的其它动作列表（用于冲突检测；比较全部槽）。
static func find_conflicts(action: String) -> Array[String]:
	var result: Array[String] = []
	var sigs := _action_signatures(action)
	if sigs.is_empty():
		return result
	for entry in ACTIONS:
		var other: String = entry["action"]
		if other == action:
			continue
		for s in _action_signatures(other):
			if s in sigs:
				result.append(other)
				break
	return result


# 私有 ──────────────────────────────────────────────────────

## 动作全部绑定事件的签名集合（用于比较是否有同键重叠）。
static func _action_signatures(action: String) -> Array:
	var out: Array = []
	if not InputMap.has_action(action):
		return out
	for ev in InputMap.action_get_events(action):
		var enc := _encode_event(ev)
		if not enc.is_empty():
			out.append("%s:%d" % [enc["t"], enc["code"]])
	return out


static func _project_default_events(action: String) -> Array:
	var setting := "input/" + action
	if not ProjectSettings.has_setting(setting):
		return []
	var data = ProjectSettings.get_setting(setting)
	if data is Dictionary and data.has("events"):
		return (data["events"] as Array).duplicate()
	return []


## 事件 → 可序列化字典。仅支持键盘/鼠标键。
static func _encode_event(event: InputEvent) -> Dictionary:
	if event is InputEventKey:
		var k := event as InputEventKey
		return { "t": "key", "code": k.physical_keycode if k.physical_keycode != 0 else k.keycode }
	if event is InputEventMouseButton:
		return { "t": "mouse", "code": (event as InputEventMouseButton).button_index }
	return {}


static func _decode_event(data: Dictionary) -> InputEvent:
	match data.get("t", ""):
		"key":
			var k := InputEventKey.new()
			k.physical_keycode = int(data.get("code", 0))
			return k
		"mouse":
			var m := InputEventMouseButton.new()
			m.button_index = int(data.get("code", 0))
			return m
	return null


static func _encode_events(events: Array) -> Array:
	var out: Array = []
	for ev in events:
		var enc := _encode_event(ev)
		if not enc.is_empty():
			out.append(enc)
	return out


static func _decode_events(encoded) -> Array:
	var out: Array = []
	if encoded is Array:
		for data in encoded:
			if data is Dictionary:
				var ev := _decode_event(data)
				if ev:
					out.append(ev)
	return out
