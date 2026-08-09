class_name BotManager
extends Node

## Map-scoped factory and registry for BasePlayer-backed bots.

@export var player_path: NodePath
@export var default_bot_config: BotConfig

var last_error: String = ""
var initial_spawn_transform: Transform3D = Transform3D.IDENTITY

var _player: BasePlayer
var _bots: Dictionary = {}
var _next_id: int = 1
var _spawn_captured := false


func _ready() -> void:
	_player = _find_player()
	if _player:
		initial_spawn_transform = _player.global_transform
		_spawn_captured = true
	call_deferred("_initialize")


func _initialize() -> void:
	if not _player or not is_instance_valid(_player):
		_player = _find_player()
	if _player and not _spawn_captured:
		initial_spawn_transform = _player.global_transform
		_spawn_captured = true


func get_player() -> BasePlayer:
	if not is_instance_valid(_player):
		_player = _find_player()
	return _player


func get_spawn_transform() -> Transform3D:
	return initial_spawn_transform


func is_name_available(bot_name: String) -> bool:
	if bot_name.is_empty():
		return true
	for bot in _bots.values():
		if is_instance_valid(bot) and bot.bot_display_name.to_lower() == bot_name.to_lower():
			return false
	return true


func add_bot(
	bot_name: String = "",
	bot_faction: BasePlayer.Faction = BasePlayer.Faction.None,
	spawn_position: Vector3 = Vector3.ZERO,
	use_spawn_position: bool = false,
	bot_config: BotConfig = null
) -> BasePlayer:
	last_error = ""
	var player := get_player()
	if not player:
		last_error = "当前场景没有可用的玩家。"
		return null

	var resolved_name := bot_name.strip_edges()
	if resolved_name.is_empty():
		resolved_name = _next_default_name()
	if not is_name_available(resolved_name):
		last_error = "Bot 名称已存在：%s。" % resolved_name
		return null

	var id := _next_id
	_next_id += 1
	var config_source := bot_config if bot_config else default_bot_config
	var config: PlayerConfig
	if config_source:
		config = config_source.build_player_config(player.player_config)
	else:
		config = _copy_player_config(player.player_config)

	var node := CharacterBody3D.new()
	node.set_script(preload("res://classes/player/base_player.gd"))
	var bot := node as BasePlayer
	if not bot:
		last_error = "无法创建 BasePlayer Bot。"
		node.free()
		return null

	bot.name = "Bot_%d" % id
	bot.bot_id = id
	bot.bot_display_name = resolved_name
	bot.is_bot = true
	bot.controllable = false
	bot.faction = bot_faction
	bot.player_config = config
	add_child(bot)
	if use_spawn_position:
		bot.global_position = spawn_position
	else:
		bot.global_transform = initial_spawn_transform
	_bots[id] = bot
	return bot


func get_bot(bot_id: int) -> BasePlayer:
	var bot = _bots.get(bot_id, null)
	if is_instance_valid(bot):
		return bot as BasePlayer
	return null


func get_bots() -> Array[BasePlayer]:
	var result: Array[BasePlayer] = []
	for bot_id in _bots.keys():
		var bot := get_bot(int(bot_id))
		if bot:
			result.append(bot)
	return result

func set_bot_test_motion(bot_id: int, world_velocity: Vector3) -> bool:
	var bot := get_bot(bot_id)
	if not bot:
		last_error = "找不到 Bot ID：%d。" % bot_id
		return false
	if not bot.set_bot_test_motion(world_velocity):
		last_error = "Bot ID=%d 当前不可移动。" % bot_id
		return false
	return true

func set_all_bot_test_motion(world_velocity: Vector3) -> int:
	var count := 0
	for bot in get_bots():
		if bot.set_bot_test_motion(world_velocity):
			count += 1
	return count

func stop_bot_test_motion(bot_id: int) -> bool:
	var bot := get_bot(bot_id)
	if not bot:
		last_error = "找不到 Bot ID：%d。" % bot_id
		return false
	bot.stop_bot_test_motion()
	return true

func stop_all_bot_test_motion() -> int:
	var count := 0
	for bot in get_bots():
		if bot.stop_bot_test_motion():
			count += 1
	return count


func kill_bot(bot_id: int) -> bool:
	var bot := get_bot(bot_id)
	if not bot:
		last_error = "找不到 Bot ID：%d。" % bot_id
		return false
	if bot.is_alive:
		bot.die()
	return true


func remove_bot(bot_id: int) -> bool:
	var bot := get_bot(bot_id)
	if not bot:
		last_error = "找不到 Bot ID：%d。" % bot_id
		return false
	_bots.erase(bot_id)
	bot.queue_free()
	return true


func kill_all() -> int:
	var count := 0
	for bot_id in _bots.keys():
		if kill_bot(int(bot_id)):
			count += 1
	return count


func remove_all() -> int:
	var ids := _bots.keys()
	for bot_id in ids:
		remove_bot(int(bot_id))
	return ids.size()


func _next_default_name() -> String:
	var index := 1
	while not is_name_available("Bot_%d" % index):
		index += 1
	return "Bot_%d" % index


func _copy_player_config(source: PlayerConfig) -> PlayerConfig:
	if source:
		return source.duplicate(true) as PlayerConfig
	return PlayerConfig.new()


func _find_player() -> BasePlayer:
	if not player_path.is_empty():
		var configured := get_node_or_null(player_path) as BasePlayer
		if configured and not configured.is_bot:
			return configured
	return _find_player_recursive(get_parent())


func _find_player_recursive(node: Node) -> BasePlayer:
	if node is BasePlayer and not (node as BasePlayer).is_bot:
		return node as BasePlayer
	for child in node.get_children():
		var found := _find_player_recursive(child)
		if found:
			return found
	return null
