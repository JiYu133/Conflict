class_name PlayerCameraController
extends Node

# ============================================================
# 玩家摄像机控制器
# 功能：
#   - 摄像机位置在玩家局部空间用弹簧跟随头部骨骼（过滤动画晃动）
#   - 鼠标旋转绕过弹簧直接应用，不产生延迟感
#   - ADS 系统：平滑 FOV 缩放 + 武器居中
# ============================================================


# 弹簧跟踪器（1D 临界阻尼弹簧，用于低通滤波）
class CameraSpring1D:
	var position: float = 0.0
	var velocity: float = 0.0
	var stiffness: float = 120.0
	var damping: float = 20.0

	func update(delta: float, target: float) -> float:
		var force: float = -stiffness * (position - target) - damping * velocity
		velocity += force * delta
		position += velocity * delta
		return position


# 信号 ────────────────────────────────────────────────────
signal camera_ready(camera: Camera3D)


# 公开属性 ────────────────────────────────────────────────
var camera_mount: Node3D:
	get: return _camera_mount
# 可控状态以 BasePlayer.controllable 为唯一权威来源
var controllable: bool:
	get: return is_instance_valid(_player) and _player.controllable


# 私有变量 ────────────────────────────────────────────────
var _camera_mount: Node3D
var _model_camera: Camera3D
var _active_camera: Camera3D
var _model_manager: PlayerModelManager
var _model_lookup_config: ModelLookupConfig
var _camera_config: CameraConfig
var _player: BasePlayer
var _bone_attachment: BoneAttachment3D

var _mouse_sensitivity: float
var _vertical_angle: float = 0.0
var _max_vertical_angle: float

# 弹簧系统 - 3 轴独立弹簧，对头部位置在玩家局部空间做低通滤波
var _spring_x: CameraSpring1D
var _spring_y: CameraSpring1D
var _spring_z: CameraSpring1D
var _stiffness_h: float = 500.0
var _stiffness_v: float = 120.0

var _sway_pivot: Node3D = null

# 后座
var _recoil_component: RecoilComponent = null

# 死亡摄像机跟随
var _ragdoll_skeleton: Skeleton3D = null
var _ragdoll_bone_idx: int = -1
var _ragdoll_physical_bone: PhysicalBone3D = null

# ADS
var _is_ads: bool = false
var _ads_progress: float = 0.0
var _ads_transition_time: float = 0.25
var _hip_fov: float = 90.0
var _ads_fov: float = 60.0
var _ads_center_offset: Vector3 = Vector3.ZERO


# ============================================================
# 初始化
# ============================================================
func initialize(
	player: BasePlayer,
	model_manager: PlayerModelManager,
	model_lookup_config: ModelLookupConfig,
	camera_config: CameraConfig
) -> void:
	_model_manager = model_manager
	_model_lookup_config = model_lookup_config if model_lookup_config else ModelLookupConfig.new()
	_camera_config = camera_config if camera_config else CameraConfig.new()
	_player = player

	_spring_x = CameraSpring1D.new()
	_spring_y = CameraSpring1D.new()
	_spring_z = CameraSpring1D.new()
	_update_spring_params()

	_hip_fov = _camera_config.fov

	var seed: Camera3D = Camera3D.new()
	seed.name = "SeedCamera"
	seed.current = true
	_player.add_child(seed)

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _update_spring_params() -> void:
	_stiffness_h = _camera_config.spring_stiffness_h
	_stiffness_v = _camera_config.spring_stiffness_v
	_spring_x.damping = _camera_config.spring_damping_h
	_spring_z.damping = _camera_config.spring_damping_h
	_spring_y.damping = _camera_config.spring_damping_v


# ============================================================
# 摄像机激活与挂载
# ============================================================
func enable_camera() -> void:
	_mouse_sensitivity = _camera_config.mouse_sensitivity
	_max_vertical_angle = _camera_config.max_vertical_angle

	if _ragdoll_skeleton:
		_ragdoll_skeleton = null
		_ragdoll_bone_idx = -1
		_ragdoll_physical_bone = null
		_sync_springs_to_head()
		return
	_ragdoll_physical_bone = null

	var viewport: Viewport = get_viewport()
	if not viewport:
		return

	var viewport_camera: Camera3D = viewport.get_camera_3d()
	if _camera_mount:
		_attach_to_mount(viewport_camera, _camera_mount)
	elif _model_camera:
		_model_camera.current = true
		_active_camera = _model_camera
	else:
		_create_mount_from_skeleton(viewport_camera)

	camera_ready.emit(_active_camera)
	if _active_camera:
		_active_camera.fov = _camera_config.fov

	_bone_attachment = _find_bone_attachment()
	if _bone_attachment:
		GlobalLogger.info("Camera", "Head BoneAttachment found: " + _bone_attachment.bone_name)
	else:
		GlobalLogger.warn("Camera", "Head BoneAttachment not found, using fallback position")
	_sync_springs_to_head()


