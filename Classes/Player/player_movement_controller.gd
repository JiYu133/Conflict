lass_name PlayerMovementController
extends Node

# ============================================================
# 玩家移动控制器
# 功能：处理玩家（CharacterBody3D）的全部移动逻辑：
#       WASD 输入转换 → 惯性平滑 / 跳跃 / 重力 / 奔跑。
# 用法：由 BasePlayer 初始化并每帧执行，独立于动画系统。
# 依赖：PlayerConfig（需要 walk_speed / run_speed / 加速度等参数）
# 设计要点：
#   - 加速度/减速度分离：地面和空中有不同的摩擦系数
#   - move_and_slide() 后同步 _velocity，避免碰撞后漂移
# ============================================================

# 信号 ────────────────────────────────────────────────────
signal jumped
## 起跳
signal landed
## 落地（当前未实现，后续可通过检查 is_on_floor 的上升沿触发）
signal started_running
## 开始奔跑
signal stopped_running
## 停止奔跑


# 私有变量 ────────────────────────────────────────────────
var _player: CharacterBody3D           # 需要控制的玩家角色
var _config: PlayerConfig              # 移动参数配置
var _velocity: Vector3                 # 当前速度向量（每帧持续维护，而非每帧重置）
var _is_running: bool = false          # 当前是否处于奔跑状态（用于防重复发射 started/stopped 信号）
var _was_on_floor: bool = true         # 上一帧是否在地面（用于检测落地上升沿）

func initialize(player: CharacterBody3D, config: PlayerConfig) -> void:
	_player = player
	_config = config
	_velocity = Vector3.ZERO


func _physics_process(delta: float) -> void:
	if not _player or not _config:
		return

	# ——————————————————————————————————————————
	# 1. 获取输入方向
	#    Input.get_vector 返回一个 Vector2：
	#    x = 左右（-1~1），y = 前后（-1~1）
	# ——————————————————————————————————————————
	var input_dir = Input.get_vector(
		"move_left", "move_right",
		"move_forward", "move_backward"
	)

	# ——————————————————————————————————————————
	# 2. 计算目标水平速度
	#    奔跑判定：在地面 + 按着 sprint + 按着前（w）
	# ——————————————————————————————————————————
	var speed = _config.walk_speed
	if _player.is_on_floor():
		if Input.is_action_pressed("sprint"):
			if Input.is_action_pressed("move_forward"):
				speed = _config.run_speed
				if not _is_running:
					_is_running = true
					started_running.emit()
			else:
				if _is_running:
					_is_running = false
					stopped_running.emit()

	# 将 2D 输入方向转换成 3D 世界空间方向
	var target_velocity = Vector3.ZERO
	if input_dir.length() > 0.1:
		var direction = _player.transform.basis.x * input_dir.x
		direction += _player.transform.basis.z * input_dir.y
		direction = direction.normalized()
		target_velocity = direction * speed

	# ——————————————————————————————————————————
	# 3. 惯性平滑过渡
	#    地面：高加速度 + 高减速度（响应灵敏）
	#    空中：低加速度 + 低减速度（空气阻力小，惯性大）
	# ——————————————————————————————————————————
	var accel = _config.acceleration if _player.is_on_floor() else _config.air_acceleration
	var decel = _config.deceleration if _player.is_on_floor() else _config.air_deceleration

	if target_velocity.length() > 0.1:
		# 有输入：向目标速度加速
		_velocity.x = move_toward(_velocity.x, target_velocity.x, accel * delta)
		_velocity.z = move_toward(_velocity.z, target_velocity.z, accel * delta)
	else:
		# 无输入：减速到零
		_velocity.x = move_toward(_velocity.x, 0.0, decel * delta)
		_velocity.z = move_toward(_velocity.z, 0.0, decel * delta)

	# ——————————————————————————————————————————
	# 4. 跳跃
	#    仅在地面时响应跳跃指令
	# ——————————————————————————————————————————
	if Input.is_action_just_pressed("jump") and _player.is_on_floor():
		_velocity.y = _config.jump_force
		jumped.emit()

	# ——————————————————————————————————————————
	# 5. 重力
	#    空中持续受重力影响；地面时将 y 速度钳制为 -0.5 保持贴地
	# ——————————————————————————————————————————
	if not _player.is_on_floor():
		_velocity.y -= _config.gravity * delta
	elif _velocity.y < 0:
		_velocity.y = -0.5

	# ——————————————————————————————————————————
	# 6. 应用移动
	#    move_and_slide() 是 CharacterBody3D 的标准移动方法，
	#    自动处理碰撞检测和滑动。
	#    注意：碰撞后 _player.velocity 会被引擎修改，
	#    因此需要同步回 _velocity 避免下一帧重新加速。
	# ——————————————————————————————————————————
	_player.velocity = _velocity
	_player.move_and_slide()
	_velocity = _player.velocity  # 同步碰撞后的实际速度

	# landed detection: rising edge of is_on_floor
	var on_floor := _player.is_on_floor()
	if on_floor and not _was_on_floor:
		landed.emit()
	_was_on_floor = on_floor
