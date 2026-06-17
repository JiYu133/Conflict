class_name BoltComponent
extends Node

# ============================================================
# 枪机组件
# 功能：模拟枪机开锁→后坐→复进→闭锁的完整自动循环。
#       枪机状态是武器能否击发的关键前提。
# 依赖：WeaponConfig（需要 bolt_mass / recoil_spring_strength 等）
# 信号：由 BaseWeapon._update_cycle() 在枪机到达特定位置时触发
# ============================================================

# 信号 ────────────────────────────────────────────────────
signal cycle_completed()
## 枪机完成一个完整的自动循环（复进到位→闭锁）
signal bolt_reached_rear()
## 枪机后坐到位，到达行程终点（此时可抛壳、准备推弹）
signal bolt_hold_open()
## 枪机被挂起锁定在后方（空仓挂机状态）

# 公开属性 ────────────────────────────────────────────────
var config: WeaponConfig            # 武器配置引用
var bolt_speed_open: float = 0.0    # 枪机后坐速度，单位：m/s（由初速和枪机质量换算）
var bolt_speed_close: float = 0.0   # 枪机复进速度，单位：m/s（由复进簧刚度和枪机质量换算）

# 私有属性 ────────────────────────────────────────────────
var _is_locked: bool = true         # 枪机是否已闭锁。true = 可击发
var _is_held_open: bool = false     # 枪机是否处于空仓挂机状态


# ============================================================
# 初始化
# ============================================================
func initialize(cfg: WeaponConfig) -> void:
	config = cfg

	# 枪机速度换算
	# 后坐速度：取初速的 15% 作为近似（实际取决于枪机质量和火药燃气的动量守恒）
	bolt_speed_open = cfg.muzzle_velocity * 0.15
	# 复进速度：F = k/m × t 的简化版本，取一个经验系数 0.02 使数值合理
	bolt_speed_close = cfg.recoil_spring_strength / cfg.bolt_mass * 0.02

	# 注册自动循环完成后的闭锁回调
	cycle_completed.connect(_on_cycle_completed)

	print("BoltComponent 初始化完成")


# ============================================================
# 状态查询
# ============================================================
func is_locked() -> bool:
	## 枪机是否闭锁。只有 locked = true 时才能击发
	return _is_locked

func is_held_open() -> bool:
	## 枪机是否被空仓挂机卡住（打空弹匣后停留在后方）
	return _is_held_open


# ============================================================
# 枪机状态切换
# ============================================================

## 枪机开始后坐（击发后导气活塞推动枪机向后）
func on_bolt_start_back() -> void:
	_is_locked = false  # 开锁，枪机开始向后运动

## 枪机开始复进（复进簧推着枪机向前回位）
func on_bolt_start_forward() -> void:
	_is_locked = false  # 开锁状态，枪机正在前进，尚未闭锁

## 空仓挂起：将枪机锁定在后方位置
func hold_open() -> void:
	_is_held_open = true

## 释放枪机（按下空仓挂机解脱钮 / 拉机柄轻拉再放）
func release_bolt() -> void:
	_is_held_open = false
	# 【未实现 / 待扩展】
	# 释放枪机应触发复进（推弹入膛），当前由 BaseWeapon.reload() 中手动调用 _start_bolt_forward()


# ============================================================
# 内部回调
# ============================================================

## 自动循环完成 → 枪机恢复闭锁状态
func _on_cycle_completed() -> void:
	_is_locked = true
