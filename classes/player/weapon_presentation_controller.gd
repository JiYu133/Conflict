class_name WeaponPresentationController
extends Node

## Owns the independent weapon pose. WeaponMount is sampled as an animation
## input only; both hands solve toward the resulting weapon grips afterwards.

var _player: BasePlayer
var _camera_controller: PlayerCameraController
var _weapon_manager: WeaponManager
var _pose_source: Node3D
var _pose_root: Node3D
var _sway_pivot: Node3D
var _weapon: BaseWeapon
var _config := WeaponPresentationConfig.new()

var _position_velocity := Vector3.ZERO
var _angular_velocity := Vector3.ZERO
var _current_rotation := Quaternion.IDENTITY
var _pose_initialized := false
var _last_update_frame: int = -1
var _last_delta: float = 0.016
var _last_view_basis := Basis.IDENTITY
var _view_lag := Vector3.ZERO
var _breath_time := 0.0
var _obstruction_target := 0.0
var _obstruction_weight := 0.0


func initialize(
	player: BasePlayer,
	camera_controller: PlayerCameraController,
	weapon_manager: WeaponManager
) -> void:
	_player = player
	_camera_controller = camera_controller
	_weapon_manager = weapon_manager
	_weapon_manager.weapon_changed.connect(bind_weapon)
	set_process(true)


func setup_weapon_rig(weapon_mount: Node3D, pose_parent: Node3D) -> Node3D:
	if not is_instance_valid(weapon_mount) or not is_instance_valid(pose_parent):
		return null
	_pose_source = weapon_mount
	_pose_root = Node3D.new()
	_pose_root.name = "WeaponPoseRoot"
	pose_parent.add_child(_pose_root)
	_refresh_pose_source_attachment()
	_pose_root.global_transform = _pose_source.global_transform
	_sway_pivot = Node3D.new()
	_sway_pivot.name = "WeaponSwayPivot"
	_pose_root.add_child(_sway_pivot)
	_current_rotation = _pose_root.global_basis.orthonormalized().get_rotation_quaternion()
	_pose_initialized = true
	return _sway_pivot


func bind_weapon(weapon: BaseWeapon) -> void:
	_weapon = weapon if is_instance_valid(weapon) else null
	_config = (
		_weapon.config.presentation_config
		if _weapon and _weapon.config and _weapon.config.presentation_config
		else WeaponPresentationConfig.new()
	)
	_position_velocity = Vector3.ZERO
	_angular_velocity = Vector3.ZERO
	_view_lag = Vector3.ZERO
	if is_instance_valid(_pose_root):
		_current_rotation = _pose_root.global_basis.orthonormalized().get_rotation_quaternion()


func _process(delta: float) -> void:
	_last_delta = clampf(delta, 0.0001, 0.05)
	ensure_pose_current(_last_delta)


func ensure_pose_current(delta: float = 0.0) -> void:
	var frame := Engine.get_process_frames()
	if _last_update_frame == frame:
		return
	_last_update_frame = frame
	_update_pose(delta if delta > 0.0 else _last_delta)


func _update_pose(delta: float) -> void:
	if not is_instance_valid(_pose_root) or not is_instance_valid(_pose_source):
		return
	_refresh_pose_source_attachment()
	var hip_global := _pose_source.global_transform
	var active_camera: Camera3D = _camera_controller.get_active_camera()
	var view_xf: Transform3D = (
		active_camera.global_transform
		if is_instance_valid(active_camera)
		else _player.global_transform
	)
	var ads_blend := _camera_controller.get_ads_blend()
	var nominal_target := hip_global
	var ads_anchor := _weapon.get_ads_anchor() if is_instance_valid(_weapon) else null
	if is_instance_valid(ads_anchor):
		var anchor_from_pose := _pose_root.global_transform.affine_inverse() * ads_anchor.global_transform
		var ads_global: Transform3D = view_xf * anchor_from_pose.affine_inverse()
		nominal_target = hip_global.interpolate_with(ads_global, ads_blend)
	elif is_instance_valid(_weapon) and _weapon.config:
		var fallback := hip_global * Transform3D(Basis.IDENTITY, _weapon.config.ads_center_offset)
		nominal_target = hip_global.interpolate_with(fallback, ads_blend)

	_breath_time += delta
	_update_view_lag(view_xf.basis.orthonormalized(), delta, ads_blend)
	_update_obstruction(delta)
	var additive := _build_additive_pose(view_xf.basis.orthonormalized(), ads_blend)
	var target := nominal_target * additive
	_integrate_pose(target, delta)


