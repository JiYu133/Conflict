@tool
extends BTAction

## 感知：刷新目标与视线，并把世界状态写进黑板。放在根节点第一个，每帧都执行。
## Runs perception and publishes the world state to the blackboard. Keep it as
## the first child of the root so every later task reads fresh variables.
## Variable list: AIPlayerBrain "BLACKBOARD VARIABLES".


func _generate_name() -> String:
	return "Sense Environment"


func _tick(delta: float) -> Status:
	var brain := AIBT.brain_of(agent)
	if not brain:
		return FAILURE
	brain.update_perception(delta)
	brain.write_blackboard(blackboard)
	return SUCCESS
