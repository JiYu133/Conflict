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
var _rearward_position: float = 0.0
var _rearward_velocity: float = 0.0
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
	_rearward_velocity += physics_model.get_shot_linear_velocity().z * _translation_scale()


func set_control_multiplier(value: float) -> void:
	_control_multiplier = value


func reset() -> void:
	_pitch = 0.0
	_pitch_velocity = 0.0
	_yaw = 0.0
	_yaw_velocity = 0.0
	_rearward_position = 0.0
	_rearward_velocity = 0.0


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
	var linear_stiffness := _linear_stiffness()
	var linear_damping := _linear_damping()
	_rearward_velocity += (-linear_stiffness * _rearward_position - linear_damping * _rearward_velocity) * delta
	_rearward_position += _rearward_velocity * delta

	_pitch = clampf(_pitch, -_max_pitch(), _max_pitch())
	_yaw = clampf(_yaw, -_max_yaw(), _max_yaw())
	_rearward_position = clampf(_rearward_position, 0.0, _max_translation())


func get_physics_snapshot() -> Dictionary:
	if not physics_model:
		return {}
	return physics_model.get_snapshot()


func get_recoil_offset() -> float:
	return rad_to_deg(_pitch)


func get_recoil_horizontal_offset() -> float:
	return rad_to_deg(_yaw)


func get_camera_feedback_scale() -> float:
	return config.recoil_pose_camera_feedback_scale if config else 0.12


func get_pose_rotation() -> Basis:
	var scale := _rotation_scale()
	return Basis.from_euler(Vector3(_pitch * scale, _yaw * scale, 0.0))


func get_pose_translation() -> Vector3:
	return Vector3(0.0, 0.0, _rearward_position)


func get_pose_snapshot() -> Dictionary:
	return {
		"pitch_rad": _pitch,
		"yaw_rad": _yaw,
		"rearward_position_m": _rearward_position,
		"rearward_velocity_mps": _rearward_velocity,
	}


func _translation_scale() -> float:
	return maxf(config.recoil_pose_translation_scale if config else 0.012, 0.0)


func _rotation_scale() -> float:
	return maxf(config.recoil_pose_rotation_scale if config else 1.0, 0.0)


func _linear_stiffness() -> float:
	return maxf(config.recoil_pose_linear_stiffness if config else 85.0, 1.0) * maxf(_control_multiplier, 0.05)


func _linear_damping() -> float:
	return maxf(config.recoil_pose_linear_damping if config else 20.0, 0.1) * maxf(_control_multiplier, 0.05)


func _max_translation() -> float:
	return maxf(config.recoil_pose_max_translation_m if config else 0.045, 0.001)


func _max_pitch() -> float:
	return minf(MAX_CAMERA_OFFSET_RAD, maxf(config.recoil_pose_max_pitch_rad if config else 0.45, 0.01))


func _max_yaw() -> float:
	return minf(MAX_CAMERA_OFFSET_RAD, maxf(config.recoil_pose_max_yaw_rad if config else 0.24, 0.01))
