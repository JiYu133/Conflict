class_name PlayerConfig
extends Resource

## 玩家的基本参数

## 移动参数
@export_group("Movement")
@export var walk_speed: float = 2.0 ## 行走速度
@export var run_speed: float = 4.0 ## 奔跑速度
@export var jump_force: float = 2.0 ## 跳跃时垂直方向的力
@export var gravity: float = 9.8 ## 重力加速度
@export var deceleration_multiplier: float = 20.0 ## 减速系数 (决定玩家减速的惯性大小)

## 模型配置
@export_group("Model")
@export var model_scene: PackedScene
@export var model_config: ModelLookupConfig

## 摄像机配置
@export_group("Camera")
@export var fov: float = 90.0
@export var mouse_sensitivity: float = 0.003 ## 鼠标灵敏度
@export var max_vertical_angle: float = 1.4 ## 上下限制（约 80 度）
