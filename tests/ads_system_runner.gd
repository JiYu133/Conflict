extends Node

var failures := 0


func _ready() -> void:
	_run.call_deferred()


func _run() -> void:
	var map := (load("res://assets/map/TestMap.tscn") as PackedScene).instantiate()
	get_tree().root.add_child(map)
	for _frame in 20:
		await get_tree().process_frame
	var player := map.get_node("CharacterBody3D") as BasePlayer
	var manager := player.weapon_manager
	var weapon := manager.current_weapon
	_check(weapon != null, "local player equips a weapon")
	if not weapon:
		_finish()
		return

	_check(InputMap.has_action("aim"), "aim input action exists")
	_check(
		String(player.settings_service.get_value("controls/ads_input_mode", "")) in ["hold", "toggle"],
		"ADS input preference is valid"
	)
	_check(
		is_equal_approx(weapon.get_current_spread(false), weapon.get_current_spread(true)),
		"ADS cannot select a different accuracy value"
	)
	await _test_input_modes(player)
	_test_action_priority(player)

	var muzzle_before := weapon.get_muzzle_direction()
	var control_before := weapon._get_control_multiplier()
	var signal_counter := {"count": 0}
	manager.aiming_changed.connect(func(_aiming: bool): signal_counter["count"] += 1)
	manager.set_aiming(true)
	manager.set_aiming(true)
	_check(manager.is_aiming and signal_counter["count"] == 1, "ADS state changes are idempotent")
	_check(
		muzzle_before.is_equal_approx(weapon.get_muzzle_direction()),
		"changing ADS state alone does not rewrite the muzzle direction"
	)
	_check(
		is_equal_approx(control_before, weapon._get_control_multiplier()),
		"ADS does not change weapon-domain recoil control"
	)

	var anchor := weapon.get_ads_anchor()
	_check(is_instance_valid(anchor), "equipped mechanical sight supplies ADSAnchor")
	var pose_root := player.camera_controller.get_weapon_pose_root()
	var pose_source := player.camera_controller.get_weapon_pose_source()
	_check(is_instance_valid(pose_root), "weapon uses an independent pose root")
	_check(is_instance_valid(pose_source) and not pose_root.is_ancestor_of(pose_source), "weapon pose does not depend on a solved hand bone")
	player.camera_controller._ads_progress = 0.25
	player.camera_controller._update_ads(0.0)
	_check(
		is_equal_approx(player.camera_controller.get_ads_blend(), 0.15625),
		"ADS uses smoothstep easing instead of a linear visual blend"
	)
	player.camera_controller._process(1.0)
	_check(player.camera_controller.get_ads_progress() > 0.99, "camera completes ADS transition")
	var active_camera := player.camera_controller.get_active_camera()
	_check(
		anchor.global_position.distance_to(active_camera.global_position) < 0.001,
		"mechanical sight anchor reaches the player eye position"
	)
	_check(
		anchor.global_basis.get_rotation_quaternion().angle_to(
			active_camera.global_basis.get_rotation_quaternion()
		) < 0.001,
		"mechanical sight axis reaches the player view axis"
	)
	var stable_pose := pose_root.global_transform
	for _frame in 60:
		player.camera_controller.refresh_weapon_pose()
	_check(
		pose_root.global_transform.origin.distance_to(stable_pose.origin) < 0.0001,
		"independent weapon pose has no right-hand feedback drift"
	)

	manager.reload()
	_check(not manager.is_aiming, "reload cancels ADS")
	manager.set_aiming(true)
	manager.attempt_malfunction_clearance()
	_check(not manager.is_aiming, "malfunction action cancels ADS")

	var optic_renderer := player.optic_render_controller
	_check(optic_renderer != null, "local player owns an optic renderer")
	if optic_renderer:
		_check(optic_renderer.get_optic_viewport() != null, "optic SubViewport is allocated")
		_check(optic_renderer.get_scope_camera() != null, "optic camera is allocated")
		_check(
			optic_renderer.get_optic_viewport().render_target_update_mode == SubViewport.UPDATE_DISABLED,
			"mechanical sights do not spend scope render time"
		)
		await _test_synthetic_optic(player, weapon, optic_renderer)

	var detached_parent := Node3D.new()
	detached_parent.name = "DetachedWeaponTestParent"
	get_tree().root.add_child(detached_parent)
	var detached := manager.detach_current_weapon_to(detached_parent)
	_check(detached == weapon and weapon.get_parent() == detached_parent, "weapon can detach from the independent pose rig")
	_check(manager.restore_current_weapon_to_mount(weapon), "weapon restores to the independent pose rig")
	_check(
		weapon.get_parent() == player.camera_controller.get_weapon_pose_root().get_node("WeaponSwayPivot"),
		"restored weapon returns below WeaponPoseRoot"
	)
	detached_parent.queue_free()

	map.queue_free()
	await get_tree().process_frame
	await get_tree().process_frame
	_finish()


func _test_input_modes(player: BasePlayer) -> void:
	player.settings_service.set_value("controls/ads_input_mode", "hold")
	player._input(_aim_event(true))
	_check(player.weapon_manager.is_aiming, "hold mode enters ADS on press")
	player._input(_aim_event(false))
	_check(not player.weapon_manager.is_aiming, "hold mode exits ADS on release")

	player.settings_service.set_value("controls/ads_input_mode", "toggle")
	player._input(_aim_event(true))
	_check(player.weapon_manager.is_aiming, "toggle mode enters ADS on first press")
	player._input(_aim_event(true))
	_check(not player.weapon_manager.is_aiming, "toggle mode exits ADS on second press")
	player.settings_service.set_value("controls/ads_input_mode", "hold")


func _aim_event(pressed: bool) -> InputEventAction:
	var event := InputEventAction.new()
	event.action = "aim"
	event.pressed = pressed
	return event


