extends SceneTree


func _init() -> void:
	var scene := load("res://res/map/TestMap.tscn") as PackedScene
	if not _check(scene != null, "TestMap scene loads"):
		return
	var map := scene.instantiate()
	get_root().add_child(map)
	await process_frame
	await process_frame

	var manager := map.get_node_or_null("BotManager") as BotManager
	var player := map.get_node_or_null("CharacterBody3D") as BasePlayer
	if not _check(manager != null and player != null, "map exposes player and BotManager"):
		return
	if not _check(manager.get_spawn_transform().origin.is_equal_approx(player.global_position), "initial spawn transform is captured"):
		return

	var first := manager.add_bot("CheckBot", BasePlayer.Faction.UA)
	if not _check(first != null, "add_bot creates a bot"):
		return
	if not _check(first.is_bot and not first.controllable, "bot identity and control state are set"):
		return
	if not _check(first.player_config != player.player_config, "bot receives a copied player config"):
		return
	if not _check(first.player_config.starting_weapon.weapon_name == player.player_config.starting_weapon.weapon_name, "bot copies the starting weapon"):
		return
	if not _check(first.player_config.health_config != null, "bot copies the health configuration"):
		return
	if not _check(first.model_manager.model_node != null, "bot loads the player model"):
		return
	if not _check(first.model_manager.animator != null, "bot keeps the model AnimationPlayer"):
		return
	if not _check(first.model_manager.animation_tree != null and first.model_manager.animation_tree.active, "bot enables the model AnimationTree"):
		return
	var bot_weapon := first.weapon_manager.current_weapon
	if not _check(bot_weapon != null, "bot equips the starting weapon"):
		return
	if not _check(bot_weapon.get_parent() == first.weapon_manager.weapon_mount, "bot weapon is parented to the weapon mount"):
		return
	var bot_head := first.model_manager.model_node.find_child("Soldier_head", true, false) as MeshInstance3D
	if not _check(bot_head != null and bot_head.visible and (bot_head.layers & 1) != 0, "bot head is visible to world cameras"):
		return
	for local_ui in ["SeedCamera", "ConsoleSystem", "PauseMenu", "WeaponModMenu", "WeaponAmmoHUD", "FreeCameraController"]:
		if not _check(first.get_node_or_null(local_ui) == null, "bot has no local %s" % local_ui):
			return
	await process_frame
	if not _check(first.health_system.get_hitbox_rids().size() > 0, "bot creates medical hitboxes"):
		return
	var damage_seen := false
	first.health_system.damage_taken.connect(func(_info): damage_seen = true)
	var damage := DamageInfo.new()
	damage.amount = 100.0
	damage.body_part = MedicalEnums.BodyPartId.TORSO
	damage.direction = Vector3.FORWARD
	first.health_system.apply_damage(damage)
	if not _check(damage_seen, "bot accepts damage through HealthSystem"):
		return

	var second := manager.add_bot("CheckBotTwo", BasePlayer.Faction.RU)
	if not _check(second != null and second.bot_id != first.bot_id, "bot IDs are unique"):
		return
	if not _check(manager.kill_bot(first.bot_id), "kill_bot accepts a valid ID"):
		return
	if not _check(is_instance_valid(first) and not first.is_alive, "kill does not remove the bot"):
		return
	await process_frame
	var simulator := first.ragdoll_system._physical_simulator as PhysicalBoneSimulator3D
	if not _check(simulator != null and simulator.is_simulating_physics(), "bot death starts physical ragdoll simulation"):
		return
	if not _check(bot_head.visible and (bot_head.layers & 1) != 0, "ragdoll keeps the bot head visible to world cameras"):
		return
	if not _check(manager.remove_bot(first.bot_id), "remove_bot accepts a valid ID"):
		return
	if not _check(manager.get_bot(first.bot_id) == null, "remove_bot removes only the selected bot"):
		return
	manager.remove_all()
	print("bot_manager_check=ok")
	quit(0)


func _check(condition: bool, message: String) -> bool:
	if condition:
		return true
	push_error(message)
	quit(1)
	return false
