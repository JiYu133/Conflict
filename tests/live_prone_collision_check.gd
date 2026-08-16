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
	var collision := player.collision_controller.get_collision_shape()
	var capsule := collision.shape as CapsuleShape3D
	var camera := player.camera_controller.get_active_camera()
	if not _check(stance != null and capsule != null and camera != null, "live prone dependencies initialize"):
		return

	for _frame in 10:
		await get_tree().physics_frame
	var standing_height := capsule.height
	var root_y := player.global_position.y
	# The headless runner may execute two physics ticks before this test coroutine
	# resumes. Observe the CapsuleShape resource itself so the metric represents
	# each actual controller write instead of a coarser coroutine sample.
	var height_monitor: Dictionary = {
		"previous_height": capsule.height,
		"maximum_step": 0.0,
	}
	var height_observer := func() -> void:
		var new_height: float = capsule.height
		height_monitor["maximum_step"] = maxf(
			float(height_monitor["maximum_step"]),
			absf(new_height - float(height_monitor["previous_height"]))
		)
		height_monitor["previous_height"] = new_height
	capsule.changed.connect(height_observer)

	stance._enter_prone()
	var enter_metrics := await _sample_transition(player, collision, camera, 180)
	enter_metrics["height_step"] = float(height_monitor["maximum_step"])
	if not _check(not stance.is_prone_transitioning() and stance.is_prone(), "live prone entry completes"):
		return
	var prone_height := capsule.height
	if not _check(prone_height < standing_height - 0.2, "live hitboxes reduce the prone environment volume"):
		return

	height_monitor["previous_height"] = capsule.height
	height_monitor["maximum_step"] = 0.0
	stance._exit_prone(true)
	var exit_metrics := await _sample_transition(player, collision, camera, 240)
	exit_metrics["height_step"] = float(height_monitor["maximum_step"])
	if not _check(not stance.is_prone_transitioning() and not stance.is_prone(), "live prone exit completes"):
		return
	if not _check(capsule.height > prone_height + 0.2, "live hitboxes restore standing volume"):
		return

	var maximum_allowed_height_step := player.player_config.collision_bounds_follow_speed / 60.0 + 0.003
	print("live_prone_collision_metrics enter_height_step=%.4f exit_height_step=%.4f exit_camera_step=%.4f enter_bottom_drift=%.4f exit_bottom_drift=%.4f root_drift=%.4f allowed_height_step=%.4f" % [
		enter_metrics.height_step,
		exit_metrics.height_step,
		exit_metrics.camera_step,
		enter_metrics.bottom_drift,
		exit_metrics.bottom_drift,
		absf(player.global_position.y - root_y),
		maximum_allowed_height_step,
	])
	if not _check(
		maxf(enter_metrics.height_step, exit_metrics.height_step) <= maximum_allowed_height_step,
		"live capsule height changes only at the configured bounded rate"
	):
		return
	if not _check(maxf(enter_metrics.bottom_drift, exit_metrics.bottom_drift) < 0.003,
		"live capsule keeps its floor contact through prone transitions"):
		return
	if not _check(absf(player.global_position.y - root_y) < 0.02,
		"CharacterBody root does not fall or get pushed up by resizing"):
		return
	if not _check(exit_metrics.camera_step < 0.08,
		"camera-bearing head pose has no single-frame exit jump"):
		return

	print("live_prone_collision_check=ok enter_step=%.4f exit_step=%.4f camera_step=%.4f root_drift=%.4f" % [
		enter_metrics.height_step,
		exit_metrics.height_step,
		exit_metrics.camera_step,
		absf(player.global_position.y - root_y)
	])
	capsule.changed.disconnect(height_observer)
	map.queue_free()
	await get_tree().process_frame
	await get_tree().physics_frame
	get_tree().quit(0)


func _sample_transition(
	player: BasePlayer,
	collision: CollisionShape3D,
	camera: Camera3D,
	maximum_frames: int
) -> Dictionary:
	var capsule := collision.shape as CapsuleShape3D
	var previous_camera_y := camera.global_position.y
	var floor_bottom := player.collision_controller._floor_bottom
	var metrics := {
		"height_step": 0.0,
		"camera_step": 0.0,
		"bottom_drift": 0.0,
	}
	for _frame in maximum_frames:
		await get_tree().physics_frame
		await get_tree().process_frame
		metrics.camera_step = maxf(metrics.camera_step, absf(camera.global_position.y - previous_camera_y))
		metrics.bottom_drift = maxf(
			metrics.bottom_drift,
			absf(collision.position.y - capsule.height * 0.5 - floor_bottom)
		)
		previous_camera_y = camera.global_position.y
		if not player.stance_controller.is_prone_transitioning() \
			and is_equal_approx(
				player.stance_controller._prone_geometry_blend,
				player.stance_controller._prone_geometry_target
			):
			break
	return metrics


func _check(condition: bool, message: String) -> bool:
	if condition:
		return true
	push_error(message)
	get_tree().quit(1)
	return false
