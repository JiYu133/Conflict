class_name PlayerCameraController
extends Node

# ============================================================
# 玩家摄像机控制器
# 功能：管理第一人称视角的摄像机挂载、鼠标视角控制。
#       支持三种相机位置获取方式（优先级递减）：
#         1. 模型场景中预设的 CameraMount 节点（挂载点）
#         2. 模型场景自带 Camera3D
#         3. 从头部骨骼动态创建 Marker3D 挂载点（回退方案）
#
#       程序化摄像机效果（均可通过 CameraConfig 单独开关）：
#         - 头部摆动（Head Bob）：基于水平速度的 sine 波叠加，
#           产生 figure-8 轨迹模拟步伐重心起伏
#         - 武器晃动（Weapon Sway）：鼠标运动 + 移动速度双层
#           偏移，经 lerp 平滑归位，模拟持枪惯性
#         - 落地冲击（Landing Impact）：落地/起跳时对摄像机施加
#           弹簧冲量，产生自然衰减的下沉/回弹
#         - 呼吸摆动（Breathing）：静止或低速时叠加低频 sine 漂移，
#           模拟持枪自然呼吸感
#         - 后座（Recoil）：从 RecoilComponent 读取累积后座角度，
#           叠加到摄像机垂直与水平旋转
#
#       所有效果均为独立层，最终做加法合成到摄像机变换，
#       互不干扰，可单独调整或关闭。
#
# 依赖：PlayerModelManager / ModelLookupConfig / CameraConfig
#       依赖 CharacterBody3D 的 rotate_y 实现水平视角
# ============================================================


# ============================================================
# 内部弹簧阻尼工具类
# 用于落地冲击等需要物理感衰减的摄像机效果
# ============================================================
class CameraSpring:
	var position: float = 0.0   # 当前位移（m）
	var velocity: float = 0.0   # 当前速度（m/s）
	var stiffness: float = 180.0
	var damping: float = 16.0

	## 每帧更新弹簧状态，返回当前位移
	func update(delta: float, target: float = 0.0) -> float:
		var force: float = -stiffness * (position - target) - damping * velocity
		velocity += force * delta
		position += velocity * delta
		return position

	## 施加瞬时速度冲量（正值向上，负值向下）
	func add_impulse(impulse: float) -> void:
		velocity += impulse

	## 重置弹簧到静止状态
	func reset() -> void:
		position = 0.0
		velocity = 0.0


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
var _camera_config: CameraConfig          # 摄像机配置
var _player: CharacterBody3D             # 玩家角色

var _mouse_sensitivity: float             # 鼠标灵敏度（弧度/像素）
var _vertical_angle: float = 0.0         # 当前垂直视角角度（弧度）
var _max_vertical_angle: float           # 最大垂直角度，约 80 度（1.4 弧度）

# 头部摆动（Head Bob）─────────────────────────────────────
var _bob_phase: float = 0.0              # Lissajous 相位累加器（完整周期数）
var _bob_offset: Vector3 = Vector3.ZERO  # 当前摆动偏移量（局部空间，供 lerp 归零用）

# 武器晃动（Weapon Sway）──────────────────────────────────
var _sway_pivot: Node3D = null                 # 晃动支点节点（挂在 WeaponMount 下）
var _sway_target_rot: Vector3 = Vector3.ZERO   # 目标旋转（由鼠标输入驱动）
var _sway_target_pos: Vector3 = Vector3.ZERO   # 目标位置偏移（由移动速度驱动）
var _mouse_delta: Vector2 = Vector2.ZERO       # 当前帧累积鼠标移动量

# 落地冲击（Landing Impact Spring）───────────────────────
var _land_spring: CameraSpring             # 垂直位置弹簧，落地/起跳时施加冲量
var _pitch_spring: CameraSpring            # 俯仰旋转弹簧，产生头部前点/后仰动画
var _air_y_velocity: float = 0.0          # 空中最大下落速度（落地时用于缩放冲击幅度）

# 呼吸摆动（Breathing）────────────────────────────────────
var _breathe_phase: float = 0.0            # 呼吸相位累加器（完整周期数）

