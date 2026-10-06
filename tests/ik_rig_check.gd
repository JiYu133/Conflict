extends Node

## IKRig regression check: solver math, modifier order, both hands on the
## weapon in every stance, finger grip, feet on the ground, prone fade,
## ragdoll gate and model rebinding — all through the real player pipeline.
## Run: godot --headless --path . res://tests/ik_rig_check.tscn

const POSITION_TOLERANCE := 0.002
const ROTATION_TOLERANCE_DEG := 1.0
const FOOT_TOLERANCE := 0.005
const WALK_FOOT_TOLERANCE := 0.025

var failures := 0
var player: BasePlayer
var rig: IKRig
var skeleton: Skeleton3D
var label := ""
var stats := {}


func _ready() -> void:
	_run.call_deferred()


func _check(ok: bool, message: String) -> void:
	if not ok:
		failures += 1
		push_error(message)


func _frames(count: int) -> void:
	for i in count:
		await get_tree().process_frame


func _world(bone: int) -> Transform3D:
	return TwoBoneIK.bone_world_transform(skeleton, bone)


func _elbow_down(arm: ArmIK) -> float:
	var shoulder := _world(arm.upper).origin
	var elbow := _world(arm.lower).origin
	var wrist := _world(arm.hand).origin
	var line := wrist - shoulder
	var bend := elbow - (shoulder + line * clampf((elbow - shoulder).dot(line) / line.length_squared(), 0.0, 1.0))
	return bend.normalized().dot(Vector3.DOWN)


## Sampled right after the arm stage, where the targets are this frame's.
func _sample_arms() -> void:
	if label == "":
		return
	var s: Dictionary = stats.get(label, {"n": 0, "pos": 0.0, "rot": 0.0, "left_elbow": 1.0, "right_elbow": 1.0, "unreachable": 0})
	for arm in [rig.right_arm, rig.left_arm]:
		if not arm.has_target or arm.weight < 0.999:
			continue
		var shoulder := _world(arm.upper).origin
		if shoulder.distance_to(arm.target.origin) > arm.length(skeleton) * 0.999:
			s.unreachable += 1
			continue
		var wrist := _world(arm.hand)
		s.pos = maxf(s.pos, wrist.origin.distance_to(arm.target.origin))
		s.rot = maxf(s.rot, rad_to_deg(wrist.basis.get_rotation_quaternion().angle_to(arm.target.basis.get_rotation_quaternion())))
		s.n += 1
	s.left_elbow = minf(s.left_elbow, _elbow_down(rig.left_arm))
	s.right_elbow = minf(s.right_elbow, _elbow_down(rig.right_arm))
	stats[label] = s


func _sample_feet() -> void:
	if label == "":
		return
	var s: Dictionary = stats.get(label, {})
	var error: float = s.get("foot", 0.0)
	for leg in [rig.left_leg, rig.right_leg]:
		if leg.blend > 0.99:
			error = maxf(error, _world(leg.foot).origin.distance_to(leg.target))
	s["foot"] = error
	s["pelvis"] = maxf(s.get("pelvis", 0.0), rig.get_pelvis_drop())
	var released: int = s.get("released", 0)
	var planted: int = s.get("planted", 0)
	for leg in [rig.left_leg, rig.right_leg]:
		planted += 1 if leg.blend > 0.99 else 0
		released += 1 if leg.blend < 0.95 else 0
	s["planted"] = planted
	s["released"] = released
	stats[label] = s


func _measure(name: String, frames: int) -> Dictionary:
	label = name
	await _frames(frames)
	label = ""
	return stats.get(name, {})


func _check_hold(name: String, frames: int = 30, min_left_elbow: float = 0.3) -> void:
	var s := await _measure(name, frames)
	_check(s.get("n", 0) > 0 and s.get("unreachable", 0) == 0, "%s: both hands solved on a reachable weapon" % name)
	_check(s.get("pos", 1.0) < POSITION_TOLERANCE, "%s: wrists reach their weapon targets (%.4f m)" % [name, s.get("pos", 1.0)])
	_check(s.get("rot", 180.0) < ROTATION_TOLERANCE_DEG, "%s: wrists turn to their weapon targets (%.2f deg)" % [name, s.get("rot", 180.0)])
	_check(s.get("left_elbow", -1.0) > min_left_elbow, "%s: support elbow points down (%.2f)" % [name, s.get("left_elbow", -1.0)])
	_check(s.get("right_elbow", -1.0) > 0.0, "%s: trigger elbow never points up (%.2f)" % [name, s.get("right_elbow", -1.0)])


