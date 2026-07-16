class_name BallisticProjectileSystem
extends Node

# ============================================================
# 弹道模拟系统（P2 — 飞行时间弹丸）
# 功能：管理所有在飞弹丸的逐物理帧模拟：
#       重力下坠 + 二次空气阻力（由弹道系数 BC 推导）+ 分段射线命中检测。
#       命中时按"落点实时速度"计算动能 → 远距离伤害自然衰减。
# 用法：BaseWeapon 通过 get_or_create(get_tree()) 获取共享实例，
#       调用 spawn(...) 发射一发弹丸。全部弹丸在单个 Node 中批量
#       模拟（数组而非每弹一个 Node，避免节点开销）。
# 兼容：命中解析仍走 HitResolver.resolve() → DamageInfo →
#       HealthSystem.apply_damage()，医疗系统 API 无任何变化。
# ============================================================

## 弹丸最大飞行距离（米），超出后移除
const MAX_RANGE_M: float = 2000.0
## 弹丸最大飞行时间（秒），兜底防泄漏
const MAX_FLIGHT_TIME_S: float = 8.0
## 低于此速度（m/s）视为失能弹头，直接移除（KE 已不足以造成有效伤口）
const MIN_SPEED_MPS: float = 40.0
## 同时在飞弹丸上限，超出时丢弃最旧的（防异常连发泄漏）
const MAX_ACTIVE_BULLETS: int = 256

## 射线碰撞掩码：layer 1（环境，阻挡弹丸）+ layer 2（hitbox/布娃娃骨骼）
const HIT_MASK: int = 1 | 2

static var _instance: BallisticProjectileSystem = null

## 在飞弹丸列表。每项为 Dictionary：
##   position: Vector3      当前位置（世界空间）
##   velocity: Vector3      当前速度向量（m/s）
##   mass_kg: float         弹头质量
##   bc: float              弹道系数（G1 近似）
##   source: WeakRef        开火武器（可能已被释放，命中时解引用）
##   exclude: Array[RID]    射手自身的碰撞体排除列表
##   world: World3D         发射时所在物理世界
##   traveled: float        累计飞行距离（米）
##   time: float            累计飞行时间（秒）
var _bullets: Array[Dictionary] = []

var _gravity: float = 9.8


## 获取（或惰性创建并挂到场景根的）共享实例
static func get_or_create(tree: SceneTree) -> BallisticProjectileSystem:
	if is_instance_valid(_instance):
		return _instance
	_instance = BallisticProjectileSystem.new()
	_instance.name = "BallisticProjectileSystem"
	tree.root.add_child(_instance)
	return _instance


func _ready() -> void:
	_gravity = float(ProjectSettings.get_setting("physics/3d/default_gravity", 9.8))
	GlobalLogger.info("Ballistics", "BallisticProjectileSystem ready (gravity=%.2f m/s²)" % _gravity)


## 发射一发模拟弹丸
## origin: 弹丸起点（枪口世界坐标）
## direction: 初始飞行方向（无需归一化）
## config: 武器配置（bullet_mass_g / muzzle_velocity / ballistic_coefficient）
## source: 开火的武器节点（DamageInfo.source；以 WeakRef 存储防悬空）
## exclude: 射手自身 RID（胶囊体 + hitbox），防自伤
## world: 发射时的 World3D
func spawn(
	origin: Vector3,
	direction: Vector3,
	config: WeaponConfig,
	source: Node,
	exclude: Array[RID],
	world: World3D
) -> void:
	if not world:
		GlobalLogger.warn("Ballistics", "spawn() without World3D, bullet dropped")
		return
	if _bullets.size() >= MAX_ACTIVE_BULLETS:
		_bullets.pop_front()
		GlobalLogger.warn("Ballistics", "Active bullet cap reached, oldest bullet dropped")

	_bullets.append({
		"position": origin,
		"velocity": direction.normalized() * config.muzzle_velocity,
		"mass_kg": config.bullet_mass_g / 1000.0,
		"bc": config.ballistic_coefficient,
		"source": weakref(source),
		"exclude": exclude,
		"world": world,
		"traveled": 0.0,
		"time": 0.0,
	})


