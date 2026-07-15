class_name HitResolver
extends RefCounted

# ============================================================
# 命中判定解析器
# 功能：将物理射线检测结果转换为 DamageInfo。
#       通过骨骼名称或 BodyHitbox 查询命中部位。
# 用法：HitResolver.resolve(ray_result, energy_joules, damage_type, source)
# ============================================================

## Mixamo 骨骼名称 → BodyPartId 映射表（ragdoll PhysicalBone3D 命中时使用）
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


## 从射线检测结果构建 DamageInfo
## ray_result: PhysicsDirectSpaceState3D.intersect_ray() 返回的字典
## energy_joules: 预计算的动能（J）
## damage_type: 伤害类型
## source: 攻击来源节点
static func resolve(
	ray_result: Dictionary,
	energy_joules: float,
	damage_type: MedicalEnums.DamageType,
	source: Node
) -> DamageInfo:
	var info := DamageInfo.new()
	info.amount = energy_joules
	info.type = damage_type
	info.hit_position = ray_result.get("position", Vector3.ZERO)
	# normal 指向外（离开碰撞体），取反得弹头入射方向
	info.direction = ray_result.get("normal", Vector3.ZERO) * -1.0
	info.source = source

	var collider = ray_result.get("collider", null)
	info.body_part = _resolve_part_from_collider(collider)
	return info


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
