class_name PlayerModelManager
extends Node

## 玩家模型加载器，会加载玩家的模型以及检查关键组件

## 信号
signal model_loaded(model: Node3D)
signal model_unloaded

## 公开属性（只读）
var model_node: Node3D:
	get: return _model_node
var skeleton: Skeleton3D:
	get: return _skeleton
var animator: AnimationPlayer:
	get: return _animator

## 私有变量
var _model_node: Node3D
var _skeleton: Skeleton3D
var _animator: AnimationPlayer
var _model_lookup_config: ModelLookupConfig
var _player_config: PlayerConfig


## 加载模型
func load_model(player_config: PlayerConfig = null) -> void:
	var scene = player_config.model_scene
	var model_lookup_config = player_config.model_config
	
	if not scene:
		push_error("模型场景为空")
		return
	
	if model_lookup_config:
		model_lookup_config
	
	_model_lookup_config = model_lookup_config if model_lookup_config else ModelLookupConfig.new()
	_player_config = player_config if player_config else PlayerConfig.new()
	
	# 清理旧模型
	unload_model()
	
	# 实例化
	_model_node = scene.instantiate()
	if not _model_node:
		push_error("模型实例化失败")
		return
	
	# 添加到 BasePlayer 下（ModelManager 的父节点）
	var player = get_parent()
	if player:
		player.add_child(_model_node)
	else:
		add_child(_model_node)  # 回退
	
	# 强制取消 top_level 并重置局部位置
	_model_node.top_level = false
	_model_node.position = Vector3.ZERO
	
	# 查找关键组件
	_find_components()

	model_loaded.emit(_model_node)
	print("模型加载完成: ", _model_node.name)
	# 设置碰撞体积
	_create_collision_body() 


## 卸载模型
func unload_model() -> void:
	if _model_node:
		_model_node.queue_free()
		_model_node = null
		_skeleton = null
		_animator = null
		model_unloaded.emit()

## 按名称列表查找节点（模糊匹配）
func find_node_by_names(names: Array, type: String = "") -> Node:
	if not _model_node:
		return null
	
	for name in names:
		var node = _model_node.find_child(name, true, false)
		if node and (type.is_empty() or node.is_class(type)):
			return node
		
	return null

## 私有：查找关键组件
func _find_components() -> void:
	_skeleton = find_node_by_names([_model_lookup_config.skeleton_name])
	_animator = find_node_by_names([_model_lookup_config.animator_name])
	
	if not _skeleton:
		push_warning("未找到骨骼系统，部分功能将不可用")
	if not _animator:
		push_warning("未找到动画系统")
		

func _create_collision_body() -> void:
	var collision = CollisionShape3D.new()
	var shape = CapsuleShape3D.new()
	shape.height =  _player_config.collision_shape_height  # 身高
	shape.radius = _player_config.collision_shape_radius   # 体型半径
	collision.shape = shape
	collision.position = Vector3(0, 0, 0)  # 碰撞体中心在身体中部
	var player = get_parent()
	player.add_child(collision)
