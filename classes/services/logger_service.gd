class_name LoggerService
extends Node
## 日志服务契约（问题清单 R7：GlobalLogger 硬编码 121 处、0 注入）。
##
## 契约：debug / info / warn / error(module, message) 四个级别，与 GlobalLogger 逐字一致。
##
## 本类自身就是**静默实现**（方法体为空）——不是一个纯接口壳子。需要静默日志时
## （单测、发布版、压测），把持有者的 `_logger` 覆盖为 `LoggerService.new()` 即可，
## 调用点一个字都不用改。参数以 `_` 前缀标记为接口占位，静默实现不消费它们。
##
## 默认实现是 autoload `GlobalLogger`（res://classes/services/game_logger.gd），
## 它继承本类并覆写四个方法，输出行为与本刀之前逐字一致。

func debug(_module: String, _message: String) -> void:
	pass


func info(_module: String, _message: String) -> void:
	pass


func warn(_module: String, _message: String) -> void:
	pass


func error(_module: String, _message: String) -> void:
	pass
