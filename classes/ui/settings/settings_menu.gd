extends CanvasLayer

## 设置页只编辑玩家偏好草稿；PauseMenu 负责暂停与恢复玩家控制。

const FONT_PATH := "res://res/fonts/ConflictCJKUI.ttf"
const KeybindStore = preload("res://classes/ui/settings/keybind_store.gd")
const SettingsText = preload("res://classes/ui/settings/settings_text.gd")
const AnimatedToggle = preload("res://classes/ui/settings/animated_toggle.gd")
const BLUR_SHADER_PATH := "res://res/shaders/death_blur.gdshader"
const COL_BACKDROP := Color(0.0, 0.0, 0.0, 0.68)
const COL_PANEL := Color(0.063, 0.067, 0.075, 0.90)
const COL_SURFACE := Color(0.10, 0.106, 0.12, 0.76)
const COL_BORDER := Color(1.0, 1.0, 1.0, 0.11)
const COL_TEXT := Color(0.945, 0.953, 0.961)
const COL_MUTED := Color(0.61, 0.64, 0.68)
const COL_DANGER := Color(0.84, 0.42, 0.39)
const COL_DANGER_DIM := Color(0.84, 0.42, 0.39, 0.12)
const COL_HOVER := Color(1.0, 1.0, 1.0, 0.055)
## 提示气泡底色：必须接近不透明，否则文字与背后界面重叠看不清
const COL_TOOLTIP_BG := Color(0.043, 0.047, 0.055, 0.98)
const COL_VALUE_HIGHLIGHT := Color(1.0, 0.92, 0.52)

const CATEGORIES := [
	{ "id": "controls", "label": SettingsText.CATEGORY_CONTROLS },
	{ "id": "video", "label": SettingsText.CATEGORY_VIDEO, "available": false },
	{ "id": "audio", "label": SettingsText.CATEGORY_AUDIO, "available": false },
	{ "id": "interface", "label": SettingsText.CATEGORY_INTERFACE, "available": false },
	{ "id": "accessibility", "label": SettingsText.CATEGORY_ACCESSIBILITY, "available": false },
]

signal closed

var _open := false
var _settings_service
var _theme: Theme
var _background_blur_layer: CanvasLayer
var _backdrop: ColorRect
var _panel: PanelContainer
var _panel_rest_position := Vector2.ZERO
var _transition: Tween
var _transitioning := false
var _active_category := "controls"
var _category_buttons: Dictionary = {}
var _content_title: Label
var _content_subtitle: Label
var _content_rows: VBoxContainer
var _warning_label: Label
var _conflict_panel: PanelContainer
var _conflict_label: Label
var _key_buttons: Dictionary = {}

var _values_snapshot: Dictionary = {}
var _bindings_snapshot: Dictionary = {}
var _dirty := false
var _listening_action := ""
var _listening_slot := -1
var _listen_button: Button
var _listen_frame := 0
var _pending_event: InputEvent
var _pending_action := ""
var _pending_slot := -1
var _value_label_tweens: Dictionary = {}


func is_open() -> bool:
	return _open or _transitioning


func initialize(settings_service) -> void:
	_settings_service = settings_service


func _ready() -> void:
	layer = 21
	_theme = Theme.new()
	if ResourceLoader.exists(FONT_PATH):
		_theme.default_font = load(FONT_PATH)
	_theme.default_font_size = 15
	_setup_tooltip_style()
	_setup_background_blur()
	_build_ui()
	visible = false


func open() -> void:
	if _open or _transitioning:
		return
	_open = true
	_values_snapshot = _settings_service.snapshot()
	_bindings_snapshot = KeybindStore.snapshot_bindings()
	_dirty = false
	visible = true
	_panel_rest_position = _panel.position
	_backdrop.modulate.a = 0.0
	_panel.modulate.a = 0.0
	_panel.position = _panel_rest_position + Vector2(0.0, 8.0)
	if _background_blur_layer:
		_background_blur_layer.visible = true
	_select_category("controls")
	_play_open_animation()


