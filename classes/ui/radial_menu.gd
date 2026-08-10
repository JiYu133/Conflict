class_name RadialMenu
extends Control

const FONT_PATH := "res://assets/fonts/ConflictCJKUI.ttf"
const COL_BACKDROP := Color(0.0, 0.0, 0.0, 0.24)
const COL_PANEL := Color(0.10, 0.10, 0.10, 0.76)
const COL_PANEL_SELECTED := Color(0.42, 0.42, 0.42, 0.86)
const COL_BORDER := Color(0.78, 0.78, 0.78, 0.42)
const COL_BORDER_SELECTED := Color(0.98, 0.98, 0.98, 0.96)
const COL_TEXT := Color(0.94, 0.94, 0.94, 1.0)
const COL_MUTED := Color(0.68, 0.68, 0.68, 1.0)
const COL_DISABLED := Color(0.20, 0.20, 0.20, 0.58)
const COL_DISABLED_TEXT := Color(0.46, 0.46, 0.46, 1.0)
const RADIUS := 230.0
const INNER_RADIUS := 92.0
const LABEL_RADIUS := 158.0

var options: Array[RadialMenuOption] = []
var selected_index := -1
var page_index := 0
var page_count := 1
var _labels: Array[Label] = []
var _center_icon: Label
var _center_title: Label
var _center_description: Label
var _center_reason: Label
var _prompt: Label
var _page_label: Label
var _font: Font


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	if ResourceLoader.exists(FONT_PATH):
		_font = load(FONT_PATH) as Font
	_build_center_labels()
	visible = false


func show_options(new_options: Array[RadialMenuOption], new_page_index: int = 0, new_page_count: int = 1) -> void:
	options = new_options
	page_index = new_page_index
	page_count = max(new_page_count, 1)
	selected_index = -1
	visible = true
	_rebuild_labels()
	_update_center()
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
	if delta.length() < INNER_RADIUS:
		_set_selected(-1)
		return
	var angle := fposmod(atan2(delta.y, delta.x) + PI * 0.5, TAU)
	_set_selected(int(floor(angle / (TAU / max(options.size(), 1)))))


func update_stick(stick: Vector2) -> void:
	if stick.length() >= 0.25:
		update_pointer(size * 0.5 + stick.normalized() * RADIUS)


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
	_update_center()
	_restyle_labels()
	queue_redraw()


func _build_center_labels() -> void:
	_center_icon = _make_label(42, COL_TEXT)
	_center_icon.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_center_icon.set_anchors_preset(Control.PRESET_CENTER)
	_center_icon.position = Vector2(-42, -120)
	_center_icon.size = Vector2(84, 58)
	add_child(_center_icon)

	_center_title = _make_label(22, COL_TEXT)
	_center_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_center_title.set_anchors_preset(Control.PRESET_CENTER)
	_center_title.position = Vector2(-150, -55)
	_center_title.size = Vector2(300, 34)
	add_child(_center_title)

	_center_description = _make_label(13, COL_MUTED)
	_center_description.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_center_description.set_anchors_preset(Control.PRESET_CENTER)
	_center_description.position = Vector2(-170, -16)
	_center_description.size = Vector2(340, 42)
	_center_description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(_center_description)

	_center_reason = _make_label(12, Color(0.95, 0.62, 0.38))
	_center_reason.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_center_reason.set_anchors_preset(Control.PRESET_CENTER)
	_center_reason.position = Vector2(-180, 25)
	_center_reason.size = Vector2(360, 32)
	_center_reason.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(_center_reason)

	_prompt = _make_label(12, COL_MUTED)
	_prompt.text = "Release to select  |  Esc / RMB to cancel  |  Center to cancel"
	_prompt.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_prompt.set_anchors_preset(Control.PRESET_CENTER)
	_prompt.position = Vector2(-310, 285)
	_prompt.size = Vector2(620, 26)
	add_child(_prompt)

	_page_label = _make_label(12, COL_MUTED)
	_page_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_page_label.set_anchors_preset(Control.PRESET_CENTER)
	_page_label.position = Vector2(-100, 255)
	_page_label.size = Vector2(200, 24)
	add_child(_page_label)


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
		var label := _make_label(15, COL_TEXT)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.text = "%s\n%s" % [options[i].icon, options[i].title]
		label.tooltip_text = options[i].disabled_reason if not options[i].is_enabled else options[i].description
		label.position = size * 0.5 + Vector2.from_angle(-PI * 0.5 + (i + 0.5) * TAU / count) * LABEL_RADIUS - Vector2(72, 31)
		label.size = Vector2(144, 62)
		_labels.append(label)
		add_child(label)
	_restyle_labels()


func _clear_labels() -> void:
	for label in _labels:
		if is_instance_valid(label):
			label.queue_free()
	_labels.clear()


func _restyle_labels() -> void:
	for i in _labels.size():
		var label := _labels[i]
		var option := options[i]
		var color := COL_DISABLED_TEXT if not option.is_enabled else (COL_TEXT if i != selected_index else Color.WHITE)
		label.add_theme_color_override("font_color", color)
		label.modulate = Color(1.0, 1.0, 1.0, 0.72) if not option.is_enabled else (Color(0.82, 0.94, 1.0) if option.is_current else Color.WHITE)


func _update_center() -> void:
	if not _center_icon:
		return
	var option := get_selected_option()
	if not option:
		_center_icon.text = "+"
		_center_title.text = "RADIAL MENU"
		_center_description.text = "Point to an option"
		_center_reason.text = ""
	else:
		_center_icon.text = option.icon
		_center_title.text = option.title
		_center_description.text = option.description
		_center_reason.text = option.disabled_reason if not option.is_enabled else ""
	_page_label.text = "PAGE %d / %d" % [page_index + 1, page_count] if page_count > 1 else ""


func _draw() -> void:
	if not visible:
		return
	draw_rect(Rect2(Vector2.ZERO, size), COL_BACKDROP)
	var center := size * 0.5
	draw_circle(center, RADIUS + 12.0, Color(0.01, 0.025, 0.04, 0.72))
	draw_circle(center, INNER_RADIUS, COL_PANEL)
	draw_arc(center, RADIUS + 12.0, 0.0, TAU, 96, COL_BORDER, 2.0, true)
	draw_arc(center, INNER_RADIUS, 0.0, TAU, 64, COL_BORDER, 2.0, true)
	var count := options.size()
	if count == 0:
		return
	for i in count:
		var start := -PI * 0.5 + i * TAU / count + 0.012
		var finish := -PI * 0.5 + (i + 1) * TAU / count - 0.012
		var points := PackedVector2Array([center + Vector2.from_angle(start) * INNER_RADIUS])
		for j in 13:
			points.append(center + Vector2.from_angle(lerpf(start, finish, float(j) / 12.0)) * RADIUS)
		points.append(center + Vector2.from_angle(finish) * INNER_RADIUS)
		var option := options[i]
		var fill := COL_DISABLED if not option.is_enabled else (COL_PANEL_SELECTED if i == selected_index else COL_PANEL)
		draw_colored_polygon(points, fill)
		var edge := COL_BORDER_SELECTED if i == selected_index else (Color(0.86, 0.86, 0.86, 0.78) if option.is_current else COL_BORDER)
		draw_polyline(PackedVector2Array([center + Vector2.from_angle(start) * INNER_RADIUS, center + Vector2.from_angle(start) * RADIUS]), edge, 2.0, true)
		draw_arc(center, RADIUS, start, finish, 24, edge, 2.0, true)
