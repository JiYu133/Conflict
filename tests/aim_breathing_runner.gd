extends Node

var failures := 0
var _authored_pose: Array[Quaternion] = []


func _ready() -> void:
	_run.call_deferred()


func _run() -> void:
	var map := (load("res://assets/map/TestMap.tscn") as PackedScene).instantiate()
	get_tree().root.add_child(map)
	await _frames(120)
	var player := map.get_node("CharacterBody3D") as BasePlayer
	var weapon := player.weapon_manager.current_weapon
	_check(weapon != null, "weapon equipped")
	if not weapon:
		_finish()
		return
	var config := player.player_config.aim_config
	_check(config != null and config.resource_path == "res://assets/config/player/aim_config_default.tres",
		"default player exposes the editable aim config")
	_test_timing(player, weapon)
	_test_input(player)
	await _test_live_breathing(player, weapon)
	await _test_idle_playback(player)
	_finish()


func _test_timing(player: BasePlayer, weapon: BaseWeapon) -> void:
	var camera := player.camera_controller
	var timing := AimConfig.new()
	camera.set_aim_config(timing)
	var weapon_time := weapon.get_effective_ads_time()
	var stats := weapon.get_stats_snapshot()
	player.weapon_manager.set_aiming(true)
	camera._ads_progress = 0.0
	camera._update_ads(weapon_time * 0.25)
	_check(is_equal_approx(camera.get_ads_progress(), 0.25), "1x raise rate uses weapon/attachment time")
	timing.raise_speed = 2.0
	camera._ads_progress = 0.0
	camera._update_ads(weapon_time * 0.25)
	_check(is_equal_approx(camera.get_ads_progress(), 0.5)
		and is_equal_approx(camera.get_ads_blend(), 0.5), "2x raise rate halves the eased transition duration")
	player.weapon_manager.set_aiming(false)
	timing.lower_speed = 0.5
	camera._ads_progress = 1.0
	camera._update_ads(weapon_time * 0.5)
	_check(is_equal_approx(camera.get_ads_progress(), 0.75), "lower rate adjusts exit independently")
	_check(weapon_time == weapon.get_effective_ads_time() and stats == weapon.get_stats_snapshot(),
		"rate config does not change weapon stats or effective weapon ADS time")
	camera.set_aim_config(player.player_config.aim_config)
	camera.reset_weapon_pose_to_hip()


func _alt(pressed: bool, location: KeyLocation) -> void:
	var event := InputEventKey.new()
	event.keycode = KEY_ALT
	event.physical_keycode = KEY_ALT
	event.location = location
	event.pressed = pressed
	Input.parse_input_event(event)
	Input.flush_buffered_events()


func _test_input(player: BasePlayer) -> void:
	_check(InputMap.has_action("hold_breath"), "hold breath action registered")
	_alt(true, KEY_LOCATION_RIGHT)
	_check(not Input.is_action_pressed("hold_breath"), "right Alt does not hold breath")
	_alt(false, KEY_LOCATION_RIGHT)
	_alt(true, KEY_LOCATION_LEFT)
	_check(Input.is_action_pressed("hold_breath"), "left Alt holds breath")
	player.weapon_manager.set_aiming(false)
	var state := player._get_aim_breathing_state()
	player.aim_breathing_controller.update_breathing(0.5, state.aiming, state.hold_requested)
	_check(not player.aim_breathing_controller.is_holding_breath(), "Alt outside ADS cannot hold breath")
	player.weapon_manager.set_aiming(true)
	state = player._get_aim_breathing_state()
	player.aim_breathing_controller.update_breathing(0.01, state.aiming, state.hold_requested)
	_check(player.aim_breathing_controller.is_holding_breath(), "ADS + left Alt reaches breath component")
	_alt(false, KEY_LOCATION_LEFT)
	player.weapon_manager.set_aiming(false)


