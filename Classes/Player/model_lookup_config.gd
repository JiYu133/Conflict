class_name ModelLookupConfig
extends Resource

# ============================================================
# 模型节点查找配置
# 功能：定义如何从导入的 3D 模型场景（.glb / .tscn）中
#       自动定位关键节点的规则。
#       每个字段是一个候选名称数组，按优先级排列，
#       遍历找到第一个匹配项即停止。
# 用法：附加在 PlayerConfig.model_config 中，由 PlayerModelManager
#       在 load_model() 时读取并执行查找。
# ============================================================

# 骨骼 / 动画器名称 ────────────────────────────────────────
@export var skeleton_name: String = "Skeleton3D"
## 骨骼系统的节点名称（通常是 Godot 导入 .glb 时自动生成的 Skeleton3D）
@export var animator_name: String = "AnimationPlayer"
## 动画播放器的节点名称

# 摄像机挂载点候选名称（按优先级排列）─────────────────────────
@export var camera_mount_names: Array[String] = [
	"CameraMount", "Camera_Mount", "EyeMount",
	"Camera", "camera", "Camera3D", "Marker3D"
]
## 第一人称视角的挂载点节点名称列表
## 模型制作者可以按习惯命名，只要在这个列表里就能被自动识别

# 脚部射线候选名称 ──────────────────────────────────────────
@export var left_foot_ray_names: Array[String] = [
	"RayCast_LeftFoot", "LeftFootRay", "LeftRay", "leftray"
]
@export var right_foot_ray_names: Array[String] = [
	"RayCast_RightFoot", "RightFootRay", "RightRay", "rightray"
]
## 双脚的 RayCast 节点名称（后续用于 IK 脚步适配地面）

# 头部骨骼候选名称（自动创建挂载点时的回退方案）────────────────
@export var head_bone_names: Array[String] = [
	"Head", "head", "Eye", "eye"
]
## 当模型没有 CameraMount 时，从头部骨骼自动创建摄像机挂载点
