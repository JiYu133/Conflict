class_name AttachmentManager
extends Node

# ════════════════════════════════════════════════════════════════════════
# 配件管理器 (AttachmentManager)
# ════════════════════════════════════════════════════════════════════════
# 作用：一把武器上挂一个 AttachmentManager，它负责：
#   1. 扫描武器场景里所有的 AttachmentSlot（挂载点）
#   2. 接受玩家的装备/卸载请求
#   3. 汇总所有配件的数值修正，反馈给武器
#
# 数值汇总方式：
#   武器实际值 = 武器基础值 + Σ 所有当前配件的修正
#
# 装备流程（外部调用）：
#   var att = AttachmentFactory.create(red_dot_config)
#   weapon.attachment_manager.equip_to_slot(att, "OpticRail")
# ════════════════════════════════════════════════════════════════════════

# ──────────────────────────── 信号 ────────────────────────────
signal attachment_equipped(slot: AttachmentSlot, attachment: BaseAttachment)
## 配件已装备（HUD/音效可监听）

signal attachment_detached(slot: AttachmentSlot, attachment: BaseAttachment)
## 配件已卸下

signal attachments_changed()
## 配件配置有变（用于触发数值重算）

# ──────────────────────────── 引用 ────────────────────────────
var parent_weapon: BaseWeapon
## 所属武器

var _slots: Dictionary = {}
## 所有挂载点字典：{slot_name: AttachmentSlot}

# ──────────────────────────── 初始化 ────────────────────────────
## 由 BaseWeapon 在初始化时调用
## 入参：武器自身的 Node 根，用于扫描所有 AttachmentSlot 子节点
func initialize(weapon: BaseWeapon, weapon_root: Node) -> void:
	parent_weapon = weapon
	_scan_slots(weapon_root)
	print("[AttachmentMgr] 找到 %d 个挂载点" % _slots.size())

## 递归扫描所有 AttachmentSlot 类型的子节点
func _scan_slots(root: Node) -> void:
	for child in root.get_children():
		if child is AttachmentSlot:
			# 用 slot_name 或节点名作为 key
			var key = child.slot_name if child.slot_name != "" else child.name
			# 重名挂载点：保留先扫描到者（确定性），告警提示后者被忽略
			if _slots.has(key):
				push_warning("[AttachmentMgr] 挂载点名称重复，已忽略后者: %s" % key)
			else:
				_slots[key] = child
		# 递归扫描子节点
		if child.get_child_count() > 0:
			_scan_slots(child)

# ──────────────────────────── 公开接口 ────────────────────────────
## 把一个配件装到指定名字的槽位
## 返回 true = 成功；false = 失败（槽位不存在/被占/类型不符）
func equip_to_slot(attachment: BaseAttachment, slot_name: String) -> bool:
	if not _slots.has(slot_name):
		push_error("找不到挂载点: %s" % slot_name)
		return false

	var slot: AttachmentSlot = _slots[slot_name]
	var ok = slot.attach(attachment)
	if ok:
		attachment.parent_weapon = parent_weapon
		attachment_equipped.emit(slot, attachment)
		attachments_changed.emit()
	return ok

## 从指定名字的槽位卸下配件
## 返回被卸下的配件（调用方决定删除/放回库存）
func detach_from_slot(slot_name: String) -> BaseAttachment:
	if not _slots.has(slot_name):
		return null

	var slot: AttachmentSlot = _slots[slot_name]
	var att = slot.detach()
	if att:
		attachment_detached.emit(slot, att)
		attachments_changed.emit()
	return att

## 获取指定名字的挂载点
func get_slot(slot_name: String) -> AttachmentSlot:
	return _slots.get(slot_name, null)

## 获取所有已装备的配件（用于数值汇总）
func get_all_attachments() -> Array[BaseAttachment]:
	var result: Array[BaseAttachment] = []
	for slot in _slots.values():
		if slot.is_occupied:
			result.append(slot.current_attachment)
	return result

## 获取指定槽位的当前配件
func get_attachment_in_slot(slot_name: String) -> BaseAttachment:
	var slot = get_slot(slot_name)
	if slot and slot.is_occupied:
		return slot.current_attachment
	return null

# ──────────────────────────── 数值汇总（武器每帧调用） ────────────────────────────
## 计算散布修正总和（结合机瞄/腰射）
## 入参：is_ads = true 表示机瞄状态
func get_total_spread_modifier(is_ads: bool) -> float:
	var total = 0.0
	for att in get_all_attachments():
		total += att.get_spread_modifier(is_ads)
	return total

## 计算垂直后座修正总和
func get_total_recoil_vertical_modifier() -> float:
	var total = 0.0
	for att in get_all_attachments():
		total += att.get_recoil_vertical_modifier()
	return total

## 计算水平后座修正总和
func get_total_recoil_horizontal_modifier() -> float:
	var total = 0.0
	for att in get_all_attachments():
		total += att.get_recoil_horizontal_modifier()
	return total

## 计算后座回正速度修正
func get_total_recoil_recovery_modifier() -> float:
	var total = 0.0
	for att in get_all_attachments():
		total += att.get_recoil_recovery_modifier()
	return total

## 计算瞄准速度修正
func get_total_ads_speed_modifier() -> float:
	var total = 0.0
	for att in get_all_attachments():
		total += att.get_ads_speed_modifier()
	return total

## 计算配件总重量
func get_total_attachment_weight() -> float:
	var total = 0.0
	for att in get_all_attachments():
		total += att.get_weight()
	return total

## 是否抑制枪口火光
func suppresses_muzzle_flash() -> bool:
	for att in get_all_attachments():
		if att.suppresses_muzzle_flash():
			return true
	return false

## 是否抑制枪声
func suppresses_sound() -> bool:
	for att in get_all_attachments():
		if att.suppresses_sound():
			return true
	return false

## 获取当前瞄具的放大倍率（无瞄具 = 1.0）
func get_magnification() -> float:
	var mag = 1.0
	for att in get_all_attachments():
		if att is OpticAttachment:
			mag = max(mag, att.get_magnification())
	return mag

## 获取已装备弹匣附件的额外容量总和
## （AmmoComponent 用它在 initialize 后调整弹匣大小）
func get_total_magazine_capacity_bonus() -> int:
	var total = 0
	for att in get_all_attachments():
		if att is ExtendedMagAttachment:
			total += att.get_extra_capacity()
	return total

## 获取当前瞄具的FOV覆盖
func get_fov_override() -> float:
	var fov = -1.0
	for att in get_all_attachments():
		if att is OpticAttachment:
			var att_fov = att.get_fov_override()
			if att_fov > 0:
				fov = att_fov
	return fov
