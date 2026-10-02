extends Node

var failures := 0


func _ready() -> void:
	_run.call_deferred()


func _check(condition: bool, message: String) -> void:
	if not condition:
		failures += 1
		push_error(message)


func _run() -> void:
	var map_scene := load("res://assets/map/test_map.tscn") as PackedScene
	if not is_instance_valid(map_scene):
		_check(false, "test map loads")
		_finish()
		return
	var map := map_scene.instantiate()
	get_tree().root.add_child(map)
	for _frame in 30:
		await get_tree().process_frame

	var player := _find_player(map)
	_check(is_instance_valid(player), "local player loads")
	if not is_instance_valid(player):
		_finish()
		return
	var presentation := player.weapon_presentation_controller
	var camera := player.camera_controller.get_active_camera()
	_check(is_instance_valid(presentation), "player owns weapon presentation controller")
	if not is_instance_valid(presentation):
		_finish()
		return
	var pivot := presentation.get_sway_pivot()
	_check(is_instance_valid(pivot), "weapon display pivot is mounted")
	_check(is_instance_valid(camera), "player camera is active")
	if not is_instance_valid(pivot) or not is_instance_valid(camera):
		_finish()
		return

	var mount := pivot.get_parent() as Node3D
	var mount_transform := mount.global_transform
	var camera_transform := camera.global_transform
	pivot.position.z = -0.17
	presentation._ads_center_offset = Vector3(0.04, -0.06, 0.5)
	presentation._ads_target = true
	presentation._process(1.0)
	_check(is_equal_approx(pivot.position.x, 0.04), "ADS offset moves only weapon presentation X")
	_check(is_equal_approx(pivot.position.y, -0.06), "ADS offset moves only weapon presentation Y")
	_check(is_equal_approx(pivot.position.z, -0.17), "ADS leaves weapon depth owned by obstruction")
	_check(mount.global_transform.is_equal_approx(mount_transform), "ADS does not move the animated weapon mount")
	_check(camera.global_transform.is_equal_approx(camera_transform), "weapon presentation does not move the camera")

	presentation._ads_target = false
	presentation._process(1.0)
	_check(pivot.position.is_equal_approx(Vector3(0.0, 0.0, -0.17)), "ADS exit restores the hip pose without changing depth")

	_finish()


func _find_player(root: Node) -> BasePlayer:
	if root is BasePlayer:
		return root
	for child in root.get_children():
		var player := _find_player(child)
		if is_instance_valid(player):
			return player
	return null


func _finish() -> void:
	print("weapon_presentation=%s failures=%d" % ["ok" if failures == 0 else "FAILED", failures])
	get_tree().quit(0 if failures == 0 else 1)
