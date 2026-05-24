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
	if not _player:
		return
	var input_dir = Input.get_vector("move_left","move_right","move_forward","move_backward")
	var direction = Vector3.ZERO
	## 换算并归一化方向向量
	var speed = _config.walk_speed
	if input_dir.length() > 0.1:
		direction = _player.transform.basis.x * input_dir.x
		direction += _player.transform.basis.z * input_dir.y
		direction = direction.normalized()
		## 按下奔跑时切换状态
		if Input.is_action_pressed("sprint"): 
			speed = _config.run_speed
			if not _is_running:
				_is_running = true
				started_running.emit()
		else:
			if _is_running:
				_is_running = false
				stopped_running.emit()
	## 跳跃			
	if Input.is_action_pressed("jump"):
		jump() 
		
	## 应用水平速度
	var deceleration_multiplier = _config.deceleration_multiplier # 获取减速系数
	if direction.length() > 0.1:
		_velocity.x = direction.x * speed
		_velocity.z = direction.z * speed
	else:
		_velocity.x = move_toward(_velocity.x, 0, speed * delta * deceleration_multiplier)
		_velocity.z = move_toward(_velocity.z, 0, speed * delta * deceleration_multiplier)
		
	## 应用重力	
	if not _player.is_on_floor():
		_velocity.y -= _config.gravity * delta
	elif _velocity.y < 0: # 防止落地时短暂失去地面检测
		_velocity.y = -0.5
		
	## 应用移动
	_player.velocity = _velocity
	_player.move_and_slide()
	
## 设置输入方向（AI控制时扩展）
func set_input_direction(direction: Vector2) -> void:
	pass

## 强制设置跑步状态
func set_running(enabled: bool) -> void:
	if _is_running != enabled:
		_is_running = enabled
		if enabled:
			started_running.emit()
		else:
			stopped_running.emit()

## 跳跃（外部调用）
func jump() -> void:
	if _player.is_on_floor():
		_velocity.y = _config.jump_force
		jumped.emit()			
