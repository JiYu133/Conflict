class_name AIBT
extends RefCounted

## Shared helpers for the AI behaviour tree tasks in classes/bot/limbo/tasks.


## The AIPlayerBrain that drives this agent, or null when it is gone.
static func brain_of(agent: Node) -> AIPlayerBrain:
	if not agent or not is_instance_valid(agent):
		return null
	var brain: Object = agent.get_meta(&"ai_player_brain", null)
	return brain as AIPlayerBrain if is_instance_valid(brain) else null


## A Vector3 blackboard variable, or null when it is unset or not a Vector3.
static func get_position(blackboard: Blackboard, var_name: StringName) -> Variant:
	var value: Variant = blackboard.get_var(var_name, null, false)
	return value if value is Vector3 else null
