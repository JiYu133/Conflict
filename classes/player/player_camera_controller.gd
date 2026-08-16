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
var _look_controller: PlayerLookController
var _model_lookup_config: ModelLookupConfig
var _camera_config: CameraConfig
var _player: BasePlayer
var _settings_service
var _bone_attachment: BoneAttachment3D

var _mouse_sensitivity: float
var _vertical_angle: float:
	get:
		return _look_controller.get_view_pitch() if is_instance_valid(_look_controller) else 0.0
	set(value):
		if is_instance_valid(_look_controller):
			_look_controller.set_base_pitch(value)
var _view_yaw: float:
	get:
		return _look_controller.get_base_yaw() if is_instance_valid(_look_controller) else 0.0
	set(value):
		if is_instance_valid(_look_controller):
			_look_controller.set_base_yaw(value)
var _max_vertical_angle: float

# 弹簧系统 - 3 轴独立弹簧，对头部位置在玩家局部空间做低通滤波
var _spring_x: CameraSpring1D
var _spring_y: CameraSpring1D
var _spring_z: CameraSpring1D
var _stiffness_h: float = 500.0
var _stiffness_v: float = 120.0

var _sway_pivot: Node3D = null

# 蹲下眼部高度插值
var _eye_height: float = 1.6
var _target_eye_height: float = 1.6
var _turn_height_locked: bool = false
var _turn_height_local_y: float = 0.0

# 受击疼痛镜头冲击：独立于鼠标视角和武器后座的短促阻尼弹簧。
# 位置是当前角度偏移，速度由受击瞬间注入，随后自动回到零，
# 因此不会产生《我的世界》式的持续随机抖屏。
const PAIN_STIFFNESS: float = 105.0
const PAIN_DAMPING: float = 22.0
const PAIN_MAX_PITCH: float = 0.10 # 约 5.7°
const PAIN_MAX_YAW: float = 0.07   # 约 4.0°
const PAIN_MAX_ROLL: float = 0.14  # 约 8.0°
var _pain_pitch: float = 0.0
var _pain_pitch_velocity: float = 0.0
var _pain_yaw: float = 0.0
var _pain_yaw_velocity: float = 0.0
var _pain_roll: float = 0.0
var _pain_roll_velocity: float = 0.0
var _pain_rng := RandomNumberGenerator.new()

# 布娃娃视角的轻微晃动：昏迷和死亡阶段都启用。
var _ragdoll_camera_shake_active: bool = false
var _ragdoll_camera_shake_time: float = 0.0

