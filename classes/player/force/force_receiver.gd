class_name ForceReceiver
extends Node

# ============================================================
# 通用力接收器
# 功能：与来源解耦的受力入口。任何系统（本期为受击反馈）把力交给它，
#       它负责把力沿骨骼链衰减传播成逐骨骼的姿态偏移，并缓存一份
#       “待用冲量”供布娃娃消费。
# 用法：挂在 BasePlayer 下；攻击侧调用 apply_force()/apply_impact()，
#       ForceBodyModifier 每帧读取 get_pose_offsets() 并写回骨骼。
# ============================================================

## 新力被接受时触发；payload 为 ForceTypes.ForcePayload
signal force_applied(payload)
## 逐骨骼姿态偏移总和越过 overload_threshold 时触发一次（边沿触发）
signal overload_triggered(total: float)

var _player: Node3D = null
var _skeleton: Skeleton3D = null
var _config: ForceConfig = null
var _propagation: ForcePropagation = null

## 当前生效的力
var _active: Array = []
## 复用池，避免每次受力都分配新对象
var _pool: Array = []

## 逐骨骼姿态偏移缓存
var _pose_offsets: Dictionary = {}
## 受力最重的单块骨骼的累计强度（逐骨骼求和后的峰值）。
## pose_cap 与 overload_threshold 都作用在这个量上，因此两者量纲一致：
## 默认值相等意味着“某块骨骼刚到偏移上限时”触发 overload。
var _peak_strength: float = 0.0
var _overloaded: bool = false

## 待布娃娃消费的冲量：{direction, impulse_ns, hit_bone}；一次性
var _pending_impulse: Dictionary = {}

## 骨骼静止朝向缓存（bone_idx → 世界空间单位向量）
var _bone_direction_cache: Dictionary = {}


## 绑定玩家与配置；skeleton 可为空，稍后通过 set_skeleton() 补上。
func initialize(player: Node3D, config: ForceConfig = null, skeleton: Skeleton3D = null) -> void:
	_player = player
	_config = config if config else ForceConfig.new()
	if not is_instance_valid(_propagation):
		_propagation = ForcePropagation.new()
	_propagation.configure(skeleton, _config.decay_per_level, _config.max_propagation_depth)
	_skeleton = skeleton
	_bone_direction_cache.clear()
	_pose_offsets.clear()
	_peak_strength = 0.0
	_overloaded = false


## 模型加载完成后绑定骨骼；会重建传播缓存。
func set_skeleton(skeleton: Skeleton3D) -> void:
	_skeleton = skeleton
	if not is_instance_valid(_propagation):
		_propagation = ForcePropagation.new()
	_propagation.configure(skeleton, _config.decay_per_level, _config.max_propagation_depth)
	_bone_direction_cache.clear()
	_pose_offsets.clear()
	_peak_strength = 0.0
	_overloaded = false


func get_config() -> ForceConfig:
	return _config


func get_skeleton() -> Skeleton3D:
	return _skeleton


# 受力入口 ───────────────────────────────────────────────────

## 通用受力入口。前五个参数为稳定签名。
## direction:      力的方向（world 或 local，取决于 space）
## magnitude:      归一化强度；0–1 便于调参，上限由 pose_cap 负责
## hit_bone:       作用点骨骼名；为空时丢弃
## duration:       持续时间（秒）；<=0 使用配置默认值
## decay_curve:    "exponential" / "linear"
## origin:         点源位置；非零时按径向发力（爆炸）
## space:          direction/origin 所在空间
## mass_kg/speed_mps/impulse_ns: 真实物理量，仅对外暴露与布娃娃使用
func apply_force(
	direction: Vector3,
	magnitude: float,
	hit_bone: String = "",
	duration: float = 0.0,
	decay_curve: String = "exponential",
	origin: Vector3 = Vector3.ZERO,
	space: ForceTypes.Space = ForceTypes.Space.WORLD,
	mass_kg: float = 0.0,
	speed_mps: float = 0.0,
	impulse_ns: float = -1.0
) -> void:
	if not is_finite(magnitude) or magnitude <= 0.0:
		return
	if not direction.is_finite():
		return
	var has_origin := origin.is_finite() and origin.length_squared() > 0.000001
	if direction.length_squared() <= 0.000001 and not has_origin:
		return
	var direction_world := direction
	var origin_world := origin
	if space == ForceTypes.Space.LOCAL:
		var basis := _player_basis()
		direction_world = basis * direction
		origin_world = _player_to_world(origin)
	if _resolve_bone_index(hit_bone) < 0:
		return

	var payload: ForceTypes.ForcePayload = _acquire_payload()
	if direction_world.length_squared() > 0.0:
		payload.direction_world = direction_world.normalized()
	else:
		payload.direction_world = Vector3.ZERO
	payload.origin_world = origin_world
	payload.has_origin = has_origin
	payload.magnitude = magnitude
	payload.hit_bone = hit_bone
	payload.duration = duration if (is_finite(duration) and duration > 0.0) else _config.default_duration
	payload.decay_curve = ForceTypes.parse_decay_curve(decay_curve)
	payload.decay_floor = _config.decay_floor
	payload.elapsed = 0.0
	payload.mass_kg = maxf(mass_kg, 0.0) if is_finite(mass_kg) else 0.0
	payload.speed_mps = maxf(speed_mps, 0.0) if is_finite(speed_mps) else 0.0
	payload.impulse_ns = impulse_ns if is_finite(impulse_ns) else 0.0
	payload.source = null

	_active.append(payload)
	_trim_active()
	force_applied.emit(payload)


