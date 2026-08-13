extends SceneTree

## Resource-level regression check. It intentionally does not instantiate a
## scene or touch medical treatment: AI configuration and information sharing
## remain independently testable while rescue behaviour is out of scope.
func _init() -> void:
	var profile := load("res://assets/config/ai/profiles/ai_default_profile.tres") as AIProfile
	_check(profile != null, "default AI profile loads")
	_check(profile.perception_distance > 0.0, "profile exposes perception distance")
	_check(profile.weapon_distance > 0.0, "profile exposes weapon distance")
	_check(profile.retreat_casualty_ratio == 0.5, "profile exposes retreat casualty threshold")

	var friendly := load("res://assets/config/ai/ai_friendly_regular.tres") as AIConfig
	var enemy := load("res://assets/config/ai/ai_enemy_regular.tres") as AIConfig
	_check(friendly != null and enemy != null, "faction AI configs load")
	_check(friendly.get_profile("combat").aggression < enemy.get_profile("combat").aggression, "factions select different combat profiles")

	var board := AIBlackboard.new()
	board.publish_enemy_spotted(null, null, Vector3(3.0, 0.0, 4.0), 1.0, 10.0)
	_check(board.has_fresh_enemy(12.0, 5.0), "fresh enemy information is accepted")
	_check(not board.has_fresh_enemy(20.0, 5.0), "stale enemy information expires")
	board.issue_retreat("timeout", Vector3(8.0, 0.0, 8.0))
	_check(board.retreat_order and board.retreat_reason == "timeout", "retreat order is shared")
	print("bot_ai_config_check=ok")
	quit(0)


func _check(condition: bool, message: String) -> void:
	if not condition:
		push_error(message)
		quit(1)
