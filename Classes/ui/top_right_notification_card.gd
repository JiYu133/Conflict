class_name TopRightNotificationCard
extends Control

signal dismissed(notification_id: StringName)

var entry: TopRightNotificationEntry
var _config: TopRightNotificationConfig
var _panel: PanelContainer
var _icon: TextureRect
var _symbol: Label
var _message: Label
var _is_exiting: bool = false


func setup(new_entry: TopRightNotificationEntry, new_config: TopRightNotificationConfig) -> void:
	entry = new_entry
	_config = new_config
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	custom_minimum_size = Vector2(
		_config.card_width,
		maxf(_config.icon_size, float(_config.font_size)) + _config.card_padding * 2.0
	)
	_build_ui()
	_apply_style()
	refresh()


func refresh() -> void:
	if not entry:
		return
	_icon.texture = entry.icon
	_icon.visible = entry.icon != null
	_symbol.text = entry.symbol
	_symbol.visible = entry.icon == null and not entry.symbol.is_empty()
	_message.text = entry.text


func play_enter() -> void:
	_panel.position.x = _config.card_width
	_panel.modulate.a = 0.0
	var tween := create_tween().set_parallel(true)
	tween.tween_property(_panel, "position:x", 0.0, _config.slide_in_duration) \
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(_panel, "modulate:a", 1.0, _config.slide_in_duration * 0.75) \
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	if entry.duration > 0.0:
		await get_tree().create_timer(entry.duration).timeout
		play_exit()


func play_exit() -> void:
	if _is_exiting:
		return
	_is_exiting = true
	var tween := create_tween().set_parallel(true)
	tween.tween_property(_panel, "position:x", _config.card_width, _config.slide_out_duration) \
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_property(_panel, "modulate:a", 0.0, _config.slide_out_duration) \
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	await tween.finished
	dismissed.emit(entry.notification_id)
	queue_free()


func _build_ui() -> void:
	_panel = PanelContainer.new()
	_panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_panel)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	_panel.add_child(row)

	_icon = TextureRect.new()
	_icon.custom_minimum_size = Vector2(_config.icon_size, _config.icon_size)
	_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	row.add_child(_icon)

	_symbol = Label.new()
	_symbol.custom_minimum_size.x = _config.symbol_width
	_symbol.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_symbol.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_symbol.add_theme_font_size_override("font_size", _config.symbol_font_size)
	_symbol.add_theme_color_override("font_color", _config.symbol_color)
	if _config.font:
		_symbol.add_theme_font_override("font", _config.font)
	row.add_child(_symbol)

	_message = Label.new()
	_message.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_message.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_message.add_theme_font_size_override("font_size", _config.font_size)
	_message.add_theme_color_override("font_color", _config.text_color)
	if _config.font:
		_message.add_theme_font_override("font", _config.font)
	row.add_child(_message)


func _apply_style() -> void:
	var style := StyleBoxFlat.new()
	style.bg_color = _config.card_background
	style.border_width_left = 3
	style.border_color = entry.accent_color
	style.corner_radius_top_left = _config.card_corner_radius
	style.corner_radius_top_right = _config.card_corner_radius
	style.corner_radius_bottom_left = _config.card_corner_radius
	style.corner_radius_bottom_right = _config.card_corner_radius
	style.content_margin_left = _config.card_padding
	style.content_margin_right = _config.card_padding
	style.content_margin_top = _config.card_padding
	style.content_margin_bottom = _config.card_padding
	_panel.add_theme_stylebox_override("panel", style)
