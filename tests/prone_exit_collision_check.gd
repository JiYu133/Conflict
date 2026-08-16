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
	var movement := player.movement_controller
	var collision := player.get_node_or_null("PlayerCollisionShape") as CollisionShape3D
	var model := player.model_manager.model_node
	if not _check(
		stance != null and movement != null and collision != null
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
	movement._on_stance_changed(1.0)

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
	var prone_bottom_y := collision.position.y - shape.height * 0.5
	var max_height_step := 0.0
	var max_center_step := 0.0
	var max_model_step := 0.0
	var max_bottom_drift := 0.0
	for _frame in 12:
		stance._process(1.0 / 60.0)
		max_height_step = maxf(max_height_step, absf(shape.height - previous_height))
		max_center_step = maxf(max_center_step, absf(collision.position.y - previous_center_y))
		max_model_step = maxf(max_model_step, absf(model.position.y - previous_model_y))
		max_bottom_drift = maxf(
			max_bottom_drift,
			absf(collision.position.y - shape.height * 0.5 - prone_bottom_y)
		)
		previous_height = shape.height
		previous_center_y = collision.position.y
		previous_model_y = model.position.y

	if not _check(shape.height > prone_height + 0.1, "capsule starts expanding during the exit clip"):
		return
	if not _check(max_height_step < 0.1, "capsule height changes smoothly"):
		return
	if not _check(max_center_step < 0.1, "capsule center changes smoothly"):
		return
	if not _check(max_model_step < 0.1, "model and camera anchor change smoothly"):
		return
	if not _check(max_bottom_drift < 0.002, "capsule bottom remains anchored while standing up"):
		return

	print("prone_exit_collision_check=ok height_step=%.4f center_step=%.4f model_step=%.4f bottom_drift=%.4f" % [
		max_height_step, max_center_step, max_model_step, max_bottom_drift
	])
	get_tree().quit(0)


func _check(condition: bool, message: String) -> bool:
	if condition:
		return true
	push_error(message)
	get_tree().quit(1)
	return false
