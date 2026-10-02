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

enum LocomotionMode {
	STAND,
	CROUCH,
	PRONE,
}
const CROUCH_STANCE_THRESHOLD := 0.3
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
var _turn_constraint_active: bool = false
var _turn_speed_ratio: float = 1.0
var _turn_acceleration_ratio: float = 1.0
## Debug-only Bot motion override. It still uses CharacterBody3D.move_and_slide().
var _test_motion_active: bool = false
var _test_motion_velocity: Vector3 = Vector3.ZERO
var _ai_motion_active: bool = false
var _ai_motion_velocity: Vector3 = Vector3.ZERO
## Virtual player input used by runtime AI. It feeds the same locomotion
## calculation as keyboard input; it never writes a world velocity directly.
var _ai_input_active: bool = false
var _ai_input_direction: Vector3 = Vector3.ZERO
var _ai_input_running: bool = false
var _ai_input_sprinting: bool = false
var _prone_roll_cooldown: float = 0.0
var _prone_roll_timer: float = 0.0
var _prone_roll_duration: float = 0.0
## The authored clips are 2.5-3.27s long, but only the configured opening
## window should propel the CharacterBody. Camera/animation timing stays on
## _prone_roll_timer so visual playback cannot turn into a multi-metre slide.
var _prone_roll_motion_timer: float = 0.0
var _prone_rolling: bool = false
var _prone_roll_direction: float = 0.0
var _prone_roll_world_direction: Vector3 = Vector3.ZERO


func is_running() -> bool:
	return _is_running

func is_sprinting() -> bool:
	return _is_sprinting

func is_prone_rolling() -> bool:
	return _prone_rolling

func is_prone_roll_active() -> bool:
	return _prone_rolling

func get_prone_roll_direction() -> float:
	return _prone_roll_direction

func get_prone_roll_progress() -> float:
	if not _prone_rolling or _prone_roll_duration <= 0.0:
		return 0.0
	return clampf(1.0 - _prone_roll_timer / _prone_roll_duration, 0.0, 1.0)

## Single source of truth for the three gameplay locomotion postures.
func get_locomotion_mode() -> LocomotionMode:
	if _player and _player.stance_controller \
			and (_player.stance_controller.is_prone() or _player.stance_controller.is_prone_transitioning()):
		return LocomotionMode.PRONE
	var stance_value := _player.stance_controller.get_stance_value() if _player and _player.stance_controller else 0.0
	return LocomotionMode.CROUCH if stance_value >= CROUCH_STANCE_THRESHOLD else LocomotionMode.STAND


func is_crouched_locomotion() -> bool:
	return get_locomotion_mode() == LocomotionMode.CROUCH

## Ends a prone-only action before another system changes the player's pose.
## This keeps roll velocity, camera banking, and the direct animation override
## from leaking into an exit transition or a later control-state restore.
func cancel_prone_roll() -> void:
	if not _prone_rolling:
		return
	_prone_rolling = false
	_prone_roll_direction = 0.0
	_prone_roll_world_direction = Vector3.ZERO
	_prone_roll_timer = 0.0
	_prone_roll_duration = 0.0
	_prone_roll_motion_timer = 0.0
	_velocity.x = 0.0
	_velocity.z = 0.0
	if _player:
		_player.velocity.x = 0.0
		_player.velocity.z = 0.0

func set_turn_constraint(active: bool, speed_ratio: float = 1.0, acceleration_ratio: float = 1.0) -> void:
	_turn_constraint_active = active
	_turn_speed_ratio = clampf(speed_ratio, 0.0, 1.0)
	_turn_acceleration_ratio = clampf(acceleration_ratio, 0.0, 1.0)

func get_max_speed() -> float:
	if not _config:
		return 4.0
	var base := _get_ground_speed()
	if _player and _player.health_system:
		base *= _player.health_system.get_movement_speed_multiplier()
	return base


func _get_ground_speed() -> float:
	if _is_sprinting:
		return _config.sprint_speed
	if _is_running:
		return _config.run_speed
	var stance_value := _player.stance_controller.get_stance_value() if _player and _player.stance_controller else 0.0
	return lerpf(_config.walk_speed, _config.crouch_speed, stance_value)


