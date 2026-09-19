extends Node


func _ready() -> void:
	_run.call_deferred()


func _run() -> void:
	var map := (load("res://assets/map/TestMap.tscn") as PackedScene).instantiate()
	get_tree().root.add_child(map)
	await get_tree().process_frame
	var player := map.get_node("CharacterBody3D") as BasePlayer
	var manager := map.get_node("AIPlayerManager") as AIPlayerManager
	var bot := manager.add_ai_player("AimCheck", BasePlayer.Faction.UA)
	for i in 180:
		if bot.is_ai_runtime_ready():
			break
		await get_tree().process_frame
	if not _check(bot.is_ai_runtime_ready() and bot.weapon_manager.current_weapon != null, "staggered AI model and loadout initialization completes"):
		return
	var brain := AIPlayerBrain.new()
	add_child(brain)
	brain.bot = bot
	var camera := bot.camera_controller
	var spine := bot.spine_aim_controller
	bot.rotation.y = 0.7
	if not _check(absf(camera.get_body_yaw_offset()) < 0.0001, "spawn/body rotation cannot leave a stale AI view"):
		return

	# Exercise the brain entry point, not just the view setter.
	for direction in [Vector3.RIGHT, Vector3.LEFT, Vector3.FORWARD, Vector3.BACK]:
		brain._face(bot.global_position + direction * 10.0)
		spine.process_aim(1.0, true)
		if not _check(absf(camera.get_body_yaw_offset()) < 0.0001, "AI body and view agree after facing " + str(direction)):
			return
		if not _check(absf(spine._modifier.yaw_radians) < 0.0001, "AI does not add compensating spine yaw"):
			return
		if not _check((-bot.global_basis.z).dot(direction) > 0.999, "body faces commanded heading"):
			return

	for height in [5.0, -5.0]:
		brain._face(bot.global_position + Vector3(10, height, 0))
		spine.process_aim(1.0, true)
		var expected_pitch := atan2(height, 10.0)
		if not _check(absf(camera.get_vertical_angle() - expected_pitch) < 0.0001, "AI view retains target elevation"):
			return
		if not _check(absf(spine._modifier.pitch_radians - expected_pitch) < 0.001, "target elevation reaches spine aim"):
			return
		if not _check(absf(bot.rotation.x) < 0.0001 and absf(bot.rotation.z) < 0.0001, "aiming keeps the character capsule upright"):
			return

	# Profile aim error must change the coherent aim, not only the body transform.
	var profile := AIProfile.new()
	profile.aim_error_degrees = 3.0
	var pitch_before := camera.get_vertical_angle()
	for i in 8:
		brain._apply_aim_error(profile)
		if not _check(absf(camera.get_body_yaw_offset()) < 0.0001, "aim error keeps body/view synchronized"):
			return
		if not _check(absf(camera.get_vertical_angle() - pitch_before) < 0.0001, "yaw error preserves elevation"):
			return

	# Observe the actual rendered weapon after the spine/attachment modifier chain.
	# A correct command alone is insufficient if it never moves the muzzle.
	var weapon := bot.weapon_manager.current_weapon
	var samples := {}
	bot.hand_ik_controller._target_modifier.modification_processed.connect(
		func(): samples["direction"] = weapon._get_muzzle_direction()
	)
	brain._face(bot.global_position + Vector3(0, 0, -10))
	spine.process_aim(1.0, true)
	for i in 3:
		await get_tree().process_frame
	if not _check(samples.has("direction"), "weapon direction is sampled after pose modification"):
		return
	var level_direction: Vector3 = samples.direction
	brain._face(bot.global_position + Vector3(0, 5, -10))
	spine.process_aim(1.0, true)
	for i in 3:
		await get_tree().process_frame
	var elevated_direction: Vector3 = samples.direction
	if not _check(elevated_direction.y > level_direction.y + 0.1, "elevated aim raises the actual muzzle direction"):
		return
	brain._move_to(bot.global_position + Vector3(10, 3, 0), profile, 0.016)
	if not _check(absf(camera.get_vertical_angle()) < 0.0001, "navigation restores a level heading"):
		return

	var local_view := player.camera_controller.get_view_yaw()
	if not _check(not player.set_ai_aim_direction(Vector3.RIGHT), "AI commands cannot take over a local player"):
		return
	if not _check(is_equal_approx(local_view, player.camera_controller.get_view_yaw()), "local view is unchanged"):
		return
	if not _check(not bot.set_ai_aim_direction(Vector3.ZERO), "zero aim does not reset heading"):
		return
	bot.is_ragdolled = true
	if not _check(not bot.set_ai_aim_direction(Vector3.RIGHT), "ragdoll ignores aim commands"):
		return
	bot.is_ragdolled = false
	if not _check(bot.set_ai_aim_direction(Vector3.UP), "vertical target has a valid aim"):
		return
	spine.process_aim(1.0, true)
	if not _check(is_equal_approx(spine._modifier.pitch_radians, deg_to_rad(spine._config.max_look_up_degrees)), "vertical aim respects spine limit"):
		return
	print("ai_aim_check=ok muzzle_y_delta=%.3f" % (elevated_direction.y - level_direction.y))
	get_tree().quit(0)


func _check(condition: bool, message: String) -> bool:
	if condition:
		return true
	push_error(message)
	get_tree().quit(1)
	return false
