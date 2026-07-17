class_name HitResolver
extends RefCounted

# ============================================================
# 命中判定解析器
# 功能：将物理射线检测结果转换为 DamageInfo。
#       通过骨骼名称或 BodyHitbox 查询命中部位。
# 用法：HitResolver.resolve(ray_result, energy_joules, damage_type, source)
# ============================================================

## Mixamo 骨骼名称 → BodyPartId 映射表。
## 仅在玩家死亡后（ragdoll 激活）命中 PhysicalBone3D 时使用；
## 存活时由 BodyHitbox.get_body_part_id() 直接返回部位，不经此表。
## 骨骼名匹配采用 contains()，因此 Mixamo 的 "mixamorig_LeftArm" 能匹配到 "LeftArm" 键。
static var BONE_PART_MAP: Dictionary = {
	# 头部 & 颈部
	"Head":           MedicalEnums.BodyPartId.HEAD,
	"Neck":           MedicalEnums.BodyPartId.HEAD,
	# 躯干
	"Hips":           MedicalEnums.BodyPartId.TORSO,
	"Spine":          MedicalEnums.BodyPartId.TORSO,
	"Spine1":         MedicalEnums.BodyPartId.TORSO,
	"Spine2":         MedicalEnums.BodyPartId.TORSO,
	"LeftShoulder":   MedicalEnums.BodyPartId.TORSO,
	"RightShoulder":  MedicalEnums.BodyPartId.TORSO,
	# 左臂
	"LeftArm":        MedicalEnums.BodyPartId.LEFT_UPPER_ARM,
	"LeftForeArm":    MedicalEnums.BodyPartId.LEFT_FOREARM,
	"LeftHand":       MedicalEnums.BodyPartId.LEFT_FOREARM,
	# 右臂
	"RightArm":       MedicalEnums.BodyPartId.RIGHT_UPPER_ARM,
	"RightForeArm":   MedicalEnums.BodyPartId.RIGHT_FOREARM,
	"RightHand":      MedicalEnums.BodyPartId.RIGHT_FOREARM,
	# 左腿
	"LeftUpLeg":      MedicalEnums.BodyPartId.LEFT_THIGH,
	"LeftLeg":        MedicalEnums.BodyPartId.LEFT_CALF,
	"LeftFoot":       MedicalEnums.BodyPartId.LEFT_CALF,
	# 右腿
	"RightUpLeg":     MedicalEnums.BodyPartId.RIGHT_THIGH,
	"RightLeg":       MedicalEnums.BodyPartId.RIGHT_CALF,
	"RightFoot":      MedicalEnums.BodyPartId.RIGHT_CALF,
}


## 将射线命中结果转化为 DamageInfo，供 HealthSystem.apply_damage() 消费。
## 命中部位解析有两条路径：
##   1. 存活：collider 为 BodyHitbox（Area3D），调用 get_body_part_id() 直接取部位
##   2. 死亡后（ragdoll）：collider 为 PhysicalBone3D，通过 BONE_PART_MAP 按骨骼名映射
## [参数] ray_result     PhysicsDirectSpaceState3D.intersect_ray() 返回的字典
## [参数] energy_joules  由 Ballistics.kinetic_energy() 预计算的动能（J）
## [参数] damage_type    伤害类型（MedicalEnums.DamageType）
## [参数] source         攻击来源节点，用于得分/日志
## [参数] travel_dir     弹头实际飞行方向（归一化，可选）。弹道模拟提供真实方向；
##                       缺省 ZERO 时回退为表面法线取反（hitscan 老路径，斜射时略有偏差）
## [返回] 填充好所有字段的 DamageInfo；无法识别部位时默认 TORSO
static func resolve(
	ray_result: Dictionary,
	energy_joules: float,
	damage_type: MedicalEnums.DamageType,
	source: Node,
	travel_dir: Vector3 = Vector3.ZERO
) -> DamageInfo:
	var info := DamageInfo.new()
	info.amount = energy_joules
	info.type = damage_type
	info.hit_position = ray_result.get("position", Vector3.ZERO)
	if travel_dir != Vector3.ZERO:
		info.direction = travel_dir
	else:
		# normal 指向外（离开碰撞体），取反近似弹头入射方向
		info.direction = ray_result.get("normal", Vector3.ZERO) * -1.0
	info.source = source

	var collider = ray_result.get("collider", null)
	info.body_part = _resolve_part_from_collider(collider)
	_fill_wound_channel(info, collider)
	return info


## P2：把世界空间命中信息转换到 hitbox 局部空间，供 AnatomySolver
## 做伤道-结构相交测试。仅存活时命中 BodyHitbox 才有伤道信息；
## 布娃娃（PhysicalBone3D）命中的是尸体，无需解剖判定。
static func _fill_wound_channel(info: DamageInfo, collider: Object) -> void:
	if not (collider is BodyHitbox) or info.direction == Vector3.ZERO:
		return
	var hitbox := collider as BodyHitbox
	var xf: Transform3D = hitbox.global_transform
	info.local_entry = xf.affine_inverse() * info.hit_position
	info.local_direction = (xf.basis.inverse() * info.direction).normalized()
	var attach := hitbox.get_parent()
	if attach is BoneAttachment3D:
		info.anchor_bone = (attach as BoneAttachment3D).bone_name


static func _resolve_part_from_collider(collider: Object) -> MedicalEnums.BodyPartId:
	if not collider:
		return MedicalEnums.BodyPartId.TORSO

	# 存活时命中 BodyHitbox（Area3D），直接读取部位 ID
	if collider.has_method("get_body_part_id"):
		return collider.get_body_part_id()

	# 死亡后命中 PhysicalBone3D（布娃娃），用骨骼名映射
	if collider is PhysicalBone3D:
		var bone_name: String = collider.bone_name
		for candidate: String in BONE_PART_MAP:
			if bone_name.contains(candidate):
				return BONE_PART_MAP[candidate]

	# 兜底返回躯干
	return MedicalEnums.BodyPartId.TORSO
