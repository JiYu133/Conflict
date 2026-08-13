class_name EncounterAIDirector
extends Node

var controller: EncounterController
var config: EncounterConfig
var navigation_service: AINavigationService
var squads: Dictionary = {}
var brains: Dictionary = {}
var _now := 0.0

func initialize(new_controller: EncounterController) -> void:
	controller = new_controller
	config = controller.config
	_now = Time.get_ticks_msec() / 1000.0
	navigation_service = AINavigationService.new()
	navigation_service.name = "AINavigationService"
	add_child(navigation_service)
	controller.match_state_changed.connect(_on_match_state_changed)
	controller.extraction_opened.connect(_on_extraction_opened)
	controller.objective_progress_changed.connect(_on_objective_progress)
	for actor in controller.get_actors():
		_register_actor(actor)


func _ready() -> void:
	# EncounterPrototype calls initialize after add_child; all setup is deferred
	# there so actors have completed BasePlayer subsystem initialization.
	pass

func _physics_process(delta: float) -> void:
	if not controller:
		return
	_now += delta
	for faction in squads.keys():
		var squad: AISquadCommander = squads[faction]
		var profile := _profile_for_faction(int(faction))
		squad.tick(delta, _now, profile)
	for key in brains.keys():
		var brain: AIPlayerBrain = brains[key]
		if is_instance_valid(brain):
			if controller.get_match_state() >= EncounterRules.MatchState.MATCH_SUCCESS:
				brain.shutdown()
				brain.set_ai_active(false)


func _register_actor(actor: Object) -> void:
	if not actor is AIPlayer or not (actor as AIPlayer).is_ai_player:
		return
	var ai_player := actor as AIPlayer
	var faction := int(ai_player.faction)
	var squad: AISquadCommander = squads.get(faction, null)
	if not squad:
		squad = AISquadCommander.new()
		squad.initialize(faction, controller.objective_position, controller.extraction_position)
		squads[faction] = squad
	squad.add_member(ai_player)
	var brain := AIPlayerBrain.new()
	brain.name = "AIPlayerBrain_%d" % ai_player.ai_player_id
	add_child(brain)
	var manager := ai_player.get_parent() as AIPlayerManager
	brain.initialize(ai_player, squad, navigation_service, ai_player.ai_config)
	if not ai_player.ai_config:
		brain.apply_profile(_profile_for_faction(faction))
	brains[ai_player.get_instance_id()] = brain
	if manager:
		manager.register_brain(ai_player, brain)


func _profile_for_faction(faction: int) -> AIProfile:
	var fallback := AIProfile.new()
	return fallback


func _on_match_state_changed(_state: int) -> void:
	if not controller:
		return
	if controller.get_match_state() == EncounterRules.MatchState.EXTRACTION_OPEN:
		_on_extraction_opened("match_state")


func _on_extraction_opened(reason: String) -> void:
	for squad in squads.values():
		var commander: AISquadCommander = squad
		commander.blackboard.issue_retreat(reason, commander.extraction_position, commander.leader, _now)


func publish_objective_status(objective_state: int) -> void:
	for squad in squads.values():
		(squad as AISquadCommander).blackboard.publish_objective_status(objective_state, _now)


func issue_player_command(command: AIBlackboard.SquadCommand, player: BasePlayer) -> bool:
	if not player:
		return false
	var squad: AISquadCommander = squads.get(int(player.faction), null)
	if not squad:
		return false
	squad.issue_player_command(command, player, _now)
	return true


func _on_objective_progress(_progress: float, _faction: int, objective_state: int) -> void:
	publish_objective_status(objective_state)
