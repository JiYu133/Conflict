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
var _config: ModelLookupConfig

## 初始化（由BasePlayer调用）
func initialize(model_manager: PlayerModelManager, config: ModelLookupConfig) -> void:
	_model_manager = model_manager
	_config = config
	
	# 监听模型加载
	if not _model_manager.model_loaded.is_connected(_on_model_loaded):
		_model_manager.model_loaded.connect(_on_model_loaded)

## 启用第一人称
func enable_camera() -> void:
	var viewport_camera = get_viewport().get_camera_3d()
	if not viewport_camera:
		push_warning("视口中没有激活的摄像机")
		return
	
	# 优先级：挂载点 > 模型摄像机 > 骨骼创建
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
	
	# 查找挂载点
	_camera_mount = _model_manager.find_node_by_names(_config.camera_mount_names, "Node3D")
	
	# 查找模型摄像机
	var cameras = _model_manager.model_node.find_children("*", "Camera3D", true, false)
	_model_camera = cameras[0] if cameras.size() > 0 else null
	
	if _camera_mount:
		print("找到摄像机挂载点: ", _camera_mount.name)
	elif _model_camera:
		print("找到模型摄像机: ", _model_camera.name)
	else:
		print("未找到任何摄像机节点，将尝试从骨骼创建")

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
	for bone_name in _config.head_bone_names:
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
