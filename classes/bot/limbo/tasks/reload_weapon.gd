@tool
extends BTAction

## 停下并换弹（走玩家同一套换弹接口）。弹量恢复后返回 SUCCESS。
## Stops and reloads through the player's reload path; SUCCESS once topped up.


func _generate_name() -> String:
	return "Reload Weapon"


func _enter() -> void:
	var brain := AIBT.brain_of(agent)
	if brain:
		brain.activity = get_task_name()
		brain.stop()
		brain.release_weapon()
		brain.set_stance(false)


func _tick(_delta: float) -> Status:
	var brain := AIBT.brain_of(agent)
	if not brain:
		return FAILURE
	brain.stop()
	if not brain.weapon_needs_reload():
		return SUCCESS
	brain.reload_weapon()
	return RUNNING
