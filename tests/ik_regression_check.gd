extends Node

var failures := 0
var left_hand_samples := 0
var right_hand_samples := 0
var left_hand_error := 0.0
var right_hand_error := 0.0
var record_hand_errors := true


func _ready() -> void:
	_run.call_deferred()


func _check(ok: bool, message: String) -> void:
	if not ok:
		failures += 1
		push_error(message)


func _run() -> void:
	var map := (load("res://assets/map/TestMap.tscn") as PackedScene).instantiate()
	get_tree().root.add_child(map)
	for i in 10:
		await get_tree().physics_frame
	var player := map.get_node("CharacterBody3D") as BasePlayer
	var hand := player.hand_ik_controller
	var foot := player.foot_ik_controller
	var skeleton := player.model_manager.skeleton
	var spine := player.spine_aim_controller
	var weapon := player.weapon_manager.current_weapon
	spine.process_aim(0.016, true)
	var expected_head_target := weapon.get_muzzle_position() \
			+ weapon.get_muzzle_direction() * SpineAimController.HEAD_MUZZLE_TARGET_DISTANCE
	_check(
		spine._modifier.head_target_valid \
				and spine._modifier.head_target_world_position.distance_to(expected_head_target) < 0.0001,
		"head target comes from the same muzzle ray used by projectiles"
	)
	_check(foot._left_ik != null and foot._right_ik != null, "default model supplies both foot solvers")
	_check(foot._left_target != null and foot._right_target != null, "default model supplies both foot targets")
	_check(hand._ik_node != null and hand._right_ik_node != null, "default model supplies both hand solvers")
	_check(hand._hand_target != null and hand._right_hand_target != null, "default model supplies both hand targets")
	_check(
		hand._target_modifier.get_index() < hand._ik_node.get_index()
			and hand._target_modifier.get_index() < hand._right_ik_node.get_index(),
		"weapon pose and both hand targets update before arm solving"
	)
	_check(foot._pose_modifier.get_index() < foot._left_ik.get_index() and foot._pose_modifier.get_index() < foot._right_ik.get_index(), "animated feet sampled before both solvers")
	for solver in [foot._left_ik, foot._right_ik]:
		_check(solver.get_root_bone(0) >= 0 and solver.get_middle_bone(0) >= 0 and solver.get_end_bone(0) >= 0, "authored leg chain resolves")
		_check(solver.get_node_or_null(solver.get_target_node(0)) != null, "foot target path resolves")
		_check(solver.get_node_or_null(solver.get_pole_node(0)) != null, "knee pole path resolves")

	hand.set_movement_state(false, false)
	player.weapon_manager.set_aiming(true)
	_check(hand._is_ads and is_equal_approx(hand._target_weight, hand._ik_weight * hand._config.ads_ik_weight), "ADS signal selects configured IK weight")
	hand.set_movement_state(true, false)
	_check(is_equal_approx(hand._target_weight, hand._ik_weight * hand._config.ads_ik_weight), "ADS takes precedence over running")
	player.weapon_manager.set_aiming(false)
	_check(not hand._is_ads and is_equal_approx(hand._target_weight, hand._ik_weight * hand._config.run_ik_weight), "leaving ADS restores movement weight")
	hand.set_prone_state(true)
	_check(is_equal_approx(hand._target_weight, hand._ik_weight * hand._config.prone_ik_weight), "prone state selects configured IK weight")
	hand.set_prone_state(false)

	# Observe the real engine modifier chain at full influence.
	var saved_config := hand._config
	hand._config = saved_config.duplicate()
	hand._config.walk_ik_weight = 1.0
	hand._config.run_ik_weight = 1.0
	hand._config.ads_ik_weight = 1.0
	hand._ik_weight = 1.0
	hand.set_movement_state(false, false)
	hand.process_ik(1.0)
	hand._ik_node.modification_processed.connect(func():
		if record_hand_errors and hand._current_weight > 0.999:
			left_hand_samples += 1
			var actual := skeleton.global_transform * skeleton.get_bone_global_pose(hand._hand_bone_idx).origin
			left_hand_error = maxf(left_hand_error, actual.distance_to(hand._hand_target.global_position))
	)
	hand._right_ik_node.modification_processed.connect(func():
		if record_hand_errors and hand._current_weight > 0.999:
			right_hand_samples += 1
			var actual := skeleton.global_transform * skeleton.get_bone_global_pose(hand._right_hand_bone_idx).origin
			right_hand_error = maxf(right_hand_error, actual.distance_to(hand._right_hand_target.global_position))
	)
	for i in 30:
		await get_tree().process_frame
	_check(left_hand_samples > 0 and left_hand_error < 0.01, "left arm IK reaches the live weapon target")
	_check(right_hand_samples > 0 and right_hand_error < 0.01, "right arm IK reaches the live weapon target")
	record_hand_errors = false
	hand._config = saved_config
	_test_rotation_spaces(player)
	_test_grip_priority()

	# Freeze animation and use an explicit pose so swing/contact assertions are deterministic.
	player.set_process(false)
	player.set_physics_process(false)
	player.animation_controller._animation_tree.active = false
	foot.set_active(false)
	# Upstream uses authored wrist targets instead of automatic calibration.
	var authored_target := hand._left_hand_wrist_target
	_check(is_instance_valid(authored_target), "default weapon has an authored wrist target")
	var authored_grip := hand._left_hand_grip
	var saved_grip_transform := authored_grip.global_transform
	var saved_wrist_transform := authored_target.global_transform
	var displaced_grip := saved_grip_transform
	displaced_grip.origin += Vector3(0.04, -0.02, 0.03)
	authored_grip.global_transform = displaced_grip
	var wrist_orientation := Basis.from_euler(Vector3(0.3, -0.5, 0.7))
	var displaced_wrist := Transform3D(wrist_orientation, saved_wrist_transform.origin + Vector3(0.7, 0.4, -0.6))
	authored_target.global_transform = displaced_wrist
	hand._update_hand_target()
	var expected_grip_origin := displaced_grip.origin \
		+ displaced_grip.basis.orthonormalized() * hand._config.grip_position_offset \
		- hand._get_current_wrist_to_palm_world() * hand._config.fallback_palm_contact_ratio \
		+ displaced_grip.basis.orthonormalized() * hand._config.fallback_wrist_position_offset
	_check(hand._hand_target.global_position.distance_to(expected_grip_origin) < 0.0001, "wrist target position remains owned by the grip")
	_check(hand._hand_target.global_basis.orthonormalized().is_equal_approx(wrist_orientation.orthonormalized()), "wrist target orientation drives wrist rotation")
	authored_grip.global_transform = saved_grip_transform
	authored_target.global_transform = saved_wrist_transform
	hand._left_hand_grip = null
	hand._update_hand_target()
	_check(hand._hand_target.global_transform.is_equal_approx(authored_target.global_transform), "wrist-only weapons preserve the authored target transform")
	hand._on_attachments_changed()
	_check(is_instance_valid(hand._left_hand_grip) and hand._left_hand_wrist_target == authored_target, "attachment update refreshes grip and wrist references")
	hand._config = saved_config
	# Exercise the actual TwoBoneIK implementation, not just target calculations.
	skeleton.reset_bone_poses()
	for side in ["left", "right"]:
		var solver: TwoBoneIK3D = foot.get("_%s_ik" % side)
		var target: Marker3D = foot.get("_%s_target" % side)
		var tip: int = foot.get("_%s_foot_idx" % side)
		target.global_position = skeleton.global_transform * skeleton.get_bone_global_pose(tip).origin + Vector3.UP * 0.06
		solver.influence = 1.0
		var errors: Array[float] = []
		solver.modification_processed.connect(func():
			errors.append((skeleton.global_transform * skeleton.get_bone_global_pose(tip).origin).distance_to(target.global_position))
		, CONNECT_ONE_SHOT)
		await get_tree().process_frame
		await get_tree().process_frame
		_check(not errors.is_empty() and errors[0] < 0.005, "%s leg solver reaches raised ground target" % side)
		solver.influence = 0.0
	var bone := foot._left_foot_idx
	skeleton.reset_bone_poses()
	var hit := {"colliding": true, "point": Vector3.ZERO, "normal": Vector3.UP}
	var blend := foot._update_leg(foot._left_ik, foot._left_target, bone, hit, 0.0, 1.0, true)
	_check(is_equal_approx(blend, 1.0), "planted foot acquires ground contact")
	_check(is_equal_approx(foot._left_target.global_position.y, FootIKController.ANKLE_OFFSET), "planted target includes ankle clearance")
	var parent := skeleton.get_bone_parent(bone)
	var parent_world := skeleton.global_basis * skeleton.get_bone_global_pose(parent).basis
	skeleton.set_bone_pose_position(bone, skeleton.get_bone_pose_position(bone) + parent_world.inverse() * Vector3.UP * 0.2)
	blend = foot._update_leg(foot._left_ik, foot._left_target, bone, hit, 1.0, 0.016, true)
	_check(is_zero_approx(blend) and is_zero_approx(foot._left_ik.influence), "lifted swing foot immediately releases ground IK")
	skeleton.reset_bone_poses()
	blend = foot._update_leg(foot._left_ik, foot._left_target, bone, hit, 1.0, 1.0, false)
	_check(is_zero_approx(blend), "airborne body releases foot IK")
	foot._left_ik.influence = 0.8
	foot._right_ik.influence = 0.8
	foot._left_blend = 0.8
	foot._right_blend = 0.8
	foot.set_active(false, 0.016)
	_check(foot._left_ik.influence > 0.0 and foot._left_ik.influence < 0.8, "prone transition retains gradual foot fade")
	player.is_ragdolled = true
	player._process(0.016)
	_check(foot._left_ik.influence == 0.0 and foot._right_ik.influence == 0.0 and not foot._ankle_modifier.active, "ragdoll gate immediately clears both feet and ankles")
	player.is_ragdolled = false
	player._process(0.016)
	_check(foot._pose_modifier.active and foot._ankle_modifier.active, "leaving ragdoll re-enables foot updates")
	foot.set_active(false)

	var old_solver := hand._ik_node
	var old_sync := hand._target_modifier
	old_solver.influence = 0.65
	hand.setup(null, saved_config)
	_check(old_solver.influence == 0.0 and not old_sync.active and hand._ik_node == null, "failed model bind disables old hand chain")
	hand.setup(skeleton, saved_config)
	hand.setup(skeleton, saved_config)
	_check(skeleton.get_node_or_null("LeftHandTargetSync") == hand._target_modifier, "repeated model binding replaces target sync without duplicates")
	_check(skeleton.get_node_or_null("LeftHandWrist") == null, "hand placement does not install a direct wrist rotation modifier")
	player.model_manager.model_unloaded.emit()
	_check(hand._ik_node == null and foot._left_ik == null, "model unload clears both controllers")
	print("ik_regression_check=%s failures=%d left_error=%.4f right_error=%.4f" % ["ok" if failures == 0 else "FAILED", failures, left_hand_error, right_hand_error])
	get_tree().quit(0 if failures == 0 else 1)


