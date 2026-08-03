class_name AnimatedToggle
extends Button

const TRACK_SIZE := Vector2(52.0, 24.0)
const KNOB_SIZE := Vector2(18.0, 18.0)
const TRANSITION_TIME := 0.16

var _visual_progress: float = 0.0
var _transition: Tween


func _ready() -> void:
	text = ""
	toggle_mode = true
	flat = true
	focus_mode = Control.FOCUS_ALL
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	custom_minimum_size = Vector2(52.0, 32.0)
	var empty_style := StyleBoxEmpty.new()
	for state in ["normal", "hover", "pressed", "focus", "disabled"]:
		add_theme_stylebox_override(state, empty_style)
	_visual_progress = 1.0 if button_pressed else 0.0
	toggled.connect(_on_toggled)
	queue_redraw()


func _on_toggled(enabled: bool) -> void:
	if _transition and _transition.is_valid():
		_transition.kill()
	_transition = create_tween()
	_transition.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	_transition.tween_property(self, "_visual_progress", 1.0 if enabled else 0.0, TRANSITION_TIME)
	_transition.tween_callback(queue_redraw)


func _draw() -> void:
	var track := StyleBoxFlat.new()
	track.bg_color = Color(1.0, 1.0, 1.0, 0.16) if not button_pressed else Color(0.40, 0.72, 0.62, 0.88)
	track.set_corner_radius_all(12)
	draw_style_box(track, Rect2(Vector2(0.0, 4.0), TRACK_SIZE))

	var knob_x := 3.0 + (TRACK_SIZE.x - KNOB_SIZE.x - 6.0) * _visual_progress
	var knob := StyleBoxFlat.new()
	knob.bg_color = Color(0.76, 0.79, 0.82) if not button_pressed else Color.WHITE
	knob.set_corner_radius_all(9)
	knob.shadow_color = Color(0.0, 0.0, 0.0, 0.24)
	knob.shadow_size = 2
	draw_style_box(knob, Rect2(Vector2(knob_x, 7.0), KNOB_SIZE))

	if has_focus():
		var focus_box := StyleBoxFlat.new()
		focus_box.bg_color = Color(1.0, 1.0, 1.0, 0.0)
		focus_box.border_color = Color.WHITE
		focus_box.set_border_width_all(1)
		focus_box.set_corner_radius_all(14)
		draw_style_box(focus_box, Rect2(Vector2(-2.0, 2.0), Vector2(56.0, 28.0)))
