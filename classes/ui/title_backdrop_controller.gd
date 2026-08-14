class_name TitleBackdropController
extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var camera_rig: Node3D = $CameraRig
@onready var camera: Camera3D = $CameraRig/Camera3D

var _camera_tween: Tween

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	camera.process_mode = Node.PROCESS_MODE_ALWAYS
	camera.current = true
	camera.make_current()
	play_default_drift()

func play_credits_orbit() -> void:
	_stop_camera_tween()
	animation_player.stop()
	var orbit := create_tween()
	orbit.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	orbit.tween_property(camera_rig, "position", Vector3(8, 6.5, 16), 6.0)
	orbit.parallel().tween_property(camera_rig, "rotation", Vector3(-0.18, 0.78, 0), 6.0)
	orbit.chain().tween_property(camera_rig, "position", Vector3(5, 7.5, 8), 6.0)
	orbit.parallel().tween_property(camera_rig, "rotation", Vector3(-0.2, 1.1, 0), 6.0)
	orbit.chain().tween_property(camera_rig, "position", Vector3(11, 6.8, 3), 6.0)
	orbit.parallel().tween_property(camera_rig, "rotation", Vector3(-0.2, 1.55, 0), 6.0)
	orbit.chain().tween_property(camera_rig, "position", Vector3(14, 7, 18), 6.0)
	orbit.parallel().tween_property(camera_rig, "rotation", Vector3(-0.22, 0.62, 0), 6.0)
	_camera_tween = orbit

func play_default_drift() -> void:
	_stop_camera_tween()
	animation_player.stop()
	var drift := create_tween()
	drift.set_loops()
	drift.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	drift.tween_property(camera_rig, "position", Vector3(10, 6.5, 14), 9.0)
	drift.parallel().tween_property(camera_rig, "rotation", Vector3(-0.2, 0.74, 0), 9.0)
	drift.chain().tween_property(camera_rig, "position", Vector3(14, 7, 18), 9.0)
	drift.parallel().tween_property(camera_rig, "rotation", Vector3(-0.22, 0.62, 0), 9.0)
	_camera_tween = drift

func _stop_camera_tween() -> void:
	if _camera_tween and _camera_tween.is_valid():
		_camera_tween.kill()
	_camera_tween = null
