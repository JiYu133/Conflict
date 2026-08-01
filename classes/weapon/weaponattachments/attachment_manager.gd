class_name AttachmentManager
extends Node

# ════════════════════════════════════════════════════════════════════════
# 配件管理器 (AttachmentManager)
# ════════════════════════════════════════════════════════════════════════
# 作用：一把武器上挂一个 AttachmentManager，它负责：
#   1. 扫描武器场景里所有的 AttachmentSlot
#   2. 接受玩家的装备/卸载请求，管理配件节点的场景树归属
#   3. 汇总所有配件的数值修正，缓存结果以避免重复遍历
#
# 对齐方式：
#   AttachmentSlot 本身就是 Node3D，在武器/配件场景里放置到接口位置。
#   配件作为 AttachmentSlot 的子节点挂载，transform = IDENTITY 即贴合接口。
#
# 层级槽位：
#   配件自身可以在其 .tscn 场景里包含子 AttachmentSlot（如机匣盖带导轨槽）。
#   装上配件时自动扫描并注册这些新槽；卸下时自动清理。
# ════════════════════════════════════════════════════════════════════════

signal attachment_equipped(slot: AttachmentSlot, attachment: BaseAttachment)
signal attachment_detached(slot: AttachmentSlot, attachment: BaseAttachment)
signal attachments_changed()

## 配件场景里标记装配面的 Marker3D 节点名，存在时用它对准槽位
const SNAP_POINT_NAME := "SnapPoint"
## 记录导轨配件对齐后、未叠加 rail_offset 时的基准 Z，供滑动条重复调整
const META_RAIL_BASE_Z := "_rail_base_z"

var parent_weapon: BaseWeapon
var _slots: Dictionary = {}  # {String: AttachmentSlot}

# 数值缓存（attachments_changed 时重建）
var _cache_spread_ads: float = 0.0
var _cache_spread_hip: float = 0.0
var _cache_recoil_v: float = 0.0
var _cache_recoil_h: float = 0.0
var _cache_recoil_recovery: float = 0.0
var _cache_ads_speed: float = 0.0
var _cache_weight: float = 0.0
var _cache_length: float = 0.0
var _cache_mag_bonus: int = 0
var _cache_suppresses_flash: bool = false
var _cache_suppresses_sound: bool = false
var _cache_magnification: float = 1.0
var _cache_fov: float = -1.0


# ──────────────────────────── 初始化 ────────────────────────────

func initialize(weapon: BaseWeapon, weapon_root: Node) -> void:
	parent_weapon = weapon
	_scan_slots(weapon_root)
	attachments_changed.connect(_rebuild_cache)
	GlobalLogger.debug("AttachmentMgr", "找到 %d 个挂载点" % _slots.size())


func _scan_slots(root: Node) -> void:
	for child in root.get_children():
		if child is AttachmentSlot:
			var key: String = child.slot_name if child.slot_name != "" else String(child.name)
			if _slots.has(key):
				push_warning("[AttachmentMgr] 挂载点名称重复，已忽略后者: %s" % key)
			else:
				_slots[key] = child
		if child.get_child_count() > 0:
			_scan_slots(child)


# ──────────────────────────── 公开接口 ────────────────────────────

func get_slot_names() -> Array[String]:
	var names: Array[String] = []
	for k in _slots:
		names.append(k as String)
	return names

## 把配件装到指定槽位
func equip_to_slot(attachment: BaseAttachment, slot_name: String) -> bool:
	if not _slots.has(slot_name):
		push_error("[AttachmentMgr] 找不到挂载点: %s" % slot_name)
		return false

	var slot: AttachmentSlot = _slots[slot_name]
	var ok := slot.attach(attachment)
	if ok:
		attachment.parent_weapon = parent_weapon
		_place_attachment(attachment, slot)
		# 配件自身可能带有子槽位（如机匣盖带导轨槽），装上后扫描新增槽位
		_scan_slots(attachment)
		attachment_equipped.emit(slot, attachment)
		attachments_changed.emit()
	return ok


## 从指定槽位卸下配件
func detach_from_slot(slot_name: String) -> BaseAttachment:
	if not _slots.has(slot_name):
		return null

	var slot: AttachmentSlot = _slots[slot_name]
	var att := slot.detach()
	if att:
		# 先清理这个配件带来的所有子槽位
		_remove_child_slots(att)
		if att.get_parent():
			att.get_parent().remove_child(att)
		attachment_detached.emit(slot, att)
		attachments_changed.emit()
	return att


## 递归移除某节点下所有已注册的子槽位（卸载配件时清理它带来的槽）
func _remove_child_slots(root: Node) -> void:
	for child in root.get_children():
		if child is AttachmentSlot:
			var key: String = child.slot_name if child.slot_name != "" else String(child.name)
			if _slots.get(key) == child:
				if child.is_occupied:
					detach_from_slot(key)
				_slots.erase(key)
		if child.get_child_count() > 0:
			_remove_child_slots(child)


func get_slot(slot_name: String) -> AttachmentSlot:
	return _slots.get(slot_name, null)

func get_all_attachments() -> Array[BaseAttachment]:
	var result: Array[BaseAttachment] = []
	for slot in _slots.values():
		if slot.is_occupied:
			result.append(slot.current_attachment)
	return result

