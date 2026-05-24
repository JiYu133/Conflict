class_name FootIKController
extends Node

## 私有变量
var _left_foot_ray: RayCast3D
var _right_foot_ray: RayCast3D
var _model_manager: PlayerModelManager
var _config: ModelLookupConfig
var _skeleton: Skeleton3D

## 初始化
func initialize(model_manager: PlayerModelManager, config: ModelLookupConfig) -> void:
	_model_manager = model_manager
	_config = config
	_skeleton = model_manager.skeleton
	
	# 监听模型加载
	_model_manager.model_loaded.connect(_on_model_loaded)

## 获取脚部地面信息
func get_ground_info() -> Dictionary:
	var result = {
		"left": {"colliding": false, "point": Vector3.ZERO, "normal": Vector3.UP},
		"right": {"colliding": false, "point": Vector3.ZERO, "normal": Vector3.UP}
	}
	
	if _left_foot_ray and _left_foot_ray.is_colliding():
		result.left.colliding = true
		result.left.point = _left_foot_ray.get_collision_point()
		result.left.normal = _left_foot_ray.get_collision_normal()
	
	if _right_foot_ray and _right_foot_ray.is_colliding():
		result.right.colliding = true
		result.right.point = _right_foot_ray.get_collision_point()
		result.right.normal = _right_foot_ray.get_collision_normal()
	
	return result

# TODO: 实现完整的IK调整
func process_ik(delta: float) -> void:
	pass  # 使用SkeletonIK3D或手动计算

## 私有方法
func _on_model_loaded(_model: Node3D) -> void:
	_setup_foot_rays()

func _setup_foot_rays() -> void:
	# 查找预设的射线节点
	_left_foot_ray = _model_manager.find_node_by_names(_config.left_foot_ray_names)
	_right_foot_ray = _model_manager.find_node_by_names(_config.right_foot_ray_names)
	
	# 如果没有，尝试从骨骼创建
	if not _left_foot_ray or not _right_foot_ray:
		_create_rays_from_skeleton()

# TODO: 从骨骼自动创建射线
func _create_rays_from_skeleton() -> void:
	if not _skeleton:
		return
	
	# 查找脚部骨骼
	var foot_bones = [
		["LeftFoot", "Foot_L", "l_foot"],
		["RightFoot", "Foot_R", "r_foot"]
	]
	
	# 为每只脚创建射线
	# (代码较长，重构时具体实现)
	pass
