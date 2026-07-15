class_name MedicalEnums

# ============================================================
# 医疗系统枚举定义
# 功能：集中定义医疗/伤害/治疗相关的所有枚举，避免循环依赖。
# 用法：直接通过 MedicalEnums.BodyPartId.HEAD 引用；
#       或在同文件中直接写 BodyPartId.HEAD（class_name 已全局注册）。
# ============================================================

## 身体部位 ID（P1 6 部位；数据结构预留，未来可扩展 CHEST/ABDOMEN 等子部位）
enum BodyPartId {
	HEAD,
	TORSO,
	LEFT_ARM,
	RIGHT_ARM,
	LEFT_LEG,
	RIGHT_LEG,
}

## 伤害类型
enum DamageType {
	BULLET,
	EXPLOSION,
	FRAGMENT,
	MELEE,
	FALL,
	FIRE,
}

## 玩家整体生理状态（驱动 HUD 显示和行动能力）
enum HealthState {
	HEALTHY,      ## 无伤
	INJURED,      ## 受伤，仍可行动
	CRITICAL,     ## 严重失血或关键部位受创，运动受限（P4 乘数生效）
	UNCONSCIOUS,  ## 失去意识；controllable = false，is_alive = true（P3）
	DEAD,
}

## 伤口类型
enum WoundType {
	PENETRATING,    ## 贯穿伤（枪伤）
	LACERATION,     ## 撕裂伤
	BLUNT_TRAUMA,   ## 钝击伤
	FRACTURE,       ## 骨折（P4）
	BURN,           ## 烧伤（P4）
	BLAST_TRAUMA,   ## 爆炸伤
}

## 出血速率等级
enum BleedRate {
	NONE,        ## 不出血
	CAPILLARY,   ## 毛细血管出血：~0.5 ml/s，不致命但积累
	VENOUS,      ## 静脉出血：~3.0 ml/s，数分钟内危及生命
	ARTERIAL,    ## 动脉出血：~15.0 ml/s，数十秒内致命
}

## 治疗方式
enum TreatmentType {
	BANDAGE,        ## 绷带（止毛细/静脉出血）
	TOURNIQUET,     ## 止血带（仅限肢体，止任意等级出血）
	WOUND_PACKING,  ## 填塞止血（止静脉/动脉出血）
	CHEST_SEAL,     ## 胸腔封闭（P3/P4，处理气胸）
	MORPHINE,       ## 吗啡（P4，缓解疼痛）
	EPINEPHRINE,    ## 肾上腺素（P4，心脏骤停）
	BLOOD_BAG,      ## 血袋输血（P4）
	SPLINT,         ## 夹板（P4，骨折固定）
}