func apply_changes() -> void:
	KeybindStore.save_all()
	var result: int = _settings_service.save_settings()
	if result != OK:
		_warning_label.text = SettingsText.SETTINGS_SAVE_ERROR % result
		_warning_label.visible = true
		return
	_values_snapshot = _settings_service.snapshot()
	_bindings_snapshot = KeybindStore.snapshot_bindings()
	_dirty = false
	_refresh_warning()


func cancel_and_close() -> void:
	_cancel_listening()
	_cancel_pending_conflict()
	_settings_service.restore_snapshot(_values_snapshot)
	KeybindStore.restore_bindings(_bindings_snapshot)
	_dirty = false
	_close()


func _close() -> void:
	if not _open or _transitioning:
		return
	_open = false
	_play_close_animation()


func _exit_tree() -> void:
	if _background_blur_layer and is_instance_valid(_background_blur_layer):
		_background_blur_layer.queue_free()


func _input(event: InputEvent) -> void:
	if not _open or _transitioning:
		return
	if _listening_action != "":
		_handle_listen_input(event)
		return
	if event.is_action_pressed("ui_cancel"):
		cancel_and_close()
		get_viewport().set_input_as_handled()


func _handle_listen_input(event: InputEvent) -> void:
	if Engine.get_process_frames() == _listen_frame:
		return
	if event is InputEventKey and event.pressed and not event.echo \
			and (event as InputEventKey).physical_keycode == KEY_ESCAPE:
		_cancel_listening()
		get_viewport().set_input_as_handled()
		return
	var input_event: InputEvent
	if event is InputEventKey and event.pressed and not event.echo:
		input_event = event.duplicate()
	elif event is InputEventMouseButton and event.pressed:
		input_event = event.duplicate()
	else:
		return
	var action := _listening_action
	var slot := _listening_slot
	_cancel_listening()
	var conflicts: Array[String] = KeybindStore.find_event_conflicts(input_event, action)
	if conflicts.is_empty():
		KeybindStore.rebind_action_slot(action, slot, input_event, false)
		_mark_dirty()
		_refresh_bindings()
	else:
		_show_conflict(action, slot, input_event, conflicts)
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
	_panel.custom_minimum_size = Vector2(1080, 650)
	_panel.set_anchors_preset(Control.PRESET_CENTER)
	_panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
	_panel.grow_vertical = Control.GROW_DIRECTION_BOTH
	_backdrop.add_child(_panel)
	_panel_rest_position = _panel.position

	var margin := MarginContainer.new()
	for side in ["left", "right", "top", "bottom"]:
		margin.add_theme_constant_override("margin_" + side, 26)
	_panel.add_child(margin)

	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 16)
	margin.add_child(root)
	_build_header(root)
	root.add_child(_divider())

	var body := HBoxContainer.new()
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 24)
	root.add_child(body)
	_build_sidebar(body)
	_build_content(body)

	_conflict_panel = PanelContainer.new()
	_conflict_panel.add_theme_stylebox_override("panel", _box(COL_DANGER_DIM, COL_DANGER, 3))
	_conflict_panel.visible = false
	root.add_child(_conflict_panel)
	_build_conflict_prompt(_conflict_panel)

	root.add_child(_divider())
	_build_footer(root)


## 提示气泡（未开放分类等）默认背景过于透明，文字会与下层界面叠在一起看不清。
## 这里给 TooltipPanel 一个近乎不透明的深色底并加描边，文字压在其上。
func _setup_tooltip_style() -> void:
	var box := _box(COL_TOOLTIP_BG, COL_BORDER, 3)
	box.content_margin_left = 12
	box.content_margin_right = 12
	box.content_margin_top = 8
	box.content_margin_bottom = 8
	_theme.set_stylebox("panel", "TooltipPanel", box)
	_theme.set_color("font_color", "TooltipLabel", COL_TEXT)
	_theme.set_font_size("font_size", "TooltipLabel", 13)
	if ResourceLoader.exists(FONT_PATH):
		_theme.set_font("font", "TooltipLabel", load(FONT_PATH))


