class_name RadialMenu
extends Control

const RadialMenuConfigScript := preload("res://classes/ui/radial_menu_config.gd")
const FONT_PATH := "res://assets/fonts/ConflictCJKUI.ttf"

var options: Array[RadialMenuOption] = []
var selected_index := -1
var _labels: Array[Label] = []
var _icons: Array[TextureRect] = []
var _font: Font
var _config: RadialMenuConfig


## 注入由 .tres 提供的视觉参数；未注入时使用脚本默认配置。
func configure(new_config: RadialMenuConfig) -> void:
	_config = new_config if new_config else RadialMenuConfigScript.new() as RadialMenuConfig


func _ready() -> void:
	if not _config:
		_config = RadialMenuConfigScript.new() as RadialMenuConfig
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	if ResourceLoader.exists(FONT_PATH):
		_font = load(FONT_PATH) as Font
	visible = false


func show_options(new_options: Array[RadialMenuOption], _new_page_index: int = 0, _new_page_count: int = 1) -> void:
	options = new_options
	selected_index = -1
	visible = true
	_rebuild_labels()
	queue_redraw()


func hide_menu() -> void:
	visible = false
	options.clear()
	selected_index = -1
	_clear_labels()
	queue_redraw()


func get_selected_option() -> RadialMenuOption:
	if selected_index < 0 or selected_index >= options.size():
		return null
	return options[selected_index]


func update_pointer(pointer: Vector2) -> void:
	if not visible:
		return
	var center := size * 0.5
	var delta := pointer - center
	if delta.length() < _inner_radius():
		_set_selected(-1)
		return
	var angle := fposmod(atan2(delta.y, delta.x) + PI * 0.5, TAU)
	_set_selected(int(floor(angle / (TAU / max(options.size(), 1)))))


func update_stick(stick: Vector2) -> void:
	if stick.length() >= 0.25:
		update_pointer(size * 0.5 + stick.normalized() * _outer_radius())


func move_selection(step: int) -> void:
	if options.is_empty():
		return
	var next := selected_index + step
	if selected_index < 0:
		next = 0 if step >= 0 else options.size() - 1
	_set_selected(posmod(next, options.size()))


func _set_selected(index: int) -> void:
	if selected_index == index:
		return
	selected_index = index
	_layout_labels()
	_restyle_labels()
	queue_redraw()


func _make_label(font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	if _font:
		label.add_theme_font_override("font", _font)
	return label


func _rebuild_labels() -> void:
	_clear_labels()
	var count := options.size()
	if count == 0:
		return
	for i in count:
		var label := _make_label(_config.label_font_size, _config.text_color)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.text = options[i].title.to_upper()
		label.size = _config.label_size
		label.pivot_offset = _config.label_size * 0.5
		_labels.append(label)
		add_child(label)
		_add_icon_if_configured(options[i], label, i)
	_layout_labels()
	_restyle_labels()


func _clear_labels() -> void:
	for label in _labels:
		if is_instance_valid(label):
			label.queue_free()
	_labels.clear()
	for icon in _icons:
		if is_instance_valid(icon):
			icon.queue_free()
	_icons.clear()


## 图标扩展点：配置 show_icons 且选项提供 icon_texture 后才会创建节点。
func _add_icon_if_configured(option: RadialMenuOption, label: Label, label_index: int) -> void:
	if not _config.show_icons or not option.icon_texture:
		return
	var icon := TextureRect.new()
	icon.texture = option.icon_texture
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	icon.size = _config.icon_size
	icon.set_meta("label_index", label_index)
	icon.position = label.position + Vector2((_config.label_size.x - _config.icon_size.x) * 0.5, -_config.icon_size.y - 2.0)
	_icons.append(icon)
	add_child(icon)


func _layout_icons() -> void:
	for icon in _icons:
		var label_index := int(icon.get_meta("label_index", -1))
		if label_index < 0 or label_index >= _labels.size():
			continue
		var item_scale := _config.selected_scale if label_index == selected_index else 1.0
		icon.scale = Vector2.ONE * item_scale
		icon.position = _labels[label_index].position + Vector2(
			(_config.label_size.x - _config.icon_size.x) * 0.5,
			-_config.icon_size.y - 2.0
		) * item_scale


func _layout_labels() -> void:
	var count := options.size()
	if count == 0:
		return
	var center := size * 0.5
	for i in _labels.size():
		var item_scale := _config.selected_scale if i == selected_index else 1.0
		var direction := Vector2.from_angle(-PI * 0.5 + (i + 0.5) * TAU / count)
		_labels[i].scale = Vector2.ONE * item_scale
		_labels[i].position = center + direction * _label_radius() * item_scale - _config.label_size * 0.5
	_layout_icons()


func _restyle_labels() -> void:
	for i in _labels.size():
		var label := _labels[i]
		var option := options[i]
		var color := _config.disabled_text_color if not option.is_enabled else (_config.text_color if i != selected_index else Color.WHITE)
		label.add_theme_color_override("font_color", color)
		label.modulate = Color(1.0, 1.0, 1.0, 0.72) if not option.is_enabled else (Color(0.82, 0.82, 0.82) if option.is_current and i != selected_index else Color.WHITE)


func _outer_radius() -> float:
	return minf(size.x, size.y) * _config.menu_radius_ratio


func _inner_radius() -> float:
	return _outer_radius() * _config.inner_radius_ratio


func _label_radius() -> float:
	return _outer_radius() * _config.label_radius_ratio


func _arc_points(center: Vector2, radius: float, start: float, finish: float, steps: int = 16) -> PackedVector2Array:
	var points := PackedVector2Array()
	for j in steps + 1:
		points.append(center + Vector2.from_angle(lerpf(start, finish, float(j) / float(steps))) * radius)
	return points


func _draw() -> void:
	if not visible:
		return
	var center := size * 0.5
	var outer_radius := _outer_radius()
	var inner_radius := _inner_radius()
	var count := options.size()
	if count == 0:
		return
	for i in count:
		var start := -PI * 0.5 + i * TAU / count + _config.sector_gap
		var finish := -PI * 0.5 + (i + 1) * TAU / count - _config.sector_gap
		var item_scale := _config.selected_scale if i == selected_index else 1.0
		var item_outer_radius := outer_radius * item_scale
		var item_inner_radius := inner_radius * item_scale
		# 端面仍是直线，但内侧端点向模块中线收拢，减少“指向圆心”的倾斜感。
		var inner_start := start + _config.side_flatten_angle
		var inner_finish := finish - _config.side_flatten_angle
		var points := _arc_points(center, item_outer_radius, start, finish)
		var inner_points := _arc_points(center, item_inner_radius, inner_finish, inner_start)
		points.append_array(inner_points)
		var option := options[i]
		var fill := _config.disabled_color if not option.is_enabled else (_config.panel_selected_color if i == selected_index else _config.panel_color)
		draw_colored_polygon(points, fill)
		var edge := _config.border_selected_color if i == selected_index else (_config.border_current_color if option.is_current else _config.border_color)
		draw_polyline(_arc_points(center, item_outer_radius, start, finish), edge, 1.0, true)
		draw_polyline(_arc_points(center, item_inner_radius, inner_finish, inner_start), edge, 1.0, true)
		draw_line(center + Vector2.from_angle(inner_start) * item_inner_radius, center + Vector2.from_angle(start) * item_outer_radius, edge, 1.0, true)
		draw_line(center + Vector2.from_angle(inner_finish) * item_inner_radius, center + Vector2.from_angle(finish) * item_outer_radius, edge, 1.0, true)
