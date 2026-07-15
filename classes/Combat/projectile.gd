class_name Projectile
extends RefCounted

# ============================================================
# 弹丸发射器（P1 hitscan 实现）
# 功能：从枪口发射射线，计算命中，构建 DamageInfo 交给目标 HealthSystem。
# 使用 RefCounted 避免 Node 开销；fire_hitscan() 同步执行。
# P2+ 可扩展为物理弹丸 Node3D。
# ============================================================

## 发射一发 hitscan 射线
## origin: 枪口世界坐标
## target_dir: 弹头飞行方向（归一化）
## config: 武器配置（提供 bullet_mass_g 和 muzzle_velocity）
## source: 开火的武器节点（用于 DamageInfo.source）
## world: World3D 引用（用于射线查询）
static func fire_hitscan(
	origin: Vector3,
	target_dir: Vector3,
	config: WeaponConfig,
	source: Node,
	world: World3D
) -> void:
	# 弹道参数
	var mass_kg: float = config.bullet_mass_g / 1000.0
	var velocity: float = config.muzzle_velocity
	var energy: float = Ballistics.kinetic_energy(mass_kg, velocity)

	# 射线查询（最大 2000m）
	var query := PhysicsRayQueryParameters3D.create(
		origin,
		origin + target_dir.normalized() * 2000.0,
		2,   # collision_mask: layer 2 = living hitboxes + ragdoll bones
		[]
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

	# 向上寻找 BasePlayer
	var player_node := _find_player(collider)
	if not player_node:
		return
	if not player_node.has_node("HealthSystem"):
		GlobalLogger.warn("Projectile", "Hit player has no HealthSystem")
		return

	# 构建 DamageInfo 并提交
	var info := HitResolver.resolve(result, energy, MedicalEnums.DamageType.BULLET, source)
	var health_system := player_node.get_node("HealthSystem") as HealthSystem
	health_system.apply_damage(info)


## 从碰撞体向上查找 BasePlayer 节点
static func _find_player(node: Object) -> BasePlayer:
	var current := node as Node
	while current:
		if current is BasePlayer:
			return current as BasePlayer
		current = current.get_parent()
	return null
