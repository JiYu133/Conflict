class_name BoltComponent
extends Node

# ============================================================
# 枪机组件
# 功能：模拟枪机开锁→后坐→复进→闭锁的完整自动循环。
#       枪机状态是武器能否击发的关键前提。
#       支持物理故障状态：卡弹（复进受阻）、双上膛（两发卡死）。
# 依赖：WeaponConfig（需要 bolt_mass / recoil_spring_strength 等）
# 信号：由 BaseWeapon._update_cycle() 在枪机到达特定位置时触发
# ============================================================

# 枪机故障状态枚举
enum JamType {
	NONE,
	STOVEPIPE,    # 烟囱卡弹：弹壳卡住，枪机停在中途
	DOUBLE_FEED,  # 双上膛：两发子弹卡死进弹口
}

# 信号 ────────────────────────────────────────────────────
signal cycle_completed()
## 枪机完成一个完整的自动循环（复进到位→闭锁）
signal bolt_reached_rear()
## 枪机后坐到位，到达行程终点（此时可抛壳、准备推弹）
signal bolt_hold_open()
## 枪机被挂起锁定在后方（空仓挂机状态）
signal jammed(type: JamType)
## 枪机发生卡弹故障

# 公开属性 ────────────────────────────────────────────────
var config: WeaponConfig            # 武器配置引用
var bolt_speed_open: float = 0.0    # 枪机后坐速度，单位：m/s
var bolt_speed_close: float = 0.0   # 枪机复进速度，单位：m/s

# 私有属性 ────────────────────────────────────────────────
var _is_locked: bool = true         # 枪机是否已闭锁
var _is_held_open: bool = false     # 枪机是否处于空仓挂机状态
var _jam_type: JamType = JamType.NONE  # 当前故障类型


# ============================================================
# 初始化
# ============================================================
func initialize(cfg: WeaponConfig) -> void:
	config = cfg

	bolt_speed_open = cfg.muzzle_velocity * 0.15
	var mass = cfg.bolt_mass if cfg.bolt_mass > 0.001 else 0.3
	var spring = cfg.recoil_spring_strength if cfg.recoil_spring_strength > 0.001 else 50.0
	bolt_speed_close = spring / mass * 0.02

	cycle_completed.connect(_on_cycle_completed)

	print("BoltComponent 初始化完成")


# ============================================================
# 状态查询
# ============================================================
func is_locked() -> bool:
	return _is_locked

func is_held_open() -> bool:
	return _is_held_open

func is_jammed() -> bool:
	return _jam_type != JamType.NONE

func get_jam_type() -> JamType:
	return _jam_type


# ============================================================
# 枪机状态切换
# ============================================================

func on_bolt_start_back() -> void:
	_is_locked = false

func on_bolt_start_forward() -> void:
	_is_locked = false

func hold_open() -> void:
	_is_held_open = true

func release_bolt() -> void:
	_is_held_open = false


# ============================================================
# 物理故障接口
# ============================================================

## 触发烟囱卡弹：复进途中弹壳阻挡枪机，停在指定位置
## 由 BaseWeapon._update_cycle() 在检测到弹壳卡住时调用
func trigger_stovepipe() -> void:
	_jam_type = JamType.STOVEPIPE
	jammed.emit(JamType.STOVEPIPE)

## 触发双上膛：枪机强行复进推入第二发，两发卡死
## 由 BaseWeapon._update_cycle() 在抛壳失败且枪机完成复进时调用
func trigger_double_feed() -> void:
	_jam_type = JamType.DOUBLE_FEED
	jammed.emit(JamType.DOUBLE_FEED)

## 排障：清除所有卡弹状态（物理拉机柄动作完成后调用）
func clear_jam() -> void:
	_jam_type = JamType.NONE
	_is_locked = false


# ============================================================
# 内部回调
# ============================================================

func _on_cycle_completed() -> void:
	_is_locked = true

