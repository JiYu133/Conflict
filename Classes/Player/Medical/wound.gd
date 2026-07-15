class_name Wound
extends RefCounted

# ============================================================
# 伤口实例
# 功能：记录单个伤口的持久状态，包括出血、处置情况。
# 由 HealthSystem 创建，存储在 BodyRegion.wounds 中。
# ============================================================

## 每种出血等级对应的毫升/秒失血速率
const BLEED_RATE_ML_PER_SEC: Dictionary = {
	MedicalEnums.BleedRate.NONE:      0.0,
	MedicalEnums.BleedRate.CAPILLARY: 0.5,
	MedicalEnums.BleedRate.VENOUS:    3.0,
	MedicalEnums.BleedRate.ARTERIAL: 15.0,
}

## 由 VitalsModel 分配的唯一 ID（单调递增）
var wound_id: int = 0

## 所在部位
var body_part: MedicalEnums.BodyPartId = MedicalEnums.BodyPartId.TORSO

## 伤口类型
var type: MedicalEnums.WoundType = MedicalEnums.WoundType.PENETRATING

## 伤口严重程度：0.0（轻微）~ 1.0（部位摧毁级）
var severity: float = 0.0

## 外部出血等级（直接影响血量）
var bleed_rate: MedicalEnums.BleedRate = MedicalEnums.BleedRate.NONE

## 内部出血等级（P2 启用；P1 始终 NONE）
var internal_bleed_rate: MedicalEnums.BleedRate = MedicalEnums.BleedRate.NONE

## 是否已包扎（绷带/填塞）
var is_bandaged: bool = false

## 是否已上止血带（仅肢体有效）
var is_tourniqueted: bool = false

## 是否已填塞
var is_packed: bool = false

## 疼痛贡献值（0.0–1.0），P4 神经系统使用
var pain_contribution: float = 0.0


## 返回当前有效的外部失血速率（ml/s）。
## 已包扎或已上止血带时返回 0。
func get_bleed_ml_per_sec() -> float:
	if is_bandaged or is_tourniqueted:
		return 0.0
	return BLEED_RATE_ML_PER_SEC.get(bleed_rate, 0.0)


## 返回当前有效的内部失血速率（ml/s）。P2 启用。
func get_internal_bleed_ml_per_sec() -> float:
	if is_packed:
		return 0.0
	return BLEED_RATE_ML_PER_SEC.get(internal_bleed_rate, 0.0)