func disable_camera(skeleton: Skeleton3D = null) -> void:
	if not skeleton:
		return
	var head_idx: int = _find_head_bone_index(skeleton)
	if head_idx == -1:
		return
	_ragdoll_skeleton = skeleton
	_ragdoll_bone_idx = head_idx
	_ragdoll_physical_bone = null


## 死亡动画结束后改为直接跟随物理头骨，而不是等待 Skeleton3D 回写姿态。
func follow_ragdoll_physical_bone(physical_bone: PhysicalBone3D) -> void:
	if not is_instance_valid(physical_bone):
		GlobalLogger.warn("Camera", "Cannot bind ragdoll camera: physical head bone not found")
		return
	_ragdoll_physical_bone = physical_bone
	GlobalLogger.info("Camera", "Ragdoll camera bound to physical bone: %s" % physical_bone.bone_name)


# 弹簧位置对齐当前头部局部位置，防止启用/复活瞬间镜头跳变
func _sync_springs_to_head() -> void:
	var head_pos := _get_head_local_position()
	_spring_x.position = head_pos.x
	_spring_y.position = head_pos.y
	_spring_z.position = head_pos.z


# 按 head_bone_names 优先级查找头部骨骼索引，未找到返回 -1
func _find_head_bone_index(skeleton: Skeleton3D) -> int:
	for bone_name in _model_lookup_config.head_bone_names:
		var idx: int = skeleton.find_bone(bone_name)
		if idx != -1:
			return idx
	return -1


func _on_model_loaded() -> void:
	_find_camera_nodes()


func _find_camera_nodes() -> void:
	if not _model_manager.model_node:
		return

	_camera_mount = _model_manager.find_node_by_names(
		_model_lookup_config.camera_mount_names, "Node3D"
	)
	if _camera_mount and _camera_mount is Camera3D:
		_camera_mount = null

	var cameras: Array = _model_manager.model_node.find_children("*", "Camera3D", true, false)
	_model_camera = cameras[0] if cameras.size() > 0 else null

	if _camera_mount:
		var cam: Camera3D = get_viewport().get_camera_3d()
		if cam:
			_attach_to_mount(cam, _camera_mount)
	elif _model_camera:
		_model_camera.current = true
		_active_camera = _model_camera
	else:
		push_warning("未找到摄像机挂载点")


func _attach_to_mount(camera: Camera3D, mount: Node3D) -> void:
	if is_instance_valid(_player):
		var seed: Node = _player.find_child("SeedCamera", false, false)
		if seed and seed != camera:
			seed.queue_free()
	if camera and camera.get_parent():
		camera.get_parent().remove_child(camera)
	if mount and camera:
		mount.add_child(camera)
	if camera:
		camera.rotation = Vector3.ZERO
		camera.current = true
		_active_camera = camera


func _create_mount_from_skeleton(camera: Camera3D) -> void:
	var skeleton: Skeleton3D = _model_manager.skeleton
	if not skeleton:
		return
	var bone_idx: int = _find_head_bone_index(skeleton)
	if bone_idx == -1:
		return
	var mount: Marker3D = Marker3D.new()
	mount.name = "CameraMount_Auto"
	skeleton.add_child(mount)
	var bone_pose: Transform3D = skeleton.get_bone_global_pose(bone_idx)
	mount.global_position = skeleton.global_transform * bone_pose.origin
	_camera_mount = mount
	_attach_to_mount(camera, mount)


func _find_bone_attachment() -> BoneAttachment3D:
	if not _model_manager.model_node:
		return null
	var nodes: Array = _model_manager.model_node.find_children("*", "BoneAttachment3D", true, false)
	# 精确匹配优先
	for node in nodes:
		var attachment := node as BoneAttachment3D
		if attachment and attachment.bone_name in _model_lookup_config.head_bone_names:
			return attachment
	# 回退：包含匹配（处理 mixamorig_Head 等前缀命名）
	for node in nodes:
		var attachment := node as BoneAttachment3D
		if not attachment:
			continue
		for candidate in _model_lookup_config.head_bone_names:
			if attachment.bone_name.to_lower().contains(candidate.to_lower()):
				return attachment
	return null


# ============================================================
# 鼠标输入
# ============================================================
func _input(event: InputEvent) -> void:
	if event is not InputEventMouseMotion:
		return
	if not is_instance_valid(_player) or not controllable:
		return
	_player.rotate_y(-event.relative.x * _mouse_sensitivity)
	_vertical_angle -= event.relative.y * _mouse_sensitivity
	_vertical_angle = clamp(_vertical_angle, -_max_vertical_angle, _max_vertical_angle)


