class_name DeathBloodEffect
extends Node3D

## 独立的死亡后外部渗血表现。
##
## 依赖方向：HealthSystem.medically_died / BasePlayer.revived -> 本节点。
## 本节点不读取、不修改伤口数值；缺少美术纹理时只跳过对应视觉层。
## 贴图层使用 Godot 官方 Decal 与 GPUParticles3D 节点，方便替换资源。

const DEFAULT_DROP_COLOR := Color(0.45, 0.01, 0.006, 1.0)

var _player: BasePlayer
var _config: BloodEffectConfig
var _settings_service = null
var _pools: Array[Decal] = []
var _drips: GPUParticles3D
var _ground_ray: RayCast3D
var _pool_tween: Tween
var _drip_timer: Timer
var _drip_start_timer: Timer
var _has_started := false

func initialize(player: BasePlayer, config: BloodEffectConfig = null, settings_service = null) -> void:
	_player = player
	_config = config if config else BloodEffectConfig.new()
	_settings_service = settings_service if settings_service else (player.settings_service if player else null)
	add_to_group("blood_effects")
	if not _player or not _player.health_system:
		push_warning("DeathBloodEffect requires a player with HealthSystem.")
		return
	if not _player.health_system.medically_died.is_connected(_on_medically_died):
		_player.health_system.medically_died.connect(_on_medically_died)
	if not _player.died.is_connected(_on_player_died):
		_player.died.connect(_on_player_died)
	if not _player.revived.is_connected(_on_player_revived):
		_player.revived.connect(_on_player_revived)
	if not _player.tree_exiting.is_connected(_on_player_exiting):
		_player.tree_exiting.connect(_on_player_exiting)
	if _settings_service and not _settings_service.value_changed.is_connected(_on_setting_changed):
		_settings_service.value_changed.connect(_on_setting_changed)
	_build_nodes()

func _build_nodes() -> void:
	_ground_ray = RayCast3D.new()
	_ground_ray.name = "BloodGroundRay"
	_ground_ray.collision_mask = _config.ground_collision_mask
	_ground_ray.enabled = false
	add_child(_ground_ray)

	if _config.blood_drop_texture:
		_drips = GPUParticles3D.new()
		_drips.name = "BloodDrips"
		_drips.amount = _config.drip_amount
		_drips.lifetime = _config.drip_lifetime
		_drips.one_shot = false
		_drips.emitting = false
		_drips.visibility_aabb = AABB(Vector3(-2.0, -_config.ground_ray_length, -2.0), Vector3(4.0, _config.ground_ray_length + 3.0, 4.0))
		_drips.position = Vector3(0.0, 1.0, 0.0)
		_drips.draw_pass_1 = _make_drop_mesh()
		_drips.process_material = _make_drip_process_material()
		add_child(_drips)
	else:
		push_warning("DeathBloodEffect: blood_drop_texture is not assigned; drip particles are disabled.")

	_drip_timer = Timer.new()
	_drip_timer.name = "BloodDripStopTimer"
	_drip_timer.one_shot = true
	add_child(_drip_timer)
	_drip_timer.timeout.connect(_stop_drips)
	_drip_start_timer = Timer.new()
	_drip_start_timer.name = "BloodDripStartTimer"
	_drip_start_timer.one_shot = true
	add_child(_drip_start_timer)
	_drip_start_timer.timeout.connect(_begin_drips)

func _on_medically_died(_death_type: PlayerRagdollSystem.DeathType, _direction: Vector3) -> void:
	_start_once()

func _on_player_died() -> void:
	# 覆盖控制台/脚本直接调用 BasePlayer.die() 的非医疗死亡路径。
	_start_once()

func _start_once() -> void:
	if _has_started:
		return
	_has_started = true
	# 医疗信号早于 BasePlayer.die() 发出；延迟一帧等待玩家/布娃娃完成状态切换。
	call_deferred("_start_effect")

