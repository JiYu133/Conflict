extends SceneTree


func _init() -> void:
	var ammo := AmmoComponent.new()
	ammo.initialize(WeaponConfig.new())

	ammo.debug_set_ammo(12, 61, true)
	if not _check(ammo.get_current_magazine_count() == 12, "Current magazine count is set exactly"):
		return
	if not _check(ammo.get_reserve_count() == 61, "Reserve rounds are distributed across spare magazines"):
		return
	if not _check(ammo.has_chambered_round(), "Chamber state is set"):
		return

	ammo.debug_set_ammo(35, 10, false)
	if not _check(ammo.get_current_magazine_count() == 30, "Current magazine is capped to magazine capacity"):
		return
	if not _check(ammo.get_reserve_count() == 15, "Current-magazine overflow is preserved as reserve rounds"):
		return
	if not _check(not ammo.has_chambered_round(), "Chamber can be cleared explicitly"):
		return

	print("ammo_component_debug_check=ok")
	quit(0)


func _check(condition: bool, message: String) -> bool:
	if condition:
		return true
	push_error(message)
	quit(1)
	return false
