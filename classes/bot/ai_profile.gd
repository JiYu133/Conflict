class_name AIProfile
extends Resource

## A complete set of tunable AIPlayer behaviour parameters. Keep these as resources
## so encounter designers can swap behaviour without changing code.

@export_group("Perception")
## AIPlayer 能发现目标的最大距离。
@export var perception_distance: float = 32.0
## 水平视野角度；180 表示前方半圆，360 表示全向。
@export_range(1.0, 360.0) var field_of_view_degrees: float = 120.0
## 两次视线扫描之间的间隔，越小反应越快但开销越高。
@export var sight_check_interval: float = 0.20
## 失去视线后继续记忆敌人的时间。
@export var target_memory_time: float = 5.0
## 发现敌人后的反应延迟。
@export var reaction_time: float = 0.25
## 进攻倾向，0 为保守，1 为激进。
@export_range(0.0, 1.0) var aggression: float = 0.65

@export_group("Movement")
## 旧版速度调参，仅用于旧逻辑兼容；AIPlayer 的实际速度由 PlayerConfig 决定。
@export var move_speed: float = 3.5
## AIPlayer 追击敌人的最大距离。
@export var chase_distance: float = 30.0
## 距离任务点达到该值后返回任务区或开始巡逻。
@export var return_to_objective_distance: float = 4.0
## 距离目标点小于该值时视为到达。
@export var arrival_distance: float = 1.25
## 导航路径重新计算的间隔。
@export var replan_interval: float = 0.35
## 局部射线避障和导航邻居检测距离。
@export var local_avoidance_distance: float = 1.5
## 前往任务点和推进时是否向玩家移动系统提交跑步输入。
@export var run_to_objective: bool = true
## 撤退时是否向玩家移动系统提交冲刺输入；仍受耐力和姿态限制。
@export var sprint_when_retreating: bool = true
## 进入交战和压制状态时是否使用玩家姿态系统蹲下。
@export var crouch_in_combat: bool = false
## 在任务点驻守时是否使用玩家姿态系统蹲下。
@export var crouch_while_holding: bool = false
@export_group("Fire Control")
## 有效开火距离。
@export var weapon_distance: float = 22.0
## AI 瞄准误差角度；数值越小越准。
@export_range(0.0, 45.0) var aim_error_degrees: float = 3.0
## 期望点射长度；实际射击模式和弹药由真实武器决定。
@export var burst_length: int = 3
## AI 两次提交扳机输入之间的间隔。
@export var fire_interval: float = 0.65
## 弹匣低于该比例且有备弹时进入换弹。
@export_range(0.0, 1.0) var minimum_ammo_ratio: float = 0.20

@export_group("Team Tactics")
## 掩护任务持续时间。
@export var suppression_duration: float = 4.0
## 同时承担压制任务的 AIPlayer 数量。
@export var suppression_count: int = 1
## 搜索最后已知敌人位置的最长时间。
@export var search_duration: float = 5.0
## 阵营伤亡比例达到该值后允许撤退。
@export_range(0.0, 1.0) var retreat_casualty_ratio: float = 0.50
## 可战斗成员弹药低于该比例时允许撤退。
@export_range(0.0, 1.0) var retreat_ammo_ratio: float = 0.20
## Blackboard 敌情超过该时间后视为过期。
@export var blackboard_stale_time: float = 5.0
## 阵营信息广播的最大距离。
@export var broadcast_radius: float = 45.0
## 队长死亡后的选举规则。
@export var leader_replacement_rule: String = "nearest_objective"

@export_group("Debug")
## 是否显示该 AIPlayer 的调试状态信息。
@export var show_debug_state: bool = false


func sanitized() -> AIProfile:
	var result := duplicate(true) as AIProfile
	result.perception_distance = maxf(result.perception_distance, 1.0)
	result.sight_check_interval = maxf(result.sight_check_interval, 0.05)
	result.target_memory_time = maxf(result.target_memory_time, 0.0)
	result.move_speed = maxf(result.move_speed, 0.0)
	result.arrival_distance = maxf(result.arrival_distance, 0.1)
	result.replan_interval = maxf(result.replan_interval, 0.05)
	result.burst_length = maxi(result.burst_length, 1)
	result.fire_interval = maxf(result.fire_interval, 0.05)
	result.suppression_count = maxi(result.suppression_count, 1)
	return result