func _test_action_priority(player: BasePlayer) -> void:
	player.movement_controller._enter_sprint()
	_check(player.movement_controller.is_sprinting(), "test player can enter sprint")
	player._request_aim(true)
	_check(
		player.weapon_manager.is_aiming and not player.movement_controller.is_sprinting(),
		"aim input exits an active sprint"
	)
	_check(
		player.movement_controller._sprint_suppressed_until_release,
		"held sprint cannot immediately restart after aim input"
	)
	player.movement_controller._sprint_suppressed_until_release = false
	player.movement_controller._enter_sprint()
	_check(
		player.movement_controller.is_sprinting() and not player.weapon_manager.is_aiming,
		"starting a new sprint cancels ADS"
	)
	player.movement_controller._exit_sprint()


func _test_synthetic_optic(
	player: BasePlayer,
	weapon: BaseWeapon,
	renderer: OpticRenderController
) -> void:
	var old_optic := weapon.detach_attachment("OpticRail")
	_check(old_optic != null, "mechanical sight can be replaced for optic test")

	var config := AttachmentConfig.new()
	config.attachment_name = "ADS Test Optic"
	config.attachment_type = AttachmentConfig.AttachmentType.OPTIC
	config.allowed_slot = AttachmentSlot.SlotType.OPTIC_RAIL
	config.magnification = 1.0
	var optic := OpticAttachment.new()
	optic.name = "ADSTestOptic"
	var ads_anchor := Marker3D.new()
	ads_anchor.name = "ADSAnchor"
	optic.add_child(ads_anchor)
	var camera_anchor := Marker3D.new()
	camera_anchor.name = "OpticCameraAnchor"
	optic.add_child(camera_anchor)
	var lens := MeshInstance3D.new()
	lens.name = "LensSurface"
	lens.mesh = QuadMesh.new()
	optic.add_child(lens)
	optic.initialize(config, weapon)
	_check(
		weapon.attachment_manager.equip_to_slot(optic, "OpticRail"),
		"synthetic optic equips to the live rail"
	)
	await get_tree().process_frame
	await get_tree().process_frame
	_check(renderer.get_bound_optic() == optic, "optic renderer binds the active optic")
	player.camera_controller._process(1.0)
	renderer._process(0.0)
	_check(lens.material_override == null, "optic keeps its original lens material outside ADS")

	player.weapon_manager.set_aiming(true)
	player.camera_controller._process(1.0)
	renderer._process(0.0)
	var viewport := renderer.get_optic_viewport()
	var scope_camera := renderer.get_scope_camera()
	var main_camera := player.camera_controller.get_active_camera()
	_check(
		viewport.render_target_update_mode == SubViewport.UPDATE_ALWAYS,
		"optic viewport renders while ADS"
	)
	_check(lens.visible, "optic lens is visible while ADS")
	_check(lens.material_override is StandardMaterial3D, "lens receives the viewport material while ADS")
	_check(
		is_equal_approx(scope_camera.fov, main_camera.fov),
		"1x optic camera matches the main camera FOV"
	)
	_check(
		not scope_camera.get_cull_mask_value(OpticRenderController.LOCAL_WEAPON_RENDER_LAYER),
		"optic camera excludes the local weapon render layer"
	)
	config.magnification = 4.0
	player.settings_service.set_value("graphics/magnified_scope_mode", "pixel_zoom")
	renderer._process(0.0)
	_check(
		renderer.get_active_render_mode() == OpticRenderController.MODE_PIXEL_ZOOM,
		"magnified optic can use zero-extra-render pixel zoom"
	)
	_check(
		viewport.render_target_update_mode == SubViewport.UPDATE_DISABLED,
		"pixel zoom does not render the secondary viewport"
	)
	_check(lens.material_override is ShaderMaterial, "pixel zoom uses the main-screen sampling material")
	player.settings_service.set_value("graphics/magnified_scope_mode", "dual_camera")
	renderer._process(0.0)
	_check(
		renderer.get_active_render_mode() == OpticRenderController.MODE_DUAL_CAMERA,
		"magnified optic can use the independent dual-camera view"
	)
	_check(
		viewport.render_target_update_mode == SubViewport.UPDATE_ALWAYS,
		"dual-camera mode renders the optic viewport"
	)
	_check(lens.material_override is StandardMaterial3D, "dual-camera mode uses the viewport texture")
	config.magnification = 1.0
	player.settings_service.set_value("graphics/magnified_scope_mode", "pixel_zoom")
	renderer._process(0.0)
	_check(
		renderer.get_active_render_mode() == OpticRenderController.MODE_DUAL_CAMERA,
		"1x optics ignore the high-magnification rendering preference"
	)

	player.weapon_manager.set_aiming(false)
	player.camera_controller._process(1.0)
	renderer._process(0.0)
	_check(
		viewport.render_target_update_mode == SubViewport.UPDATE_DISABLED,
		"optic viewport stops after ADS-out completes"
	)
	_check(lens.visible, "physical optic lens remains visible outside ADS")
	_check(lens.material_override == null, "optic restores its original lens material outside ADS")

	var removed := weapon.detach_attachment("OpticRail")
	if removed:
		removed.free()
	if old_optic:
		_check(
			weapon.attachment_manager.equip_to_slot(old_optic, "OpticRail"),
			"mechanical sight is restored after the optic test"
		)
	await get_tree().process_frame
	await get_tree().process_frame


func _check(condition: bool, message: String) -> void:
	if condition:
		return
	failures += 1
	push_error(message)


func _finish() -> void:
	print("ads_system=%s failures=%d" % ["ok" if failures == 0 else "FAILED", failures])
	get_tree().quit(0 if failures == 0 else 1)
