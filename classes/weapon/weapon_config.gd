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
## Display name shown in weapon UI.
@export var weapon_name: String = "Unnamed Weapon"
## Weapon family identifier used by gameplay systems.
@export var weapon_type: String = "rifle"
## 武器逻辑总开关：关闭时禁用击发/换弹/后座/故障，仅保留模型显示
@export var logic_enabled: bool = false

# 自动原理 ─────────────────────────────────────────────────
@export_group("自动原理")
## Operating action identifier.
@export var action_type: String = "gas_operated"
## Whether the weapon fires from an open bolt.
@export var open_bolt: bool = false
## 理论射速（RPM），实际射速由枪机框循环时间决定
@export var cycle_rate: float = 600.0

# 击发 ────────────────────────────────────────────────────
@export_group("击发")
## 该武器支持的射击模式，按此顺序循环切换（V 键）。
## 可用值：safe（保险）/ semi（半自动）/ burst（点射）/ auto（全自动）。
## 每把枪按真实机械结构填写——只有真正带断续器的枪才该列 burst，
## 栓动/半自动枪就只填 ["safe", "semi"]。
@export var fire_modes: Array[String] = ["safe", "semi", "auto"]
## 一组点射的发数（仅 fire_modes 含 burst 时有意义）。
## AK-12 为 2 发点射；多数西方步枪为 3 发。
@export_range(2, 5) var burst_count: int = 3
## Fire mode selected when first equipped.
@export var default_fire_mode: String = "semi"

# 后座旧字段（兼容）──────────────────────────────────────────
## Deprecated: retained only so older weapon resources remain loadable.
## RecoilPhysicsModel derives recoil from physical receiver/attachment data.
@export_storage var recoil_vertical: float = 2.0
## Legacy horizontal recoil value retained for compatibility.
@export_storage var recoil_horizontal: float = 0.5
## Legacy recoil recovery speed retained for compatibility.
@export_storage var recoil_recovery_speed: float = 5.0
## Legacy pitch kick in degrees retained for compatibility.
@export_storage var kick_pitch_deg: float = 0.8
## Legacy yaw kick in degrees retained for compatibility.
@export_storage var kick_yaw_deg: float = 0.12
## Legacy random yaw kick in degrees retained for compatibility.
@export_storage var kick_yaw_random_deg: float = 0.35

# 散布（机匣基准值）──────────────────────────────────────
@export_group("散布")
## Base hip-fire spread in degrees.
@export var hipfire_spread: float = 3.0
## Base ADS spread in degrees.
@export var ads_spread: float = 0.1

# 重量（机匣自身重量）────────────────────────────────────
@export_group("重量")
## Receiver/weapon mass in kilograms.
@export var weight: float = 3.5
## Whether weapon weight affects movement.
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
## Weapon model scene instantiated for this resource.
@export var weapon_scene: PackedScene
## 开火表现配置（抛壳 / 枪口焰 / 枪口光照）。
## 留空则使用 WeaponFXConfig 默认值：抛壳照常工作（占位模型），
## 枪口焰因无素材而静默跳过，待美术补上贴图后填入 .tres 即可。
@export var fx_config: WeaponFXConfig
## Overall weapon length in metres, used by presentation systems.
@export var weapon_length: float = 0.75
## Time to complete ADS transition, in seconds.
@export var ads_time: float = 0.25
## Camera offset while aiming down sights.
@export var ads_center_offset: Vector3 = Vector3(0.0, -0.1, -0.05)
## Optional ADS FOV override; negative keeps the default.
@export var ads_fov_override: float = -1.0

# 掉落物理 ─────────────────────────────────────────────────
@export_group("掉落物理")
## 死亡脱手时交给 RigidBody3D 使用的预制碰撞形状；为空时保持原挂载状态。
@export var dropped_collision_shape: Shape3D
## 碰撞形状相对武器根节点的局部偏移。
@export var dropped_collision_offset: Vector3 = Vector3.ZERO

# 握持 IK ─────────────────────────────────────────────────
@export_group("握持 IK")
## 持枪姿态修正角（欧拉角，度）。武器默认按自身 RightHandGrip 标记对齐到右手骨骼；
## 若美术摆放握把 Marker 的轴向与骨骼约定不一致（枪身侧倒/上下颠倒），在此修正。
## 通常只需调 Z（枪身滚转）或 X（枪口俯仰）。
@export var grip_alignment_offset: Vector3 = Vector3.ZERO
## Left-hand IK influence while holding this weapon.
@export_range(0.0, 1.0) var left_hand_ik_weight: float = 1.0

# 配件槽位声明 ────────────────────────────────────────────
@export_group("配件槽位")
## 旧版槽位声明：运行时不再读取；场景内的 AttachmentSlot Marker3D 才是槽位来源。
@export var supported_slots: Array[AttachmentSlot.SlotType] = []

# 预设配件 ────────────────────────────────────────────────
@export_group("预设配件")
## 旧版显式槽位名列表；留空时按 default_attachment_configs 顺序自动匹配可用槽位。
@export var default_attachment_slots: Array[String] = []
## 出生时按顺序自动装配的配件列表；父配件应先于其子槽上的配件。
@export var default_attachment_configs: Array[AttachmentConfig] = []

# 武器特征标签 ────────────────────────────────────────────
@export_group("武器特征")
## Country associated with the weapon.
@export var origin_country: String = "Russia"
## Approximate era or generation label.
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
	## 已弃用：槽位来源已改为场景 Marker3D，保留此方法仅为兼容旧调用方。
	return supported_slots
