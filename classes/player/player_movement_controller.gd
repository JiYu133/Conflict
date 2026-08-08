class_name PlayerMovementController
extends Node

# ============================================================
# 玩家移动控制器（新运动系统）
# 功能：处理玩家（CharacterBody3D）的全部移动逻辑。
# 新增机制：起步爆发、步态波动、转向减速（dot product）、
#           停止卸力、方向速度上限（横向/后退）。
# 跳跃、重力、空中逻辑与旧版保持不变。
# ============================================================

# 信号 ────────────────────────────────────────────────────
signal jumped
## 起跳
signal landed
## 落地（is_on_floor 上升沿触发）
signal started_running
## 开始奔跑（单击 Shift 切换，持枪快步）
signal stopped_running
## 停止奔跑
signal started_sprinting
## 开始冲刺（长按 Shift，全力疾跑）
signal stopped_sprinting
## 停止冲刺


# 私有变量 ────────────────────────────────────────────────
var _player: BasePlayer
var _config: PlayerConfig
var _velocity: Vector3
var _is_running: bool = false
var _is_sprinting: bool = false
var _was_on_floor: bool = true
var _was_controllable: bool = true

var _gait_phase: float = 0.0
var _burst_timer: float = 0.0
var _had_input: bool = false

var _shift_held_time: float = 0.0
var _shift_was_held: bool = false

var _camera_controller: PlayerCameraController = null


func is_running() -> bool:
	return _is_running

func is_sprinting() -> bool:
	return _is_sprinting

func get_max_speed() -> float:
	if not _config:
		return 4.0
	var base: float
	if _is_sprinting:
		base = _config.sprint_speed
	elif _is_running:
		base = _config.run_speed
	else:
		# 根据姿态插值速度：站立=walk_speed, 蹲下=crouch_speed
		var stance = _player.stance_controller.get_stance_value() if _player.stance_controller else 0.0
		base = lerp(_config.walk_speed, _config.crouch_speed, stance)
	if _player and _player.health_system:
		base *= _player.health_system.get_movement_speed_multiplier()
	return base


func initialize(player: BasePlayer, config: PlayerConfig, camera_controller: PlayerCameraController) -> void:
	_player = player
	_config = config
	_camera_controller = camera_controller
	_velocity = Vector3.ZERO


