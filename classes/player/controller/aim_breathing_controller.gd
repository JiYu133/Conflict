class_name AimBreathingController
extends Node

## Receives input/ADS state through composition. Produces a view-space breathing
## target for the existing weapon spring; never modifies weapon or IK data.
signal idle_pause_changed(paused: bool)

var _config := AimConfig.new()
var _state_provider: Callable
var _phase := 0.0
var _hold_weight := 0.0
var _holding := false
var _idle_paused := false


func initialize(config: AimConfig, state_provider: Callable) -> void:
	_config = config if config else AimConfig.new()
	_state_provider = state_provider


func _process(delta: float) -> void:
	if not _state_provider.is_valid():
		return
	var state: Dictionary = _state_provider.call()
	update_breathing(delta, bool(state.get("aiming", false)), bool(state.get("hold_requested", false)))


func update_breathing(delta: float, aiming: bool, hold_requested: bool) -> void:
	if _idle_paused != aiming:
		_idle_paused = aiming
		idle_pause_changed.emit(aiming)
	_holding = aiming and hold_requested
	var blend_time := _config.hold_blend_time if _holding else _config.release_blend_time
	_hold_weight = move_toward(_hold_weight, 1.0 if _holding else 0.0,
		maxf(delta, 0.0) / maxf(blend_time, 0.01))
	# Slow the phase as the lungs settle, and resume from the same phase.
	_phase = fmod(_phase + maxf(delta, 0.0) * TAU
		* maxf(_config.breathing_frequency_hz, 0.0) * (1.0 - _hold_weight), TAU * 100.0)


func get_breath_pose() -> Transform3D:
	var amplitude := 1.0 - _hold_weight
	var position := _config.breathing_position * Vector3(
		sin(_phase * 0.5), sin(_phase), cos(_phase * 0.7)) * amplitude
	var rotation := _config.breathing_rotation_degrees * Vector3(
		sin(_phase), sin(_phase * 0.53), cos(_phase * 0.71)) * amplitude
	return Transform3D(Basis.from_euler(rotation * (PI / 180.0)), position)


func is_holding_breath() -> bool:
	return _holding


func get_hold_weight() -> float:
	return _hold_weight
