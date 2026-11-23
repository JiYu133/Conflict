extends Node

var failures := 0
var weapon: BaseWeapon
var manager: WeaponManager
var impacts: ImpactRecorder
var ballistics: BallisticProjectileSystem
var reload_completions := 0
var finished_stages: Array[int] = []


# Keep the owning-player contract, without unrelated player subsystems.
class TestPlayer extends BasePlayer:
	func _ready() -> void:
		pass
	func _process(_delta: float) -> void:
		pass
	func _physics_process(_delta: float) -> void:
		pass


class ImpactRecorder extends HealthSystem:
	var directions: Array[Vector3] = []
	func apply_damage(info: DamageInfo) -> void:
		directions.append(info.direction)


func _ready() -> void:
	_run.call_deferred()


func _check(ok: bool, message: String) -> void:
	if not ok:
		failures += 1
		push_error(message)


func _frames(count: int) -> void:
	for i in count:
		await get_tree().process_frame


func _run() -> void:
	var player := TestPlayer.new()
	add_child(player)
	manager = WeaponManager.new()
	player.weapon_manager = manager
	player.add_child(manager)
	var mount := Node3D.new()
	player.add_child(mount)
	mount.position.y = 50.0
	manager.set_mount(mount)
	var config := load("res://assets/config/player/player_config.tres") as PlayerConfig
	manager.load_and_equip(config.starting_weapon.duplicate(true))
	weapon = manager.current_weapon
	weapon.set_process(false)
	weapon.global_transform = Transform3D(Basis.IDENTITY, Vector3(0, 50, 0))
	weapon.reload_finished.connect(func(): reload_completions += 1)
	weapon.reload_stage_finished.connect(func(stage: int): finished_stages.append(stage))
	ballistics = BallisticProjectileSystem.get_or_create(get_tree())
	ballistics.set_physics_process(false)

	# A real collider and damage sink observe the hitscan launch direction.
	var target := TestPlayer.new()
	add_child(target)
	impacts = ImpactRecorder.new()
	impacts.name = "HealthSystem"
	target.add_child(impacts)
	impacts.set_physics_process(false)
	var body := StaticBody3D.new()
	body.collision_layer = PhysicsLayers.WORLD
	body.position = Vector3(0, 50, -25)
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(100, 100, 1)
	collision.shape = shape
	body.add_child(collision)
	target.add_child(body)
	await get_tree().physics_frame
	await get_tree().physics_frame

	await _test_reload_restart(false)
	await _test_reload_restart(true)
	_test_muzzle_authority()
	_test_missing_barrel()
	for bullet in ballistics._bullets:
		ballistics._destroy_bullet_visual(bullet)
	ballistics._bullets.clear()
	ballistics.queue_free()
	player.queue_free()
	target.queue_free()
	weapon = null
	manager = null
	impacts = null
	ballistics = null
	await _frames(2)
	print("combat_regression_check=%s failures=%d" % ["ok" if failures == 0 else "FAILED", failures])
	get_tree().quit(0 if failures == 0 else 1)


func _test_reload_restart(staged: bool) -> void:
	var mag := weapon._get_attachment_config_of_type(MagazineConfig) as MagazineConfig
	mag.reload_time = 0.6
	mag.stage_mag_out_time = 0.2 if staged else 0.0
	mag.stage_mag_in_time = 0.4 if staged else 0.0
	mag.stage_charge_time = 0.0
	weapon.debug_set_ammo_state(1, 100, true)
	reload_completions = 0
	finished_stages.clear()
	weapon.reload()
	await _frames(16 if staged else 12)
	if staged:
		_check(weapon._reload_done_stages.has(BaseWeapon.ReloadStage.MAG_OUT), "completed magazine-out stage is retained")
	weapon.interrupt_reload()
	weapon.reload()
	# Cross the cancelled timer's deadline, but not the replacement timer's.
	await _frames(23 if staged else 27)
	_check(weapon.is_reloading and reload_completions == 0, "cancelled timer cannot finish replacement reload (staged=%s)" % staged)
	_check(weapon.ammo_component.get_current_magazine_count() == 1, "replacement reload does not swap ammunition early")
	await _frames(10 if staged else 16)
	_check(not weapon.is_reloading and reload_completions == 1, "replacement reload completes exactly once")
	if staged:
		_check(finished_stages.count(BaseWeapon.ReloadStage.MAG_OUT) == 1, "resumed reload skips previously completed stage")
		_check(finished_stages.count(BaseWeapon.ReloadStage.MAG_IN) == 1, "cancelled magazine-in stage cannot emit completion")
	# Let any stale coroutine expire before the following case.
	await _frames(45)