func initialize(player: BasePlayer, config: PlayerConfig, camera_controller: PlayerCameraController) -> void:
	_player = player
	_config = config
	_camera_controller = camera_controller
	_velocity = Vector3.ZERO

func set_test_motion_velocity(world_velocity: Vector3) -> void:
	_test_motion_active = true
	_test_motion_velocity = world_velocity
	_velocity = world_velocity
	if _player:
		_player.velocity = world_velocity

func clear_test_motion() -> void:
	_test_motion_active = false
	_test_motion_velocity = Vector3.ZERO
	_velocity.x = 0.0
	_velocity.z = 0.0
	if _player:
		_player.velocity.x = 0.0
		_player.velocity.z = 0.0


func set_ai_motion_velocity(world_velocity: Vector3) -> void:
	_ai_motion_active = true
	_ai_motion_velocity = world_velocity


func clear_ai_motion() -> void:
	_ai_motion_active = false
	_ai_motion_velocity = Vector3.ZERO


## Supplies virtual movement input to the normal player locomotion path.
func set_ai_input(world_direction: Vector3, running: bool = false, sprinting: bool = false) -> void:
	_ai_input_active = true
	_ai_input_direction = world_direction
	_ai_input_running = running
	_ai_input_sprinting = sprinting


func clear_ai_input() -> void:
	_ai_input_active = false
	_ai_input_direction = Vector3.ZERO
	_ai_input_running = false
	_ai_input_sprinting = false
	clear_locomotion_state()


func is_ai_motion_active() -> bool:
	return _ai_motion_active

func is_test_motion_active() -> bool:
	return _test_motion_active


