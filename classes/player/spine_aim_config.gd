class_name SpineAimConfig
extends Resource

## 正常瞄准时分摊视角旋转的脊柱/颈部骨骼。
## 这些骨骼会影响持枪上半身，因此自由观察偏移不会使用这组骨骼。
@export var bone_names: Array[String] = [
	"mixamorig_Spine",
	"mixamorig_Spine1",
	"mixamorig_Spine2",
	"mixamorig_Neck",
]

## 与 bone_names 一一对应的正常瞄准旋转权重，运行时会自动归一化。
@export var bone_weights: Array[float] = [0.16, 0.24, 0.34, 0.26]

## 自由观察时只旋转这些骨骼，默认只使用头部，避免改变枪械方向。
## 名称不存在的骨骼会被自动跳过。
@export var free_look_bone_names: Array[String] = ["mixamorig_Head"]

## 与 free_look_bone_names 一一对应的自由观察权重。
@export var free_look_bone_weights: Array[float] = [1.0]

## 抬头和低头的最大角度。
@export_range(0.0, 89.0, 0.5) var max_look_up_degrees: float = 55.0
## 脊柱可分摊的最大低头角度（度）。
@export_range(0.0, 89.0, 0.5) var max_look_down_degrees: float = 45.0

## 水平转头相对身体的最大角度（度）。建议与 MovementConfig 的视角上限一致。
@export_range(0.0, 180.0, 0.5) var max_look_yaw_degrees: float = 90.0

## 脊柱追随视角的速度；越大响应越快。
@export_range(0.0, 30.0, 0.1) var response_speed: float = 14.0

## 总体旋转强度。用于保留一部分原始动画姿态。
@export_range(0.0, 1.0, 0.01) var influence: float = 1.0
