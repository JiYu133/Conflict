class_name PlayerConfig
extends Resource

## 玩家的基本参数

## 移动参数
@export_group("移动参数")
@export var walk_speed: float = 2.0 ## 行走速度
@export var run_speed: float = 4.0 ## 奔跑速度
@export var jump_force: float = 3.7 ## 跳跃时垂直方向的力
@export var gravity: float = 9.8 ## 重力加速度
@export var acceleration: float = 9.5 ## 地面加速度（米/秒²）
@export var deceleration: float = 20.0 ## 地面减速度
@export var air_acceleration: float = 1.0 ## 空中加速度（通常较低）
@export var air_deceleration: float = 2.0 ## 空中减速度

## 模型配置
@export_group("模型")
@export var model_scene: PackedScene
@export var model_config: ModelLookupConfig
@export var collision_shape_height: float = 1.8
@export var collision_shape_radius: float = 0.4
## 摄像机配置
@export_group("摄像机")
@export var fov: float = 90.0
@export var mouse_sensitivity: float = 0.003 ## 鼠标灵敏度
@export var max_vertical_angle: float = 1.4 ## 上下限制（约 80 度）
## 武器配置
@export_group("武器配置")
@export var starting_weapon:WeaponConfig ## 初始武器