func _physics_process(delta: float) -> void:
	if not _player or not _config:
		return
	var ai_driving := _player.is_ai_player and _ai_input_active
	if not _player.is_alive or _player.is_ragdolled:
		clear_locomotion_state()
		_velocity = Vector3.ZERO
		_player.velocity = Vector3.ZERO
		return
	# Once a roll starts it continues through temporary control locks. Death and
	# ragdoll still take the lifecycle branch above and cancel it explicitly.
	if not _player.controllable and not ai_driving and not _prone_rolling:
		if _was_controllable:
			clear_locomotion_state()
		_was_controllable = false
		if _player.is_ai_player and (_test_motion_active or _ai_motion_active) and not ai_driving:
			var requested := _test_motion_velocity if _test_motion_active else _ai_motion_velocity
			if not _player.is_on_floor():
				_velocity.y -= _config.gravity * delta
			else:
				_velocity.y = _config.floor_snap_velocity
			_velocity.x = requested.x
			_velocity.z = requested.z
			_player.velocity = _velocity
			_player.move_and_slide()
			_velocity = _player.velocity
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
	if _prone_roll_cooldown > 0.0:
		_prone_roll_cooldown -= delta
	if _prone_rolling:
		_prone_roll_timer -= delta
		_prone_roll_motion_timer = maxf(_prone_roll_motion_timer - delta, 0.0)
		var has_roll_animation := _player.animation_controller != null
		var animation_finished := has_roll_animation and not _player.animation_controller.is_prone_roll_playing()
		var fallback_finished := not has_roll_animation and _prone_roll_timer <= 0.0
		if animation_finished or fallback_finished:
			_prone_rolling = false
			_prone_roll_world_direction = Vector3.ZERO
			_prone_roll_cooldown = _config.prone_roll_cooldown
			_prone_roll_timer = 0.0
			_prone_roll_motion_timer = 0.0
			if _player.animation_controller and _player.stance_controller and _player.stance_controller.is_prone():
				_player.animation_controller.play_prone_idle()

	# ──────────────────────────────────────────────────────
	# 1. 读取输入方向
	# ──────────────────────────────────────────────────────
	var input_dir: Vector2
	var shift_held: bool
	var has_forward: bool
	if ai_driving:
		var local_direction := _player.global_basis.inverse() * _ai_input_direction
		input_dir = Vector2(local_direction.x, local_direction.z)
		shift_held = _ai_input_running or _ai_input_sprinting
		has_forward = input_dir.y < -_config.input_dead_zone
		_set_ai_locomotion_state()
	else:
		input_dir = Input.get_vector(
			"move_left", "move_right",
			"move_forward", "move_backward"
		)
		shift_held = Input.is_action_pressed("sprint")
		has_forward = Input.is_action_pressed("move_forward")
	var has_input := input_dir.length() > _config.input_dead_zone
	if get_locomotion_mode() == LocomotionMode.PRONE:
		_process_prone_movement(delta, input_dir, has_input, ai_driving)
		return

	# ──────────────────────────────────────────────────────
	# 2. Shift 按压检测：区分单击（切换 Run）和长按（Sprint）
	# ──────────────────────────────────────────────────────
	# 下降沿：Shift 刚松开
	if not ai_driving and _shift_was_held and not shift_held:
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
	elif not ai_driving and not _shift_was_held and shift_held:
		_shift_held_time = 0.0
	# 持续按住：累计时间，达到阈值后激活 Sprint
	elif not ai_driving and shift_held:
		_shift_held_time += delta
		var threshold := _config.sprint_hold_threshold if _config else 0.25
		if _shift_held_time >= threshold and has_forward and not _is_sprinting:
			_enter_sprint()

	if not ai_driving:
		_shift_was_held = shift_held

	# Sprint 失去前进输入时自动退出
	if _is_sprinting and not has_forward:
		_exit_sprint()

	# ──────────────────────────────────────────────────────
	# 3. 地面水平速度
	# ──────────────────────────────────────────────────────
	if _player.is_on_floor():
		# 3a. 确定基础目标速度（与 get_max_speed() 保持一致的优先级）
		var speed := _get_ground_speed()
		# 功能性损伤乘数
		if _player.health_system:
			speed *= _player.health_system.get_movement_speed_multiplier()

		if has_input:
			var basis := _camera_controller.get_view_basis() if _camera_controller else _player.global_basis
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
			if _turn_constraint_active:
				speed *= _turn_speed_ratio
			var target_x := direction.x * speed * burst_mult
			var target_z := direction.z * speed * burst_mult
			var acceleration := _config.ground_acceleration * (_turn_acceleration_ratio if _turn_constraint_active else 1.0)
			_velocity.x = move_toward(_velocity.x, target_x, acceleration * delta)
			_velocity.z = move_toward(_velocity.z, target_z, acceleration * delta)

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
	if not ai_driving and Input.is_action_just_pressed("jump") and _player.is_on_floor() and not (_player.stance_controller and _player.stance_controller.is_prone()):
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
	cancel_prone_roll()
	if _is_sprinting:
		_exit_sprint()
	if _is_running:
		_exit_run()
	_shift_held_time = 0.0
	_shift_was_held = false
	_burst_timer = 0.0
	_gait_phase = 0.0
	_ai_input_running = false
	_ai_input_sprinting = false


func _set_ai_locomotion_state() -> void:
	if _ai_input_sprinting:
		if not _is_sprinting:
			_enter_sprint()
		return
	if _is_sprinting:
		_exit_sprint()
	if _ai_input_running:
		if not _is_running:
			_toggle_run()
	elif _is_running:
		_exit_run()
	_had_input = false


# ──────────────────────────────────────────────────────
# 姿态同步方法（响应 StanceController 信号）
# ──────────────────────────────────────────────────────

## Public value interface; callers do not need access to movement internals.
func apply_stance_value(value: float) -> void:
	"""响应姿态变化，只同步移动状态；碰撞体由 PlayerCollisionController 独占。"""
	# 进入蹲伏时强制退出 Run/Sprint，确保速度上限切换为 crouch_speed
	if value > 0.05:
		if _is_sprinting:
			_exit_sprint()
		if _is_running:
			_is_running = false
			stopped_running.emit()

