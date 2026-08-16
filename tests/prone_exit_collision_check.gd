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
	if not _check(player != null, "player initializes"):
		return
	var stance := player.stance_controller
	var collision_controller := player.collision_controller
	var collision := collision_controller.get_collision_shape() if collision_controller else null
	var model := player.model_manager.model_node
	if not _check(
		stance != null and collision_controller != null and collision != null
		and collision.shape is CapsuleShape3D and model != null,
		"prone exit geometry initializes"
	):
		return

	# Put the test in a fully settled prone pose without waiting through the
	# authored enter clip.
	stance.set_process(false)
	stance._is_prone = true
	stance._prone_transition = false
	stance._stance_value = 1.0
	stance._target_stance = 1.0
	stance._prone_geometry_blend = 1.0
	stance._prone_geometry_target = 1.0
	# Disable hitbox sampling here to isolate the fallback transition. A separate
	# envelope test verifies that live BodyHitbox geometry drives the controller.
	collision_controller.set_physics_process(false)
	collision_controller.set_envelope_provider(Callable())
	stance.prone_geometry_changed.emit(1.0)
	collision_controller.refresh_immediately()

	var shape := collision.shape as CapsuleShape3D
	var prone_height := shape.height
	var prone_center_y := collision.position.y
	var prone_model_y := model.position.y
	stance._exit_prone(true)

	if not _check(absf(shape.height - prone_height) < 0.001, "Z exit does not resize the capsule in one frame"):
		return
	if not _check(absf(collision.position.y - prone_center_y) < 0.001, "Z exit does not teleport the capsule center"):
		return
	if not _check(absf(model.position.y - prone_model_y) < 0.001, "Z exit does not teleport the camera-bearing model"):
		return
	if not _check(is_zero_approx(stance._target_stance), "Z begins moving directly toward standing"):
		return

	var previous_height := shape.height
	var previous_center_y := collision.position.y
	var previous_model_y := model.position.y
	var prone_bottom_y := collision_controller.get_floor_contact_y()
	var max_height_step := 0.0
	var max_center_step := 0.0
	var max_model_step := 0.0
	var max_bottom_drift := 0.0
	for _frame in 12:
		stance._process(1.0 / 60.0)
		collision_controller._update_geometry(1.0 / 60.0, false)
		max_height_step = maxf(max_height_step, absf(shape.height - previous_height))
		max_center_step = maxf(max_center_step, absf(collision.position.y - previous_center_y))
		max_model_step = maxf(max_model_step, absf(model.position.y - previous_model_y))
		max_bottom_drift = maxf(
			max_bottom_drift,
			absf(collision_controller.get_floor_contact_y() - prone_bottom_y)
		)
		previous_height = shape.height
		previous_center_y = collision.position.y
		previous_model_y = model.position.y

	if not _check(shape.height > prone_height + 0.04, "capsule starts expanding during the exit clip"):
		return
	if not _check(max_height_step < 0.1, "capsule height changes smoothly"):
		return
	if not _check(max_center_step < 0.1, "capsule center changes smoothly"):
		return
	if not _check(max_model_step < 0.1, "model and camera anchor change smoothly"):
		return
	if not _check(max_bottom_drift < 0.002, "capsule bottom remains anchored while standing up"):
		return

	# Reset to prone, then put a low ceiling above the current capsule. The exit
	# may approach the obstacle but must never commit an overlapping expansion;
	# BasePlayer should translate the rejection into a public stance rollback.
	stance._is_prone = true
	stance._prone_transition = false
	stance._stance_value = 1.0
	stance._target_stance = 1.0
	stance._prone_geometry_blend = 1.0
	stance._prone_geometry_target = 1.0
	stance.prone_geometry_changed.emit(1.0)
	collision_controller.refresh_immediately()
	var ceiling := StaticBody3D.new()
	ceiling.name = "ProneExitClearanceCeiling"
	var ceiling_collision := CollisionShape3D.new()
	var ceiling_box := BoxShape3D.new()
	ceiling_box.size = Vector3(2.0, 0.2, 2.0)
	ceiling_collision.shape = ceiling_box
	ceiling.add_child(ceiling_collision)
	map.add_child(ceiling)
	var floor_world_y := player.global_position.y + collision_controller.get_floor_contact_y()
	var ceiling_bottom_y := floor_world_y + 0.8
	ceiling.global_position = Vector3(
		player.global_position.x,
		ceiling_bottom_y + ceiling_box.size.y * 0.5,
		player.global_position.z
	)
	await get_tree().physics_frame
	var blocked := {"count": 0}
	var count_block := func() -> void:
		blocked["count"] = int(blocked["count"]) + 1
	collision_controller.transition_blocked.connect(count_block)
	stance._exit_prone(true)
	for _frame in 60:
		stance._process(1.0 / 60.0)
		collision_controller._update_geometry(1.0 / 60.0, false)
		await get_tree().physics_frame
		if int(blocked["count"]) > 0:
			break
	var capsule_top_world_y := player.global_position.y + collision.position.y \
		+ collision_controller.get_vertical_extent() * 0.5
	if not _check(int(blocked["count"]) == 1, "blocked prone exit emits one rejection"):
		return
	if not _check(stance.is_prone() and not stance.is_prone_transitioning(),
		"blocked prone exit rolls stance back to settled prone"):
		return
	if not _check(capsule_top_world_y <= ceiling_bottom_y + 0.005,
		"blocked prone exit never commits an overlapping capsule"):
		return

	print("prone_exit_collision_check=ok height_step=%.4f center_step=%.4f model_step=%.4f bottom_drift=%.4f blocked=%d" % [
		max_height_step, max_center_step, max_model_step, max_bottom_drift, int(blocked["count"])
	])
	get_tree().quit(0)


func _check(condition: bool, message: String) -> bool:
	if condition:
		return true
	push_error(message)
	get_tree().quit(1)
	return false