func _setup_background_blur() -> void:
	_background_blur_layer = CanvasLayer.new()
	_background_blur_layer.name = "SettingsBackgroundBlurLayer"
	_background_blur_layer.layer = 19
	_background_blur_layer.visible = false
	get_parent().add_child(_background_blur_layer)
	_background_blur_layer.add_child(_make_background_blur())


func _make_background_blur() -> ColorRect:
	var blur := ColorRect.new()
	blur.name = "SettingsBackgroundBlur"
	blur.set_anchors_preset(Control.PRESET_FULL_RECT)
	blur.color = Color.WHITE
	blur.modulate.a = 0.72
	blur.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var shader := load(BLUR_SHADER_PATH) as Shader
	if shader:
		var material := ShaderMaterial.new()
		material.shader = shader
		material.set_shader_parameter("blur_amount", 3.0)
		blur.material = material
	return blur


func _build_header(parent: Control) -> void:
	var header := HBoxContainer.new()
	parent.add_child(header)
	var titles := VBoxContainer.new()
	titles.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	titles.add_theme_constant_override("separation", 2)
	header.add_child(titles)
	var title := Label.new()
	title.text = SettingsText.SETTINGS_TITLE
	title.add_theme_font_size_override("font_size", 24)
	title.add_theme_color_override("font_color", COL_TEXT)
	titles.add_child(title)
	var subtitle := Label.new()
	subtitle.text = SettingsText.SETTINGS_SUBTITLE
	subtitle.add_theme_font_size_override("font_size", 13)
	subtitle.add_theme_color_override("font_color", COL_MUTED)
	titles.add_child(subtitle)


func _build_sidebar(parent: Control) -> void:
	var sidebar := VBoxContainer.new()
	sidebar.custom_minimum_size = Vector2(170, 0)
	sidebar.add_theme_constant_override("separation", 4)
	parent.add_child(sidebar)
	for category in CATEGORIES:
		var button := Button.new()
		button.text = category["label"]
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.custom_minimum_size = Vector2(0, 38)
		button.focus_mode = Control.FOCUS_ALL
		button.tooltip_text = SettingsText.SETTINGS_UNAVAILABLE_TOOLTIP if category.get("available", true) == false else ""
		button.disabled = category.get("available", true) == false
		button.pressed.connect(_select_category.bind(category["id"]))
		sidebar.add_child(button)
		_category_buttons[category["id"]] = button


func _build_content(parent: Control) -> void:
	var content := VBoxContainer.new()
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content.add_theme_constant_override("separation", 8)
	parent.add_child(content)
	_content_title = Label.new()
	_content_title.add_theme_font_size_override("font_size", 19)
	_content_title.add_theme_color_override("font_color", COL_TEXT)
	content.add_child(_content_title)
	_content_subtitle = Label.new()
	_content_subtitle.add_theme_font_size_override("font_size", 13)
	_content_subtitle.add_theme_color_override("font_color", COL_MUTED)
	content.add_child(_content_subtitle)
	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	content.add_child(scroll)
	_content_rows = VBoxContainer.new()
	_content_rows.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_content_rows.add_theme_constant_override("separation", 4)
	scroll.add_child(_content_rows)
	_warning_label = Label.new()
	_warning_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_warning_label.add_theme_font_size_override("font_size", 13)
	_warning_label.add_theme_color_override("font_color", COL_DANGER)
	_warning_label.visible = false
	content.add_child(_warning_label)


func _build_footer(parent: Control) -> void:
	var footer := HBoxContainer.new()
	footer.add_theme_constant_override("separation", 10)
	parent.add_child(footer)
	var reset := Button.new()
	reset.text = SettingsText.SETTINGS_RESTORE_PAGE
	reset.custom_minimum_size = Vector2(140, 40)
	_style_ghost(reset)
	reset.pressed.connect(_reset_current_page)
	footer.add_child(reset)
	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	footer.add_child(spacer)
	var cancel := Button.new()
	cancel.text = SettingsText.SETTINGS_CANCEL
	cancel.custom_minimum_size = Vector2(110, 40)
	_style_ghost(cancel)
	cancel.pressed.connect(cancel_and_close)
	footer.add_child(cancel)
	var apply := Button.new()
	apply.text = SettingsText.SETTINGS_APPLY
	apply.custom_minimum_size = Vector2(110, 40)
	_style_primary(apply)
	apply.pressed.connect(apply_changes)
	footer.add_child(apply)


