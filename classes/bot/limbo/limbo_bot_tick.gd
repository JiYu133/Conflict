extends BTAction

## LimboAI adapter for the project-specific tactical brain.
## LimboAI owns scheduling, cancellation and execution state; AIPlayerBrain owns
## the domain actions that operate the real player and weapon systems.

func _tick(delta: float) -> Status:
	if not agent or not is_instance_valid(agent):
		return FAILURE
	var brain := agent.get_meta("ai_player_brain", null) as AIPlayerBrain
	if not brain or not is_instance_valid(brain):
		return FAILURE
	brain.tick_ai(delta)
	return RUNNING
