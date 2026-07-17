class_name FootIKController
extends Node

# 脚部 IK 控制器（未完成，默认关闭）
# 通过 enabled 开关控制，默认 false

@export var enabled: bool = false


func initialize(_model_manager: PlayerModelManager, _config) -> void:
	pass


func process_ik(_delta: float) -> void:
	pass
