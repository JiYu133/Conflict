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
## 弹头最大直径（mm），用于外弹道/穿透参数记录
@export var bullet_diameter_mm: float = 5.45
## 弹头长度（mm），近似值；未配置时只用于记录，不影响旧资源加载
@export var bullet_length_mm: float = 25.6
## 膛线缠距（m/转）。AK 系列常见右旋约 195 mm/转。
@export var rifling_twist_rate_m: float = 0.195
## 右旋为 1，左旋为 -1；0 表示没有可用的方向信息
@export_range(-1, 1, 1) var rifling_direction: int = 1
## 是否根据枪口初速和飞行时间估算简化自旋漂移
@export var enable_spin_drift: bool = false
## 自旋漂移微调系数；默认值保持在瞄准误差之下
@export_range(0.0, 0.01, 0.0001) var spin_drift_scale: float = 0.0005
## 是否给初始枪口方向加入弹道随机散布
@export var enable_ballistic_random_spread: bool = false
## 随机散布最大锥角（MOA）；开关关闭或为 0 时不改变枪口轴线
@export_range(0.0, 20.0, 0.01) var ballistic_spread_moa: float = 0.0

var bullet_diameter_m: float:
	get:
		return bullet_diameter_mm / 1000.0
	set(value):
		bullet_diameter_mm = value * 1000.0

var bullet_length_m: float:
	get:
		return bullet_length_mm / 1000.0
	set(value):
		bullet_length_mm = value * 1000.0

var rifling_twist_m: float:
	get:
		return rifling_twist_rate_m
	set(value):
		rifling_twist_rate_m = value

var rifling_right_hand: bool:
	get:
		return rifling_direction >= 0
	set(value):
		rifling_direction = 1 if value else -1

var spin_drift_enabled: bool:
	get:
		return enable_spin_drift
	set(value):
		enable_spin_drift = value

var random_spread_enabled: bool:
	get:
		return enable_ballistic_random_spread
	set(value):
		enable_ballistic_random_spread = value

var enable_random_spread: bool:
	get:
		return enable_ballistic_random_spread
	set(value):
		enable_ballistic_random_spread = value

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
