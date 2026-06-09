class_name GasComponent
extends Node

var config: WeaponConfig

# 【已实现】
func initialize(cfg: WeaponConfig) -> void:
	config = cfg
	print("GasComponent 初始化完成")

func get_delay_time() -> float:
	# 简化为导气孔到枪机的时间
	var barrel_time = config.barrel_length / config.muzzle_velocity
	return barrel_time * 0.3
