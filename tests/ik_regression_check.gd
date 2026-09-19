extends Node

var failures := 0
var wrist_samples := 0
var wrist_error := 0.0


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
	_check(foot._left_ik != null and foot._right_ik != null, "default model supplies both foot solvers")
	_check(foot._left_target != null and foot._right_target != null, "default model supplies both foot targets")
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

	# Observe the real engine modifier chain at full influence.
	var saved_config := hand._config
	hand._config = saved_config.duplicate()
	hand._config.walk_ik_weight = 1.0
	hand._config.run_ik_weight = 1.0
	hand._config.ads_ik_weight = 1.0
	hand._config.wrist_rotation_offset = Vector3(35, 70, -20)
	hand._ik_weight = 1.0
	hand.set_movement_state(false, false)
	hand.process_ik(1.0)
	hand._wrist_modifier.modification_processed.connect(func():
		var actual := (skeleton.global_basis.orthonormalized() * skeleton.get_bone_global_pose(hand._hand_bone_idx).basis.orthonormalized()).get_rotation_quaternion()
		var desired := hand._hand_target.global_basis.orthonormalized().get_rotation_quaternion()
		if hand._current_weight > 0.999:
			wrist_samples += 1
			wrist_error = maxf(wrist_error, actual.angle_to(desired))
	)
	for i in 30:
		await get_tree().process_frame
	_check(wrist_samples > 0 and wrist_error < 0.002, "wrist orientation reaches target after arm solve")
	hand._config = saved_config
	_test_rotation_spaces()
	_test_grip_priority()

	# Freeze animation and use an explicit pose so swing/contact assertions are deterministic.
	player.set_process(false)
	player.set_physics_process(false)
	player.animation_controller._animation_tree.active = false
	foot.set_active(false)
	# Upstream uses authored wrist targets instead of automatic calibration.
	var authored_target := hand._left_hand_wrist_target
	_check(is_instance_valid(authored_target), "default weapon has an authored wrist target")
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
	_check(skeleton.get_node_or_null("LeftHandWrist") == hand._wrist_modifier, "repeated model binding replaces modifiers without duplicates")
	player.model_manager.model_unloaded.emit()
	_check(hand._ik_node == null and foot._left_ik == null, "model unload clears both controllers")
	print("ik_regression_check=%s failures=%d wrist_samples=%d wrist_error_deg=%.4f" % ["ok" if failures == 0 else "FAILED", failures, wrist_samples, rad_to_deg(wrist_error)])
	get_tree().quit(0 if failures == 0 else 1)


func _test_rotation_spaces() -> void:
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
