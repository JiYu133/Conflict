class_name AttachmentSlot
extends Marker3D

# ════════════════════════════════════════════════════════════════════════
# 配件挂载点 (AttachmentSlot)
# ════════════════════════════════════════════════════════════════════════
# 作用：标记武器上一个可挂配件的位置（瞄具导轨、枪口螺纹、握把槽等）。
#       同时承担"是否被占用"的逻辑，阻止两个配件装同一位置。
#
# 用法：
#   - 在武器/配件场景里放一个 Marker3D 节点（脚本绑这个类）
#   - 在检查器里用 allowed_attachment_types 多选允许安装的配件类型
#   - 给它一个名字如 "OpticRail"、"MuzzleDevice"
#   - AttachmentManager 会自动找它
#
# 节点关系示例（AK-74M）：
#   Weapon
#   ├── Barrel
#   │   └── Muzzle (AttachmentSlot)  ← 装消音器
#   ├── Receiver
#   │   └── OpticRail (AttachmentSlot)  ← 装瞄具
#   └── Handguard
#       └── Underbarrel (AttachmentSlot)  ← 装握把
# ════════════════════════════════════════════════════════════════════════

# ──────────────────────────── 槽位类型枚举 ────────────────────────────
enum SlotType {
	# ─── 光学 / 瞄具 ───────────────────────────────────────────
	OPTIC_RAIL,        # 顶部瞄具导轨（皮卡汀尼/燕尾）— 瞄具/机械照门
	SIDE_RAIL_LEFT,    # 左侧导轨 — 战术灯/激光
	SIDE_RAIL_RIGHT,   # 右侧导轨

	# ─── 枪口 ─────────────────────────────────────────────────
	MUZZLE,            # 枪口螺纹 — 消焰器/制退器/消音器

	# ─── 下挂 ─────────────────────────────────────────────────
	UNDERBARREL,       # 护木下挂导轨 — 前握把/战术灯

	# ─── 枪管区 ───────────────────────────────────────────────
	BARREL,            # 枪管接口 — 整根枪管总成（含导气管/准星）
	HANDGUARD,         # 护木安装槽 — 护木总成

	# ─── 机匣区 ───────────────────────────────────────────────
	RECEIVER_COVER,    # 机匣盖卡槽 — 防尘盖（含/不含导轨）
	PISTOL_GRIP,       # 握把安装螺孔 — 手枪式握把
	TRIGGER_GROUP,     # 扳机销孔 — 扳机组（纯数值改装为主）
	CHARGING_HANDLE,   # 拉机柄槽 — AR 类/可更换平台

	# ─── 弹药供给 ─────────────────────────────────────────────
	MAGAZINE_WELL,     # 弹匣井 — 弹匣（标准/加长/弹鼓）

	# ─── 枪托 ─────────────────────────────────────────────────
	STOCK_ADAPTER,     # 枪托接口 — 固定/折叠/伸缩枪托

	# ─── 内部可动部件 ──────────────────────────────────────────
	BOLT_CARRIER,      # 枪机框槽 — 枪机框/活塞组（可动，由 WeaponMovingPartsController 驱动）

	# ─── 机匣控制件 ────────────────────────────────────────────
	SELECTOR_SWITCH,   # 快慢机拨片 — 射击模式选择器（有动画，不可卸但可更换样式）
}

# ──────────────────────────── 导出属性 ────────────────────────────
@export var slot_type: SlotType = SlotType.OPTIC_RAIL
## 旧版槽位分类；仅用于 allowed_attachment_types 为空时的兼容映射和握持点评分。

## 允许安装的配件类型；可多选。空列表时按 slot_type 的旧映射兼容。
@export var allowed_attachment_types: Array[AttachmentConfig.AttachmentType] = []

@export var slot_name: String = ""
## 显示名（HUD提示用），如"瞄具导轨"

@export var can_be_empty: bool = true
## 是否可以为空（机械瞄具槽不能为空，要保留后照门）

# ──────────────────────────── 运行时状态 ────────────────────────────
var current_attachment: BaseAttachment = null
## 当前装在此槽位的配件实例（null = 空槽）

var is_occupied: bool:
	## 是否已被占用（便捷属性）
	get:
		return current_attachment != null

