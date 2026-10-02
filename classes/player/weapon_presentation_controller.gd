class_name WeaponPresentationController
extends Node

## Owns the local weapon display offset. It never samples or writes hand bones.

var _weapon_manager: WeaponManager
var _sway_pivot: Node3D
var _ads_progress: float = 0.0
var _ads_target: bool = false
var _ads_transition_time: float = 0.25
var _ads_center_offset: Vector3 = Vector3.ZERO


func initialize(weapon_manager: WeaponManager) -> void:
	_weapon_manager = weapon_manager
	if is_instance_valid(_weapon_manager):
		if not _weapon_manager.weapon_changed.is_connected(_on_weapon_changed):
			_weapon_manager.weapon_changed.connect(_on_weapon_changed)
		if not _weapon_manager.aiming_changed.is_connected(_on_aiming_changed):
			_weapon_manager.aiming_changed.connect(_on_aiming_changed)
		_on_weapon_changed(_weapon_manager.current_weapon)
	set_process(true)


func setup_weapon_mount(weapon_mount: Node3D) -> Node3D:
	if not is_instance_valid(weapon_mount):
		return null
	if is_instance_valid(_sway_pivot) and _sway_pivot.get_parent() == weapon_mount:
		return _sway_pivot
	_sway_pivot = Node3D.new()
	_sway_pivot.name = "WeaponSwayPivot"
	weapon_mount.add_child(_sway_pivot)
	return _sway_pivot


func _on_weapon_changed(weapon: BaseWeapon) -> void:
	if not is_instance_valid(weapon) or not weapon.config:
		_ads_transition_time = 0.25
		_ads_center_offset = Vector3.ZERO
		return
	_ads_transition_time = maxf(weapon.config.ads_time, 0.001)
	_ads_center_offset = weapon.config.ads_center_offset


func _on_aiming_changed(aiming: bool) -> void:
	_ads_target = aiming
	if is_instance_valid(_weapon_manager) and is_instance_valid(_weapon_manager.current_weapon):
		_on_weapon_changed(_weapon_manager.current_weapon)


func _process(delta: float) -> void:
	if not is_instance_valid(_sway_pivot):
		return
	var target := 1.0 if _ads_target else 0.0
	_ads_progress = move_toward(_ads_progress, target, delta / _ads_transition_time)
	var blend := _ads_progress * _ads_progress * (3.0 - 2.0 * _ads_progress)
	var offset := _ads_center_offset * blend
	_sway_pivot.position.x = offset.x
	_sway_pivot.position.y = offset.y


func get_sway_pivot() -> Node3D:
	return _sway_pivot


func get_ads_progress() -> float:
	return _ads_progress
