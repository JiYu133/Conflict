extends RefCounted

const SettingsText = preload("res://classes/ui/settings/settings_text.gd")
const SAVE_PATH := "user://keybinds.cfg"
const CONFIG_SECTION := "keybinds"

const ACTIONS: Array[Dictionary] = [
	{ "action": "move_forward", "display": SettingsText.ACTION_MOVE_FORWARD, "category": SettingsText.CATEGORY_MOVEMENT },
	{ "action": "move_backward", "display": SettingsText.ACTION_MOVE_BACKWARD, "category": SettingsText.CATEGORY_MOVEMENT },
	{ "action": "move_left", "display": SettingsText.ACTION_MOVE_LEFT, "category": SettingsText.CATEGORY_MOVEMENT },
	{ "action": "move_right", "display": SettingsText.ACTION_MOVE_RIGHT, "category": SettingsText.CATEGORY_MOVEMENT },
	{ "action": "jump", "display": SettingsText.ACTION_JUMP, "category": SettingsText.CATEGORY_MOVEMENT },
	{ "action": "sprint", "display": SettingsText.ACTION_SPRINT, "category": SettingsText.CATEGORY_MOVEMENT },
	{ "action": "crouch", "display": SettingsText.ACTION_CROUCH, "category": SettingsText.CATEGORY_STANCE },
	{ "action": "stance_raise", "display": SettingsText.ACTION_STANCE_RAISE, "category": SettingsText.CATEGORY_STANCE },
	{ "action": "stance_lower", "display": SettingsText.ACTION_STANCE_LOWER, "category": SettingsText.CATEGORY_STANCE },
	{ "action": "free_look", "display": SettingsText.ACTION_FREE_LOOK, "category": SettingsText.CATEGORY_COMBAT },
	{ "action": "fire", "display": SettingsText.ACTION_FIRE, "category": SettingsText.CATEGORY_COMBAT },
	{ "action": "reload", "display": SettingsText.ACTION_RELOAD, "category": SettingsText.CATEGORY_COMBAT },
	{ "action": "cycle_fire_mode", "display": SettingsText.ACTION_CYCLE_FIRE_MODE, "category": SettingsText.CATEGORY_COMBAT },
	{ "action": "clear_malfunction", "display": SettingsText.ACTION_CLEAR_MALFUNCTION, "category": SettingsText.CATEGORY_COMBAT },
	{ "action": "squad_command_radial", "display": SettingsText.ACTION_SQUAD_COMMAND_RADIAL, "category": SettingsText.CATEGORY_COMBAT },
	{ "action": "toggle_free_cam", "display": SettingsText.ACTION_TOGGLE_FREE_CAM, "category": SettingsText.CATEGORY_DEBUG, "debug_only": true },
	{ "action": "weapon_mod_menu", "display": SettingsText.ACTION_WEAPON_MOD_MENU, "category": SettingsText.CATEGORY_DEBUG, "debug_only": true },
	{ "action": "debug_revive", "display": SettingsText.ACTION_DEBUG_REVIVE, "category": SettingsText.CATEGORY_DEBUG, "debug_only": true },
	{ "action": "console", "display": SettingsText.ACTION_CONSOLE, "hint": SettingsText.ACTION_CONSOLE_HINT, "category": SettingsText.CATEGORY_DEBUG },
]

static var _applied := false
static var _overrides: Dictionary = {}
static var _pressed_keys: Dictionary = {}
static var _combo_active: Dictionary = {}
static var _combo_pressed_edges: Dictionary = {}
static var _combo_released_edges: Dictionary = {}
static var _last_input_event: InputEvent


static func apply_saved() -> void:
	if _applied:
		return
	_applied = true
	var cfg := ConfigFile.new()
	if cfg.load(SAVE_PATH) != OK:
		return
	for entry in ACTIONS:
		var action: String = entry["action"]
		if not InputMap.has_action(action) or not cfg.has_section_key(CONFIG_SECTION, action):
			continue
		var bindings := _decode_bindings(cfg.get_value(CONFIG_SECTION, action))
		if bindings.is_empty():
			continue
		_overrides[action] = bindings
		_apply_bindings_to_input_map(action, bindings)


