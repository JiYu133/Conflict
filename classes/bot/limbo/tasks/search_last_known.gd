@tool
extends BTAction

## 搜索：前往敌人最后已知位置，超过 AIProfile.search_duration 后放弃并遗忘敌人。
## Moves to the last known enemy position; after search_duration it forgets the
## enemy and returns SUCCESS.

@export var position_var: StringName = &"last_known_enemy_position"
@export var profile_context: StringName = &"combat"

var _elapsed := 0.0


func _generate_name() -> String:
	return "Search %s (%s)" % [LimboUtility.decorate_var(position_var), profile_context]


func _enter() -> void:
	_elapsed = 0.0
	var brain := AIBT.brain_of(agent)
	if brain:
		brain.activity = get_task_name()
		brain.set_stance(false)


func _tick(delta: float) -> Status:
	var brain := AIBT.brain_of(agent)
	if not brain:
		return FAILURE
	var profile := brain.get_profile(profile_context)
	_elapsed += delta
	if _elapsed >= profile.search_duration:
		brain.forget_enemy()
		return SUCCESS
	var position: Variant = AIBT.get_position(blackboard, position_var)
	if position != null and position != Vector3.ZERO:
		brain.move_to(position, profile, delta)
	else:
		brain.stop()
	return RUNNING


func _exit() -> void:
	var brain := AIBT.brain_of(agent)
	if brain:
		brain.stop()
