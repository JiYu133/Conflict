class_name AIBlackboard
extends RefCounted

## Local, single-player squad information store. It deliberately contains no
## networking code; all tactical communication stays inside this encounter.

signal information_published(kind: String, payload: Dictionary)

enum SquadCommand { NONE, FOLLOW_PLAYER, MOVE_TO_OBJECTIVE, ADVANCE, HOLD, FALL_BACK, ATTACK }

var faction: int = BasePlayer.Faction.None
var enemy_position: Vector3 = Vector3.ZERO
var last_visible_enemy_position: Vector3 = Vector3.ZERO
var enemy_actor: BasePlayer
var enemy_timestamp: float = -INF
var enemy_confidence: float = 0.0
var objective_state: int = 0
var objective_position: Vector3 = Vector3.ZERO
var extraction_position: Vector3 = Vector3.ZERO
var retreat_order: bool = false
var retreat_reason: String = ""
var rally_position: Vector3 = Vector3.ZERO
var cover_request: Dictionary = {}
var event_log: Array[Dictionary] = []
var squad_command: SquadCommand = SquadCommand.NONE
var command_source: BasePlayer
var command_position: Vector3 = Vector3.ZERO
var command_timestamp: float = -INF


func publish_enemy_spotted(source: BasePlayer, target: BasePlayer, position: Vector3, confidence: float, now: float = 0.0) -> void:
	enemy_actor = target
	enemy_position = position
	last_visible_enemy_position = position
	enemy_timestamp = now
	enemy_confidence = clampf(confidence, 0.0, 1.0)
	_publish("enemy_spotted", {"source": source, "target": target, "position": position, "timestamp": now, "confidence": enemy_confidence})


func publish_under_fire(source: BasePlayer, position: Vector3, priority: int = 50, now: float = 0.0) -> void:
	_publish("under_fire", {"source": source, "position": position, "timestamp": now, "priority": priority})


func publish_need_cover(source: BasePlayer, position: Vector3, priority: int = 60, now: float = 0.0) -> void:
	cover_request = {"source": source, "position": position, "timestamp": now, "priority": priority}
	_publish("need_cover", cover_request)


func publish_objective_status(state: int, now: float = 0.0) -> void:
	objective_state = state
	_publish("objective_status_changed", {"state": state, "timestamp": now, "priority": 40})


func issue_command(command: SquadCommand, source: BasePlayer, position: Vector3, now: float = 0.0) -> void:
	squad_command = command
	command_source = source
	command_position = position
	command_timestamp = now
	_publish("squad_command", {
		"command": command,
		"source": source,
		"position": position,
		"timestamp": now,
		"priority": 80,
	})


func clear_command() -> void:
	squad_command = SquadCommand.NONE
	command_source = null
	command_position = Vector3.ZERO


static func command_name(command: SquadCommand) -> String:
	match command:
		SquadCommand.FOLLOW_PLAYER: return "follow_player"
		SquadCommand.MOVE_TO_OBJECTIVE: return "move_to_objective"
		SquadCommand.ADVANCE: return "advance"
		SquadCommand.HOLD: return "hold"
		SquadCommand.FALL_BACK: return "fall_back"
		SquadCommand.ATTACK: return "attack"
	return "none"


func publish_enemy_lost(source: BasePlayer, position: Vector3, now: float = 0.0) -> void:
	last_visible_enemy_position = position
	_publish("enemy_lost", {"source": source, "position": position, "timestamp": now, "confidence": enemy_confidence})


func has_fresh_enemy(now: float, stale_time: float) -> bool:
	return enemy_confidence > 0.1 and now - enemy_timestamp <= stale_time


func issue_retreat(reason: String, rally: Vector3, source: BasePlayer = null, now: float = 0.0) -> void:
	retreat_order = true
	retreat_reason = reason
	rally_position = rally
	_publish("retreat_order", {"source": source, "reason": reason, "rally": rally, "timestamp": now, "priority": 100})


func clear_retreat() -> void:
	retreat_order = false
	retreat_reason = ""


func _publish(kind: String, payload: Dictionary) -> void:
	payload["kind"] = kind
	event_log.push_back(payload)
	if event_log.size() > 64:
		event_log.pop_front()
	information_published.emit(kind, payload)
