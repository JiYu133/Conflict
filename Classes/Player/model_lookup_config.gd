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
## 骨骼系统的节点名称 / Skeleton3D node name in the model scene
@export var skeleton_name: String = "Skeleton3D"
## 动画播放器的节点名称 / AnimationPlayer node name
@export var animator_name: String = "AnimationPlayer"
## AnimationTree 节点名称 / AnimationTree node name
@export var animation_tree_name: String = "AnimationTree"

# 摄像机挂载点候选名称（按优先级排列）─────────────────────────
## 第一人称视角挂载点候选名称列表（多候选，按优先级排列）/ Camera mount candidate node names in priority order
@export var camera_mount_names: Array[String] = [
	"CameraMount", "Camera_Mount", "EyeMount",
	"Camera", "camera", "Camera3D", "Marker3D"
]

# 脚部射线候选名称 ──────────────────────────────────────────
## 左脚 RayCast 节点候选名称（用于 IK 脚步适配）/ Left foot RayCast candidate node names for IK
@export var left_foot_ray_names: Array[String] = [
	"RayCast_LeftFoot", "LeftFootRay", "LeftRay", "leftray"
]
## 右脚 RayCast 节点候选名称（用于 IK 脚步适配）/ Right foot RayCast candidate node names for IK
@export var right_foot_ray_names: Array[String] = [
	"RayCast_RightFoot", "RightFootRay", "RightRay", "rightray"
]

# 头部骨骼候选名称（自动创建挂载点时的回退方案）────────────────
## 当模型没有 CameraMount 时，从头部骨骼自动创建挂载点 / Head bone candidates used to auto-create camera mount when none exists
@export var head_bone_names: Array[String] = [
	"Head", "head", "Eye", "eye"
]
