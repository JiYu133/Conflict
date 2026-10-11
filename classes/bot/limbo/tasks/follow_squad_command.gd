@tool
extends BTAction

## 执行玩家下达给小队的命令（跟随 / 去任务点 / 推进 / 进攻 / 原地待命 / 后撤）。
## 没有命令时返回 FAILURE，否则一直 RUNNING。
## Carries out the squad command on the AIBlackboard. FAILURE when none is set.


func _generate_name() -> String:
	return "Follow Squad Command"


func _enter() -> void:
	var brain := AIBT.brain_of(agent)
	if brain:
		brain.activity = get_task_name()
		brain.set_stance(false)


func _tick(delta: float) -> Status:
	var brain := AIBT.brain_of(agent)
	if not brain or not brain.squad:
		return FAILURE
	var info := brain.squad.blackboard
	var source := info.command_source if is_instance_valid(info.command_source) else null
	match info.squad_command:
		AIBlackboard.SquadCommand.FOLLOW_PLAYER:
			var destination := source.global_position if source else brain.squad.objective_position
			brain.move_to(destination, brain.default_profile, delta)
		AIBlackboard.SquadCommand.MOVE_TO_OBJECTIVE:
			brain.move_to(brain.squad.objective_position, brain.default_profile, delta, true)
		AIBlackboard.SquadCommand.ADVANCE, AIBlackboard.SquadCommand.ATTACK:
			brain.move_to(info.command_position, brain.combat_profile, delta, true)
		AIBlackboard.SquadCommand.HOLD:
			brain.stop()
			if brain.target and is_instance_valid(brain.target):
				brain.face(brain.target.global_position)
		AIBlackboard.SquadCommand.FALL_BACK:
			var destination := source.global_position if source else brain.squad.extraction_position
			brain.move_to(destination, brain.retreat_profile, delta, true)
		_:
			return FAILURE
	return RUNNING


func _exit() -> void:
	var brain := AIBT.brain_of(agent)
	if brain:
		brain.stop()
