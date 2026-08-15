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
	await get_tree().process_frame

	var manager := map.get_node_or_null("AIPlayerManager") as AIPlayerManager
	var player := map.get_node_or_null("CharacterBody3D") as BasePlayer
	if not _check(manager != null and player != null, "map exposes player and AIPlayerManager"):
		return
	# The live player may settle a few millimetres under gravity while this test
	# waits for scene readiness; the captured spawn point should remain nearby.
	if not _check(manager.get_spawn_transform().origin.distance_to(player.global_position) < 0.1, "initial spawn transform is captured"):
		return

	var spawn_started := Time.get_ticks_usec()
	var first := manager.add_ai_player("CheckAIPlayer", BasePlayer.Faction.UA)
	var synchronous_spawn_usec := Time.get_ticks_usec() - spawn_started
	if not _check(first != null, "add_bot creates a bot"):
		return
	if not _check(first.is_ai_player and not first.controllable, "AIPlayer identity and control state are set"):
		return
	if not _check(first.player_config != player.player_config, "bot receives a copied player config"):
		return
	if not _check(first.player_config.starting_weapon.weapon_name == player.player_config.starting_weapon.weapon_name, "bot copies the starting weapon"):
		return
	if not _check(first.player_config.health_config != null, "bot copies the health configuration"):
		return
	if not _check(first.model_manager.model_node == null, "bot defers heavy model initialization"):
		return
	if not _check(synchronous_spawn_usec < 50000, "bot command returns without a long synchronous stall"):
		return
	var ready_deadline := Time.get_ticks_msec() + 5000
	while not first.is_ai_runtime_ready() and Time.get_ticks_msec() < ready_deadline:
		await get_tree().process_frame
	if not _check(first.is_ai_runtime_ready(), "bot finishes queued model and loadout initialization"):
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
	if not _check(
		bot_weapon.attachment_manager.get_all_attachments().size() == first.player_config.starting_weapon.default_attachment_configs.size(),
		"bot finishes its staggered default attachment loadout"
	):
		return
	if not _check(bot_weapon.get_parent() == first.weapon_manager.weapon_mount, "bot weapon is parented to the weapon mount"):
		return
	var bot_head := first.model_manager.model_node.find_child("Soldier_head", true, false) as MeshInstance3D
	if not _check(bot_head != null and bot_head.visible and (bot_head.layers & 1) != 0, "bot head is visible to world cameras"):
		return
	for local_ui in ["SeedCamera", "ConsoleSystem", "PauseMenu", "WeaponModMenu", "WeaponAmmoHUD", "FreeCameraController"]:
		if not _check(first.get_node_or_null(local_ui) == null, "bot has no local %s" % local_ui):
			return
	await get_tree().process_frame
	if not _check(first.health_system.get_hitbox_rids().size() > 0, "bot creates medical hitboxes"):
		return
	# Use a reference container because scalar closure captures are not written
	# back to the outer local in GDScript.
	var damage_seen := [false]
	first.health_system.damage_taken.connect(func(_info): damage_seen[0] = true)
	var damage := DamageInfo.new()
	damage.amount = 100.0
	damage.body_part = MedicalEnums.BodyPartId.TORSO
	damage.direction = Vector3.FORWARD
	first.health_system.apply_damage(damage)
	if not _check(damage_seen[0], "bot accepts damage through HealthSystem"):
		return

	var second := manager.add_ai_player("CheckAIPlayerTwo", BasePlayer.Faction.RU)
	if not _check(second != null and second.ai_player_id != first.ai_player_id, "AIPlayer IDs are unique"):
		return
	if not _check(manager.kill_ai_player(first.ai_player_id), "kill_ai_player accepts a valid ID"):
		return
	if not _check(is_instance_valid(first) and not first.is_alive, "kill does not remove the bot"):
		return
	await get_tree().process_frame
	var simulator := first.ragdoll_system._physical_simulator as PhysicalBoneSimulator3D
	if not _check(simulator != null and simulator.is_simulating_physics(), "bot death starts physical ragdoll simulation"):
		return
	var dropped_bot_weapon := get_tree().current_scene.find_child("%s_Dropped" % bot_weapon.name, true, false) as RigidBody3D
	if not _check(dropped_bot_weapon != null and bot_weapon.get_parent() == dropped_bot_weapon, "bot death drops its weapon as a rigid body"):
		return
	if not _check(dropped_bot_weapon.get_node_or_null("DroppedWeaponCollision") is CollisionShape3D, "dropped bot weapon has authored collision"):
		return
	if not _check(bot_head.visible and (bot_head.layers & 1) != 0, "ragdoll keeps the bot head visible to world cameras"):
		return
	first.revive()
	await get_tree().process_frame
	if not _check(bot_weapon.get_parent() == first.weapon_manager.weapon_mount, "revive restores the bot weapon to its mount"):
		return
	if not _check(not is_instance_valid(dropped_bot_weapon), "revive removes the dropped bot weapon body"):
		return

	var player_weapon := player.weapon_manager.current_weapon
	player.die()
	await get_tree().process_frame
	var dropped_player_weapon := get_tree().current_scene.find_child("%s_Dropped" % player_weapon.name, true, false) as RigidBody3D
	if not _check(dropped_player_weapon != null and player_weapon.get_parent() == dropped_player_weapon, "player death uses the same weapon drop system"):
		return
	player.revive()
	await get_tree().process_frame
	if not _check(player_weapon.get_parent() == player.weapon_manager.weapon_mount, "player revive restores the weapon to its mount"):
		return
	if not _check(manager.remove_ai_player(first.ai_player_id), "remove_ai_player accepts a valid ID"):
		return
	if not _check(manager.get_ai_player_by_id(first.ai_player_id) == null, "remove_ai_player removes only the selected AIPlayer"):
		return
	manager.remove_all_ai_players()
	await get_tree().process_frame
	await get_tree().process_frame
	map.queue_free()
	await get_tree().process_frame
	await get_tree().process_frame
	print("bot_manager_check=ok")
	get_tree().quit(0)


func _check(condition: bool, message: String) -> bool:
	if condition:
		return true
	push_error(message)
	get_tree().quit(1)
	return false