# 死亡摄像机跟随
var _ragdoll_skeleton: Skeleton3D = null
var _ragdoll_bone_idx: int = -1
var _ragdoll_head_bone: PhysicalBone3D = null  # 头部物理骨骼
var _ragdoll_physics_active: bool = false
var _head_spring_enabled: bool = true
const PRONE_ROLL_MAX_CAMERA_BANK: float = deg_to_rad(18.0)
var _prone_roll_camera_angle: float = 0.0
## 头部没有对应 PhysicalBone3D 时，使用颈部等最近物理父骨骼，
## 该变换把物理骨骼坐标转换为头部坐标，因此仍能保持头部位置/滚转。
var _ragdoll_head_from_physical: Transform3D = Transform3D.IDENTITY
var _ragdoll_head_conversion_valid: bool = false
## 将模型头骨骼朝向转换为死亡前玩家相机朝向，避免导入模型轴向差异造成镜头反向。
var _ragdoll_head_to_camera_basis: Basis = Basis.IDENTITY
var _ragdoll_camera_original_parent: Node = null
var _ragdoll_camera_original_transform: Transform3D = Transform3D.IDENTITY

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
	camera_config: CameraConfig,
	settings_service,
	create_local_camera: bool = true,
	look_controller: PlayerLookController = null
) -> void:
	_model_manager = model_manager
	_model_lookup_config = model_lookup_config if model_lookup_config else ModelLookupConfig.new()
	_camera_config = camera_config if camera_config else CameraConfig.new()
	_look_controller = look_controller
	_settings_service = settings_service
	_player = player
	if not is_instance_valid(_look_controller):
		_view_yaw = player.rotation.y if player else 0.0

	_spring_x = CameraSpring1D.new()
	_spring_y = CameraSpring1D.new()
	_spring_z = CameraSpring1D.new()
	_update_spring_params()
	_pain_rng.randomize()

	_hip_fov = _camera_config.fov
	# 眼部高度从 camera_config 头部偏移 Y 初始化（fallback 用）
	_eye_height = _camera_config.head_offset.y if _camera_config.head_offset.y > 0.1 else 1.6
	_target_eye_height = _eye_height

	if create_local_camera:
		var seed: Camera3D = Camera3D.new()
		seed.name = "SeedCamera"
		seed.current = true
		_player.add_child(seed)
		_player.request_mouse_mode(BasePlayer.MOUSE_OWNER_CAMERA, Input.MOUSE_MODE_CAPTURED, 0)


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
	_head_spring_enabled = true
	_ragdoll_physics_active = false
	set_ragdoll_camera_shake(false)

	if _ragdoll_skeleton:
		_ragdoll_skeleton = null
		_ragdoll_bone_idx = -1
		_ragdoll_head_bone = null
		_ragdoll_head_from_physical = Transform3D.IDENTITY
		_ragdoll_head_conversion_valid = false
		_ragdoll_head_to_camera_basis = Basis.IDENTITY
		# 恢复死亡前的真实父节点；部分模型使用自带 Camera3D，并没有 CameraMount。
		var restore_parent := _camera_mount if is_instance_valid(_camera_mount) else _ragdoll_camera_original_parent
		if is_instance_valid(_active_camera) and is_instance_valid(restore_parent):
			if _active_camera.get_parent():
				_active_camera.get_parent().remove_child(_active_camera)
			restore_parent.add_child(_active_camera)
			_active_camera.transform = _ragdoll_camera_original_transform
			_active_camera.current = true
		_ragdoll_camera_original_parent = null
		_ragdoll_camera_original_transform = Transform3D.IDENTITY
		_sync_springs_to_head()
		return

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
		var authored_head := _find_physical_bone_for_head(skeleton)
		if authored_head:
			head_idx = skeleton.find_bone(authored_head.bone_name)
	if head_idx == -1:
		return
	_ragdoll_skeleton = skeleton
	_ragdoll_bone_idx = head_idx
	_ragdoll_physics_active = false
	# 死亡视角必须直接读取布娃娃姿态；头部位置弹簧不能继续滤掉滚转。
	_head_spring_enabled = false
	_spring_x.velocity = 0.0
	_spring_y.velocity = 0.0
	_spring_z.velocity = 0.0
	# 预制 PhysicalBone3D 在模型初始化时已经存在，先立即缓存；
	# 物理启动信号后仍会再次检查，兼容导入器延迟绑定。
	_ragdoll_head_bone = _find_physical_bone_for_bone_or_ancestor(skeleton, head_idx)
	_cache_ragdoll_head_conversion()

	# 把摄像机移到场景根，脱离所有会移动的父节点，确保每帧直接写 global_transform 生效
	if is_instance_valid(_active_camera) and get_tree():
		var saved_xform := _active_camera.global_transform
		_ragdoll_camera_original_parent = _active_camera.get_parent()
		_ragdoll_camera_original_transform = _active_camera.transform
		if _active_camera.get_parent():
			_active_camera.get_parent().remove_child(_active_camera)
		get_tree().root.add_child(_active_camera)
		_active_camera.global_transform = saved_xform
		_active_camera.current = true
	if not is_instance_valid(_ragdoll_head_bone):
		GlobalLogger.warn("Camera", "Ragdoll camera waiting for PhysicalBone3D: " + skeleton.get_bone_name(head_idx))


