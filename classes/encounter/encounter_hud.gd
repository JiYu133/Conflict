class_name EncounterHUD
extends CanvasLayer

var controller: EncounterController
var label: Label
var result_label: Label

func initialize(new_controller: EncounterController, _new_player: BasePlayer) -> void:
	controller = new_controller
	_build_ui()
	controller.match_finished.connect(_on_match_finished)

func _process(_delta: float) -> void:
	if not controller or not label:
		return
	var objective := controller.get_objective_state()
	var state_name: String = String(EncounterRules.MatchState.keys()[controller.get_match_state()])
	var faction_name := "None"
	if int(objective.control_faction) == BasePlayer.Faction.RU:
		faction_name = "RU"
	elif int(objective.control_faction) == BasePlayer.Faction.UA:
		faction_name = "UA"
	var remaining := maxf(controller.config.match_duration - controller.rules.elapsed_time, 0.0)
	var extraction_name: String = "OPEN %.0f / %.0f sec" % [controller.get_extraction_progress(), controller.config.extraction_duration] if controller.get_match_state() == EncounterRules.MatchState.EXTRACTION_OPEN else "CLOSED"
	label.text = "ENCOUNTER | %s\nOBJECTIVE: %s %.0f / %.0f sec\nCONTROL: %s\nTIME: %s\nEXTRACTION: %s" % [
		state_name, EncounterRules.ObjectiveState.keys()[int(objective.state)],
		float(objective.progress), controller.config.objective_control_duration,
		faction_name, _format_time(remaining), extraction_name,
	]

func _build_ui() -> void:
	layer = 20
	var panel := ColorRect.new()
	panel.position = Vector2(24.0, 24.0)
	panel.size = Vector2(330.0, 150.0)
	panel.color = Color(0.02, 0.03, 0.04, 0.78)
	add_child(panel)
	label = Label.new()
	label.position = Vector2(14.0, 10.0)
	label.add_theme_font_size_override("font_size", 16)
	panel.add_child(label)
	result_label = Label.new()
	result_label.position = Vector2(24.0, 190.0)
	result_label.add_theme_font_size_override("font_size", 26)
	add_child(result_label)

func _on_match_finished(result: Dictionary) -> void:
	var state: int = int(result.get("state", EncounterRules.MatchState.MATCH_FAILED))
	result_label.text = "RESULT: %s\nEXTRACTED: %d" % [String(EncounterRules.MatchState.keys()[state]), int(result.get("extracted", 0))]

func _format_time(value: float) -> String:
	return "%02d:%02d" % [int(value) / 60, int(value) % 60]
