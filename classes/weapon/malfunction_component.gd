class_name MalfunctionComponent
extends Node

# ============================================================
# 武器故障/排障组件（物理驱动版）
# 功能：聚合 BoltComponent 和 EjectionComponent 的物理故障状态，
#       提供统一的故障查询接口和排障动作入口。
#       故障本身由各物理组件产生，本组件只负责协调排障流程。
#
# 故障类型与物理来源：
#   MISFIRE     — 底火未响（WeaponConfig.misfire_chance 在 _fire_one_round 抽取）
#                 结果：弹留膛内，枪机不启动循环
#   STOVEPIPE   — 弹壳卡抛壳口（EjectionComponent.attempt_eject 返回 false）
#                 结果：复进途中枪机停在中途
#   DOUBLE_FEED — 抛壳失败后枪机仍复进推入第二发（BoltComponent.trigger_double_feed）
#                 结果：两发卡死，需退弹匣+多次拉机柄+重装
#
# 排障流程：
#   MISFIRE     → 1 步：拉机柄（强制后坐抛出哑火弹 + 推新弹入膛）
#   STOVEPIPE   → 1 步：拉机柄（清除卡壳 + 强制归位）
#   DOUBLE_FEED → 3 步：退弹匣 → 拉机柄（两次抛出卡弹）→ 重新装填
# ============================================================

signal malfunction_occurred(type: BoltComponent.JamType)
signal malfunction_cleared()

var _bolt: BoltComponent
var _ejection: EjectionComponent
var _ammo: AmmoComponent
var config: WeaponConfig

# 哑火独立标志（BoltComponent 不感知哑火，由 BaseWeapon._fire_one_round 写入）
var _is_misfired: bool = false
# 双上膛排障步骤计数
var _double_feed_step: int = 0


func initialize(cfg: WeaponConfig, bolt: BoltComponent, ejection: EjectionComponent, ammo: AmmoComponent) -> void:
	config = cfg
	_bolt = bolt
	_ejection = ejection
	_ammo = ammo


# ============================================================
# 故障状态查询
# ============================================================

func has_malfunction() -> bool:
	return _is_misfired or _bolt.is_jammed()

func get_jam_type() -> BoltComponent.JamType:
	if _is_misfired:
		return BoltComponent.JamType.NONE  # 哑火不属于枪机卡弹，单独标志
	return _bolt.get_jam_type()

func is_misfired() -> bool:
	return _is_misfired


# ============================================================
# 故障触发（由 BaseWeapon 在物理事件发生时调用）
# ============================================================

## 哑火：底火未响，弹仍在膛内，枪机不启动循环
func trigger_misfire() -> void:
	_is_misfired = true
	malfunction_occurred.emit(BoltComponent.JamType.NONE)

## 烟囱卡弹：弹壳卡在抛壳口（由 EjectionComponent 通知后调用）
func trigger_stovepipe() -> void:
	_bolt.trigger_stovepipe()
	malfunction_occurred.emit(BoltComponent.JamType.STOVEPIPE)

## 双上膛：抛壳失败且枪机强行推入第二发
func trigger_double_feed() -> void:
	_bolt.trigger_double_feed()
	_double_feed_step = 0
	malfunction_occurred.emit(BoltComponent.JamType.DOUBLE_FEED)


# ============================================================
# 排障动作（每次玩家按排障键调用一次）
# 返回 true = 排障完全完成；false = 还需要继续操作
# ============================================================

## 尝试执行下一步排障动作
func attempt_clearance() -> bool:
	if _is_misfired:
		return _clear_misfire()
	match _bolt.get_jam_type():
		BoltComponent.JamType.STOVEPIPE:
			return _clear_stovepipe()
		BoltComponent.JamType.DOUBLE_FEED:
			return _clear_double_feed()
	return true


## 获取当前故障的总排障步骤数（供动画控制器查询）
func get_clearance_steps() -> int:
	if _is_misfired:
		return 1
	match _bolt.get_jam_type():
		BoltComponent.JamType.STOVEPIPE:
			return 1
		BoltComponent.JamType.DOUBLE_FEED:
			return 3
	return 0


# ============================================================
# 内部排障实现
# ============================================================

func _clear_misfire() -> bool:
	# 拉机柄：强制将哑火弹抽出（弹仍在膛，直接清空膛室即可）
	_ammo.chambered_round = false
	_ejection.clear_stuck_case()
	_bolt.clear_jam()
	_is_misfired = false
	malfunction_cleared.emit()
	return true

func _clear_stovepipe() -> bool:
	# 拉机柄：清除卡壳，枪机重新后坐到底再复进
	_ejection.clear_stuck_case()
	_bolt.clear_jam()
	malfunction_cleared.emit()
	return true

func _clear_double_feed() -> bool:
	_double_feed_step += 1
	match _double_feed_step:
		1:
			# 第 1 步：退出弹匣（清空弹匣进弹位，但不切换弹匣）
			# 实际上弹匣在玩家手中，此处将进弹准备状态清空
			_ammo.chambered_round = false
			_ammo._next_round_ready = false
			return false
		2:
			# 第 2 步：拉机柄（将枪机强行拉到后方，清出进弹口）
			_ejection.clear_stuck_case()
			_bolt.clear_jam()
			return false
		3:
			# 第 3 步：插回/换新弹匣并推弹入膛
			_ammo.swap_magazine()
			if _ammo.has_ammo():
				_ammo.prepare_next_round()
				_ammo.chamber_round()
			_double_feed_step = 0
			malfunction_cleared.emit()
			return true
	return false
