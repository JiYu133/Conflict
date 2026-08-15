class_name AIPlayerManager
extends Node

## Map-scoped factory and registry for AIPlayer instances.
## The console's bot command is an entity command; the runtime type is AIPlayer.

@export var player_path: NodePath
var last_error: String = ""
var initial_spawn_transform: Transform3D = Transform3D.IDENTITY

signal ai_player_ready(ai_player: AIPlayer)

var _player: BasePlayer
var _ai_players: Dictionary = {}
var _brains: Dictionary = {}
var _next_id: int = 1
var _spawn_captured := false
var _pending_model_loads: Array[WeakRef] = []
var _model_load_worker_active := false


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


func set_spawn_transform(spawn_transform: Transform3D) -> void:
	initial_spawn_transform = spawn_transform
	_spawn_captured = true


func is_name_available(ai_player_name: String) -> bool:
	if ai_player_name.is_empty():
		return true
	for ai_player in _ai_players.values():
		if is_instance_valid(ai_player) and ai_player.ai_display_name.to_lower() == ai_player_name.to_lower():
			return false
	return true


func add_ai_player(
	ai_player_name: String = "",
	ai_faction: BasePlayer.Faction = BasePlayer.Faction.None,
	spawn_position: Vector3 = Vector3.ZERO,
	use_spawn_position: bool = false,
	ai_config: AIConfig = null
) -> AIPlayer:
	last_error = ""
	var player := get_player()
	if not player:
		last_error = "当前场景没有可用的玩家。"
		return null

	var resolved_name := ai_player_name.strip_edges()
	if resolved_name.is_empty():
		resolved_name = _next_default_name()
	if not is_name_available(resolved_name):
		last_error = "AIPlayer 名称已存在：%s。" % resolved_name
		return null

	var id := _next_id
	_next_id += 1
	var config: PlayerConfig
	if ai_config:
		config = ai_config.build_player_config(player.player_config)
	else:
		config = _copy_player_config(player.player_config)

	var node := CharacterBody3D.new()
	node.set_script(preload("res://classes/player/ai_player.gd"))
	var ai_player := node as AIPlayer
	if not ai_player:
		last_error = "无法创建 AIPlayer。"
		node.free()
		return null

	ai_player.name = "AIPlayer_%d" % id
	ai_player.ai_player_id = id
	ai_player.ai_display_name = resolved_name
	ai_player.is_ai_player = true
	ai_player.controllable = false
	ai_player.faction = ai_faction
	ai_player.ai_config = ai_config
	ai_player.player_config = config
	ai_player.defer_ai_model_load = true
	add_child(ai_player)
	if use_spawn_position:
		ai_player.global_position = spawn_position
	else:
		ai_player.global_transform = initial_spawn_transform
	_ai_players[id] = ai_player
	_pending_model_loads.append(weakref(ai_player))
	_drain_model_load_queue.call_deferred()
	return ai_player


func _drain_model_load_queue() -> void:
	if _model_load_worker_active:
		return
	_model_load_worker_active = true
	while not _pending_model_loads.is_empty():
		# Always cross a frame boundary before a model scene is instantiated. This
		# keeps bot add commands responsive and serializes encounter batch spawns.
		await get_tree().process_frame
		var pending_ref := _pending_model_loads.pop_front() as WeakRef
		var ai_player := pending_ref.get_ref() as AIPlayer
		if not is_instance_valid(ai_player) or ai_player.is_queued_for_deletion():
			continue
		ai_player.begin_deferred_model_load()
		# A bot's weapon and default attachments are initialized incrementally.
		# Wait for that work before beginning the next bot to avoid overlapping
		# two expensive spawn stages on one rendered frame.
		while is_instance_valid(ai_player) and not ai_player.is_queued_for_deletion() \
				and not ai_player.is_ai_runtime_ready():
			await get_tree().process_frame
		if is_instance_valid(ai_player) and not ai_player.is_queued_for_deletion():
			ai_player_ready.emit(ai_player)
	_model_load_worker_active = false


## Registers the runtime brain owned by a director/squad. Keeping this registry
## on AIPlayerManager makes AIPlayer lifecycle cleanup explicit and queryable.
func register_brain(bot: BasePlayer, brain: AIPlayerBrain) -> void:
	if bot and brain:
		_brains[bot.get_instance_id()] = brain


func get_brain(bot: BasePlayer) -> AIPlayerBrain:
	if not bot:
		return null
	var brain = _brains.get(bot.get_instance_id(), null)
	return brain as AIPlayerBrain if is_instance_valid(brain) else null


func get_brains() -> Array[AIPlayerBrain]:
	var result: Array[AIPlayerBrain] = []
	for key in _brains.keys():
		var brain = _brains[key]
		if is_instance_valid(brain):
			result.append(brain as AIPlayerBrain)
	return result


