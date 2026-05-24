class_name ModelLookupConfig
extends Resource

## 配置模版，定义如何从导入的模型场景中查找节点的规则

## 骨骼/动画器名称
@export var skeleton_name: String = "Skeleton3D"
@export var animator_name: String = "AnimationPlayer"

## 摄像机挂载点候选名称（按优先级排列）
@export var camera_mount_names: Array[String] = [
	"CameraMount", "Camera_Mount", "EyeMount", "Camera", "camera"
]

## 脚部射线候选名称
@export var left_foot_ray_names: Array[String] = [
	"RayCast_LeftFoot", "LeftFootRay", "LeftRay", "leftray"
]
@export var right_foot_ray_names: Array[String] = [
	"RayCast_RightFoot", "RightFootRay", "RightRay", "rightray"
]

## 头部骨骼候选名称（自动创建挂载点时的回退方案）
@export var head_bone_names: Array[String] = [
	"Head", "head", "Eye", "eye"
]