func _test_muzzle_authority() -> void:
	var barrel := weapon._get_attachment_config_of_type(BarrelConfig) as BarrelConfig
	barrel.enable_ballistic_random_spread = false
	barrel.charge_variation = 0.0
	weapon.config.hipfire_spread = 10.0
	weapon.config.ads_spread = 0.2
	for simulated in [true, false]:
		weapon.config.use_ballistic_simulation = simulated
		for ads in [false, true]:
			manager.set_aiming(ads)
			impacts.directions.clear()
			seed(1729)
			var maximum := 0.0
			for shot in 24:
				weapon._spawn_projectile()
				var direction: Vector3
				if simulated:
					direction = (ballistics._bullets.back().velocity as Vector3).normalized()
				elif impacts.directions.size() > shot:
					direction = impacts.directions[shot]
				else:
					_check(false, "hitscan reaches the recording target")
					break
				maximum = maxf(maximum, rad_to_deg(weapon._get_muzzle_direction().angle_to(direction)))
			_check(maximum < 0.05, "projectiles follow the physical muzzle with ballistic randomness disabled (simulated=%s ADS=%s)" % [simulated, ads])
			_check(is_equal_approx(weapon.config.hipfire_spread, 10.0) and is_equal_approx(weapon.config.ads_spread, 0.2), "ADS preserves legacy spread resources")
	manager.set_aiming(false)


func _test_missing_barrel() -> void:
	var barrel_node: BaseAttachment
	for attachment in weapon.attachment_manager.get_all_attachments():
		if attachment.config is BarrelConfig:
			barrel_node = attachment
			break
	var slot := barrel_node.get_parent() as AttachmentSlot
	var slot_key := slot.get_slot_key()
	var config := barrel_node.config
	var detached_nodes: Array[BaseAttachment] = []
	var on_detached := func(_slot: AttachmentSlot, attachment: BaseAttachment):
		detached_nodes.append(attachment)
	weapon.attachment_manager.attachment_detached.connect(on_detached)
	var detached := weapon.detach_attachment(slot_key)
	weapon.attachment_manager.attachment_detached.disconnect(on_detached)
	_check(detached != null, "barrel is detached for the firing check")
	weapon.debug_set_ammo_state(5, 100, true)
	var fired := []
	var recoils := []
	weapon.fired.connect(func(): fired.append(true))
	weapon.recoil_component.physical_recoil_applied.connect(func(_data: Dictionary): recoils.append(true))
	var before_count := weapon.ammo_component.get_current_magazine_count()
	weapon._fire_one_round()
	_check(weapon.ammo_component.has_chambered_round(), "missing barrel does not consume the chambered round")
	_check(weapon.ammo_component.get_current_magazine_count() == before_count, "missing barrel does not consume magazine ammunition")
	_check(not weapon.is_cycling and fired.is_empty() and recoils.is_empty(), "missing barrel does not cycle, emit a shot, or apply recoil")
	_check(weapon.equip_attachment(slot_key, config), "barrel can be reinstalled")
	weapon.config.use_ballistic_simulation = true
	weapon._fire_one_round()
	_check(not weapon.ammo_component.has_chambered_round() and fired.size() == 1 and recoils.size() == 1, "valid reassembled weapon fires normally")
	for attachment in detached_nodes:
		attachment.queue_free()
