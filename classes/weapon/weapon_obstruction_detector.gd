class_name WeaponObstructionDetector
extends Node

# ============================================================
# 武器遮挡检测器
# 功能：每帧从摄像机位置向前发射短射线，检测武器前方是否有障碍物。
#       有障碍时按距离比例将武器沿 -Z 轴平滑缩回，
#       障碍消失时自动归位。
#       射线长度动态读取当前武器配置（weapon_length + 枪口配件修正），
#       确保安装消音器等枪口装置后也能正确检测。
# 用法：由 BasePlayer 在模型加载后初始化，传入玩家、摄像机、武器管理器、晃动支点。
# 注意：纯本地视觉效果，不影响任何物理或网络同步状态。
# ============================================================

const RETRACT_SPEED: float = 12.0  # 归位插值速度
const MAX_RETRACT: float = 0.35    # 最大缩进距离（m）
const FALLBACK_RAY_LENGTH: float = 0.75  # 无武器时的默认检测距离

var _player: CharacterBody3D
var _camera: Camera3D
var _weapon_manager: WeaponManager
var _sway_pivot: Node3D

var _retract_amount: float = 0.0


func initialize(player: CharacterBody3D, camera: Camera3D, weapon_manager: WeaponManager, sway_pivot: Node3D) -> void:
	_player = player
	_camera = camera
	_weapon_manager = weapon_manager
	_sway_pivot = sway_pivot


func _physics_process(delta: float) -> void:
	if not _player or not _camera or not _sway_pivot:
		return

	var target_retract: float = _get_target_retract()
	_retract_amount = lerp(_retract_amount, target_retract, clamp(delta * RETRACT_SPEED, 0.0, 1.0)) as float
	_sway_pivot.position.z = -_retract_amount


func _get_ray_length() -> float:
	if not _weapon_manager or not _weapon_manager.current_weapon:
		return FALLBACK_RAY_LENGTH

	var weapon: BaseWeapon = _weapon_manager.current_weapon
	if not weapon.config:
		return FALLBACK_RAY_LENGTH

	var length: float = weapon.config.weapon_length
	if weapon.attachment_manager:
		length += weapon.attachment_manager.get_total_length_modifier()
	return max(length, 0.1)


func _get_target_retract() -> float:
	var ray_length: float = _get_ray_length()
	var space_state: PhysicsDirectSpaceState3D = _player.get_world_3d().direct_space_state
	var from: Vector3 = _camera.global_position
	var forward: Vector3 = -_camera.global_transform.basis.z
	var to: Vector3 = from + forward * ray_length

	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(from, to)
	query.exclude = [_player.get_rid()]

	var result: Dictionary = space_state.intersect_ray(query)
	if result.is_empty():
		return 0.0

	var hit_dist: float = from.distance_to(result["position"])
	var ratio: float = 1.0 - clamp(hit_dist / ray_length, 0.0, 1.0)
	return ratio * MAX_RETRACT
