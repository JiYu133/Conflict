class_name BoltCarrierConfig
extends AttachmentConfig

# ════════════════════════════════════════════════════════════════════════
# 枪机框配置（BoltCarrierConfig）
# 继承自 AttachmentConfig，增加枪机框专属物理参数。
# 装入 BOLT_CARRIER 槽后，BaseWeapon._reconfigure_from_attachments() 会
# 提取这些参数注入 BoltComponent 和 MalfunctionComponent。
# ════════════════════════════════════════════════════════════════════════

@export_group("枪机参数")
## 枪机框组质量（kg），影响后坐速度和循环速度
@export var bolt_mass: float = 0.3
## 复进簧刚度（N/m），影响枪机复进速度
@export var recoil_spring_strength: float = 50.0
## 枪机框后退行程（m），WeaponMovingPartsController 据此驱动视觉位移
@export var bolt_travel_m: float = 0.08

@export_group("可靠性")
## 抛壳失败概率（弹壳卡在抛壳口 → 烟囱卡弹）
@export_range(0.0, 1.0, 0.001) var stovepipe_chance: float = 0.0
## 烟囱卡弹升级为双上膛的概率（抛壳失败且枪机强行复进）
@export_range(0.0, 1.0, 0.001) var double_feed_chance: float = 0.0
