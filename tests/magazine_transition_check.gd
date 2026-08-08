extends SceneTree


func _init() -> void:
	var ammo := AmmoComponent.new()
	var weapon_config := WeaponConfig.new()
	ammo.initialize(weapon_config)

	var magazine_config := MagazineConfig.new()
	magazine_config.magazine_capacity = 30
	magazine_config.reserve_magazines = 1
	ammo.reconfigure(magazine_config)
	ammo.debug_set_ammo(12, 30, true)

	if not _check(ammo.has_chambered_round(), "Chambered round exists before magazine removal"):
		return
	if not _check(ammo.get_current_magazine_count() == 12, "Current magazine count is preserved before removal"):
		return

	ammo.clear_magazine()
	if not _check(ammo.has_chambered_round(), "Removing magazine preserves chambered round"):
		return
	if not _check(ammo.get_current_magazine_count() == 0, "Removing magazine clears only magazine rounds"):
		return
	ammo.swap_magazine()

	ammo.reconfigure(magazine_config)
	if not _check(ammo.has_chambered_round(), "Installing magazine does not clear chambered round"):
		return
	if not _check(ammo.get_current_magazine_count() == 30, "Installing magazine creates a fresh magazine"):
		return

	print("magazine_transition_check=ok")
	quit(0)


func _check(condition: bool, message: String) -> bool:
	if condition:
		return true
	push_error(message)
	quit(1)
	return false
