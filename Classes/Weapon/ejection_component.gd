class_name EjectionComponent
extends Node

var config: WeaponConfig
var _ejection_port_position: Vector3 = Vector3(0.05, 0.0, 0.2)
var _ejection_velocity: Vector3 = Vector3(1.0, 2.0, -0.5)

# 【已实现】
func initialize(cfg: WeaponConfig) -> void:
	config = cfg
	print("EjectionComponent 初始化完成")
func get_ejection_position() -> Vector3:
	return _ejection_port_position

func get_ejection_velocity() -> Vector3:
	return _ejection_velocity