# 速度倾斜（Tilt）────────────────────────────────────────
var _tilt_angle: float = 0.0               # 当前 Z 轴倾斜角度（弧度）

# 后座引用（Recoil）────────────────────────────────────────
## 由外部在武器加载后通过 set_recoil_component() 注入
var _recoil_component: RecoilComponent = null


# ============================================================
# 初始化（由 BasePlayer 调用）
# ============================================================
func initialize(
	player: CharacterBody3D,
	model_manager: PlayerModelManager,
	model_lookup_config: ModelLookupConfig,
	camera_config: CameraConfig
) -> void:
	_model_manager = model_manager
	_model_lookup_config = model_lookup_config if model_lookup_config else ModelLookupConfig.new()
	_camera_config = camera_config if camera_config else CameraConfig.new()
	_player = player

	# 初始化落地弹簧（参数来自配置；initialize 时配置已赋值）
	_land_spring = CameraSpring.new()
	_land_spring.stiffness = _camera_config.land_impact_stiffness
	_land_spring.damping   = _camera_config.land_impact_damping

	_pitch_spring = CameraSpring.new()
	_pitch_spring.stiffness = _camera_config.land_pitch_stiffness
	_pitch_spring.damping   = _camera_config.land_pitch_damping

	# 创建备用摄像机防止 Godot 视口空窗
	# 在真实摄像机挂载前，先用这个占位
	var seed: Camera3D = Camera3D.new()
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
	_mouse_sensitivity = _camera_config.mouse_sensitivity
	_max_vertical_angle = _camera_config.max_vertical_angle

	var viewport: Viewport = get_viewport()
	if not viewport:
		push_warning("没有找到有效视口")
		return

	# 优先级：挂载点 > 模型摄像机 > 从骨骼创建
	var viewport_camera: Camera3D = viewport.get_camera_3d()

	if _camera_mount:
		_attach_to_mount(viewport_camera, _camera_mount)
	elif _model_camera:
		_model_camera.current = true
		_active_camera = _model_camera
	else:
		_create_mount_from_skeleton(viewport_camera)

	camera_ready.emit(_active_camera)

	# 应用 FOV（摄像机就绪后才能设置）
	if _active_camera:
		_active_camera.fov = _camera_config.fov


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
	var cameras: Array = _model_manager.model_node.find_children("*", "Camera3D", true, false)
	_model_camera = cameras[0] if cameras.size() > 0 else null

	# 找到后立即挂载
	if _camera_mount:
		var cam: Camera3D = get_viewport().get_camera_3d()
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
		var seed: Node = _player.find_child("SeedCamera", false, false)
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
	var skeleton: Skeleton3D = _model_manager.skeleton
	if not skeleton:
		push_warning("无法从骨骼创建挂载点：没有骨骼系统")
		return

	# 遍历候选头部骨骼名称列表，找到第一个存在的骨骼
	for bone_name in _model_lookup_config.head_bone_names:
		var bone_idx: int = skeleton.find_bone(bone_name)
		if bone_idx != -1:
			# 在骨骼下创建 Marker3D 作为挂载点
			var mount: Marker3D = Marker3D.new()
			mount.name = "CameraMount_Auto"
			skeleton.add_child(mount)

			# 将挂载点定位到骨骼的世界空间位置
			var bone_pose: Transform3D = skeleton.get_bone_global_pose(bone_idx)
			mount.global_position = skeleton.global_transform * bone_pose.origin

			_camera_mount = mount
			_attach_to_mount(camera, mount)
			return

	push_warning("未找到合适的头部骨骼")


# ============================================================
# 视角控制（每帧处理鼠标输入）
# ============================================================

