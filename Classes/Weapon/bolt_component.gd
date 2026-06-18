class_name BoltComponent
extends Node

signal cycle_completed()
signal bolt_reached_rear()
signal bolt_hold_open()

var config: WeaponConfig
var bolt_speed_open: float = 0.0
var bolt_speed_close: float = 0.0
var _is_locked: bool = true
var _is_held_open: bool = false

# 【已实现】
func initialize(cfg: WeaponConfig) -> void:
	config = cfg
	bolt_speed_open = cfg.muzzle_velocity * 0.15
	bolt_speed_close = cfg.recoil_spring_strength / cfg.bolt_mass * 0.02
	GlobalLogger.debug("BoltComponent", "BoltComponent initialized")

func is_locked() -> bool:
	return _is_locked

func is_held_open() -> bool:
	return _is_held_open

func on_bolt_start_back() -> void:
	_is_locked = false

func on_bolt_start_forward() -> void:
	# 【未实现/待扩展】此处可加入闭锁判定、上膛触发
	pass

func hold_open() -> void:
	_is_held_open = true

func release_bolt() -> void:
	_is_held_open = false
	# 【未实现/待扩展】释放枪机应触发复进（推弹入膛）
