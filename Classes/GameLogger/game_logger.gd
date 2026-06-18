class_name GameLogger
extends Node

## 用法：Logger.info("模块名", "消息")
## 级别：DEBUG < INFO < WARN < ERROR

enum Level {
	DEBUG = 0,
	INFO  = 1,
	WARN  = 2,
	ERROR = 3,
}

## 最低显示级别；低于此级别的日志会被静默丢弃
@export var minimum_level: Level = Level.DEBUG


func debug(module: String, message: String) -> void:
	_log(Level.DEBUG, module, message)


func info(module: String, message: String) -> void:
	_log(Level.INFO, module, message)


func warn(module: String, message: String) -> void:
	_log(Level.WARN, module, message)


func error(module: String, message: String) -> void:
	_log(Level.ERROR, module, message)


func _log(level: Level, module: String, message: String) -> void:
	if level < minimum_level:
		return

	var prefix := _level_prefix(level)
	var timestamp := Time.get_time_string_from_system()
	var line := str("[", timestamp, "] ", prefix, " [", module, "] ", message)

	if level >= Level.ERROR:
		printerr(line)
	elif level >= Level.WARN:
		push_warning(line)
		print(line)
	else:
		print(line)


func _level_prefix(level: Level) -> String:
	match level:
		Level.DEBUG: return "DEBUG"
		Level.INFO:  return "INFO"
		Level.WARN:  return "WARN"
		Level.ERROR: return "ERROR"
	return "???"