func _run() -> void:
	_test_solver()
	_test_grip_priority()

	var map := (load("res://assets/map/TestMap.tscn") as PackedScene).instantiate()
	add_child(map)
	await _frames(20)
	player = map.get_node("CharacterBody3D") as BasePlayer
	rig = player.ik_rig
	skeleton = player.model_manager.skeleton
	player.is_ai_player = true

	var order: Array[String] = []
	for child in skeleton.get_children():
		if child is SkeletonModifier3D:
			order.append(String(child.name))
	_check(order == ["SpineAimModifier", "ForceBodyModifier", "IKLegs", "IKArms", "PhysicalBoneSimulator3D"], "IK runs after pose layers and before ragdoll physics: %s" % [order])
	_check(skeleton.find_children("*", "TwoBoneIK3D", false, false).is_empty(), "no scene-authored IK nodes remain")
	_check(rig.left_arm.finger_count() > 0 and rig.right_arm.finger_count() > 0, "grip finger pose sampled for both hands")

	rig.arms_processed.connect(_sample_arms)
	skeleton.skeleton_updated.connect(_sample_feet)
	await _frames(60)
	await _check_hold("idle")
	var idle: Dictionary = stats["idle"]
	_check(idle.get("foot", 1.0) < FOOT_TOLERANCE, "idle feet keep their authored floor contact (%.4f m)" % idle.get("foot", 1.0))
	_check(idle.get("pelvis", 1.0) < 0.001, "flat ground leaves the pelvis alone (%.4f m)" % idle.get("pelvis", 1.0))
	_test_pelvis_drop_on_real_leg()
	_test_reach_slide()

	var yaw := player.rotation.y
	for pose in [["look_up", 40.0, 0.0], ["look_down", -40.0, 0.0], ["yaw", 0.0, 50.0]]:
		player.look_controller.set_base_pitch(deg_to_rad(pose[1]))
		player.look_controller.set_base_yaw(yaw + deg_to_rad(pose[2]))
		await _frames(20)
		await _check_hold(pose[0])
	player.look_controller.set_base_pitch(0.0)
	player.look_controller.set_base_yaw(yaw)
	await _frames(60)

	player.weapon_manager.set_aiming(true)
	await _frames(40)
	await _check_hold("ads")
	player.look_controller.set_base_pitch(deg_to_rad(35.0))
	await _frames(20)
	await _check_hold("ads_look_up")
	player.look_controller.set_base_pitch(0.0)
	player.weapon_manager.set_aiming(false)

	player.stance_controller.transition_to_stance(1.0)
	await _frames(90)
	await _check_hold("crouch")
	player.look_controller.set_base_pitch(deg_to_rad(-35.0))
	await _frames(20)
	await _check_hold("crouch_look_down")
	player.look_controller.set_base_pitch(0.0)
	var start := player.global_position
	var released := 0
	for direction in [Vector3.FORWARD, Vector3.BACK, Vector3.LEFT, Vector3.RIGHT]:
		player.global_position = start
		player.velocity = Vector3.ZERO
		player.set_ai_input(direction)
		await _frames(40)
		var gait := await _measure("crouch_walk_%s" % direction, 120)
		_check(gait.get("planted", 0) > 30, "crouch gait keeps support contacts %s (%d)" % [direction, gait.get("planted", 0)])
		_check(gait.get("foot", 1.0) < WALK_FOOT_TOLERANCE, "planted crouch feet reach their targets %s (%.4f m)" % [direction, gait.get("foot", 1.0)])
		released += gait.get("released", 0)
		player.clear_ai_input()
	_check(released > 0, "crouch gait releases stepping feet (%d samples)" % released)
	player.stance_controller.transition_to_stance(0.0)
	await _frames(90)

	for direction in [Vector3.FORWARD, Vector3.BACK, Vector3.LEFT, Vector3.RIGHT]:
		player.set_ai_input(direction)
		await _frames(40)
		var walk := await _measure("walk_%s" % direction, 90)
		_check(walk.get("pos", 1.0) < POSITION_TOLERANCE, "walking %s keeps reachable wrists on target (%.4f m)" % [direction, walk.get("pos", 1.0)])
		_check(walk.get("foot", 1.0) < WALK_FOOT_TOLERANCE, "walking %s keeps planted feet down (%.4f m)" % [direction, walk.get("foot", 1.0)])
		_check(walk.get("pelvis", 1.0) < 0.005, "walking %s on flat ground does not bob the pelvis (%.4f m)" % [direction, walk.get("pelvis", 1.0)])
		player.clear_ai_input()
	await _frames(40)

	await _test_slope()

	player.movement_controller._is_sprinting = true
	rig.update(1.0, true, false, true)
	_check(is_equal_approx(rig.get_arm_weight(), rig._config.sprint_arm_weight), "sprinting lowers both arms to the sprint weight")
	player.movement_controller._is_sprinting = false
	await _frames(30)

	player.stance_controller._enter_prone()
	await _frames(190)
	_check(is_equal_approx(rig.get_arm_weight(), 1.0), "prone keeps both hands on the weapon")
	# Prone elbows rest spread on the ground: only require that they never point skyward.
	await _check_hold("prone", 40, 0.0)

	_test_prone_fade()
	_test_ragdoll_gate()
	_test_plant_release()
	await _frames(2)
	_test_rebind()

	for key in stats:
		var s: Dictionary = stats[key]
		print("ik_rig %-26s wrist_pos=%.4f wrist_rot=%.2f unreachable=%d elbows=%+.2f/%+.2f foot=%.4f pelvis=%.4f" % [key, s.get("pos", -1.0), s.get("rot", -1.0), s.get("unreachable", 0), s.get("left_elbow", 9.0), s.get("right_elbow", 9.0), s.get("foot", -1.0), s.get("pelvis", -1.0)])
	print("ik_rig_check=%s failures=%d" % ["ok" if failures == 0 else "FAILED", failures])
	get_tree().quit(0 if failures == 0 else 1)