# ============================================================
# 每帧更新（核心）
# ============================================================
func _process(delta: float) -> void:
	if not _active_camera or not _camera_config:
		return

	# 死亡模式：直接读头骨骼全局变换
	if is_instance_valid(_ragdoll_physical_bone):
		# PhysicalBone3D.global_transform 是刚体中心；消除 body_offset 后才是骨骼关节变换。
		var phys_xform: Transform3D = _ragdoll_physical_bone.global_transform
		var offset_basis: Basis = _ragdoll_physical_bone.body_offset.basis
		_active_camera.global_position = phys_xform.origin
		# 模型整体有 PI 旋转修正，补偿 180°
		var yaw_fix := Basis(Vector3.UP, PI)
		_active_camera.global_basis = phys_xform.basis * offset_basis.inverse() * yaw_fix
		return
	if _ragdoll_skeleton and _ragdoll_bone_idx != -1:
		if is_instance_valid(_ragdoll_skeleton):
			var bone_xform: Transform3D = _ragdoll_skeleton.global_transform * _ragdoll_skeleton.get_bone_global_pose(_ragdoll_bone_idx)
			_active_camera.global_transform = bone_xform
		return

	if not controllable:
		return

	# 1. 读取头部在玩家局部空间的位置（弹簧不感知玩家旋转，只过滤动画位移）
	var head_local := _get_head_local_position()

	# 2. 弹簧低通滤波——ADS 时提高刚度
	var stiffness_mult: float = 1.0
	if _is_ads:
		stiffness_mult += (_camera_config.ads_stiffness_multiplier - 1.0) * _ads_progress
	_spring_x.stiffness = _stiffness_h * stiffness_mult
	_spring_y.stiffness = _stiffness_v * stiffness_mult
	_spring_z.stiffness = _stiffness_h * stiffness_mult

	var filtered_local := Vector3(
		_spring_x.update(delta, head_local.x),
		_spring_y.update(delta, head_local.y),
		_spring_z.update(delta, head_local.z)
	)

	# 3. 局部空间转全局——玩家旋转正确携带，鼠标转头不触发弹簧
	_active_camera.global_position = _player.global_transform * filtered_local

	# 4. 旋转由鼠标控制
	var player_yaw: float = _player.rotation.y if _player else 0.0
	var recoil_pitch: float = _get_recoil_pitch()
	_active_camera.global_rotation = Vector3(
		_vertical_angle + recoil_pitch,
		player_yaw,
		0.0
	)

	var recoil_yaw: float = _get_recoil_yaw()
	if recoil_yaw != 0.0 and _player:
		_player.rotate_y(recoil_yaw * delta)

	_update_ads(delta)
	_update_weapon_spring(delta)


# ============================================================
# 头部位置读取（玩家局部空间）
# ============================================================
func _get_head_local_position() -> Vector3:
	if _bone_attachment and is_instance_valid(_bone_attachment) and is_instance_valid(_player):
		var bone_local := _player.global_transform.affine_inverse() * _bone_attachment.global_position
		return bone_local + _camera_config.head_offset
	elif is_instance_valid(_player):
		return Vector3(0, 1.6, 0)
	return Vector3.ZERO


# ============================================================
# ADS
# ============================================================
func _update_ads(delta: float) -> void:
	var target: float = 1.0 if _is_ads else 0.0
	_ads_progress = move_toward(_ads_progress, target, delta / max(_ads_transition_time, 0.001))
	_active_camera.fov = lerp(_hip_fov, _ads_fov, _ads_progress)


func set_ads_state(ads: bool, ads_time: float, zoom_fov: float, center_offset: Vector3) -> void:
	_is_ads = ads
	_ads_transition_time = ads_time
	_ads_fov = zoom_fov if zoom_fov > 0.0 else _hip_fov
	_ads_center_offset = center_offset


# ============================================================
# 武器 ADS 居中偏移
# ============================================================
func _update_weapon_spring(_delta: float) -> void:
	if not _sway_pivot:
		return
	var pos_target := _ads_center_offset * _ads_progress
	_sway_pivot.position.x = pos_target.x
	_sway_pivot.position.y = pos_target.y


# ============================================================
# 后座
# ============================================================
func set_recoil_component(rc: RecoilComponent) -> void:
	_recoil_component = rc


func _get_recoil_pitch() -> float:
	if not _recoil_component:
		return 0.0
	return _recoil_component.get_recoil_offset()


func _get_recoil_yaw() -> float:
	if not _recoil_component:
		return 0.0
	return _recoil_component.get_recoil_horizontal_offset()


# ============================================================
# 公开 API
# ============================================================
func setup_weapon_sway_pivot(weapon_mount: Node3D) -> Node3D:
	if not weapon_mount:
		return null
	if _sway_pivot and is_instance_valid(_sway_pivot):
		return _sway_pivot
	var pivot: Node3D = Node3D.new()
	pivot.name = "WeaponSwayPivot"
	weapon_mount.add_child(pivot)
	_sway_pivot = pivot
	return pivot


func get_active_camera() -> Camera3D:
	return _active_camera
