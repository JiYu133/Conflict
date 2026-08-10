class_name WeaponMovingPartsController
extends Node

# ============================================================
# 可动部件控制器
#
# 职责：订阅 BaseWeapon.bolt_moving(position: float) 信号，
#       直接驱动武器场景中的运动部件（枪机框、拉机柄）做程序动画。
#
# 说明：
#   - 这里不使用 AnimationPlayer 驱动刚体运动。
#   - 枪机行程由 bolt_mass / 复进簧刚度 / 导气延时实时驱动，
#     以便配件变化后仍然保持物理一致性。
#
# 节点命名约定（武器 .tscn 场景内）：
#   BoltCarrier        — 枪机框/活塞（Node3D，沿 +Z 平移）
#   ChargingHandleMesh — 拉机柄网格节点（随枪机框同步）
# ============================================================

## 枪机框节点的约定名称
const BOLT_CARRIER_NAME := "BoltCarrier"
## 拉机柄节点的约定名称
const CHARGING_HANDLE_NAME := "ChargingHandleMesh"

var _weapon: BaseWeapon
var _bolt_carrier: Node3D
var _charging_handle: Node3D
var _bolt_rest_pos: Vector3 = Vector3.ZERO
var _ch_rest_pos: Vector3 = Vector3.ZERO
var _rebind_scheduled: bool = false


## 初始化：查找可动部件节点，订阅 bolt_moving 与配件变更信号
func initialize(weapon: BaseWeapon) -> void:
	_weapon = weapon
	if _weapon and not _weapon.bolt_moving.is_connected(_on_bolt_moving):
		_weapon.bolt_moving.connect(_on_bolt_moving)
	if _weapon and _weapon.attachment_manager and not _weapon.attachment_manager.attachments_changed.is_connected(_schedule_target_refresh):
		_weapon.attachment_manager.attachments_changed.connect(_schedule_target_refresh)

	_schedule_target_refresh()


func _schedule_target_refresh() -> void:
	if _rebind_scheduled:
		return
	_rebind_scheduled = true
	call_deferred("_refresh_targets")


func _refresh_targets() -> void:
	_rebind_scheduled = false
	if not is_instance_valid(_weapon):
		_bolt_carrier = null
		_charging_handle = null
		return

	var new_bolt_carrier := _weapon.find_child(BOLT_CARRIER_NAME, true, false) as Node3D
	var new_charging_handle := _weapon.find_child(CHARGING_HANDLE_NAME, true, false) as Node3D

	_bolt_carrier = new_bolt_carrier
	_charging_handle = new_charging_handle

	if _bolt_carrier:
		_bolt_rest_pos = _bolt_carrier.position
	else:
		_bolt_rest_pos = Vector3.ZERO

	if _charging_handle:
		_ch_rest_pos = _charging_handle.position
	else:
		_ch_rest_pos = Vector3.ZERO


## bolt_moving 信号回调
## position: 0.0 = 闭锁（静息）, 1.0 = 全开（最大后退）
func _on_bolt_moving(position: float) -> void:
	if not is_instance_valid(_weapon):
		return

	var travel: float = 0.08
	var bolt_cfg := _weapon._get_attachment_config_of_type(BoltCarrierConfig) as BoltCarrierConfig
	if bolt_cfg:
		travel = bolt_cfg.bolt_travel_m

	var offset := Vector3(0.0, 0.0, clampf(position, 0.0, 1.0) * travel)
	if _bolt_carrier:
		_bolt_carrier.position = _bolt_rest_pos + offset
	if _charging_handle:
		_charging_handle.position = _ch_rest_pos + offset
