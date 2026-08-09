class_name Projectile
extends RefCounted

# ============================================================
# 瞬时 hitscan 回退发射器
# 功能：从枪口发射射线，计算命中，构建 DamageInfo 交给目标 HealthSystem。
# 使用 RefCounted 避免 Node 开销；fire_hitscan() 同步执行。
# 真实飞行弹道由 BallisticProjectileSystem 承担。
# ============================================================

## 发射一发 hitscan 射线
## origin: 射线起点世界坐标（应使用枪口位置）
## target_dir: 枪口决定的弹头飞行方向（归一化）
## config: 武器配置（提供 bullet_mass_g 和 muzzle_velocity）
## source: 开火的武器节点（用于 DamageInfo.source）
## world: World3D 引用（用于射线查询）
## exclude: 射线忽略的 RID 列表（射手自身的胶囊体与 hitbox，防止自伤）
static func fire_hitscan(
	origin: Vector3,
	target_dir: Vector3,
	config: BarrelConfig,
	source: Node,
	world: World3D,
	exclude: Array[RID] = []
) -> void:
	# 弹道参数
	if not config:
		GlobalLogger.warn("Projectile", "fire_hitscan() 缺少 BarrelConfig（未装枪管？），未开火")
		return
	var mass_kg: float = config.bullet_mass_g / 1000.0
	var velocity: float = config.muzzle_velocity
	if config.charge_variation > 0.0:
		velocity *= 1.0 + randf_range(-config.charge_variation, config.charge_variation)
	var energy: float = Ballistics.kinetic_energy(mass_kg, velocity)

	# 射线查询（最大 2000m）
	# mask 含 layer 1（环境）+ layer 2（hitbox/布娃娃骨骼）：
	# 墙体等环境命中在先时子弹被阻挡，不能隔墙伤人
	var query := PhysicsRayQueryParameters3D.create(
		origin,
		origin + target_dir.normalized() * 2000.0,
		1 | 2,
		exclude
	)
	query.collide_with_areas = true
	query.collide_with_bodies = true

	var space_state := world.direct_space_state
	if not space_state:
		GlobalLogger.warn("Projectile", "Cannot get direct_space_state from world")
		return

	var result := space_state.intersect_ray(query)
	if result.is_empty():
		return

	var collider = result.get("collider", null)
	if not collider:
		return

	# 向上寻找 BasePlayer；命中环境（墙/地面）时子弹在此终止
	var player_node := find_player(collider)
	if not player_node:
		return
	if not player_node.has_node("HealthSystem"):
		GlobalLogger.warn("Projectile", "Hit player has no HealthSystem")
		return

	# 构建 DamageInfo 并提交
	var info := HitResolver.resolve(
		result, energy, MedicalEnums.DamageType.BULLET, source, target_dir.normalized()
	)
	info.impact_velocity = velocity
	info.impact_mass_kg = mass_kg
	var health_system := player_node.get_node("HealthSystem") as HealthSystem
	health_system.apply_damage(info)


## 从碰撞体向上查找 BasePlayer 节点（供 hitscan 与 BallisticProjectileSystem 共用）
static func find_player(node: Object) -> BasePlayer:
	var current := node as Node
	while current:
		if current is BasePlayer:
			return current as BasePlayer
		current = current.get_parent()
	return null
