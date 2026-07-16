class_name RecoilComponent
extends Node

# ============================================================
# 后座组件
# 功能：模拟每发子弹射击后的枪口上跳以及准星自然回正。
#       后座角度累加后由外部每帧读取，用于驱动摄像机或准星偏移。
# 依赖：WeaponConfig（需要 recoil_vertical / recoil_horizontal / recoil_recovery_speed）
#       AttachmentManager（用于读取配件的后座修正）
# ============================================================

var config: WeaponConfig
var attachment_manager: AttachmentManager
var _current_recoil_angle: float = 0.0
## 当前累积的后座角度（正值 = 枪口上抬）
var _current_recoil_horizontal: float = 0.0
## 当前累积的水平后座角度（正值 = 向右偏移，负值 = 向左偏移）


# ============================================================
# 初始化
# ============================================================
func initialize(cfg: WeaponConfig, am: AttachmentManager = null) -> void:
	config = cfg
	attachment_manager = am
	GlobalLogger.debug("RecoilComponent", "Initialized for: " + cfg.weapon_name)


# ============================================================
# 后座逻辑
# ============================================================

## 应用一发子弹的后座
## 在每次 fired() 信号中调用，叠加垂直与水平后座角度
func apply_recoil() -> void:
	var vertical_recoil = config.recoil_vertical
	var horizontal_recoil = config.recoil_horizontal
	if attachment_manager:
		vertical_recoil += attachment_manager.get_total_recoil_vertical_modifier()
		horizontal_recoil += attachment_manager.get_total_recoil_horizontal_modifier()

	_current_recoil_angle += max(vertical_recoil, 0.0)
	horizontal_recoil = max(horizontal_recoil, 0.0)
	if horizontal_recoil > 0.0:
		_current_recoil_horizontal += randf_range(-horizontal_recoil, horizontal_recoil)

## 每帧回正（控枪）
## 后座角度逐渐减小直到归零，模拟玩家控枪复位动作
func _process(delta: float) -> void:
	var recovery_speed = config.recoil_recovery_speed
	if attachment_manager:
		recovery_speed += attachment_manager.get_total_recoil_recovery_modifier()
	recovery_speed = max(recovery_speed, 0.0)

	_current_recoil_angle = move_toward(_current_recoil_angle, 0.0, recovery_speed * delta)
	_current_recoil_horizontal = move_toward(_current_recoil_horizontal, 0.0, recovery_speed * delta)

## 获取当前后座偏移量
## 外部（如摄像机控制器）每帧调用此函数获得当前枪口上跳角度
func get_recoil_offset() -> float:
	return _current_recoil_angle

## 获取当前水平后座偏移量
## 外部如需要左右晃动，可读取此值叠加到准星或相机 yaw
func get_recoil_horizontal_offset() -> float:
	return _current_recoil_horizontal