func _test_solver() -> void:
	var skel := Skeleton3D.new()
	add_child(skel)
	skel.rotation = Vector3(0.3, 2.4, -0.2)
	skel.scale = Vector3.ONE * 1.7
	skel.add_bone("upper")
	skel.add_bone("lower")
	skel.add_bone("end")
	skel.set_bone_parent(1, 0)
	skel.set_bone_parent(2, 1)
	skel.set_bone_rest(0, Transform3D(Basis.from_euler(Vector3(0.4, -0.2, 0.9)), Vector3(0.1, 1.0, 0.0)))
	skel.set_bone_rest(1, Transform3D(Basis.from_euler(Vector3(-0.3, 0.6, 0.2)), Vector3(0.0, 0.5, 0.0)))
	skel.set_bone_rest(2, Transform3D(Basis.from_euler(Vector3(0.2, 0.1, -0.5)), Vector3(0.0, 0.4, 0.0)))
	skel.reset_bone_poses()
	var root := TwoBoneIK.bone_world_position(skel, 0)
	var upper := root.distance_to(TwoBoneIK.bone_world_position(skel, 1))
	var lower := TwoBoneIK.bone_world_position(skel, 1).distance_to(TwoBoneIK.bone_world_position(skel, 2))
	var target := root + Vector3(0.6, -0.9, 0.5).normalized() * (upper + lower) * 0.7
	var pole := root + Vector3(-1.0, 0.2, 0.3) * 2.0
	TwoBoneIK.solve(skel, 0, 1, 2, target, pole)
	var middle := TwoBoneIK.bone_world_position(skel, 1)
	var end := TwoBoneIK.bone_world_position(skel, 2)
	_check(end.distance_to(target) < 0.0005, "two-bone solver reaches a reachable target")
	_check(absf(root.distance_to(middle) - upper) < 0.0005 and absf(middle.distance_to(end) - lower) < 0.0005, "two-bone solver keeps bone lengths")
	var axis := (target - root).normalized()
	var bend := (middle - root) - axis * (middle - root).dot(axis)
	var pole_side := (pole - root) - axis * (pole - root).dot(axis)
	_check(bend.normalized().dot(pole_side.normalized()) > 0.999, "two-bone solver bends toward the pole")
	var far := root + Vector3(0.2, 1.0, -0.3).normalized() * (upper + lower) * 1.5
	TwoBoneIK.solve(skel, 0, 1, 2, far, pole)
	end = TwoBoneIK.bone_world_position(skel, 2)
	_check(absf(root.distance_to(end) - (upper + lower)) < 0.001 and (end - root).normalized().dot((far - root).normalized()) > 0.9999, "unreachable target straightens the chain toward it")
	var basis := Basis.from_euler(Vector3(0.7, -1.1, 0.4))
	TwoBoneIK.blend_world_rotation(skel, 2, basis, 1.0)
	_check(TwoBoneIK.bone_world_transform(skel, 2).basis.get_rotation_quaternion().angle_to(basis.get_rotation_quaternion()) < 0.001, "wrist rotation reaches the target world rotation")
	skel.queue_free()
	_check(is_equal_approx(LegIK.drop_to_reach(Vector3(0, -1.03, 0), 1.0), 0.03), "pelvis drop closes a vertical reach gap")
	_check(is_zero_approx(LegIK.drop_to_reach(Vector3(0, -0.9, 0), 1.0)), "reachable foot needs no pelvis drop")
	_check(is_equal_approx(LegIK.drop_to_reach(Vector3(1.2, -0.1, 0), 1.0), 0.1), "sideways overreach sinks only to the closest point")


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


