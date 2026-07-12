class_name WeaponConfig
extends Resource

# ============================================================
# 武器配置资源
# 功能：作为武器参数的中央数据容器，所有子系统（枪机、弹药、
#       导气、后座等）的初始化均依赖此配置。
# 用法：在 Godot 编辑器中创建 .tres 资源文件，填入具体数值，
#       然后通过 BaseWeapon.initialize(cfg) 注入到武器实例。
# ============================================================

# 基础属性 ─────────────────────────────────────────────────
@export_group("基础属性")
## 武器显示名称 / Weapon display name
@export var weapon_name: String = "Unnamed Weapon"
## 武器种类标识（rifle / smg / shotgun / pistol 等） / Weapon category tag
@export var weapon_type: String = "rifle"

# 自动原理 ─────────────────────────────────────────────────
@export_group("自动原理")
## 自动方式：gas_operated / blowback / bolt_action / manual / Action type: gas_operated / blowback / bolt_action / manual
@export var action_type: String = "gas_operated"
## true = 开膛待击，false = 闭膛待击 / true = open bolt, false = closed bolt
@export var open_bolt: bool = false
## 理论射速（RPM）/ Theoretical rate of fire (rounds per minute)
@export var cycle_rate: float = 600.0
## 枪机组质量（kg），影响循环速度 / Bolt group mass in kg, affects cycle time
@export var bolt_mass: float = 0.3
## 复进簧刚度（N/m），影响复进速度 / Recoil spring stiffness in N/m
@export var recoil_spring_strength: float = 50.0

# 枪管 ────────────────────────────────────────────────────
@export_group("枪管")
## 枪管长度（m），影响导气延时和初速 / Barrel length in m, affects gas timing and muzzle velocity
@export var barrel_length: float = 0.415
## 弹头初速（m/s）/ Muzzle velocity in m/s
@export var muzzle_velocity: float = 900.0

# 弹药 ────────────────────────────────────────────────────
@export_group("弹药")
## 单弹匣容量 / Magazine capacity in rounds
@export var magazine_capacity: int = 30
## 弹匣类型：detachable_box / integral / belt / tube / Magazine type
@export var magazine_type: String = "detachable_box"
## 是否支持空仓挂机 / Whether last-round bolt hold-open is supported
@export var has_last_round_hold_open: bool = true
## 携带备用弹匣数（不含枪上在用的） / Number of spare magazines carried
@export var reserve_magazines: int = 4

# 击发 ────────────────────────────────────────────────────
@export_group("击发")
## 可选射击模式列表 / Available fire mode list
@export var fire_modes: Array[String] = ["safe", "semi", "auto"]
## 默认射击模式 / Default fire mode on spawn
@export var default_fire_mode: String = "semi"

# 换弹 ────────────────────────────────────────────────────
@export_group("换弹")
## 战术换弹时间（s）/ Tactical reload time in seconds
@export var reload_time: float = 2.5
## 空仓换弹时间（s）/ Empty-chamber reload time in seconds
@export var reload_empty_time: float = 4.0

# 后座力 ──────────────────────────────────────────────────
@export_group("后座")
## 每发垂直后座幅度（度）/ Vertical recoil per shot in degrees
@export var recoil_vertical: float = 2.0
## 每发水平后座幅度（度）/ Horizontal recoil per shot in degrees
@export var recoil_horizontal: float = 0.5
## 后座回正速度（度/秒）/ Recoil recovery speed in degrees per second
@export var recoil_recovery_speed: float = 5.0

# 散布 ────────────────────────────────────────────────────
@export_group("散布")
## 腰射散布（度）/ Hip-fire spread in degrees
@export var hipfire_spread: float = 3.0
## 机瞄散布（度）/ ADS spread in degrees
@export var ads_spread: float = 0.1

# 重量 ────────────────────────────────────────────────────
@export_group("重量")
## 武器重量（kg，含空弹匣）/ Weapon weight in kg (with empty magazine)
@export var weight: float = 3.5
## 重量是否影响移动速度 / Whether weight affects movement speed
@export var weight_affects_movement: bool = true

# 视觉效果 ────────────────────────────────────────────────
@export_group("视觉效果")
## 武器 3D 模型场景 / Weapon 3D model scene
@export var weapon_scene: PackedScene
## 武器全长（m），用于顶墙收枪射线检测 / Full weapon length in m, used for obstruction raycast
@export var weapon_length: float = 0.75
## 瞄准时间（秒），从腰射到瞄准的过渡时长 / ADS transition time in seconds
@export var ads_time: float = 0.25
## 瞄准时武器居中偏移（m），相对摄像机中心的偏移量 / Weapon center offset when ADS
@export var ads_center_offset: Vector3 = Vector3(0.0, -0.1, -0.05)
## 瞄准时 FOV 缩放目标值（度），-1 = 使用摄像机默认 / ADS FOV target; -1 = use camera default
@export var ads_fov_override: float = -1.0

# 握持 IK ─────────────────────────────────────────────────
@export_group("握持 IK")
## 左手 IK 强度，0 = 完全用动画，1 = 完全跟随 LeftHandGrip / Left hand IK blend weight
@export_range(0.0, 1.0) var left_hand_ik_weight: float = 1.0

# 配件槽位声明 ────────────────────────────────────────────
@export_group("配件槽位")
## 是否支持瞄具槽 / Whether optic rail is supported
@export var supports_optic: bool = true

## 是否支持枪口装置 / Whether muzzle device is supported
@export var supports_muzzle: bool = true

## 是否支持下挂导轨 / Whether underbarrel rail is supported
@export var supports_underbarrel: bool = true

## 是否支持扩容弹匣 / Whether extended magazine is supported
@export var supports_extended_mag: bool = true

# 武器特征标签 ────────────────────────────────────────────
@export_group("武器特征")
## 弹药口径 / Ammunition caliber
@export var caliber: String = "5.45x39mm"

## 原产国 / Country of origin
@export var origin_country: String = "Russia"

## 时代 / Era
@export var era: String = "Modern"


# ============================================================
# 【未实现 / 待扩展】
# 以下字段是预留的弹药类型配置，后续需要实现弹种切换功能时启用
# ============================================================
# @export var bullet_type: String = "fmj"              # 弹种：fmj（全被甲）/ hp（空尖）/ ap（穿甲）
# @export var bullet_mass: float = 0.0034              # 弹头质量，单位：kg
# @export var ballistic_coefficient: float = 0.3       # 弹道系数（BC），用于远距离弹道下坠计算
