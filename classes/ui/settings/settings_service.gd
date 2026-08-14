extends Node

## BasePlayer 拥有的玩家偏好组件。
## 只保存玩家可自行决定的偏好；武器、瞄具光学和其他游戏平衡参数不属于这里。

const KeybindStore = preload("res://classes/ui/settings/keybind_store.gd")
const SettingsText = preload("res://classes/ui/settings/settings_text.gd")

const SAVE_PATH := "user://settings.cfg"
const VERSION := 5

const GRAPHICS_DEFAULTS_V3 := {
	"graphics/hit_camera_impact": 1.0,
	"graphics/damage_blur": 1.0,
	"graphics/coma_effect": true,
	"graphics/death_effect": true,
	"graphics/death_camera_shake": 1.0,
	"graphics/muzzle_flash": true,
	"graphics/muzzle_light": true,
	"graphics/heat_haze": true,
	"graphics/blood_effects": true,
}

const GRAPHICS_DEFAULTS_V4 := {
	"graphics/muzzle_flash_distance": 120.0,
	"graphics/muzzle_light_distance": 35.0,
	"graphics/muzzle_flash_offscreen_culling": true,
	"graphics/muzzle_flash_quality": "medium",
}

const DEFAULTS := {
	"audio/menu_music_volume": 0.75,
	"audio/loading_music_volume": 0.38,
	"audio/loading_muffle": 0.70,
	"controls/sensitivity": 1.0,
	"controls/radial_menu_hold_threshold": 0.25,
	"controls/invert_y": false,
	"graphics/window_mode": "fullscreen",
	"graphics/hit_camera_impact": 1.0,
	"graphics/damage_blur": 1.0,
	"graphics/coma_effect": true,
	"graphics/death_effect": true,
	"graphics/death_camera_shake": 1.0,
	"graphics/muzzle_flash": true,
	"graphics/muzzle_flash_distance": 120.0,
	"graphics/muzzle_light_distance": 35.0,
	"graphics/muzzle_flash_offscreen_culling": true,
	"graphics/muzzle_flash_quality": "medium",
	"graphics/muzzle_light": true,
	"graphics/heat_haze": true,
	"graphics/blood_effects": true,
}

signal value_changed(key: String, value: Variant)

var _values: Dictionary = DEFAULTS.duplicate(true)
var _settings_were_migrated := false


func initialize() -> void:
	load_settings()
	if _settings_were_migrated:
		var migration_result := save_settings()
		if migration_result != OK:
			push_warning("SettingsService: 无法保存迁移后的默认画面设置，错误码 %d" % migration_result)
	_apply_window_mode()
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
	if key == "graphics/window_mode":
		_apply_window_mode()
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


func reset_video() -> void:
	for raw_key in DEFAULTS:
		var key: String = String(raw_key)
		if key.begins_with("graphics/"):
			set_value(key, DEFAULTS[key])


func reset_audio() -> void:
	for raw_key in DEFAULTS:
		var key: String = String(raw_key)
		if key.begins_with("audio/"):
			set_value(key, DEFAULTS[key])


func load_settings() -> void:
	_values = DEFAULTS.duplicate(true)
	_settings_were_migrated = false
	var config := ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		return
	var saved_version := int(config.get_value("meta", "version", 0))
	for raw_key in DEFAULTS:
		var key: String = String(raw_key)
		var path: PackedStringArray = key.split("/", false, 1)
		if path.size() == 2 and config.has_section_key(path[0], path[1]):
			_values[key] = _normalize_value(key, config.get_value(path[0], path[1]))
	# 这些画面开关在 v3 才正式接入。旧存档可能包含开发测试值，
	# 升级时统一恢复为设计默认值；之后玩家的主动修改会正常持久化。
	if saved_version < VERSION:
		_settings_were_migrated = true
	if saved_version < 3:
		for key in GRAPHICS_DEFAULTS_V3:
			_values[key] = GRAPHICS_DEFAULTS_V3[key]
	if saved_version < 4:
		for key in GRAPHICS_DEFAULTS_V4:
			_values[key] = GRAPHICS_DEFAULTS_V4[key]


func save_settings() -> Error:
	var config := ConfigFile.new()
	config.set_value("meta", "version", VERSION)
	for raw_key in DEFAULTS:
		var key: String = String(raw_key)
		var path: PackedStringArray = key.split("/", false, 1)
		_values[key] = _normalize_value(key, _values.get(key, DEFAULTS[key]))
		config.set_value(path[0], path[1], _values[key])
	return config.save(SAVE_PATH)


func _normalize_value(key: String, value: Variant) -> Variant:
	match key:
		"controls/sensitivity":
			return clampf(float(value), 0.10, 3.00)
		"controls/radial_menu_hold_threshold":
			return clampf(float(value), 0.10, 1.00)
		"controls/invert_y":
			return bool(value)
		"audio/menu_music_volume", "audio/loading_music_volume", "audio/loading_muffle":
			return clampf(float(value), 0.0, 1.0)
		"graphics/window_mode":
			var mode := String(value)
			return mode if mode in ["windowed", "fullscreen"] else DEFAULTS[key]
		"graphics/hit_camera_impact", "graphics/damage_blur", "graphics/death_camera_shake":
			return clampf(float(value), 0.0, 1.0)
		"graphics/muzzle_flash_distance":
			return clampf(float(value), 20.0, 300.0)
		"graphics/muzzle_light_distance":
			return clampf(float(value), 5.0, 100.0)
		"graphics/muzzle_flash_quality":
			var quality := String(value)
			return quality if quality in ["low", "medium", "high"] else DEFAULTS[key]
		"graphics/coma_effect", "graphics/death_effect", "graphics/muzzle_flash", \
			"graphics/muzzle_light", "graphics/heat_haze", "graphics/blood_effects", \
			"graphics/muzzle_flash_offscreen_culling":
			return bool(value)
	return value


func _apply_window_mode() -> void:
	var mode := String(_values.get("graphics/window_mode", DEFAULTS["graphics/window_mode"]))
	DisplayServer.window_set_mode(
		DisplayServer.WINDOW_MODE_FULLSCREEN
		if mode == "fullscreen"
		else DisplayServer.WINDOW_MODE_WINDOWED
	)
