class_name FootIKController
extends Node

var _skeleton: Skeleton3D
var _model_manager: PlayerModelManager
var _player: CharacterBody3D
var _left_ik: TwoBoneIK3D
var _right_ik: TwoBoneIK3D
var _left_target: Marker3D
var _right_target: Marker3D
var _left_blend := 0.0
var _right_blend := 0.0
var _left_foot_idx := -1
var _right_foot_idx := -1
var _ankle_modifier: FootAnkleModifier
var _pose_modifier: FootPoseModifier
var _active := true
var _left_hit := {"colliding": false, "point": Vector3.ZERO, "normal": Vector3.UP}
var _right_hit := {"colliding": false, "point": Vector3.ZERO, "normal": Vector3.UP}

const BLEND_SPEED := 8.0
const RAY_ABOVE := 0.3
const RAY_BELOW := 0.4
const ANKLE_OFFSET := 0.05
const ANKLE_BONE_LEFT := "mixamorig_LeftFoot"
const ANKLE_BONE_RIGHT := "mixamorig_RightFoot"
# Lift is relative to the animated support foot. Imported crouch clips can
# translate both ankles far above the standing rest pose.
const PLANT_LIFT_START := 0.035
const PLANT_LIFT_END := 0.12


func initialize(model_manager: PlayerModelManager, _config: ModelLookupConfig) -> void:
	if is_instance_valid(_model_manager):
		if _model_manager.model_loaded.is_connected(_on_model_loaded):
			_model_manager.model_loaded.disconnect(_on_model_loaded)
		if _model_manager.model_unloaded.is_connected(clear):
			_model_manager.model_unloaded.disconnect(clear)
	clear()
	_model_manager = model_manager
	var node: Node = model_manager
	while node and not node is CharacterBody3D:
		node = node.get_parent()
	_player = node as CharacterBody3D
	_model_manager.model_loaded.connect(_on_model_loaded)
	_model_manager.model_unloaded.connect(clear)
	if is_instance_valid(model_manager.skeleton):
		_on_model_loaded(model_manager.model_node)


func clear() -> void:
	set_active(false)
	for modifier in [_pose_modifier, _ankle_modifier]:
		if is_instance_valid(modifier):
			modifier.active = false
			if modifier.get_parent():
				modifier.get_parent().remove_child(modifier)
			modifier.queue_free()
	_pose_modifier = null
	_ankle_modifier = null
	_skeleton = null
	_left_ik = null
	_right_ik = null
	_left_target = null
	_right_target = null
	_left_foot_idx = -1
	_right_foot_idx = -1
	_left_hit = {"colliding": false, "point": Vector3.ZERO, "normal": Vector3.UP}
	_right_hit = _left_hit.duplicate()


func _on_model_loaded(_model: Node3D) -> void:
	clear()
	_skeleton = _model_manager.skeleton
	_setup()
	set_active(true)


func _setup() -> void:
	if not is_instance_valid(_skeleton):
		return
	_left_ik = _skeleton.get_node_or_null("LeftFootIK") as TwoBoneIK3D
	_right_ik = _skeleton.get_node_or_null("RightFootIK") as TwoBoneIK3D
	_left_target = _skeleton.get_node_or_null("LeftFootTarget") as Marker3D
	_right_target = _skeleton.get_node_or_null("RightFootTarget") as Marker3D
	_left_foot_idx = _skeleton.find_bone(ANKLE_BONE_LEFT)
	_right_foot_idx = _skeleton.find_bone(ANKLE_BONE_RIGHT)
	_bind_leg(_left_ik, _left_target, _left_foot_idx)
	_bind_leg(_right_ik, _right_target, _right_foot_idx)
	if not _valid_leg(_left_ik, _left_target, _left_foot_idx) and not _valid_leg(_right_ik, _right_target, _right_foot_idx):
		GlobalLogger.warn("FootIK", "Model has no complete foot IK chain; ground adaptation disabled.")
		return
	_pose_modifier = FootPoseModifier.new()
	_pose_modifier.name = "FootPoseSync"
	_pose_modifier.controller = self
	_skeleton.add_child(_pose_modifier)
	# Sample the animated legs before either leg IK can feed its result back.
	var first_index := _skeleton.get_child_count() - 1
	for solver in [_left_ik, _right_ik]:
		if is_instance_valid(solver):
			first_index = mini(first_index, solver.get_index())
	_skeleton.move_child(_pose_modifier, first_index)
	_ankle_modifier = FootAnkleModifier.new()
	_ankle_modifier.name = "FootAnkleModifier"
	_skeleton.add_child(_ankle_modifier)
	_ankle_modifier.setup(_skeleton, self)