## 从伤害事件推导力与待用冲量。本期唯一接入点（HealthSystem.damage_taken）。
func apply_impact(info: DamageInfo) -> void:
	if info == null:
		return
	var direction := info.direction
	if not direction.is_finite() or direction.length_squared() <= 0.000001:
		return
	var hit_bone := info.anchor_bone
	if hit_bone.is_empty():
		hit_bone = ForceTypes.bone_for_body_part(info.body_part)
	if not is_finite(info.amount) or info.amount <= 0.0:
		return
	if _resolve_bone_index(hit_bone) < 0:
		return

	var is_headshot := info.body_part == MedicalEnums.BodyPartId.HEAD
	var is_explosion := info.type == MedicalEnums.DamageType.EXPLOSION
	var effective_mass := info.impact_mass_kg
	if not is_finite(effective_mass) or effective_mass <= 0.0:
		if info.type == MedicalEnums.DamageType.BULLET or info.type == MedicalEnums.DamageType.FRAGMENT:
			# 弹道伤害缺少弹头质量时无法从能量唯一确定动量；不猜质量。
			return
		effective_mass = _config.fallback_impact_mass_kg
	effective_mass = maxf(effective_mass, 0.001)

	var transfer_ratio := _config.impact_energy_transfer
	if is_headshot:
		transfer_ratio = _config.headshot_energy_transfer
	elif is_explosion:
		transfer_ratio = _config.explosion_energy_transfer
	transfer_ratio = clampf(transfer_ratio, 0.0, 1.0)

	# p = sqrt(2*m*E)，与 PlayerRagdollSystem 的动能换算保持一致。
	var impulse := sqrt(2.0 * effective_mass * info.amount) * transfer_ratio
	if not is_finite(impulse) or impulse <= 0.0:
		return
	var magnitude := _config.normalized_magnitude(impulse)
	if magnitude <= 0.0:
		return

	var has_origin := is_explosion and info.hit_position.is_finite() and info.hit_position.length_squared() > 0.000001
	var velocity := info.impact_velocity if is_finite(info.impact_velocity) else 0.0
	apply_force(
		direction,
		magnitude,
		hit_bone,
		0.0,
		"exponential",
		info.hit_position if has_origin else Vector3.ZERO,
		ForceTypes.Space.WORLD,
		effective_mass,
		maxf(velocity, 0.0),
		impulse
	)
	_pending_impulse = {
		"direction": direction.normalized(),
		"impulse_ns": impulse,
		"hit_bone": hit_bone,
	}


# 布娃娃接口 ─────────────────────────────────────────────────

## 一次性取走待用冲量；取走后清空，第二次返回空字典。
func consume_pending_impulse() -> Dictionary:
	if _pending_impulse.is_empty():
		return {}
	var result := _pending_impulse
	_pending_impulse = {}
	return result


func clear_pending_impulse() -> void:
	_pending_impulse = {}


## 清空所有生效中的力（复活/重生时调用）。
func clear_forces() -> void:
	for payload in _active:
		_release_payload(payload)
	_active.clear()
	_pose_offsets.clear()
	_peak_strength = 0.0
	_overloaded = false


# 查询 ───────────────────────────────────────────────────────

## 逐骨骼姿态偏移总和（未钳制），overload 判定的依据。
func get_total_magnitude() -> float:
	return _peak_strength


