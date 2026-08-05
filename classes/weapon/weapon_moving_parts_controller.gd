class_name WeaponMovingPartsController
extends Node

# ============================================================
# 可动部件控制器
#
# 职责：订阅 BaseWeapon.bolt_moving(position: float) 信号，
#       驱动武器场景中的运动部件（枪机框、拉机柄）做位移动画。
#
# 默认模式：直接驱动 Node3D.position（沿 -Z 轴后退）。
# 动画覆盖：武器 AnimationPlayer 存在名为 "bolt_cycle" 的动画时，
#           改为驱动 anim_player.seek()，美术可在动画里控制多部件联动。
#
# 节点命名约定（武器 .tscn 场景内）：
#   BoltCarrier      — 枪机框/活塞（Node3D，沿 -Z 平移）
#   ChargingHandleMesh — 拉机柄网格节点（随枪机框同步）
#
# Mod 扩展：
#   - 在武器场景里命名以上节点即可自动接管
#   - bolt_travel_m（WeaponConfig 字段）控制最大后退距离
#   - 提供 bolt_cycle 动画则切换到动画驱动，无需任何代码改动
# ============================================================

## 枪机框节点的约定名称
const BOLT_CARRIER_NAME     := "BoltCarrier"
## 拉机柄节点的约定名称
const CHARGING_HANDLE_NAME  := "ChargingHandleMesh"
## 可选的动画片段名（存在时切换到动画驱动模式）
const ANIM_BOLT_CYCLE       := "bolt_cycle"

var _weapon: BaseWeapon
var _bolt_carrier: Node3D
var _charging_handle: Node3D
var _bolt_rest_pos: Vector3
var _ch_rest_pos: Vector3
var _anim_player: AnimationPlayer
var _use_anim: bool = false

## 是否允许 bolt_cycle 动画接管枪机运动。
## 默认 false：刚体运动用程序动画，保证物理参数（枪机质量/复进簧/导气延时）
## 能实时改变运动速度。仅在确有多部件联动需求时才由美术显式打开。
@export var use_animation_override: bool = false


## 初始化：查找可动部件节点，订阅 bolt_moving 信号
func initialize(weapon: BaseWeapon) -> void:
	_weapon = weapon
	_anim_player = weapon.find_child("AnimationPlayer", true, false) as AnimationPlayer
	_bolt_carrier    = weapon.find_child(BOLT_CARRIER_NAME,    true, false) as Node3D
	_charging_handle = weapon.find_child(CHARGING_HANDLE_NAME, true, false) as Node3D

	# 用 call_deferred 推迟记录静息位置：
	# 武器 GLB 子节点可能在自身 _ready() 里调整位置，
	# 延迟一帧能保证拿到正确的静息值
	call_deferred("_record_rest_positions")

	# 刚体运动一律走程序动画（JiYu 指示：刚体运动的动画用程序动画，不用 AnimationPlayer）。
	# 枪机行程由 bolt_mass / 复进簧刚度 / 导气延时实时驱动，动画曲线做不到这点：
	# 换重枪机或强复进簧后，位移速度必须跟着变。
	# ANIM_BOLT_CYCLE 仅在美术显式要求多部件联动时作为覆盖手段保留。
	if _anim_player and _anim_player.has_animation(ANIM_BOLT_CYCLE) and use_animation_override:
		_use_anim = true
		GlobalLogger.warn(
			"MovingParts",
			"检测到 bolt_cycle 动画且已开启覆盖：枪机将由动画驱动，物理参数不再影响其速度"
		)

	weapon.bolt_moving.connect(_on_bolt_moving)


func _record_rest_positions() -> void:
	if _bolt_carrier:
		_bolt_rest_pos = _bolt_carrier.position
	if _charging_handle:
		_ch_rest_pos = _charging_handle.position


## bolt_moving 信号回调
## position: 0.0 = 闭锁（静息）, 1.0 = 全开（最大后退）
func _on_bolt_moving(position: float) -> void:
	if _use_anim and _anim_player:
		# 动画驱动：将枪机位置映射到动画时间轴
		var anim := _anim_player.get_animation(ANIM_BOLT_CYCLE)
		if anim:
			_anim_player.seek(position * anim.length, true)
		return

	# 默认：直接驱动节点 Z 轴位移（枪机后退方向 = +Z，对应 bolt_moving 升高）
	# bolt_travel_m 从已装 BoltCarrierConfig 读取，未装时使用安全默认值
	var travel: float = 0.08
	if _weapon:
		var bolt_cfg := _weapon._get_attachment_config_of_type(BoltCarrierConfig) as BoltCarrierConfig
		if bolt_cfg:
			travel = bolt_cfg.bolt_travel_m
	if _bolt_carrier:
		_bolt_carrier.position = _bolt_rest_pos + Vector3(0.0, 0.0, position * travel)
	if _charging_handle:
		_charging_handle.position = _ch_rest_pos + Vector3(0.0, 0.0, position * travel)