## 布娃娃物理启动后调用（由 base_player 连接 ragdoll_physics_started 信号触发）
## 此时 PhysicalBone3D 节点已存在，可以找到并缓存
func on_ragdoll_physics_started() -> void:
	if not _ragdoll_skeleton or _ragdoll_bone_idx == -1:
		return
	var head_bone_name := _ragdoll_skeleton.get_bone_name(_ragdoll_bone_idx)
	_ragdoll_head_bone = _find_physical_bone_for_bone_or_ancestor(
		_ragdoll_skeleton, _ragdoll_bone_idx
	)
	_ragdoll_physics_active = true
	if not _ragdoll_head_conversion_valid and is_instance_valid(_ragdoll_head_bone):
		# 兼容导入器延迟填充 bone_name：此时骨架已开始由物理驱动，
		# 当前骨架姿态可用于建立一次性的头部/物理父骨骼相对变换。
		_cache_ragdoll_head_conversion()
	if _ragdoll_head_bone:
		GlobalLogger.info("Camera", "Ragdoll head bone found: " + _ragdoll_head_bone.name)
	else:
		GlobalLogger.warn("Camera", "Ragdoll PhysicalBone3D not found for: " + head_bone_name + ", falling back to skeleton pose")


## 缓存当前头部相对物理骨骼的变换。
## 这样模型只制作到 Neck 的布娃娃时，头部仍会随颈部的旋转一起翻滚。
func _cache_ragdoll_head_conversion() -> void:
	if not is_instance_valid(_ragdoll_skeleton):
		return
	var head_pose := _ragdoll_skeleton.get_bone_global_pose(_ragdoll_bone_idx)
	var head_world := _ragdoll_skeleton.global_transform * head_pose
	var camera_basis := _active_camera.global_basis.orthonormalized() if is_instance_valid(_active_camera) else Basis.IDENTITY
	_ragdoll_head_to_camera_basis = head_world.basis.orthonormalized().inverse() * camera_basis
	if is_instance_valid(_ragdoll_head_bone):
		_ragdoll_head_from_physical = _ragdoll_head_bone.global_transform.affine_inverse() * head_world
		_ragdoll_head_conversion_valid = true
	else:
		_ragdoll_head_from_physical = Transform3D.IDENTITY
		_ragdoll_head_conversion_valid = false


## 查找头部对应的物理骨骼；若模型没有头部物理骨骼，逐级回退到物理父骨骼。
func _find_physical_bone_for_bone_or_ancestor(skeleton: Skeleton3D, bone_idx: int) -> PhysicalBone3D:
	var current_idx := bone_idx
	while current_idx >= 0:
		var physical_bone := _find_physical_bone_for_skeleton_bone(skeleton.get_bone_name(current_idx))
		if is_instance_valid(physical_bone):
			return physical_bone
		current_idx = skeleton.get_bone_parent(current_idx)
	return null


func _find_physical_bone_for_skeleton_bone(bone_name: String) -> PhysicalBone3D:
	if not is_instance_valid(_ragdoll_skeleton):
		return null
	for node in _ragdoll_skeleton.find_children("*", "", true, false):
		var physical_bone := node as PhysicalBone3D
		if not physical_bone:
			continue
		# Imported scenes may expose bone_name one frame later than the node.
		if physical_bone.bone_name == bone_name:
			return physical_bone
		# Authored fallback: PhysicalBone3D node names generated by Godot retain
		# the bound skeleton bone name even when the property is not initialized.
		var node_name := physical_bone.name.to_lower().replace(" ", "")
		var expected_name := ("physicalbone" + bone_name).to_lower().replace(" ", "")
		if node_name == expected_name or node_name.ends_with(bone_name.to_lower().replace(" ", "")):
			return physical_bone
	return null