## 当前生效的力数量。
func get_active_force_count() -> int:
	return _active.size()


## 调试/测试快照：逐骨骼姿态偏移 + 汇总。
func get_pose_snapshot() -> Dictionary:
	var bones := {}
	for bone_idx in _pose_offsets:
		var entry: Dictionary = _pose_offsets[bone_idx]
		bones[bone_idx] = {
			"angle": entry["angle"],
			"axis": entry["axis"],
			"translation": entry["translation"],
			"depth": entry["depth"],
			"strength": entry["raw_strength"],
		}
	return {
		"total": _peak_strength,
		"overloaded": _overloaded,
		"active_forces": _active.size(),
		"bones": bones,
	}


## 返回逐骨骼姿态偏移：{bone_idx: {"axis", "angle", "translation", "depth"}}。
func get_pose_offsets() -> Dictionary:
	return _pose_offsets


# 每帧推进 ───────────────────────────────────────────────────

func _process(delta: float) -> void:
	update_pose_offsets(delta)


## 推进力的生命周期并重算姿态偏移。
## 独立成公开方法，便于无场景的测试直接驱动。
func update_pose_offsets(delta: float) -> void:
	var step := delta if is_finite(delta) and delta > 0.0 else 0.0
	var index := _active.size() - 1
	while index >= 0:
		var payload: ForceTypes.ForcePayload = _active[index]
		payload.elapsed += step
		if payload.is_expired():
			_active.remove_at(index)
			_release_payload(payload)
		index -= 1
	_rebuild_pose_offsets()
	_update_overload()


# 内部 — 姿态偏移求解 ────────────────────────────────────────

func _rebuild_pose_offsets() -> void:
	_pose_offsets.clear()
	_peak_strength = 0.0
	if not is_instance_valid(_skeleton) or _active.is_empty():
		return
	for raw_payload in _active:
		var payload: ForceTypes.ForcePayload = raw_payload
		var bone_idx := _skeleton.find_bone(payload.hit_bone)
		if bone_idx < 0:
			continue
		var curve: float = payload.curve_weight()
		if curve <= 0.0:
			continue
		var weights := _propagation.weights_for(bone_idx)
		for affected_idx in weights:
			var info: Dictionary = weights[affected_idx]
			var weight: float = info["weight"]
			if weight <= 0.0:
				continue
			var direction: Vector3 = _direction_for_bone(payload, int(affected_idx))
			if direction.length_squared() <= 0.0:
				continue
			var scalar: float = payload.magnitude * curve * weight
			if scalar <= 0.0:
				continue
			if not _pose_offsets.has(affected_idx):
				_pose_offsets[affected_idx] = {
					"push": Vector3.ZERO,
					"depth": int(info["depth"]),
					"raw_strength": 0.0,
				}
			var accumulated: Dictionary = _pose_offsets[affected_idx]
			accumulated["push"] = accumulated["push"] + direction * scalar
			accumulated["raw_strength"] = float(accumulated["raw_strength"]) + scalar
			accumulated["depth"] = mini(int(accumulated["depth"]), int(info["depth"]))

	for bone_idx in _pose_offsets.keys():
		var raw: Dictionary = _pose_offsets[bone_idx]
		var resolved := _resolve_offset(
			int(bone_idx),
			raw["push"],
			float(raw["raw_strength"]),
			int(raw["depth"])
		)
		_peak_strength = maxf(_peak_strength, float(raw["raw_strength"]))
		if resolved.is_empty():
			_pose_offsets.erase(bone_idx)
		else:
			_pose_offsets[bone_idx] = resolved


## 把“合力向量”转成旋转轴/角度与位移。
## push 的长度承载强度；超过 pose_cap 后不再增加偏移量。
func _resolve_offset(bone_idx: int, push: Vector3, strength: float, depth: int) -> Dictionary:
	if not push.is_finite() or push.length_squared() <= 0.0:
		return {}
	var push_length := push.length()
	var direction := push / push_length
	var effective := minf(push_length, maxf(_config.pose_cap, 0.0))
	var translation := Vector3.ZERO
	if depth <= _config.translation_max_depth:
		var distance := clampf(
			_config.translation_gain * effective,
			0.0,
			maxf(_config.max_translation_m, 0.0)
		)
		translation = direction * distance
	var axis := Vector3.ZERO
	var angle := 0.0
	var bone_direction := _bone_direction_world(bone_idx)
	if bone_direction.length_squared() > 0.0:
		var candidate := bone_direction.cross(direction)
		if candidate.length_squared() > 0.0000001:
			axis = candidate.normalized()
			angle = _config.rotation_gain * effective
	if not is_finite(angle) or not axis.is_finite() or not translation.is_finite():
		return {}
	return {
		"axis": axis,
		"angle": angle,
		"translation": translation,
		"depth": depth,
		"raw_strength": strength,
	}


