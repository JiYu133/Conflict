class_name MedicalEnums

# ============================================================
# 医疗系统枚举定义
# 功能：集中定义医疗/伤害/治疗相关的所有枚举，避免循环依赖。
# 用法：直接通过 MedicalEnums.BodyPartId.HEAD 引用；
#       或在同文件中直接写 BodyPartId.HEAD（class_name 已全局注册）。
# ============================================================

## 身体部位 ID（10 部位：头、躯干、上臂×2、前臂×2、大腿×2、小腿×2）
enum BodyPartId {
	HEAD,            ## 头部：单发高 severity 即致命，爆头判定来源
	TORSO,           ## 躯干：累积伤最高容忍度，多发也可致命
	LEFT_UPPER_ARM,  ## 左上臂
	LEFT_FOREARM,    ## 左前臂
	RIGHT_UPPER_ARM, ## 右上臂
	RIGHT_FOREARM,   ## 右前臂
	LEFT_THIGH,      ## 左大腿：含股动脉，动脉出血阈值与头/躯干相同
	LEFT_CALF,       ## 左小腿
	RIGHT_THIGH,     ## 右大腿：同左大腿
	RIGHT_CALF,      ## 右小腿
}

## 伤害类型（决定 WoundType 分类和部分特殊处理逻辑）
enum DamageType {
	BULLET,     ## 子弹：生成 PENETRATING 伤口
	EXPLOSION,  ## 爆炸冲击波：生成 BLAST_TRAUMA 伤口，死亡动画优先使用 EXPLOSION DeathType
	FRAGMENT,   ## 破片：当前同 BULLET 处理（P2 差异化）
	MELEE,      ## 近战：生成 BLUNT_TRAUMA 伤口
	FALL,       ## 坠落：生成 BLUNT_TRAUMA 伤口
	FIRE,       ## 火焰：P4 BURN 伤口，当前同 BLUNT_TRAUMA 处理
}

## 玩家整体生理状态（驱动 HUD 显示和行动能力）
enum HealthState {
	HEALTHY,      ## 无伤
	INJURED,      ## 受伤，仍可行动
	CRITICAL,     ## 严重失血或关键部位受创，运动受限（P4 乘数生效）
	UNCONSCIOUS,  ## 失去意识；controllable = false，is_alive = true（P3）
	DEAD,         ## 死亡；触发 ragdoll 和死亡屏幕
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

## 内部解剖结构类型（P2 解剖模型）
enum StructureType {
	ORGAN,         ## 器官：心/肺/肝/肠/脑等，受损累积并产生内出血/机能惩罚
	BONE,          ## 骨骼：动能超过阈值时骨折
	MAJOR_VESSEL,  ## 大血管：伤道贯穿时产生动脉/静脉出血（外部或内部）
}

## 器官损伤状态（P2）
enum OrganState {
	INTACT,     ## 完好
	DAMAGED,    ## 受损：内出血 + 机能惩罚
	DESTROYED,  ## 摧毁：重度内出血；关键器官（心/脑）直接致死
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
