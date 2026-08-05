class_name MagazineConfig
extends AttachmentConfig

# ════════════════════════════════════════════════════════════════════════
# 弹匣配置（MagazineConfig）
# 继承自 AttachmentConfig，增加弹匣专属参数。
# 装入 MAGAZINE_WELL 槽后，BaseWeapon._reconfigure_from_attachments() 会
# 提取这些参数注入 AmmoComponent，并更新 reload() 的换弹时间。
# ════════════════════════════════════════════════════════════════════════

@export_group("弹匣参数")
## 弹匣容量（发）
@export var magazine_capacity: int = 30
## 弹匣类型（信息展示用）：detachable_box / drum / integral / belt
@export var magazine_type: String = "detachable_box"
## 是否支持空仓挂机（弹匣最后一发打完后枪机自动挂起）
@export var has_last_round_hold_open: bool = true
## 携带备用弹匣数（不含枪上在用的）
@export var reserve_magazines: int = 4

@export_group("换弹时间")
## 战术换弹时间（s）—— 膛内有弹时，只换弹匣不需要拉机柄
@export var reload_time: float = 2.5
## 空仓换弹时间（s）—— 膛内无弹时，换弹匣后需要拉机柄推弹入膛
@export var reload_empty_time: float = 4.0

@export_subgroup("分段时长 / Staged")
## 分段换弹时长（秒）。三段全为 0 时回退到上面的整段计时。
## 分段的意义：动画与音效按阶段挂接，且后续可实现「换弹中途被打断」。
## 拔出旧弹匣
@export var stage_mag_out_time: float = 0.55
## 插入新弹匣
@export var stage_mag_in_time: float = 0.75
## 拉机柄上膛（仅空仓换弹经历此阶段）
@export var stage_charge_time: float = 0.45
