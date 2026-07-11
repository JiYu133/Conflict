class_name PlayerModelManager
extends Node

# ============================================================
# 玩家模型管理器
# 功能：负责加载/卸载玩家的 3D 模型场景，查找并缓存模型中的
#       关键组件（骨骼系统、动画播放器），以及创建碰撞体。
# 用法：
#   1. 在 BasePlayer 中作为子节点存在
#   2. 调用 load_model(player_config) 传入 PlayerConfig 资源
#   3. 加载成功后通过 model_loaded 信号通知其他模块（如摄像机控制器）
# ============================================================

# 信号 ────────────────────────────────────────────────────
signal model_loaded(model: Node3D)
## 模型加载完成，参数为实例化后的模型根节点
signal model_unloaded
## 模型已卸载

# 公开属性（只读）──────────────────────────────────────────
var model_node: Node3D:
	get: return _model_node
## 当前加载的模型场景根节点

var skeleton: Skeleton3D:
	get: return _skeleton
## 模型中的 Skeleton3D 骨骼系统（用于挂载武器、摄像机等）

var animator: AnimationPlayer:
	get: return _animator
## 模型中的 AnimationPlayer（用于播放走路、奔跑、换弹等动画）

var animation_tree: AnimationTree:
	get: return _animation_tree
## 模型中的 AnimationTree（用于 BlendSpace2D 多方向动画混合）


# 私有变量 ────────────────────────────────────────────────
var _model_node: Node3D               # 当前加载的模型实例
var _skeleton: Skeleton3D             # 缓存的骨骼系统引用
var _animator: AnimationPlayer        # 缓存的动画播放器引用
var _animation_tree: AnimationTree    # 缓存的动画树引用
var _model_lookup_config: ModelLookupConfig  # 节点查找规则配置
var _player_config: PlayerConfig             # 玩家配置（碰撞体参数等）


# ============================================================
# 模型加载与卸载
# ============================================================

## 加载模型
## 从 PlayerConfig 中读取 model_scene（PackedScene）并实例化，
## 然后自动查找骨骼和动画系统，最后创建碰撞体。
func load_model(player_config: PlayerConfig = null) -> void:
	var scene = player_config.model_scene
	var model_lookup_config = player_config.model_config

	if not scene:
		push_error("模型场景为空")
		return

	_model_lookup_config = model_lookup_config if model_lookup_config else ModelLookupConfig.new()
	_player_config = player_config if player_config else PlayerConfig.new()

	# 先实例化新模型，验证可用后再卸载旧的
	# 避免新模型失败时玩家变成无模型的隐形人
	var new_model = scene.instantiate()
	if not new_model:
		push_error("模型实例化失败")
		return

	# 实例化成功，清除旧模型
	unload_model()

	_model_node = new_model

	# 将模型添加到 BasePlayer 节点下
	# 优先把模型挂到 ModelManager 的父节点（即 BasePlayer）下
	var player = get_parent()
	if player:
		player.add_child(_model_node)
	else:
		add_child(_model_node)  # 回退方案：挂到自己下面

	# 强制关闭 top_level，确保模型的坐标空间相对 BasePlayer
	_model_node.top_level = false
	# 应用 Y 轴偏移使模型脚部对齐胶囊体底部
	_model_node.position = Vector3(0, _player_config.model_y_offset, 0)

	# 查找骨骼系统和动画播放器
	_find_components()

	model_loaded.emit(_model_node)
	print("模型加载完成: ", _model_node.name)

	# 创建碰撞体
	_create_collision_body()

## 卸载模型
## 清除模型实例和相关缓存的引用
func unload_model() -> void:
	if _model_node:
		_model_node.queue_free()
		_model_node = null
		_skeleton = null
		_animator = null
		_animation_tree = null
		model_unloaded.emit()


# ============================================================
# 节点查找
# ============================================================

## 按名称列表查找节点（模糊匹配）
## names：候选名称数组，按优先级排列，找到第一个匹配的即返回
## type：可选的类型过滤器，例如 "Node3D" / "Skeleton3D"
func find_node_by_names(names: Array, type: String = "") -> Node:
	if not _model_node:
		return null

	for name in names:
		var node = _model_node.find_child(name, true, false)
		if node and (type.is_empty() or node.is_class(type)):
			return node

	return null


# ============================================================
# 内部
# ============================================================

## 查找关键组件：骨骼系统和动画播放器
func _find_components() -> void:
	_skeleton = find_node_by_names([_model_lookup_config.skeleton_name])
	_animator = find_node_by_names([_model_lookup_config.animator_name])
	_animation_tree = find_node_by_names([_model_lookup_config.animation_tree_name])

	if not _skeleton:
		push_warning("未找到骨骼系统，部分功能将不可用")
	if not _animator:
		push_warning("未找到动画系统")
	if not _animation_tree:
		push_warning("未找到 AnimationTree，动画混合将不可用")

## 为玩家创建碰撞体
## 使用胶囊体碰撞形状（CapsuleShape3D），参数来自 PlayerConfig
func _create_collision_body() -> void:
	var collision = CollisionShape3D.new()
	var shape = CapsuleShape3D.new()
	shape.height = _player_config.collision_shape_height
	shape.radius = _player_config.collision_shape_radius
	collision.shape = shape
	collision.position = Vector3(0, 0, 0)  # 碰撞体中心置于身体中部

	var player = get_parent()
	player.add_child(collision)
