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
	player.camera_controller._update_ads(weapon.get_effective_ads_time())
	_check(player.camera_controller.get_ads_progress() > 0.99, "camera completes ADS transition")
	manager.set_aiming(false)
	player.camera_controller._update_ads(weapon.get_effective_ads_time() * 0.25)
	_check(is_equal_approx(player.camera_controller.get_ads_progress(), 0.75)
		and is_equal_approx(player.camera_controller.get_ads_blend(), 0.84375),
		"ADS-out uses the same deterministic smoothstep timing")
	manager.set_aiming(true)
	player.camera_controller._update_ads(weapon.get_effective_ads_time())
	await _frames(160)
	var active_camera := player.camera_controller.get_active_camera()
	_check(anchor.global_position.distance_to(active_camera.global_position) < 0.02,
		"settled ADS anchor stays within two centimetres of the eye")
	_check((-anchor.global_basis.z).normalized().dot((-active_camera.global_basis.z).normalized()) > 0.999,
		"ADSAnchor local -Z aligns with the view forward axis")
	var min_error := INF
	var max_error := 0.0
	for _frame in 180:
		await get_tree().process_frame
		var error := anchor.global_position.distance_to(active_camera.global_position)
		min_error = minf(min_error, error)
		max_error = maxf(max_error, error)
	_check(max_error < 0.02 and max_error - min_error > 0.0001,
		"breathing is visible and bounded without right-hand feedback drift")
	player.camera_controller.refresh_weapon_pose()
	var stable_pose := pose_root.global_transform
	for _call in 60:
		player.camera_controller.refresh_weapon_pose()
	_check(pose_root.global_transform.is_equal_approx(stable_pose),
		"compatibility refresh integrates at most once per frame")
	var original_yaw := player.look_controller.get_base_yaw()
	player.look_controller.set_base_yaw(original_yaw + 0.15)
	await _frames(1)
	_check((-anchor.global_basis.z).normalized().dot((-active_camera.global_basis.z).normalized()) < 0.9999,
		"weapon retains inertia after a view change")
	await _frames(150)
	_check(anchor.global_position.distance_to(active_camera.global_position) < 0.02,
		"weapon settles after a view change")
	player.look_controller.set_base_yaw(original_yaw)
	await _frames(150)
	_test_weapon_data_invariance(player, weapon)
	_test_fallback_pose()
	_test_eye_anchor(player)
	await _test_obstruction(player, weapon)

	manager.reload()
	_check(not manager.is_aiming, "reload cancels ADS")
	manager.set_aiming(true)
	manager.attempt_malfunction_clearance()
	_check(not manager.is_aiming, "malfunction action cancels ADS")

	var optic_renderer := player.optic_render_controller
	_check(optic_renderer != null, "local player owns an optic renderer")
	if optic_renderer:
		_check(optic_renderer.get_optic_viewport() == null, "mechanical sights allocate no optic SubViewport")
		_check(optic_renderer.get_scope_camera() == null, "mechanical sights allocate no optic camera")
		_check(
			optic_renderer.get_bound_optic() == null,
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
	player.camera_controller._update_ads(1.0)
	renderer._process(0.0)
	_check(lens.material_override == null, "optic keeps its original lens material outside ADS")

	player.weapon_manager.set_aiming(true)
	player.camera_controller._update_ads(1.0)
	renderer._process(0.0)
	var viewport := renderer.get_optic_viewport()
	var scope_camera := renderer.get_scope_camera()
	var main_camera := player.camera_controller.get_active_camera()
	await _frames(2)
	_check(scope_camera.global_transform.is_equal_approx(camera_anchor.global_transform),
		"normal update pipeline renders the final pose after IK")
	_check(
		viewport.render_target_update_mode == SubViewport.UPDATE_ALWAYS,
		"optic viewport renders while ADS"
	)
	_check(lens.visible, "optic lens is visible while ADS")
	_check(lens.material_override is ShaderMaterial, "lens receives the viewport material while ADS")
	_check(
		is_equal_approx(scope_camera.fov, main_camera.fov),
		"1x optic camera matches the main camera FOV"
	)
	_check(
		not scope_camera.get_cull_mask_value(OpticRenderController.LOCAL_WEAPON_RENDER_LAYER),
		"optic camera excludes the local weapon render layer"
	)
	_check(viewport.world_3d == player.get_world_3d(), "optic shares the main World3D")
	_check(scope_camera.global_transform.is_equal_approx(camera_anchor.global_transform),
		"optic camera uses the final optic anchor transform")
	var material := lens.material_override as ShaderMaterial
	_check(material.get_shader_parameter("optic_texture") == viewport.get_texture(),
		"lens samples the viewport texture")
	config.magnification = 4.0
	player.settings_service.set_value("graphics/magnified_scope_mode", "pixel_zoom")
	renderer._process(0.0)
	_check(renderer.get_active_render_mode() == OpticRenderController.MODE_DUAL_CAMERA,
		"legacy pixel zoom preference cannot select a second magnification path")
	var expected_fov := rad_to_deg(2.0 * atan(tan(deg_to_rad(main_camera.fov) * 0.5) / 4.0))
	_check(is_equal_approx(scope_camera.fov, expected_fov), "4x optic uses the optical FOV formula")
	_check(viewport.render_target_update_mode == SubViewport.UPDATE_ALWAYS, "4x optic renders its own camera")
	for magnification in [1.0, 4.0]:
		config.magnification = magnification
		var saved_camera := main_camera.global_transform
		main_camera.global_transform = ads_anchor.global_transform
		renderer._process(0.0)
		var aligned_visibility := renderer.get_eye_box_visibility()
		main_camera.global_position += camera_anchor.global_basis.x.normalized() * optic.eye_box_config.horizontal_tolerance
		renderer._process(0.0)
		var edge_visibility := renderer.get_eye_box_visibility()
		main_camera.global_position += camera_anchor.global_basis.x.normalized() * optic.eye_box_config.horizontal_tolerance
		renderer._process(0.0)
		_check(aligned_visibility > edge_visibility and edge_visibility > renderer.get_eye_box_visibility(),
			"eye box fades progressively at %sx" % magnification)
		main_camera.global_transform = ads_anchor.global_transform
		main_camera.global_position += camera_anchor.global_basis.z.normalized() * optic.eye_box_config.eye_relief_tolerance * 2.0
		renderer._process(0.0)
		_check(renderer.get_eye_box_visibility() < 0.1, "eye relief outside the box darkens the lens")
		main_camera.global_transform = ads_anchor.global_transform
		main_camera.rotate_object_local(Vector3.UP, deg_to_rad(optic.eye_box_config.angle_tolerance_degrees * 2.0))
		renderer._process(0.0)
		_check(renderer.get_eye_box_visibility() < 0.1, "angular eye error darkens the lens")
		main_camera.global_transform = saved_camera
	player.weapon_manager.set_aiming(false)
	player.camera_controller._update_ads(0.01)
	renderer._process(0.0)
	_check(viewport.render_target_update_mode == SubViewport.UPDATE_ALWAYS,
		"optic keeps rendering throughout ADS-out")

	player.weapon_manager.set_aiming(false)
	player.camera_controller._update_ads(1.0)
	renderer._process(0.0)
	_check(
		viewport.render_target_update_mode == SubViewport.UPDATE_DISABLED,
		"optic viewport stops after ADS-out completes"
	)
	_check(lens.visible, "physical optic lens remains visible outside ADS")
	_check(lens.material_override == null, "optic restores its original lens material outside ADS")
	renderer._refresh_binding()
	_check(renderer.get_optic_viewport() == viewport and renderer.get_scope_camera() == scope_camera,
		"rebinding an optic reuses the existing viewport and camera")

	camera_anchor.name = "MissingCameraAnchor"
	renderer._refresh_binding()
	_check(renderer.get_bound_optic() == null and viewport.render_target_update_mode == SubViewport.UPDATE_DISABLED,
		"optic without camera anchor cannot start rendering")
	camera_anchor.name = "OpticCameraAnchor"
	lens.name = "MissingLensSurface"
	renderer._refresh_binding()
	_check(renderer.get_bound_optic() == null, "optic without lens cannot start rendering")
	lens.name = "LensSurface"
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


func _frames(count: int) -> void:
	for _frame in count:
		await get_tree().process_frame


func _resource_values(resource: Resource) -> Dictionary:
	var values := {}
	for property in resource.get_property_list():
		if int(property.usage) & PROPERTY_USAGE_STORAGE:
			values[property.name] = resource.get(property.name)
	return values.duplicate(true)


func _test_weapon_data_invariance(player: BasePlayer, weapon: BaseWeapon) -> void:
	var manager := player.weapon_manager
	manager.set_aiming(false)
	var configs := {weapon.config: _resource_values(weapon.config)}
	for attachment in weapon.attachment_manager.get_all_attachments():
		configs[attachment.config] = _resource_values(attachment.config)
	var stats := weapon.get_stats_snapshot()
	var recoil := weapon.recoil_component.get_physics_snapshot()
	var ammo := [weapon.ammo_component.magazines.duplicate(true), weapon.ammo_component.chambered_round]
	var camera := player.camera_controller
	camera._ads_progress = 0.0
	camera._update_recoil_camera(0.0)
	var hip_recovery := Vector2(camera._recoil_pitch_spring.stiffness, camera._recoil_yaw_spring.stiffness)
	seed(7689)
	var hip_impulse := weapon.recoil_component.physics_model.get_shot_impulse()
	var muzzle_position := weapon.get_muzzle_position()
	var muzzle_direction := weapon.get_muzzle_direction()
	manager.set_aiming(true)
	camera._ads_progress = 1.0
	camera._update_recoil_camera(0.0)
	_check(hip_recovery == Vector2(camera._recoil_pitch_spring.stiffness, camera._recoil_yaw_spring.stiffness),
		"ADS cannot accelerate even the visual recoil recovery")
	seed(7689)
	_check(hip_impulse == weapon.recoil_component.physics_model.get_shot_impulse(),
		"ADS preserves the full single-shot recoil impulse")
	_check(stats == weapon.get_stats_snapshot() and recoil == weapon.recoil_component.get_physics_snapshot(),
		"ADS leaves all weapon statistics and physical recoil parameters unchanged")
	_check(ammo == [weapon.ammo_component.magazines, weapon.ammo_component.chambered_round],
		"ADS alone leaves ammunition unchanged")
	_check(muzzle_position.is_equal_approx(weapon.get_muzzle_position()) and muzzle_direction.is_equal_approx(weapon.get_muzzle_direction()),
		"ADS toggle does not overwrite the muzzle transform")
	for resource in configs:
		_check(configs[resource] == _resource_values(resource), "ADS does not mutate weapon or attachment resources")
	var marker := weapon.find_child("Muzzle", true, false) as Node3D
	_check(marker != null, "weapon provides a physical muzzle marker")
	if marker:
		var saved := marker.transform
		marker.rotate_y(0.1)
		_check(weapon.get_muzzle_direction().is_equal_approx((-marker.global_basis.z).normalized()),
			"ballistic direction remains Muzzle local -Z while aiming")
		_check(weapon.get_muzzle_position().is_equal_approx(marker.global_position), "ballistic origin remains the physical muzzle")
		marker.transform = saved
	manager.set_aiming(false)
	player.camera_controller._update_ads(1.0)


func _test_eye_anchor(player: BasePlayer) -> void:
	var camera := player.camera_controller
	var attachment := camera._bone_attachment
	_check(attachment != null, "model supplies a head bone attachment")
	if not attachment:
		return
	var previous := camera._eye_anchor
	var marker := Marker3D.new()
	marker.name = "EyeAnchor"
	marker.position = Vector3(0.01, 0.02, -0.03)
	attachment.add_child(marker)
	camera.enable_camera()
	_check(camera.get_eye_anchor() == marker, "camera discovers EyeAnchor below the head attachment")
	_check(camera._get_head_local_position().is_equal_approx(player.to_local(marker.global_position)),
		"EyeAnchor takes priority over configured head offsets")
	camera._eye_anchor = null
	camera._bone_attachment = null
	_check(camera._get_head_local_position().is_equal_approx(Vector3(0, camera._eye_height, 0)),
		"camera without head anchor falls back to configured eye height")
	camera._bone_attachment = attachment
	camera._eye_anchor = previous
	marker.free()
	camera._sync_springs_to_head()
	for mesh in player.model_manager.model_node.find_children("*", "MeshInstance3D", true, false):
		if String(mesh.name) == "Soldier_body":
			_check(mesh.is_visible_in_tree() and mesh.layers == 1
				and mesh.cast_shadow == GeometryInstance3D.SHADOW_CASTING_SETTING_ON,
				"ADS preserves normal body and arm visibility")


func _test_fallback_pose() -> void:
	var parent := Node3D.new()
	add_child(parent)
	var source := Node3D.new()
	parent.add_child(source)
	var presentation := WeaponPresentationController.new()
	parent.add_child(presentation)
	var state := {"active": true, "view": Transform3D.IDENTITY, "ads_blend": 1.0, "local_velocity": Vector3.ZERO}
	presentation.initialize(func(): return state)
	var pivot := presentation.setup_weapon_rig(source, parent)
	var weapon := BaseWeapon.new()
	weapon.config = WeaponConfig.new()
	weapon.config.logic_enabled = false
	weapon.config.ads_center_offset = Vector3(0.03, -0.1, -0.2)
	# Leave the weapon outside the tree to avoid unrelated component setup.
	presentation.bind_weapon(weapon)
	for _step in 240:
		presentation._update_pose(1.0 / 60.0)
	_check(presentation.get_pose_root().global_position.distance_to(weapon.config.ads_center_offset) < 0.02,
		"weapon without ADSAnchor uses the configured fallback offset")
	var still := presentation.get_pose_root().global_position
	state["local_velocity"] = Vector3(4.0, 0.0, -4.0)
	for _step in 120:
		presentation._update_pose(1.0 / 60.0)
	var displacement := presentation.get_pose_root().global_position.distance_to(still)
	_check(displacement > 0.001 and displacement < 0.03,
		"movement retains a small bounded ADS pose offset")
	_check(pivot.get_parent() == presentation.get_pose_root(), "sway pivot remains beneath the independent pose root")
	weapon.free()
	parent.free()


func _test_obstruction(player: BasePlayer, weapon: BaseWeapon) -> void:
	await _frames(160)
	var detector := player.weapon_obstruction_detector
	var presentation := player.weapon_presentation_controller
	var camera := player.camera_controller.get_active_camera()
	var clear_pose := presentation.get_pose_root().global_transform
	var wall := StaticBody3D.new()
	wall.collision_layer = PhysicsLayers.WORLD
	wall.collision_mask = 0
	var shape := CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = Vector3(4.0, 4.0, 0.06)
	shape.shape = box
	wall.add_child(shape)
	add_child(wall)
	wall.global_transform = Transform3D(Basis.looking_at(weapon.get_muzzle_direction()),
		camera.global_position + weapon.get_muzzle_direction() * 0.3)
	await _frames(30)
	_check(detector.get_obstruction_weight() > presentation.get_obstruction_fire_threshold(),
		"swept sphere detects a wall before the muzzle")
	_check(presentation.get_obstruction_weight() > 0.1, "obstruction weight reaches the pose controller")
	var displacement := camera.global_basis.inverse() * (presentation.get_pose_root().global_position - clear_pose.origin)
	_check(displacement.z > 0.01 and displacement.y < -0.005, "obstructed weapon retracts backward and down in view space")
	weapon.set_fire_mode("semi")
	_check(not player.weapon_manager.can_fire() and not weapon.can_fire(), "obstruction blocks both public fire interfaces")
	var ammo := [weapon.ammo_component.magazines.duplicate(true), weapon.ammo_component.chambered_round]
	var fired := {"count": 0}
	var listener := func(): fired["count"] += 1
	weapon.fired.connect(listener)
	weapon._fire_one_round()
	_check(ammo == [weapon.ammo_component.magazines, weapon.ammo_component.chambered_round] and fired["count"] == 0,
		"blocked round neither fires nor consumes ammunition")
	wall.queue_free()
	await _frames(160)
	_check(detector.get_obstruction_weight() < 0.001 and presentation.get_obstruction_weight() < 0.001,
		"weapon smoothly returns after the wall is removed")
	_check(player.weapon_manager.can_fire(), "clear weapon can fire again")
	weapon._fire_one_round()
	_check(fired["count"] == 1, "fire gate permits a real shot after obstruction clears")
	weapon.fired.disconnect(listener)
	var unavailable := WeaponObstructionDetector.new()
	unavailable.refresh()
	_check(is_zero_approx(unavailable.get_obstruction_weight()), "missing probe dependencies fail open")
	unavailable.free()
	await _frames(120)


func _check(condition: bool, message: String) -> void:
	if condition:
		return
	failures += 1
	push_error(message)


func _finish() -> void:
	print("ads_system=%s failures=%d" % ["ok" if failures == 0 else "FAILED", failures])
	get_tree().quit(0 if failures == 0 else 1)
