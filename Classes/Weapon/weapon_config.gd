class_name WeaponConfig
extends Resource

# 基础属性
@export_group("基础属性")
@export var weapon_name: String = "Unnamed Weapon"
@export var weapon_type: String = "rifle"

# 自动原理
@export_group("自动原理")
@export var action_type: String = "gas_operated"
## 可选: gas_operated / blowback / bolt_action / manual
@export var open_bolt: bool = false
## 开膛待击/闭膛待击
@export var cycle_rate: float = 600.0
## 理论射速(RPM)
@export var bolt_mass: float = 0.3
## 枪机质量(kg)，影响枪机速度
@export var recoil_spring_strength: float = 50.0
## 复进簧刚度(N/m)

# 枪管
@export_group("枪管")
@export var barrel_length: float = 0.415
@export var muzzle_velocity: float = 900.0

# 弹药
@export_group("弹药")
@export var magazine_capacity: int = 30
@export var magazine_type: String = "detachable_box"
## 弹匣类型:detachable_box / integral / belt / tube
@export var has_last_round_hold_open: bool = true
## 空仓挂机
@export var reserve_magazines: int = 4
## 携带弹匣数量

# 击发
@export_group("击发")
@export var fire_modes: Array[String] = ["safe", "semi", "auto"]
@export var default_fire_mode: String = "semi"

# 后座力
@export_group("后座")
@export var recoil_vertical: float = 2.0
@export var recoil_horizontal: float = 0.5
@export var recoil_recovery_speed: float = 5.0

# 散布
@export_group("散布")
@export var hipfire_spread: float = 3.0
@export var ads_spread: float = 0.1

# 重量
@export_group("重量")
@export var weight: float = 3.5
@export var weight_affects_movement: bool = true

# 视觉效果
@export_group("视觉效果")
@export var weapon_scene:PackedScene

# 【未实现/待扩展】弹药类型（弹种配置预留）
# @export var bullet_type: String = "fmj"
# @export var bullet_mass: float = 0.0034
# @export var ballistic_coefficient: float = 0.3
