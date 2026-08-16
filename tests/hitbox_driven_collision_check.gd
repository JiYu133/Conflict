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
		"medical system publishes a value-only 3D core-pose envelope"):
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
	if not _check(controller.contains_envelope(source["envelope"] as AABB),
		"standing capsule contains every supplied AABB corner"):
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

	# Simulate an unseen animation increasing the supplied core-pose envelope.
	# Each actual physics write is observed through the public signal and must
	# remain bounded.
	source["envelope"] = AABB(Vector3(-0.4, -0.85, -0.35), Vector3(0.8, 2.0, 0.7))
	controller.set_physics_process(true)
	for _frame in 3:
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
	if not _check(
		float(metrics["height_step"]) > 0.0 or float(metrics["radius_step"]) > 0.0,
		"unknown 3D envelope changes produce a sampled geometry update"
	):
		return
	var bounded_height_step := float(metrics["height_step"])
	var bounded_radius_step := float(metrics["radius_step"])

	# A prone-like envelope is longer along Z than Y. No prone flag or animation
	# name is supplied: the fit must infer a horizontal capsule from geometry.
	var prone_envelope := AABB(
		Vector3(-0.35, -0.6, -1.1),
		Vector3(0.7, 0.45, 2.2)
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
	if not _check(controller.contains_envelope(prone_envelope),
		"horizontal capsule contains every supplied AABB corner"):
		return
	if not _check(controller.get_vertical_extent() < 1.0,
		"prone capsule keeps a low vertical profile"):
		return
	if not _check(absf(controller.get_floor_contact_y() + 0.9) < 0.001,
		"horizontal capsule also preserves floor contact"):
		return

	# An unchanged pose may still be sampled at the controller's throttled rate,
	# but it must not rewrite the shared physics shape on every physics tick.
	var writes_before_idle := controller.get_geometry_write_count()
	var samples_before_idle := controller.get_envelope_sample_count()
	controller.set_physics_process(true)
	for _frame in 12:
		await get_tree().physics_frame
	controller.set_physics_process(false)
	var idle_samples := controller.get_envelope_sample_count() - samples_before_idle
	if not _check(controller.get_geometry_write_count() == writes_before_idle,
		"steady poses do not rewrite CapsuleShape3D"):
		return
	if not _check(idle_samples > 0 and idle_samples <= 8,
		"steady poses sample the hitbox envelope at a bounded rate"):
		return

	# Model a small bot squad with independent bodies/controllers. Sixty steady
	# physics steps must produce no shape-server writes after the initial fit.
	var bot_controllers: Array[PlayerCollisionController] = []
	for bot_index in 16:
		var bot_body := CharacterBody3D.new()
		bot_body.name = "SteadyBotBody%d" % bot_index
		map.add_child(bot_body)
		var bot_controller := PlayerCollisionController.new()
		bot_controller.name = "CollisionController"
		bot_body.add_child(bot_controller)
		bot_controller.initialize(bot_body, controller._config, envelope_provider)
		bot_controller.set_physics_process(false)
		bot_controller.refresh_immediately()
		bot_controllers.append(bot_controller)
	var squad_writes_before := 0
	for bot_controller in bot_controllers:
		squad_writes_before += bot_controller.get_geometry_write_count()
	for frame_index in 60:
		for bot_controller in bot_controllers:
			bot_controller._update_geometry(1.0 / 60.0, false, frame_index % 2 == 0)
	var squad_writes_after := 0
	for bot_controller in bot_controllers:
		squad_writes_after += bot_controller.get_geometry_write_count()
	if not _check(squad_writes_after == squad_writes_before,
		"steady multi-bot squad performs zero repeated physics-shape writes"):
		return

	print("hitbox_driven_collision_check=ok medical_size=%s prone_axis=%s height_step=%.4f radius_step=%.4f idle_samples=%d steady_bots=%d" % [
		medical_envelope.size,
		prone_axis,
		bounded_height_step,
		bounded_radius_step,
		idle_samples,
		bot_controllers.size(),
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
