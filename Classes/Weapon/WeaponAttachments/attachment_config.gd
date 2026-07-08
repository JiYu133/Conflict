class_name AttachmentConfig
extends Resource

# ════════════════════════════════════════════════════════════════════════
# 配件配置资源 (AttachmentConfig)
# ════════════════════════════════════════════════════════════════════════
# 作用：作为配件的"数据档案"，保存一种配件的全部参数。
#       在 Godot 编辑器里创建 .tres 资源，填好数值，就能被任意武器加载。
#
# 使用流程：
#   1. 在 Godot 编辑器中 FileSystem 右键 → New Resource → AttachmentConfig
#   2. 填入瞄具/握把/枪口 等具体参数
#   3. 武器的 AttachmentManager 加载它，自动影响武器数值
#
# 设计原则：
#   - 一个 .tres 文件 = 一种配件（红点/全息/ACOG/前握把...）
#   - 数值修正采用"百分比"或"绝对值"修正，便于叠加
#   - 模型场景用 PackedScene 引用，方便自定义外观
# ════════════════════════════════════════════════════════════════════════

# ──────────────────────────── 基础信息 ────────────────────────────
@export_group("基础信息")
## 配件显示名（例："Trijicon TA31 ACOG 4x32"）/ Attachment display name
@export var attachment_name: String = "Unnamed Attachment"

## 配件类型，决定能装到哪个槽位 / Attachment type, determines which slot it fits
@export var attachment_type: AttachmentType = AttachmentType.OPTIC

# ──────────────────────────── 槽位约束 ────────────────────────────
@export_group("槽位约束")
## 允许装入的挂载点类型 / Allowed slot type for this attachment
@export var allowed_slot: AttachmentSlot.SlotType = AttachmentSlot.SlotType.OPTIC_RAIL

## 是否需要先有某个配件 / Whether a prerequisite attachment is required
@export var requires_existing_attachment: bool = false

# ──────────────────────────── 数值修正 ────────────────────────────
@export_group("散布修正")
## 腰射散布修正：负值 = 减少散布 / Hip-fire spread modifier; negative = tighter
@export var hipfire_spread_modifier: float = 0.0

## 机瞄散布修正：负值 = 减少散布 / ADS spread modifier; negative = tighter
@export var ads_spread_modifier: float = 0.0

# ──────────────────────────── 后座修正 ────────────────────────────
@export_group("后座修正")
## 垂直后座修正：负值 = 减少上跳 / Vertical recoil modifier; negative = less climb
@export var recoil_vertical_modifier: float = 0.0

## 水平后座修正：负值 = 减少左右偏移 / Horizontal recoil modifier; negative = less drift
@export var recoil_horizontal_modifier: float = 0.0

## 后座回正速度修正：正值 = 更快回正 / Recoil recovery speed modifier; positive = faster
@export var recoil_recovery_modifier: float = 0.0

# ──────────────────────────── 重量与机动 ────────────────────────────
@export_group("重量与机动")
## 配件重量（kg），叠加到武器总重量 / Attachment weight in kg, added to weapon total
@export var weight_kg: float = 0.1

## 瞄准速度修正：正值 = 更快瞄准 / ADS speed modifier; positive = faster aim
@export var ads_speed_modifier: float = 0.0

# ──────────────────────────── 视野与光学 ────────────────────────────
@export_group("视野与光学")
## 放大倍率，1.0 = 无放大 / Magnification; 1.0 = no zoom
@export var magnification: float = 1.0

## 强制 FOV（-1 = 沿用摄像机 FOV）/ Forced FOV (-1 = use camera default)
@export var fov_override: float = -1.0

## 是否有准星图案 / Whether this optic has a reticle
@export var has_reticle: bool = true

## 准星颜色 / Reticle color
@export var reticle_color: Color = Color(1, 0, 0)

# ──────────────────────────── 特殊效果 ────────────────────────────
@export_group("特殊效果")
## 是否抑制枪口火光 / Whether muzzle flash is suppressed
@export var suppresses_flash: bool = false

## 是否抑制枪声 / Whether gunshot sound is suppressed
@export var suppresses_sound: bool = false

## 枪口长度修正（m），消音器填正值 / Muzzle length modifier in m; positive for suppressors
@export var length_modifier: float = 0.0

## 伤害修正，消音器亚音速弹可能为负 / Damage modifier; subsonic suppressors may be negative
@export var damage_modifier: float = 0.0

# ──────────────────────────── 视觉 ────────────────────────────
@export_group("视觉")
## 配件 3D 模型场景 / Attachment 3D model scene
@export var attachment_scene: PackedScene

## 挂在武器哪个 Marker3D 节点下 / Marker3D node name on the weapon to attach to
@export var mount_point_name: String = ""

# ════════════════════════════════════════════════════════════════════════
# 枚举类型定义
# ════════════════════════════════════════════════════════════════════════

## 配件大类
enum AttachmentType {
	OPTIC,      # 瞄具
	GRIP,       # 握把
	MUZZLE,     # 枪口
	MAGAZINE,   # 弹匣
	SIDE        # 侧挂
}