func _build_conflict_prompt(parent: Control) -> void:
	var margin := MarginContainer.new()
	for side in ["left", "right", "top", "bottom"]:
		margin.add_theme_constant_override("margin_" + side, 12)
	parent.add_child(margin)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	margin.add_child(row)
	_conflict_label = Label.new()
	_conflict_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_conflict_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_conflict_label.add_theme_color_override("font_color", COL_TEXT)
	row.add_child(_conflict_label)
	var replace := Button.new()
	replace.text = SettingsText.CONFLICT_REPLACE
	_style_primary(replace)
	replace.pressed.connect(_resolve_conflict.bind(true))
	row.add_child(replace)
	var keep := Button.new()
	keep.text = SettingsText.CONFLICT_KEEP
	_style_ghost(keep)
	keep.pressed.connect(_resolve_conflict.bind(false))
	row.add_child(keep)
	var dismiss := Button.new()
	dismiss.text = SettingsText.SETTINGS_CANCEL
	_style_ghost(dismiss)
	dismiss.pressed.connect(_cancel_pending_conflict)
	row.add_child(dismiss)


func _select_category(category: String) -> void:
	_active_category = category
	for id in _category_buttons:
		_style_category(_category_buttons[id], id == category)
	_clear_content()
	match category:
		"controls":
			_build_controls_page()
		_:
			_build_placeholder_page(category)


func _build_controls_page() -> void:
	_content_title.text = SettingsText.CATEGORY_CONTROLS
	_content_subtitle.text = SettingsText.CONTROLS_SUBTITLE
	_add_section(SettingsText.SECTION_MOUSE_AND_OPTICS)
	_add_slider_row(SettingsText.CONTROL_SENSITIVITY, SettingsText.CONTROL_SENSITIVITY_HINT, "controls/sensitivity", 0.10, 3.00, 0.05)
	_add_toggle_row(SettingsText.CONTROL_INVERT_Y, SettingsText.CONTROL_INVERT_Y_HINT, "controls/invert_y")
	_add_section(SettingsText.SECTION_KEYBINDS)
	var current_category := ""
	for entry in KeybindStore.ACTIONS:
		if entry.get("debug_only", false) and not OS.is_debug_build():
			continue
		if entry["category"] != current_category:
			current_category = entry["category"]
			_add_binding_group(current_category)
		_add_bind_row(entry)
	_refresh_bindings()


func _build_placeholder_page(category: String) -> void:
	_content_title.text = str(category).capitalize()
	_content_subtitle.text = SettingsText.SETTINGS_PLACEHOLDER_SUBTITLE
	_add_section(SettingsText.SETTINGS_COMING_SOON)
	var label := Label.new()
	label.text = SettingsText.SETTINGS_NO_FAKE_OPTIONS
	label.add_theme_color_override("font_color", COL_MUTED)
	_content_rows.add_child(label)


func _add_section(text: String) -> void:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 14)
	label.add_theme_color_override("font_color", COL_TEXT)
	label.add_theme_constant_override("outline_size", 0)
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_top", 14)
	margin.add_theme_constant_override("margin_bottom", 4)
	margin.add_child(label)
	_content_rows.add_child(margin)


func _add_binding_group(text: String) -> void:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 12)
	label.add_theme_color_override("font_color", COL_MUTED)
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_top", 8)
	margin.add_theme_constant_override("margin_bottom", 2)
	margin.add_child(label)
	_content_rows.add_child(margin)