func _test_pelvis_drop_on_real_leg() -> void:
	var leg := rig.left_leg
	var hip := _world(leg.upper).origin
	var knee := _world(leg.lower).origin
	var ankle := _world(leg.foot).origin
	var reach := maxf((hip.distance_to(knee) + knee.distance_to(ankle)) * rig._config.max_leg_extension, hip.distance_to(ankle))
	var saved_target := leg.target
	var saved_blend := leg.blend
	leg.target = hip + Vector3.DOWN * (reach + 0.05)
	leg.blend = 1.0
	_check(is_equal_approx(leg.pelvis_drop_needed(skeleton, rig._config), 0.05), "pelvis drop covers a planted foot below the straight leg")
	leg.target = saved_target
	leg.blend = saved_blend


func _test_reach_slide() -> void:
	var shoulder := _world(rig.left_arm.upper).origin
	var length := rig.left_arm.length(skeleton)
	var toward_stock: Vector3 = player.weapon_manager.current_weapon.global_basis.z.normalized()
	var limited := rig._slide_into_reach(shoulder - toward_stock * length * 1.05)
	_check(rig.get_grip_slide() > 0.0 and rig.get_grip_slide() <= rig._config.support_hand_max_slide, "overreach slides the support hand a bounded distance")
	_check(shoulder.distance_to(limited) <= length * rig._config.max_reach_ratio + 0.0001, "slid target is back inside the comfortable reach")
	var reachable := shoulder - toward_stock * length * 0.5
	_check(rig._slide_into_reach(reachable).is_equal_approx(reachable) and is_zero_approx(rig.get_grip_slide()), "reachable support target is left untouched")


func _test_slope() -> void:
	var start := player.global_position
	var slope := StaticBody3D.new()
	slope.collision_layer = PhysicsLayers.WORLD
	slope.position = Vector3(100, -0.25, 0)
	slope.rotation.z = deg_to_rad(12.0)
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(12, 0.5, 12)
	collision.shape = shape
	slope.add_child(collision)
	add_child(slope)
	for facing in [0.0, PI]:
		player.global_position = Vector3(100, 1.5, 0)
		player.rotation.y = facing
		player.velocity = Vector3.ZERO
		await _frames(120)
		_check(player.is_on_floor() and rig.left_leg.hit.colliding and rig.right_leg.hit.colliding, "both feet probe the slope facing %.2f" % facing)
		var on_slope := await _measure("slope_%.2f" % facing, 30)
		_check(on_slope.get("foot", 1.0) < 0.015, "feet reach a 12 degree slope facing %.2f (%.4f m)" % [facing, on_slope.get("foot", 1.0)])
	player.rotation.y = 0.0
	player.global_position = start
	player.velocity = Vector3.ZERO
	slope.queue_free()
	await _frames(90)