func _input(event: InputEvent) -> void:
	var active_camera: Camera3D = get_viewport().get_camera_3d()
	if not active_camera:
		return

	if event is not InputEventMouseMotion:
		return

	# 水平旋转：绕 Y 轴旋转整个 BasePlayer
	# 这样可以保持移动方向与视角方向一致
	var player: Node = get_parent()  # CameraController 的父节点是 BasePlayer
	if player and player is CharacterBody3D:
		player.rotate_y(-event.relative.x * _mouse_sensitivity)
	else:
		push_warning("玩家不存在或类型错误！")

	# 垂直旋转：绕 X 轴旋转摄像机本身
	# 限制范围防止翻转（-max ~ +max 弧度）
	_vertical_angle -= event.relative.y * _mouse_sensitivity
	_vertical_angle = clamp(_vertical_angle, -_max_vertical_angle, _max_vertical_angle)

	# 累积鼠标移动量，供武器晃动在 _process 中使用
	_mouse_delta += event.relative


# ============================================================
# 程序化摄像机效果（每帧更新）
# 所有效果各自计算增量，最后加法合成到摄像机变换，互不干扰
# ============================================================

func _process(delta: float) -> void:
	if not _active_camera or not _camera_config:
		_mouse_delta = Vector2.ZERO
		return

	# 空中时追踪下落速度，落地时用于缩放冲击幅度
	if not _player.is_on_floor():
		_air_y_velocity = min(_air_y_velocity, _player.velocity.y)

	# 各层独立计算位置偏移
	var pos_offset: Vector3 = Vector3.ZERO
	pos_offset += _update_head_bob(delta)
	pos_offset += _update_breathing(delta)
	pos_offset += _update_land_impact(delta)

	_active_camera.position = pos_offset

	# 垂直视角 = 鼠标控制角度 + 垂直后座 + pitch 弹簧（跳跃/落地动画）
	var recoil_pitch: float = _get_recoil_pitch()
	var pitch_spring_offset: float = 0.0
	if _pitch_spring:
		pitch_spring_offset = _pitch_spring.update(delta, 0.0)
	_active_camera.rotation.x = _vertical_angle + recoil_pitch + pitch_spring_offset

	# 水平后座
	var recoil_yaw: float = _get_recoil_yaw()
	if recoil_yaw != 0.0 and _player:
		_player.rotate_y(recoil_yaw * delta)

	_update_weapon_sway(delta)
	_update_tilt(delta)


# ============================================================
# 层 1：头部摆动（Head Bob）
# 基于水平速度驱动 sine 波，产生 figure-8 轨迹
# 垂直分量使用全频，水平分量使用半频，合成自然步伐感
# ============================================================

func _update_head_bob(delta: float) -> Vector3:
	if not _camera_config.bob_enabled:
		return Vector3.ZERO

	var h_vel: Vector2 = Vector2(_player.velocity.x, _player.velocity.z)
	var h_speed: float = h_vel.length()
	var is_on_floor: bool = _player.is_on_floor()

	if is_on_floor and h_speed > 0.1:
		var is_running: bool = h_speed > _camera_config.walk_speed_reference * 1.1
		var freq: float = _camera_config.bob_frequency_run if is_running else _camera_config.bob_frequency_walk

		# fmod 防止长时间运行浮点精度劣化
		_bob_phase = fmod(_bob_phase + delta * freq, 1.0)

		# 振幅随速度线性缩放：低速时摆动小，奔跑时摆动大
		var speed_t: float = clamp(h_speed / max(_camera_config.max_speed_reference, 0.001), 0.0, 1.0)
		var amp_v: float = _camera_config.bob_amplitude_vertical   * speed_t
		var amp_h: float = _camera_config.bob_amplitude_horizontal * speed_t

		# figure-8 轨迹：垂直全频，水平半频
		var vert:  float = sin(_bob_phase * TAU) * amp_v
		var horiz: float = sin(_bob_phase * PI)  * amp_h

		_bob_offset = Vector3(horiz, vert, 0.0)
	else:
		_bob_offset = _bob_offset.lerp(Vector3.ZERO, delta * _camera_config.bob_return_speed)
		if _bob_offset.length_squared() < 0.000001:
			_bob_phase = 0.0

	return _bob_offset


# ============================================================
# 层 2：呼吸摆动（Breathing）
# 静止或低速时叠加低频 sine 漂移，模拟持枪呼吸感
# 速度超过 breathe_max_speed 时线性淡出，与步态摆动平滑交接
# ============================================================

