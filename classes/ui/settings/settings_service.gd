extends Node

## BasePlayer 拥有的玩家偏好组件。
## 只保存玩家可自行决定的偏好；武器、瞄具光学和其他游戏平衡参数不属于这里。

const KeybindStore = preload("res://classes/ui/settings/keybind_store.gd")
const SettingsText = preload("res://classes/ui/settings/settings_text.gd")

const SAVE_PATH := "user://settings.cfg"
const VERSION := 1

const DEFAULTS := {
	"controls/sensitivity": 1.0,
	"controls/invert_y": false,
}

signal value_changed(key: String, value: Variant)

var _values: Dictionary = DEFAULTS.duplicate(true)


func initialize() -> void:
	load_settings()
	# 键位是 InputMap 的运行时覆盖，必须在首个玩家开始接收输入前恢复。
	KeybindStore.apply_saved()


func get_value(key: String, fallback: Variant = null) -> Variant:
	return _values.get(key, fallback)


func set_value(key: String, value: Variant) -> void:
	if not DEFAULTS.has(key):
		push_warning(SettingsText.SETTINGS_UNKNOWN_KEY % key)
		return
	var normalized: Variant = _normalize_value(key, value)
	if _values.get(key) == normalized:
		return
	_values[key] = normalized
	value_changed.emit(key, normalized)


func snapshot() -> Dictionary:
	return _values.duplicate(true)


func restore_snapshot(snapshot: Dictionary) -> void:
	for raw_key in DEFAULTS:
		var key: String = String(raw_key)
		set_value(key, snapshot.get(key, DEFAULTS[key]))


func reset_controls() -> void:
	for raw_key in DEFAULTS:
		var key: String = String(raw_key)
		if key.begins_with("controls/"):
			set_value(key, DEFAULTS[key])


func load_settings() -> void:
	_values = DEFAULTS.duplicate(true)
	var config := ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		return
	for raw_key in DEFAULTS:
		var key: String = String(raw_key)
		var path: PackedStringArray = key.split("/", false, 1)
		if path.size() == 2 and config.has_section_key(path[0], path[1]):
			_values[key] = _normalize_value(key, config.get_value(path[0], path[1]))


func save_settings() -> Error:
	var config := ConfigFile.new()
	config.set_value("meta", "version", VERSION)
	for raw_key in DEFAULTS:
		var key: String = String(raw_key)
		var path: PackedStringArray = key.split("/", false, 1)
		config.set_value(path[0], path[1], _values[key])
	return config.save(SAVE_PATH)


func _normalize_value(key: String, value: Variant) -> Variant:
	match key:
		"controls/sensitivity":
			return clampf(float(value), 0.10, 3.00)
		"controls/invert_y":
			return bool(value)
	return value