func _find_physical_bone_for_head(skeleton: Skeleton3D) -> PhysicalBone3D:
	if not is_instance_valid(skeleton):
		return null
	for node in skeleton.find_children("*", "", true, false):
		var physical_bone := node as PhysicalBone3D
		if not physical_bone:
			continue
		for candidate in _model_lookup_config.head_bone_names:
			if physical_bone.bone_name.to_lower() == String(candidate).to_lower():
				return physical_bone
			var node_name := physical_bone.name.to_lower().replace(" ", "")
			var candidate_name := String(candidate).to_lower().replace(" ", "")
			if node_name.ends_with(candidate_name):
				return physical_bone
	return null


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
# 每帧更新（核心）
# ============================================================
func _process(delta: float) -> void:
	if not _active_camera or not _camera_config:
		return

	# 即使暂时失去输入控制，也让受击镜头继续回正，避免打开菜单后
	# 冲击被冻结，关闭菜单时突然恢复一个过期的歪斜角度。
	_update_pain_impulse(delta)

	# 眼部高度平滑插值（蹲下/起立时移动摄像机 fallback 高度）
	if _eye_height != _target_eye_height:
		_eye_height = move_toward(_eye_height, _target_eye_height, 3.0 * delta)

	# 死亡模式：直接跟随头部/最近物理父骨骼，完全绕过头部位置弹簧。
	if _ragdoll_skeleton and _ragdoll_bone_idx != -1:
		if is_instance_valid(_ragdoll_skeleton):
			# PhysicalBone3D 可能在模拟器启动后才完成绑定，持续补查一次。
			if not is_instance_valid(_ragdoll_head_bone):
				_ragdoll_head_bone = _find_physical_bone_for_bone_or_ancestor(
					_ragdoll_skeleton, _ragdoll_bone_idx
				)
			var head_xform: Transform3D
			if _ragdoll_physics_active and is_instance_valid(_ragdoll_head_bone):
				# 物理阶段使用真实物理骨骼变换；缓存的相对变换会将 Neck
				# 或 Head 的姿态还原为头部姿态，并保留完整 roll。
				head_xform = _ragdoll_head_bone.global_transform * _ragdoll_head_from_physical
			else:
				# 死亡动画阶段仍直接读取动画骨骼，不经过弹簧。
				head_xform = _ragdoll_skeleton.global_transform * _ragdoll_skeleton.get_bone_global_pose(_ragdoll_bone_idx)
			# 死亡和昏迷都严格跟随布娃娃头部，完整保留物理位移、滚转和姿态。
			# 仅保留一次性轴向转换，用于适配模型头骨骼与相机前方向的差异。
			var camera_basis := (head_xform.basis.orthonormalized() * _ragdoll_head_to_camera_basis).orthonormalized()
			_active_camera.global_position = head_xform.origin
			_active_camera.global_basis = camera_basis
			return

	# 防御性保护：死亡跟随已接管相机时，正常头部弹簧永远不再推进。
	if not _head_spring_enabled:
		return

	if not controllable:
		return
	_update_prone_roll_camera(delta)
	if not is_instance_valid(_look_controller) or not _look_controller.is_free_look_active():
		_sync_moving_body_yaw()

	# 1. 读取头部在玩家局部空间的位置（弹簧不感知玩家旋转，只过滤动画位移）
	var head_local := _get_head_local_position()

	# 2. 弹簧低通滤波——ADS 时提高刚度
	var stiffness_mult: float = 1.0
	if _is_ads:
		stiffness_mult += (_camera_config.ads_stiffness_multiplier - 1.0) * _ads_progress

	# 功能性损伤：稳定性低 → 弹簧更软 → 摄像机晃动更多
	var stability := 1.0
	if is_instance_valid(_player) and _player.health_system:
		stability = _player.health_system.get_aim_stability_multiplier()
	_spring_x.stiffness = _stiffness_h * stiffness_mult * stability
	_spring_y.stiffness = _stiffness_v * stiffness_mult * stability
	_spring_z.stiffness = _stiffness_h * stiffness_mult * stability

	var lock_turn_height := _should_lock_turn_in_place_height()
	if lock_turn_height and not _turn_height_locked:
		# Capture the already rendered eye height on the first turn frame. The
		# imported turn clips move the head vertically; letting that motion enter
		# the camera spring produces a visible crouch/prone view bump.
		_turn_height_local_y = (
			_player.global_transform.affine_inverse() * _active_camera.global_position
		).y
		_spring_y.position = _turn_height_local_y
		_spring_y.velocity = 0.0
		_turn_height_locked = true
	elif not lock_turn_height and _turn_height_locked:
		# Resume from the locked value so releasing the turn cannot snap to the
		# current animation frame.
		_spring_y.position = _turn_height_local_y
		_spring_y.velocity = 0.0
		_turn_height_locked = false

	var filtered_local := Vector3(
		_spring_x.update(delta, head_local.x),
		_turn_height_local_y if _turn_height_locked else _spring_y.update(delta, head_local.y),
		_spring_z.update(delta, head_local.z)
	)

	# 3. 局部空间转全局——玩家旋转正确携带，鼠标转头不触发弹簧。
	# The roll animation may rotate the head bone through arbitrary imported
	# axes. Keep the first-person view driven by look input and add only a small
	# cosmetic bank, otherwise the camera can reverse or point at the ground.
	_active_camera.global_position = _player.global_transform * filtered_local
	_active_camera.global_rotation = Vector3(
		get_vertical_angle() + _pain_pitch,
		get_view_yaw() + _pain_yaw,
		_pain_roll + _prone_roll_camera_angle
	)

	_update_ads(delta)
	_update_weapon_spring(delta)


