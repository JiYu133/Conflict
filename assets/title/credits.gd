extends CanvasLayer

signal return_requested

var _return_requested := false
var _scroll_tween: Tween
@onready var credits_viewport: Control = $Content/CreditsViewport
@onready var credits_text: Label = $Content/CreditsViewport/CreditsText
@onready var top_cinema_bar: ColorRect = $TopCinemaBar
@onready var bottom_cinema_bar: ColorRect = $BottomCinemaBar

func _ready() -> void:
	$ReturnButton.pressed.connect(_on_return)
	$ReturnButton.grab_focus()
	_play_cinema_bars_in()
	await get_tree().process_frame
	await get_tree().process_frame
	_start_text_scroll()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_on_return()
		get_viewport().set_input_as_handled()

func _on_return() -> void:
	if _return_requested:
		return
	_return_requested = true
	if _scroll_tween and _scroll_tween.is_valid():
		_scroll_tween.kill()
	return_requested.emit()

func _start_text_scroll() -> void:
	credits_text.position.y = 0.0
	var travel := maxf(0.0, credits_text.size.y - credits_viewport.size.y)
	if travel <= 0.0:
		return
	_scroll_tween = create_tween()
	_scroll_tween.set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	_scroll_tween.tween_property(credits_text, "position:y", -travel, 36.0)

func _play_cinema_bars_in() -> void:
	top_cinema_bar.offset_bottom = 0.0
	bottom_cinema_bar.offset_top = 0.0
	bottom_cinema_bar.offset_bottom = 0.0
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.set_parallel()
	tween.tween_property(top_cinema_bar, "offset_bottom", 58.0, 0.7)
	# The bottom bar is anchored to the viewport bottom, so its top edge uses a negative offset.
	tween.tween_property(bottom_cinema_bar, "offset_top", -58.0, 0.7)
