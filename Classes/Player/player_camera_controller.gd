class_name PlayerCameraController
extends Node

## 信号
signal camera_ready(camera: Camera3D)

## 公开属性
var camera_mount: Node3D:
	get: return _camera_mount
var model_camera: Camera3D:
	get: return _model_camera

## 私有变量
var _camera_mount: Node3D
var _model_camera: Camera3D
var _active_camera: Camera3D
var _model_manager: PlayerModelManager
var _model_lookup_config: ModelLookupConfig
var _player_config: PlayerConfig
var _player: CharacterBody3D

var _mouse_sensitivity: float # 鼠标灵敏度
var _vertical_angle: float = 0.0  # 当前垂直角度（弧度）
var _max_vertical_angle: float # 上下限制（约 80 度）

func _ready() -> void:
	print("player_camera_controller.gd 已激活")

## 初始化（由BasePlayer调用）
func initialize(player: CharacterBody3D, model_manager: PlayerModelManager, model_lookup_config: ModelLookupConfig, player_config: PlayerConfig) -> void:
	_model_manager = model_manager
	_model_lookup_config = model_lookup_config
	_player_config = player_config
	_player = player
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# 监听模型加载
	if not _model_manager.model_loaded.is_connected(_on_model_loaded):
		_model_manager.model_loaded.connect(_on_model_loaded)
	print("摄像机控制器初始化完成")
	enable_camera()
## 启用第一人称
func enable_camera() -> void:
	# 读取有关视角控制的配置参数
	_mouse_sensitivity = _player_config.mouse_sensitivity
	_max_vertical_angle = _player_config.max_vertical_angle 
	
	var seedCamera = Camera3D.new()
	if seedCamera :
		print("种子相机创建完毕")
		seedCamera.name = "SeedCamera"
		seedCamera.current = true
		_player.add_child(seedCamera)
	
	print("开始激活第一人称")
	var viewport = get_viewport()
	if not viewport:
		push_warning("没有找到有效视口")
		return
	else:
		print("已找到视口")
	# 优先级：挂载点 > 模型摄像机 > 骨骼创建
	var viewport_camera = viewport.get_camera_3d()
	if _camera_mount:
		_attach_to_mount(viewport_camera, _camera_mount)
	elif _model_camera:
		_model_camera.current = true
		_active_camera = _model_camera
	else:
		_create_mount_from_skeleton(viewport_camera)
	
	camera_ready.emit(_active_camera)


func _process(delta: float) -> void:
	pass  # 以后实现鼠标视角控制

## 私有方法
func _on_model_loaded(_model: Node3D) -> void:
	_find_camera_nodes()

func _find_camera_nodes() -> void:
	if not _model_manager.model_node:
		return
	
	_camera_mount = _model_manager.find_node_by_names(_model_lookup_config.camera_mount_names, "Node3D")
	
	var cameras = _model_manager.model_node.find_children("*", "Camera3D", true, false)
	_model_camera = cameras[0] if cameras.size() > 0 else null
	
	if _camera_mount:
		print("找到摄像机挂载点: ", _camera_mount.name)
		var cam = get_viewport().get_camera_3d()
		if cam:
			_attach_to_mount(cam, _camera_mount)
	else:
		print("未找到摄像机挂载点")

func _attach_to_mount(camera: Camera3D, mount: Node3D) -> void:
	# 重新挂载
	if camera.get_parent():
		camera.get_parent().remove_child(camera)
	mount.add_child(camera)
	
	# 重置相对位置
	camera.position = Vector3.ZERO
	camera.rotation = Vector3.ZERO
	camera.current = true
	_active_camera = camera
	
	print("摄像机已挂载到: ", mount.name)

func _create_mount_from_skeleton(camera: Camera3D) -> void:
	var skeleton = _model_manager.skeleton
	if not skeleton:
		push_warning("无法从骨骼创建挂载点：没有骨骼系统")
		return
	
	# 查找头部骨骼
	for bone_name in _model_lookup_config.head_bone_names:
		var bone_idx = skeleton.find_bone(bone_name)
		if bone_idx != -1:
			# 创建挂载点
			var mount = Marker3D.new()
			mount.name = "CameraMount_Auto"
			skeleton.add_child(mount)
			
			# 设置位置到骨骼位置
			var bone_pose = skeleton.get_bone_global_pose(bone_idx)
			mount.global_position = skeleton.global_transform * bone_pose.origin
			
			_camera_mount = mount
			_attach_to_mount(camera, mount)
			print("从骨骼自动创建挂载点: ", bone_name)
			return
	
	push_warning("未找到合适的头部骨骼")

## 视角控制

func _input(event: InputEvent) -> void:
	var active_camera = get_viewport().get_camera_3d()
	if not active_camera:
		return
	
	# 只处理鼠标移动
	if event is not InputEventMouseMotion:
		return
	
	# 水平旋转：旋转 BasePlayer
	var player = get_parent()  # CameraController 的父节点是 BasePlayer
	if player and player is CharacterBody3D:
		player.rotate_y(-event.relative.x * _mouse_sensitivity)
	
	# 垂直旋转：旋转摄像机本身
	_vertical_angle -= event.relative.y * _mouse_sensitivity
	_vertical_angle = clamp(_vertical_angle, -_max_vertical_angle, _max_vertical_angle)
	
	if active_camera:
		active_camera.rotation.x = _vertical_angle	
