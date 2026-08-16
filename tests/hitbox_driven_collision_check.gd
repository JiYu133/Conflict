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
	await get_tree().physics_frame
	await get_tree().process_frame

	var player := map.get_node_or_null("CharacterBody3D") as BasePlayer
	if not _check(player != null and player.collision_controller != null, "collision controller initializes"):
		return
	var controller := player.collision_controller
	var collision := controller.get_collision_shape()
	var hitboxes := player.health_system.get_active_hitboxes()
	if not _check(hitboxes.size() >= 8, "medical hitboxes are available as geometry source"):
		return
	var environment_shape_count := 0
	for child in player.get_children():
		if child is CollisionShape3D and child.name == "PlayerCollisionShape":
			environment_shape_count += 1
	if not _check(environment_shape_count == 1,
		"the player has exactly one environment capsule owner"):
		return

	controller.set_physics_process(false)
	var sampled_bounds := controller._sample_hitbox_bounds()
	if not _check(sampled_bounds.y > sampled_bounds.x, "hitbox bounds can be sampled in player space"):
		return
	controller.refresh_immediately()
	var capsule := collision.shape as CapsuleShape3D
	var expected_bottom := controller._floor_bottom
	var expected_top := sampled_bounds.y + controller._config.collision_bounds_margin
	var actual_bottom := collision.position.y - capsule.height * 0.5
	var actual_top := collision.position.y + capsule.height * 0.5
	if not _check(absf(actual_bottom - expected_bottom) < 0.001 and actual_top >= expected_top - 0.001,
		"environment capsule encloses the H-key hitbox range"):
		return

	var head: BodyHitbox = null
	for hitbox in hitboxes:
		if hitbox.get_body_part_id() == MedicalEnums.BodyPartId.HEAD:
			head = hitbox
			break
	if not _check(head != null, "head hitbox is available"):
		return

	# Simulate an unseen future animation moving the highest hitbox. The generic
	# bounds follower must adapt without adding an animation/capsule config entry.
	head.position.y += 0.4
	var raised_bounds := controller._sample_hitbox_bounds()
	if not _check(raised_bounds.y > sampled_bounds.y + 0.25, "changed animation geometry changes sampled bounds"):
		return
	var before_top := collision.position.y + capsule.height * 0.5
	controller._update_collision_bounds(1.0 / 60.0, false)
	var after_top := collision.position.y + capsule.height * 0.5
	var maximum_step := controller._config.collision_bounds_follow_speed / 60.0 + 0.001
	if not _check(after_top > before_top and after_top - before_top <= maximum_step,
		"capsule follows new hitbox volume without a one-frame jump"):
		return
	for _frame in 30:
		controller._update_collision_bounds(1.0 / 60.0, false)
	actual_top = collision.position.y + capsule.height * 0.5
	expected_top = raised_bounds.y + controller._config.collision_bounds_margin
	if not _check(absf(actual_top - expected_top) < 0.01, "capsule converges to changed hitbox volume"):
		return

	print("hitbox_driven_collision_check=ok bounds=[%.3f, %.3f] step=%.4f" % [
		sampled_bounds.x, sampled_bounds.y, after_top - before_top
	])
	map.queue_free()
	await get_tree().process_frame
	await get_tree().physics_frame
	get_tree().quit(0)


func _check(condition: bool, message: String) -> bool:
	if condition:
		return true
	push_error(message)
	get_tree().quit(1)
	return false