func _physics_process(delta: float) -> void:
	if not _player or not _config:
		return
	if not _player.controllable:
		if _was_controllable:
			clear_locomotion_state()
		_was_controllable = false
		# 死亡或布娃娃激活时停止所有物理移动，让布娃娃自己处理物理
		if not _player.is_alive or _player.is_ragdolled:
			_velocity = Vector3.ZERO
			_player.velocity = Vector3.ZERO
			return
		# 存活但不可控（菜单/自由视角）：应用重力 + 制动滑停，不瞬间清零
		if not _player.is_on_floor():
			_velocity.y -= _config.gravity * delta
		else:
			_velocity.y = _config.floor_snap_velocity
		# 水平制动与地面判定无关：菜单/自由视角接管时，
		# 即使角色正在空中或处于斜坡判定过渡，也必须消化已有水平速度。
		_velocity.x = move_toward(_velocity.x, 0.0, _config.stop_brake_strength * delta)
		_velocity.z = move_toward(_velocity.z, 0.0, _config.stop_brake_strength * delta)
		_player.velocity = _velocity
		_player.move_and_slide()
		_velocity = _player.velocity
		return
	_was_controllable = true

	# ──────────────────────────────────────────────────────
	# 1. 读取输入方向
	# ──────────────────────────────────────────────────────
	var input_dir := Input.get_vector(
		"move_left", "move_right",
		"move_forward", "move_backward"
	)
	var has_input := input_dir.length() > _config.input_dead_zone

	# ──────────────────────────────────────────────────────
	# 2. Shift 按压检测：区分单击（切换 Run）和长按（Sprint）
	# ──────────────────────────────────────────────────────
	var shift_held := Input.is_action_pressed("sprint")
	var has_forward := Input.is_action_pressed("move_forward")

	# 下降沿：Shift 刚松开
	if _shift_was_held and not shift_held:
		var threshold := _config.sprint_hold_threshold if _config else 0.25
		if _shift_held_time < threshold:
			# 短按 → 切换 Run（不触发 Sprint）
			if _is_sprinting:
				_exit_sprint()
			else:
				_toggle_run()
		else:
			# 长按松开 → 退出 Sprint
			if _is_sprinting:
				_exit_sprint()
		_shift_held_time = 0.0
	# 上升沿：Shift 刚按下，重置计时
	elif not _shift_was_held and shift_held:
		_shift_held_time = 0.0
	# 持续按住：累计时间，达到阈值后激活 Sprint
	elif shift_held:
		_shift_held_time += delta
		var threshold := _config.sprint_hold_threshold if _config else 0.25
		if _shift_held_time >= threshold and has_forward and not _is_sprinting:
			_enter_sprint()

	_shift_was_held = shift_held

	# Sprint 失去前进输入时自动退出
	if _is_sprinting and not has_forward:
		_exit_sprint()

	# ──────────────────────────────────────────────────────
	# 3. 地面水平速度
	# ──────────────────────────────────────────────────────
	if _player.is_on_floor():
		# 3a. 确定基础目标速度（与 get_max_speed() 保持一致的优先级）
		var speed: float
		if _is_sprinting:
			speed = _config.sprint_speed
		elif _is_running:
			speed = _config.run_speed
		else:
			# 根据姿态插值速度
			var stance = _player.stance_controller.get_stance_value() if _player.stance_controller else 0.0
			speed = lerp(_config.walk_speed, _config.crouch_speed, stance)
		# 功能性损伤乘数
		if _player.health_system:
			speed *= _player.health_system.get_movement_speed_multiplier()

		if has_input:
			var basis := _player.global_basis
			var direction := (basis.x * input_dir.x + basis.z * input_dir.y).normalized()

			# 3b. 方向速度上限：横向 80%、后退 70%
			var forward_dot: float = direction.dot(-basis.z)
			var side_dot: float    = abs(direction.dot(basis.x))
			if forward_dot < _config.backward_dot_threshold:
				speed *= _config.backward_speed_ratio
			elif side_dot > _config.lateral_dot_threshold:
				speed *= _config.lateral_speed_ratio

			# 3c. 转向减速（dot product，世界空间对比）
			var h_vel_2d := Vector2(_velocity.x, _velocity.z)
			if h_vel_2d.length_squared() > _config.turn_decel_min_speed * _config.turn_decel_min_speed:
				var vel_dir  := h_vel_2d.normalized()
				var inp_dir  := Vector2(direction.x, direction.z)
				var alignment: float = vel_dir.dot(inp_dir)
				var speed_keep: float = lerp(
					1.0 - _config.turn_decel_factor,
					1.0,
					(alignment + 1.0) * 0.5
				)
				speed *= speed_keep

			# 3d. 起步爆发
			if not _had_input:
				_burst_timer = _config.burst_duration
			_burst_timer = max(_burst_timer - delta, 0.0)
			var burst_mult: float = 1.0
			if _config.burst_duration > 0.0:
				burst_mult = 1.0 + (_config.burst_strength - 1.0) * (_burst_timer / _config.burst_duration)

			# 3e. 用 move_toward 向目标速度加速
			var target_x := direction.x * speed * burst_mult
			var target_z := direction.z * speed * burst_mult
			_velocity.x = move_toward(_velocity.x, target_x, _config.ground_acceleration * delta)
			_velocity.z = move_toward(_velocity.z, target_z, _config.ground_acceleration * delta)

			# 3f. 步态波动：在速度方向叠加 sin 波动，模拟重心摆动（±振幅）
			var freq: float
			var amp: float
			if _is_sprinting:
				freq = _config.gait_frequency_sprint
				amp  = _config.gait_amplitude_sprint
			elif _is_running:
				freq = _config.gait_frequency_run
				amp  = _config.gait_amplitude_run
			else:
				freq = _config.gait_frequency_walk
				amp  = _config.gait_amplitude_walk
			_gait_phase = fmod(_gait_phase + delta * freq, 1.0)
			var move_dir_2d := Vector2(_velocity.x, _velocity.z).normalized()
			var gait_mod := sin(_gait_phase * TAU) * amp
			_velocity.x += move_dir_2d.x * gait_mod
			_velocity.z += move_dir_2d.y * gait_mod

		else:
			# 3h. 停止卸力：无输入时使用制动强度快速站稳，重置步态相位
			_velocity.x = move_toward(_velocity.x, 0.0, _config.stop_brake_strength * delta)
			_velocity.z = move_toward(_velocity.z, 0.0, _config.stop_brake_strength * delta)
			_burst_timer = 0.0
			_gait_phase  = 0.0
			# 停止移动时自动退出 Sprint 和 Run
			if _is_sprinting:
				_exit_sprint()
			if _is_running:
				_is_running = false
				stopped_running.emit()

	else:
		# ──────────────────────────────────────────────────
		# 4. 空中水平速度（保持原有空气阻力手感）
		# ──────────────────────────────────────────────────
		var basis := _player.global_basis
		var target_velocity := Vector3.ZERO
		if has_input:
			var direction := (basis.x * input_dir.x + basis.z * input_dir.y).normalized()
			target_velocity = direction * _config.walk_speed

		var accel: float = _config.air_acceleration if target_velocity.length() > _config.air_input_threshold else _config.air_deceleration
		_velocity.x = move_toward(_velocity.x, target_velocity.x, accel * delta)
		_velocity.z = move_toward(_velocity.z, target_velocity.z, accel * delta)

	# ──────────────────────────────────────────────────────
	# 5. 跳跃（不变）
	# ──────────────────────────────────────────────────────
	if Input.is_action_just_pressed("jump") and _player.is_on_floor():
		# 腿骨折时禁止跳跃
		var can_jump := true
		if _player.health_system:
			can_jump = _player.health_system.can_jump()
		if can_jump:
			_velocity.y = _config.jump_force
			jumped.emit()

	# ──────────────────────────────────────────────────────
	# 6. 重力（不变）
	# ──────────────────────────────────────────────────────
	if not _player.is_on_floor():
		_velocity.y -= _config.gravity * delta
	elif _velocity.y < 0:
		_velocity.y = _config.floor_snap_velocity

		# -----------------------------------------------------
		# 7. 速度死区：无输入时微速直接归零，防止浮点滑动
		# -----------------------------------------------------
		const VEL_DEAD_ZONE_SQ := 0.001
		if not has_input and Vector2(_velocity.x, _velocity.z).length_squared() < VEL_DEAD_ZONE_SQ:
			_velocity.x = 0.0
			_velocity.z = 0.0

	# ──────────────────────────────────────────────────────
	# 7. 应用移动，同步碰撞后实际速度
	# ──────────────────────────────────────────────────────
	_player.velocity = _velocity
	_player.move_and_slide()
	_velocity = _player.velocity

	# ──────────────────────────────────────────────────────
	# 8. 落地检测（is_on_floor 上升沿）及帧末状态更新
	# ──────────────────────────────────────────────────────
	var on_floor := _player.is_on_floor()
	if on_floor and not _was_on_floor:
		landed.emit()
	_was_on_floor = on_floor
	_had_input = has_input


