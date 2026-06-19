class_name PlayerCameraController
extends Node

# ============================================================
# 玩家摄像机控制器
# 功能：管理第一人称视角的摄像机挂载、鼠标视角控制。
#       支持三种相机位置获取方式（优先级递减）：
#         1. 模型场景中预设的 CameraMount 节点（挂载点）
#         2. 模型场景自带 Camera3D
#         3. 从头部骨骼动态创建 Marker3D 挂载点（回退方案）
# 依赖：PlayerModelManager / ModelLookupConfig / PlayerConfig
#       依赖 CharacterBody3D 的 rotate_y 实现水平视角
# ============================================================

# 信号 ────────────────────────────────────────────────────
signal camera_ready(camera: Camera3D)
## 摄像机就绪，可以开始接收视角输入


# 公开属性（只读）──────────────────────────────────────────
var camera_mount: Node3D:
	get: return _camera_mount
## 当前活动的摄像机挂载点

var model_camera: Camera3D:
	get: return _model_camera
## 模型自带的摄像机（如有）


# 私有变量 ────────────────────────────────────────────────
var _camera_mount: Node3D                  # 摄像机挂载点（Marker3D / Node3D）
var _model_camera: Camera3D               # 模型自带的摄像机
var _active_camera: Camera3D              # 当前实际使用的摄像机
var _model_manager: PlayerModelManager    # 模型管理器引用
var _model_lookup_config: ModelLookupConfig  # 模型节点查找配置
var _player_config: PlayerConfig          # 玩家配置
var _player: CharacterBody3D             # 玩家角色

var _mouse_sensitivity: float             # 鼠标灵敏度（弧度/像素）
var _vertical_angle: float = 0.0         # 当前垂直视角角度（弧度）
var _max_vertical_angle: float           # 最大垂直角度，约 80 度（1.4 弧度）


# ============================================================
# 初始化（由 BasePlayer 调用）
# ============================================================
func initialize(
	player: CharacterBody3D,
	model_manager: PlayerModelManager,
	model_lookup_config: ModelLookupConfig,
	player_config: PlayerConfig
) -> void:
	_model_manager = model_manager
	_model_lookup_config = model_lookup_config if model_lookup_config else ModelLookupConfig.new()
	_player_config = player_config if player_config else PlayerConfig.new()
	_player = player

	# 创建备用摄像机防止 Godot 视口空窗
	# 在真实摄像机挂载前，先用这个占位
	var seed = Camera3D.new()
	seed.name = "SeedCamera"
	seed.current = true
	_player.add_child(seed)

	# 默认捕获鼠标（FPS 标准操作）
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	# 监听模型加载完成事件，加载后自动查找摄像机节点
	# 【注意】需要外部连接 model_manager.model_loaded 信号到 _on_model_loaded


# ============================================================
# 摄像机激活
# ============================================================

## 启用摄像机视角控制
## 调用时机：模型加载完成后，需要正式开始游戏视角时
func enable_camera() -> void:
	# 读取视角控制参数
	_mouse_sensitivity = _player_config.mouse_sensitivity
	_max_vertical_angle = _player_config.max_vertical_angle

	var viewport = get_viewport()
	if not viewport:
		push_warning("没有找到有效视口")
		return

	# 优先级：挂载点 > 模型摄像机 > 从骨骼创建
	var viewport_camera = viewport.get_camera_3d()

	if _camera_mount:
		_attach_to_mount(viewport_camera, _camera_mount)
	elif _model_camera:
		_model_camera.current = true
		_active_camera = _model_camera
	else:
		_create_mount_from_skeleton(viewport_camera)

	camera_ready.emit(_active_camera)


# ============================================================
# 模型加载回调
# ============================================================

## 模型加载完成时查找摄像机相关节点
func _on_model_loaded() -> void:
	_find_camera_nodes()

