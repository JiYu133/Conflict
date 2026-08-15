class_name PlayerLookController
extends Node

## Owns player view input separately from camera placement and body turning.

## Speed used to return the temporary free-look offset to zero after release.
const RETURN_SPEED := 9.0

var _player: BasePlayer
var _camera_config: CameraConfig
var _settings_service
var _mouse_sensitivity: float = 0.01
var _max_vertical_angle: float = PI * 0.45
var _base_yaw: float = 0.0
var _base_pitch: float = 0.0
var _free_yaw_offset: float = 0.0
var _free_pitch_offset: float = 0.0
var _free_look_active: bool = false


func initialize(player: BasePlayer, camera_config: CameraConfig, settings_service) -> void:
	_player = player
	_camera_config = camera_config if camera_config else CameraConfig.new()
	_settings_service = settings_service
	_mouse_sensitivity = _camera_config.mouse_sensitivity
	_max_vertical_angle = _camera_config.max_vertical_angle
	_base_yaw = player.rotation.y if player else 0.0
	_base_pitch = 0.0


func _input(event: InputEvent) -> void:
	if not is_instance_valid(_player) or not _player.controllable:
		return
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		return

	if event.is_action_pressed("free_look"):
		begin_free_look()
		return
	if event.is_action_released("free_look"):
		end_free_look()
		return
	if event is not InputEventMouseMotion:
		return

	var motion := event as InputEventMouseMotion
	var unified_multiplier := float(_settings_service.get_value("controls/sensitivity", 1.0)) if _settings_service else 1.0
	var invert_sign := -1.0 if _settings_service and bool(_settings_service.get_value("controls/invert_y", false)) else 1.0
	var input_yaw := -motion.relative.x * _mouse_sensitivity * unified_multiplier
	var input_pitch := -motion.relative.y * _mouse_sensitivity * unified_multiplier * invert_sign
	if _free_look_active:
		_free_yaw_offset += input_yaw
		_free_pitch_offset = clampf(
			_free_pitch_offset + input_pitch,
			-_max_vertical_angle - _base_pitch,
			_max_vertical_angle - _base_pitch
		)
		_clamp_free_yaw_to_body()
	else:
		_base_yaw = _apply_base_yaw_input(input_yaw)
		_base_pitch = clampf(_base_pitch + input_pitch, -_max_vertical_angle, _max_vertical_angle)


func _process(delta: float) -> void:
	if is_instance_valid(_player) and not _player.controllable:
		_free_look_active = false
	if _free_look_active:
		_clamp_free_yaw_to_body()
		return
	_free_yaw_offset = move_toward(_free_yaw_offset, 0.0, RETURN_SPEED * delta)
	_free_pitch_offset = move_toward(_free_pitch_offset, 0.0, RETURN_SPEED * delta)
	if absf(_free_yaw_offset) < 0.0001:
		_free_yaw_offset = 0.0
	if absf(_free_pitch_offset) < 0.0001:
		_free_pitch_offset = 0.0


func _apply_base_yaw_input(input_yaw: float) -> float:
	if not is_instance_valid(_player):
		return _base_yaw + input_yaw
	var movement_config := _player.player_config.movement_config if _player.player_config else null
	if not movement_config or not movement_config.turn_in_place_enabled:
		return _base_yaw + input_yaw

	var limit := deg_to_rad(movement_config.turn_view_limit_degrees)
	# Airborne input rotates the view but never synchronizes the body.
	if _player.is_on_floor() and _is_moving():
		return _base_yaw + input_yaw
	var ratio := 1.0
	if _player.is_on_floor():
		var trigger := deg_to_rad(movement_config.turn_trigger_angle_degrees)
		var body_offset := angle_difference(_player.rotation.y, _base_yaw)
		if absf(body_offset) > trigger:
			var t := inverse_lerp(trigger, maxf(limit * 2.0, limit + 0.001), absf(body_offset))
			ratio = lerpf(1.0, movement_config.turn_view_min_sensitivity_ratio, clampf(t, 0.0, 1.0))
	var desired_yaw := _base_yaw + input_yaw * ratio
	return _player.rotation.y + clampf(
		angle_difference(_player.rotation.y, desired_yaw), -limit, limit
	)


func _clamp_free_yaw_to_body() -> void:
	if not is_instance_valid(_player):
		return
	var movement_config := _player.player_config.movement_config if _player.player_config else null
	if not movement_config:
		return
	var limit := deg_to_rad(movement_config.turn_view_limit_degrees)
	var visual_yaw := _base_yaw + _free_yaw_offset
	var clamped_yaw := _player.rotation.y + clampf(
		angle_difference(_player.rotation.y, visual_yaw), -limit, limit
	)
	_free_yaw_offset = angle_difference(_base_yaw, clamped_yaw)


func _is_moving() -> bool:
	if not is_instance_valid(_player):
		return false
	return Vector2(_player.velocity.x, _player.velocity.z).length_squared() > 0.01


func is_free_look_active() -> bool:
	return _free_look_active


func begin_free_look() -> void:
	_free_look_active = true


func end_free_look() -> void:
	_free_look_active = false


func get_base_yaw() -> float:
	return _base_yaw


func get_base_pitch() -> float:
	return _base_pitch


## Temporary pitch offset created by middle-button free observation.
## Consumers that drive weapons must use base pitch instead.
func get_free_pitch_offset() -> float:
	return _free_pitch_offset


## Temporary yaw offset created by middle-button free observation.
## This offset is visual-only and must not be used for weapon aiming.
func get_free_yaw_offset() -> float:
	return _free_yaw_offset


func get_view_yaw() -> float:
	return _base_yaw + _free_yaw_offset


func get_view_pitch() -> float:
	return clampf(_base_pitch + _free_pitch_offset, -_max_vertical_angle, _max_vertical_angle)


func get_body_yaw_offset() -> float:
	return angle_difference(_player.rotation.y, _base_yaw) if is_instance_valid(_player) else 0.0


func get_visual_body_yaw_offset() -> float:
	return angle_difference(_player.rotation.y, get_view_yaw()) if is_instance_valid(_player) else 0.0


func get_movement_basis() -> Basis:
	return Basis(Vector3.UP, _base_yaw)


func set_base_yaw(value: float) -> void:
	_base_yaw = value


func set_base_pitch(value: float) -> void:
	_base_pitch = clampf(value, -_max_vertical_angle, _max_vertical_angle)
