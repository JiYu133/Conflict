extends RefCounted

const SettingsText = preload("res://classes/ui/settings/settings_text.gd")

# ============================================================
# 键位存储（纯静态，无 Autoload）
# 功能：定义可重绑定的输入动作清单，负责在 InputMap 与用户配置
#       文件（user://keybinds.cfg）之间读写键位覆盖。
# 用法：SettingsService.initialize() 调用 apply_saved() 于启动时套用；
#       设置页在应用时调用 save_all() 持久化；
#       reset_action()/reset_all() 从 ProjectSettings 默认值恢复。
# 设计：由 BasePlayer 拥有的 SettingsService 启动；KeybindStore 保持静态数据工具。
# ============================================================

const SAVE_PATH := "user://keybinds.cfg"
const CONFIG_SECTION := "keybinds"

## 可重绑定动作清单：{ action, display（中文·英文）, category, debug_only? }
## 顺序即 UI 显示顺序；category 用于分组标题；
## debug_only 为 true 的条目仅在 debug 构建的设置菜单中显示。
## 每个动作最多两个绑定槽。姿态微调默认绑定滚轮，可改绑键盘或鼠标键。
const ACTIONS: Array[Dictionary] = [
	{ "action": "move_forward", "display": SettingsText.ACTION_MOVE_FORWARD, "category": SettingsText.CATEGORY_MOVEMENT },
	{ "action": "move_backward", "display": SettingsText.ACTION_MOVE_BACKWARD, "category": SettingsText.CATEGORY_MOVEMENT },
	{ "action": "move_left", "display": SettingsText.ACTION_MOVE_LEFT, "category": SettingsText.CATEGORY_MOVEMENT },
	{ "action": "move_right", "display": SettingsText.ACTION_MOVE_RIGHT, "category": SettingsText.CATEGORY_MOVEMENT },
	{ "action": "jump", "display": SettingsText.ACTION_JUMP, "category": SettingsText.CATEGORY_MOVEMENT },
	{ "action": "sprint", "display": SettingsText.ACTION_SPRINT, "category": SettingsText.CATEGORY_MOVEMENT },
	{ "action": "crouch", "display": SettingsText.ACTION_CROUCH, "category": SettingsText.CATEGORY_MOVEMENT },
	{ "action": "stance_raise", "display": SettingsText.ACTION_STANCE_RAISE, "category": SettingsText.CATEGORY_STANCE },
	{ "action": "stance_lower", "display": SettingsText.ACTION_STANCE_LOWER, "category": SettingsText.CATEGORY_STANCE },
	{ "action": "fire", "display": SettingsText.ACTION_FIRE, "category": SettingsText.CATEGORY_COMBAT },
	{ "action": "reload", "display": SettingsText.ACTION_RELOAD, "category": SettingsText.CATEGORY_COMBAT },
	{ "action": "cycle_fire_mode", "display": SettingsText.ACTION_CYCLE_FIRE_MODE, "category": SettingsText.CATEGORY_COMBAT },
	{ "action": "clear_malfunction", "display": SettingsText.ACTION_CLEAR_MALFUNCTION, "category": SettingsText.CATEGORY_COMBAT },
	{ "action": "toggle_free_cam", "display": SettingsText.ACTION_TOGGLE_FREE_CAM, "category": SettingsText.CATEGORY_DEBUG, "debug_only": true },
	{ "action": "weapon_mod_menu", "display": SettingsText.ACTION_WEAPON_MOD_MENU, "category": SettingsText.CATEGORY_DEBUG, "debug_only": true },
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
		if not cfg.has_section_key(CONFIG_SECTION, action):
			continue
		var encoded = cfg.get_value(CONFIG_SECTION, action)
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
static func reset_action(action: String, persist: bool = true) -> void:
	var default_events := _project_default_events(action)
	InputMap.action_erase_events(action)
	for ev in default_events:
		InputMap.action_add_event(action, ev)
	var cfg := ConfigFile.new()
	cfg.load(SAVE_PATH)
	if cfg.has_section_key(CONFIG_SECTION, action):
		cfg.erase_section_key(CONFIG_SECTION, action)
		if persist:
			cfg.save(SAVE_PATH)


## 恢复全部动作为默认键位并清空存档。
static func reset_all(persist: bool = true) -> void:
	for entry in ACTIONS:
		var action: String = entry["action"]
		if not InputMap.has_action(action):
			continue
		var default_events := _project_default_events(action)
		InputMap.action_erase_events(action)
		for ev in default_events:
			InputMap.action_add_event(action, ev)
	if persist:
		DirAccess.remove_absolute(SAVE_PATH)


## 把动作重绑定到单个新事件（覆盖式，替换全部现有事件）。
static func rebind_action(action: String, event: InputEvent) -> void:
	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, event)
	save_action(action)


