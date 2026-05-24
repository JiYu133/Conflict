class_name PlayerConfig
extends Resource

## 玩家的基本参数

## 移动参数
@export_group("Movement")
@export var walk_speed: float = 5.0
@export var run_speed: float = 8.0
@export var jump_force: float = 10.0
@export var gravity: float = 9.8

## 模型配置
@export_group("Model")
@export var model_scene: PackedScene
@export var model_config: ModelLookupConfig

## 摄像机配置
@export_group("Camera")
@export var fov: float = 90.0
@export var mouse_sensitivity: float = 0.1
