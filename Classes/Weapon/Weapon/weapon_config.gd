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
@export var weapon_name: String = "Unnamed Weapon"    # 武器显示名称
@export var weapon_type: String = "rifle"             # 武器种类标识（rifle / smg / shotgun / pistol 等）

# 自动原理 ─────────────────────────────────────────────────
@export_group("自动原理")
@export var action_type: String = "gas_operated"
## 自动方式：gas_operated（导气式）/ blowback（自由枪机）/ bolt_action（旋转后拉）/ manual（栓动无自动）
@export var open_bolt: bool = false
## true = 开膛待击（如 MG42），false = 闭膛待击（如 M4A1）
@export var cycle_rate: float = 600.0
## 理论射速，单位：发/分钟（RPM）。注意这是理论值，实际射速受枪机循环时间制约
@export var bolt_mass: float = 0.3
## 枪机组质量，单位：kg。质量越大，后座开锁速度越慢，循环周期越长
@export var recoil_spring_strength: float = 50.0
## 复进簧刚度，单位：N/m。影响枪机复进速度和闭锁可靠性

# 枪管 ────────────────────────────────────────────────────
@export_group("枪管")
@export var barrel_length: float = 0.415
## 枪管长度，单位：m。影响导气延时和弹头初速
@export var muzzle_velocity: float = 900.0
## 初速，单位：m/s。弹头飞出枪口时的速度，也用于计算导气孔延时

# 弹药 ────────────────────────────────────────────────────
@export_group("弹药")
@export var magazine_capacity: int = 30
## 单弹匣容量
@export var magazine_type: String = "detachable_box"
## 弹匣类型：detachable_box（可拆卸弹匣）/ integral（内置弹仓）/ belt（弹链）/ tube（管状弹仓）
@export var has_last_round_hold_open: bool = true
## 是否支持空仓挂机（打空最后一发后枪机自动停留在后方）
@export var reserve_magazines: int = 4
## 携带的备用弹匣数量（不含枪上在用的那个）

# 击发 ────────────────────────────────────────────────────
@export_group("击发")
@export var fire_modes: Array[String] = ["safe", "semi", "auto"]
## 可选射击模式列表，按罗盘顺序排列。通常：safe（保险）→ semi（单发）→ auto（连发）/ burst（三发点射）
@export var default_fire_mode: String = "semi"
## 武器出生时的默认射击模式

# 换弹 ────────────────────────────────────────────────────
@export_group("换弹")
@export var reload_time: float = 2.5
## 战术换弹时间，单位：s。膛内有弹时只换弹匣
@export var reload_empty_time: float = 4.0
## 空仓换弹时间，单位：s。膛内无弹时需要换弹匣+释放枪机+推弹入膛

# 后座力 ──────────────────────────────────────────────────
@export_group("后座")
@export var recoil_vertical: float = 2.0
## 每发子弹的垂直后座幅度，单位：度
@export var recoil_horizontal: float = 0.5
## 每发子弹的水平后座幅度，单位：度（左右随机方向）
@export var recoil_recovery_speed: float = 5.0
## 后座回正速度，单位：度/秒。控枪越稳这个值越高

# 散布 ────────────────────────────────────────────────────
@export_group("散布")
@export var hipfire_spread: float = 3.0
## 腰射散布，单位：度。不瞄准时子弹随机分布在以准星为中心的圆形区域内
@export var ads_spread: float = 0.1
## 机瞄散布，单位：度。瞄准时精度显著提升

# 重量 ────────────────────────────────────────────────────
@export_group("重量")
@export var weight: float = 3.5
## 武器重量，单位：kg（含空弹匣）
@export var weight_affects_movement: bool = true
## 重量是否影响玩家移动速度

# 视觉效果 ────────────────────────────────────────────────
@export_group("视觉效果")
@export var weapon_scene: PackedScene
## 武器 3D 模型场景，需要包含 AnimationPlayer 和必要的挂载点

# 配件槽位声明 ────────────────────────────────────────────
@export_group("配件槽位")
@export var supports_optic: bool = true
## 是否支持瞄具槽（皮卡汀尼/燕尾）

@export var supports_muzzle: bool = true
## 是否支持枪口装置（螺纹/快拆）

@export var supports_underbarrel: bool = true
## 是否支持下挂导轨（前握把/榴弹）

@export var supports_extended_mag: bool = true
## 是否支持扩容弹匣

# 武器特征标签 ────────────────────────────────────────────
@export_group("武器特征")
@export var caliber: String = "5.45x39mm"
## 弹药口径（俄制5.45x39 / 西制5.56x45 / 7.62x39 / 9x18mm / 火箭弹）

@export var origin_country: String = "Russia"
## 原产国（Russia / USA / Belgium / etc.）

@export var era: String = "Modern"
## 时代（"Cold War" / "Modern" / "Modernized"）


# ============================================================
# 【未实现 / 待扩展】
# 以下字段是预留的弹药类型配置，后续需要实现弹种切换功能时启用
# ============================================================
# @export var bullet_type: String = "fmj"              # 弹种：fmj（全被甲）/ hp（空尖）/ ap（穿甲）
# @export var bullet_mass: float = 0.0034              # 弹头质量，单位：kg
# @export var ballistic_coefficient: float = 0.3       # 弹道系数（BC），用于远距离弹道下坠计算
