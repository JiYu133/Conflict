class_name AttachmentSlot
extends Node3D

# ════════════════════════════════════════════════════════════════════════
# 配件挂载点 (AttachmentSlot)
# ════════════════════════════════════════════════════════════════════════
# 作用：标记武器上一个可挂配件的位置（瞄具导轨、枪口螺纹、握把槽等）。
#       同时承担"是否被占用"的逻辑，阻止两个配件装同一位置。
#
# 用法：
#   - 在武器场景里放一个 Node3D 节点（脚本绑这个类）
#   - 设置 slot_type 属性为对应类型
#   - 给它一个名字如 "OpticRail"、"Muzzle"
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
	OPTIC_RAIL,    # 顶部瞄具导轨（皮卡汀尼/燕尾）
	MUZZLE,        # 枪口螺纹
	UNDERBARREL,   # 下挂导轨（前握把/榴弹发射器）
	MAGAZINE_WELL, # 弹匣井
	SIDE_RAIL      # 侧导轨
}

# ──────────────────────────── 导出属性 ────────────────────────────
@export var slot_type: SlotType = SlotType.OPTIC_RAIL
## 当前槽位类型，决定能装什么配件

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
## 尝试挂载一个配件实例
## 返回 true = 挂载成功；false = 失败（槽位被占或类型不匹配）
func attach(attachment: BaseAttachment) -> bool:
	# 检查槽位是否已被占用
	if is_occupied:
		push_warning("槽位 %s 已被占用" % slot_name)
		return false

	# 检查配件类型是否匹配
	if attachment.config.allowed_slot != slot_type:
		push_warning("配件 %s 不能装在 %s 槽位" % [attachment.config.attachment_name, slot_name])
		return false

	# 挂载
	current_attachment = attachment
	add_child(attachment)
	attachment.global_transform = global_transform
	print("[Slot] %s 已挂载 %s" % [slot_name, attachment.config.attachment_name])
	return true

## 卸载当前配件
## 返回被卸下的配件实例（调用方负责释放或放回库存）
func detach() -> BaseAttachment:
	if not is_occupied:
		return null

	var att = current_attachment
	att.get_parent().remove_child(att)
	current_attachment = null
	print("[Slot] %s 已卸载" % slot_name)
	return att
