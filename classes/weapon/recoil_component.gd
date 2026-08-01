class_name RecoilComponent
extends Node

# Physics-driven recoil component.
# Each shot adds angular velocity from RecoilPhysicsModel; a damped spring
# then returns the camera offset to zero.

const MAX_CAMERA_OFFSET_RAD := 0.6

var config: WeaponConfig
var attachment_manager: AttachmentManager
var physics_model: RecoilPhysicsModel

var _pitch: float = 0.0
var _pitch_velocity: float = 0.0
var _yaw: float = 0.0
var _yaw_velocity: float = 0.0
var _control_multiplier: float = 1.0


func initialize(cfg: WeaponConfig, am: AttachmentManager = null) -> void:
	config = cfg
	attachment_manager = am
	physics_model = RecoilPhysicsModel.new()
	rebuild_physics()
	GlobalLogger.debug("RecoilComponent", "Initialized physics recoil for: " + cfg.weapon_name)


func rebuild_physics() -> void:
	if not physics_model:
		physics_model = RecoilPhysicsModel.new()
	physics_model.rebuild(config, attachment_manager)
	reset()


func apply_recoil(control_multiplier: float = 1.0) -> void:
	if not physics_model:
		return
	_control_multiplier = control_multiplier
	var angular_impulse := physics_model.get_shot_angular_impulse()
	_pitch_velocity += angular_impulse.x
	_yaw_velocity += angular_impulse.y


func set_control_multiplier(value: float) -> void:
	_control_multiplier = value


func reset() -> void:
	_pitch = 0.0
	_pitch_velocity = 0.0
	_yaw = 0.0
	_yaw_velocity = 0.0


func _process(delta: float) -> void:
	if not physics_model:
		return

	var control := physics_model.get_control()
	var stiffness := control.x * maxf(_control_multiplier, 0.05)
	var damping := control.y * maxf(_control_multiplier, 0.05)
	var inv_inertia_pitch := 1.0 / maxf(physics_model.inertia_pitch, 0.05)
	var inv_inertia_yaw := 1.0 / maxf(physics_model.inertia_yaw, 0.05)

	var pitch_accel := -stiffness * inv_inertia_pitch * _pitch
	pitch_accel -= damping * inv_inertia_pitch * _pitch_velocity
	var yaw_accel := -stiffness * inv_inertia_yaw * _yaw
	yaw_accel -= damping * inv_inertia_yaw * _yaw_velocity

	_pitch_velocity += pitch_accel * delta
	_yaw_velocity += yaw_accel * delta
	_pitch += _pitch_velocity * delta
	_yaw += _yaw_velocity * delta

	_pitch = clampf(_pitch, -MAX_CAMERA_OFFSET_RAD, MAX_CAMERA_OFFSET_RAD)
	_yaw = clampf(_yaw, -MAX_CAMERA_OFFSET_RAD, MAX_CAMERA_OFFSET_RAD)


func get_camera_pitch_offset() -> float:
	return _pitch


func get_camera_yaw_offset() -> float:
	return _yaw


func get_physics_snapshot() -> Dictionary:
	if not physics_model:
		return {}
	return physics_model.get_snapshot()


# Deprecated compatibility helpers. The camera no longer consumes these values.
func consume_camera_kick_pitch() -> float:
	return _pitch


func consume_camera_kick_yaw() -> float:
	return _yaw


func get_recoil_offset() -> float:
	return rad_to_deg(_pitch)


func get_recoil_horizontal_offset() -> float:
	return rad_to_deg(_yaw)