func _should_lock_turn_in_place_height() -> bool:
	if not is_instance_valid(_player) or not _player.turn_controller:
		return false
	var horizontal_velocity := Vector2(_player.velocity.x, _player.velocity.z)
	return _player.turn_controller.is_turning() and horizontal_velocity.length_squared() < 0.0001


# ============================================================
# 头部位置读取（玩家局部空间）
# ============================================================
func _get_head_local_position() -> Vector3:
	if _bone_attachment and is_instance_valid(_bone_attachment) and is_instance_valid(_player):
		var bone_local := _player.global_transform.affine_inverse() * _bone_attachment.global_position
		return bone_local + _camera_config.head_offset
	elif is_instance_valid(_player):
		return Vector3(0, _eye_height, 0)
	return Vector3.ZERO


## 响应姿态变化，更新摄像机眼部目标高度
## Public value interface; the camera does not retain a stance component.
func apply_stance_value(value: float) -> void:
	if not _player or not _player.player_config:
		return
	var config = _player.player_config
	_target_eye_height = lerp(
		config.camera_stand_eye_height,
		config.camera_crouch_eye_height,
		value
	)


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
# 受击镜头冲击
# ============================================================
## 施加一次受击疼痛镜头冲击。
## world_direction 是弹头飞向玩家的方向；amount 使用 DamageInfo 的动能（焦耳）。
## 角度会根据受击左右方向决定，方向未知时只补一个很小的随机左右偏移。
func add_pain_impulse(world_direction: Vector3, amount: float, intensity: float = 1.0) -> void:
	if not is_instance_valid(_player) or not controllable:
		return
	var camera_impact := clampf(float(_settings_service.get_value("graphics/hit_camera_impact", 1.0)), 0.0, 1.0) if _settings_service else 1.0
	if camera_impact <= 0.0:
		return

	var direction := world_direction.normalized()
	var local_direction := _player.global_basis.inverse() * direction if direction != Vector3.ZERO else Vector3.ZERO
	var side := clampf(local_direction.x, -1.0, 1.0)
	if absf(side) < 0.1:
		# 正面/背面命中没有可靠的左右信息；轻微随机即可避免每次都向同侧歪。
		side = -1.0 if _pain_rng.randf() < 0.5 else 1.0

	var energy_scale := clampf(amount / 600.0, 0.15, 1.0)
	var impulse_scale := clampf(intensity, 0.35, 1.0) * energy_scale * camera_impact
	# 受击方向只影响短促的上下/水平错动，主要视觉重点放在横滚疼痛感。
	_pain_pitch_velocity += clampf(-local_direction.y * 0.55, -0.55, 0.55) * impulse_scale
	_pain_yaw_velocity += -side * 0.38 * impulse_scale
	_pain_roll_velocity += -side * 1.20 * impulse_scale


