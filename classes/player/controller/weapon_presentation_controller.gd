class_name WeaponPresentationController
extends Node

## Follows the animated right-hand WeaponMount directly, with ADS and small
## procedural offsets. Both hands solve toward the resulting grips afterwards.

var _state_provider: Callable
var _pose_source: Node3D
var _pose_root: Node3D
var _sway_pivot: Node3D
var _weapon: BaseWeapon
var _config := WeaponPresentationConfig.new()

var _last_update_frame: int = -1
var _last_delta: float = 0.016
var _last_view_basis := Basis.IDENTITY
var _view_lag := Vector3.ZERO
var _breath_time := 0.0
var _obstruction_target := 0.0
var _obstruction_weight := 0.0


func initialize(state_provider: Callable) -> void:
	_state_provider = state_provider
	set_process(false)


func setup_weapon_rig(weapon_mount: Node3D, pose_parent: Node3D) -> Node3D:
	if not is_instance_valid(weapon_mount) or not is_instance_valid(pose_parent):
		return null
	if is_instance_valid(_pose_root):
		_pose_root.queue_free()
	_pose_source = weapon_mount
	_pose_root = Node3D.new()
	_pose_root.name = "WeaponPoseRoot"
	pose_parent.add_child(_pose_root)
	# Sample the animated hand before arm IK, then apply the final world pose
	# directly. Parenting under the solved hand would create a feedback loop.
	_pose_root.top_level = true
	_refresh_pose_source_attachment()
	_pose_root.global_transform = _pose_source.global_transform
	_sway_pivot = Node3D.new()
	_sway_pivot.name = "WeaponSwayPivot"
	_pose_root.add_child(_sway_pivot)
	_last_update_frame = -1
	_last_view_basis = _pose_root.global_basis.orthonormalized()
	return _sway_pivot


func bind_weapon(weapon: BaseWeapon) -> void:
	_weapon = weapon if is_instance_valid(weapon) else null
	_config = (
		_weapon.config.presentation_config
		if _weapon and _weapon.config and _weapon.config.presentation_config
		else WeaponPresentationConfig.new()
	)
	_view_lag = Vector3.ZERO
	_obstruction_target = 0.0
	_obstruction_weight = 0.0


func _process(delta: float) -> void:
	_last_delta = clampf(delta, 0.0001, 0.05)
	ensure_pose_current(_last_delta)


func ensure_pose_current(delta: float = 0.0) -> void:
	var frame := Engine.get_process_frames()
	if _last_update_frame == frame:
		return
	_last_update_frame = frame
	_last_delta = clampf(delta if delta > 0.0 else _last_delta, 0.0001, 0.05)
	_update_pose(_last_delta)


func _update_pose(delta: float) -> void:
	if not _state_provider.is_valid() or not is_instance_valid(_pose_root) or not is_instance_valid(_pose_source):
		return
	var state: Dictionary = _state_provider.call()
	if not bool(state.get("active", true)):
		return
	_refresh_pose_source_attachment()
	var hip_global := _pose_source.global_transform
	var view_xf: Transform3D = state.get("view", hip_global)
	var ads_blend := float(state.get("ads_blend", 0.0))
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
	var view_basis := view_xf.basis.orthonormalized()
	var additive := _build_additive_pose(state, ads_blend)
	var target := nominal_target
	target.origin += view_basis * additive.origin
	target.basis = view_basis * additive.basis * view_basis.inverse() * nominal_target.basis
	_pose_root.global_transform = target


func _build_additive_pose(state: Dictionary, ads_blend: float) -> Transform3D:
	var stability := maxf(float(state.get("stability", 1.0)), 0.15)
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
	# Composition may supply ADS breathing. Hip breathing stays weapon-authored;
	# both offsets are applied directly to the current hand/ADS pose.
	if state.has("ads_breath_pose"):
		var ads_breath: Transform3D = state["ads_breath_pose"]
		var hip_position := _config.hip_breath_position * Vector3(
			sin(phase * 0.5), sin(phase), cos(phase * 0.7))
		var hip_degrees := _config.hip_breath_rotation_degrees * Vector3(
			sin(phase), sin(phase * 0.53), cos(phase * 0.71))
		breath_position = hip_position.lerp(ads_breath.origin, ads_blend) * instability
		breath_rotation = (hip_degrees * (PI / 180.0)).lerp(
			ads_breath.basis.get_euler(), ads_blend) * instability

	var local_velocity: Vector3 = state.get("local_velocity", Vector3.ZERO)
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
	# The caller applies these offsets in eye/view space, including hip fire.
	return Transform3D(Basis.from_euler(local_rotation), local_position)


func _update_view_lag(view_basis: Basis, delta: float, ads_blend: float) -> void:
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
