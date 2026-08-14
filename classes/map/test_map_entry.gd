extends Node3D

var _deployment_activation_pending := false

func arm_deployment_activation() -> void:
	_deployment_activation_pending = true

func _process(_delta: float) -> void:
	if not _deployment_activation_pending:
		return
	_deployment_activation_pending = false
	var player := find_child("CharacterBody3D", true, false) as BasePlayer
	if player:
		player.set_controllable(true)
		player.request_mouse_mode(BasePlayer.MOUSE_OWNER_CAMERA, Input.MOUSE_MODE_CAPTURED, 0)
	var recording := find_child("MissionRecordingOverlay", true, false) as MissionRecordingOverlay
	if recording:
		recording.show_recording()