func _physics_process(delta: float) -> void:
	if _bullets.is_empty():
		return
	# 倒序遍历，命中/超程的弹丸就地移除
	for i in range(_bullets.size() - 1, -1, -1):
		if not _step_bullet(_bullets[i], delta):
			_bullets.remove_at(i)


## 推进单发弹丸一个物理帧。[返回] false = 弹丸应被移除
func _step_bullet(b: Dictionary, delta: float) -> bool:
	var world: World3D = b["world"]
	if not is_instance_valid(world):
		return false

	# 1. 空气阻力：二次阻力 dv/dt = −k·v²，k 由 BC 推导（见 Ballistics.drag_factor）
	var velocity: Vector3 = b["velocity"]
	var speed: float = velocity.length()
	var new_speed: float = maxf(speed - Ballistics.drag_decel(speed, b["bc"]) * delta, 0.0)
	if new_speed < MIN_SPEED_MPS:
		return false

	# 2. 半隐式欧拉积分：先更新速度（阻力 + 重力），再位移
	velocity = velocity * (new_speed / speed) + Vector3.DOWN * _gravity * delta
	var next_position: Vector3 = b["position"] + velocity * delta

	# 3. 分段射线检测（本帧扫过的线段；900 m/s @ 60 Hz ≈ 15 m/帧）
	var query := PhysicsRayQueryParameters3D.create(
		b["position"], next_position, HIT_MASK, b["exclude"]
	)
	query.collide_with_areas = true
	query.collide_with_bodies = true
	var space_state := world.direct_space_state
	if not space_state:
		return false
	var result := space_state.intersect_ray(query)

	if not result.is_empty():
		_on_bullet_hit(b, result, velocity)
		return false

	# 4. 未命中：推进状态，检查超程/超时
	b["velocity"] = velocity
	b["position"] = next_position
	b["traveled"] = b["traveled"] + new_speed * delta
	b["time"] = b["time"] + delta
	return b["traveled"] < MAX_RANGE_M and b["time"] < MAX_FLIGHT_TIME_S


## 命中处理：按落点实时速度计算动能，经 HitResolver 构建 DamageInfo 提交医疗系统。
## 命中环境（无 BasePlayer 祖先）时弹丸静默终止——这就是墙体阻挡。
func _on_bullet_hit(b: Dictionary, ray_result: Dictionary, velocity: Vector3) -> void:
	var collider = ray_result.get("collider", null)
	if not collider:
		return

	var player_node := Projectile.find_player(collider)
	if not player_node:
		return
	if not player_node.has_node("HealthSystem"):
		GlobalLogger.warn("Ballistics", "Hit player has no HealthSystem")
		return

	# 落点动能：速度已含全程阻力/重力衰减 → 远距离命中伤害自然降低
	var impact_speed: float = velocity.length()
	var energy: float = Ballistics.kinetic_energy(b["mass_kg"], impact_speed)

	var source_ref: WeakRef = b["source"]
	var source: Node = source_ref.get_ref() as Node

	# travel_dir 传弹道实际方向：斜射时比表面法线取反更准确
	var info := HitResolver.resolve(
		ray_result, energy, MedicalEnums.DamageType.BULLET, source, velocity.normalized()
	)
	var health_system := player_node.get_node("HealthSystem") as HealthSystem
	health_system.apply_damage(info)

	GlobalLogger.debug("Ballistics", "Bullet hit at %.1fm: %.0f m/s → %.0f J" % [
		b["traveled"], impact_speed, energy
	])


## 当前在飞弹丸数量（调试/测试用）
func get_active_bullet_count() -> int:
	return _bullets.size()
