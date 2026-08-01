class_name BarrelConfig
extends AttachmentConfig

# ════════════════════════════════════════════════════════════════════════
# 枪管配置（BarrelConfig）
# 继承自 AttachmentConfig，在配件通用字段基础上增加枪管专属物理参数。
# 装入 BARREL 槽后，BaseWeapon._reconfigure_from_attachments() 会提取这些
# 参数注入 GasComponent 和 EjectionComponent。
# ════════════════════════════════════════════════════════════════════════

@export_group("枪管参数")
## 枪管长度（m），影响导气延时和弹头在膛内的加速时间
@export var barrel_length: float = 0.415
## 弹头初速（m/s），弹道计算和导气系统的基准速度
@export var muzzle_velocity: float = 900.0
## 弹药口径（信息展示用）
@export var caliber: String = "5.45x39mm"

@export_group("弹道学参数")
## 弹头质量（克），动能计算 KE = 0.5 × m × v²
@export var bullet_mass_g: float = 5.2
## 弹道系数（G1 近似），驱动空气阻力衰减
@export_range(0.05, 1.0, 0.01) var ballistic_coefficient: float = 0.25

@export_group("燃气物理")
## 装药质量（克），用于后座燃气冲量
@export var propellant_mass_g: float = 1.6
## 燃气出口速度（m/s），用于后座燃气冲量
@export var gas_exit_velocity_mps: float = 900.0
## 燃气动量进入后座冲量的比例
@export var gas_impulse_factor: float = 0.6
## 每发装药/初速波动，用于少量物理随机性
@export_range(0.0, 0.2, 0.001) var charge_variation: float = 0.02

@export_group("可靠性")
## 底火哑火概率（枪管/弹药质量决定）
@export_range(0.0, 1.0, 0.001) var misfire_chance: float = 0.0
