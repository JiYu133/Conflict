extends SceneTree


func _init() -> void:
	var ammo := AmmoComponent.new()
	ammo.magazines = [[null], [null, null, null]]
	ammo.current_magazine = 0
	var updates: Array[Vector2i] = []
	ammo.ammo_count_changed.connect(func(current: int, reserve: int) -> void:
		updates.append(Vector2i(current, reserve))
	)

	ammo.swap_magazine()

	if ammo.current_magazine != 1:
		_fail("swap_magazine should select the next non-empty magazine")
		return
	if updates != [Vector2i(3, 1)]:
		_fail("swap_magazine should immediately emit the new ammo counts")
		return

	print("ammo_component_check=ok")
	quit(0)


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
