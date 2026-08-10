class_name PlayerControlState
extends Node

## 玩家控制权组件。
## 生命周期状态、临时输入接管和外部控制请求彼此独立，最终控制权由本组件统一计算。

var _alive: bool = true
var _base_enabled: bool = true
var _locks: Dictionary = {}
var _mouse_requests: Dictionary = {}


func set_alive(value: bool) -> void:
	_alive = value


func set_base_enabled(value: bool) -> void:
	_base_enabled = value


func acquire_lock(owner: String) -> void:
	if not owner.is_empty():
		_locks[owner] = true


func release_lock(owner: String) -> void:
	if not owner.is_empty():
		_locks.erase(owner)


func has_lock(owner: String) -> bool:
	return _locks.has(owner)


func is_controllable() -> bool:
	return _alive and _base_enabled and _locks.is_empty()


## 鼠标模式由控制状态统一仲裁，避免暂停、自由视角和调试界面互相覆盖。
func request_mouse_mode(owner: String, mode: int, priority: int = 0) -> void:
	if owner.is_empty():
		return
	_mouse_requests[owner] = {"mode": mode, "priority": priority}
	_apply_mouse_mode()


func release_mouse_mode(owner: String) -> void:
	if owner.is_empty():
		return
	_mouse_requests.erase(owner)
	_apply_mouse_mode()


func _apply_mouse_mode() -> void:
	var selected_mode := Input.MOUSE_MODE_CAPTURED
	var selected_priority := -1
	for request in _mouse_requests.values():
		if int(request.priority) >= selected_priority:
			selected_priority = int(request.priority)
			selected_mode = int(request.mode)
	Input.set_mouse_mode(selected_mode)
