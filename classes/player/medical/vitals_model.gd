class_name VitalsModel
extends RefCounted

# ============================================================
# 玩家生理状态数据模型（纯数据，无信号）
# 功能：存储血量、各部位状态及三大生理系统（循环/呼吸/神经）数据。
#       P1 只运行循环系统；呼吸/神经为 P3/P4 存根。
# 由 HealthSystem 持有并在 _physics_process tick 中更新。
# ============================================================

# ── 循环系统 ────────────────────────────────────────────────

## 当前血量（ml）
var blood_volume_ml: float = 5000.0

## 最大血量（ml），初始化时由配置固定
var max_blood_volume_ml: float = 5000.0

## 各身体部位；键为 int(MedicalEnums.BodyPartId)，值为 BodyRegion
var regions: Dictionary = {}

# ── 呼吸系统（P3/P4 存根）───────────────────────────────────

## 呼吸效率：1.0 = 正常，0.0 = 完全阻塞
var breathing_effectiveness: float = 1.0

## 氧合水平：1.0 = 正常（P4 细化）
var oxygenation: float = 1.0

# ── 神经系统（P4 存根）─────────────────────────────────────

## 意识等级：1.0 = 完全清醒，0.0 = 无响应
var consciousness_level: float = 1.0

## 疼痛等级：0.0（无痛）~ 1.0（极度疼痛）
var pain_level: float = 0.0

# ── 内部 ────────────────────────────────────────────────────

var _next_wound_id: int = 0


## 根据 HealthConfig 初始化各部位和基础血量（复活时重复调用可完全重置）
func initialize(config: HealthConfig) -> void:
	blood_volume_ml = config.blood_volume_ml
	max_blood_volume_ml = config.blood_volume_ml
	breathing_effectiveness = 1.0
	oxygenation = 1.0
	consciousness_level = 1.0
	pain_level = 0.0
	_build_regions(config)


func _build_regions(config: HealthConfig) -> void:
	for part_id: int in [
		MedicalEnums.BodyPartId.HEAD,
		MedicalEnums.BodyPartId.TORSO,
		MedicalEnums.BodyPartId.LEFT_UPPER_ARM,
		MedicalEnums.BodyPartId.LEFT_FOREARM,
		MedicalEnums.BodyPartId.RIGHT_UPPER_ARM,
		MedicalEnums.BodyPartId.RIGHT_FOREARM,
		MedicalEnums.BodyPartId.LEFT_THIGH,
		MedicalEnums.BodyPartId.LEFT_CALF,
		MedicalEnums.BodyPartId.RIGHT_THIGH,
		MedicalEnums.BodyPartId.RIGHT_CALF,
	]:
		var region := BodyRegion.new()
		region.part_id = part_id as MedicalEnums.BodyPartId
		regions[part_id] = region


## 分配一个唯一的伤口 ID
func allocate_wound_id() -> int:
	_next_wound_id += 1
	return _next_wound_id


## 获取指定部位的 BodyRegion；找不到返回 null
func get_region(part: MedicalEnums.BodyPartId) -> BodyRegion:
	return regions.get(int(part), null)


## 返回当前血量百分比（0.0–1.0）
func get_blood_pct() -> float:
	if max_blood_volume_ml <= 0.0:
		return 0.0
	return blood_volume_ml / max_blood_volume_ml


## 返回全身总外部失血速率（ml/s）
func total_bleed_rate() -> float:
	var total: float = 0.0
	for part_id: int in regions:
		total += (regions[part_id] as BodyRegion).total_bleed_ml_per_sec()
	return total


## 返回全身总内部失血速率（ml/s，P2）
func total_internal_bleed_rate() -> float:
	var total: float = 0.0
	for part_id: int in regions:
		total += (regions[part_id] as BodyRegion).total_internal_bleed_ml_per_sec()
	return total
