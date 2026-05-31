class_name PlayerMovementController
extends Node

## 信号
signal jumped
signal landed
signal started_running
signal stopped_running

## 私有变量
var _player: CharacterBody3D
var _config: PlayerConfig
var _velocity: Vector3
var _is_running: bool = false

func _ready() -> void:
	print("player_movement_controller.gd 已激活")

## 初始化
func initialize(player: CharacterBody3D, config: PlayerConfig) -> void:
	_player = player
	_config = config
	_velocity = Vector3.ZERO

func _physics_process(delta: float) -> void:
	if not _player or not _config:
		return
	
	# ----- 1. 获取输入方向 -----
	var input_dir = Input.get_vector(
		"move_left", "move_right",
		"move_forward", "move_backward"
	)
	
	# ----- 2. 计算目标水平速度 -----
	var speed = _config.walk_speed
	if _player.is_on_floor():
		if Input.is_action_pressed("sprint"):
			speed = _config.run_speed
			if not _is_running:
				_is_running = true
				started_running.emit()
		else:
			if _is_running:
				_is_running = false
				stopped_running.emit()
	
	var target_velocity = Vector3.ZERO
	if input_dir.length() > 0.1:
		# 将输入方向转换到世界空间，并乘以目标速度
		var direction = _player.transform.basis.x * input_dir.x
		direction += _player.transform.basis.z * input_dir.y
		direction = direction.normalized()
		target_velocity = direction * speed
	
	# ----- 3. 惯性：加速度/减速度平滑过渡 -----
	# 根据是否在地面选择不同的加速度值
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
	
	# ----- 4. 跳跃 -----
	if Input.is_action_just_pressed("jump") and _player.is_on_floor():
		_velocity.y = _config.jump_force
		jumped.emit()
	
	# ----- 5. 重力 -----
	if not _player.is_on_floor():
		_velocity.y -= _config.gravity * delta
	elif _velocity.y < 0:
		_velocity.y = -0.5
	
	# ----- 6. 应用移动 -----
	_player.velocity = _velocity
	_player.move_and_slide()
