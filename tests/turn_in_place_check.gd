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

	var camera := player.camera_controller
	var config := player.player_config.movement_config
	camera._view_yaw = player.rotation.y + deg_to_rad(39.0)
	if not _check(not controller.is_turning(), "sub-threshold turns remain idle"):
		return
	camera._view_yaw = player.rotation.y + deg_to_rad(41.0)
	controller._try_start_turn()
	if not _check(controller.is_turning(), "right view yaw starts a standing turn"):
		return
	if not _check(player.animation_controller.get_current_state() == PlayerAnimationController.State.TURN_LEFT, "AnimationTree enters standing left turn"):
		return
	controller._cancel_turn()
	player.stance_controller._stance_value = 1.0
	camera._view_yaw = player.rotation.y - deg_to_rad(41.0)
	controller._try_start_turn()
	if not _check(player.animation_controller.get_current_state() == PlayerAnimationController.State.CROUCH_TURN_RIGHT, "crouching turn selects the correct direction"):
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
