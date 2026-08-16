class_name DeathBloodEffect
extends Node3D

## 独立的死亡后外部渗血表现。
##
## 依赖方向：BasePlayer died/revived + 注入的出血点 Callable -> 本节点。
## 本节点不读取、不修改 HealthSystem/Wound/骨骼；缺少美术纹理时只跳过对应视觉层。
## 贴图层使用 Godot 官方 Decal 与 GPUParticles3D 节点，方便替换资源。

const DEFAULT_DROP_COLOR := Color(0.45, 0.01, 0.006, 1.0)
const ATLAS_COLUMNS := 2
const ATLAS_VARIANT_COUNT := 4
const POOL_ALPHA_CUTOFF := 64

var _player: BasePlayer
var _config: BloodEffectConfig
var _settings_service = null
var _bleed_origin_provider: Callable
var _pools: Array[Decal] = []
var _drips: GPUParticles3D
var _ground_ray: RayCast3D
var _pool_tween: Tween
var _drip_timer: Timer
var _drip_start_timer: Timer
var _has_started := false
var _blood_pool_variant: Texture2D
var _blood_pool_variants: Array[Texture2D] = []
var _blood_drop_variant: Texture2D
var _rng := RandomNumberGenerator.new()

func initialize(
	player: BasePlayer,
	config: BloodEffectConfig = null,
	settings_service = null,
	bleed_origin_provider: Callable = Callable()
) -> void:
	_player = player
	_config = config if config else BloodEffectConfig.new()
	_settings_service = settings_service if settings_service else (player.settings_service if player else null)
	_bleed_origin_provider = bleed_origin_provider
	_rng.randomize()
	add_to_group("blood_effects")
	if not _player:
		push_warning("DeathBloodEffect requires a player lifecycle source.")
		return
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
	if _config.blood_pool_texture:
		_blood_pool_variants = DecalAtlasCache.build_variants(
			_config.blood_pool_texture, ATLAS_COLUMNS, ATLAS_VARIANT_COUNT, POOL_ALPHA_CUTOFF
		)
		_blood_pool_variant = _blood_pool_variants[0] if not _blood_pool_variants.is_empty() else null
	if _config.blood_drop_texture:
		var drop_variants := DecalAtlasCache.build_variants(
			_config.blood_drop_texture, ATLAS_COLUMNS, ATLAS_VARIANT_COUNT
		)
		_blood_drop_variant = drop_variants[1] if drop_variants.size() > 1 else null

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
		# The effect node itself is moved to the resolved wound position when the
		# player dies. Keeping the old player-origin offset here would place the
		# emitter one metre above the actual wound (and above head wounds entirely).
		_drips.position = Vector3.ZERO
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

func _on_player_died() -> void:
	# 覆盖控制台/脚本直接调用 BasePlayer.die() 的非医疗死亡路径。
	_start_once()

func _start_once() -> void:
	if _has_started:
		return
	_has_started = true
	# 延迟一帧等待玩家/布娃娃完成状态切换。
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
	if _bleed_origin_provider.is_valid():
		var provided: Variant = _bleed_origin_provider.call()
		if provided is Vector3 and provided != Vector3.INF:
			return provided as Vector3
	return _player.global_position

func _create_pool(ground_point: Vector3) -> void:
	if not _config.blood_pool_texture:
		push_warning("DeathBloodEffect: blood_pool_texture is not assigned; blood pool creation skipped.")
		return
	var pool := Decal.new()
	pool.name = "BloodPool"
	pool.texture_albedo = _blood_pool_variants[_rng.randi_range(0, _blood_pool_variants.size() - 1)] \
		if not _blood_pool_variants.is_empty() else _blood_pool_variant
	pool.modulate = Color(1.0, 1.0, 1.0, 0.0)
	var size_variation := Vector2(_rng.randf_range(0.78, 1.12), _rng.randf_range(0.78, 1.12))
	var start_size := _config.pool_start_size * size_variation
	var final_size := _config.pool_max_size * size_variation
	pool.size = Vector3(start_size.x, 0.08, start_size.y)
	# Decal 默认从 +Y 向 -Y 投影，适合水平地面。
	pool.rotation = Vector3(0.0, _rng.randf_range(-PI, PI), 0.0)
	# Persistent stains belong to the world, not this movable wound emitter.
	# Otherwise a revive followed by another death relocates every old pool when
	# DeathBloodEffect moves to the new wound origin.
	var world_parent := _world_parent()
	if not world_parent:
		push_warning("DeathBloodEffect: no world parent; blood pool creation skipped.")
		pool.queue_free()
		return
	world_parent.add_child(pool)
	# ground_point comes from RayCast3D in world space. Assign it after parenting
	# through global_position so the wound-origin transform is not applied twice.
	var position_jitter := Vector3(
		_rng.randf_range(-0.12, 0.12),
		0.0,
		_rng.randf_range(-0.12, 0.12)
	)
	pool.global_position = ground_point + position_jitter + Vector3.UP * _config.ground_offset
	_pools.append(pool)

	_pool_tween = create_tween()
	_pool_tween.tween_interval(_config.pool_delay)
	_pool_tween.tween_property(pool, "modulate:a", _config.pool_alpha * _rng.randf_range(0.72, 0.92), 0.35)
	_pool_tween.parallel().tween_property(
		pool, "size", Vector3(final_size.x, 0.08, final_size.y),
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


func _world_parent() -> Node:
	if is_instance_valid(_player) and is_instance_valid(_player.get_parent()):
		return _player.get_parent()
	return get_tree().current_scene if get_tree() else null


func _on_player_exiting() -> void:
	# 死亡效果脱离玩家节点后，仍需跟随玩家实例的生命周期清理。
	clear_bloodstains()
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
	material.albedo_texture = _blood_drop_variant
	mesh.material = material
	return mesh

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
