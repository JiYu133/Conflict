class_name MissionRecordingOverlay
extends Control

## 进入行动后的短暂录像信息叠加层。

@onready var time_label: Label = $Content/Time
@onready var date_label: Label = $Content/Date
@onready var location_label: Label = $Content/Location

@export var action_location := "北线设施 / Sector 04"
@export var display_duration := 5.0

func _ready() -> void:
	_update_timestamp()
	location_label.text = action_location
	modulate.a = 0.0

func _process(_delta: float) -> void:
	if visible:
		_update_timestamp()

func show_recording() -> void:
	_update_timestamp()
	location_label.text = action_location
	visible = true
	modulate.a = 0.0
	var tween := create_tween()
	tween.set_parallel()
	tween.tween_property(self, "modulate:a", 1.0, 0.18)
	tween.tween_property(self, "position:x", 0.0, 0.18)
	tween.chain().tween_interval(display_duration)
	tween.chain().tween_property(self, "modulate:a", 0.0, 0.8)
	tween.chain().tween_callback(func(): visible = false)

func _update_timestamp() -> void:
	time_label.text = Time.get_time_string_from_system()
	date_label.text = Time.get_date_string_from_system().replace("-", ".")
