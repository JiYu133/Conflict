extends Node

## Integration coverage for component wiring, UI ownership and scene changes.
var failures := 0


func _ready() -> void:
	_run.call_deferred()


func _run() -> void:
	var scene := load("res://assets/map/TestMap.tscn") as PackedScene
	var map := scene.instantiate()
	add_child(map)
	await _frames(120)
	var player := map.get_node("CharacterBody3D") as BasePlayer
	_check(player.ui_layer != null and player.weapon_feedback != null, "player components are assembled")
	for ui in [player.settings_menu, player.pause_menu, player.weapon_mod_menu, player.console_system]:
		_check(ui.get_parent() == player.ui_layer, "UI layer owns the menus")
	_check(player.get_node_or_null("MedicalTreatment") == player.medical_treatment_component,
		"encounter medical node path is preserved")
	_check(player.settings_service.get_value("graphics/magnified_scope_mode") != null,
		"migrated service retains current optics settings")
	_test_weapon_feedback(player)
	_test_console_commands(player)
	await _test_menu_input(player)

	var bot := BasePlayer.new()
	bot.is_ai_player = true
	map.add_child(bot)
	_check(bot.ui_layer == null and bot.settings_menu == null and bot.medical_treatment_component == null,
		"AI composition does not create local UI")
	_check(bot.weapon_feedback != null, "AI composition includes weapon feedback")
	bot.queue_free()

	_check(RadialMenuService.open("fire_mode"), "first player's fire-mode wheel opens")
	# Instantiate the next scene before releasing the old scene, as can happen
	# during transitions. Old UI teardown must not clear the new registration.
	var next_map := scene.instantiate()
	add_child(next_map)
	var next_player := next_map.get_node("CharacterBody3D") as BasePlayer
	map.queue_free()
	await _frames(120)
	_check(RadialMenuService.get("_player") == next_player, "old UI preserves the new radial owner")
	_check(RadialMenuService.open("fire_mode"), "new wheel provider survives old scene teardown")
	# Unload while a wheel is open to exercise mouse ownership and callback cleanup.
	next_map.queue_free()
	await _frames(3)
	_check(not RadialMenuService.is_open() and RadialMenuService.get("_player") == null,
		"scene unload closes the wheel and releases its player")
	var wheels: Dictionary = RadialMenuService.get("_wheels")
	_check(not wheels.has("fire_mode") and not wheels.has("medical") and not wheels.has("squad_command"),
		"scene unload removes callbacks to freed player components")
	print(JSON.stringify({"status": "passed" if failures == 0 else "failed", "failed": failures}))
	get_tree().quit(0 if failures == 0 else 1)


func _test_weapon_feedback(player: BasePlayer) -> void:
	var manager := player.weapon_manager
	var weapon := manager.current_weapon
	_check(weapon != null and weapon.recoil_component != null, "initial weapon is ready")
	if not weapon or not weapon.recoil_component:
		return
	weapon.recoil_component.apply_recoil(1.0)
	_check(not player.force_receiver.get("_recoil_states").is_empty(), "recoil reaches the feedback component")
	manager.load_and_equip(weapon.config)
	var replacement := manager.current_weapon
	_check(replacement != weapon, "weapon replacement creates a new instance")
	_check(player.force_receiver.get("_recoil_states").is_empty(), "weapon replacement clears previous recoil")
	_check(player.camera_controller.get_recoil_component() == replacement.recoil_component,
		"weapon replacement rebinds camera recoil")
	_check(player.ik_rig.get("_weapon") == replacement
		and player.weapon_presentation_controller.get("_weapon") == replacement,
		"weapon replacement rebinds both IK and the independent presentation rig")
	player.stamina_system.set_carry_weight(0.0)
	manager.weapon_stats_changed.emit()
	var expected_weight := replacement.get_total_weight() if replacement.config.weight_affects_movement else 0.0
	_check(is_equal_approx(player.stamina_system.get_carry_weight_kg(), expected_weight),
		"weapon stats changes update carry weight")
	player.force_receiver.clear_forces()
	player.is_ragdolled = true
	player.apply_weapon_recoil(replacement, {
		"linear_impulse_local": Vector3.BACK,
		"angular_impulse_local": Vector3.RIGHT,
	})
	_check(player.force_receiver.get("_recoil_states").is_empty(), "ragdoll lifecycle still blocks weapon recoil")
	player.is_ragdolled = false


func _test_console_commands(player: BasePlayer) -> void:
	var console := player.console_system
	_check(console._run_command("status", []).get("ok", false), "status command retains player access")
	_check(console._run_command("help", ["giveammo"]).get("ok", false), "legacy ammo alias retains help")
	_check(not console._run_command("timescale", ["bad"]).get("ok", true), "handler rejects invalid numeric arguments")
	_check(not console._run_command("__unknown__", []).get("ok", true), "unknown command returns an error")
	var result := console._run_command("set_aiming", ["1"])
	_check(result.get("ok", false) and player.weapon_manager.is_aiming, "command table reaches the gameplay interface")
	console._run_command("set_aiming", ["0"])


func _test_menu_input(player: BasePlayer) -> void:
	player.pause_menu.open()
	await _frames(30)
	_check(player.has_control_lock(BasePlayer.CONTROL_LOCK_PAUSE) and not player.controllable,
		"nested pause menu blocks player control")
	player.pause_menu._open_settings()
	await _frames(30)
	_check(player.settings_menu.is_open() and player.has_control_lock(BasePlayer.CONTROL_LOCK_SETTINGS),
		"pause menu still opens the migrated settings UI")
	player.settings_menu.cancel_and_close()
	await _frames(30)
	_check(player.pause_menu.is_open() and not player.has_control_lock(BasePlayer.CONTROL_LOCK_SETTINGS),
		"closing settings restores the pause menu")
	player.pause_menu.close()
	await _frames(30)
	_check(player.controllable, "closing pause releases control")
	player.console_system.open()
	await _frames(30)
	_check(not player.controllable, "nested console blocks gameplay input")
	player.console_system.close()
	await _frames(30)
	_check(player.controllable, "closing console restores control")


func _frames(count: int) -> void:
	for _frame in count:
		await get_tree().process_frame


func _check(condition: bool, message: String) -> void:
	if not condition:
		failures += 1
		push_error(message)
