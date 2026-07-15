class_name BodyRegion
extends RefCounted

# ============================================================
# 单个身体部位的伤情状态
# 功能：追踪部位的伤口列表和累积伤情。
# 注意：无传统 HP 概念——部位状态由伤口严重度累积决定。
# ============================================================

## 所属部位
var part_id: MedicalEnums.BodyPartId = MedicalEnums.BodyPartId.TORSO

## 附属伤口列表
var wounds: Array[Wound] = []


## 返回本部位所有伤口的累积严重度（0.0–无穷大）
## 用于判定部位是否"功能性摧毁"（如累积>2.0时无法使用）
func get_total_severity() -> float:
	var total: float = 0.0
	for w in wounds:
		total += (w as Wound).severity
	return total


## 部位是否有致命伤（单个伤口 severity >= 阈值）
func has_lethal_wound(threshold: float = 0.8) -> bool:
	for w in wounds:
		if (w as Wound).severity >= threshold:
			return true
	return false


## 添加伤口
func add_wound(w: Wound) -> void:
	wounds.append(w)


## 返回本部位所有伤口的总外部失血速率（ml/s）
func total_bleed_ml_per_sec() -> float:
	var total: float = 0.0
	for w in wounds:
		total += (w as Wound).get_bleed_ml_per_sec()
	return total


## 返回本部位所有伤口的总内部失血速率（ml/s，P2）
func total_internal_bleed_ml_per_sec() -> float:
	var total: float = 0.0
	for w in wounds:
		total += (w as Wound).get_internal_bleed_ml_per_sec()
	return total
