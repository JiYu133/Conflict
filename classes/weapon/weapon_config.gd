class_name WeaponConfig
extends Resource

# ============================================================
# 武器配置资源（机匣固有属性）
#
# 只保存机匣本身的参数。以下属性已迁移到对应配件子类：
#   barrel_length / muzzle_velocity / bullet_mass_g /
#   ballistic_coefficient / caliber / misfire_chance
#     → BarrelConfig（classes/weapon/weaponattachments/barrel_config.gd）
#
#   bolt_mass / recoil_spring_strength / bolt_travel_m /
#   stovepipe_chance / double_feed_chance
#     → BoltCarrierConfig（bolt_carrier_config.gd）
#
#   magazine_capacity / magazine_type / has_last_round_hold_open /
#   reserve_magazines / reload_time / reload_empty_time
#     → MagazineConfig（magazine_config.gd）
# ============================================================

# 基础属性 ─────────────────────────────────────────────────
@export_group("基础属性")
@export var weapon_name: String = "Unnamed Weapon"
@export var weapon_type: String = "rifle"
## 武器逻辑总开关：关闭时禁用击发/换弹/后座/故障，仅保留模型显示
@export var logic_enabled: bool = false

# 自动原理 ─────────────────────────────────────────────────
@export_group("自动原理")
@export var action_type: String = "gas_operated"
@export var open_bolt: bool = false
## 理论射速（RPM），实际射速由枪机框循环时间决定
@export var cycle_rate: float = 600.0

# 击发 ────────────────────────────────────────────────────
@export_group("击发")
@export var fire_modes: Array[String] = ["safe", "semi", "auto"]
@export var default_fire_mode: String = "semi"

# 后座力（机匣基准值，配件修正叠加在此之上）────────────────
@export_group("后座")
@export var recoil_vertical: float = 2.0
@export var recoil_horizontal: float = 0.5
@export var recoil_recovery_speed: float = 5.0
@export var kick_pitch_deg: float = 0.8
@export var kick_yaw_deg: float = 0.12
@export var kick_yaw_random_deg: float = 0.35

# 散布（机匣基准值）──────────────────────────────────────
@export_group("散布")
@export var hipfire_spread: float = 3.0
@export var ads_spread: float = 0.1

# 重量（机匣自身重量）────────────────────────────────────
@export_group("重量")
@export var weight: float = 3.5
@export var weight_affects_movement: bool = true

# 后座物理 ----------------------------------------
@export_group("后座物理")
## 机匣本体质量，不含可换配件；用于总质量和转动惯量
@export var receiver_mass_kg: float = 2.2
## 机匣质心相对武器原点偏移（m）
@export var receiver_com_local: Vector3 = Vector3.ZERO
## 枪膛/枪管轴线参考点（武器局部坐标）
@export var bore_point_local: Vector3 = Vector3(0, 0.06, -0.35)
## 枪管轴线相对肩部接触点的高度（m），决定俯仰力矩臂
@export var bore_axis_height_m: float = 0.06
## 肩部接触点（武器局部坐标），后座绕此点旋转
@export var shoulder_pivot_local: Vector3 = Vector3(0, -0.04, 0.35)
## 射手基础控枪刚度（N·m/rad）
@export var recoil_control_stiffness: float = 120.0
## 射手基础控枪阻尼（N·m·s/rad）
@export var recoil_control_damping: float = 18.0
## 射手扰动产生的随机冲量比例，用于每发横向/纵向噪声
@export_range(0.0, 0.2, 0.001) var shooter_impulse_noise: float = 0.03

# 视觉效果 ────────────────────────────────────────────────
@export_group("视觉效果")
@export var weapon_scene: PackedScene
@export var weapon_length: float = 0.75
@export var ads_time: float = 0.25
@export var ads_center_offset: Vector3 = Vector3(0.0, -0.1, -0.05)
@export var ads_fov_override: float = -1.0

# 握持 IK ─────────────────────────────────────────────────
@export_group("握持 IK")
@export_range(0.0, 1.0) var left_hand_ik_weight: float = 1.0

# 配件槽位声明 ────────────────────────────────────────────
@export_group("配件槽位")
@export var supported_slots: Array[AttachmentSlot.SlotType] = []

# 预设配件 ────────────────────────────────────────────────
@export_group("预设配件")
## 出生时自动装上的槽位名列表，与 default_attachment_configs 一一对应
@export var default_attachment_slots: Array[String] = []
## 出生时自动装上的配件配置列表，与 default_attachment_slots 一一对应
@export var default_attachment_configs: Array[AttachmentConfig] = []

# 武器特征标签 ────────────────────────────────────────────
@export_group("武器特征")
@export var origin_country: String = "Russia"
@export var era: String = "Modern"

# 弹道学 ──────────────────────────────────────────────────
@export_group("弹道学")
## 启用弹道模拟（飞行时间 + 重力下坠 + 空气阻力）
## 关闭时回退为瞬时 hitscan，便于 A/B 对比调参
@export var use_ballistic_simulation: bool = true


# ============================================================
# 改装系统辅助
# ============================================================

func get_allowed_slot_types() -> Array[AttachmentSlot.SlotType]:
	return supported_slots
