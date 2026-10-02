extends Node

var failures := 0
var player: BasePlayer
var foot: FootIKController
var hand: HandIKController
var samples := {}
var planted_samples := 0
var released_samples := 0
var max_planted_error := 0.0


func _ready() -> void:
	_run.call_deferred()


func _check(ok: bool, message: String) -> void:
	if not ok:
		failures += 1
		push_error(message)


func _frames(count: int) -> void:
	for i in count:
		await get_tree().process_frame


func _run() -> void:
	var map := (load("res://assets/map/TestMap.tscn") as PackedScene).instantiate()
	add_child(map)
	player = map.get_node("CharacterBody3D") as BasePlayer
	# Drive the real movement/stance/animation pipeline without keyboard input.
	player.is_ai_player = true
	foot = player.foot_ik_controller
	hand = player.hand_ik_controller
	foot._pose_modifier.modification_processed.connect(_sample_animation)
	foot._ankle_modifier.modification_processed.connect(_sample_solved_feet)
	await _frames(90)
	var start := player.global_position
	for stance in [0.25, 0.5, 0.75, 1.0, 0.0, 1.0]:
		player.stance_controller.transition_to_stance(stance)
		await _frames(90)
		_check(absf(player.stance_controller.get_stance_value() - stance) < 0.01, "requested crouch depth reached")
		_check(foot._left_blend > 0.95 and foot._right_blend > 0.95, "idle feet stay planted at stance %.2f" % stance)
		_check(float(samples.get("error", 1.0)) < 0.015, "idle ankle targets reached at stance %.2f" % stance)

	# Check every directional crouch blend with actual movement and physics probes.
	for direction in [Vector3.FORWARD, Vector3.BACK, Vector3.LEFT, Vector3.RIGHT, Vector3(-1, 0, -1).normalized(), Vector3(1, 0, -1).normalized(), Vector3(-1, 0, 1).normalized(), Vector3(1, 0, 1).normalized()]:
		player.global_position = start
		player.velocity = Vector3.ZERO
		player.set_ai_input(direction)
		planted_samples = 0
		released_samples = 0
		max_planted_error = 0.0
		await _frames(120)
		print("crouch_gait direction=%s planted=%d released=%d max_error=%.4f" % [direction, planted_samples, released_samples, max_planted_error])
		_check(planted_samples > 30, "crouch gait keeps support contacts: " + str(direction))
		_check(released_samples > 0, "crouch gait releases raised feet: " + str(direction))
		_check(max_planted_error < 0.025, "planted crouch gait feet reach their targets: " + str(direction))
	player.clear_ai_input()
	player.velocity = Vector3.ZERO
	player.global_position = start
	await _frames(90)
	player.weapon_manager.set_aiming(true)
	await _frames(30)
	_check(hand._is_ads and is_equal_approx(hand._current_weight, hand._ik_weight * hand._config.ads_ik_weight), "crouch ADS keeps configured hand weight")
	_check(hand._hand_target.global_position.distance_to(hand._left_hand_wrist_target.global_position) < 0.003, "crouch support hand follows authored weapon target")
	player.weapon_manager.set_aiming(false)

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
	for yaw in [0.0, PI * 0.5, PI]:
		player.global_position = Vector3(100, 1.5, 0)
		player.rotation.y = yaw
		player.velocity = Vector3.ZERO
		await _frames(120)
		_check(player.is_on_floor() and foot._left_hit.colliding and foot._right_hit.colliding, "crouched feet probe slope at yaw %.2f" % yaw)
		_check(foot._left_blend > 0.95 and foot._right_blend > 0.95, "crouch slope support contacts remain active")
		_check(float(samples.get("error", 1.0)) < 0.015, "crouched feet reach slope targets")

	# Translation of the entire crouch pose must not count as a swing; a single
	# lifted ankle must still release even when both feet are above standing rest.
	player.set_process(false)
	player.animation_controller._animation_tree.active = false
	foot.set_active(false)
	var skeleton := player.model_manager.skeleton
	skeleton.reset_bone_poses()
	var hips := skeleton.find_bone("mixamorig_Hips")
	skeleton.set_bone_pose_position(hips, skeleton.get_bone_pose_position(hips) + Vector3.UP * 0.5)
	_check(foot._plant_weight(foot._left_foot_idx) > 0.99 and foot._plant_weight(foot._right_foot_idx) > 0.99, "common crouch pose offset is not mistaken for foot lift")
	var idx := foot._left_foot_idx
	var parent_basis := skeleton.global_basis * skeleton.get_bone_global_pose(skeleton.get_bone_parent(idx)).basis
	skeleton.set_bone_pose_position(idx, skeleton.get_bone_pose_position(idx) + parent_basis.inverse() * Vector3.UP * 0.2)
	_check(foot._plant_weight(idx) < 0.01 and foot._plant_weight(foot._right_foot_idx) > 0.99, "raised crouch foot releases while the support foot stays planted")
	print("crouch_ik_check=%s failures=%d" % ["ok" if failures == 0 else "FAILED", failures])
	get_tree().quit(0 if failures == 0 else 1)


func _sample_animation() -> void:
	samples["left_lift"] = foot._plant_weight(foot._left_foot_idx)
	samples["right_lift"] = foot._plant_weight(foot._right_foot_idx)


func _sample_solved_feet() -> void:
	var error := 0.0
	for side in ["left", "right"]:
		var blend: float = foot.get("_%s_blend" % side)
		var bone: int = foot.get("_%s_foot_idx" % side)
		var target: Marker3D = foot.get("_%s_target" % side)
		if blend > 0.99:
			planted_samples += 1
			error = maxf(error, foot._bone_world_position(bone).distance_to(target.global_position))
		if float(samples.get("%s_lift" % side, 1.0)) < 0.95:
			released_samples += 1
	samples["error"] = error
	max_planted_error = maxf(max_planted_error, error)
