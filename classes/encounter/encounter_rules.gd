class_name EncounterRules
extends RefCounted

signal match_state_changed(state: int)
signal objective_progress_changed(progress: float, control_faction: int, objective_state: int)
signal actor_status_changed(actor: Object, status: String)
signal extraction_opened(reason: String)
signal match_finished(result: Dictionary)

enum MatchState { DEPLOYMENT, ACTIVE, OBJECTIVE_SECURED, EXTRACTION_OPEN, MATCH_SUCCESS, MATCH_PARTIAL_SUCCESS, MATCH_FAILED }
enum ObjectiveState { UNCONTROLLED, CONTESTED, RU_CONTROLLED, UA_CONTROLLED, SECURED }

const ACTOR_ALIVE := "alive"
const ACTOR_DOWN := "down"
const ACTOR_EXTRACTED := "extracted"

var config: EncounterConfig
var state: MatchState = MatchState.DEPLOYMENT
var objective_state: ObjectiveState = ObjectiveState.UNCONTROLLED
var elapsed_time: float = 0.0
var remaining_time: float = 0.0
var extraction_reason: String = ""

var _actors: Array[Dictionary] = []
var _progress_by_faction: Dictionary = {}
var _control_faction: int = -1
var _extraction_progress: Dictionary = {}
var _result: Dictionary = {}

func _init(new_config: EncounterConfig = null) -> void:
	config = new_config if new_config else EncounterConfig.new()
	remaining_time = config.match_duration

func start_match() -> void:
	state = MatchState.DEPLOYMENT
	objective_state = ObjectiveState.UNCONTROLLED
	elapsed_time = 0.0
	remaining_time = config.match_duration
	extraction_reason = ""
	_progress_by_faction = {}
	_control_faction = -1
	_extraction_progress = {}
	_result = {}
	_set_state(MatchState.DEPLOYMENT)
	if config.deployment_duration <= 0.0:
		_set_state(MatchState.ACTIVE)

func register_actor(actor: Object, faction: int) -> bool:
	if actor == null:
		return false
	for record in _actors:
		if record.actor == actor:
			return false
	var status := ACTOR_ALIVE if _actor_is_alive(actor) else ACTOR_DOWN
	_actors.append({"actor": actor, "faction": faction, "status": status})
	if actor.has_signal("died"):
		var died_callable := Callable(self, "_on_actor_died").bind(actor)
		if not actor.is_connected("died", died_callable):
			actor.connect("died", died_callable)
	if actor.has_signal("medically_died"):
		var medical_callable := Callable(self, "_on_actor_medically_died").bind(actor)
		if not actor.is_connected("medically_died", medical_callable):
			actor.connect("medically_died", medical_callable)
	var health_system = actor.get("health_system")
	if health_system and health_system.has_signal("medically_died"):
		var health_callable := Callable(self, "_on_actor_medically_died").bind(actor)
		if not health_system.is_connected("medically_died", health_callable):
			health_system.connect("medically_died", health_callable)
	return true

func unregister_actor(actor: Object) -> void:
	for index in range(_actors.size() - 1, -1, -1):
		if _actors[index].actor == actor:
			_actors.remove_at(index)

func get_match_state() -> int:
	return state

func get_objective_state() -> Dictionary:
	return {
		"state": objective_state,
		"progress": get_control_progress(),
		"progress_by_faction": _progress_by_faction.duplicate(),
		"control_faction": _control_faction,
		"remaining": maxf(config.objective_control_duration - get_control_progress(), 0.0),
	}

func get_result() -> Dictionary:
	return _result.duplicate(true)

func get_extraction_progress() -> float:
	var progress := 0.0
	for value in _extraction_progress.values():
		progress = maxf(progress, float(value))
	return progress

func get_actors() -> Array[Object]:
	var result: Array[Object] = []
	for record in _actors:
		if record.actor != null and is_instance_valid(record.actor):
			result.append(record.actor)
	return result

func get_control_progress() -> float:
	return float(_progress_by_faction.get(_control_faction, 0.0)) if _control_faction >= 0 else 0.0

func get_alive_count(faction: int = -1) -> int:
	var count := 0
	for record in _actors:
		if faction >= 0 and int(record.faction) != faction:
			continue
		if record.status == ACTOR_ALIVE and _actor_is_alive(record.actor):
			count += 1
	return count

func get_extracted_count(faction: int = -1) -> int:
	var count := 0
	for record in _actors:
		if faction >= 0 and int(record.faction) != faction:
			continue
		if record.status == ACTOR_EXTRACTED:
			count += 1
	return count

func tick(delta: float, objective_position: Vector3, extraction_position: Vector3) -> void:
	if state == MatchState.DEPLOYMENT:
		elapsed_time += delta
		if elapsed_time >= config.deployment_duration:
			_set_state(MatchState.ACTIVE)
		return
	if state == MatchState.ACTIVE:
		elapsed_time += delta
		remaining_time = maxf(config.match_duration - elapsed_time, 0.0)
		_refresh_actor_statuses()
		if get_alive_count(config.player_faction) <= 0:
			_finish(MatchState.MATCH_FAILED, "all_friendly_actors_lost")
			return
		_update_objective(delta, objective_position)
		if state == MatchState.ACTIVE and remaining_time <= 0.0:
			_open_extraction("time_expired")
			return
	if state == MatchState.EXTRACTION_OPEN:
		_refresh_actor_statuses()
		_update_extraction(delta, extraction_position)

func request_extraction(actor: Object = null) -> bool:
	if state != MatchState.EXTRACTION_OPEN:
		return false
	if actor == null:
		return true
	return _mark_extracted(actor)

