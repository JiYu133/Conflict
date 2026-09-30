extends SceneTree

## Regression check for thresholded velocity-driven lower-body yaw, backward
## locomotion, and independent spine aim.
## Run: godot --headless --path . --script res://tests/movement_body_yaw_runner.gd

const PLAYER_SCENE := "res://assets/map/test_map.tscn"
const EPSILON := 0.01


func _init() -> void:
	_run.call_deferred()


func _run() -> void:
	var results: Dictionary = {}
	var packed := load(PLAYER_SCENE) as PackedScene
	if not packed:
		_finish({"scene_loaded": false})
		return
	results["scene_loaded"] = true

	var map := packed.instantiate()
	root.add_child(map)
	var player: Node = null
	for _frame in 120:
		await physics_frame
		player = _find_player(map)
		if player and player.is_on_floor():
			break
	results["player_on_floor"] = player != null and player.is_on_floor()
	if not player:
		_finish(results)
		return

	var camera = player.get("camera_controller")
	var look = player.get("look_controller")
	var spine = player.get("spine_aim_controller")
	var turn = player.get("turn_controller")
	var animation = player.get("animation_controller")
	results["controllers_ready"] = camera != null and look != null and spine != null \
			and turn != null and animation != null
	if not results["controllers_ready"]:
		_finish(results)
		return

	# Aim straight ahead while moving right. The body must turn toward velocity,
	# not snap back to the view yaw.
	look.set_base_yaw(0.0)
	player.rotation.y = 0.0
	player.velocity = Vector3.RIGHT
	camera.call("_sync_moving_body_yaw", 1.0)
	var body_yaw := float(player.rotation.y)
	results["body_follows_velocity"] = absf(angle_difference(body_yaw, -PI * 0.5)) < EPSILON
	results["body_does_not_follow_view"] = absf(angle_difference(body_yaw, 0.0)) > 1.0

	# Keep the same velocity-driven body pose and ask the spine modifier to aim at
	# the view direction. A non-zero correction proves the upper body is separate.
	spine.process_aim(1.0)
	var spine_yaw := float(spine.get("_current_yaw"))
	results["upper_body_keeps_aim_offset"] = absf(spine_yaw) > 0.5

	# Backward velocity lies outside the configured velocity-follow threshold.
	# The root must remain view-aligned so the locomotion BlendSpace receives a
	# negative forward component and selects its backward animation.
	player.rotation.y = 0.0
	player.velocity = Vector3.BACK
	camera.call("_sync_moving_body_yaw", 1.0)
	var backward_body_yaw := float(player.rotation.y)
	var backward_local_velocity: Vector3 = player.global_transform.basis.transposed() * player.velocity
	results["backward_keeps_view_facing_body"] = absf(angle_difference(backward_body_yaw, 0.0)) < EPSILON
	results["backward_animation_direction_preserved"] = -backward_local_velocity.z < -EPSILON

	# A large view/body mismatch must interrupt locomotion and keep the turn
	# active even though horizontal velocity remains non-zero.
	turn.call("_cancel_turn")
	player.rotation.y = 0.0
	player.velocity = Vector3.FORWARD
	look.set_base_yaw(deg_to_rad(150.0))
	animation.call("_transition", PlayerAnimationController.State.RUN)
	turn.call("_try_start_turn")
	var forced_snapshot: Dictionary = turn.get_debug_snapshot()
	results["fast_moving_turn_is_forced"] = bool(forced_snapshot.get("turning", false)) \
			and bool(forced_snapshot.get("forced_turning", false))
	turn.call("_process_turn", 0.01)
	results["forced_turn_survives_locomotion"] = turn.is_turning()

	# Turn clips are filtered to leg tracks. Spine and arm tracks stay on the
	# base pose so weapon aim remains controlled by SpineAim/hand IK.
	results["turn_filter_includes_leg"] = bool(animation.call(
			"_is_turn_lower_body_path", NodePath("Skeleton3D:mixamorig_LeftUpLeg")
	))
	results["turn_filter_excludes_spine"] = not bool(animation.call(
			"_is_turn_lower_body_path", NodePath("Skeleton3D:mixamorig_Spine2")
	))
	results["turn_filter_excludes_arms"] = not bool(animation.call(
			"_is_turn_lower_body_path", NodePath("Skeleton3D:mixamorig_RightArm")
	))
	turn.call("_cancel_turn")

	map.queue_free()
	_finish(results)


func _find_player(node: Node) -> Node:
	var script: Variant = node.get_script()
	if script != null and String(script.resource_path).ends_with("base_player.gd") \
			and not bool(node.get("is_ai_player")):
		return node
	for child in node.get_children():
		var found := _find_player(child)
		if found:
			return found
	return null


func _finish(results: Dictionary) -> void:
	var passed := true
	for key in results:
		if results[key] != true:
			passed = false
	results["status"] = "passed" if passed else "failed"
	print(JSON.stringify({"status": results["status"], "results": results}))
	quit(0 if passed else 1)
