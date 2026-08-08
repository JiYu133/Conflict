extends SceneTree


func _init() -> void:
	var config := load("res://res/config/weapons/ak12_config.tres") as WeaponConfig
	if not _check(config != null, "AK12 config loads"):
		return

	var receiver_scene := load("res://res/models/attachments/receivers/ak12_receiver/ak12_receiver.tscn") as PackedScene
	if not _check(receiver_scene != null, "AK12 receiver scene loads"):
		return
	var weapon := receiver_scene.instantiate() as BaseWeapon
	if not _check(weapon != null, "AK12 receiver scene creates BaseWeapon"):
		return
	root.add_child(weapon)
	weapon.initialize(config)

	if not _check(weapon.current_fire_mode == config.default_fire_mode, "Configured default fire mode is applied"):
		return
	if not _check(not weapon.cycle_fire_mode(), "Mode cycling fails without selector switch"):
		return
	if not _check(weapon.current_fire_mode == config.default_fire_mode, "Mode stays unchanged without selector switch"):
		return

	var selector_cfg := load("res://res/config/weapons/attachments/selector_switches/ak12_selector_switch.tres") as AttachmentConfig
	var selector := AttachmentFactory.create(selector_cfg, weapon)
	if not _check(selector is SelectorSwitchAttachment, "Selector config creates selector behavior attachment"):
		return
	selector.queue_free()
	if not _check(weapon.equip_attachment("SelectorSwitch", selector_cfg), "Selector switch equips"):
		return
	if not _check(weapon.cycle_fire_mode(), "Mode cycling succeeds with selector switch"):
		return
	if not _check(weapon.current_fire_mode == "burst", "Mode follows configured order"):
		return
	if not _check(weapon.fire_control.current_fire_mode == "burst", "Fire control receives selected mode"):
		return

	var detached := weapon.detach_attachment("SelectorSwitch")
	if not _check(detached == selector, "Selector switch detaches"):
		return
	if not _check(not weapon.cycle_fire_mode(), "Mode cycling fails after selector removal"):
		return
	if not _check(weapon.current_fire_mode == "burst", "Current mode remains after selector removal"):
		return

	var fallback_config := WeaponConfig.new()
	fallback_config.fire_modes = ["safe", "semi"]
	fallback_config.default_fire_mode = "auto"
	var fallback_weapon := BaseWeapon.new()
	root.add_child(fallback_weapon)
	fallback_weapon.initialize(fallback_config)
	if not _check(fallback_weapon.current_fire_mode == "safe", "Invalid default mode falls back to first configured mode"):
		return

	print("fire_mode_selector_check=ok")
	quit(0)


func _check(condition: bool, message: String) -> bool:
	if condition:
		return true
	push_error(message)
	quit(1)
	return false