## 点源（爆炸）按径向取方向；其余情况使用统一方向。
func _direction_for_bone(payload: ForceTypes.ForcePayload, bone_idx: int) -> Vector3:
	if not payload.has_origin:
		return payload.direction_world
	var bone_world := _bone_world_position(bone_idx)
	var radial := bone_world - payload.origin_world
	if radial.length_squared() <= 0.000001:
		return payload.direction_world
	return radial.normalized()


func _update_overload() -> void:
	var threshold := maxf(_config.overload_threshold, 0.0)
	var now_overloaded := _peak_strength >= threshold and _peak_strength > 0.0
	if now_overloaded and not _overloaded:
		overload_triggered.emit(_peak_strength)
	_overloaded = now_overloaded


# 内部 — 骨骼几何 ────────────────────────────────────────────

func _bone_world_position(bone_idx: int) -> Vector3:
	if not is_instance_valid(_skeleton):
		return Vector3.ZERO
	return _skeleton.global_transform * _skeleton.get_bone_global_pose(bone_idx).origin


## 骨骼的“链条朝向”：优先父 → 本骨，其次本骨 → 首个子骨。
## 依据静止姿态计算并缓存，不随每帧偏移变化，避免正反馈漂移。
func _bone_direction_world(bone_idx: int) -> Vector3:
	if _bone_direction_cache.has(bone_idx):
		return _bone_direction_cache[bone_idx]
	var direction := Vector3.ZERO
	if is_instance_valid(_skeleton):
		var parent_idx := _skeleton.get_bone_parent(bone_idx)
		var from_idx := -1
		var to_idx := -1
		if parent_idx >= 0:
			from_idx = parent_idx
			to_idx = bone_idx
		else:
			var child_idx := _first_child_of(bone_idx)
			if child_idx >= 0:
				from_idx = bone_idx
				to_idx = child_idx
		if from_idx >= 0 and to_idx >= 0:
			var from_pos := _skeleton.get_bone_global_rest(from_idx).origin
			var to_pos := _skeleton.get_bone_global_rest(to_idx).origin
			var local_direction := to_pos - from_pos
			if local_direction.length_squared() > 0.0000001:
				direction = (_skeleton.global_transform.basis * local_direction).normalized()
	_bone_direction_cache[bone_idx] = direction
	return direction


func _first_child_of(bone_idx: int) -> int:
	if not is_instance_valid(_skeleton):
		return -1
	for candidate in _skeleton.get_bone_count():
		if _skeleton.get_bone_parent(candidate) == bone_idx:
			return candidate
	return -1


# 内部 — 载荷池 ─────────────────────────────────────────────

func _acquire_payload() -> ForceTypes.ForcePayload:
	if not _pool.is_empty():
		var reused: ForceTypes.ForcePayload = _pool.pop_back()
		return reused
	return ForceTypes.ForcePayload.new()


func _release_payload(payload: ForceTypes.ForcePayload) -> void:
	payload.reset()
	_pool.append(payload)


func _trim_active() -> void:
	var limit := maxi(_config.max_active_forces, 1)
	while _active.size() > limit:
		var oldest: ForceTypes.ForcePayload = _active.pop_front()
		_release_payload(oldest)


# 内部 — 工具 ───────────────────────────────────────────────

func _resolve_bone_index(hit_bone: String) -> int:
	if hit_bone.is_empty():
		GlobalLogger.warn("Force", "hit_bone 为空，本次力已丢弃")
		return -1
	if not is_instance_valid(_skeleton):
		return -1
	var bone_idx := _skeleton.find_bone(hit_bone)
	if bone_idx < 0:
		GlobalLogger.warn("Force", "未找到骨骼 '%s'，本次力已丢弃" % hit_bone)
	return bone_idx


func _player_basis() -> Basis:
	if is_instance_valid(_player):
		return _player.global_transform.basis.orthonormalized()
	return Basis.IDENTITY


func _player_to_world(local_point: Vector3) -> Vector3:
	if is_instance_valid(_player):
		return _player.global_transform * local_point
	return local_point