# ──────────────────────────── 挂载逻辑 ────────────────────────────
## 尝试挂载一个配件实例（只做状态记录，节点 add_child 由 AttachmentManager 负责）
## 返回 true = 挂载成功；false = 失败（槽位被占或类型不匹配）
func attach(attachment: BaseAttachment) -> bool:
	if is_occupied:
		push_warning("槽位 %s 已被占用" % get_slot_key())
		return false

	if not can_accept_attachment(attachment.config):
		push_warning("配件 %s 不能装在 %s 槽位" % [attachment.config.attachment_name, get_slot_key()])
		return false

	# 前置槽位依赖检查
	if attachment.config.required_slots.size() > 0 and attachment.parent_weapon:
		var am: AttachmentManager = attachment.parent_weapon.attachment_manager
		for req_type in attachment.config.required_slots:
			var satisfied := false
			for sname in am.get_slot_names():
				var slot := am.get_slot(sname)
				if slot and slot.slot_type == req_type and slot.is_occupied:
					satisfied = true
					break
			if not satisfied:
				push_warning("配件 %s 安装失败：缺少前置槽位 %s" % [attachment.config.attachment_name, AttachmentSlot.SlotType.keys()[req_type]])
				return false

	current_attachment = attachment
	GlobalLogger.debug("AttachmentSlot", "%s 已记录配件 %s" % [get_slot_key(), attachment.config.attachment_name])
	return true

## 卸载当前配件（只清状态，节点 remove_child 由 AttachmentManager 负责）
## 返回被卸下的配件实例（调用方负责释放或放回库存）
func detach() -> BaseAttachment:
	if not is_occupied:
		return null

	var att := current_attachment
	current_attachment = null
	GlobalLogger.debug("AttachmentSlot", "%s 已清除配件记录" % get_slot_key())
	return att


## 槽位在 AttachmentManager 中的索引名；优先用 slot_name，否则用场景 Marker3D 节点名。
func get_slot_key() -> String:
	return slot_name if slot_name != "" else String(name)


## 判断一个配件配置是否可以装入本槽。
## 新规则以场景 Marker3D 上的 allowed_attachment_types 为准；留空时兼容旧的 slot_type 映射。
func can_accept_attachment(cfg: AttachmentConfig) -> bool:
	if not allowed_attachment_types.is_empty():
		return allowed_attachment_types.has(cfg.attachment_type)
	return _get_legacy_attachment_types(slot_type).has(cfg.attachment_type)


## 旧版 SlotType 到 AttachmentType 的兼容映射，仅在 allowed_attachment_types 为空时使用。
static func _get_legacy_attachment_types(slot_type: SlotType) -> Array[AttachmentConfig.AttachmentType]:
	match slot_type:
		SlotType.OPTIC_RAIL:
			return [AttachmentConfig.AttachmentType.OPTIC]
		SlotType.SIDE_RAIL_LEFT, SlotType.SIDE_RAIL_RIGHT:
			return [
				AttachmentConfig.AttachmentType.SIDE,
				AttachmentConfig.AttachmentType.TACTICAL_DEVICE,
			]
		SlotType.MUZZLE:
			return [AttachmentConfig.AttachmentType.MUZZLE]
		SlotType.UNDERBARREL:
			return [
				AttachmentConfig.AttachmentType.GRIP,
				AttachmentConfig.AttachmentType.TACTICAL_DEVICE,
			]
		SlotType.BARREL:
			return [AttachmentConfig.AttachmentType.BARREL_ASSEMBLY]
		SlotType.HANDGUARD:
			return [AttachmentConfig.AttachmentType.HANDGUARD]
		SlotType.RECEIVER_COVER:
			return [AttachmentConfig.AttachmentType.RECEIVER_COVER]
		SlotType.PISTOL_GRIP:
			return [AttachmentConfig.AttachmentType.PISTOL_GRIP]
		SlotType.TRIGGER_GROUP:
			return [AttachmentConfig.AttachmentType.TRIGGER]
		SlotType.CHARGING_HANDLE:
			return [AttachmentConfig.AttachmentType.CHARGING_HANDLE]
		SlotType.MAGAZINE_WELL:
			return [AttachmentConfig.AttachmentType.MAGAZINE]
		SlotType.STOCK_ADAPTER:
			return [AttachmentConfig.AttachmentType.STOCK]
		SlotType.BOLT_CARRIER:
			return [AttachmentConfig.AttachmentType.BOLT_CARRIER]
		SlotType.SELECTOR_SWITCH:
			return [AttachmentConfig.AttachmentType.SELECTOR_SWITCH]
	return []
