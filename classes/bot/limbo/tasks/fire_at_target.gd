@tool
extends BTAction

## 开火：只在瞄准任务报告已对准时，按 AIProfile 的点射节奏扣真实武器的扳机。
## 不生成子弹、不计算伤害——射击模式、射速、弹药和故障都由武器本身决定。
## Pulls the real trigger in bursts while ready_var is true. Always RUNNING.

@export var profile_context: StringName = &"combat"
## Input written by AimAtTarget.
@export var ready_var: StringName = &"aim_ready"
## Crouch when the profile's crouch_in_combat is on.
@export var crouch_in_combat: bool = true

var _cooldown := 0.0
var _release_timer := 0.0


func _generate_name() -> String:
	return "Fire When %s (%s)" % [LimboUtility.decorate_var(ready_var), profile_context]


func _enter() -> void:
	_cooldown = 0.0
	_release_timer = 0.0
	var brain := AIBT.brain_of(agent)
	if brain:
		brain.set_stance(crouch_in_combat and brain.get_profile(profile_context).crouch_in_combat)


func _tick(delta: float) -> Status:
	var brain := AIBT.brain_of(agent)
	if not brain:
		return FAILURE
	_cooldown = maxf(_cooldown - delta, 0.0)
	_release_timer = maxf(_release_timer - delta, 0.0)
	if not blackboard.get_var(ready_var, false, false):
		brain.release_trigger()
		return RUNNING
	if _release_timer <= 0.0:
		brain.release_trigger()
	if _cooldown > 0.0:
		return RUNNING
	var profile := brain.get_profile(profile_context)
	brain.pull_trigger()
	if brain.active_aim:
		brain.active_aim.on_shot_fired(brain)
	_cooldown = profile.fire_interval
	_release_timer = minf(profile.fire_interval * 0.8, maxf(0.08, float(profile.burst_length) * 0.1))
	return RUNNING


func _exit() -> void:
	var brain := AIBT.brain_of(agent)
	if brain:
		brain.release_weapon()