func _start_effect() -> void:
	if not is_instance_valid(_player) or not _player.is_inside_tree():
		return
	if not _blood_effects_enabled():
		return
	# 等待布娃娃的 deferred 启动至少跨过一个物理帧，再从当前骨骼姿态投影伤口。
	await get_tree().physics_frame
	if not _has_started or not is_instance_valid(_player):
		return
	# 渐显延迟由 Shader Tween 控制，避免将延迟重复计入血泊创建时机。
	# 效果属于死亡地点，不应随着 BasePlayer 后续的布娃娃根节点移动。
	var effect_parent := _player.get_parent()
	if effect_parent and get_parent() == _player:
		reparent(effect_parent, true)

	_global_position_for_ground_query()
	_ground_ray.enabled = true
	_ground_ray.force_raycast_update()
	var ground_point: Vector3 = _ground_ray.get_collision_point() if _ground_ray.is_colliding() else _player.global_position
	if not _ground_ray.is_colliding():
		GlobalLogger.warn("DeathBloodEffect", "No ground below wound; using player origin for blood pool fallback.")
	_create_pool(ground_point)
	_start_drips()

func _global_position_for_ground_query() -> void:
	# 优先从最严重的外部伤口的实际入射点向下投影，让血泊从伤口位置渗出。
	var wound_origin: Vector3 = _find_major_bleed_origin()
	global_position = wound_origin
	_ground_ray.position = Vector3(0.0, 0.15, 0.0)
	_ground_ray.target_position = Vector3(0.0, -_config.ground_ray_length, 0.0)

func _find_major_bleed_origin() -> Vector3:
	if not _player.health_system or not _player.health_system.vitals:
		return _player.global_position
	var best_wound: Wound = null
	for region_value in _player.health_system.vitals.regions.values():
		var region: BodyRegion = region_value as BodyRegion
		if not region:
			continue
		for wound_value in region.wounds:
			var wound: Wound = wound_value as Wound
			if not wound or wound.is_bandaged or wound.is_tourniqueted:
				continue
			if wound.bleed_rate == MedicalEnums.BleedRate.NONE:
				continue
			if best_wound == null or _is_higher_priority_bleed(wound, best_wound):
				best_wound = wound
	if not best_wound:
		return _player.global_position
	return _wound_world_position(best_wound)


func _is_higher_priority_bleed(candidate: Wound, current: Wound) -> bool:
	if candidate.bleed_rate != current.bleed_rate:
		return candidate.bleed_rate > current.bleed_rate
	return candidate.severity > current.severity


func _wound_world_position(wound: Wound) -> Vector3:
	if wound.has_bone_local_position and not wound.anchor_bone.is_empty():
		var anchored_position := _bone_world_position(wound.anchor_bone, wound.bone_local_position)
		if anchored_position != Vector3.INF:
			return anchored_position
	if wound.has_hit_position:
		return wound.hit_position
	for fallback_name in _fallback_bone_names(wound.body_part):
		var fallback_position := _bone_world_position(fallback_name, Vector3.ZERO)
		if fallback_position != Vector3.INF:
			return fallback_position
	return _player.global_position

func _bone_world_position(bone_name: String, local_entry: Vector3) -> Vector3:
	if not _player.model_manager or not _player.model_manager.skeleton:
		return Vector3.INF
	var skeleton: Skeleton3D = _player.model_manager.skeleton
	var bone_index := skeleton.find_bone(bone_name)
	if bone_index < 0:
		return Vector3.INF
	var bone_world_transform := skeleton.global_transform * skeleton.get_bone_global_pose(bone_index)
	return bone_world_transform * local_entry


func _fallback_bone_names(part: MedicalEnums.BodyPartId) -> Array[String]:
	match part:
		MedicalEnums.BodyPartId.HEAD: return ["mixamorig_Head", "Head"]
		MedicalEnums.BodyPartId.TORSO: return ["mixamorig_Spine2", "mixamorig_Spine1", "Spine2"]
		MedicalEnums.BodyPartId.LEFT_UPPER_ARM: return ["mixamorig_LeftArm", "LeftArm"]
		MedicalEnums.BodyPartId.LEFT_FOREARM: return ["mixamorig_LeftForeArm", "LeftForeArm"]
		MedicalEnums.BodyPartId.RIGHT_UPPER_ARM: return ["mixamorig_RightArm", "RightArm"]
		MedicalEnums.BodyPartId.RIGHT_FOREARM: return ["mixamorig_RightForeArm", "RightForeArm"]
		MedicalEnums.BodyPartId.LEFT_THIGH: return ["mixamorig_LeftUpLeg", "LeftUpLeg"]
		MedicalEnums.BodyPartId.LEFT_CALF: return ["mixamorig_LeftLeg", "LeftLeg"]
		MedicalEnums.BodyPartId.RIGHT_THIGH: return ["mixamorig_RightUpLeg", "RightUpLeg"]
		MedicalEnums.BodyPartId.RIGHT_CALF: return ["mixamorig_RightLeg", "RightLeg"]
	return [""]

