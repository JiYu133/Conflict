extends Node


func _ready() -> void:
	await get_tree().process_frame
	var scene := load("res://assets/map/TestMap.tscn") as PackedScene
	if not _check(scene != null, "TestMap scene loads"):
		return
	var map := scene.instantiate()
	get_tree().root.add_child(map)
	await get_tree().process_frame
	await get_tree().process_frame

	var player := map.get_node_or_null("CharacterBody3D") as BasePlayer
	if not _check(player != null and player.camera_controller != null, "local player camera initializes"):
		return
	var controller := player.camera_controller as PlayerCameraController
	var camera := controller.get_active_camera()
	if not _check(camera != null, "active camera exists"):
		return
	var normal_camera_parent := camera.get_parent()
	controller._vertical_angle = deg_to_rad(-11.0)
	controller._view_yaw = deg_to_rad(23.0)
	controller._process(0.016)

	player.stance_controller._is_prone = true
	var roll_clip_length := player.animation_controller.play_prone_roll(false)
	if not _check(roll_clip_length > player.player_config.prone_roll_duration, "authored roll is longer than the legacy movement timer"):
		return
	player.movement_controller._prone_rolling = true
	player.movement_controller._prone_roll_direction = 1.0
	player.movement_controller._prone_roll_duration = roll_clip_length
	player.movement_controller._prone_roll_timer = roll_clip_length
	player.movement_controller._prone_roll_motion_timer = player.player_config.prone_roll_duration
	await get_tree().create_timer(player.player_config.prone_roll_duration + 0.1).timeout
	if not _check(player.movement_controller.is_prone_rolling(), "camera remains in roll mode after the legacy timer expires"):
		return
	player.movement_controller._prone_roll_timer = roll_clip_length * 0.25
	controller._update_prone_roll_camera(0.016)
	var bank_magnitude := sin(PI * 0.75) * PlayerCameraController.PRONE_ROLL_MAX_CAMERA_BANK
	var expected_bank := -bank_magnitude
	if not _check(is_equal_approx(controller._prone_roll_camera_angle, expected_bank), "right prone roll camera banks toward the right"):
		return
	player.movement_controller._prone_roll_direction = -1.0
	controller._update_prone_roll_camera(0.016)
	if not _check(is_equal_approx(controller._prone_roll_camera_angle, bank_magnitude), "left prone roll camera banks toward the left"):
		return
	player.movement_controller._prone_roll_direction = 1.0
	controller._update_prone_roll_camera(0.016)
	controller._process(0.016)
	var expected_roll_basis := Basis.from_euler(Vector3(
		controller.get_vertical_angle() + controller._pain_pitch,
		controller.get_view_yaw() + controller._pain_yaw,
		controller._pain_roll + expected_bank
	)).orthonormalized()
	var roll_basis_error := expected_roll_basis.get_rotation_quaternion().angle_to(camera.global_basis.get_rotation_quaternion())
	if not _check(roll_basis_error < 0.03, "prone roll camera remains aligned to look input"):
		return
	var level_view_basis := Basis.from_euler(Vector3(
		controller.get_vertical_angle(), controller.get_view_yaw(), 0.0
	)).orthonormalized()
	if not _check((-camera.global_basis.z).dot(-level_view_basis.z) > 0.99, "prone roll camera keeps the player's forward view"):
		return
	await get_tree().create_timer(roll_clip_length - player.player_config.prone_roll_duration + 0.2).timeout
	if not _check(not player.movement_controller.is_prone_rolling(), "roll camera releases only after the animation finishes"):
		return
	controller._update_prone_roll_camera(1.0)
	if not _check(absf(controller._prone_roll_camera_angle) < 0.01, "prone roll camera returns to neutral"):
		return
	player.stance_controller._is_prone = false

	player.die()
	await get_tree().process_frame
	await get_tree().physics_frame
	await get_tree().process_frame

	if not _check(camera.get_parent() == get_tree().root, "death camera is detached to the scene root"):
		return
	if not _check(not controller._head_spring_enabled, "death disables the head position spring"):
		return
	if not _check(controller._ragdoll_camera_shake_active, "death enables subtle ragdoll camera shake"):
		return
	if not _check(controller._ragdoll_physics_active, "physical ragdoll takes ownership of the camera"):
		return
	if not _check(player.screen_effects != null and player.screen_effects._death_active, "death activates the screen effect state"):
		return
	if not _check(player.screen_effects._death_rect != null and player.screen_effects._death_rect.visible and player.screen_effects._death_rect.modulate.a > 0.0, "death fade overlay becomes visible"):
		return
	var physical_head := controller._ragdoll_head_bone as PhysicalBone3D
	if not _check(physical_head != null, "camera resolves the head or nearest physical parent bone"):
		return

	var head_transform: Transform3D = physical_head.global_transform * controller._ragdoll_head_from_physical
	var expected_position := head_transform.origin
	if not _check(camera.global_position.distance_to(expected_position) < 0.02, "camera position follows the physical head"):
		return
	var expected_basis := (head_transform.basis.orthonormalized() * controller._ragdoll_head_to_camera_basis).orthonormalized()
	var basis_error := expected_basis.get_rotation_quaternion().angle_to(camera.global_basis.get_rotation_quaternion())
	if not _check(basis_error < 0.03, "camera preserves the physical head roll and orientation"):
		return

	player.revive()
	await get_tree().process_frame
	if not _check(controller._head_spring_enabled, "revive re-enables the head position spring"):
		return
	if not _check(not controller._ragdoll_camera_shake_active, "revive clears ragdoll camera shake"):
		return
	if not _check(camera.get_parent() == normal_camera_parent, "revive restores the original camera parent"):
		return
	if not _check(not player.screen_effects._death_active and not player.screen_effects._death_rect.visible, "revive clears the death overlay"):
		return

	print("ragdoll_camera_check=ok")
	get_tree().quit(0)


func _check(condition: bool, message: String) -> bool:
	if condition:
		return true
	push_error(message)
	get_tree().quit(1)
	return false