func _build_additive_pose(view_basis: Basis, ads_blend: float) -> Transform3D:
	var stability := 1.0
	if is_instance_valid(_player) and _player.health_system:
		stability = maxf(_player.health_system.get_aim_stability_multiplier(), 0.15)
	var instability := 1.0 / stability
	var phase := _breath_time * TAU * maxf(_config.breathing_frequency_hz, 0.01)
	var breath_position := _config.hip_breath_position.lerp(_config.ads_breath_position, ads_blend)
	breath_position *= Vector3(sin(phase * 0.5), sin(phase), cos(phase * 0.7)) * instability
	var breath_degrees := _config.hip_breath_rotation_degrees.lerp(
		_config.ads_breath_rotation_degrees, ads_blend
	)
	var breath_rotation := Vector3(
		deg_to_rad(breath_degrees.x) * sin(phase),
		deg_to_rad(breath_degrees.y) * sin(phase * 0.53),
		deg_to_rad(breath_degrees.z) * cos(phase * 0.71)
	) * instability

	var local_velocity := Vector3.ZERO
	if is_instance_valid(_player):
		local_velocity = _player.global_basis.orthonormalized().inverse() * _player.velocity
	var speed_reference := maxf(_config.reference_move_speed, 0.1)
	var move_ratio := Vector3(
		clampf(local_velocity.x / speed_reference, -1.0, 1.0),
		clampf(local_velocity.y / speed_reference, -1.0, 1.0),
		clampf(local_velocity.z / speed_reference, -1.0, 1.0)
	)
	var move_scale := _config.hip_move_position_scale.lerp(_config.ads_move_position_scale, ads_blend)
	var move_position := Vector3(
		move_ratio.x * move_scale.x,
		(absf(move_ratio.x) + absf(move_ratio.z)) * -move_scale.y,
		move_ratio.z * move_scale.z
	)
	var move_degrees := _config.hip_move_rotation_degrees.lerp(
		_config.ads_move_rotation_degrees, ads_blend
	)
	var move_rotation := Vector3(
		deg_to_rad(move_degrees.x) * -move_ratio.z,
		deg_to_rad(move_degrees.y) * -move_ratio.x,
		deg_to_rad(move_degrees.z) * -move_ratio.x
	)

	var obstruction_position := _config.obstruction_position * _obstruction_weight
	var obstruction_degrees := _config.obstruction_rotation_degrees * _obstruction_weight
	var obstruction_rotation := Vector3(
		deg_to_rad(obstruction_degrees.x),
		deg_to_rad(obstruction_degrees.y),
		deg_to_rad(obstruction_degrees.z)
	)
	var local_position := breath_position + move_position + obstruction_position
	var local_rotation := breath_rotation + move_rotation + _view_lag + obstruction_rotation
	# Additive values are authored in eye/view space. Convert the translation to
	# the nominal target's local axes through Transform3D composition.
	return Transform3D(Basis.from_euler(local_rotation), local_position)


func _update_view_lag(view_basis: Basis, delta: float, ads_blend: float) -> void:
	if not _pose_initialized:
		_last_view_basis = view_basis
		return
	var delta_basis := _last_view_basis.inverse() * view_basis
	var delta_euler := delta_basis.get_euler()
	var max_degrees := _config.hip_view_lag_degrees.lerp(_config.ads_view_lag_degrees, ads_blend)
	var target := Vector3(
		clampf(-delta_euler.x / maxf(delta, 0.0001) * _config.view_lag_response, -deg_to_rad(max_degrees.x), deg_to_rad(max_degrees.x)),
		clampf(-delta_euler.y / maxf(delta, 0.0001) * _config.view_lag_response, -deg_to_rad(max_degrees.y), deg_to_rad(max_degrees.y)),
		clampf(delta_euler.y / maxf(delta, 0.0001) * _config.view_lag_response * 0.5, -deg_to_rad(max_degrees.z), deg_to_rad(max_degrees.z))
	)
	_view_lag = _view_lag.lerp(target, clampf(delta * 18.0, 0.0, 1.0))
	_last_view_basis = view_basis


func _update_obstruction(delta: float) -> void:
	var speed := (
		_config.obstruction_enter_speed
		if _obstruction_target > _obstruction_weight
		else _config.obstruction_exit_speed
	)
	_obstruction_weight = move_toward(_obstruction_weight, _obstruction_target, speed * delta)


func _integrate_pose(target: Transform3D, delta: float) -> void:
	if not _pose_initialized:
		_pose_root.global_transform = target
		_current_rotation = target.basis.orthonormalized().get_rotation_quaternion()
		_pose_initialized = true
		return
	var remaining := maxf(delta, 0.0)
	var max_step := maxf(_config.max_substep, 0.001)
	while remaining > 0.000001:
		var step := minf(remaining, max_step)
		var current_position := _pose_root.global_position
		var position_accel := (target.origin - current_position) * _config.position_stiffness \
				- _position_velocity * _config.position_damping
		_position_velocity += position_accel * step
		current_position += _position_velocity * step

		var target_rotation := target.basis.orthonormalized().get_rotation_quaternion()
		var error := target_rotation * _current_rotation.inverse()
		if error.w < 0.0:
			error = Quaternion(-error.x, -error.y, -error.z, -error.w)
		var angle := error.get_angle()
		var axis := error.get_axis() if angle > 0.000001 else Vector3.ZERO
		var angular_accel := axis * angle * _config.rotation_stiffness \
				- _angular_velocity * _config.rotation_damping
		_angular_velocity += angular_accel * step
		var angular_step := _angular_velocity.length() * step
		if angular_step > 0.000001:
			_current_rotation = Quaternion(_angular_velocity.normalized(), angular_step) * _current_rotation
			_current_rotation = _current_rotation.normalized()
		_pose_root.global_transform = Transform3D(Basis(_current_rotation), current_position)
		remaining -= step


func set_obstruction_target(value: float) -> void:
	_obstruction_target = clampf(value, 0.0, 1.0)


func get_obstruction_weight() -> float:
	return _obstruction_weight


func get_obstruction_fire_threshold() -> float:
	return _config.obstruction_fire_block_threshold


func get_obstruction_probe_radius() -> float:
	return _config.obstruction_probe_radius


func get_pose_root() -> Node3D:
	return _pose_root


func get_pose_source() -> Node3D:
	return _pose_source


func get_sway_pivot() -> Node3D:
	return _sway_pivot


func _refresh_pose_source_attachment() -> void:
	var node: Node = _pose_source
	while is_instance_valid(node):
		if node is BoneAttachment3D:
			(node as BoneAttachment3D).on_skeleton_update()
			return
		node = node.get_parent()