func _create_pool(ground_point: Vector3) -> void:
	if not _config.blood_pool_texture:
		push_warning("DeathBloodEffect: blood_pool_texture is not assigned; blood pool creation skipped.")
		return
	var pool := Decal.new()
	pool.name = "BloodPool"
	pool.texture_albedo = _atlas_variant(_config.blood_pool_texture, 0)
	pool.modulate = Color(1.0, 1.0, 1.0, 0.0)
	pool.size = Vector3(_config.pool_start_size.x, 0.08, _config.pool_start_size.y)
	pool.position = ground_point + Vector3.UP * _config.ground_offset
	# Decal 默认从 +Y 向 -Y 投影，适合水平地面。
	pool.rotation = Vector3.ZERO
	add_child(pool)
	_pools.append(pool)

	_pool_tween = create_tween()
	_pool_tween.tween_interval(_config.pool_delay)
	_pool_tween.tween_property(pool, "modulate:a", _config.pool_alpha, 0.35)
	_pool_tween.parallel().tween_property(
		pool, "size", Vector3(_config.pool_max_size.x, 0.08, _config.pool_max_size.y),
		_config.pool_growth_duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _start_drips() -> void:
	if not _drips:
		return
	_drip_start_timer.start(_config.drip_delay)

func _begin_drips() -> void:
	if not _drips or not _has_started:
		return
	_drips.emitting = true
	if _config.drip_duration > 0.0:
		_drip_timer.start(_config.drip_duration)

func _stop_drips() -> void:
	if _drips:
		_drips.emitting = false

func _on_player_revived() -> void:
	# 复活只结束当前尸体的滴血周期；已经落地的血泊属于场景痕迹，
	# 必须通过 clear_blood 指令显式清理。
	_reset_drip_cycle()

func _on_setting_changed(key: String, value: Variant) -> void:
	if key == "graphics/blood_effects" and not bool(value):
		clear_bloodstains()

func _blood_effects_enabled() -> bool:
	return bool(_settings_service.get_value("graphics/blood_effects", true)) if _settings_service else true

func _on_player_exiting() -> void:
	# 死亡效果脱离玩家节点后，仍需跟随玩家实例的生命周期清理。
	queue_free()

## 清除该效果节点创建的全部血迹。由 ConsoleSystem 的 clear_blood 指令调用。
func clear_bloodstains() -> int:
	var cleared := 0
	for pool in _pools:
		if is_instance_valid(pool):
			pool.queue_free()
			cleared += 1
	_pools.clear()
	_reset_drip_cycle()
	return cleared

func _reset_drip_cycle() -> void:
	_has_started = false
	if _pool_tween and _pool_tween.is_valid():
		_pool_tween.kill()
	if _drip_timer:
		_drip_timer.stop()
	if _drip_start_timer:
		_drip_start_timer.stop()
	if _drips:
		_drips.emitting = false
	_ground_ray.enabled = false

func _make_drop_mesh() -> QuadMesh:
	var mesh := QuadMesh.new()
	mesh.size = Vector2(_config.drip_size, _config.drip_size)
	var material := StandardMaterial3D.new()
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
	material.albedo_color = Color(1.0, 1.0, 1.0, _config.drip_alpha)
	material.albedo_texture = _atlas_variant(_config.blood_drop_texture, 1)
	mesh.material = material
	return mesh

func _atlas_variant(texture: Texture2D, variant_index: int) -> Texture2D:
	if not texture:
		return null
	var atlas_size := texture.get_size()
	if atlas_size.x < 2.0 or atlas_size.y < 2.0:
		return texture
	var atlas := AtlasTexture.new()
	atlas.atlas = texture
	var cell_size := atlas_size / 2.0
	var column := variant_index % 2
	var row := int(variant_index / 2)
	atlas.region = Rect2(Vector2(column, row) * cell_size, cell_size)
	return atlas

func _make_drip_process_material() -> ParticleProcessMaterial:
	var material := ParticleProcessMaterial.new()
	material.direction = Vector3(0.0, -1.0, 0.0)
	material.spread = 8.0
	material.initial_velocity_min = 0.25
	material.initial_velocity_max = 0.8
	material.gravity = Vector3(0.0, -_config.drip_gravity, 0.0)
	material.scale_min = 0.7
	material.scale_max = 1.25
	material.color = DEFAULT_DROP_COLOR
	return material
