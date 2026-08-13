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

	print("ragdoll_camera_check=ok")
	get_tree().quit(0)


func _check(condition: bool, message: String) -> bool:
	if condition:
		return true
	push_error(message)
	get_tree().quit(1)
	return false