static func save_action(action: String) -> void:
	var cfg := ConfigFile.new()
	cfg.load(SAVE_PATH)
	cfg.set_value(CONFIG_SECTION, action, _encode_bindings(_get_bindings(action)))
	cfg.save(SAVE_PATH)


static func save_all() -> void:
	var cfg := ConfigFile.new()
	cfg.load(SAVE_PATH)
	for entry in ACTIONS:
		var action: String = entry["action"]
		if InputMap.has_action(action):
			cfg.set_value(CONFIG_SECTION, action, _encode_bindings(_get_bindings(action)))
	cfg.save(SAVE_PATH)


static func reset_action(action: String, persist: bool = true) -> void:
	var defaults := _project_default_events(action)
	_overrides.erase(action)
	_apply_bindings_to_input_map(action, defaults)
	if persist:
		var cfg := ConfigFile.new()
		cfg.load(SAVE_PATH)
		if cfg.has_section_key(CONFIG_SECTION, action):
			cfg.erase_section_key(CONFIG_SECTION, action)
			cfg.save(SAVE_PATH)


static func reset_all(persist: bool = true) -> void:
	_overrides.clear()
	for entry in ACTIONS:
		var action: String = entry["action"]
		if InputMap.has_action(action):
			_apply_bindings_to_input_map(action, _project_default_events(action))
	if persist:
		DirAccess.remove_absolute(SAVE_PATH)


static func rebind_action(action: String, binding, persist: bool = true) -> void:
	rebind_action_slot(action, 0, binding, persist)


static func rebind_action_slot(action: String, slot: int, binding, persist: bool = true) -> void:
	if not InputMap.has_action(action) or slot < 0 or slot > 1:
		return
	var bindings := _get_bindings(action)
	var normalized = _normalize_binding(binding)
	if normalized == null:
		return
	if slot < bindings.size():
		bindings[slot] = normalized
	else:
		bindings.append(normalized)
	_overrides[action] = bindings.slice(0, 2)
	_apply_bindings_to_input_map(action, _overrides[action])
	if persist:
		save_action(action)


static func clear_action_slot(action: String, slot: int, persist: bool = true) -> void:
	var bindings := _get_bindings(action)
	if slot < 0 or slot >= bindings.size():
		return
	bindings.remove_at(slot)
	_overrides[action] = bindings
	_apply_bindings_to_input_map(action, bindings)
	if persist:
		save_action(action)


static func replace_conflicts_and_rebind(action: String, slot: int, binding, persist: bool = true) -> void:
	var signature := _binding_signature(binding)
	for entry in ACTIONS:
		var other: String = entry["action"]
		if other == action or not InputMap.has_action(other):
			continue
		var kept: Array = []
		for other_binding in _get_bindings(other):
			if _binding_signature(other_binding) != signature:
				kept.append(other_binding)
		_overrides[other] = kept
		_apply_bindings_to_input_map(other, kept)
		if persist:
			save_action(other)
	rebind_action_slot(action, slot, binding, persist)


static func find_event_conflicts(binding, excluded_action: String = "") -> Array[String]:
	var result: Array[String] = []
	var signature := _binding_signature(binding)
	if signature == "":
		return result
	for entry in ACTIONS:
		var action: String = entry["action"]
		if action == excluded_action or not InputMap.has_action(action):
			continue
		for existing in _get_bindings(action):
			if _binding_signature(existing) == signature:
				result.append(action)
				break
	return result


static func find_conflicts(action: String) -> Array[String]:
	var result: Array[String] = []
	for binding in _get_bindings(action):
		for other in find_event_conflicts(binding, action):
			if other not in result:
				result.append(other)
	return result


static func snapshot_bindings() -> Dictionary:
	var snapshot := {}
	for entry in ACTIONS:
		var action: String = entry["action"]
		if InputMap.has_action(action):
			snapshot[action] = _duplicate_bindings(_get_bindings(action))
	return snapshot


static func restore_bindings(snapshot: Dictionary) -> void:
	for entry in ACTIONS:
		var action: String = entry["action"]
		if not InputMap.has_action(action) or not snapshot.has(action):
			continue
		_overrides[action] = _duplicate_bindings(snapshot[action])
		_apply_bindings_to_input_map(action, _overrides[action])


static func describe_action(action: String) -> String:
	for binding in _get_bindings(action):
		var label := describe_binding(binding)
		if label != "":
			return label
	return SettingsText.BIND_UNBOUND


