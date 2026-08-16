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
	var capsule := collision.shape as CapsuleShape3D
	var medical_envelope := player.health_system.get_collision_envelope()
	if not _check(_valid_envelope(medical_envelope),
		"medical system publishes a value-only 3D hitbox envelope"):
		return
	var environment_shape_count := 0
	for child in player.get_children():
		if child is CollisionShape3D and child.name == "PlayerCollisionShape":
			environment_shape_count += 1
	if not _check(environment_shape_count == 1,
		"the player has exactly one environment capsule owner"):
		return

	# From this point on, feed plain AABB values. The collision component must not
	# know or mutate HealthSystem/BodyHitbox nodes to react to an unknown pose.
	controller.set_physics_process(false)
	var source := {
		"envelope": AABB(Vector3(-0.3, -0.85, -0.25), Vector3(0.6, 1.6, 0.5)),
	}
	var envelope_provider := func() -> AABB:
		return source["envelope"] as AABB
	controller.set_envelope_provider(envelope_provider)
	controller.refresh_immediately()
	if not _check(controller.get_capsule_axis().dot(Vector3.UP) > 0.999,
		"standing 3D envelope fits a vertical capsule"):
		return
	if not _check(absf(controller.get_floor_contact_y() + 0.9) < 0.001,
		"fitted capsule preserves configured floor contact"):
		return

	var metrics := {
		"previous_height": capsule.height,
		"previous_radius": capsule.radius,
		"height_step": 0.0,
		"radius_step": 0.0,
	}
	var geometry_observer := func(height: float, radius: float, _axis: Vector3, _center: Vector3, _floor_y: float) -> void:
		metrics["height_step"] = maxf(
			float(metrics["height_step"]),
			absf(height - float(metrics["previous_height"]))
		)
		metrics["radius_step"] = maxf(
			float(metrics["radius_step"]),
			absf(radius - float(metrics["previous_radius"]))
		)
		metrics["previous_height"] = height
		metrics["previous_radius"] = radius
	controller.geometry_changed.connect(geometry_observer)

	# Simulate an unseen animation increasing the full body envelope. Each actual
	# physics write is observed through the public signal and must remain bounded.
	source["envelope"] = AABB(Vector3(-0.4, -0.85, -0.35), Vector3(0.8, 2.0, 0.7))
	controller.set_physics_process(true)
	await get_tree().physics_frame
	await get_tree().process_frame
	controller.set_physics_process(false)
	var maximum_step := controller._config.collision_bounds_follow_speed / 60.0 + 0.002
	if not _check(
		float(metrics["height_step"]) <= maximum_step
		and float(metrics["radius_step"]) <= maximum_step,
		"unknown 3D envelope changes remain bounded per physics tick"
	):
		return
	var bounded_height_step := float(metrics["height_step"])
	var bounded_radius_step := float(metrics["radius_step"])

	# A prone-like envelope is longer along Z than Y. No prone flag or animation
	# name is supplied: the fit must infer a horizontal capsule from geometry.
	var prone_envelope := AABB(
		Vector3(-0.35, -0.85, -1.1),
		Vector3(0.7, 0.55, 2.2)
	)
	source["envelope"] = prone_envelope
	controller.refresh_immediately()
	var prone_axis := controller.get_capsule_axis()
	if not _check(absf(prone_axis.z) > 0.999 and absf(prone_axis.y) < 0.001,
		"prone-like 3D envelope automatically fits a horizontal capsule"):
		return
	if not _check(capsule.height >= prone_envelope.size.z,
		"horizontal capsule follows the prone body's longitudinal range"):
		return
	if not _check(controller.get_vertical_extent() < 1.0,
		"prone capsule keeps a low vertical profile"):
		return
	if not _check(absf(controller.get_floor_contact_y() + 0.9) < 0.001,
		"horizontal capsule also preserves floor contact"):
		return

	print("hitbox_driven_collision_check=ok medical_size=%s prone_axis=%s height_step=%.4f radius_step=%.4f" % [
		medical_envelope.size,
		prone_axis,
		bounded_height_step,
		bounded_radius_step,
	])
	controller.geometry_changed.disconnect(geometry_observer)
	map.queue_free()
	await get_tree().process_frame
	await get_tree().physics_frame
	get_tree().quit(0)


func _valid_envelope(envelope: AABB) -> bool:
	return envelope.size.x > 0.0 and envelope.size.y > 0.0 and envelope.size.z > 0.0


func _check(condition: bool, message: String) -> bool:
	if condition:
		return true
	push_error(message)
	get_tree().quit(1)
	return false
