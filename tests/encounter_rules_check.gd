extends SceneTree

class DummyActor extends Node3D:
	var is_alive := true
	var faction := 0

	func die() -> void:
		is_alive = false
		died.emit()

	signal died

func _init() -> void:
	var cfg := EncounterConfig.new()
	cfg.match_duration = 10.0
	cfg.objective_control_duration = 3.0
	cfg.extraction_duration = 2.0
	cfg.objective_radius = 5.0
	cfg.extraction_radius = 5.0
	var rules := EncounterRules.new(cfg)
	var ru := DummyActor.new()
	ru.position = Vector3.ZERO
	var ua := DummyActor.new()
	ua.position = Vector3(20.0, 0.0, 0.0)
	get_root().add_child(ru)
	get_root().add_child(ua)
	rules.register_actor(ru, BasePlayer.Faction.RU)
	rules.register_actor(ua, BasePlayer.Faction.UA)
	rules.start_match()
	_check(rules.get_match_state() == EncounterRules.MatchState.ACTIVE, "match starts active")
	rules.tick(1.0, Vector3.ZERO, Vector3(50.0, 0.0, 0.0))
	_check(is_equal_approx(rules.get_control_progress(), 1.0), "single faction controls objective")
	ua.position = Vector3.ZERO
	rules.tick(1.0, Vector3.ZERO, Vector3(50.0, 0.0, 0.0))
	_check(int(rules.get_objective_state()["state"]) == EncounterRules.ObjectiveState.CONTESTED, "contested objective pauses progress")
	ua.position = Vector3(20.0, 0.0, 0.0)
	rules.tick(2.0, Vector3.ZERO, Vector3(50.0, 0.0, 0.0))
	_check(rules.get_match_state() == EncounterRules.MatchState.EXTRACTION_OPEN, "objective opens extraction")
	ru.position = Vector3(50.0, 0.0, 0.0)
	rules.tick(1.0, Vector3.ZERO, Vector3(50.0, 0.0, 0.0))
	_check(rules.get_result().is_empty(), "extraction requires continuous presence")
	rules.tick(1.0, Vector3.ZERO, Vector3(50.0, 0.0, 0.0))
	_check(rules.get_match_state() == EncounterRules.MatchState.MATCH_SUCCESS, "successful extraction settles match")
	_check(int(rules.get_result()["extracted"]) == 1, "one friendly actor extracted")

	var failure := EncounterRules.new(cfg)
	var lone := DummyActor.new()
	get_root().add_child(lone)
	failure.register_actor(lone, BasePlayer.Faction.RU)
	failure.start_match()
	lone.die()
	failure.tick(0.1, Vector3.ZERO, Vector3.ZERO)
	_check(failure.get_match_state() == EncounterRules.MatchState.MATCH_FAILED, "all friendly actors lost fails immediately")

	var timeout_cfg := EncounterConfig.new()
	timeout_cfg.match_duration = 1.0
	timeout_cfg.extraction_duration = 1.0
	var timeout_rules := EncounterRules.new(timeout_cfg)
	var timeout_actor := DummyActor.new()
	get_root().add_child(timeout_actor)
	timeout_rules.register_actor(timeout_actor, BasePlayer.Faction.RU)
	timeout_rules.start_match()
	timeout_rules.tick(1.1, Vector3(100.0, 0.0, 0.0), Vector3.ZERO)
	_check(timeout_rules.get_match_state() == EncounterRules.MatchState.EXTRACTION_OPEN, "timeout opens extraction")
	timeout_rules.tick(1.0, Vector3(100.0, 0.0, 0.0), Vector3.ZERO)
	_check(timeout_rules.get_match_state() == EncounterRules.MatchState.MATCH_PARTIAL_SUCCESS, "timeout extraction is partial success")
	_check(MedicalTreatmentComponent.can_treat_self(MedicalEnums.TreatmentType.BANDAGE), "bandage supports self treatment")
	_check(not MedicalTreatmentComponent.can_treat_self(MedicalEnums.TreatmentType.WOUND_PACKING), "wound packing is not self treatment")
	print("encounter_rules_check=ok")
	quit(0)

func _check(condition: bool, message: String) -> void:
	if not condition:
		push_error(message)
		quit(1)
