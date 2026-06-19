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
@export var attachment_name: String = "Unnamed Attachment"
## 配件显示名（例："Trijicon TA31 ACOG 4x32"）

@export var attachment_type: AttachmentType = AttachmentType.OPTIC
## 配件类型，决定能装到哪个槽位

# ──────────────────────────── 槽位约束 ────────────────────────────
@export_group("槽位约束")
@export var allowed_slot: AttachmentSlot.SlotType = AttachmentSlot.SlotType.OPTIC_RAIL
## 允许装入的挂载点类型。瞄具只能装瞄具槽，握把只能装握把槽

@export var requires_existing_attachment: bool = false
## 是否需要先有某个配件（例如：消音器可装在枪口；某些瞄具需要先拆除机械瞄具）

# ──────────────────────────── 数值修正 ────────────────────────────
@export_group("散布修正")
@export var hipfire_spread_modifier: float = 0.0
## 腰射散布修正：负值 = 减少散布（更准）。例：红点 -0.5°

@export var ads_spread_modifier: float = 0.0
## 机瞄散布修正：负值 = 减少散布。例：ACOG -0.05°

# ──────────────────────────── 后座修正 ────────────────────────────
@export_group("后座修正")
@export var recoil_vertical_modifier: float = 0.0
## 垂直后座修正：负值 = 减少上跳。例：垂直握把 -0.3°

@export var recoil_horizontal_modifier: float = 0.0
## 水平后座修正：负值 = 减少左右偏移

@export var recoil_recovery_modifier: float = 0.0
## 后座回正速度修正：正值 = 更快回正。例：握把 +1.0°/s

# ──────────────────────────── 重量与机动 ────────────────────────────
@export_group("重量与机动")
@export var weight_kg: float = 0.1
## 配件重量（kg），叠加到武器总重量上影响移动速度

@export var ads_speed_modifier: float = 0.0
## 瞄准速度修正：正值 = 更快的瞄准。例：红点 +0.3

# ──────────────────────────── 视野与光学 ────────────────────────────
@export_group("视野与光学")
@export var magnification: float = 1.0
## 放大倍率。1.0=无放大，4.0=ACOG 4x

@export var fov_override: float = -1.0
## 强制FOV（-1表示沿用摄像机FOV）。狙击镜会缩小FOV模拟远距离

@export var has_reticle: bool = true
## 是否有准星图案（机械瞄具无，瞄具有）

@export var reticle_color: Color = Color(1, 0, 0)
## 准星颜色（红点常用红/橙，全息常用红）

# ──────────────────────────── 特殊效果 ────────────────────────────
@export_group("特殊效果")
@export var suppresses_flash: bool = false
## 是否抑制枪口火光（消音器特有）

@export var suppresses_sound: bool = false
## 是否抑制枪声（消音器特有）

@export var damage_modifier: float = 0.0
## 伤害修正：消音器亚音速弹可能 -10%

# ──────────────────────────── 视觉 ────────────────────────────
@export_group("视觉")
@export var attachment_scene: PackedScene
## 配件 3D 模型场景，挂在武器的指定 Marker3D 上

@export var mount_point_name: String = ""
## 挂在武器哪个 Marker3D 节点下（例："OpticMount"、"MuzzleMount"）
## 留空则使用挂载点的默认位置

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