func _valid_leg(solver: TwoBoneIK3D, target: Marker3D, bone_idx: int) -> bool:
	if not is_instance_valid(solver) or solver.setting_count < 1 or not is_instance_valid(target) or bone_idx < 0:
		return false
	var root := solver.get_root_bone(0)
	var middle := solver.get_middle_bone(0)
	return root >= 0 and middle >= 0 and solver.get_end_bone(0) == bone_idx \
		and _skeleton.get_bone_parent(middle) == root and _skeleton.get_bone_parent(bone_idx) == middle \
		and solver.get_node_or_null(solver.get_pole_node(0)) is Marker3D


func _bind_leg(solver: TwoBoneIK3D, target: Marker3D, bone_idx: int) -> void:
	if is_instance_valid(solver):
		solver.influence = 0.0
	if _valid_leg(solver, target, bone_idx):
		solver.set_target_node(0, solver.get_path_to(target))


func _bone_world_position(bone_idx: int) -> Vector3:
	return (_skeleton.global_transform * _skeleton.get_bone_global_pose(bone_idx)).origin


func _update_leg_pole(pole: Marker3D, hip_idx: int, knee_idx: int, foot_idx: int) -> void:
	if not pole or hip_idx < 0 or knee_idx < 0 or foot_idx < 0:
		return
	var hip := _bone_world_position(hip_idx)
	var knee := _bone_world_position(knee_idx)
	var foot := _bone_world_position(foot_idx)
	var hip_to_foot := foot - hip
	var bend := knee - (hip + hip_to_foot * clampf(
		(knee - hip).dot(hip_to_foot) / maxf(hip_to_foot.length_squared(), 0.000001),
		0.0,
		1.0
	))
	if bend.length_squared() < 0.000001:
		bend = _skeleton.global_basis.z
	var pole_distance := maxf((knee - hip).length() + (foot - knee).length(), 0.3)
	pole.global_position = knee + bend.normalized() * pole_distance


func set_active(enabled: bool, fade_delta: float = 0.0) -> void:
	_active = enabled
	if not enabled:
		# Prone transitions fade; death/unload callers use the immediate default.
		_left_blend = move_toward(_left_blend, 0.0, BLEND_SPEED * fade_delta) if fade_delta > 0.0 else 0.0
		_right_blend = move_toward(_right_blend, 0.0, BLEND_SPEED * fade_delta) if fade_delta > 0.0 else 0.0
		if is_instance_valid(_left_ik):
			_left_ik.influence = _left_blend
		if is_instance_valid(_right_ik):
			_right_ik.influence = _right_blend
		if is_instance_valid(_ankle_modifier):
			_ankle_modifier.left_blend = _left_blend
			_ankle_modifier.right_blend = _right_blend
	if is_instance_valid(_pose_modifier):
		_pose_modifier.active = enabled
	if is_instance_valid(_ankle_modifier):
		_ankle_modifier.active = enabled or _left_blend > 0.0 or _right_blend > 0.0


func _physics_process(_delta: float) -> void:
	if not _active or not is_instance_valid(_skeleton):
		return
	# Physics queries stay in the physics tick. Pose targets and plant weights
	# use the current animation later, inside FootPoseModifier.
	_left_hit = _raycast_foot(_left_foot_idx)
	_right_hit = _raycast_foot(_right_foot_idx)


func process_ik(delta: float, enabled: bool = true) -> void:
	set_active(enabled)
	if not enabled or not is_instance_valid(_skeleton):
		return
	var on_ground := is_instance_valid(_player) and _player.is_on_floor()
	_left_blend = _update_leg(_left_ik, _left_target, _left_foot_idx, _left_hit, _left_blend, delta, on_ground)
	_right_blend = _update_leg(_right_ik, _right_target, _right_foot_idx, _right_hit, _right_blend, delta, on_ground)
	if is_instance_valid(_ankle_modifier):
		_ankle_modifier.left_normal = _left_hit.normal
		_ankle_modifier.right_normal = _right_hit.normal
		_ankle_modifier.left_blend = _left_blend
		_ankle_modifier.right_blend = _right_blend


func _plant_weight(bone_idx: int) -> float:
	var animated := _bone_world_position(bone_idx)
	var support_y := animated.y
	for foot_idx in [_left_foot_idx, _right_foot_idx]:
		if foot_idx >= 0:
			support_y = minf(support_y, _bone_world_position(foot_idx).y)
	var lift := maxf(animated.y - support_y, 0.0)
	return 1.0 - smoothstep(PLANT_LIFT_START, PLANT_LIFT_END, lift)


