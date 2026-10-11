@tool
extends BTAction

## 停下并排除武器故障。故障清除后返回 SUCCESS。
## Stops and works the weapon's malfunction clearance; SUCCESS once cleared.


func _generate_name() -> String:
	return "Clear Malfunction"


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
	if not brain.weapon_has_malfunction():
		return SUCCESS
	brain.clear_malfunction()
	return RUNNING
