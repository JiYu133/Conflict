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
## 旧版单值槽位约束，仅保留兼容；运行时校验以场景 Marker3D 的 allowed_attachment_types 为准。
@export var allowed_slot: AttachmentSlot.SlotType = AttachmentSlot.SlotType.OPTIC_RAIL

## 安装此配件前必须已装的槽位类型列表（空 = 无前置依赖）
## 例：瞄具需要机匣盖上的导轨，填 [SlotType.RECEIVER_COVER] 表示必须先装机匣盖
## AttachmentSlot.attach() 会检查此约束，不满足时拒绝安装
@export var required_slots: Array[AttachmentSlot.SlotType] = []

# ──────────────────────────── 安装位置 ────────────────────────────
@export_group("安装位置")
## 自动装配时优先尝试的槽位名，按顺序回退；如 ["SideRailLeft", "SideRailRight"]
@export var preferred_slot_names: Array[String] = []

# ──────────────────────────── 数值修正 ────────────────────────────
@export_group("散布修正")
## 腰射散布修正：负值 = 减少散布 / Hip-fire spread modifier; negative = tighter
@export var hipfire_spread_modifier: float = 0.0

## 机瞄散布修正：负值 = 减少散布 / ADS spread modifier; negative = tighter
@export var ads_spread_modifier: float = 0.0

# 后座旧字段（兼容）──────────────────────────────────────────
## Deprecated: kept only so older .tres resources remain loadable.
## RecoilPhysicsModel never reads these angle/recovery modifiers.
@export_storage var recoil_vertical_modifier: float = 0.0
@export_storage var recoil_horizontal_modifier: float = 0.0
@export_storage var recoil_recovery_modifier: float = 0.0

# ──────────────────────────── 重量与机动 ────────────────────────────
@export_group("重量与机动")
## 配件重量（kg），叠加到武器总重量 / Attachment weight in kg, added to weapon total
@export var weight_kg: float = 0.1
## 配件局部质心偏移，默认在挂载点中心
@export var center_of_mass_local: Vector3 = Vector3.ZERO

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

## 旧版单值安装点；preferred_slot_names 为空时使用它 / Legacy single mount point
@export var mount_point_name: String = ""

## true = 纯数值配件，不生成任何 3D 节点（扳机组、弹簧等纯参数配件适用）
@export var no_visual: bool = false

# ── 导轨位置调整 ────────────────────────────────────────────────
## 配件可否沿导轨（Z轴）滑动调整位置（瞄具/战术灯等导轨安装配件设为 true）
@export var rail_adjustable: bool = false
## 当前沿导轨方向的偏移（m），正值朝后（靠近射手），负值朝前（靠近枪口）
@export var rail_offset: float = 0.0
## 允许的最小偏移（m），防止滑出导轨前端
@export var rail_offset_min: float = -0.05
## 允许的最大偏移（m），防止滑出导轨后端
@export var rail_offset_max: float = 0.05

## 返回自动装配时应优先尝试的槽位名。
## 新字段 preferred_slot_names 优先；旧字段 mount_point_name 作为单值兼容。
func get_preferred_slot_names() -> Array[String]:
	var result: Array[String] = []
	for slot_name in preferred_slot_names:
		if slot_name != "":
			result.append(slot_name)
	if not result.is_empty():
		return result
	if mount_point_name != "":
		return [mount_point_name]
	return []

# ════════════════════════════════════════════════════════════════════════
# 枚举类型定义
# ════════════════════════════════════════════════════════════════════════

## 配件大类
enum AttachmentType {
	OPTIC,           # 瞄具（机械/红点/全息/ACOG/高倍）
	MUZZLE,          # 枪口装置（消焰/制退/消音）
	GRIP,            # 前握把（垂直/斜角/手挡）
	MAGAZINE,        # 弹匣
	BARREL_ASSEMBLY, # 枪管总成（含导气管、准星、枪口螺纹段）
	HANDGUARD,       # 护木
	STOCK,           # 枪托
	PISTOL_GRIP,     # 手枪握把
	RECEIVER_COVER,  # 机匣盖
	TRIGGER,         # 扳机组（纯数值为主）
	CHARGING_HANDLE, # 拉机柄
	TACTICAL_DEVICE, # 战术灯/激光
	SIDE,            # 侧挂（泛用）
	RECEIVER,        # 机匣（组装基础，根节点是 BaseWeapon）
	BOLT_CARRIER,    # 枪机框（可动部件，由 WeaponMovingPartsController 驱动）
	SELECTOR_SWITCH, # 快慢机拨片（有动画，驱动方式同枪机框）
}