func _update_breathing(delta: float) -> Vector3:
	if not _camera_config.breathe_enabled:
		return Vector3.ZERO

	var h_speed: float = Vector2(_player.velocity.x, _player.velocity.z).length()
	# breathe_max_speed 时权重为 0，静止时权重为 1
	# max(…, 0.001) 防止除零（若配置值为 0 则效果始终全强度）
	var weight: float = 1.0 - clamp(h_speed / max(_camera_config.breathe_max_speed, 0.001), 0.0, 1.0)
	if weight <= 0.0:
		return Vector3.ZERO

	_breathe_phase = fmod(_breathe_phase + delta * _camera_config.breathe_frequency, 1.0)

	var vert:  float = sin(_breathe_phase * TAU)       * _camera_config.breathe_amplitude_vertical
	var horiz: float = sin(_breathe_phase * TAU * 0.5) * _camera_config.breathe_amplitude_horizontal

	return Vector3(horiz, vert, 0.0) * weight


# ============================================================
# 层 3：落地冲击（Landing Impact）
# 落地/起跳时对弹簧施加冲量，弹簧自然衰减产生下沉/回弹
# 冲量由 PlayerMovementController 的信号触发（在 connect_movement_signals 中绑定）
# ============================================================

func _update_land_impact(delta: float) -> Vector3:
	if not _camera_config.land_impact_enabled or not _land_spring:
		return Vector3.ZERO

	# 更新弹簧朝静止位置收敛，返回当前 Y 偏移
	var spring_y: float = _land_spring.update(delta, 0.0)
	return Vector3(0.0, spring_y, 0.0)


## 落地时由外部信号调用，给弹簧施加向下冲量 + 头部前点
func on_landed() -> void:
	if not _camera_config or not _camera_config.land_impact_enabled:
		_air_y_velocity = 0.0
		return

	# 按下落速度缩放冲击幅度（落得越重动静越大），最小保留基础值
	var velocity_scale: float = 1.0 + abs(_air_y_velocity) * _camera_config.land_impact_velocity_scale
	_air_y_velocity = 0.0

	# 位置弹簧：向下冲量（负值 = 摄像机下沉）
	_land_spring.add_impulse(-_camera_config.land_impact_impulse * velocity_scale)

	# pitch 弹簧：向前点头（正值 = pitch 前倾）
	if _pitch_spring:
		_pitch_spring.add_impulse(_camera_config.land_pitch_impulse * velocity_scale)


## 起跳时由外部信号调用，给位置弹簧上抬 + 头部轻微后仰
func on_jumped() -> void:
	if not _camera_config or not _camera_config.land_impact_enabled:
		return
	_air_y_velocity = 0.0

	# 位置弹簧：向上轻推
	_land_spring.add_impulse(_camera_config.jump_lift_impulse)

	# pitch 弹簧：轻微后仰（负值 = pitch 后仰）
	if _pitch_spring:
		_pitch_spring.add_impulse(-_camera_config.jump_pitch_impulse)


# ============================================================
# 层 4：后座（Recoil）
# 从 RecoilComponent 读取已累积的后座角度，叠加到垂直视角
# 不修改 _vertical_angle，仅在写入摄像机时临时偏移，
# 确保后座视觉效果与准星控制解耦
# ============================================================

## 注入 RecoilComponent 引用（在武器装备后由 BasePlayer 调用）
func set_recoil_component(rc: RecoilComponent) -> void:
	_recoil_component = rc


## 返回当前帧应叠加到摄像机 pitch 的后座角度（弧度）
func _get_recoil_pitch() -> float:
	if not _recoil_component:
		return 0.0
	return _recoil_component.get_recoil_offset()


## 返回当前帧应叠加到玩家 yaw 的水平后座角度（弧度/秒，由调用方乘 delta）
func _get_recoil_yaw() -> float:
	if not _recoil_component:
		return 0.0
	return _recoil_component.get_recoil_horizontal_offset()


# ============================================================
# 武器晃动（Weapon Sway）
# 双层效果，作用于 _sway_pivot，不影响摄像机旋转
#   层 A（look sway）：鼠标移动时武器向反方向微微倾斜，模拟惯性滞后
#   层 B（move sway）：移动速度在武器局部空间产生位置偏移，模拟持枪重量
# ============================================================