func _add_slider_row(title: String, description: String, key: String, minimum: float, maximum: float, step: float) -> void:
	var row := _new_row()
	var labels := _add_row_labels(row, title, description)
	var value_label := Label.new()
	value_label.custom_minimum_size = Vector2(48, 0)
	value_label.pivot_offset = Vector2(24.0, 10.0)
	value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	value_label.add_theme_color_override("font_color", COL_TEXT)
	row.add_child(value_label)
	var slider := HSlider.new()
	slider.custom_minimum_size = Vector2(260, 24)
	_style_slider(slider)
	slider.min_value = minimum
	slider.max_value = maximum
	slider.step = step
	slider.value = float(_settings_service.get_value(key))
	value_label.text = "%.2f" % slider.value
	slider.value_changed.connect(func(value: float):
		value_label.text = "%.2f" % value
		_settings_service.set_value(key, value)
		_mark_dirty()
		_pulse_value_label(value_label, true)
	)
	slider.drag_ended.connect(func(_value_changed: bool):
		_pulse_value_label(value_label, false)
	)
	row.add_child(slider)


func _style_slider(slider: HSlider) -> void:
	var track := StyleBoxFlat.new()
	track.bg_color = Color(1.0, 1.0, 1.0, 0.14)
	track.set_corner_radius_all(0)
	track.content_margin_top = 5.0
	track.content_margin_bottom = 5.0
	slider.add_theme_stylebox_override("slider", track)

	var active_track := StyleBoxFlat.new()
	active_track.bg_color = Color(1.0, 1.0, 1.0, 0.76)
	active_track.set_corner_radius_all(0)
	active_track.content_margin_top = 5.0
	active_track.content_margin_bottom = 5.0
	slider.add_theme_stylebox_override("grabber_area", active_track)
	slider.add_theme_icon_override("grabber", _make_slider_grabber(Color(0.96, 0.96, 0.96)))
	slider.add_theme_icon_override("grabber_highlight", _make_slider_grabber(Color.WHITE))


func _make_slider_grabber(color: Color) -> GradientTexture2D:
	var gradient := Gradient.new()
	gradient.colors = PackedColorArray([color, color])
	var texture := GradientTexture2D.new()
	texture.gradient = gradient
	texture.width = 14
	texture.height = 22
	texture.fill_from = Vector2(0.0, 0.5)
	texture.fill_to = Vector2(1.0, 0.5)
	return texture


func _pulse_value_label(label: Label, active: bool) -> void:
	var old_tween := _value_label_tweens.get(label) as Tween
	if old_tween and old_tween.is_valid():
		old_tween.kill()
	var target_scale := Vector2(1.07, 1.07) if active else Vector2.ONE
	var target_modulate := COL_VALUE_HIGHLIGHT if active else Color.WHITE
	var tween := create_tween()
	tween.set_parallel()
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT if active else Tween.EASE_IN_OUT)
	tween.tween_property(label, "scale", target_scale, 0.12 if active else 0.18)
	tween.tween_property(label, "modulate", target_modulate, 0.12 if active else 0.18)
	_value_label_tweens[label] = tween


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
	closed.emit()


func _stop_transition() -> void:
	if _transition and _transition.is_valid():
		_transition.kill()
	_transition = null


func _add_toggle_row(title: String, description: String, key: String) -> void:
	var row := _new_row()
	_add_row_labels(row, title, description)
	var toggle := AnimatedToggle.new()
	toggle.button_pressed = bool(_settings_service.get_value(key))
	toggle.toggled.connect(func(enabled: bool):
		_settings_service.set_value(key, enabled)
		_mark_dirty()
	)
	row.add_child(toggle)


func _add_bind_row(entry: Dictionary) -> void:
	var action: String = entry["action"]
	var row := _new_row()
	var name := Label.new()
	name.text = entry["display"]
	name.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name.add_theme_color_override("font_color", COL_TEXT)
	row.add_child(name)
	for slot in 2:
		var button := Button.new()
		button.custom_minimum_size = Vector2(135, 34)
		button.focus_mode = Control.FOCUS_ALL
		button.tooltip_text = SettingsText.BIND_TOOLTIP
		button.pressed.connect(_begin_listen.bind(action, slot, button))
		button.gui_input.connect(func(event: InputEvent):
			if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
				KeybindStore.clear_action_slot(action, slot, false)
				_mark_dirty()
				_refresh_bindings()
				button.accept_event()
		)
		row.add_child(button)
		_key_buttons[_button_id(action, slot)] = button


