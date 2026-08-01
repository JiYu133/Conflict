class_name EjectionComponent
extends Node

# ============================================================
# 抛壳组件
# 功能：确定弹壳从抛壳窗飞出时的位置和初始速度。
#       被击发后的弹壳由枪机后坐抽出→抛壳挺撞击→抛出枪身。
#       支持物理故障模拟：抛壳有概率失败，导致烟囱卡弹或双上膛。
# 依赖：WeaponConfig（weapon_type / stovepipe_chance / double_feed_chance）
# ============================================================

var config: WeaponConfig

var _ejection_port_position: Vector3 = Vector3(0.05, 0.0, 0.2)
var _ejection_velocity: Vector3 = Vector3(1.0, 2.0, -0.5)
var _case_stuck: bool = false

# 可靠性参数（由枪管配件/枪机框配件提供）
var _stovepipe_chance: float = 0.0
var _misfire_chance: float = 0.0


func initialize(cfg: WeaponConfig) -> void:
	config = cfg
	_case_stuck = false
	GlobalLogger.debug("EjectionComponent", "初始化完成")


## 枪管配件装卸后调用，更新底火可靠性参数
func reconfigure(barrel_cfg: BarrelConfig) -> void:
	_misfire_chance = barrel_cfg.misfire_chance


## 枪机框配件装卸后调用，更新抛壳可靠性参数
func reconfigure_bolt(bolt_cfg: BoltCarrierConfig) -> void:
	_stovepipe_chance = bolt_cfg.stovepipe_chance


# ============================================================
# 抛壳尝试（带物理故障判定）
# ============================================================

## 尝试抛壳。返回 true = 正常抛出；false = 弹壳卡在抛壳口（烟囱/双上膛前兆）。
## 调用方（BaseWeapon._on_bolt_reached_rear）应根据返回值决定是否允许复进继续。
func attempt_eject() -> bool:
	_case_stuck = false
	if _stovepipe_chance > 0.0 and randf() < _stovepipe_chance:
		_case_stuck = true
		return false
	return true


## 弹壳是否卡在抛壳口（供枪机复进逻辑查询）
func is_case_stuck() -> bool:
	return _case_stuck


## 强制清除卡壳状态（排障拉机柄时调用）
func clear_stuck_case() -> void:
	_case_stuck = false


# ============================================================
# 抛壳参数查询
# ============================================================

## 获取弹壳弹出位置（相对武器节点的偏移）
func get_ejection_position() -> Vector3:
	return _ejection_port_position

## 获取弹壳初始速度（世界空间方向）
func get_ejection_velocity() -> Vector3:
	return _ejection_velocity