func _test_rotation_spaces(player: BasePlayer) -> void:
	var skeleton := Skeleton3D.new()
	add_child(skeleton)
	skeleton.rotation = Vector3(0.2, 0.7, -0.1)
	skeleton.add_bone("parent")
	skeleton.add_bone("child")
	skeleton.set_bone_parent(1, 0)
	skeleton.set_bone_rest(0, Transform3D(Basis.from_euler(Vector3(0.3, -0.4, 0.2)), Vector3.ZERO))
	skeleton.set_bone_rest(1, Transform3D(Basis.from_euler(Vector3(-0.6, 0.1, 0.8)), Vector3.UP))
	skeleton.reset_bone_poses()
	var spine := SpineAimController.SpineAimModifier.new()
	skeleton.add_child(spine)
	var before := skeleton.get_bone_global_pose(1).basis.get_rotation_quaternion()
	var delta := Quaternion(Vector3.RIGHT, deg_to_rad(30.0))
	spine._apply_global_rotation(skeleton, 1, delta)
	var actual := skeleton.get_bone_global_pose(1).basis.get_rotation_quaternion()
	_check(actual.angle_to(delta * before) < 0.002, "spine applies skeleton-space rotation with nonidentity bone rests")
	_test_head_muzzle_alignment(player)
	skeleton.reset_bone_poses()
	var ankle := FootIKController.FootAnkleModifier.new()
	skeleton.add_child(ankle)
	before = (skeleton.global_basis * skeleton.get_bone_global_pose(1).basis).get_rotation_quaternion()
	var normal := Vector3(0.25, 1.0, 0.15).normalized()
	delta = Quaternion(Vector3.UP.cross(normal).normalized(), Vector3.UP.angle_to(normal) * 0.6)
	ankle._apply_ankle_rotation(1, normal, 0.6)
	actual = (skeleton.global_basis * skeleton.get_bone_global_pose(1).basis).get_rotation_quaternion()
	_check(actual.angle_to(delta * before) < 0.002, "ankle applies world-space tilt with rotated skeleton and bone rests")
	skeleton.queue_free()