func _test_prone_fade() -> void:
	rig.left_leg.blend = 0.8
	rig.right_leg.blend = 0.8
	rig.update(0.016, true, true, false)
	_check(rig.left_leg.blend > 0.0 and rig.left_leg.blend < 0.8, "prone fades the feet out gradually")


func _test_ragdoll_gate() -> void:
	rig.update(0.016, false, false, false)
	_check(is_zero_approx(rig.get_arm_weight()) and is_zero_approx(rig.left_leg.blend) and is_zero_approx(rig.right_leg.blend), "ragdoll gate drops arms and feet immediately")
	_check(not rig.get_arms_modifier().active and not rig.get_legs_modifier().active, "ragdoll gate disables both IK modifiers")
	rig.update(0.016, true, false, false)
	_check(rig.get_legs_modifier().active and rig.get_arms_modifier().active, "leaving ragdoll re-enables both IK modifiers")


## Frozen pose: a common crouch offset is not a lift, a single raised foot releases at once.
func _test_plant_release() -> void:
	player.set_process(false)
	player.set_physics_process(false)
	player.animation_controller._animation_tree.active = false
	skeleton.reset_bone_poses()
	var hips := skeleton.find_bone("mixamorig_Hips")
	skeleton.set_bone_pose_position(hips, skeleton.get_bone_pose_position(hips) + Vector3.UP * 0.5)
	var contact := {"colliding": true, "point": Vector3.ZERO, "normal": Vector3.UP}
	var support_y := minf(_world(rig.left_leg.foot).origin.y, _world(rig.right_leg.foot).origin.y)
	for leg in [rig.left_leg, rig.right_leg]:
		leg.hit = contact.duplicate()
		leg.blend = 1.0
		leg.plan(skeleton, support_y, 0.0, true, 0.016, rig._config)
	_check(rig.left_leg.blend > 0.99 and rig.right_leg.blend > 0.99, "a whole-body crouch offset is not mistaken for a lifted foot")
	var foot := rig.left_leg.foot
	var parent_basis := skeleton.global_basis * skeleton.get_bone_global_pose(skeleton.get_bone_parent(foot)).basis
	skeleton.set_bone_pose_position(foot, skeleton.get_bone_pose_position(foot) + parent_basis.inverse() * Vector3.UP * 0.2)
	support_y = minf(_world(rig.left_leg.foot).origin.y, _world(rig.right_leg.foot).origin.y)
	rig.left_leg.plan(skeleton, support_y, 0.0, true, 0.016, rig._config)
	rig.right_leg.plan(skeleton, support_y, 0.0, true, 0.016, rig._config)
	_check(rig.left_leg.blend < 0.01 and rig.right_leg.blend > 0.99, "a raised foot releases immediately while the support foot stays planted")
	skeleton.reset_bone_poses()
	rig.left_leg.plan(skeleton, support_y, 0.0, false, 0.016, rig._config)
	_check(is_zero_approx(rig.left_leg.blend), "an airborne body releases the feet")


func _test_rebind() -> void:
	rig.bind_skeleton(skeleton)
	rig.bind_skeleton(skeleton)
	var legs := 0
	var arms := 0
	for child in skeleton.get_children():
		legs += 1 if child.name == "IKLegs" and not child.is_queued_for_deletion() else 0
		arms += 1 if child.name == "IKArms" and not child.is_queued_for_deletion() else 0
	_check(legs == 1 and arms == 1, "rebinding replaces the IK modifiers without duplicates")
	player.model_manager.model_unloaded.emit()
	_check(rig.get_arms_modifier() == null and not rig.left_arm.is_bound() and not rig.left_leg.is_bound(), "model unload clears the rig")
