class_name RecoilComponent
extends Node

var config: WeaponConfig
var _current_recoil_angle: float = 0.0

# 【已实现】
func initialize(cfg: WeaponConfig) -> void:
	config = cfg
	print("RecoilComponent 初始化完成")

func apply_recoil() -> void:
	_current_recoil_angle += config.recoil_vertical

func _process(delta: float) -> void:
	if _current_recoil_angle > 0.0:
		_current_recoil_angle -= config.recoil_recovery_speed * delta
		if _current_recoil_angle < 0.0:
			_current_recoil_angle = 0.0

func get_recoil_offset() -> float:
	return _current_recoil_angle
