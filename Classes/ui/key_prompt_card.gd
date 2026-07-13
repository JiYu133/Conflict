class_name KeyPromptCard
extends PanelContainer

signal dismissed

var _config: KeyPromptConfig
var _entry: KeyPromptEntry
var _tween: Tween
var _dismiss_timer: SceneTreeTimer

var _icon: TextureRect
var _label: Label

# Manager 在重排时设置此值，供 reposition_to 使用
var target_y: float = 0.0


func setup(entry: KeyPromptEntry, config: KeyPromptConfig) -> void:
	_entry = entry
	_config = config
	_build_ui()
	_apply_style()


func play_enter() -> void:
	if _tween:
		_tween.kill()

	# 先等一帧，让 PanelContainer 完成 minimum_size 计算
	await get_tree().process_frame

	var slide_offset := size.x + (_config.margin_right if _config else 24.0)
	position.x = slide_offset
	modulate.a = 0.0

	var dur := _config.slide_in_duration if _config else 0.22
	var ease_type := _config.ease_in if _config else Tween.EASE_OUT

	_tween = create_tween().set_parallel(true)
	_tween.tween_property(self, "position:x", 0.0, dur).set_trans(Tween.TRANS_CUBIC).set_ease(ease_type)
	_tween.tween_property(self, "modulate:a", 1.0, dur * 0.7).set_trans(Tween.TRANS_CUBIC).set_ease(ease_type)

	await _tween.finished

	var d := _entry.duration if _entry else 4.0
	if d > 0.0:
		_dismiss_timer = get_tree().create_timer(d)
		_dismiss_timer.timeout.connect(_on_dismiss_timeout)


func play_exit() -> void:
	if _tween:
		_tween.kill()
	if _dismiss_timer:
		# SceneTreeTimer 没有 disconnect 方法，用守卫替代
		_dismiss_timer = null

	var slide_offset := size.x + (_config.margin_right if _config else 24.0)
	var dur := _config.slide_out_duration if _config else 0.18
	var ease_type := _config.ease_out if _config else Tween.EASE_IN

	_tween = create_tween().set_parallel(true)
	_tween.tween_property(self, "position:x", slide_offset, dur).set_trans(Tween.TRANS_CUBIC).set_ease(ease_type)
	_tween.tween_property(self, "modulate:a", 0.0, dur).set_trans(Tween.TRANS_CUBIC).set_ease(ease_type)

	await _tween.finished
	dismissed.emit()
	queue_free()


func reposition_to(new_y: float) -> void:
	target_y = new_y
	var dur := _config.reposition_duration if _config else 0.15
	create_tween().tween_property(self, "position:y", new_y, dur).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)


# ── 内部构建 ──────────────────────────────────────────────

func _build_ui() -> void:
	var hbox := HBoxContainer.new()
	hbox.add_theme_constant_override("separation", int(_config.icon_label_gap if _config else 10.0))
	add_child(hbox)

	_icon = TextureRect.new()
	_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var icon_px := int(_config.icon_size if _config else 40.0)
	_icon.custom_minimum_size = Vector2(icon_px, icon_px)
	if _entry and _entry.key_icon:
		_icon.texture = _entry.key_icon
	hbox.add_child(_icon)

	_label = Label.new()
	_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_label.autowrap_mode = TextServer.AUTOWRAP_OFF
	_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	if _entry:
		_label.text = _entry.label_text
	if _config:
		_label.add_theme_font_size_override("font_size", _config.font_size)
		_label.add_theme_color_override("font_color", _config.text_color)
		if _config.custom_font:
			_label.add_theme_font_override("font", _config.custom_font)
	hbox.add_child(_label)


func _apply_style() -> void:
	var style := StyleBoxFlat.new()
	style.bg_color = _config.card_bg_color if _config else Color(0.05, 0.05, 0.05, 0.82)
	var radius := _config.card_corner_radius if _config else 6
	style.corner_radius_top_left = radius
	style.corner_radius_top_right = radius
	style.corner_radius_bottom_left = radius
	style.corner_radius_bottom_right = radius
	var pad := int(_config.card_padding if _config else 10.0)
	style.content_margin_left = pad
	style.content_margin_right = pad
	style.content_margin_top = pad
	style.content_margin_bottom = pad
	add_theme_stylebox_override("panel", style)


func _on_dismiss_timeout() -> void:
	if not is_inside_tree():
		return
	if _dismiss_timer == null:
		# play_exit 已将 _dismiss_timer 置 null，说明卡片正在手动滑出
		return
	play_exit()
