class_name AISquadCommander
extends RefCounted

var faction: int = BasePlayer.Faction.None
var blackboard := AIBlackboard.new()
var objective_position: Vector3 = Vector3.ZERO
var extraction_position: Vector3 = Vector3.ZERO
var leader: BasePlayer
var members: Array[BasePlayer] = []
var cover_assignments: Dictionary = {}
var assault_assignments: Dictionary = {}
var _reassign_timer := 0.0
var _cover_time := 0.0


func initialize(new_faction: int, objective: Vector3, extraction: Vector3) -> void:
	faction = new_faction
	objective_position = objective
	extraction_position = extraction
	blackboard.faction = faction
	blackboard.objective_position = objective
	blackboard.extraction_position = extraction


func add_member(bot: BasePlayer) -> void:
	if bot and not members.has(bot):
		members.append(bot)
		elect_leader()


func remove_member(bot: BasePlayer) -> void:
	members.erase(bot)
	cover_assignments.erase(bot.get_instance_id() if bot else -1)
	assault_assignments.erase(bot.get_instance_id() if bot else -1)
	if leader == bot:
		leader = null
	elect_leader()


func elect_leader() -> BasePlayer:
	if is_instance_valid(leader) and leader.is_alive:
		return leader
	var best: BasePlayer
	var best_distance := INF
	for bot in members:
		if not is_instance_valid(bot) or not bot.is_alive:
			continue
		var distance := bot.global_position.distance_to(objective_position)
		if distance < best_distance:
			best = bot
			best_distance = distance
	leader = best
	return leader


func tick(delta: float, now: float, profile: AIProfile) -> void:
	_reassign_timer -= delta
	_cover_time -= delta
	elect_leader()
	if _reassign_timer > 0.0 and _cover_time > 0.0:
		return
	_reassign_timer = 0.5
	if blackboard.retreat_order:
		return
	var alive: Array[BasePlayer] = []
	for bot in members:
		if is_instance_valid(bot) and bot.is_alive:
			alive.append(bot)
	var casualty_ratio := 1.0 - float(alive.size()) / maxf(float(members.size()), 1.0)
	if casualty_ratio >= profile.retreat_casualty_ratio:
		blackboard.issue_retreat("casualties", extraction_position, leader, now)
		return
	cover_assignments.clear()
	assault_assignments.clear()
	_cover_time = profile.suppression_duration
	if not blackboard.has_fresh_enemy(now, profile.blackboard_stale_time):
		return
	var candidates: Array[BasePlayer] = []
	for bot in alive:
		if bot == leader:
			continue
		if bot.global_position.distance_to(blackboard.enemy_position) <= profile.weapon_distance * 1.25:
			candidates.append(bot)
	var cover_count := mini(profile.suppression_count, candidates.size())
	for index in range(cover_count):
		cover_assignments[candidates[index].get_instance_id()] = true
	for bot in alive:
		if not cover_assignments.has(bot.get_instance_id()):
			assault_assignments[bot.get_instance_id()] = true


func is_covering(bot: BasePlayer) -> bool:
	return cover_assignments.has(bot.get_instance_id())


func is_assaulting(bot: BasePlayer) -> bool:
	return assault_assignments.has(bot.get_instance_id())


func get_role(bot: BasePlayer) -> String:
	if bot == leader:
		return "leader"
	if is_covering(bot):
		return "suppress"
	if is_assaulting(bot):
		return "assault"
	return "patrol"


func issue_player_command(command: AIBlackboard.SquadCommand, player: BasePlayer, now: float) -> void:
	if not player or player.faction != faction:
		return
	var position := player.global_position
	if command == AIBlackboard.SquadCommand.MOVE_TO_OBJECTIVE:
		position = objective_position
	elif command == AIBlackboard.SquadCommand.ADVANCE:
		position = blackboard.enemy_position if blackboard.has_fresh_enemy(now, 30.0) else objective_position
	elif command == AIBlackboard.SquadCommand.ATTACK:
		position = blackboard.enemy_position if blackboard.has_fresh_enemy(now, 30.0) else player.global_position + (-player.global_basis.z) * 25.0
	blackboard.issue_command(command, player, position, now)
