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
var _roll: float = 0.0
var _roll_velocity: float = 0.0
var _position_local: Vector3 = Vector3.ZERO
var _velocity_local: Vector3 = Vector3.ZERO
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
	else:
		physics_model.rebuild(config, attachment_manager)
	reset()


func apply_recoil(control_multiplier: float = 1.0) -> void:
	if not physics_model:
		return
	_control_multiplier = control_multiplier
	var angular_impulse: Vector3 = physics_model.get_shot_angular_impulse_3d()
	_pitch_velocity += angular_impulse.x
	_yaw_velocity += angular_impulse.y
	_roll_velocity += angular_impulse.z
	_velocity_local += physics_model.get_shot_linear_velocity() * _translation_scale()


func set_control_multiplier(value: float) -> void:
	_control_multiplier = value


func reset() -> void:
	_pitch = 0.0
	_pitch_velocity = 0.0
	_yaw = 0.0
	_yaw_velocity = 0.0
	_roll = 0.0
	_roll_velocity = 0.0
	_position_local = Vector3.ZERO
	_velocity_local = Vector3.ZERO


func _process(delta: float) -> void:
	if not physics_model:
		return

	var control: Vector2 = physics_model.get_control()
	var stiffness := control.x * maxf(_control_multiplier, 0.05)
	var damping := control.y * maxf(_control_multiplier, 0.05)
	var inv_inertia_pitch := 1.0 / maxf(physics_model.inertia_pitch, 0.05)
	var inv_inertia_yaw := 1.0 / maxf(physics_model.inertia_yaw, 0.05)

	var pitch_accel := -stiffness * inv_inertia_pitch * _pitch
	pitch_accel -= damping * inv_inertia_pitch * _pitch_velocity
	var yaw_accel := -stiffness * inv_inertia_yaw * _yaw
	yaw_accel -= damping * inv_inertia_yaw * _yaw_velocity
	var roll_stiffness := stiffness * _roll_stiffness_multiplier()
	var roll_damping := damping * _roll_damping_multiplier()
	var inv_inertia_roll := 1.0 / maxf(physics_model.inertia_roll, 0.05)
	var roll_accel := -roll_stiffness * inv_inertia_roll * _roll
	roll_accel -= roll_damping * inv_inertia_roll * _roll_velocity

	_pitch_velocity += pitch_accel * delta
	_yaw_velocity += yaw_accel * delta
	_roll_velocity += roll_accel * delta
	_pitch += _pitch_velocity * delta
	_yaw += _yaw_velocity * delta
	_roll += _roll_velocity * delta
	var linear_stiffness := _linear_stiffness()
	var linear_damping := _linear_damping()
	var linear_force: Vector3 = -_position_local * linear_stiffness - _velocity_local * linear_damping
	# Grip/stock support damps lateral and vertical drift more strongly than the
	# free rearward compression, matching a two-hand shoulder mount.
	linear_force.x *= _lateral_constraint_multiplier()
	linear_force.y *= _vertical_constraint_multiplier()
	_velocity_local += linear_force * delta
	_position_local += _velocity_local * delta

	_pitch = clampf(_pitch, -_max_pitch(), _max_pitch())
	_yaw = clampf(_yaw, -_max_yaw(), _max_yaw())
	_roll = clampf(_roll, -_max_roll(), _max_roll())
	_position_local.z = clampf(_position_local.z, 0.0, _max_translation())
	_position_local.x = clampf(_position_local.x, -_max_lateral_translation(), _max_lateral_translation())
	_position_local.y = clampf(_position_local.y, -_max_vertical_translation(), _max_vertical_translation())


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
	return Basis.from_euler(Vector3(_pitch * scale, _yaw * scale, _roll * scale))


func get_pose_translation() -> Vector3:
	return _position_local


func get_pose_snapshot() -> Dictionary:
	return {
		"pitch_rad": _pitch,
		"yaw_rad": _yaw,
		"angular_velocity": Vector3(_pitch_velocity, _yaw_velocity, _roll_velocity),
		"position_local": _position_local,
		"velocity_local": _velocity_local,
		"roll_rad": _roll,
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

func _max_lateral_translation() -> float:
	return maxf(_max_translation() * 0.35, 0.001)

func _max_vertical_translation() -> float:
	return maxf(_max_translation() * 0.25, 0.001)

func _lateral_constraint_multiplier() -> float:
	return 1.0 + clampf((physics_model.attachment_control_stiffness if physics_model else 0.0) / 120.0, 0.0, 3.0)

func _vertical_constraint_multiplier() -> float:
	return 1.0 + clampf((physics_model.attachment_control_stiffness if physics_model else 0.0) / 180.0, 0.0, 2.0)

func _roll_stiffness_multiplier() -> float:
	return 0.75 + _lateral_constraint_multiplier() * 0.25

func _roll_damping_multiplier() -> float:
	return 0.85 + _lateral_constraint_multiplier() * 0.15


func _max_pitch() -> float:
	return minf(MAX_CAMERA_OFFSET_RAD, maxf(config.recoil_pose_max_pitch_rad if config else 0.45, 0.01))


func _max_yaw() -> float:
	return minf(MAX_CAMERA_OFFSET_RAD, maxf(config.recoil_pose_max_yaw_rad if config else 0.24, 0.01))

func _max_roll() -> float:
	return minf(MAX_CAMERA_OFFSET_RAD, maxf(config.recoil_pose_max_roll_rad if config else 0.16, 0.01))
