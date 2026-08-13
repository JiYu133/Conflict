class_name EncounterController
extends Node

signal match_state_changed(state: int)
signal objective_progress_changed(progress: float, control_faction: int, objective_state: int)
signal actor_status_changed(actor: Object, status: String)
signal extraction_opened(reason: String)
signal match_finished(result: Dictionary)

@export var config: EncounterConfig
@export var objective_position: Vector3 = Vector3.ZERO
@export var extraction_position: Vector3 = Vector3(-18.0, 0.0, -16.0)

var rules: EncounterRules
var objective_zone: EncounterZone
var extraction_zone: EncounterZone

func _ready() -> void:
	if not config:
		config = EncounterConfig.new()
	rules = EncounterRules.new(config)
	rules.match_state_changed.connect(func(value): match_state_changed.emit(value))
	rules.objective_progress_changed.connect(func(progress, faction, value): objective_progress_changed.emit(progress, faction, value))
	rules.actor_status_changed.connect(func(actor, status): actor_status_changed.emit(actor, status))
	rules.extraction_opened.connect(func(reason): extraction_opened.emit(reason))
	rules.match_finished.connect(func(result): match_finished.emit(result))
	_create_zones()

func start_match() -> void:
	rules.start_match()

func register_actor(actor: Object, faction: int) -> bool:
	return rules.register_actor(actor, faction)

func get_match_state() -> int:
	return rules.get_match_state()

func get_objective_state() -> Dictionary:
	return rules.get_objective_state()

func request_extraction(actor: Object = null) -> bool:
	return rules.request_extraction(actor)

func get_result() -> Dictionary:
	return rules.get_result()

func get_extraction_progress() -> float:
	return rules.get_extraction_progress()

func get_actors() -> Array[Object]:
	return rules.get_actors()

func _physics_process(delta: float) -> void:
	if rules:
		rules.tick(delta, objective_position, extraction_position)

func _create_zones() -> void:
	objective_zone = EncounterZone.new()
	objective_zone.name = "ObjectiveZone"
	objective_zone.position = objective_position
	objective_zone.set_radius(config.objective_radius)
	add_child(objective_zone)
	extraction_zone = EncounterZone.new()
	extraction_zone.name = "ExtractionZone"
	extraction_zone.position = extraction_position
	extraction_zone.set_radius(config.extraction_radius)
	add_child(extraction_zone)
