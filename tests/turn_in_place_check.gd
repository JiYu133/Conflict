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
	if not _check(player != null and player.turn_controller != null, "player turn controller initializes"):
		return
	var controller := player.turn_controller
	var animator := player.model_manager.animator
	if not _check(player.player_config.movement_config.turn_in_place_enabled, "turn in place is enabled"):
		return

	for library_name in ["turn_left", "turn_right", "crouch_turn_left", "crouch_turn_right"]:
		if not _check(animator.has_animation_library(library_name), "%s library is installed" % library_name):
			return
		var animation := animator.get_animation_library(library_name).get_animation("mixamo_com")
		if not _check(_root_turn_is_neutralized(animation), "%s root turn is neutralized" % library_name):
			return
		if not _check(animation.loop_mode == Animation.LOOP_NONE, "%s does not loop" % library_name):
			return

	var camera := player.camera_controller
	var config := player.player_config.movement_config
	var skeleton := player.model_manager.skeleton
	var leg_idx := skeleton.find_bone("mixamorig_LeftUpLeg")
	var spine_idx := skeleton.find_bone("mixamorig_Spine2")
	var idle_leg := skeleton.get_bone_pose_rotation(leg_idx)
	var idle_spine := skeleton.get_bone_pose_rotation(spine_idx)
	camera._view_yaw = player.rotation.y + deg_to_rad(39.0)
	if not _check(not controller.is_turning(), "sub-threshold turns remain idle"):
		return
	camera._view_yaw = player.rotation.y + deg_to_rad(41.0)
	controller._try_start_turn()
	if not _check(controller.is_turning(), "right view yaw starts a standing turn"):
		return
	if not _check(player.animation_controller.get_current_state() == PlayerAnimationController.State.TURN_LEFT, "AnimationTree enters standing left turn"):
		return
	await get_tree().create_timer(0.2).timeout
	var turn_leg := skeleton.get_bone_pose_rotation(leg_idx)
	var turn_spine := skeleton.get_bone_pose_rotation(spine_idx)
	if not _check(idle_leg.angle_to(turn_leg) > deg_to_rad(2.0), "turn animation drives the lower body"):
		return
	if not _check(idle_spine.angle_to(turn_spine) < deg_to_rad(2.0), "turn animation does not rotate the upper body"):
		return
	var yaw_before_move := player.rotation.y
	player.velocity = Vector3(0.0, 0.0, -config.walk_speed)
	controller._process_turn()
	if not _check(player.animation_controller.get_current_state() == PlayerAnimationController.State.WALK, "moving interrupts turn into locomotion"):
		return
	if not _check(absf(angle_difference(yaw_before_move, player.rotation.y)) < deg_to_rad(1.0), "moving does not snap body yaw on the exit frame"):
		return
	player.camera_controller.process_moving_body_yaw_blend(config.turn_transition_time)
	if not _check(absf(player.camera_controller.get_body_yaw_offset()) < deg_to_rad(1.0), "body yaw finishes blending toward the moving view"):
		return
	player.velocity = Vector3.ZERO
	player.animation_controller._transition(PlayerAnimationController.State.IDLE)
	camera._view_yaw = player.rotation.y - deg_to_rad(41.0)
	controller._try_start_turn()
	if not _check(player.animation_controller.get_current_state() == PlayerAnimationController.State.TURN_RIGHT, "opposite view yaw interrupts the active turn"):
		return
	controller._cancel_turn()
	player.stance_controller.set_stance(1.0)
	await get_tree().create_timer(0.5).timeout
	controller._cancel_turn()
	player.animation_controller._transition(PlayerAnimationController.State.IDLE)
	camera._view_yaw = player.rotation.y
	camera._view_yaw = player.rotation.y - deg_to_rad(41.0)
	controller._try_start_turn()
	if not _check(player.animation_controller.get_current_state() == PlayerAnimationController.State.CROUCH_TURN_RIGHT, "crouching turn selects the correct direction"):
		return
	var active_camera := camera.get_active_camera()
	var crouch_camera_y := active_camera.position.y
	var collision_shape := player.get_node_or_null("PlayerCollisionShape") as CollisionShape3D
	var crouch_collision_height := (collision_shape.shape as CapsuleShape3D).height
	await get_tree().create_timer(0.2).timeout
	if not _check(absf(active_camera.position.y - crouch_camera_y) < 0.01, "crouching turn keeps camera height stable"):
		return
	if not _check(is_equal_approx((collision_shape.shape as CapsuleShape3D).height, crouch_collision_height), "crouching turn does not resize the collision capsule"):
		return
	await get_tree().create_timer(controller._clip_length + 0.2).timeout
	controller._process_turn()
	if not _check(not controller.is_turning(), "crouching turn completes instead of looping"):
		return
	player.stance_controller.set_stance(0.0)
	player.rotation.y = 0.0
	camera._view_yaw = deg_to_rad(120.0)
	player.velocity = Vector3(0.0, 0.0, -config.walk_speed)
	camera.begin_moving_body_yaw_blend(config.turn_transition_time)
	camera.process_moving_body_yaw_blend(config.turn_transition_time * 0.5)
	var half_blend_degrees := absf(rad_to_deg(player.rotation.y))
	if not _check(half_blend_degrees > 45.0 and half_blend_degrees < 75.0, "large moving turn progresses smoothly at mid-blend"):
		return
	camera.process_moving_body_yaw_blend(config.turn_transition_time * 0.5)
	if not _check(absf(camera.get_body_yaw_offset()) < deg_to_rad(1.0), "large moving turn finishes without a final snap"):
		return
	camera._view_yaw = player.rotation.y + deg_to_rad(config.turn_view_limit_degrees)
	var offset := absf(camera.get_body_yaw_offset())
	if not _check(offset <= deg_to_rad(config.turn_view_limit_degrees) + 0.001, "view yaw is clamped relative to the body"):
		return
	player.velocity = Vector3(0.0, 0.0, -config.run_speed)
	if not _check(camera._is_moving(), "running player is recognized as moving"):
		return
	camera._view_yaw = player.rotation.y + deg_to_rad(120.0)
	camera._sync_moving_body_yaw()
	if not _check(absf(camera.get_body_yaw_offset()) < 0.001, "moving body follows unrestricted view yaw"):
		return

	print("turn_in_place_check=ok")
	get_tree().quit(0)


func _root_turn_is_neutralized(animation: Animation) -> bool:
	if not animation:
		return false
	for track_index in animation.get_track_count():
		if animation.track_get_type(track_index) != Animation.TYPE_ROTATION_3D:
			continue
		if not str(animation.track_get_path(track_index)).contains("mixamorig_Hips"):
			continue
		var key_count := animation.track_get_key_count(track_index)
		var first := animation.track_get_key_value(track_index, 0) as Quaternion
		var last := animation.track_get_key_value(track_index, key_count - 1) as Quaternion
		return first.angle_to(last) < deg_to_rad(5.0)
	return false


func _check(condition: bool, message: String) -> bool:
	if condition:
		return true
	push_error(message)
	get_tree().quit(1)
	return false
