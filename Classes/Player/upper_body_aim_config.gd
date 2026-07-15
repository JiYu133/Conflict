class_name UpperBodyAimConfig
extends Resource

@export_group("骨骼")
## 驱动俯仰旋转的脊柱骨骼名称
@export var spine_bone_name: String = "mixamorig_Spine1"

@export_group("旋转参数")
## 上半身俯仰幅度（0 = 完全不跟随，1 = 完全跟随相机）
@export var pitch_scale: float = 0.5
## 俯仰方向符号（1.0 或 -1.0，若方向反了改为 -1.0）
@export var pitch_sign: float = 1.0

@export_group("过渡")
## 权重平滑速度（越大过渡越快）
@export var weight_smooth_speed: float = 5.0
