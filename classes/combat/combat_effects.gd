class_name CombatEffects
extends Node

# ============================================================
# 战斗命中特效
# 功能：把医疗系统已经判定的命中转成可读的世界反馈：
#       1. 命中瞬间的液滴粒子
#       2. 贴在命中骨骼上的伤口贴花
#       3. 沿弹道投射到后方环境表面的喷溅贴花
#       4. 按外出血速度在地面留下滴落痕迹 / 血泊
#
# 设计约束：
# - 仅消费 HealthSystem.damage_taken，不参与伤害和医学判定。
# - 世界贴花有全局数量上限和生命周期，避免长时间交火泄漏节点。
# - 人物贴花跟随骨骼，在复活或模型热重载时清理。
# ============================================================

const WALL_SPLATTER_TEXTURE: Texture2D = preload("res://assets/textures/combat_effects/wall_splatter_realistic.png")
const FLOOR_POOL_TEXTURE: Texture2D = preload("res://assets/textures/combat_effects/floor_pool_realistic.png")
const FLOOR_DROPLET_TEXTURE: Texture2D = preload("res://assets/textures/combat_effects/floor_droplet_realistic.png")
const WOUND_MARK_TEXTURE: Texture2D = preload("res://assets/textures/combat_effects/wound_mark_realistic.png")

const ENVIRONMENT_MASK: int = 1
const MAX_WORLD_DECALS: int = 96
const MAX_CHARACTER_DECALS: int = 18
const WALL_TRACE_DISTANCE_M: float = 4.0
const FLOOR_TRACE_DISTANCE_M: float = 3.0
const STATIONARY_POOL_LOSS_ML: float = 24.0

static var _world_decals: Array[WeakRef] = []

var _player: BasePlayer = null
var _health: HealthSystem = null
var _rng := RandomNumberGenerator.new()
var _bleed_timer: float = 0.0
var _stationary_loss_ml: float = 0.0
var _last_mark_position: Vector3 = Vector3.ZERO
var _has_last_mark_position: bool = false
var _character_decals: Array[BoneAttachment3D] = []


func initialize(player: BasePlayer) -> void:
	_player = player
	_health = player.health_system
	_rng.randomize()

	if _health and not _health.damage_taken.is_connected(_on_damage_taken):
		_health.damage_taken.connect(_on_damage_taken)
	if not _player.died.is_connected(_on_player_died):
		_player.died.connect(_on_player_died)
	if not _player.revived.is_connected(_on_player_revived):
		_player.revived.connect(_on_player_revived)
	if _player.model_manager and not _player.model_manager.model_unloaded.is_connected(_clear_character_decals):
		_player.model_manager.model_unloaded.connect(_clear_character_decals)


func _physics_process(delta: float) -> void:
	if not _player or not _health or not _health.vitals or not _player.is_alive:
		return

	var external_rate: float = _health.vitals.total_bleed_rate()
	if external_rate <= 0.0:
		_bleed_timer = 0.0
		_stationary_loss_ml = 0.0
		_has_last_mark_position = false
		return

	_bleed_timer -= delta
	if _bleed_timer > 0.0:
		return

	# 毛细出血约每 1.3 秒一滴；动脉出血最快约每 0.25 秒一滴。
	var interval: float = clampf(1.15 / sqrt(external_rate + 0.25), 0.24, 1.35)
	_bleed_timer = interval * _rng.randf_range(0.82, 1.18)

	var current_position := _player.global_position
	var is_stationary := _has_last_mark_position and current_position.distance_to(_last_mark_position) < 0.28
	if is_stationary:
		_stationary_loss_ml += external_rate * interval
	else:
		_stationary_loss_ml = 0.0

	if _stationary_loss_ml >= STATIONARY_POOL_LOSS_ML:
		_spawn_floor_mark(true, external_rate)
		_stationary_loss_ml = 0.0
	else:
		_spawn_floor_mark(false, external_rate)

	_last_mark_position = current_position
	_has_last_mark_position = true


func _on_damage_taken(info: DamageInfo) -> void:
	if not info:
		return

	_spawn_impact_droplets(info)
	_spawn_character_wound(info)
	_spawn_wall_splatter(info)


