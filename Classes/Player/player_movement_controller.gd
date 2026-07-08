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
## 开始奔跑
signal stopped_running
## 停止奔跑


# 私有变量 ────────────────────────────────────────────────
var _player: CharacterBody3D
var _config: PlayerConfig
var _velocity: Vector3
var _is_running: bool = false
var _was_on_floor: bool = true

var _gait_phase: float = 0.0   # 步态相位（0~1 循环），每帧按步频累加
var _burst_timer: float = 0.0  # 起步爆发剩余时间（秒）
var _had_input: bool = false   # 上一帧是否有移动输入，用于检测起步边沿


func is_running() -> bool:
	return _is_running


func get_max_speed() -> float:
	return _config.run_speed if _config else 4.0


func initialize(player: CharacterBody3D, config: PlayerConfig) -> void:
	_player = player
	_config = config
	_velocity = Vector3.ZERO


func _physics_process(delta: float) -> void:
	if not _player or not _config:
		return

	# ──────────────────────────────────────────────────────
	# 1. 读取输入方向
	# ──────────────────────────────────────────────────────
	var input_dir := Input.get_vector(
		"move_left", "move_right",
		"move_forward", "move_backward"
	)
	var has_input := input_dir.length() > _config.input_dead_zone

	# ──────────────────────────────────────────────────────
	# 2. Sprint 信号检测（移出 is_on_floor 块，空中松开也能正确重置）
	# ──────────────────────────────────────────────────────
	var sprint_active := Input.is_action_pressed("sprint") and Input.is_action_pressed("move_forward")
	if _is_running and not sprint_active:
		_is_running = false
		stopped_running.emit()

	# ──────────────────────────────────────────────────────
	# 3. 地面水平速度
	# ──────────────────────────────────────────────────────
	if _player.is_on_floor():
		# 3a. 确定基础目标速度
		var speed := _config.run_speed if sprint_active else _config.walk_speed

		if has_input:
			var basis := _player.transform.basis
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
			var freq: float = _config.gait_frequency_run if _is_running else _config.gait_frequency_walk
			var amp: float  = _config.gait_amplitude_run if _is_running else _config.gait_amplitude_walk
			_gait_phase = fmod(_gait_phase + delta * freq, 1.0)
			var move_dir_2d := Vector2(_velocity.x, _velocity.z).normalized()
			var gait_mod := sin(_gait_phase * TAU) * amp
			_velocity.x += move_dir_2d.x * gait_mod
			_velocity.z += move_dir_2d.y * gait_mod

			# 3g. 地面上奔跑起步信号
			if sprint_active and not _is_running:
				_is_running = true
				started_running.emit()

		else:
			# 3h. 停止卸力：无输入时使用制动强度快速站稳，重置步态相位
			_velocity.x = move_toward(_velocity.x, 0.0, _config.stop_brake_strength * delta)
			_velocity.z = move_toward(_velocity.z, 0.0, _config.stop_brake_strength * delta)
			_burst_timer = 0.0
			_gait_phase  = 0.0

	else:
		# ──────────────────────────────────────────────────
		# 4. 空中水平速度（保持原有空气阻力手感）
		# ──────────────────────────────────────────────────
		var basis := _player.transform.basis
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
		_velocity.y = _config.jump_force
		jumped.emit()

	# ──────────────────────────────────────────────────────
	# 6. 重力（不变）
	# ──────────────────────────────────────────────────────
	if not _player.is_on_floor():
		_velocity.y -= _config.gravity * delta
	elif _velocity.y < 0:
		_velocity.y = _config.floor_snap_velocity

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
