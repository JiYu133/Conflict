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
	await get_tree().process_frame
	await get_tree().process_frame

	var player := map.get_node_or_null("CharacterBody3D") as BasePlayer
	if not _check(player != null, "player initializes"):
		return
	var skeleton := player.model_manager.skeleton
	var spine := player.spine_aim_controller
	var hand_ik := player.hand_ik_controller
	if not _check(skeleton != null and spine._modifier != null, "spine modifier initializes"):
		return
	if not _check(spine._modifier.get_valid_bone_count() >= 4, "spine aim includes available neck and head bones"):
		return
	if not _check(hand_ik._target_modifier != null and hand_ik._ik_node != null, "hand IK modifiers initialize"):
		return

	if not _check(
		spine._modifier.get_index() < hand_ik._target_modifier.get_index()
		and hand_ik._target_modifier.get_index() < hand_ik._ik_node.get_index(),
		"modifier order is spine -> hand target -> IK"
	):
		return

	var upper_spine_idx := skeleton.find_bone("mixamorig_Spine2")
	if not _check(upper_spine_idx != -1, "upper spine bone exists"):
		return
	var before_basis := skeleton.get_bone_global_pose(upper_spine_idx).basis.orthonormalized()
	var weapon_attachment := _find_parent_bone_attachment(hand_ik._left_hand_grip)
	if not _check(weapon_attachment != null, "weapon grip has a bone attachment parent"):
		return
	var attachment_before := weapon_attachment.global_transform

	player.camera_controller._vertical_angle = deg_to_rad(35.0)
	spine.process_aim(1.0, true)
	hand_ik.process_ik(1.0, true)
	# SkeletonModifier 的结果只在骨架更新阶段生效，帧末会恢复动画基姿态。
	# 在同一阶段手动执行两个修饰器，验证实际参与 IK 求解的姿态和目标。
	spine._modifier._process_modification()

	var after_basis := skeleton.get_bone_global_pose(upper_spine_idx).basis.orthonormalized()
	var spine_change := before_basis.get_rotation_quaternion().angle_to(after_basis.get_rotation_quaternion())
	if not _check(spine_change > deg_to_rad(2.0), "view pitch changes the spine pose"):
		return
	hand_ik._target_modifier._process_modification()
	if not _check(attachment_before.origin.distance_to(weapon_attachment.global_position) > 0.001, "weapon attachment refreshes after spine aim"):
		return
	player.camera_controller._view_yaw = player.rotation.y + deg_to_rad(30.0)
	player.turn_controller._turning = true
	spine.process_aim(1.0, true)
	if not _check(absf(spine._modifier.yaw_radians) > deg_to_rad(20.0), "view yaw continues to drive the spine during a turn"):
		return
	player.look_controller.begin_free_look()
	player.look_controller._free_yaw_offset = deg_to_rad(15.0)
	spine.process_aim(1.0, true)
	if not _check(absf(spine._modifier.free_yaw_radians) > deg_to_rad(10.0), "free look drives the head-only rotation channel"):
		return
	if not _check(absf(spine._modifier.yaw_radians) < deg_to_rad(35.0), "free look does not add to the weapon aiming channel"):
		return
	player.look_controller.end_free_look()
	player.look_controller._free_yaw_offset = 0.0
	player.turn_controller._turning = false

	var grip_xf := hand_ik._get_current_grip_transform()
	var expected_target := grip_xf.origin \
		+ grip_xf.basis.orthonormalized() * hand_ik._config.grip_position_offset
	var target_error := hand_ik._hand_target.global_position.distance_to(expected_target)
	if not _check(target_error < 0.002, "hand target follows the current-frame weapon grip"):
		return

	player.stance_controller._is_prone = true
	player.stance_controller._prone_transition = true
	player._process(0.1)
	if not _check(not spine._modifier.apply_aim, "prone disables upper-body aim following"):
		return
	if not _check(hand_ik._is_prone, "prone state is forwarded to hand IK"):
		return
	if not _check(hand_ik._elbow_pole != null, "left-hand IK has an elbow pole"):
		return
	var authored_pole := hand_ik._authored_elbow_pole_transform
	hand_ik._target_modifier._process_modification()
	if not _check(hand_ik._elbow_pole.transform == authored_pole, "prone keeps the authored elbow bend"):
		return
	if not _check(not hand_ik._target_modifier.sync_enabled, "prone transition disables left-hand IK target syncing"):
		return
	if not _check(is_zero_approx(hand_ik._ik_node.influence), "prone transition clears hand IK influence"):
		return
	player.stance_controller._prone_transition = false
	player.stance_controller._is_prone = false
	hand_ik.set_prone_state(false)
	if not _check(hand_ik._elbow_pole.transform == authored_pole, "standing restores the authored elbow pole"):
		return

	print("spine_hand_ik_check=ok spine_change_deg=%.2f target_error_mm=%.3f" % [
		rad_to_deg(spine_change), target_error * 1000.0
	])
	get_tree().quit(0)


func _find_parent_bone_attachment(node: Node) -> BoneAttachment3D:
	var current := node
	while current:
		if current is BoneAttachment3D:
			return current as BoneAttachment3D
		current = current.get_parent()
	return null


func _check(condition: bool, message: String) -> bool:
	if condition:
		return true
	push_error(message)
	get_tree().quit(1)
	return false
