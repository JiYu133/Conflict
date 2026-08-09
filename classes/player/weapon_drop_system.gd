class_name WeaponDropSystem
extends Node

## Shared death-time weapon physics for local players and Bots. The existing
## weapon instance is detached into an official RigidBody3D and restored on revive.

const DROPPED_WEAPON_COLLISION_LAYER := 4
const DROPPED_WEAPON_COLLISION_MASK := 0x7FFFFFFF

var _player: BasePlayer
var _weapon_manager: WeaponManager
var _dropped_body: RigidBody3D
var _dropped_weapon: BaseWeapon


func initialize(player: BasePlayer, weapon_manager: WeaponManager) -> void:
	_player = player
	_weapon_manager = weapon_manager
	if not _player:
		return
	if not _player.died.is_connected(_on_player_died):
		_player.died.connect(_on_player_died)
	if not _player.revived.is_connected(_on_player_revived):
		_player.revived.connect(_on_player_revived)


func drop_current_weapon() -> bool:
	if is_instance_valid(_dropped_body) or not _weapon_manager:
		return false
	var weapon := _weapon_manager.current_weapon
	if not is_instance_valid(weapon) or not weapon.config:
		return false
	if not weapon.config.dropped_collision_shape:
		GlobalLogger.warn("WeaponDropSystem", "Weapon '%s' has no dropped collision shape." % weapon.name)
		return false

	var world_parent := get_tree().current_scene
	if not is_instance_valid(world_parent):
		world_parent = _player.get_parent()
	if not is_instance_valid(world_parent):
		return false

	var weapon_transform := weapon.global_transform
	_dropped_body = RigidBody3D.new()
	_dropped_body.name = "%s_Dropped" % weapon.name
	_dropped_body.mass = maxf(weapon.get_total_weight(), 0.1)
	_dropped_body.collision_layer = DROPPED_WEAPON_COLLISION_LAYER
	_dropped_body.collision_mask = DROPPED_WEAPON_COLLISION_MASK
	_dropped_body.continuous_cd = true
	_dropped_body.linear_damp = 0.2
	_dropped_body.angular_damp = 1.5
	world_parent.add_child(_dropped_body)
	_dropped_body.global_transform = weapon_transform

	var collision := CollisionShape3D.new()
	collision.name = "DroppedWeaponCollision"
	collision.shape = weapon.config.dropped_collision_shape
	collision.position = weapon.config.dropped_collision_offset
	_dropped_body.add_child(collision)

	_dropped_weapon = _weapon_manager.detach_current_weapon_to(_dropped_body)
	if not is_instance_valid(_dropped_weapon):
		_dropped_body.queue_free()
		_dropped_body = null
		return false

	_dropped_body.linear_velocity = _player.velocity
	return true


func restore_current_weapon() -> bool:
	if not is_instance_valid(_dropped_body):
		_clear_drop_references()
		return false
	var restored := false
	if _weapon_manager:
		restored = _weapon_manager.restore_current_weapon_to_mount(_dropped_weapon)
	_dropped_body.queue_free()
	_clear_drop_references()
	return restored


func _on_player_died() -> void:
	drop_current_weapon()


func _on_player_revived() -> void:
	restore_current_weapon()


func _exit_tree() -> void:
	if is_instance_valid(_dropped_body):
		_dropped_body.queue_free()
	_clear_drop_references()


func _clear_drop_references() -> void:
	_dropped_body = null
	_dropped_weapon = null
