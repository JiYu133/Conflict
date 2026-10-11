@tool
class_name AIAimProvider
extends Resource

## 瞄准接口 —— 行为树里 "Aim At Target" 任务的可替换瞄准逻辑。
## Aiming slot of the AI behaviour tree (task: limbo/tasks/aim_at_target.gd).
##
## 接入方式 / How to plug in your own aim:
##   1. 新建脚本 `class_name MyAim extends AIAimProvider`，重写 update_aim()。
##   2. 在 LimboAI 编辑器里选中 "Aim At Target" 任务，把 aim_provider 换成 MyAim。
##   FireAtTarget 只在 update_aim() 返回 true 时扣扳机。
##
## The task duplicates this resource once per AIPlayer, so instance variables
## are safe to use as per-bot state. Steer only through brain.aim_at_direction();
## never write velocity, spawn bullets or touch damage from here.


## 开始瞄准某个目标时调用（含中途换目标）。
## Called when the task starts aiming at a target, including target switches.
func begin_aim(_brain: AIPlayerBrain, _target: BasePlayer) -> void:
	pass


## 每个物理帧调用。用 brain.aim_at_direction() 转动视角；
## 准星对准、可以开火时返回 true。
## Called every physics tick while aiming. Return true once the shot is lined up.
func update_aim(_brain: AIPlayerBrain, _target: BasePlayer, _profile: AIProfile, _delta: float) -> bool:
	return false


## AI 每次扣下扳机后调用（例如重新随机瞄准误差）。
## Called right after the AI pulls the trigger.
func on_shot_fired(_brain: AIPlayerBrain) -> void:
	pass


## 停止瞄准时调用（目标丢失、分支被打断）。
## Called when the task stops (target lost, branch aborted).
func end_aim(_brain: AIPlayerBrain) -> void:
	pass
