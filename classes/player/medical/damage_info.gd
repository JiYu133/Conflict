class_name DamageInfo
extends RefCounted

# ============================================================
# 伤害事件载体
# 功能：封装单次伤害的全部信息；由 Combat 层构建，交给 HealthSystem 消费。
# 使用 RefCounted 避免 Node 开销，量大时也不会影响帧率。
# ============================================================

## 传递的动能（焦耳）；由 Ballistics.kinetic_energy() 计算
var amount: float = 0.0

## 伤害类型
var type: MedicalEnums.DamageType = MedicalEnums.DamageType.BULLET

## 命中的身体部位
var body_part: MedicalEnums.BodyPartId = MedicalEnums.BodyPartId.TORSO

## 世界坐标系下的弹头飞行方向（归一化）；用于死亡类型判断
var direction: Vector3 = Vector3.ZERO

## 世界坐标系下的命中位置
var hit_position: Vector3 = Vector3.ZERO

## 攻击来源节点（玩家/NPC/爆炸物）；用于计分和日志
var source: Node = null

## 弹头是否穿透（过穿，P2 扩展用）
var is_penetrating: bool = false

## 命中时的弹头速度（m/s）；由 Ballistics 填入，供伤口严重程度细分
var impact_velocity: float = 0.0

## 命中时的弹头质量（kg）；由 Combat 层填入，供通用冲击响应计算动量。
## 0 表示该伤害没有可用的实体质量（例如控制台/脚本伤害）。
var impact_mass_kg: float = 0.0

# ── 伤道局部信息（P2 解剖模型；由 HitResolver 填入）──────────
# 仅存活时命中 BodyHitbox 才有值；anchor_bone 为空 = 无伤道信息，
# AnatomySolver 走盲判回退路径（爆炸/调试注入/布娃娃命中）。

## 命中 hitbox 锚定的骨骼名（如 "mixamorig_Spine2"）；"" = 无伤道信息
var anchor_bone: String = ""

## 入射点（hitbox 局部空间坐标，米）
var local_entry: Vector3 = Vector3.ZERO

## 弹道方向（hitbox 局部空间，归一化）
var local_direction: Vector3 = Vector3.ZERO

## 是否携带可用于解剖求解的伤道信息
func has_wound_channel() -> bool:
	return anchor_bone != "" and local_direction != Vector3.ZERO