# ──────────────────────────────────────────────────────
# Run / Sprint 状态辅助方法
# ──────────────────────────────────────────────────────

func _toggle_run() -> void:
	# 蹲伏状态下不允许切换跑步
	if _player and _player.stance_controller and _player.stance_controller.get_stance_value() > 0.05:
		return
	# 体力不足时不允许进入奔跑
	if not _is_running and _player.stamina_system and not _player.stamina_system.allows_run():
		return
	if _is_running:
		_is_running = false
		stopped_running.emit()
	else:
		_is_running = true
		started_running.emit()


func _enter_sprint() -> void:
	# 伤情检查：腿部骨折/动脉出血/失血过多时禁止冲刺
	if _player.health_system and not _player.health_system.can_sprint():
		return
	# 蹲伏状态下不允许冲刺
	if _player and _player.stance_controller and _player.stance_controller.get_stance_value() > 0.05:
		return
	_is_sprinting = true
	# Sprint 时自动进入 Run 状态（松开 Shift 后保持 Run）
	if not _is_running:
		_is_running = true
		started_running.emit()
	started_sprinting.emit()


func _exit_sprint() -> void:
	_is_sprinting = false
	stopped_sprinting.emit()

func _exit_run() -> void:
	if _is_running:
		_is_running = false
		stopped_running.emit()


func clear_locomotion_state() -> void:
	if _is_sprinting:
		_exit_sprint()
	if _is_running:
		_exit_run()
	_shift_held_time = 0.0
	_shift_was_held = false
	_burst_timer = 0.0
	_gait_phase = 0.0
	_had_input = false


# ──────────────────────────────────────────────────────
# 姿态同步方法（响应 StanceController 信号）
# ──────────────────────────────────────────────────────

func _on_stance_changed(value: float) -> void:
	"""响应姿态变化，同步物理参数"""
	# 进入蹲伏时强制退出 Run/Sprint，确保速度上限切换为 crouch_speed
	if value > 0.05:
		if _is_sprinting:
			_exit_sprint()
		if _is_running:
			_is_running = false
			stopped_running.emit()
	_update_collision_shape(value)
	_update_model_offset(value)


func _update_collision_shape(stance: float) -> void:
	"""根据姿态值更新碰撞体高度"""
	# 懒加载碰撞体
	var collision_shape: CollisionShape3D = null
	for child in _player.get_children():
		if child is CollisionShape3D:
			collision_shape = child
			break

	if not collision_shape or not (collision_shape.shape is CapsuleShape3D):
		return

	var shape := collision_shape.shape as CapsuleShape3D
	var target_height : float = lerp(_config.collision_shape_height, _config.crouch_capsule_height, stance)
	shape.height = target_height


func _update_model_offset(stance: float) -> void:
	"""根据姿态值更新模型Y偏移（让脚部贴地）"""
	var model_node: Node3D = _player.model_manager.model_node if _player.model_manager else null
	if not model_node:
		return
	var target_y : float = lerp(_config.model_y_offset, _config.crouch_y_offset, stance)
	model_node.position.y = target_y
