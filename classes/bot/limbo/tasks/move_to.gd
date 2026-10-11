@tool
extends BTAction

## 移动到黑板里的某个位置（走玩家同一套移动系统）。到达返回 SUCCESS。
## Walks to a Vector3 blackboard variable through the player's own locomotion.
## RUNNING while travelling, SUCCESS on arrival, FAILURE if the variable is unset.

@export var destination_var: StringName = &"objective_position"
## Which AIProfile to use: calm / combat / suppress / retreat.
@export var profile_context: StringName = &"calm"
## Requests running; honoured only when the profile's run_to_objective is on.
@export var run: bool = false
## Requests sprinting; honoured only when the profile's sprint_when_retreating is on.
@export var sprint: bool = false
## Release the weapon while moving (retreats).
@export var release_weapon: bool = false


func _generate_name() -> String:
	return "Move To %s (%s)" % [LimboUtility.decorate_var(destination_var), profile_context]


func _enter() -> void:
	var brain := AIBT.brain_of(agent)
	if brain:
		brain.activity = get_task_name()
		brain.set_stance(false)
		if release_weapon:
			brain.release_weapon()


func _tick(delta: float) -> Status:
	var brain := AIBT.brain_of(agent)
	var destination: Variant = AIBT.get_position(blackboard, destination_var)
	if not brain or destination == null:
		return FAILURE
	var arrived := brain.move_to(destination, brain.get_profile(profile_context), delta, run, sprint)
	return SUCCESS if arrived else RUNNING


func _exit() -> void:
	var brain := AIBT.brain_of(agent)
	if brain:
		brain.stop()