func _update_objective(delta: float, objective_position: Vector3) -> void:
	var present: Dictionary = {}
	for record in _actors:
		if record.status != ACTOR_ALIVE or not _actor_is_alive(record.actor):
			continue
		if not _actor_has_position(record.actor):
			continue
		if (_actor_position(record.actor) - objective_position).length() <= config.objective_radius:
			present[record.faction] = int(present.get(record.faction, 0)) + 1
	var factions: Array = present.keys()
	if factions.size() > 1:
		_set_objective_state(ObjectiveState.CONTESTED)
		objective_progress_changed.emit(get_control_progress(), _control_faction, objective_state)
		return
	if factions.is_empty():
		if _control_faction >= 0 and get_alive_count(_control_faction) <= 0:
			_control_faction = -1
			_progress_by_faction.clear()
		_set_objective_state(_controlled_state())
		return
	var faction := int(factions[0])
	if _control_faction >= 0 and _control_faction != faction:
		if get_alive_count(_control_faction) <= 0:
			_progress_by_faction[_control_faction] = 0.0
		_control_faction = faction
		_progress_by_faction[faction] = 0.0
	else:
		_control_faction = faction
		_progress_by_faction[faction] = minf(
			float(_progress_by_faction.get(faction, 0.0)) + delta,
			config.objective_control_duration
		)
	_set_objective_state(ObjectiveState.RU_CONTROLLED if faction == 0 else ObjectiveState.UA_CONTROLLED)
	objective_progress_changed.emit(get_control_progress(), _control_faction, objective_state)
	if get_control_progress() >= config.objective_control_duration:
		_set_objective_state(ObjectiveState.SECURED)
		_set_state(MatchState.OBJECTIVE_SECURED)
		_open_extraction("objective_secured")

func _update_extraction(delta: float, extraction_position: Vector3) -> void:
	for record in _actors:
		if int(record.faction) != config.player_faction or record.status != ACTOR_ALIVE:
			continue
		var actor: Object = record.actor
		if not _actor_is_alive(actor):
			continue
		var in_zone := _actor_has_position(actor) and (_actor_position(actor) - extraction_position).length() <= config.extraction_radius
		var key := actor.get_instance_id()
		if in_zone:
			_extraction_progress[key] = float(_extraction_progress.get(key, 0.0)) + delta
			if float(_extraction_progress[key]) >= config.extraction_duration:
				_mark_extracted(actor)
		else:
			_extraction_progress.erase(key)
	if get_extracted_count(config.player_faction) > 0:
		_finish(MatchState.MATCH_SUCCESS if objective_state == ObjectiveState.SECURED else MatchState.MATCH_PARTIAL_SUCCESS, "extraction_complete")
	elif get_alive_count(config.player_faction) <= 0:
		_finish(MatchState.MATCH_FAILED, "all_friendly_actors_lost")

func _open_extraction(reason: String) -> void:
	if state == MatchState.EXTRACTION_OPEN or _is_finished():
		return
	extraction_reason = reason
	_set_state(MatchState.EXTRACTION_OPEN)
	extraction_opened.emit(reason)

func _mark_extracted(actor: Object) -> bool:
	for record in _actors:
		if record.actor != actor or record.status != ACTOR_ALIVE:
			continue
		if not _actor_is_alive(actor):
			return false
		record.status = ACTOR_EXTRACTED
		_extraction_progress.erase(actor.get_instance_id())
		actor_status_changed.emit(actor, ACTOR_EXTRACTED)
		return true
	return false

func _refresh_actor_statuses() -> void:
	for record in _actors:
		if record.status == ACTOR_ALIVE and not _actor_is_alive(record.actor):
			record.status = ACTOR_DOWN
			actor_status_changed.emit(record.actor, ACTOR_DOWN)

func _on_actor_died(actor: Object) -> void:
	_set_actor_down(actor)

func _on_actor_medically_died(_death_type, _direction, actor: Object) -> void:
	_set_actor_down(actor)

func _set_actor_down(actor: Object) -> void:
	for record in _actors:
		if record.actor == actor and record.status == ACTOR_ALIVE:
			record.status = ACTOR_DOWN
			actor_status_changed.emit(actor, ACTOR_DOWN)

func _controlled_state() -> ObjectiveState:
	if _control_faction == 0:
		return ObjectiveState.RU_CONTROLLED
	if _control_faction == 1:
		return ObjectiveState.UA_CONTROLLED
	return ObjectiveState.UNCONTROLLED

func _set_objective_state(new_state: ObjectiveState) -> void:
	if objective_state == new_state:
		return
	objective_state = new_state
	objective_progress_changed.emit(get_control_progress(), _control_faction, objective_state)

func _set_state(new_state: MatchState) -> void:
	if state == new_state:
		return
	state = new_state
	match_state_changed.emit(state)

func _finish(final_state: MatchState, reason: String) -> void:
	if _is_finished():
		return
	_set_state(final_state)
	_result = {
		"state": final_state,
		"reason": reason,
		"objective_secured": objective_state == ObjectiveState.SECURED,
		"extracted": get_extracted_count(config.player_faction),
		"survivors": get_alive_count(config.player_faction),
		"elapsed": elapsed_time,
	}
	match_finished.emit(_result.duplicate(true))

func _is_finished() -> bool:
	return state >= MatchState.MATCH_SUCCESS

func _actor_is_alive(actor: Object) -> bool:
	if actor == null or not is_instance_valid(actor):
		return false
	var alive = actor.get("is_alive")
	if alive != null:
		return bool(alive)
	return bool(actor.get_meta("encounter_alive", true))

func _actor_has_position(actor: Object) -> bool:
	return actor is Node3D or actor.has_method("get_encounter_position")

func _actor_position(actor: Object) -> Vector3:
	if actor.has_method("get_encounter_position"):
		return actor.get_encounter_position()
	return (actor as Node3D).global_position