## 清除受击冲击（死亡、昏迷或复活切换时使用）。
func clear_pain_impulse() -> void:
	_pain_pitch = 0.0
	_pain_pitch_velocity = 0.0
	_pain_yaw = 0.0
	_pain_yaw_velocity = 0.0
	_pain_roll = 0.0
	_pain_roll_velocity = 0.0


func _update_pain_impulse(delta: float) -> void:
	_pain_pitch_velocity += (-PAIN_STIFFNESS * _pain_pitch - PAIN_DAMPING * _pain_pitch_velocity) * delta
	_pain_yaw_velocity += (-PAIN_STIFFNESS * _pain_yaw - PAIN_DAMPING * _pain_yaw_velocity) * delta
	_pain_roll_velocity += (-PAIN_STIFFNESS * _pain_roll - PAIN_DAMPING * _pain_roll_velocity) * delta
	_pain_pitch += _pain_pitch_velocity * delta
	_pain_yaw += _pain_yaw_velocity * delta
	_pain_roll += _pain_roll_velocity * delta
	_pain_pitch = clampf(_pain_pitch, -PAIN_MAX_PITCH, PAIN_MAX_PITCH)
	_pain_yaw = clampf(_pain_yaw, -PAIN_MAX_YAW, PAIN_MAX_YAW)
	_pain_roll = clampf(_pain_roll, -PAIN_MAX_ROLL, PAIN_MAX_ROLL)


## 设置布娃娃阶段的轻微镜头晃动。
func set_ragdoll_camera_shake(active: bool) -> void:
	_ragdoll_camera_shake_active = active
	if not active:
		_ragdoll_camera_shake_time = 0.0


func _update_ragdoll_camera_shake(delta: float) -> Dictionary:
	var shake_scale := clampf(float(_settings_service.get_value("graphics/death_camera_shake", 1.0)), 0.0, 1.0) if _settings_service else 1.0
	if not _ragdoll_camera_shake_active or shake_scale <= 0.0:
		return {"position": Vector3.ZERO, "rotation": Vector3.ZERO, "basis": Basis.IDENTITY}
	_ragdoll_camera_shake_time += delta
	var t := _ragdoll_camera_shake_time
	var rotation_offset := Vector3(
		sin(t * 7.1) * 0.005 + sin(t * 12.8 + 0.7) * 0.002,
		sin(t * 5.7 + 1.4) * 0.004 + cos(t * 10.3) * 0.0015,
		sin(t * 4.8 + 2.0) * 0.010 + cos(t * 8.6) * 0.003
	)
	var position_offset := Vector3(
		sin(t * 6.3) * 0.0025,
		cos(t * 5.1 + 0.5) * 0.0020,
		sin(t * 4.2 + 1.1) * 0.0015
	)
	return {
		"position": position_offset * shake_scale,
		"rotation": rotation_offset * shake_scale,
		"basis": Basis(Vector3.RIGHT, rotation_offset.x * shake_scale) * Basis(Vector3.UP, rotation_offset.y * shake_scale) * Basis(Vector3.FORWARD, rotation_offset.z * shake_scale)
	}


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

func set_prone_roll_camera_angle(angle: float) -> void:
	_prone_roll_camera_angle = angle


func _update_prone_roll_camera(delta: float) -> void:
	if _player and _player.movement_controller and _player.movement_controller.is_prone_rolling():
		var progress := _player.movement_controller.get_prone_roll_progress()
		var direction := _player.movement_controller.get_prone_roll_direction()
		# A half-sine gives one readable bank and returns to a level horizon at
		# the end without ever flipping the player's view upside down.
		# Camera3D looks along -Z, so its screen-space bank uses the opposite
		# sign from the player's lateral input (right roll = negative Z bank).
		_prone_roll_camera_angle = -direction * sin(progress * PI) * PRONE_ROLL_MAX_CAMERA_BANK
		return
	_prone_roll_camera_angle = wrapf(
		lerp_angle(
			_prone_roll_camera_angle,
			0.0,
			clampf(delta * 14.0, 0.0, 1.0)
		),
		-PI,
		PI
	)


