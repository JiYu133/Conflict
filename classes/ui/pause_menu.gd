extends CanvasLayer

## 本地暂停菜单：阻断本地玩家输入，不暂停场景树，兼容未来多人游戏。

const FONT_PATH := "res://res/fonts/ConflictCJKUI.ttf"
const SettingsText = preload("res://classes/ui/settings/settings_text.gd")
const BLUR_SHADER_PATH := "res://res/shaders/death_blur.gdshader"
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
var _backdrop: ColorRect
var _panel: PanelContainer
var _panel_rest_position := Vector2.ZERO
var _background_blur_layer: CanvasLayer
var _transition: Tween
var _transitioning := false


func initialize(player, settings_menu) -> void:
	_player = player
	_settings_menu = settings_menu
	if _settings_menu:
		_settings_menu.closed.connect(_on_settings_closed)


func is_open() -> bool:
	return _open or _transitioning


func _ready() -> void:
	layer = 20
	_theme = Theme.new()
	if ResourceLoader.exists(FONT_PATH):
		_theme.default_font = load(FONT_PATH)
	_theme.default_font_size = 16
	_setup_background_blur()
	_build_ui()
	visible = false


func open() -> void:
	if _open or _transitioning:
		return
	_open = true
	visible = true
	_panel_rest_position = _panel.position
	_backdrop.modulate.a = 0.0
	_panel.modulate.a = 0.0
	_panel.position = _panel_rest_position + Vector2(0.0, 8.0)
	if _background_blur_layer:
		_background_blur_layer.visible = true
	if _player:
		_was_controllable = _player.controllable
		_player.set_controllable(false)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	_play_open_animation()


func close() -> void:
	if not _open or _transitioning:
		return
	if _settings_menu and _settings_menu.is_open():
		_settings_menu.cancel_and_close()
	_open = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	_play_close_animation()


func _exit_tree() -> void:
	if _background_blur_layer and is_instance_valid(_background_blur_layer):
		_background_blur_layer.queue_free()


func _input(event: InputEvent) -> void:
	if _transitioning:
		return
	if _settings_menu and _settings_menu.is_open():
		return
	if event.is_action_pressed("ui_cancel"):
		if _open:
			close()
		else:
			open()
		get_viewport().set_input_as_handled()


func _build_ui() -> void:
	_backdrop = ColorRect.new()
	_backdrop.color = COL_BACKDROP
	_backdrop.set_anchors_preset(Control.PRESET_FULL_RECT)
	_backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(_backdrop)

	_panel = PanelContainer.new()
	_panel.theme = _theme
	_panel.add_theme_stylebox_override("panel", _box(COL_PANEL, COL_BORDER, 4))
	_panel.custom_minimum_size = Vector2(360, 0)
	_panel.set_anchors_preset(Control.PRESET_CENTER)
	_panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
	_panel.grow_vertical = Control.GROW_DIRECTION_BOTH
	_backdrop.add_child(_panel)
	_panel_rest_position = _panel.position

	var margin := MarginContainer.new()
	for side in ["left", "right", "top", "bottom"]:
		margin.add_theme_constant_override("margin_" + side, 28)
	_panel.add_child(margin)

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


func _play_open_animation() -> void:
	_stop_transition()
	_transitioning = true
	_transition = create_tween()
	_transition.set_parallel()
	_transition.tween_property(_backdrop, "modulate:a", 1.0, 0.15)
	_transition.tween_property(_panel, "modulate:a", 1.0, 0.14).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	_transition.tween_property(_panel, "position", _panel_rest_position, 0.14).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	_transition.chain().tween_callback(func(): _transitioning = false)


func _play_close_animation() -> void:
	_stop_transition()
	_transitioning = true
	_transition = create_tween()
	_transition.set_parallel()
	_transition.tween_property(_backdrop, "modulate:a", 0.0, 0.10)
	_transition.tween_property(_panel, "modulate:a", 0.0, 0.09).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	_transition.tween_property(_panel, "position", _panel_rest_position + Vector2(0.0, 8.0), 0.10).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	_transition.chain().tween_callback(_finish_close)


func _finish_close() -> void:
	_transitioning = false
	visible = false
	_panel.position = _panel_rest_position
	_panel.modulate.a = 1.0
	if _background_blur_layer:
		_background_blur_layer.visible = false
	if _player:
		_player.set_controllable(_was_controllable and _player.is_alive)


func _stop_transition() -> void:
	if _transition and _transition.is_valid():
		_transition.kill()
	_transition = null


func _setup_background_blur() -> void:
	_background_blur_layer = CanvasLayer.new()
	_background_blur_layer.name = "PauseBackgroundBlurLayer"
	_background_blur_layer.layer = 19
	_background_blur_layer.visible = false
	get_parent().add_child(_background_blur_layer)
	_background_blur_layer.add_child(_make_background_blur())


func _make_background_blur() -> ColorRect:
	var blur := ColorRect.new()
	blur.name = "PauseBackgroundBlur"
	blur.set_anchors_preset(Control.PRESET_FULL_RECT)
	blur.color = Color.WHITE
	blur.modulate.a = 0.58
	blur.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var shader := load(BLUR_SHADER_PATH) as Shader
	if shader:
		var material := ShaderMaterial.new()
		material.shader = shader
		material.set_shader_parameter("blur_amount", 2.2)
		blur.material = material
	return blur


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
	if _background_blur_layer:
		_background_blur_layer.visible = false
	if _settings_menu:
		_settings_menu.open()


func _on_settings_closed() -> void:
	if _open:
		visible = true
		if _background_blur_layer:
			_background_blur_layer.visible = true


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