func _new_row() -> HBoxContainer:
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", _box(Color(1, 1, 1, 0.0), Color(1, 1, 1, 0.0), 3))
	panel.mouse_entered.connect(func(): panel.add_theme_stylebox_override("panel", _box(COL_HOVER, Color(1, 1, 1, 0.0), 3)) )
	panel.mouse_exited.connect(func(): panel.add_theme_stylebox_override("panel", _box(Color(1, 1, 1, 0.0), Color(1, 1, 1, 0.0), 3)) )
	_content_rows.add_child(panel)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	panel.add_child(row)
	return row


func _add_row_labels(row: Control, title: String, description: String) -> VBoxContainer:
	var labels := VBoxContainer.new()
	labels.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	labels.add_theme_constant_override("separation", 1)
	row.add_child(labels)
	var name := Label.new()
	name.text = title
	name.add_theme_color_override("font_color", COL_TEXT)
	labels.add_child(name)
	var hint := Label.new()
	hint.text = description
	hint.add_theme_font_size_override("font_size", 12)
	hint.add_theme_color_override("font_color", COL_MUTED)
	labels.add_child(hint)
	return labels


func _begin_listen(action: String, slot: int, button: Button) -> void:
	_cancel_pending_conflict()
	_cancel_listening()
	_listening_action = action
	_listening_slot = slot
	_listen_button = button
	_listen_frame = Engine.get_process_frames()
	_listen_button.text = SettingsText.BIND_LISTENING
	_style_key_button(_listen_button, true, false)


func _cancel_listening() -> void:
	if _listening_action == "":
		return
	var action := _listening_action
	var slot := _listening_slot
	_listening_action = ""
	_listening_slot = -1
	_listen_button = null
	var button: Button = _key_buttons.get(_button_id(action, slot))
	if button:
		_refresh_key_button(action, slot, button)


func _show_conflict(action: String, slot: int, event: InputEvent, conflicts: Array[String]) -> void:
	_pending_action = action
	_pending_slot = slot
	_pending_event = event
	var names: Array[String] = []
	for conflict in conflicts:
		names.append(_action_display_name(conflict))
	_conflict_label.text = SettingsText.CONFLICT_TEMPLATE % [KeybindStore.describe_event(event), "、".join(names)]
	_conflict_panel.visible = true


func _resolve_conflict(replace: bool) -> void:
	if not _pending_event:
		return
	if replace:
		KeybindStore.replace_conflicts_and_rebind(_pending_action, _pending_slot, _pending_event, false)
	else:
		KeybindStore.rebind_action_slot(_pending_action, _pending_slot, _pending_event, false)
	_mark_dirty()
	_cancel_pending_conflict()
	_refresh_bindings()


func _cancel_pending_conflict() -> void:
	_pending_event = null
	_pending_action = ""
	_pending_slot = -1
	if _conflict_panel:
		_conflict_panel.visible = false


func _reset_current_page() -> void:
	if _active_category != "controls":
		return
	_settings_service.reset_controls()
	KeybindStore.reset_all(false)
	_mark_dirty()
	_select_category("controls")


func _clear_content() -> void:
	_key_buttons.clear()
	for child in _content_rows.get_children():
		child.queue_free()


func _refresh_bindings() -> void:
	for entry in KeybindStore.ACTIONS:
		var action: String = entry["action"]
		for slot in 2:
			var button: Button = _key_buttons.get(_button_id(action, slot))
			if button:
				_refresh_key_button(action, slot, button)
	_refresh_warning()


func _refresh_key_button(action: String, slot: int, button: Button) -> void:
	var conflict := not KeybindStore.find_conflicts(action).is_empty()
	button.text = KeybindStore.describe_action_slot(action, slot)
	_style_key_button(button, false, conflict)