func get_attachment_in_slot(slot_name: String) -> BaseAttachment:
	var slot := get_slot(slot_name)
	if slot and slot.is_occupied:
		return slot.current_attachment
	return null


# ──────────────────────────── 节点挂载 ────────────────────────────

## 将配件作为 AttachmentSlot 的子节点挂载
## 对齐规则：
##   1. 配件场景里若有名为 SnapPoint 的 Marker3D，把它对准 AttachmentSlot
##      （美术手动标记装配面，不依赖运行时 AABB 计算）
##   2. 没有 SnapPoint 则回退到原点对齐（transform = IDENTITY）
## 若配件支持导轨滑动（rail_adjustable），在对齐结果上叠加 rail_offset Z 轴偏移
func _place_attachment(att: BaseAttachment, slot: AttachmentSlot) -> void:
	if att.config.no_visual:
		return
	slot.add_child(att)
	var snap := att.find_child(SNAP_POINT_NAME, true, false) as Marker3D
	if snap:
		att.transform = _relative_transform(att, snap).inverse()
	else:
		att.transform = Transform3D.IDENTITY
	if att.config.rail_adjustable:
		att.set_meta(META_RAIL_BASE_Z, att.position.z)
		att.position.z += att.config.rail_offset


## 计算 descendant 相对 ancestor 的变换（沿父链累乘，不依赖场景树全局状态）
func _relative_transform(ancestor: Node3D, descendant: Node3D) -> Transform3D:
	var result := Transform3D.IDENTITY
	var node: Node3D = descendant
	while node and node != ancestor:
		result = node.transform * result
		node = node.get_parent() as Node3D
	return result


## 调整指定槽位配件的导轨偏移（供改装 UI 的滑动条调用）
## offset 会被 clamp 到配件自身的 rail_offset_min/max 范围内
func set_rail_offset(slot_name: String, offset: float) -> void:
	var att := get_attachment_in_slot(slot_name)
	if not att or not att.config.rail_adjustable:
		return
	var clamped := clampf(offset, att.config.rail_offset_min, att.config.rail_offset_max)
	att.config.rail_offset = clamped
	att.position.z = att.get_meta(META_RAIL_BASE_Z, 0.0) + clamped


## 获取指定槽位配件当前的导轨偏移值
func get_rail_offset(slot_name: String) -> float:
	var att := get_attachment_in_slot(slot_name)
	if not att or not att.config.rail_adjustable:
		return 0.0
	return att.config.rail_offset


# ──────────────────────────── 数值缓存重建 ────────────────────────────

func _rebuild_cache() -> void:
	var atts := get_all_attachments()
	_cache_spread_ads = 0.0
	_cache_spread_hip = 0.0
	_cache_recoil_v = 0.0
	_cache_recoil_h = 0.0
	_cache_recoil_recovery = 0.0
	_cache_ads_speed = 0.0
	_cache_weight = 0.0
	_cache_length = 0.0
	_cache_mag_bonus = 0
	_cache_suppresses_flash = false
	_cache_suppresses_sound = false
	_cache_magnification = 1.0
	_cache_fov = -1.0
	for att in atts:
		_cache_spread_ads += att.get_spread_modifier(true)
		_cache_spread_hip += att.get_spread_modifier(false)
		_cache_recoil_v += att.get_recoil_vertical_modifier()
		_cache_recoil_h += att.get_recoil_horizontal_modifier()
		_cache_recoil_recovery += att.get_recoil_recovery_modifier()
		_cache_ads_speed += att.get_ads_speed_modifier()
		_cache_weight += att.get_weight()
		_cache_length += att.get_length_modifier()
		if att.suppresses_muzzle_flash():
			_cache_suppresses_flash = true
		if att.suppresses_sound():
			_cache_suppresses_sound = true
		if att is ExtendedMagAttachment:
			_cache_mag_bonus += att.get_extra_capacity()
		if att is OpticAttachment:
			_cache_magnification = max(_cache_magnification, att.get_magnification())
			var fov := att.get_fov_override()
			if fov > 0.0:
				_cache_fov = fov


# ──────────────────────────── 数值查询（读缓存） ────────────────────────────

func get_total_spread_modifier(is_ads: bool) -> float:
	return _cache_spread_ads if is_ads else _cache_spread_hip

func get_total_recoil_vertical_modifier() -> float:
	return _cache_recoil_v

func get_total_recoil_horizontal_modifier() -> float:
	return _cache_recoil_h

func get_total_recoil_recovery_modifier() -> float:
	return _cache_recoil_recovery

func get_total_ads_speed_modifier() -> float:
	return _cache_ads_speed

func get_total_attachment_weight() -> float:
	return _cache_weight

func get_total_length_modifier() -> float:
	return _cache_length

func get_total_magazine_capacity_bonus() -> int:
	return _cache_mag_bonus

func suppresses_muzzle_flash() -> bool:
	return _cache_suppresses_flash

func suppresses_sound() -> bool:
	return _cache_suppresses_sound

func get_magnification() -> float:
	return _cache_magnification

func get_fov_override() -> float:
	return _cache_fov
