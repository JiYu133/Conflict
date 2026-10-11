@tool
extends BTAction

## 瞄准接口所在的任务：通过可替换的 AIAimProvider 瞄准目标，并把
## "是否已对准" 写进黑板（默认 aim_ready）。目标消失时返回 FAILURE，否则一直 RUNNING。
## 换成自己的瞄准：给 aim_provider 指定一个 AIAimProvider 子类资源即可。
## Aims through a pluggable AIAimProvider and publishes whether the shot is
## lined up. Pair it with FireAtTarget under a BTParallel.

## 留空则使用 AISimpleAim。Empty means AISimpleAim.
@export var aim_provider: AIAimProvider
@export var profile_context: StringName = &"combat"
@export var target_var: StringName = &"target"
## Output: true while the provider reports the shot is lined up.
@export var ready_var: StringName = &"aim_ready"

var _aim: AIAimProvider
var _aiming_at: BasePlayer


func _generate_name() -> String:
	var provider := "AISimpleAim"
	if aim_provider and aim_provider.get_script():
		provider = (aim_provider.get_script() as Script).resource_path.get_file().get_basename()
	return "Aim At %s [%s]" % [LimboUtility.decorate_var(target_var), provider]


func _setup() -> void:
	_aim = aim_provider.duplicate() if aim_provider else AISimpleAim.new()


func _enter() -> void:
	_aiming_at = null
	var brain := AIBT.brain_of(agent)
	if brain:
		brain.activity = get_task_name()


func _tick(delta: float) -> Status:
	var brain := AIBT.brain_of(agent)
	var target := blackboard.get_var(target_var, null, false) as BasePlayer
	if not brain or not is_instance_valid(target):
		blackboard.set_var(ready_var, false)
		return FAILURE
	if target != _aiming_at:
		_aiming_at = target
		_aim.begin_aim(brain, target)
	brain.active_aim = _aim
	var ready := _aim.update_aim(brain, target, brain.get_profile(profile_context), delta)
	blackboard.set_var(ready_var, ready)
	return RUNNING


func _exit() -> void:
	blackboard.set_var(ready_var, false)
	var brain := AIBT.brain_of(agent)
	if _aiming_at and brain:
		_aim.end_aim(brain)
		if brain.active_aim == _aim:
			brain.active_aim = null
	_aiming_at = null
