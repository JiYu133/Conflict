class_name ForceTypes
extends RefCounted

# ============================================================
# 通用力系统的共享类型
# 功能：定义力载荷（ForcePayload）的数据结构与衰减曲线，
#       并提供身体部位 → 骨骼名的兜底映射。
# 说明：ForcePayload 只描述“力”，不关心来源是受击、后坐力还是爆炸。
# ============================================================

## 力的衰减曲线类型
enum DecayCurve {
	EXPONENTIAL,  ## 指数衰减；duration 处收敛到 decay_floor
	LINEAR,       ## 线性衰减；duration 处归零
}

## 力的方向所在空间
enum Space {
	WORLD,  ## 方向/原点已是世界空间
	LOCAL,  ## 方向/原点相对玩家局部空间
}

## 指数曲线在 duration 处的残余权重下限。
const DEFAULT_DECAY_FLOOR: float = 0.05


## 单个力的载荷。字段分为两组：
## - 归一化量（magnitude/duration/decay_curve）驱动姿态偏移，便于调参；
## - 物理量（mass_kg/speed_mps/impulse_ns）驱动布娃娃并对外暴露。
class ForcePayload:
	var direction_world: Vector3 = Vector3.ZERO
	var origin_world: Vector3 = Vector3.ZERO
	var has_origin: bool = false
	var magnitude: float = 0.0
	var hit_bone: String = ""
	var duration: float = 0.25
	var decay_curve: DecayCurve = DecayCurve.EXPONENTIAL
	var decay_floor: float = DEFAULT_DECAY_FLOOR
	var elapsed: float = 0.0
	var mass_kg: float = 0.0
	var speed_mps: float = 0.0
	var impulse_ns: float = 0.0
	var source: Node = null

	## 复用一个载荷对象；避免每次受力都分配新对象。
	func reset() -> void:
		direction_world = Vector3.ZERO
		origin_world = Vector3.ZERO
		has_origin = false
		magnitude = 0.0
		hit_bone = ""
		duration = 0.25
		decay_curve = DecayCurve.EXPONENTIAL
		decay_floor = DEFAULT_DECAY_FLOOR
		elapsed = 0.0
		mass_kg = 0.0
		speed_mps = 0.0
		impulse_ns = 0.0
		source = null

	## 从另一个载荷拷贝全部字段。
	func copy_from(other: ForcePayload) -> void:
		direction_world = other.direction_world
		origin_world = other.origin_world
		has_origin = other.has_origin
		magnitude = other.magnitude
		hit_bone = other.hit_bone
		duration = other.duration
		decay_curve = other.decay_curve
		decay_floor = other.decay_floor
		elapsed = other.elapsed
		mass_kg = other.mass_kg
		speed_mps = other.speed_mps
		impulse_ns = other.impulse_ns
		source = other.source

	## 当前时刻的衰减系数（0–1）。
	## 恰好落在 duration 时：指数曲线返回 decay_floor，线性曲线返回 0。
	func curve_weight() -> float:
		return curve_weight_at(elapsed)

	## 指定时刻的衰减系数；超过 duration 后为 0。
	func curve_weight_at(time_s: float) -> float:
		if not is_finite(time_s) or duration <= 0.0 or not is_finite(duration):
			return 0.0
		if time_s < 0.0:
			time_s = 0.0
		if time_s > duration:
			return 0.0
		var t := time_s / duration
		match decay_curve:
			DecayCurve.LINEAR:
				return clampf(1.0 - t, 0.0, 1.0)
			_:
				var floor_value := clampf(decay_floor, 0.0, 1.0)
				return clampf(pow(floor_value, t), 0.0, 1.0)

	## 当前有效强度 = 初始强度 × 衰减系数。
	func current_magnitude() -> float:
		return magnitude * curve_weight()

	## 力是否已耗尽；恰好等于 duration 的帧仍生效，便于观察尾部权重。
	func is_expired() -> bool:
		return duration <= 0.0 or elapsed > duration


## 将字符串形式的衰减曲线名解析为枚举；无法识别时回退指数曲线。
static func parse_decay_curve(value: String) -> DecayCurve:
	match value.strip_edges().to_lower():
		"linear":
			return DecayCurve.LINEAR
		_:
			return DecayCurve.EXPONENTIAL


## 兜底映射：BodyPartId → 模型骨骼名。
## 仅在 DamageInfo.anchor_bone 为空时使用（爆炸/调试注入/布娃娃命中）。
static func bone_for_body_part(part: MedicalEnums.BodyPartId) -> String:
	match part:
		MedicalEnums.BodyPartId.HEAD:
			return "mixamorig_Head"
		MedicalEnums.BodyPartId.TORSO:
			return "mixamorig_Spine1"
		MedicalEnums.BodyPartId.LEFT_UPPER_ARM:
			return "mixamorig_LeftArm"
		MedicalEnums.BodyPartId.LEFT_FOREARM:
			return "mixamorig_LeftForeArm"
		MedicalEnums.BodyPartId.RIGHT_UPPER_ARM:
			return "mixamorig_RightArm"
		MedicalEnums.BodyPartId.RIGHT_FOREARM:
			return "mixamorig_RightForeArm"
		MedicalEnums.BodyPartId.LEFT_THIGH:
			return "mixamorig_LeftUpLeg"
		MedicalEnums.BodyPartId.LEFT_CALF:
			return "mixamorig_LeftLeg"
		MedicalEnums.BodyPartId.RIGHT_THIGH:
			return "mixamorig_RightUpLeg"
		MedicalEnums.BodyPartId.RIGHT_CALF:
			return "mixamorig_RightLeg"
		_:
			return "mixamorig_Spine1"