func _process_prone_movement(delta: float, input_dir: Vector2, has_input: bool, ai_driving: bool) -> void:
	# Prone movement owns locomotion state. Emit the same transitions as the
	# normal input path so stamina and animation consumers cannot remain stuck
	# in Sprinting after an airborne prone transition.
	if _is_sprinting:
		_exit_sprint()
	if _is_running:
		_exit_run()
	if _player.stance_controller.is_prone_transitioning():
		input_dir = Vector2.ZERO
		has_input = false
	if not _player.is_on_floor():
		_velocity.y -= _config.gravity * delta
	else:
		_velocity.y = _config.floor_snap_velocity
	var basis: Basis = _camera_controller.get_view_basis() if _camera_controller else _player.global_basis
	var direction: Vector3 = (basis.x * input_dir.x + basis.z * input_dir.y).normalized() if has_input else Vector3.ZERO
	var side: bool = abs(input_dir.x) > abs(input_dir.y) and abs(input_dir.x) > _config.input_dead_zone
	if _is_prone_roll_combo_pressed(side, ai_driving) and not _prone_rolling and _prone_roll_cooldown <= 0.0:
		if not _player.stamina_system or _player.stamina_system.consume_prone_roll():
			if _player.turn_controller:
				_player.turn_controller.cancel_for_prone_roll()
			_prone_rolling = true
			_prone_roll_direction = sign(input_dir.x)
			var planar_right := basis.x
			planar_right.y = 0.0
			if planar_right.length_squared() < 0.000001:
				planar_right = _player.global_basis.x
				planar_right.y = 0.0
			_prone_roll_world_direction = planar_right.normalized() * _prone_roll_direction
			_prone_roll_duration = _config.prone_roll_duration
			if _player.animation_controller:
				var clip_length := _player.animation_controller.play_prone_roll(_prone_roll_direction < 0.0)
				if clip_length > 0.0:
					_prone_roll_duration = clip_length
			_prone_roll_timer = _prone_roll_duration
			_prone_roll_motion_timer = minf(_config.prone_roll_duration, _prone_roll_duration)
	var speed: float = 0.0
	var movement_direction := direction
	var should_move := has_input
	if _prone_rolling:
		if _prone_roll_motion_timer > 0.0:
			speed = _config.prone_roll_speed
			movement_direction = _prone_roll_world_direction
			should_move = not movement_direction.is_zero_approx()
		else:
			movement_direction = Vector3.ZERO
			should_move = false
	elif has_input:
		if side:
			speed = _config.prone_lateral_speed
		elif input_dir.y < 0.0:
			speed = _config.prone_forward_speed
		else:
			speed = _config.prone_backward_speed
	if should_move:
		_velocity.x = move_toward(_velocity.x, movement_direction.x * speed, _config.prone_roll_acceleration * delta)
		_velocity.z = move_toward(_velocity.z, movement_direction.z * speed, _config.prone_roll_acceleration * delta)
	else:
		var brake_strength := _config.prone_roll_acceleration if _prone_rolling else _config.stop_brake_strength
		_velocity.x = move_toward(_velocity.x, 0.0, brake_strength * delta)
		_velocity.z = move_toward(_velocity.z, 0.0, brake_strength * delta)
	_player.velocity = _velocity
	_player.move_and_slide()
	_velocity = _player.velocity
	_had_input = has_input
	# Enter/exit clips own the skeleton until StanceController marks the
	# transition complete. Locomotion must not replace them frame-by-frame.
	var prone_turn_active := _player.turn_controller and _player.turn_controller.is_turning()
	if _player.animation_controller and not _prone_rolling \
			and not _player.stance_controller.is_prone_transitioning() \
			and not prone_turn_active:
		_player.animation_controller.update_prone_motion(input_dir, has_input)


func _is_prone_roll_combo_pressed(side: bool, ai_driving: bool) -> bool:
	if ai_driving or not side or not Input.is_action_pressed("jump"):
		return false
	# Accept both input orders: hold A/D then press Space, or hold Space then
	# press A/D. Requiring a fresh edge prevents held keys from chaining rolls.
	return Input.is_action_just_pressed("jump") \
		or Input.is_action_just_pressed("move_left") \
		or Input.is_action_just_pressed("move_right")
