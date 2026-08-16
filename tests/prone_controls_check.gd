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
	var stance := player.stance_controller
	var movement := player.movement_controller
	var animation := player.animation_controller
	var animator := animation._prone_player()
	if not _check(stance != null and movement != null and animator != null, "prone controllers initialize"):
		return

	if not _check(PlayerAnimationController.PRONE_LOCOMOTION_BLEND_TIME > 0.0, "prone locomotion uses a non-zero cross-fade"):
		return
	animation.play_prone_idle()
	animator.seek(0.25, true)
	var idle_position := animator.current_animation_position
	animation.play_prone_idle()
	if not _check(animator.current_animation_position >= idle_position, "reselecting prone idle does not restart the clip"):
		return
	animation.update_prone_motion(Vector2(0.0, -1.0), true)
	if not _check(animation._prone_animation_override == &"prone_forward/mixamo_com", "prone movement selects the forward crawl clip"):
		return
	animation.update_prone_motion(Vector2.ZERO, false)
	if not _check(animation._prone_animation_override == &"prone_idle/mixamo_com", "stopping returns to prone idle"):
		return

	# C must leave prone in a crouch.
	stance._is_prone = true
	stance._prone_transition = false
	var crouch_event := InputEventAction.new()
	crouch_event.action = &"crouch"
	crouch_event.pressed = true
	stance._input(crouch_event)
	if not _check(stance._prone_transition and not stance._prone_exit_to_stand, "C starts a prone-to-crouch exit"):
		return
	stance._finish_prone_exit()
	if not _check(not stance.is_prone() and is_equal_approx(stance._target_stance, 1.0), "C finishes in crouch"):
		return

	# Z must leave prone directly toward standing, with no crouch hold timer.
	stance._is_prone = true
	stance._prone_transition = false
	var prone_event := InputEventAction.new()
	prone_event.action = &"prone"
	prone_event.pressed = true
	stance._input(prone_event)
	if not _check(stance._prone_transition and stance._prone_exit_to_stand, "Z starts a prone-to-stand exit"):
		return
	stance._finish_prone_exit()
	if not _check(not stance.is_prone() and is_zero_approx(stance._target_stance), "Z finishes directly toward standing"):
		return

	# Either key order in Space+A/D is accepted, and the captured lateral
	# direction continues driving the character after the keys are released.
	Input.action_press("move_left")
	Input.action_press("jump")
	if not _check(movement._is_prone_roll_combo_pressed(true, false), "Space+A starts a prone roll"):
		Input.action_release("move_left")
		Input.action_release("jump")
		return
	Input.action_release("move_left")
	Input.action_release("jump")
	stance._is_prone = true
	stance._prone_transition = false
	movement._prone_rolling = true
	movement._prone_roll_direction = 1.0
	movement._prone_roll_world_direction = Vector3.RIGHT
	movement._prone_roll_duration = 3.0
	movement._prone_roll_timer = 3.0
	movement._prone_roll_motion_timer = player.player_config.prone_roll_duration
	movement._velocity = Vector3.ZERO
	movement._process_prone_movement(0.05, Vector2.ZERO, false, false)
	if not _check(movement._velocity.x > 0.0, "prone roll keeps its captured direction after A/D is released"):
		return

	# A long authored clip may keep the animation/camera active, but it must not
	# keep propelling the CharacterBody after the configured roll window.
	movement._prone_roll_motion_timer = 0.0
	movement._velocity = Vector3.RIGHT * player.player_config.prone_roll_speed
	movement._process_prone_movement(0.05, Vector2.ZERO, false, false)
	if not _check(
		movement.is_prone_rolling() and movement._prone_roll_timer > player.player_config.prone_roll_duration,
		"roll animation remains active after propulsion ends"
	):
		return
	if not _check(movement._velocity.x < player.player_config.prone_roll_speed, "expired roll propulsion brakes instead of sliding through the full clip"):
		return

	print("prone_controls_check=ok")
	get_tree().quit(0)


func _check(condition: bool, message: String) -> bool:
	if condition:
		return true
	push_error(message)
	get_tree().quit(1)
	return false