static func describe_action_slot(action: String, slot: int) -> String:
	var bindings := _get_bindings(action)
	if slot < 0 or slot >= bindings.size():
		return SettingsText.BIND_UNBOUND
	return describe_binding(bindings[slot])


static func describe_binding(binding) -> String:
	if binding is Array:
		var labels: PackedStringArray = []
		for code in binding:
			labels.append(OS.get_keycode_string(int(code)))
		return " + ".join(labels)
	return describe_event(binding as InputEvent)


static func describe_event(event: InputEvent) -> String:
	if event is InputEventKey:
		var key_event := event as InputEventKey
		var code := key_event.physical_keycode if key_event.physical_keycode != 0 else key_event.keycode
		var parts: PackedStringArray = []
		if key_event.ctrl_pressed: parts.append("Ctrl")
		if key_event.alt_pressed: parts.append("Alt")
		if key_event.shift_pressed: parts.append("Shift")
		if key_event.meta_pressed: parts.append("Meta")
		parts.append(OS.get_keycode_string(code))
		return " + ".join(parts)
	if event is InputEventMouseButton:
		var mouse := event as InputEventMouseButton
		match mouse.button_index:
			MOUSE_BUTTON_LEFT: return SettingsText.KEY_MOUSE_LEFT
			MOUSE_BUTTON_RIGHT: return SettingsText.KEY_MOUSE_RIGHT
			MOUSE_BUTTON_MIDDLE: return SettingsText.KEY_MOUSE_MIDDLE
			MOUSE_BUTTON_WHEEL_UP: return SettingsText.KEY_WHEEL_UP
			MOUSE_BUTTON_WHEEL_DOWN: return SettingsText.KEY_WHEEL_DOWN
			_: return SettingsText.KEY_MOUSE_BUTTON % mouse.button_index
	return ""


## 在所有使用自定义组合键的输入入口调用。组合键必须同时按住才算激活。
static func process_input(event: InputEvent) -> void:
	if event == _last_input_event:
		return
	_last_input_event = event
	_combo_pressed_edges.clear()
	_combo_released_edges.clear()
	if event is InputEventKey and not event.echo:
		var key := event as InputEventKey
		var code := key.physical_keycode if key.physical_keycode != 0 else key.keycode
		_pressed_keys[code] = key.pressed
	elif event is InputEventMouseButton:
		var mouse := event as InputEventMouseButton
		_pressed_keys["mouse:%d" % mouse.button_index] = mouse.pressed
	else:
		return
	for action in _combo_bindings_actions():
		var active := false
		for binding in _combo_bindings_for_action(action):
			if _binding_is_combo(binding) and _combo_is_down(binding):
				active = true
				break
		var was_active: bool = _combo_active.get(action, false)
		_combo_active[action] = active
		if active and not was_active:
			_combo_pressed_edges[action] = true
		elif was_active and not active:
			_combo_released_edges[action] = true


static func action_pressed_event(action: String, event: InputEvent) -> bool:
	process_input(event)
	return event.is_action_pressed(action) or bool(_combo_pressed_edges.get(action, false))


static func action_released_event(action: String, event: InputEvent) -> bool:
	process_input(event)
	return event.is_action_released(action) or bool(_combo_released_edges.get(action, false))


static func is_action_pressed(action: String) -> bool:
	if bool(_combo_active.get(action, false)):
		return true
	return Input.is_action_pressed(action)


static func _get_bindings(action: String) -> Array:
	if _overrides.has(action):
		return _duplicate_bindings(_overrides[action])
	var result: Array = []
	if InputMap.has_action(action):
		for event in InputMap.action_get_events(action):
			result.append(event.duplicate())
	result.append_array(_combo_bindings_for_action(action))
	return result.slice(0, 2)


static func _combo_bindings_actions() -> Array:
	var result: Array = []
	for action in _overrides:
		if not _combo_bindings_for_action(action).is_empty():
			result.append(action)
	return result


static func _combo_bindings_for_action(action: String) -> Array:
	var result: Array = []
	for binding in _get_raw_bindings(action):
		if _binding_is_combo(binding):
			result.append(binding)
	return result


static func _get_raw_bindings(action: String) -> Array:
	if _overrides.has(action):
		return _overrides[action]
	return []