func get_base_mouse_sensitivity() -> float:
	return _mouse_sensitivity


func get_vertical_angle() -> float:
	return _look_controller.get_view_pitch() if is_instance_valid(_look_controller) else 0.0


func get_base_vertical_angle() -> float:
	return _look_controller.get_base_pitch() if is_instance_valid(_look_controller) else 0.0


func get_free_pitch_offset() -> float:
	return _look_controller.get_free_pitch_offset() if is_instance_valid(_look_controller) else 0.0


func get_free_yaw_offset() -> float:
	return _look_controller.get_free_yaw_offset() if is_instance_valid(_look_controller) else 0.0


func get_view_yaw() -> float:
	return _look_controller.get_view_yaw() if is_instance_valid(_look_controller) else 0.0


func get_base_view_yaw() -> float:
	return _look_controller.get_base_yaw() if is_instance_valid(_look_controller) else _view_yaw

func get_body_yaw_offset() -> float:
	return _look_controller.get_body_yaw_offset() if is_instance_valid(_look_controller) else 0.0


func get_visual_body_yaw_offset() -> float:
	return _look_controller.get_visual_body_yaw_offset() if is_instance_valid(_look_controller) else get_body_yaw_offset()

func get_view_basis() -> Basis:
	return _look_controller.get_movement_basis() if is_instance_valid(_look_controller) else Basis(Vector3.UP, _view_yaw)


func _sync_moving_body_yaw() -> void:
	if not is_instance_valid(_player) or not _player.is_on_floor() or not _is_moving():
		return
	# Landing keeps horizontal velocity for a few frames. Do not let the
	# locomotion follow path snap the body before TurnController evaluates the
	# pending view offset and starts the authored turn clip.
	if _player.turn_controller and _player.turn_controller.is_turning():
		return
	if _player.animation_controller and _player.animation_controller.get_current_state() == PlayerAnimationController.State.LAND:
		return
	if is_instance_valid(_look_controller) and _look_controller.is_free_look_active():
		return
	if is_instance_valid(_player):
		if _body_yaw_blend_remaining <= 0.0:
			_player.rotation.y = get_base_view_yaw()


var _body_yaw_blend_remaining: float = 0.0
var _body_yaw_blend_duration: float = 0.0
var _body_yaw_blend_start: float = 0.0
var _body_yaw_blend_target: float = 0.0


func begin_moving_body_yaw_blend(duration: float) -> void:
	_body_yaw_blend_duration = maxf(duration, 0.001)
	_body_yaw_blend_remaining = _body_yaw_blend_duration
	_body_yaw_blend_start = _player.rotation.y if is_instance_valid(_player) else _view_yaw
	_body_yaw_blend_target = get_base_view_yaw()


func process_moving_body_yaw_blend(delta: float) -> void:
	if _body_yaw_blend_remaining <= 0.0 or not is_instance_valid(_player):
		return
	_body_yaw_blend_remaining = maxf(_body_yaw_blend_remaining - delta, 0.0)
	var weight := 1.0 - (_body_yaw_blend_remaining / _body_yaw_blend_duration)
	# Smoothstep keeps angular velocity continuous at both ends and avoids the
	# large final snap produced by repeatedly lerping from the current yaw.
	weight = weight * weight * (3.0 - 2.0 * weight)
	_player.rotation.y = lerp_angle(_body_yaw_blend_start, _body_yaw_blend_target, clampf(weight, 0.0, 1.0))
	if _body_yaw_blend_remaining <= 0.0:
		_player.rotation.y = _body_yaw_blend_target


func is_body_yaw_blending() -> bool:
	return _body_yaw_blend_remaining > 0.0


func _is_moving() -> bool:
	if not is_instance_valid(_player):
		return false
	var horizontal_velocity := Vector2(_player.velocity.x, _player.velocity.z)
	return horizontal_velocity.length_squared() > 0.01
