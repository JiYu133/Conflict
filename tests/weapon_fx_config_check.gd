extends Node


func _ready() -> void:
	_run.call_deferred()


func _run() -> void:
	var config := load("res://assets/config/weapons/fx/weapon_fx_config.tres") as WeaponFXConfig
	_check(config != null, "weapon FX config loads")
	if config:
		_check(config.flash_scenes_short_barrel.size() == 3, "short barrel variants")
		_check(config.flash_scenes_standard.size() == 3, "standard barrel variants")
		_check(config.flash_scenes_long_barrel.size() == 3, "long barrel variants")
		_check(config.flash_scenes_muzzle_brake_standard.size() == 3, "muzzle brake variants")
		_check(config.flash_scenes_suppressor_standard.size() == 3, "suppressor variants")
		var flash_hider := config.resolve_muzzle_profile(0.415, WeaponFXConfig.MuzzleKind.FLASH_HIDER)
		_check(flash_hider.scene != null, "flash hider reuses standard flash")
		_check(flash_hider.profile == WeaponFXConfig.MuzzleProfile.FLASH_HIDER, "flash hider profile")
		var scene := config.flash_scenes_standard[0]
		var sequence := scene.instantiate() as MuzzleFlashSequence
		_check(sequence != null, "muzzle flash scene instantiates")
		if sequence:
			sequence.force_front_view = true
			get_tree().root.add_child(sequence)
			await get_tree().process_frame
			var sprite := sequence.get_node_or_null("Sequence") as AnimatedSprite3D
			_check(sprite != null, "sequence creates animated sprite")
			if sprite:
				_check(sprite.sprite_frames.get_frame_count(&"flash") == 8, "sequence loads 8 key frames")
				_check(sprite.is_playing(), "sequence starts playback")
				_check(not sprite.no_depth_test, "muzzle flash respects wall depth")
				var first_texture := sprite.sprite_frames.get_frame_texture(&"flash", 0)
				_check(first_texture != null and first_texture.get_width() <= 1024, "sequence textures are capped at 1024 px")
			sequence.queue_free()
			await get_tree().process_frame
			var cached_start := Time.get_ticks_usec()
			for index in 10:
				var cached_sequence := scene.instantiate() as MuzzleFlashSequence
				get_tree().root.add_child(cached_sequence)
				await get_tree().process_frame
				cached_sequence.queue_free()
			var cached_elapsed_ms := float(Time.get_ticks_usec() - cached_start) / 1000.0
			_check(cached_elapsed_ms < 100.0, "cached sequence spawning stays under 100 ms for 10 instances")
			var low_sequence := scene.instantiate() as MuzzleFlashSequence
			low_sequence.force_front_view = true
			low_sequence.quality = "low"
			get_tree().root.add_child(low_sequence)
			await get_tree().process_frame
			var low_sprite := low_sequence.get_node_or_null("Sequence") as AnimatedSprite3D
			_check(low_sprite != null and low_sprite.sprite_frames.get_frame_count(&"flash") == 4, "low quality loads 4 key frames")
			low_sequence.queue_free()
			var medium_sequence := scene.instantiate() as MuzzleFlashSequence
			medium_sequence.force_front_view = true
			medium_sequence.quality = "medium"
			get_tree().root.add_child(medium_sequence)
			await get_tree().process_frame
			var medium_sprite := medium_sequence.get_node_or_null("Sequence") as AnimatedSprite3D
			_check(medium_sprite != null and medium_sprite.sprite_frames.get_frame_count(&"flash") == 6, "medium quality loads 6 key frames")
			medium_sequence.queue_free()
	_test_forward_muzzle_selection(config)
	_test_flash_follows_muzzle_marker(config)
	get_tree().quit(0 if _failures == 0 else 1)


func _test_forward_muzzle_selection(config: WeaponFXConfig) -> void:
	var weapon := BaseWeapon.new()
	weapon.name = "MuzzleSelectionWeapon"
	get_tree().root.add_child(weapon)
	var receiver_muzzle := Marker3D.new()
	receiver_muzzle.name = "Muzzle"
	receiver_muzzle.position = Vector3(0.0, 0.0, -0.4)
	weapon.add_child(receiver_muzzle)
	var barrel_muzzle := Marker3D.new()
	barrel_muzzle.name = "Muzzle"
	barrel_muzzle.position = Vector3(0.0, 0.0, -0.9)
	weapon.add_child(barrel_muzzle)
	var controller := WeaponFXController.new()
	weapon.add_child(controller)
	controller.initialize(weapon, config)
	_check(controller._muzzle_point == barrel_muzzle, "forward-most muzzle marker is selected")
	weapon.queue_free()


func _test_flash_follows_muzzle_marker(config: WeaponFXConfig) -> void:
	var weapon := BaseWeapon.new()
	weapon.name = "MuzzleFollowWeapon"
	get_tree().root.add_child(weapon)
	var muzzle := Marker3D.new()
	muzzle.name = "Muzzle"
	muzzle.position = Vector3(0.0, 0.0, -0.8)
	weapon.add_child(muzzle)
	var controller := WeaponFXController.new()
	weapon.add_child(controller)
	controller.initialize(weapon, config)

	var flash_template := Node3D.new()
	var flash_scene := PackedScene.new()
	_check(flash_scene.pack(flash_template) == OK, "test muzzle flash scene packs")
	flash_template.free()
	controller._spawn_flash({"scene": flash_scene, "scale": 1.0, "lifetime": 1.0}, muzzle.global_transform)
	var flash := muzzle.get_child(muzzle.get_child_count() - 1) as Node3D
	_check(flash != null and flash.is_in_group("weapon_muzzle_flash_effects"), "muzzle flash is parented to muzzle marker")
	if flash:
		muzzle.position += Vector3(0.2, 0.1, -0.3)
		_check(flash.global_position.is_equal_approx(muzzle.global_position), "muzzle flash follows marker movement")
	weapon.queue_free()


var _failures := 0


func _check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		_failures += 1
		push_error("FAIL: " + label)