func _spawn_impact_droplets(info: DamageInfo) -> void:
	var parent := _world_parent()
	if not parent:
		return

	var particles := CPUParticles3D.new()
	particles.name = "ImpactDroplets"
	particles.amount = clampi(roundi(info.amount / 55.0), 9, 24)
	particles.lifetime = 0.42
	particles.one_shot = true
	particles.explosiveness = 1.0
	particles.randomness = 0.5
	particles.direction = (-info.direction).normalized() if info.direction != Vector3.ZERO else Vector3.UP
	particles.spread = 48.0
	particles.initial_velocity_min = 2.2
	particles.initial_velocity_max = 5.2
	particles.gravity = Vector3(0.0, -9.8, 0.0)
	particles.damping_min = 0.3
	particles.damping_max = 1.0
	particles.scale_amount_min = 0.55
	particles.scale_amount_max = 1.45

	var droplet_mesh := SphereMesh.new()
	droplet_mesh.radius = 0.012
	droplet_mesh.height = 0.024
	droplet_mesh.radial_segments = 8
	droplet_mesh.rings = 4
	var material := StandardMaterial3D.new()
	material.albedo_color = Color(0.34, 0.008, 0.018, 1.0)
	material.roughness = 0.72
	droplet_mesh.surface_set_material(0, material)
	particles.mesh = droplet_mesh

	parent.add_child(particles)
	particles.global_position = info.hit_position
	particles.emitting = true
	_queue_free_after(particles, particles.lifetime + 0.3)


func _spawn_character_wound(info: DamageInfo) -> void:
	if info.anchor_bone.is_empty() or not _player.model_manager or not _player.model_manager.skeleton:
		return
	if info.type != MedicalEnums.DamageType.BULLET and info.type != MedicalEnums.DamageType.FRAGMENT:
		return

	var skeleton := _player.model_manager.skeleton
	if skeleton.find_bone(info.anchor_bone) < 0:
		return

	var attachment := BoneAttachment3D.new()
	attachment.name = "Wound_%s" % info.anchor_bone.replace("mixamorig_", "")
	attachment.bone_name = info.anchor_bone
	skeleton.add_child(attachment)

	var decal := _create_decal(WOUND_MARK_TEXTURE, Vector2(0.18, 0.20), 0.08)
	decal.name = "WoundDecal"
	attachment.add_child(decal)

	var outward_normal := (-info.direction).normalized() if info.direction != Vector3.ZERO else Vector3.FORWARD
	decal.global_transform = Transform3D(
		_basis_for_surface(outward_normal, true),
		info.hit_position + outward_normal * 0.012
	)

	_character_decals.append(attachment)
	_trim_character_decals()


func _spawn_wall_splatter(info: DamageInfo) -> void:
	if info.direction == Vector3.ZERO or not _player.get_world_3d():
		return

	var travel_dir := info.direction.normalized()
	var exclude: Array[RID] = _health.get_hitbox_rids()
	exclude.append(_player.get_rid())
	var query := PhysicsRayQueryParameters3D.create(
		info.hit_position + travel_dir * 0.08,
		info.hit_position + travel_dir * WALL_TRACE_DISTANCE_M,
		ENVIRONMENT_MASK,
		exclude
	)
	query.collide_with_areas = false
	query.collide_with_bodies = true
	var result := _player.get_world_3d().direct_space_state.intersect_ray(query)
	if result.is_empty():
		return

	var size_scale: float = clampf(sqrt(maxf(info.amount, 1.0) / 600.0), 0.68, 1.35)
	_spawn_world_decal(
		WALL_SPLATTER_TEXTURE,
		result.get("position", info.hit_position),
		result.get("normal", -travel_dir),
		Vector2(0.78, 0.78) * size_scale,
		120.0,
		"WallSplatter"
	)


func _spawn_floor_mark(pool: bool, external_rate: float = 0.0) -> void:
	if not _player or not _player.get_world_3d():
		return

	var origin := _player.global_position + Vector3.UP * 0.45
	var exclude: Array[RID] = _health.get_hitbox_rids() if _health else []
	exclude.append(_player.get_rid())
	var query := PhysicsRayQueryParameters3D.create(
		origin,
		origin + Vector3.DOWN * FLOOR_TRACE_DISTANCE_M,
		ENVIRONMENT_MASK,
		exclude
	)
	query.collide_with_areas = false
	query.collide_with_bodies = true
	var result := _player.get_world_3d().direct_space_state.intersect_ray(query)
	if result.is_empty():
		return

	if pool:
		var pool_scale: float = clampf(0.78 + external_rate / 30.0, 0.78, 1.28)
		_spawn_world_decal(
			FLOOR_POOL_TEXTURE,
			result.get("position", origin),
			result.get("normal", Vector3.UP),
			Vector2(0.86, 0.62) * pool_scale,
			180.0,
			"FloorPool"
		)
	else:
		var drop_scale: float = _rng.randf_range(0.75, 1.15)
		_spawn_world_decal(
			FLOOR_DROPLET_TEXTURE,
			result.get("position", origin),
			result.get("normal", Vector3.UP),
			Vector2(0.24, 0.24) * drop_scale,
			90.0,
			"FloorDroplet"
		)


