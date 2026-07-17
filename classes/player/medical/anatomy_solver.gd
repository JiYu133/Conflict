class_name AnatomySolver
extends RefCounted

# ============================================================
# 解剖伤道求解器（P2，纯静态无状态）
# 功能：判定一条伤道（入射点 + 方向 + 由动能决定的侵彻深度）
#       伤及了哪些内部结构（器官/骨骼/大血管）。
#
# 判定模型：
#   1. 伤道 = hitbox 局部空间中的线段（长度 ∝ 动能）
#   2. 结构 = 线段 + 半径的胶囊体（AnatomyStructure 定义）
#   3. 两线段最近距离 d：
#        d ≤ 结构半径 + 永久伤道半径          → 直接贯穿（direct）
#        d ≤ 上值 + 临时空腔半径（∝ 动能）    → 空腔波及（概率随距离衰减）
#   4. 动能 < 结构 min_damage_energy → 不造成结构损伤（如低速弹打不断股骨）
#
# 关键设计：动脉出血不再由"命中部位"保证——只有伤道真正经过
# 血管（或空腔波及判定成功）才会产生动脉出血；动能只影响伤道
# 长度/空腔大小/损伤概率与程度，不直接决定出血类型。
# ============================================================


## 单个结构命中结果
## structure: AnatomyStructure — 被伤及的结构
## direct: bool — true = 伤道直接贯穿；false = 临时空腔波及
## damage_factor: float — 损伤程度系数（直接 1.0；空腔按距离 0.2–0.6）
class StructureHit:
	var structure: AnatomyStructure
	var direct: bool = true
	var damage_factor: float = 1.0


## 沿伤道求解全部被伤及的结构。
## [参数] entry_local  入射点（hitbox 局部空间）
## [参数] dir_local    弹道方向（hitbox 局部空间，归一化）
## [参数] energy       命中动能（J），决定伤道长度与空腔半径
## [参数] candidates   候选结构列表（AnatomyConfig.get_structures_for_bone）
## [参数] config       解剖配置（伤道求解参数）
## [参数] rng          随机数发生器（概率判定）
## [返回] Array[StructureHit]
static func solve_channel(
	entry_local: Vector3,
	dir_local: Vector3,
	energy: float,
	candidates: Array,
	config: AnatomyConfig,
	rng: RandomNumberGenerator
) -> Array:
	var hits: Array = []
	if candidates.is_empty() or dir_local == Vector3.ZERO:
		return hits

	var energy_kj: float = energy / 1000.0
	var channel_length: float = clampf(
		config.penetration_m_per_kj * energy_kj,
		config.min_channel_length,
		config.max_channel_length
	)
	var channel_end: Vector3 = entry_local + dir_local.normalized() * channel_length
	var cavity_radius: float = config.cavity_radius_per_kj * energy_kj

	for candidate in candidates:
		var s := candidate as AnatomyStructure
		if energy < s.min_damage_energy:
			continue

		var dist: float = _segment_segment_distance(
			entry_local, channel_end, s.start_point, s.end_point
		)
		var direct_threshold: float = s.radius + config.channel_radius
		var cavity_threshold: float = direct_threshold + cavity_radius

		if dist <= direct_threshold:
			# 直接贯穿
			if rng.randf() < s.direct_hit_probability:
				var hit := StructureHit.new()
				hit.structure = s
				hit.direct = true
				hit.damage_factor = 1.0
				hits.append(hit)
		elif dist <= cavity_threshold and cavity_radius > 0.0:
			# 临时空腔波及：概率与损伤程度均随距离线性衰减
			var falloff: float = 1.0 - (dist - direct_threshold) / cavity_radius
			if rng.randf() < s.cavity_hit_probability * falloff:
				var hit := StructureHit.new()
				hit.structure = s
				hit.direct = false
				hit.damage_factor = lerpf(0.2, 0.6, falloff)
				hits.append(hit)

	return hits


## 无伤道信息时的盲判回退（爆炸冲击波、调试注入、方向未知的伤害）：
## 对部位内每个结构按 blind_hit_probability 独立掷骰。
## [参数] energy      动能（J），仍需超过结构 min_damage_energy
## [参数] candidates  候选结构列表（AnatomyConfig.get_structures_for_part）
## [返回] Array[StructureHit]（全部按空腔级损伤程度处理）
static func solve_blind(
	energy: float,
	candidates: Array,
	rng: RandomNumberGenerator
) -> Array:
	var hits: Array = []
	for candidate in candidates:
		var s := candidate as AnatomyStructure
		if energy < s.min_damage_energy:
			continue
		if rng.randf() < s.blind_hit_probability:
			var hit := StructureHit.new()
			hit.structure = s
			hit.direct = false
			hit.damage_factor = 0.5
			hits.append(hit)
	return hits


## 两条 3D 线段之间的最近距离（标准算法，含退化情形处理）
static func _segment_segment_distance(p1: Vector3, q1: Vector3, p2: Vector3, q2: Vector3) -> float:
	var d1: Vector3 = q1 - p1  # 线段1方向
	var d2: Vector3 = q2 - p2  # 线段2方向
	var r: Vector3 = p1 - p2
	var a: float = d1.dot(d1)
	var e: float = d2.dot(d2)
	var f: float = d2.dot(r)

	var s: float
	var t: float

	if a <= 0.000001 and e <= 0.000001:
		# 两条线段都退化为点
		return r.length()
	if a <= 0.000001:
		s = 0.0
		t = clampf(f / e, 0.0, 1.0)
	else:
		var c: float = d1.dot(r)
		if e <= 0.000001:
			t = 0.0
			s = clampf(-c / a, 0.0, 1.0)
		else:
			var b: float = d1.dot(d2)
			var denom: float = a * e - b * b
			s = clampf((b * f - c * e) / denom, 0.0, 1.0) if denom > 0.000001 else 0.0
			t = (b * s + f) / e
			# t 越界时夹紧并重算 s
			if t < 0.0:
				t = 0.0
				s = clampf(-c / a, 0.0, 1.0)
			elif t > 1.0:
				t = 1.0
				s = clampf((b - c) / a, 0.0, 1.0)

	var closest1: Vector3 = p1 + d1 * s
	var closest2: Vector3 = p2 + d2 * t
	return closest1.distance_to(closest2)
