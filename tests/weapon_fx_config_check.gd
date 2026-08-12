extends SceneTree


func _init() -> void:
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
			root.add_child(sequence)
			await process_frame
			var sprite := sequence.get_node_or_null("Sequence") as AnimatedSprite3D
			_check(sprite != null, "sequence creates animated sprite")
			if sprite:
				_check(sprite.sprite_frames.get_frame_count(&"flash") == 8, "sequence loads 8 key frames")
				_check(sprite.is_playing(), "sequence starts playback")
				_check(not sprite.no_depth_test, "muzzle flash respects wall depth")
				var first_texture := sprite.sprite_frames.get_frame_texture(&"flash", 0)
				_check(first_texture != null and first_texture.get_width() <= 1024, "sequence textures are capped at 1024 px")
			sequence.queue_free()
			await process_frame
			var cached_start := Time.get_ticks_usec()
			for index in 10:
				var cached_sequence := scene.instantiate() as MuzzleFlashSequence
				root.add_child(cached_sequence)
				await process_frame
				cached_sequence.queue_free()
			var cached_elapsed_ms := float(Time.get_ticks_usec() - cached_start) / 1000.0
			_check(cached_elapsed_ms < 100.0, "cached sequence spawning stays under 100 ms for 10 instances")
			var low_sequence := scene.instantiate() as MuzzleFlashSequence
			low_sequence.force_front_view = true
			low_sequence.quality = "low"
			root.add_child(low_sequence)
			await process_frame
			var low_sprite := low_sequence.get_node_or_null("Sequence") as AnimatedSprite3D
			_check(low_sprite != null and low_sprite.sprite_frames.get_frame_count(&"flash") == 4, "low quality loads 4 key frames")
			low_sequence.queue_free()
			var medium_sequence := scene.instantiate() as MuzzleFlashSequence
			medium_sequence.force_front_view = true
			medium_sequence.quality = "medium"
			root.add_child(medium_sequence)
			await process_frame
			var medium_sprite := medium_sequence.get_node_or_null("Sequence") as AnimatedSprite3D
			_check(medium_sprite != null and medium_sprite.sprite_frames.get_frame_count(&"flash") == 6, "medium quality loads 6 key frames")
			medium_sequence.queue_free()
	quit(0 if _failures == 0 else 1)


var _failures := 0


func _check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		_failures += 1
		push_error("FAIL: " + label)
