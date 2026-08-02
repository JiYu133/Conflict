extends CanvasLayer

## 本地暂停菜单：阻断本地玩家输入，不暂停场景树，兼容未来多人游戏。

const FONT_PATH := "res://res/fonts/ConflictCJKUI.ttf"
const SettingsText = preload("res://classes/ui/settings/settings_text.gd")
const COL_BACKDROP := Color(0.0, 0.0, 0.0, 0.68)
const COL_PANEL := Color(0.063, 0.067, 0.075, 0.90)
const COL_BORDER := Color(1.0, 1.0, 1.0, 0.11)
const COL_TEXT := Color(0.945, 0.953, 0.961)
const COL_MUTED := Color(0.61, 0.64, 0.68)

var _player
var _settings_menu
var _open := false
var _was_controllable := false
var _theme: Theme


func initialize(player, settings_menu) -> void:
	_player = player
	_settings_menu = settings_menu
	if _settings_menu:
		_settings_menu.closed.connect(_on_settings_closed)


func is_open() -> bool:
	return _open


func _ready() -> void:
	layer = 20
	_theme = Theme.new()
	if ResourceLoader.exists(FONT_PATH):
		_theme.default_font = load(FONT_PATH)
	_theme.default_font_size = 16
	_build_ui()
	visible = false


func open() -> void:
	if _open:
		return
	_open = true
	visible = true
	if _player:
		_was_controllable = _player.controllable
		_player.set_controllable(false)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func close() -> void:
	if not _open:
		return
	if _settings_menu and _settings_menu.is_open():
		_settings_menu.cancel_and_close()
	_open = false
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if _player:
		_player.set_controllable(_was_controllable and _player.is_alive)


func _input(event: InputEvent) -> void:
	if _settings_menu and _settings_menu.is_open():
		return
	if event.is_action_pressed("ui_cancel"):
		if _open:
			close()
		else:
			open()
		get_viewport().set_input_as_handled()


func _build_ui() -> void:
	var backdrop := ColorRect.new()
	backdrop.color = COL_BACKDROP
	backdrop.set_anchors_preset(Control.PRESET_FULL_RECT)
	backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(backdrop)

	var panel := PanelContainer.new()
	panel.theme = _theme
	panel.add_theme_stylebox_override("panel", _box(COL_PANEL, COL_BORDER, 4))
	panel.custom_minimum_size = Vector2(360, 0)
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
	panel.grow_vertical = Control.GROW_DIRECTION_BOTH
	backdrop.add_child(panel)

	var margin := MarginContainer.new()
	for side in ["left", "right", "top", "bottom"]:
		margin.add_theme_constant_override("margin_" + side, 28)
	panel.add_child(margin)

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 10)
	margin.add_child(content)

	var title := Label.new()
	title.text = SettingsText.PAUSE_TITLE
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 24)
	title.add_theme_color_override("font_color", COL_TEXT)
	content.add_child(title)

	var line := ColorRect.new()
	line.color = COL_BORDER
	line.custom_minimum_size = Vector2(0, 1)
	content.add_child(line)

	_add_button(content, SettingsText.PAUSE_RESUME, close, true)
	_add_button(content, SettingsText.PAUSE_SETTINGS, _open_settings)
	_add_button(content, SettingsText.PAUSE_QUIT, _quit_game)

	var hint := Label.new()
	hint.text = SettingsText.PAUSE_RESUME_HINT
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.add_theme_font_size_override("font_size", 13)
	hint.add_theme_color_override("font_color", COL_MUTED)
	content.add_child(hint)


func _add_button(parent: Control, text: String, callback: Callable, primary: bool = false) -> void:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(0, 42)
	button.focus_mode = Control.FOCUS_ALL
	button.add_theme_stylebox_override("normal", _box(Color(1, 1, 1, 0.94) if primary else Color(1, 1, 1, 0.0), Color.WHITE if primary else COL_BORDER, 3))
	button.add_theme_stylebox_override("hover", _box(Color(1, 1, 1, 1.0) if primary else Color(1, 1, 1, 0.06), Color.WHITE, 3))
	button.add_theme_stylebox_override("focus", _box(Color(1, 1, 1, 0.94) if primary else Color(1, 1, 1, 0.06), Color.WHITE, 3, 2))
	var font_color: Color = Color(0.05, 0.05, 0.05) if primary else COL_TEXT
	button.add_theme_color_override("font_color", font_color)
	button.add_theme_color_override("font_hover_color", font_color)
	button.add_theme_color_override("font_pressed_color", font_color)
	button.add_theme_color_override("font_focus_color", font_color)
	button.pressed.connect(callback)
	parent.add_child(button)


func _open_settings() -> void:
	visible = false
	if _settings_menu:
		_settings_menu.open()


func _on_settings_closed() -> void:
	if _open:
		visible = true


func _quit_game() -> void:
	get_tree().quit()


func _box(background: Color, border: Color, radius: int, border_width: int = 1) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = background
	box.border_color = border
	box.set_border_width_all(border_width)
	box.set_corner_radius_all(radius)
	box.content_margin_left = 14
	box.content_margin_right = 14
	box.content_margin_top = 8
	box.content_margin_bottom = 8
	return box
