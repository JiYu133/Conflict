class_name WeaponManager
extends Node

signal weapon_changed(new_weapon: BaseWeapon)
signal weapon_fired(weapon: BaseWeapon)

var current_weapon: BaseWeapon
var weapon_mount: Node3D
var is_aiming: bool = false


func equip_weapon(weapon: BaseWeapon) -> void:
	if current_weapon:
		current_weapon.queue_free()
	current_weapon = weapon
	if weapon_mount:
		weapon_mount.add_child(weapon)
		weapon.position = Vector3.ZERO
		weapon.rotation = Vector3.ZERO
	weapon_changed.emit(current_weapon)

func set_mount(mount: Node3D) -> void:
	weapon_mount = mount

func press_trigger() -> void:
	if current_weapon:
		current_weapon.press_trigger()

func release_trigger() -> void:
	if current_weapon:
		current_weapon.release_trigger()

func reload() -> void:
	if current_weapon:
		current_weapon.reload()

func cycle_fire_mode() -> void:
	if current_weapon:
		current_weapon.cycle_fire_mode()

func set_aiming(aiming: bool) -> void:
	is_aiming = aiming
	
## 根据配置和模型路径创建武器实例并装备
func load_and_equip(config: WeaponConfig) -> void:
	print("装备武器 " + config.weapon_name)
	var weapon_scene = config.weapon_scene
	var weapon = weapon_scene.instantiate() as BaseWeapon
	if not weapon:
		push_error("武器场景的根节点不是 BaseWeapon")
		return
	weapon.initialize(config)
	equip_weapon(weapon)	
	