## 修改指定绑定槽；不存在的槽会依次补齐。最多保留两个槽。
static func rebind_action_slot(action: String, slot: int, event: InputEvent, persist: bool = true) -> void:
	if not InputMap.has_action(action) or slot < 0 or slot > 1:
		return
	var events: Array = InputMap.action_get_events(action).duplicate()
	if slot < events.size():
		events[slot] = event
	else:
		events.append(event)
	InputMap.action_erase_events(action)
	for input_event in events.slice(0, 2):
		InputMap.action_add_event(action, input_event)
	if persist:
		save_action(action)


## 清空一个绑定槽；不会影响同一动作的另一槽。
static func clear_action_slot(action: String, slot: int, persist: bool = true) -> void:
	if not InputMap.has_action(action) or slot < 0:
		return
	var events: Array = InputMap.action_get_events(action).duplicate()
	if slot >= events.size():
		return
	events.remove_at(slot)
	InputMap.action_erase_events(action)
	for input_event in events:
		InputMap.action_add_event(action, input_event)
	if persist:
		save_action(action)


## 移除与 event 重复的其它动作绑定，然后写入目标槽。
static func replace_conflicts_and_rebind(action: String, slot: int, event: InputEvent, persist: bool = true) -> void:
	var signature := _event_signature(event)
	for entry in ACTIONS:
		var other: String = entry["action"]
		if other == action or not InputMap.has_action(other):
			continue
		var kept: Array = []
		for other_event in InputMap.action_get_events(other):
			if _event_signature(other_event) != signature:
				kept.append(other_event)
		InputMap.action_erase_events(other)
		for kept_event in kept:
			InputMap.action_add_event(other, kept_event)
		if persist:
			save_action(other)
	rebind_action_slot(action, slot, event, persist)


## 返回占用 event 的其它可配置动作。
static func find_event_conflicts(event: InputEvent, excluded_action: String = "") -> Array[String]:
	var result: Array[String] = []
	var signature := _event_signature(event)
	if signature == "":
		return result
	for entry in ACTIONS:
		var action: String = entry["action"]
		if action == excluded_action or not InputMap.has_action(action):
			continue
		for input_event in InputMap.action_get_events(action):
			if _event_signature(input_event) == signature:
				result.append(action)
				break
	return result


## 供设置页的“取消”恢复运行时 InputMap 状态；不直接写盘。
static func snapshot_bindings() -> Dictionary:
	var snapshot := {}
	for entry in ACTIONS:
		var action: String = entry["action"]
		if not InputMap.has_action(action):
			continue
		var events: Array = []
		for event in InputMap.action_get_events(action):
			events.append(event.duplicate())
		snapshot[action] = events
	return snapshot


static func restore_bindings(snapshot: Dictionary) -> void:
	for entry in ACTIONS:
		var action: String = entry["action"]
		if not InputMap.has_action(action) or not snapshot.has(action):
			continue
		InputMap.action_erase_events(action)
		for event in snapshot[action]:
			InputMap.action_add_event(action, event.duplicate())


## 返回动作当前主要绑定的可读文本（用于键帽显示）。
static func describe_action(action: String) -> String:
	if not InputMap.has_action(action):
		return "—"
	for ev in InputMap.action_get_events(action):
		var label := describe_event(ev)
		if label != "":
			return label
	return SettingsText.BIND_UNBOUND


static func describe_action_slot(action: String, slot: int) -> String:
	if not InputMap.has_action(action):
		return SettingsText.BIND_EMPTY
	var events := InputMap.action_get_events(action)
	if slot < 0 or slot >= events.size():
		return SettingsText.BIND_UNBOUND
	var label := describe_event(events[slot])
	return label if label != "" else SettingsText.BIND_UNBOUND


## 返回单个事件的简短可读标签。
static func describe_event(event: InputEvent) -> String:
	if event is InputEventKey:
		var kc: int = (event as InputEventKey).physical_keycode
		if kc == 0:
			kc = (event as InputEventKey).keycode
		return OS.get_keycode_string(kc)
	if event is InputEventMouseButton:
		match (event as InputEventMouseButton).button_index:
			MOUSE_BUTTON_LEFT: return SettingsText.KEY_MOUSE_LEFT
			MOUSE_BUTTON_RIGHT: return SettingsText.KEY_MOUSE_RIGHT
			MOUSE_BUTTON_MIDDLE: return SettingsText.KEY_MOUSE_MIDDLE
			MOUSE_BUTTON_WHEEL_UP: return SettingsText.KEY_WHEEL_UP
			MOUSE_BUTTON_WHEEL_DOWN: return SettingsText.KEY_WHEEL_DOWN
			_: return SettingsText.KEY_MOUSE_BUTTON % (event as InputEventMouseButton).button_index
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
		var signature := _event_signature(ev)
		if signature != "":
			out.append(signature)
	return out


static func _event_signature(event: InputEvent) -> String:
	var enc := _encode_event(event)
	return "%s:%d" % [enc["t"], enc["code"]] if not enc.is_empty() else ""


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
