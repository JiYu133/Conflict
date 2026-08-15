extends Node


func _ready() -> void:
	_run.call_deferred()


func _run() -> void:
	var scene := load("res://assets/map/TestMap.tscn") as PackedScene
	if not _check(scene != null, "TestMap scene loads"):
		return
	var map := scene.instantiate()
	get_tree().root.add_child(map)
	await get_tree().process_frame
	await get_tree().physics_frame
	await get_tree().physics_frame

	var player := map.get_node_or_null("CharacterBody3D") as BasePlayer
	if not _check(player != null, "player initializes"):
		return
	var foot := player.foot_ik_controller
	var skeleton := player.model_manager.skeleton
	if not _check(foot != null and skeleton != null, "foot IK controller initializes"):
		return
	if not _check(foot._left_ready and foot._right_ready, "both authored foot IK chains are complete"):
		return
	if not _check(
		foot._left_ik.get_node_or_null(foot._left_ik.get("settings/0/target_node")) == foot._left_target
		and foot._right_ik.get_node_or_null(foot._right_ik.get("settings/0/target_node")) == foot._right_target,
		"foot solvers point at their authored targets"
	):
		return
	if not _check(
		foot._left_ik.get_node_or_null(foot._left_ik.get("settings/0/pole_node")) == foot._left_pole
		and foot._right_ik.get_node_or_null(foot._right_ik.get("settings/0/pole_node")) == foot._right_pole,
		"foot solvers point at their knee poles"
	):
		return
	if not _check(
		int(foot._left_ik.get("settings/0/root_bone")) == foot._left_hip_idx
		and int(foot._left_ik.get("settings/0/middle_bone")) == foot._left_knee_idx
		and int(foot._left_ik.get("settings/0/end_bone")) == foot._left_foot_idx
		and int(foot._right_ik.get("settings/0/root_bone")) == foot._right_hip_idx
		and int(foot._right_ik.get("settings/0/middle_bone")) == foot._right_knee_idx
		and int(foot._right_ik.get("settings/0/end_bone")) == foot._right_foot_idx,
		"foot solvers bind the intended hip-knee-ankle chains"
	):
		return
	if not _check(
		foot._ankle_modifier.get_index() > foot._left_ik.get_index()
		and foot._ankle_modifier.get_index() > foot._right_ik.get_index(),
		"ankle alignment executes after both leg solvers"
	):
		return

	# A partially authored side must never gain influence.
	if not _check(
		not foot._is_leg_complete(
			foot._left_ik, null, foot._left_pole,
			foot._left_hip_idx, foot._left_knee_idx, foot._left_foot_idx
		),
		"missing target invalidates the complete solver tuple"
	):
		return

	# Prone/roll deactivation should fade instead of snapping from one to zero.
	foot._left_blend = 1.0
	foot._right_blend = 1.0
	foot._apply_blends()
	foot.process_ik(0.05, false)
	if not _check(
		foot._left_ik.influence > 0.0 and foot._left_ik.influence < 1.0
		and foot._right_ik.influence > 0.0 and foot._right_ik.influence < 1.0,
		"inactive foot IK fades over multiple frames"
	):
		return
	foot.process_ik(1.0, false)
	if not _check(
		is_zero_approx(foot._left_ik.influence) and is_zero_approx(foot._right_ik.influence),
		"inactive foot IK eventually reaches zero"
	):
		return
	foot.process_ik(1.0, true)
	if not _check(
		player.is_on_floor()
		and foot._left_ik.influence > 0.9
		and foot._right_ik.influence > 0.9,
		"ground contact drives both authored foot solvers"
	):
		return

	# Verify the ankle's world-space slope rotation is converted through its
	# animated bone parent, which is the space set_bone_pose_rotation expects.
	player.rotation.y = deg_to_rad(37.0)
	var world_rotation := Quaternion(Vector3(0.4, 0.1, 0.8).normalized(), deg_to_rad(11.0))
	var local_rotation := foot._ankle_modifier._world_rotation_to_bone_parent_space(
		foot._left_foot_idx, world_rotation
	)
	var parent_idx := skeleton.get_bone_parent(foot._left_foot_idx)
	var parent_world_basis := (
		skeleton.global_basis * skeleton.get_bone_global_pose(parent_idx).basis
	).orthonormalized()
	var parent_world_rotation := parent_world_basis.get_rotation_quaternion()
	var reconstructed := (
		parent_world_rotation * local_rotation * parent_world_rotation.inverse()
	).normalized()
	if not _check(
		reconstructed.angle_to(world_rotation) < 0.0001,
		"ankle rotation is expressed in bone-parent space"
	):
		return

	print("foot_ik_check=ok")
	get_tree().quit(0)


func _check(condition: bool, message: String) -> bool:
	if condition:
		return true
	push_error(message)
	get_tree().quit(1)
	return false
