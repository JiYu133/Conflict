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
	if not _check(player != null and player.collision_controller != null, "player collision initializes"):
		return
	var stance := player.stance_controller
	var controller := player.collision_controller
	var collision := controller.get_collision_shape()
	var capsule := collision.shape as CapsuleShape3D
	var camera := player.camera_controller.get_active_camera()
	if not _check(stance != null and capsule != null and camera != null, "live prone dependencies initialize"):
		return

	for _frame in 20:
		await get_tree().physics_frame
	var standing_vertical_extent := controller.get_vertical_extent()
	var standing_axis := controller.get_capsule_axis()
	var standing_radius := capsule.radius
	var root_y := player.global_position.y
	var expected_floor_y := controller.get_floor_contact_y()
	if not _check(standing_axis.dot(Vector3.UP) > 0.9,
		"live standing hitbox envelope selects a vertical capsule"):
		return

	# Observe the controller's public signal. This records every actual physics
	# write even when the headless coroutine resumes after multiple ticks.
	var active := {
		"metrics": _new_geometry_metrics(capsule, standing_axis),
	}
	var geometry_observer := func(height: float, radius: float, axis: Vector3, _center: Vector3, floor_y: float) -> void:
		var metrics := active["metrics"] as Dictionary
		metrics["height_step"] = maxf(
			float(metrics["height_step"]),
			absf(height - float(metrics["previous_height"]))
		)
		metrics["radius_step"] = maxf(
			float(metrics["radius_step"]),
			absf(radius - float(metrics["previous_radius"]))
		)
		metrics["axis_step"] = maxf(
			float(metrics["axis_step"]),
			axis.angle_to(metrics["previous_axis"] as Vector3)
		)
		metrics["floor_drift"] = maxf(
			float(metrics["floor_drift"]),
			absf(floor_y - expected_floor_y)
		)
		metrics["previous_height"] = height
		metrics["previous_radius"] = radius
		metrics["previous_axis"] = axis
	controller.geometry_changed.connect(geometry_observer)

	stance._enter_prone()
	var enter_camera_metrics := await _sample_transition(player, camera, 180)
	var enter_geometry_metrics := active["metrics"] as Dictionary
	if not _check(not stance.is_prone_transitioning() and stance.is_prone(), "live prone entry completes"):
		return
	var prone_vertical_extent := controller.get_vertical_extent()
	var prone_axis := controller.get_capsule_axis()
	var prone_radius := capsule.radius
	var prone_envelope := player.health_system.get_collision_envelope()
	if not _check(absf(prone_axis.y) < 0.35,
		"live prone hitbox envelope rotates the capsule horizontally"):
		return
	if not _check(prone_vertical_extent < standing_vertical_extent - 0.2,
		"live prone capsule has a lower vertical profile"):
		return

	active["metrics"] = _new_geometry_metrics(capsule, prone_axis)
	stance._exit_prone(true)
	var exit_camera_metrics := await _sample_transition(player, camera, 240)
	var exit_geometry_metrics := active["metrics"] as Dictionary
	if not _check(not stance.is_prone_transitioning() and not stance.is_prone(), "live prone exit completes"):
		return
	var restored_axis := controller.get_capsule_axis()
	if not _check(restored_axis.dot(Vector3.UP) > 0.9,
		"live standing envelope restores the vertical capsule axis"):
		return
	if not _check(controller.get_vertical_extent() > prone_vertical_extent + 0.2,
		"live standing envelope restores occupied height"):
		return

	var maximum_linear_step := player.player_config.collision_bounds_follow_speed / 60.0 + 0.003
	var maximum_axis_step := deg_to_rad(
		player.player_config.collision_axis_follow_speed_degrees
	) / 60.0 + 0.003
	if not _check(
		_max_metric(enter_geometry_metrics, exit_geometry_metrics, "height_step") <= maximum_linear_step
		and _max_metric(enter_geometry_metrics, exit_geometry_metrics, "radius_step") <= maximum_linear_step,
		"live capsule dimensions change only at the configured bounded rate"
	):
		return
	if not _check(
		_max_metric(enter_geometry_metrics, exit_geometry_metrics, "axis_step") <= maximum_axis_step,
		"live capsule axis rotates only at the configured bounded rate"
	):
		return
	if not _check(
		_max_metric(enter_geometry_metrics, exit_geometry_metrics, "floor_drift") < 0.003,
		"live vertical and horizontal capsules keep the same floor contact"
	):
		return
	if not _check(absf(player.global_position.y - root_y) < 0.02,
		"CharacterBody root does not fall or get pushed up by capsule fitting"):
		return
	if not _check(float(exit_camera_metrics["camera_step"]) < 0.08,
		"camera-bearing head pose has no single-frame exit jump"):
		return

	print("live_prone_collision_check=ok prone_axis=%s prone_envelope=%s@%s standing_radius=%.3f prone_radius=%.3f height_step=%.4f radius_step=%.4f axis_step_deg=%.2f camera_step=%.4f floor_drift=%.4f root_drift=%.4f" % [
		prone_axis,
		prone_envelope.size,
		prone_envelope.position,
		standing_radius,
		prone_radius,
		_max_metric(enter_geometry_metrics, exit_geometry_metrics, "height_step"),
		_max_metric(enter_geometry_metrics, exit_geometry_metrics, "radius_step"),
		rad_to_deg(_max_metric(enter_geometry_metrics, exit_geometry_metrics, "axis_step")),
		float(exit_camera_metrics["camera_step"]),
		_max_metric(enter_geometry_metrics, exit_geometry_metrics, "floor_drift"),
		absf(player.global_position.y - root_y),
	])
	controller.geometry_changed.disconnect(geometry_observer)
	map.queue_free()
	await get_tree().process_frame
	await get_tree().physics_frame
	get_tree().quit(0)


func _new_geometry_metrics(capsule: CapsuleShape3D, axis: Vector3) -> Dictionary:
	return {
		"previous_height": capsule.height,
		"previous_radius": capsule.radius,
		"previous_axis": axis,
		"height_step": 0.0,
		"radius_step": 0.0,
		"axis_step": 0.0,
		"floor_drift": 0.0,
	}


func _sample_transition(player: BasePlayer, camera: Camera3D, maximum_frames: int) -> Dictionary:
	var previous_camera_y := camera.global_position.y
	var metrics := {"camera_step": 0.0}
	for _frame in maximum_frames:
		await get_tree().physics_frame
		await get_tree().process_frame
		metrics["camera_step"] = maxf(
			float(metrics["camera_step"]),
			absf(camera.global_position.y - previous_camera_y)
		)
		previous_camera_y = camera.global_position.y
		if not player.stance_controller.is_prone_transitioning() \
			and is_equal_approx(
				player.stance_controller._prone_geometry_blend,
				player.stance_controller._prone_geometry_target
			):
			break
	return metrics


func _max_metric(first: Dictionary, second: Dictionary, key: String) -> float:
	return maxf(float(first[key]), float(second[key]))


func _check(condition: bool, message: String) -> bool:
	if condition:
		return true
	push_error(message)
	get_tree().quit(1)
	return false