func _update_weapon_sway(delta: float) -> void:
	if not _camera_config.sway_enabled or not _sway_pivot:
		_mouse_delta = Vector2.ZERO
		return

	# 层 A：look sway — 鼠标输入驱动旋转目标
	var look_amount: float = _camera_config.sway_look_amount
	_sway_target_rot = Vector3(
		_mouse_delta.y * look_amount,
		0.0,
		_mouse_delta.x * look_amount
	)
	_mouse_delta = Vector2.ZERO

	# 层 B：move sway — 水平速度在武器局部坐标系产生位置偏移
	var move_amount: float = _camera_config.sway_move_amount
	var local_vel: Vector3 = _player.global_transform.basis.inverse() * _player.velocity
	_sway_target_pos = Vector3(
		-local_vel.x * move_amount * 0.01,
		-local_vel.y * move_amount * 0.005,
		0.0
	)

	var t: float = clamp(delta * _camera_config.sway_speed, 0.0, 1.0)
	_sway_pivot.rotation = _sway_pivot.rotation.lerp(_sway_target_rot, t)
	# 只插值 X/Y，Z 轴留给 WeaponObstructionDetector 控制收枪偏移
	_sway_pivot.position.x = lerp(_sway_pivot.position.x, _sway_target_pos.x, t) as float
	_sway_pivot.position.y = lerp(_sway_pivot.position.y, _sway_target_pos.y, t) as float


# ============================================================
# 层 5：速度倾斜（Tilt）
# 根据角色局部坐标系的横向速度，将摄像机沿 Z 轴轻微倾斜
# 向右跑 → 相机左倾，向左跑 → 相机右倾，模拟重心偏移感
# ============================================================

func _update_tilt(delta: float) -> void:
	if not _camera_config.tilt_enabled:
		_tilt_angle = 0.0
		if _active_camera:
			_active_camera.rotation.z = 0.0
		return

	# 将世界空间速度转换到玩家局部坐标系，取 X 分量（向右为正）
	var local_vel: Vector3 = _player.global_transform.basis.inverse() * _player.velocity
	var lateral_speed: float = local_vel.x

	# 速度越大倾斜越大，钳制在最大角度内；方向取反（向右跑 → 左倾）
	var max_speed: float = max(_camera_config.max_speed_reference, 0.001)
	var target_tilt: float = -clamp(lateral_speed / max_speed, -1.0, 1.0) * _camera_config.tilt_max_angle

	# 平滑插值到目标角度
	_tilt_angle = lerp(_tilt_angle, target_tilt, clamp(delta * _camera_config.tilt_speed, 0.0, 1.0))
	_active_camera.rotation.z = _tilt_angle


# ============================================================
# 公开 API
# ============================================================

## 创建武器晃动支点节点，返回该支点以便调用方重定向武器挂载
## 由外部（BasePlayer._on_model_loaded）在 WeaponMount 就绪后调用
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


## 连接移动控制器信号，用于接收落地/起跳事件
## 由 BasePlayer 在子系统初始化完成后调用
func connect_movement_signals(movement: PlayerMovementController) -> void:
	if not movement.landed.is_connected(on_landed):
		movement.landed.connect(on_landed)
	if not movement.jumped.is_connected(on_jumped):
		movement.jumped.connect(on_jumped)


## 返回当前活动摄像机，供 WeaponObstructionDetector 等外部系统使用
func get_active_camera() -> Camera3D:
	return _active_camera


# ============================================================
# 辅助工具（可按需移除，仅调试时使用）
# ============================================================

## 递归查找指定名称的节点
func _find_node_recursive(parent: Node, target_name: String) -> Node:
	for child in parent.get_children():
		if child.name == target_name:
			return child
		var found: Node = _find_node_recursive(child, target_name)
		if found:
			return found
	return null

## 打印节点树（调试用）
func _print_node_tree(node: Node, indent: String) -> void:
	print(indent + node.name + " (" + node.get_class() + ")")
	for child in node.get_children():
		_print_node_tree(child, indent + "  ")
