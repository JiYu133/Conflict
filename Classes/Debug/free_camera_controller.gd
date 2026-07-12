class_name FreeCameraController
extends Node

# 调试用自由视角，F 键切换，仅在 debug 构建下生效

@export var move_speed: float = 5.0
@export var fast_speed: float = 15.0
@export var sensitivity: float = 0.003

var _active: bool = false
var _free_cam: Camera3D
var _pitch: float = 0.0
var _yaw: float = 0.0
var _player: BasePlayer
var _camera_controller: PlayerCameraController
var _was_controllable: bool = false


func initialize(player: BasePlayer, camera_controller: PlayerCameraController) -> void:
	_player = player
	_camera_controller = camera_controller


func toggle() -> void:
	if _active:
		_exit()
	else:
		_enter()


func _enter() -> void:
	_active = true

	# 冻结角色和普通摄像机
	_was_controllable = _player.controllable
	_player.set_controllable(false)

	# 从当前摄像机位置出发创建自由摄像机
	var current_cam := _camera_controller.get_active_camera()
	_free_cam = Camera3D.new()
	_free_cam.name = "FreeCam"
	if current_cam:
		_free_cam.global_transform = current_cam.global_transform
		_pitch = current_cam.global_rotation.x
		_yaw   = current_cam.global_rotation.y
		_free_cam.fov = current_cam.fov
	_player.add_child(_free_cam)
	_free_cam.current = true

	GlobalLogger.info("FreeCam", "自由视角已启用，WASD/QE 移动，Shift 加速，F 退出")


func _exit() -> void:
	_active = false

	# 恢复原摄像机
	var original_cam := _camera_controller.get_active_camera()
	if original_cam:
		original_cam.current = true

	if _free_cam and is_instance_valid(_free_cam):
		_free_cam.queue_free()
	_free_cam = null

	# 恢复进入自由视角前的状态；死亡玩家必须保持不可控，否则无碰撞体时会继续受重力下坠。
	_player.set_controllable(_was_controllable and _player.is_alive)

	GlobalLogger.info("FreeCam", "自由视角已退出")


func _input(event: InputEvent) -> void:
	if not _active or not _free_cam:
		return
	if event is InputEventMouseMotion:
		_yaw   -= event.relative.x * sensitivity
		_pitch -= event.relative.y * sensitivity
		_pitch  = clamp(_pitch, -PI / 2.0 + 0.01, PI / 2.0 - 0.01)
		_free_cam.global_rotation = Vector3(_pitch, _yaw, 0.0)


func _process(delta: float) -> void:
	if not _active or not _free_cam:
		return

	var speed := fast_speed if Input.is_key_pressed(KEY_SHIFT) else move_speed
	var dir := Vector3.ZERO

	if Input.is_key_pressed(KEY_W): dir -= _free_cam.global_transform.basis.z
	if Input.is_key_pressed(KEY_S): dir += _free_cam.global_transform.basis.z
	if Input.is_key_pressed(KEY_A): dir -= _free_cam.global_transform.basis.x
	if Input.is_key_pressed(KEY_D): dir += _free_cam.global_transform.basis.x
	if Input.is_key_pressed(KEY_Q): dir -= _free_cam.global_transform.basis.y
	if Input.is_key_pressed(KEY_E): dir += _free_cam.global_transform.basis.y

	if dir.length_squared() > 0.0:
		_free_cam.global_position += dir.normalized() * speed * delta
