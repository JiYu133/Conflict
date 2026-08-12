class_name SpineAimConfig
extends Resource

## 将视角俯仰分摊到这些脊柱骨骼。名称不存在的骨骼会被自动跳过。
@export var bone_names: Array[String] = [
	"mixamorig_Spine",
	"mixamorig_Spine1",
	"mixamorig_Spine2",
]

## 与 bone_names 一一对应，运行时会自动归一化。
@export var bone_weights: Array[float] = [0.2, 0.35, 0.45]

## 抬头和低头的最大角度。
@export_range(0.0, 89.0, 0.5) var max_look_up_degrees: float = 55.0
@export_range(0.0, 89.0, 0.5) var max_look_down_degrees: float = 45.0

## 脊柱追随视角的速度；越大响应越快。
@export_range(0.0, 30.0, 0.1) var response_speed: float = 14.0

## 总体旋转强度。用于保留一部分原始动画姿态。
@export_range(0.0, 1.0, 0.01) var influence: float = 1.0