func _test_live_breathing(player: BasePlayer, weapon: BaseWeapon) -> void:
	var breathing := player.aim_breathing_controller
	var stats := weapon.get_stats_snapshot()
	var ammo := [weapon.ammo_component.magazines.duplicate(true), weapon.ammo_component.chambered_round]
	var pending := player.force_receiver.consume_pending_impulse()
	_check(pending.is_empty(), "breathing starts without a ragdoll impulse")
	seed(12345)
	var recoil := weapon.recoil_component.physics_model.get_shot_impulse()
	player.weapon_manager.set_aiming(true)
	await _frames(180)
	var free_motion := await _sample_pose_motion(player, 90)
	_check(free_motion > 0.00005 and free_motion < 0.02, "procedural breathing reaches weapon with bounded micro motion")
	_alt(true, KEY_LOCATION_LEFT)
	await _frames(120)
	_check(breathing.is_holding_breath() and is_equal_approx(breathing.get_hold_weight(), 1.0),
		"hold blends to a settled breath")
	_check(breathing.get_breath_pose().is_equal_approx(Transform3D.IDENTITY), "held breath stops procedural breathing target")
	var held_motion := await _sample_pose_motion(player, 90)
	_check(held_motion < free_motion * 0.2, "held breath settles the actual spring driven weapon")
	_alt(false, KEY_LOCATION_LEFT)
	await _frames(90)
	_check(not breathing.is_holding_breath() and is_zero_approx(breathing.get_hold_weight()), "release resumes breathing")
	var resumed_motion := await _sample_pose_motion(player, 90)
	_check(resumed_motion > 0.00005, "release restores procedural weapon motion")
	_alt(true, KEY_LOCATION_LEFT)
	await _frames(30)
	player.weapon_manager.set_aiming(false)
	await _frames(1)
	_check(not breathing.is_holding_breath() and not player.animation_controller._idle_paused,
		"ADS exit clears hold and restores idle while Alt stays down")
	_alt(false, KEY_LOCATION_LEFT)
	seed(12345)
	_check(recoil == weapon.recoil_component.physics_model.get_shot_impulse(), "breath hold preserves single shot recoil")
	_check(stats == weapon.get_stats_snapshot(), "breathing preserves weapon data")
	_check(ammo == [weapon.ammo_component.magazines, weapon.ammo_component.chambered_round], "breathing never consumes ammunition")
	_check(player.force_receiver.consume_pending_impulse().is_empty(), "breathing adds no physical recoil or ragdoll impulse")


func _sample_pose_motion(player: BasePlayer, frames: int) -> float:
	var root := player.weapon_presentation_controller.get_pose_root()
	var camera := player.camera_controller.get_active_camera()
	var first := camera.global_transform.affine_inverse() * root.global_transform
	var max_distance := 0.0
	for i in frames:
		await get_tree().process_frame
		var current := camera.global_transform.affine_inverse() * root.global_transform
		max_distance = maxf(max_distance, first.origin.distance_to(current.origin))
	return max_distance


func _capture_authored_pose(skeleton: Skeleton3D, bone: int) -> void:
	_authored_pose.append(skeleton.get_bone_pose_rotation(bone))


func _pose_varies() -> bool:
	if _authored_pose.size() < 10:
		return false
	for pose in _authored_pose:
		if _authored_pose[0].angle_to(pose) > 0.0001:
			return true
	return false


func _test_idle_playback(player: BasePlayer) -> void:
	var animation := player.animation_controller
	var tree := player.model_manager.animation_tree
	var skeleton := player.model_manager.skeleton
	var capture := _capture_authored_pose.bind(skeleton, skeleton.find_bone("mixamorig_Spine1"))
	tree.mixer_applied.connect(capture)
	player.weapon_manager.set_aiming(false)
	await _frames(40)
	_authored_pose.clear()
	await _frames(45)
	_check(_pose_varies(), "authored idle plays normally before ADS")
	player.weapon_manager.set_aiming(true)
	await _frames(50)
	_authored_pose.clear()
	await _frames(45)
	_check(_authored_pose.size() >= 10 and not _pose_varies(), "ADS freezes authored idle pose while mixer keeps running")
	_check(tree.active and is_zero_approx(float(tree.get("parameters/Idle/Rate/scale"))), "idle time is paused without disabling AnimationTree")
	# All idle base layers freeze, while the turn clip has its own advancing time.
	_check(is_zero_approx(float(tree.get("parameters/TurnLeft/Base/Rate/scale"))), "turn upper body idle is also frozen")
	player.weapon_manager.set_aiming(false)
	await _frames(40)
	_authored_pose.clear()
	await _frames(45)
	_check(_pose_varies(), "ADS exit resumes authored idle")
	tree.mixer_applied.disconnect(capture)
	# Direct prone idle uses AnimationPlayer; crawl/transition playback must resume.
	animation.set_idle_paused(true)
	animation.play_prone_idle()
	await _frames(20)
	var animator := player.model_manager.animator
	var position := animator.current_animation_position
	await _frames(20)
	_check(is_equal_approx(position, animator.current_animation_position), "prone idle also pauses")
	animation.update_prone_motion(Vector2(0, -1), true)
	await _frames(20)
	_check(animator.speed_scale > 0.0 and animator.current_animation_position > 0.0, "prone crawl continues during idle pause")
	animation.clear_prone_override()
	animation.set_idle_paused(false)
	_check(animator.speed_scale > 0.0 and tree.active, "prone override restores normal playback")


func _frames(count: int) -> void:
	for i in count:
		await get_tree().process_frame


func _check(condition: bool, label: String) -> void:
	if not condition:
		failures += 1
		push_error(label)


func _finish() -> void:
	print("aim_breathing=%s failures=%s" % ["ok" if failures == 0 else "failed", failures])
	get_tree().quit(0 if failures == 0 else 1)
