class_name PlayerMovementController
extends Node

## 信号
signal jumped
signal landed
signal started_running
signal stopped_running

## 私有变量
var _player: CharacterBody3D
var _config: PlayerConfig
var _is_running: bool = false
var _velocity: Vector3
var _input_direction: Vector2

## 初始化
func initialize(player: CharacterBody3D, config: PlayerConfig) -> void:
	_player = player
	_config = config