func _refresh_warning() -> void:
	if not _warning_label:
		return
	var has_conflict := false
	for entry in KeybindStore.ACTIONS:
		if not KeybindStore.find_conflicts(entry["action"]).is_empty():
			has_conflict = true
			break
	_warning_label.visible = has_conflict
	if has_conflict:
		_warning_label.text = SettingsText.CONFLICT_WARNING


func _mark_dirty() -> void:
	_dirty = true


func _action_display_name(action: String) -> String:
	for entry in KeybindStore.ACTIONS:
		if entry["action"] == action:
			return entry["display"]
	return action


func _button_id(action: String, slot: int) -> String:
	return action + ":" + str(slot)


func _style_category(button: Button, selected: bool) -> void:
	button.add_theme_stylebox_override("normal", _box(Color(1, 1, 1, 0.07) if selected else Color(1, 1, 1, 0.0), Color.WHITE if selected else Color(1, 1, 1, 0.0), 2, 1 if selected else 0))
	button.add_theme_stylebox_override("hover", _box(COL_HOVER, Color(1, 1, 1, 0.35), 2))
	button.add_theme_stylebox_override("focus", _box(COL_HOVER, Color.WHITE, 2, 2))
	button.add_theme_color_override("font_color", COL_TEXT if selected else COL_MUTED)
	button.add_theme_color_override("font_disabled_color", Color(0.4, 0.42, 0.45))


func _style_key_button(button: Button, listening: bool, conflict: bool) -> void:
	var background := COL_SURFACE
	var border := COL_BORDER
	var text := COL_TEXT
	if listening:
		background = Color(1, 1, 1, 0.13)
		border = Color.WHITE
	elif conflict:
		background = COL_DANGER_DIM
		border = COL_DANGER
		text = COL_DANGER
	button.add_theme_stylebox_override("normal", _box(background, border, 3))
	button.add_theme_stylebox_override("hover", _box(COL_HOVER if not conflict else COL_DANGER_DIM, Color.WHITE if not conflict else COL_DANGER, 3))
	button.add_theme_stylebox_override("focus", _box(background, Color.WHITE if not conflict else COL_DANGER, 3, 2))
	button.add_theme_color_override("font_color", text)


func _style_ghost(button: Button) -> void:
	button.add_theme_stylebox_override("normal", _box(Color(1, 1, 1, 0.0), COL_BORDER, 3))
	button.add_theme_stylebox_override("hover", _box(COL_HOVER, Color(1, 1, 1, 0.38), 3))
	button.add_theme_stylebox_override("focus", _box(COL_HOVER, Color.WHITE, 3, 2))
	button.add_theme_color_override("font_color", COL_TEXT)


func _style_primary(button: Button) -> void:
	button.add_theme_stylebox_override("normal", _box(Color(1, 1, 1, 0.94), Color.WHITE, 3))
	button.add_theme_stylebox_override("hover", _box(Color.WHITE, Color.WHITE, 3))
	button.add_theme_stylebox_override("focus", _box(Color.WHITE, Color.WHITE, 3, 2))
	button.add_theme_color_override("font_color", Color(0.045, 0.047, 0.05))
	button.add_theme_color_override("font_hover_color", Color(0.045, 0.047, 0.05))
	button.add_theme_color_override("font_pressed_color", Color(0.045, 0.047, 0.05))
	button.add_theme_color_override("font_focus_color", Color(0.045, 0.047, 0.05))


func _divider() -> ColorRect:
	var divider := ColorRect.new()
	divider.color = COL_BORDER
	divider.custom_minimum_size = Vector2(0, 1)
	return divider


func _box(background: Color, border: Color, radius: int, border_width: int = 1) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = background
	box.border_color = border
	box.set_border_width_all(border_width)
	box.set_corner_radius_all(radius)
	box.content_margin_left = 10
	box.content_margin_right = 10
	box.content_margin_top = 7
	box.content_margin_bottom = 7
	return box
