class_name FireControlComponent
extends Node

signal trigger_pulled()
signal trigger_released()

var config: WeaponConfig
var _trigger_reset: bool = true

# 【已实现】
func initialize(cfg: WeaponConfig) -> void:
	config = cfg
	print("FireControl 初始化完成")

func press_trigger(mode: String) -> void:
	if mode == "safe":
		return
	match mode:
		"semi":
			if _trigger_reset:
				trigger_pulled.emit()
				_trigger_reset = false
		"auto":
			trigger_pulled.emit()

func release_trigger() -> void:
	_trigger_reset = true
	trigger_released.emit()
