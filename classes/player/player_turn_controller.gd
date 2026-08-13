class_name PlayerTurnController
extends Node

## Coordinates view/body separation and consumes the remaining view offset over
## the actual turn clip duration. The camera's yaw limit is always relative to
## the current body yaw, so its allowed sector moves with this rotation.

var _player: BasePlayer
var _camera: PlayerCameraController
var _movement: PlayerMovementController
var _animation: PlayerAnimationController
var _config: MovementConfig
var _animator: AnimationPlayer

var _turning := false
var _turn_state := PlayerAnimationController.State.IDLE
var _turn_angle := 0.0
var _last_progress := 0.0
var _clip_length := 0.0


func initialize(player: BasePlayer, camera: PlayerCameraController, movement: PlayerMovementController, animation: PlayerAnimationController, config: MovementConfig) -> void:
	_player = player
	_camera = camera
	_movement = movement
	_animation = animation
	_config = config
	_animator = player.model_manager.animator if player and player.model_manager else null


func _physics_process(delta: float) -> void:
	if not _player or not _config:
		return
	_camera.process_moving_body_yaw_blend(delta)
	if not _player.is_alive or _player.is_ragdolled or not _player.is_on_floor():
		_cancel_turn()
		return
	if _turning:
		_process_turn()
	else:
		_try_start_turn()


func is_turning() -> bool:
	return _turning


func get_turn_progress() -> float:
	return _last_progress if _turning else 0.0


func _try_start_turn() -> void:
	if not _config.turn_in_place_enabled or not _animation or _animation.get_current_state() != PlayerAnimationController.State.IDLE:
		return
	var offset := _camera.get_body_yaw_offset()
	if absf(offset) < deg_to_rad(_config.turn_trigger_angle_degrees):
		return
	var crouching := _player.stance_controller and _player.stance_controller.get_stance_value() >= 0.3
	if offset > 0.0:
		_turn_state = PlayerAnimationController.State.CROUCH_TURN_LEFT if crouching else PlayerAnimationController.State.TURN_LEFT
	else:
		_turn_state = PlayerAnimationController.State.CROUCH_TURN_RIGHT if crouching else PlayerAnimationController.State.TURN_RIGHT
	_turn_angle = clampf(offset, -deg_to_rad(_config.turn_clip_authored_angle_degrees), deg_to_rad(_config.turn_clip_authored_angle_degrees))
	_clip_length = _animation.get_turn_clip_length(_turn_state)
	if _clip_length <= 0.0:
		return
	_last_progress = 0.0
	_turning = true
	_animation.begin_external_turn(_turn_state, _get_playback_speed())
	_movement.set_turn_constraint(true, _config.turn_constrained_speed_ratio, _config.turn_constrained_acceleration_ratio)


func _process_turn() -> void:
	if _camera._is_moving():
		_exit_turn_to_locomotion()
		return
	var opposite_state := _get_turn_state_for_offset(_camera.get_body_yaw_offset())
	if opposite_state != _turn_state and opposite_state != PlayerAnimationController.State.IDLE:
		_restart_turn(opposite_state)
		return
	var progress := _animation.get_turn_playback_progress(_clip_length)
	progress = clampf(progress, _last_progress, 1.0)
	_player.rotate_y(_turn_angle * (progress - _last_progress))
	_last_progress = progress
	_animation.set_turn_playback_speed(_get_playback_speed())
	if progress >= 0.999:
		_turning = false
		_movement.set_turn_constraint(false)
		_animation.end_external_turn()


func _exit_turn_to_locomotion() -> void:
	_turning = false
	_last_progress = 0.0
	_movement.set_turn_constraint(false)
	_animation.end_external_turn()
	_camera.begin_moving_body_yaw_blend(_config.turn_transition_time)


func _get_turn_state_for_offset(offset: float) -> PlayerAnimationController.State:
	var crouching := _player.stance_controller and _player.stance_controller.get_stance_value() >= 0.3
	if absf(offset) < deg_to_rad(_config.turn_trigger_angle_degrees):
		return PlayerAnimationController.State.IDLE
	if offset > 0.0:
		return PlayerAnimationController.State.CROUCH_TURN_LEFT if crouching else PlayerAnimationController.State.TURN_LEFT
	return PlayerAnimationController.State.CROUCH_TURN_RIGHT if crouching else PlayerAnimationController.State.TURN_RIGHT


func _restart_turn(next_state: PlayerAnimationController.State) -> void:
	_turn_state = next_state
	_turn_angle = clampf(_camera.get_body_yaw_offset(), -deg_to_rad(_config.turn_clip_authored_angle_degrees), deg_to_rad(_config.turn_clip_authored_angle_degrees))
	_clip_length = _animation.get_turn_clip_length(_turn_state)
	_last_progress = 0.0
	_animation.begin_external_turn(_turn_state, _get_playback_speed())


func _get_playback_speed() -> float:
	var trigger := deg_to_rad(_config.turn_trigger_angle_degrees)
	var limit := deg_to_rad(_config.turn_view_limit_degrees)
	var t := inverse_lerp(trigger, maxf(limit, trigger + 0.001), absf(_camera.get_body_yaw_offset()))
	return lerpf(_config.turn_min_playback_speed, _config.turn_max_playback_speed, clampf(t, 0.0, 1.0))


func _cancel_turn() -> void:
	if not _turning:
		return
	_turning = false
	_last_progress = 0.0
	_movement.set_turn_constraint(false)
	if _animation:
		_animation.end_external_turn()
