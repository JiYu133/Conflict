extends Node

## End-to-end check of the LimboAI behaviour tree on real AIPlayers:
##   1. aim contract: FireAtTarget never shoots unless the AIAimProvider is ready;
##   2. walk, find and attack: a bot walks toward its objective, spots an enemy
##      that started out of sight range, aims and fires real rounds.
## Run: godot --headless --path . --fixed-fps 60 tests/ai_behavior_check.tscn

const DEFAULT_TREE := "res://assets/config/ai/trees/ai_default_behavior_tree.tres"
const AIM_TASK := "res://classes/bot/limbo/tasks/aim_at_target.gd"


class NeverReadyAim extends AIAimProvider:
	func update_aim(brain: AIPlayerBrain, target: BasePlayer, _profile: AIProfile, _delta: float) -> bool:
		brain.face(brain.get_target_aim_point(target))
		return false


var _manager: AIPlayerManager
var _navigation: AINavigationService


func _ready() -> void:
	_run.call_deferred()


func _run() -> void:
	var map := (load("res://assets/map/TestMap.tscn") as PackedScene).instantiate()
	get_tree().root.add_child(map)
	await get_tree().process_frame
	# Park the local player far outside every bot's perception range.
	var player := map.get_node("CharacterBody3D") as BasePlayer
	player.global_position = Vector3(150, 1, 150)
	_manager = map.get_node("AIPlayerManager") as AIPlayerManager
	_navigation = AINavigationService.new()
	add_child(_navigation)

	# --- 1. Aim contract ------------------------------------------------------
	var shooter := await _spawn("Shooter", BasePlayer.Faction.UA, Vector3(-60, 1, -60), 0.0)
	var dummy := await _spawn("Dummy", BasePlayer.Faction.RU, Vector3(-60, 1, -75), 0.0)
	if not shooter or not dummy:
		return
	var blocked_config := AIConfig.new()
	blocked_config.behavior_tree = _tree_with_aim(NeverReadyAim.new())
	var shooter_brain := _make_brain(shooter, Vector3(-60, 0, -60), blocked_config)
	var ammo_before := _ammo(shooter)
	var seen := await _simulate([shooter_brain], 180)
	if not _check(_started(seen[0], "Aim At"), "bot reaches the aim task: %s" % [seen[0].keys()]):
		return
	if not _check(_ammo(shooter) == ammo_before, "no shot while the aim provider is not ready"):
		return
	var default_config := AIConfig.new()
	default_config.behavior_tree = load(DEFAULT_TREE)
	shooter_brain.apply_config(default_config)
	await _simulate([shooter_brain], 180)
	var contract_shots := ammo_before - _ammo(shooter)
	if not _check(contract_shots > 0, "default aim fires once lined up"):
		return
	shooter_brain.shutdown()
	_manager.remove_all_ai_players()
	await get_tree().physics_frame

	# --- 2. Walk, find and attack ---------------------------------------------
	# 40 m apart: beyond the default 32 m perception distance.
	var hunter := await _spawn("Hunter", BasePlayer.Faction.UA, Vector3(-40, 1, -80), 0.0)
	var guard := await _spawn("Guard", BasePlayer.Faction.RU, Vector3(-40, 1, -120), PI)
	if not hunter or not guard:
		return
	var start := hunter.global_position
	var hunter_brain := _make_brain(hunter, Vector3(-40, 0, -112), null)
	var guard_brain := _make_brain(guard, guard.global_position, null)
	var hunter_ammo := _ammo(hunter)
	var guard_ammo := _ammo(guard)
	var hits := {"count": 0}
	for bot in [hunter, guard]:
		bot.health_system.damage_taken.connect(func(_info): hits.count += 1)
	seen = await _simulate([hunter_brain, guard_brain], 60 * 20)
	var walked := start.distance_to(hunter.global_position)
	print("hunter activities: ", seen[0].keys())
	print("guard activities: ", seen[1].keys())
	if not _check(_started(seen[0], "Move To $objective_position"), "hunter walks to its objective"):
		return
	if not _check(walked > 5.0, "hunter actually moved (%.1f m)" % walked):
		return
	if not _check(_started(seen[0], "Aim At"), "hunter finds the guard and aims"):
		return
	var shots := (hunter_ammo - _ammo(hunter)) + (guard_ammo - _ammo(guard))
	if not _check(shots > 0, "the fight fires real rounds"):
		return
	if not _check(hits.count > 0, "bullets hit someone (%d shots)" % shots):
		return
	print("ai_behavior_check=ok contract_shots=%d walked=%.1fm fight_shots=%d hits=%d hunter=%s guard=%s" % [
		contract_shots, walked, shots, hits.count,
		MedicalEnums.HealthState.keys()[hunter.health_system.get_state()],
		MedicalEnums.HealthState.keys()[guard.health_system.get_state()]])
	get_tree().quit(0)


func _spawn(bot_name: String, faction: BasePlayer.Faction, position: Vector3, yaw: float) -> AIPlayer:
	var bot := _manager.add_ai_player(bot_name, faction, position, true)
	if not _check(bot != null, "spawn %s: %s" % [bot_name, _manager.last_error]):
		return null
	for i in 240:
		if bot.is_ai_runtime_ready():
			break
		await get_tree().process_frame
	if not _check(bot.is_ai_runtime_ready() and bot.weapon_manager.current_weapon != null, "%s loadout ready" % bot_name):
		return null
	bot.rotation.y = yaw
	return bot


func _make_brain(bot: AIPlayer, objective: Vector3, config: AIConfig) -> AIPlayerBrain:
	var squad := AISquadCommander.new()
	squad.initialize(int(bot.faction), objective, objective)
	squad.add_member(bot)
	var brain := AIPlayerBrain.new()
	add_child(brain)
	brain.initialize(bot, squad, _navigation, config)
	return brain


## Steps physics and records which actions each brain started.
func _simulate(brains: Array, frames: int) -> Array:
	var seen: Array = []
	for brain in brains:
		seen.append({})
	for i in frames:
		await get_tree().physics_frame
		for index in brains.size():
			seen[index][brains[index].activity] = true
	return seen


func _started(activities: Dictionary, prefix: String) -> bool:
	for name: String in activities:
		if name.begins_with(prefix):
			return true
	return false


func _tree_with_aim(provider: AIAimProvider) -> BehaviorTree:
	var tree := (load(DEFAULT_TREE) as BehaviorTree).clone()
	var pending: Array[BTTask] = [tree.get_root_task()]
	while not pending.is_empty():
		var task: BTTask = pending.pop_back()
		if task.get_script() and (task.get_script() as Script).resource_path == AIM_TASK:
			task.set(&"aim_provider", provider)
		for index in task.get_child_count():
			pending.append(task.get_child(index))
	return tree


func _ammo(bot: BasePlayer) -> int:
	var weapon := bot.weapon_manager.current_weapon
	return weapon.get_current_magazine_count() + weapon.get_reserve_ammo_count() + (1 if weapon.has_chambered_round() else 0)


func _check(condition: bool, message: String) -> bool:
	if condition:
		return true
	push_error(message)
	get_tree().quit(1)
	return false