## 递归查找模型节点树中的摄像机挂载点和自带摄像机
func _find_camera_nodes() -> void:
	if not _model_manager.model_node:
		push_warning("模型节点不存在，无法查找摄像机挂载点")
		return

	# 查找挂载点（按 ModelLookupConfig 中的候选名称列表匹配）
	_camera_mount = _model_manager.find_node_by_names(
		_model_lookup_config.camera_mount_names, "Node3D"
	)

	# 查找模型自带的 Camera3D
	var cameras = _model_manager.model_node.find_children("*", "Camera3D", true, false)
	_model_camera = cameras[0] if cameras.size() > 0 else null

	# 找到后立即挂载
	if _camera_mount:
		var cam = get_viewport().get_camera_3d()
		if cam:
			_attach_to_mount(cam, _camera_mount)
	elif _model_camera:
		_model_camera.current = true
		_active_camera = _model_camera
	else:
		push_warning("未找到摄像机挂载点")


# ============================================================
# 挂载与创建
# ============================================================

## 将摄像机重新挂载到指定挂载点
## 同时清理之前创建的备用摄像机
func _attach_to_mount(camera: Camera3D, mount: Node3D) -> void:
	# 清理备用摄像机（初始创建的 SeedCamera）
	# 注意：必须用 owned=false（非递归），否则会把"挂在玩家下面的真摄像机"也匹配上
	# 同时校验 camera 自身不是 seed，否则就是"释放当前相机"了
	if _player:
		var seed = _player.find_child("SeedCamera", false, false)
		if seed and seed != camera:
			seed.queue_free()

	# 从原父节点移除，挂载到新的挂载点
	if camera and camera.get_parent():
		camera.get_parent().remove_child(camera)
	if mount and camera:
		mount.add_child(camera)

	# 重置摄像机在挂载点下的局部位置/旋转
	if camera:
		camera.rotation = Vector3.ZERO
		camera.current = true
		_active_camera = camera

## 从头部骨骼创建挂载点（回退方案）
## 当模型既没有 CameraMount 也没有自带摄像机时使用
func _create_mount_from_skeleton(camera: Camera3D) -> void:
	var skeleton = _model_manager.skeleton
	if not skeleton:
		push_warning("无法从骨骼创建挂载点：没有骨骼系统")
		return

	# 遍历候选头部骨骼名称列表，找到第一个存在的骨骼
	for bone_name in _model_lookup_config.head_bone_names:
		var bone_idx = skeleton.find_bone(bone_name)
		if bone_idx != -1:
			# 在骨骼下创建 Marker3D 作为挂载点
			var mount = Marker3D.new()
			mount.name = "CameraMount_Auto"
			skeleton.add_child(mount)

			# 将挂载点定位到骨骼的世界空间位置
			var bone_pose = skeleton.get_bone_global_pose(bone_idx)
			mount.global_position = skeleton.global_transform * bone_pose.origin

			_camera_mount = mount
			_attach_to_mount(camera, mount)
			return

	push_warning("未找到合适的头部骨骼")


# ============================================================
# 视角控制（每帧处理鼠标输入）
# ============================================================

func _input(event: InputEvent) -> void:
	var active_camera = get_viewport().get_camera_3d()
	if not active_camera:
		return

	if event is not InputEventMouseMotion:
		return

	# 水平旋转：绕 Y 轴旋转整个 BasePlayer
	# 这样可以保持移动方向与视角方向一致
	var player = get_parent()  # CameraController 的父节点是 BasePlayer
	if player and player is CharacterBody3D:
		player.rotate_y(-event.relative.x * _mouse_sensitivity)
	else:
		push_warning("玩家不存在或类型错误！")

	# 垂直旋转：绕 X 轴旋转摄像机本身
	# 限制范围防止翻转（-max ~ +max 弧度）
	_vertical_angle -= event.relative.y * _mouse_sensitivity
	_vertical_angle = clamp(_vertical_angle, -_max_vertical_angle, _max_vertical_angle)

	if active_camera:
		active_camera.rotation.x = _vertical_angle


# ============================================================
# 辅助工具（可按需移除，仅调试时使用）
# ============================================================

## 递归查找指定名称的节点
func _find_node_recursive(parent: Node, target_name: String) -> Node:
	for child in parent.get_children():
		if child.name == target_name:
			return child
		var found = _find_node_recursive(child, target_name)
		if found:
			return found
	return null

## 打印节点树（调试用）
func _print_node_tree(node: Node, indent: String) -> void:
	print(indent + node.name + " (" + node.get_class() + ")")
	for child in node.get_children():
		_print_node_tree(child, indent + "  ")