func _update_leg(solver: TwoBoneIK3D, target: Marker3D, bone_idx: int, hit: Dictionary, blend: float, delta: float, on_ground: bool) -> float:
	if not _valid_leg(solver, target, bone_idx):
		if is_instance_valid(solver):
			solver.influence = 0.0
		return 0.0
	var knee := _skeleton.get_bone_parent(bone_idx)
	_update_leg_pole(solver.get_node(solver.get_pole_node(0)) as Marker3D, _skeleton.get_bone_parent(knee), knee, bone_idx)
	var plant := _plant_weight(bone_idx)
	var weight := plant if on_ground and hit.colliding else 0.0
	# Fade contact acquisition, but never let last frame's weight pin a lifted foot.
	blend = minf(move_toward(blend, weight, BLEND_SPEED * maxf(delta, 0.0)), plant)
	var animated_world := _skeleton.global_transform * _skeleton.get_bone_global_pose(bone_idx).origin
	if hit.colliding and on_ground:
		# Project this frame's foot onto the cached contact plane, keeping animation X/Z.
		var normal: Vector3 = hit.normal
		if normal.y > 0.1:
			var ground_y: float = hit.point.y - (normal.x * (animated_world.x - hit.point.x) + normal.z * (animated_world.z - hit.point.z)) / normal.y
			target.global_position = Vector3(animated_world.x, ground_y + ANKLE_OFFSET, animated_world.z)
		else:
			blend = 0.0
	else:
		target.global_position = animated_world
	solver.influence = blend
	return blend


func _raycast_foot(bone_idx: int) -> Dictionary:
	var result := {"colliding": false, "point": Vector3.ZERO, "normal": Vector3.UP}
	if bone_idx < 0 or not is_instance_valid(_skeleton):
		return result
	var foot_world := (_skeleton.global_transform * _skeleton.get_bone_global_pose(bone_idx)).origin
	var query := PhysicsRayQueryParameters3D.create(foot_world + Vector3.UP * RAY_ABOVE, foot_world + Vector3.DOWN * RAY_BELOW, PhysicsLayers.WORLD)
	if is_instance_valid(_player):
		query.exclude = [_player.get_rid()]
	var hit := _skeleton.get_world_3d().direct_space_state.intersect_ray(query)
	if not hit.is_empty():
		result.colliding = true
		result.point = hit.position
		result.normal = hit.normal
	return result


class FootPoseModifier extends SkeletonModifier3D:
	var controller: FootIKController

	func _process_modification_with_delta(delta: float) -> void:
		if is_instance_valid(controller) and controller._active:
			controller.process_ik(delta)


class FootAnkleModifier extends SkeletonModifier3D:
	var _left_idx := -1
	var _right_idx := -1
	var left_normal := Vector3.UP
	var right_normal := Vector3.UP
	var left_blend := 0.0
	var right_blend := 0.0

	func setup(skeleton: Skeleton3D, _controller: FootIKController) -> void:
		_left_idx = skeleton.find_bone(ANKLE_BONE_LEFT)
		_right_idx = skeleton.find_bone(ANKLE_BONE_RIGHT)

	func _process_modification() -> void:
		if _left_idx >= 0 and left_blend > 0.001:
			_apply_ankle_rotation(_left_idx, left_normal, left_blend)
		if _right_idx >= 0 and right_blend > 0.001:
			_apply_ankle_rotation(_right_idx, right_normal, right_blend)

	func _apply_ankle_rotation(bone_idx: int, ground_normal: Vector3, blend: float) -> void:
		var skel := get_skeleton()
		if not skel:
			return
		var axis := Vector3.UP.cross(ground_normal)
		if axis.length_squared() < 0.0001:
			return
		var angle := minf(Vector3.UP.angle_to(ground_normal), deg_to_rad(25.0)) * blend
		var world_extra := Quaternion(axis.normalized(), angle)
		var parent_world := skel.global_basis.orthonormalized()
		var parent_idx := skel.get_bone_parent(bone_idx)
		if parent_idx >= 0:
			parent_world *= skel.get_bone_global_pose(parent_idx).basis.orthonormalized()
		var local_extra := Quaternion(parent_world).inverse() * world_extra * Quaternion(parent_world)
		skel.set_bone_pose_rotation(bone_idx, (local_extra * skel.get_bone_pose_rotation(bone_idx)).normalized())
