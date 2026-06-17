class_name RecoilComponent
extends Node

# ============================================================
# 后座组件
# 功能：模拟每发子弹射击后的枪口上跳以及准星自然回正。
#       后座角度累加后由外部每帧读取，用于驱动摄像机或准星偏移。
# 依赖：WeaponConfig（需要 recoil_vertical / recoil_recovery_speed）
# 说明：当前仅实现了垂直后座，水平后座（左右随机）尚未实现。
# ============================================================

var config: WeaponConfig
var _current_recoil_angle: float = 0.0
## 当前累积的后座角度（正值 = 枪口上抬）


# ============================================================
# 初始化
# ============================================================
func initialize(cfg: WeaponConfig) -> void:
	config = cfg
	print("RecoilComponent 初始化完成")


# ============================================================
# 后座逻辑
# ============================================================

## 应用一发子弹的后座
## 在每次 fired() 信号中调用，叠加 recoil_vertical 角度
func apply_recoil() -> void:
	_current_recoil_angle += config.recoil_vertical

## 每帧回正（控枪）
## 后座角度逐渐减小直到归零，模拟玩家控枪复位动作
func _process(delta: float) -> void:
	if _current_recoil_angle > 0.0:
		_current_recoil_angle -= config.recoil_recovery_speed * delta
		if _current_recoil_angle < 0.0:
			_current_recoil_angle = 0.0

## 获取当前后座偏移量
## 外部（如摄像机控制器）每帧调用此函数获得当前枪口上跳角度
func get_recoil_offset() -> float:
	return _current_recoil_angle