func _spawn_world_decal(
	texture: Texture2D,
	position: Vector3,
	normal: Vector3,
	size_xz: Vector2,
	lifetime: float,
	node_name: String
) -> void:
	var parent := _world_parent()
	if not parent:
		return

	var decal := _create_decal(texture, size_xz, 0.14)
	decal.name = node_name
	parent.add_child(decal)

	var safe_normal := normal.normalized() if normal.length_squared() > 0.0001 else Vector3.UP
	var random_twist := Basis(Quaternion(safe_normal, _rng.randf_range(-PI, PI)))
	decal.global_transform = Transform3D(
		random_twist * _basis_for_surface(safe_normal),
		position + safe_normal * 0.012
	)

	_register_world_decal(decal)
	_queue_free_after(decal, lifetime)


func _create_decal(texture: Texture2D, size_xz: Vector2, projection_depth: float) -> Decal:
	var decal := Decal.new()
	decal.texture_albedo = texture
	decal.size = Vector3(size_xz.x, projection_depth, size_xz.y)
	# 暗红调制既压住绿幕边缘的残余色，也让贴花和底材产生更可信的吸收感。
	decal.modulate = Color(0.74, 0.38, 0.42, 0.96)
	decal.albedo_mix = 0.9
	decal.normal_fade = 0.62
	decal.upper_fade = 0.12
	decal.lower_fade = 0.12
	decal.distance_fade_enabled = true
	decal.distance_fade_begin = 34.0
	decal.distance_fade_length = 14.0
	decal.cull_mask = 1
	return decal


func _basis_for_surface(normal: Vector3, align_to_gravity: bool = false) -> Basis:
	# Decal 沿局部 -Y 投射，因此局部 +Y 指向表面外侧。
	var y_axis := normal.normalized()
	if align_to_gravity:
		# 让人物贴花中的流痕始终顺着世界重力，而不是随命中面的切线随机横躺。
		var down_on_surface := Vector3.DOWN - y_axis * Vector3.DOWN.dot(y_axis)
		if down_on_surface.length_squared() > 0.0001:
			var z_axis := down_on_surface.normalized()
			var x_axis := y_axis.cross(z_axis).normalized()
			return Basis(x_axis, y_axis, z_axis).orthonormalized()
	var reference := Vector3.FORWARD if absf(y_axis.dot(Vector3.FORWARD)) < 0.92 else Vector3.RIGHT
	var x_axis := reference.cross(y_axis).normalized()
	var z_axis := x_axis.cross(y_axis).normalized()
	return Basis(x_axis, y_axis, z_axis).orthonormalized()


func _register_world_decal(decal: Decal) -> void:
	for i in range(_world_decals.size() - 1, -1, -1):
		if not is_instance_valid(_world_decals[i].get_ref()):
			_world_decals.remove_at(i)

	_world_decals.append(weakref(decal))
	while _world_decals.size() > MAX_WORLD_DECALS:
		var oldest_ref := _world_decals.pop_front() as WeakRef
		var oldest = oldest_ref.get_ref()
		if is_instance_valid(oldest):
			oldest.queue_free()


func _trim_character_decals() -> void:
	for i in range(_character_decals.size() - 1, -1, -1):
		if not is_instance_valid(_character_decals[i]):
			_character_decals.remove_at(i)

	while _character_decals.size() > MAX_CHARACTER_DECALS:
		var oldest: BoneAttachment3D = _character_decals.pop_front()
		if is_instance_valid(oldest):
			oldest.queue_free()


func _queue_free_after(node: Node, seconds: float) -> void:
	var node_ref: WeakRef = weakref(node)
	get_tree().create_timer(seconds).timeout.connect(func() -> void:
		var target = node_ref.get_ref()
		if is_instance_valid(target):
			target.queue_free()
	)


func _world_parent() -> Node:
	return get_tree().current_scene if get_tree() else null


func _on_player_died() -> void:
	# 等布娃娃落地后补一块明显血泊；节点/场景已卸载时自动跳过。
	var player_ref: WeakRef = weakref(_player)
	get_tree().create_timer(0.9).timeout.connect(func() -> void:
		if is_instance_valid(player_ref.get_ref()):
			_spawn_floor_mark(true, 15.0)
	)


func _on_player_revived() -> void:
	_bleed_timer = 0.0
	_stationary_loss_ml = 0.0
	_has_last_mark_position = false
	_clear_character_decals()


func _clear_character_decals() -> void:
	for attachment in _character_decals:
		if is_instance_valid(attachment):
			attachment.queue_free()
	_character_decals.clear()