static func _combo_is_down(binding: Array) -> bool:
	for code in binding:
		if not _pressed_keys.get(int(code), false):
			return false
	return true


static func _binding_is_combo(binding) -> bool:
	return binding is Array and binding.size() >= 2


static func _normalize_binding(binding):
	if binding is Array:
		var keys: Array[int] = []
		for code in binding:
			if int(code) not in keys:
				keys.append(int(code))
		if keys.is_empty():
			return null
		return keys.slice(maxi(0, keys.size() - 2))
	if binding is InputEvent:
		return binding.duplicate()
	return null


static func _binding_signature(binding) -> String:
	if binding is Array:
		var keys: Array = binding.duplicate()
		keys.sort()
		return "combo:" + ",".join(PackedStringArray(keys.map(func(v): return str(v))))
	return _event_signature(binding as InputEvent)


static func _event_signature(event: InputEvent) -> String:
	var code := _encode_event(event)
	if code.is_empty():
		return ""
	return "%s:%d:%d%d%d%d" % [code["t"], code["code"], int(code.get("ctrl", false)), int(code.get("alt", false)), int(code.get("shift", false)), int(code.get("meta", false))]


static func _apply_bindings_to_input_map(action: String, bindings: Array) -> void:
	if not InputMap.has_action(action):
		return
	InputMap.action_erase_events(action)
	for binding in bindings:
		if binding is InputEvent:
			InputMap.action_add_event(action, binding.duplicate())


static func _encode_bindings(bindings: Array) -> Array:
	var out: Array = []
	for binding in bindings:
		if binding is Array:
			out.append({"t": "combo", "codes": binding})
		else:
			var encoded := _encode_event(binding as InputEvent)
			if not encoded.is_empty():
				out.append(encoded)
	return out


static func _decode_bindings(encoded) -> Array:
	var out: Array = []
	if not encoded is Array:
		return out
	for data in encoded:
		if not data is Dictionary:
			continue
		if data.get("t", "") == "combo":
			var combo: Array = []
			for code in data.get("codes", []):
				combo.append(int(code))
			var normalized = _normalize_binding(combo)
			if normalized != null:
				out.append(normalized)
		else:
			var event := _decode_event(data)
			if event:
				out.append(event)
	return out.slice(0, 2)


static func _duplicate_bindings(bindings: Array) -> Array:
	var out: Array = []
	for binding in bindings:
		out.append(binding.duplicate() if binding is Array or binding is InputEvent else binding)
	return out


static func _project_default_events(action: String) -> Array:
	var setting := "input/" + action
	if not ProjectSettings.has_setting(setting):
		return []
	var data = ProjectSettings.get_setting(setting)
	return data["events"].duplicate() if data is Dictionary and data.has("events") else []


static func _encode_event(event: InputEvent) -> Dictionary:
	if event is InputEventKey:
		var key := event as InputEventKey
		return {"t": "key", "code": key.physical_keycode if key.physical_keycode != 0 else key.keycode, "ctrl": key.ctrl_pressed, "alt": key.alt_pressed, "shift": key.shift_pressed, "meta": key.meta_pressed}
	if event is InputEventMouseButton:
		var mouse := event as InputEventMouseButton
		return {"t": "mouse", "code": mouse.button_index, "ctrl": mouse.ctrl_pressed, "alt": mouse.alt_pressed, "shift": mouse.shift_pressed, "meta": mouse.meta_pressed}
	return {}


static func _decode_event(data: Dictionary) -> InputEvent:
	if data.get("t", "") == "key":
		var key := InputEventKey.new()
		key.physical_keycode = int(data.get("code", 0))
		key.ctrl_pressed = bool(data.get("ctrl", false)); key.alt_pressed = bool(data.get("alt", false)); key.shift_pressed = bool(data.get("shift", false)); key.meta_pressed = bool(data.get("meta", false))
		return key
	if data.get("t", "") == "mouse":
		var mouse := InputEventMouseButton.new()
		mouse.button_index = int(data.get("code", 0))
		mouse.ctrl_pressed = bool(data.get("ctrl", false)); mouse.alt_pressed = bool(data.get("alt", false)); mouse.shift_pressed = bool(data.get("shift", false)); mouse.meta_pressed = bool(data.get("meta", false))
		return mouse
	return null