func get_ai_player_by_id(ai_player_id: int) -> AIPlayer:
	var ai_player = _ai_players.get(ai_player_id, null)
	if is_instance_valid(ai_player):
		return ai_player as AIPlayer
	return null


func get_ai_players() -> Array[AIPlayer]:
	var result: Array[AIPlayer] = []
	for ai_player_id in _ai_players.keys():
		var ai_player := get_ai_player_by_id(int(ai_player_id))
		if ai_player:
			result.append(ai_player)
	return result


func get_ai_player(ai_player_id: int) -> AIPlayer:
	var ai_player = _ai_players.get(ai_player_id, null)
	return ai_player as AIPlayer if is_instance_valid(ai_player) else null


## Assigns a tactical AIConfig to an existing AIPlayer. Player model and
## loadout overrides are only applied when the entity is spawned.
func set_ai_player_config(ai_player_id: int, config: AIConfig) -> bool:
	last_error = ""
	if not config:
		last_error = "AIConfig 资源无效。"
		return false
	var ai_player := get_ai_player_by_id(ai_player_id)
	if not ai_player:
		last_error = "找不到 AIPlayer ID：%d。" % ai_player_id
		return false
	ai_player.ai_config = config
	var brain := get_brain(ai_player)
	if brain:
		brain.apply_config(config)
	return true


func set_all_ai_player_config(config: AIConfig) -> int:
	var count := 0
	for ai_player in get_ai_players():
		if set_ai_player_config(ai_player.ai_player_id, config):
			count += 1
	return count


func set_ai_player_test_motion(ai_player_id: int, world_velocity: Vector3) -> bool:
	var ai_player := get_ai_player_by_id(ai_player_id)
	if not ai_player:
		last_error = "找不到 AIPlayer ID：%d。" % ai_player_id
		return false
	if not ai_player.set_ai_player_test_motion(world_velocity):
		last_error = "AIPlayer ID=%d 当前不可移动。" % ai_player_id
		return false
	return true

func set_all_ai_player_test_motion(world_velocity: Vector3) -> int:
	var count := 0
	for ai_player in get_ai_players():
		if ai_player.set_ai_player_test_motion(world_velocity):
			count += 1
	return count

func stop_ai_player_test_motion(ai_player_id: int) -> bool:
	var ai_player := get_ai_player_by_id(ai_player_id)
	if not ai_player:
		last_error = "找不到 AIPlayer ID：%d。" % ai_player_id
		return false
	ai_player.stop_ai_player_test_motion()
	return true

func stop_all_ai_player_test_motion() -> int:
	var count := 0
	for ai_player in get_ai_players():
		if ai_player.stop_ai_player_test_motion():
			count += 1
	return count


func kill_ai_player(ai_player_id: int) -> bool:
	var ai_player := get_ai_player_by_id(ai_player_id)
	if not ai_player:
		last_error = "找不到 AIPlayer ID：%d。" % ai_player_id
		return false
	if ai_player.is_alive:
		ai_player.die()
	return true


func remove_ai_player(ai_player_id: int) -> bool:
	var ai_player := get_ai_player_by_id(ai_player_id)
	if not ai_player:
		last_error = "找不到 AIPlayer ID：%d。" % ai_player_id
		return false
	var brain := get_brain(ai_player)
	if brain:
		_brains.erase(ai_player.get_instance_id())
		brain.queue_free()
	_ai_players.erase(ai_player_id)
	ai_player.queue_free()
	return true


func kill_all_ai_players() -> int:
	var count := 0
	for bot_id in _ai_players.keys():
		if kill_ai_player(int(bot_id)):
			count += 1
	return count


func remove_all_ai_players() -> int:
	var ids := _ai_players.keys()
	for bot_id in ids:
		remove_ai_player(int(bot_id))
	return ids.size()


func _next_default_name() -> String:
	var index := 1
	while not is_name_available("AIPlayer_%d" % index):
		index += 1
	return "AIPlayer_%d" % index


func _copy_player_config(source: PlayerConfig) -> PlayerConfig:
	if source:
		# PlayerConfig and its nested gameplay resources are treated as immutable
		# templates during spawn. A shallow copy keeps per-bot root identity without
		# recursively duplicating model, weapon and medical resource graphs.
		return source.duplicate(false) as PlayerConfig
	return PlayerConfig.new()


func _find_player() -> BasePlayer:
	if not player_path.is_empty():
		var configured := get_node_or_null(player_path) as BasePlayer
		if configured and not configured.is_ai_player:
			return configured
	return _find_player_recursive(get_parent())


func _find_player_recursive(node: Node) -> BasePlayer:
	if node is BasePlayer and not (node as BasePlayer).is_ai_player:
		return node as BasePlayer
	for child in node.get_children():
		var found := _find_player_recursive(child)
		if found:
			return found
	return null