func _test_head_muzzle_alignment(player: BasePlayer) -> void:
	var skeleton := Skeleton3D.new()
	player.add_child(skeleton)
	skeleton.rotation = Vector3(-0.12, 0.48, 0.08)
	skeleton.add_bone("mixamorig_Head")
	skeleton.set_bone_rest(0, Transform3D(
		Basis.from_euler(Vector3(0.4, -0.7, 0.25)), Vector3.UP
	))
	skeleton.reset_bone_poses()
	var config := SpineAimConfig.new()
	config.bone_names = []
	config.bone_weights = []
	config.free_look_bone_names = []
	config.free_look_bone_weights = []
	var modifier := SpineAimController.SpineAimModifier.new()
	skeleton.add_child(modifier)
	modifier.setup(player, config)
	modifier._process_modification()
	# Simulate an animation rotating the head away from the weapon target.
	skeleton.set_bone_pose_rotation(0, Quaternion.from_euler(Vector3(-0.3, 0.5, 0.2)))
	modifier.head_target_world_position = player.global_position + Vector3(7.0, 3.0, -11.0)
	modifier.head_target_valid = true
	modifier._process_modification()
	var head_pose := skeleton.get_bone_global_pose(0)
	var head_basis := (
		skeleton.global_basis.orthonormalized()
		* head_pose.basis
	).orthonormalized()
	var actual_view := (head_basis * modifier._head_to_view_basis).orthonormalized()
	var head_position := skeleton.global_transform * head_pose.origin
	var expected_direction := (
		modifier.head_target_world_position - head_position
	).normalized()
	_check(
		(-actual_view.z).dot(expected_direction) > 0.99999,
		"head view calibration looks at the actual muzzle target"
	)
	modifier.queue_free()
	skeleton.queue_free()


func _test_grip_priority() -> void:
	var weapon := BaseWeapon.new()
	var handguard := AttachmentSlot.new()
	handguard.slot_type = AttachmentSlot.SlotType.HANDGUARD
	weapon.add_child(handguard)
	var grip := Marker3D.new()
	grip.name = "LeftHandGrip"
	handguard.add_child(grip)
	var underbarrel := AttachmentSlot.new()
	underbarrel.slot_type = AttachmentSlot.SlotType.UNDERBARREL
	handguard.add_child(underbarrel)
	var nested_grip := Marker3D.new()
	nested_grip.name = "LeftHandGrip"
	underbarrel.add_child(nested_grip)
	_check(weapon._grip_node_score(nested_grip) > weapon._grip_node_score(grip), "nested underbarrel grip outranks ancestor handguard")
	weapon.free()
