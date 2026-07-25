class_name AttachmentManager
extends Node

# ════════════════════════════════════════════════════════════════════════
# 配件管理器 (AttachmentManager)
# ════════════════════════════════════════════════════════════════════════
# 作用：一把武器上挂一个 AttachmentManager，它负责：
#   1. 扫描武器场景里所有的 AttachmentSlot 和 Marker3D 锚点
#   2. 接受玩家的装备/卸载请求，管理配件节点的场景树归属
#   3. 汇总所有配件的数值修正，缓存结果以避免重复遍历
#
# 数值汇总方式：
#   武器实际值 = 武器基础值 + Σ 所有当前配件的修正
#   每次 attachments_changed 时重建缓存；各 get_total_* 直接读缓存。
#
# 装备流程（外部调用）：
#   var att = AttachmentFactory.create(red_dot_config, weapon)
#   weapon.attachment_manager.equip_to_slot(att, "OpticRail")
# ════════════════════════════════════════════════════════════════════════

# ──────────────────────────── 信号 ────────────────────────────
signal attachment_equipped(slot: AttachmentSlot, attachment: BaseAttachment)
signal attachment_detached(slot: AttachmentSlot, attachment: BaseAttachment)
signal attachments_changed()

# ──────────────────────────── 内部状态 ────────────────────────────
var parent_weapon: BaseWeapon

var _slots: Dictionary = {}    # {String: AttachmentSlot}
var _anchors: Dictionary = {}  # {String: Node3D} — 只收带 meta "attachment_anchor" 的 Marker3D

# 数值缓存（attachments_changed 时重建）
var _cache_dirty: bool = true
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
	print("[AttachmentMgr] 找到 %d 个挂载点，%d 个锚点" % [_slots.size(), _anchors.size()])


## 递归扫描 AttachmentSlot 和带 meta "attachment_anchor" 的 Marker3D
func _scan_slots(root: Node) -> void:
	for child in root.get_children():
		if child is AttachmentSlot:
			var key: String = child.slot_name if child.slot_name != "" else String(child.name)
			if _slots.has(key):
				push_warning("[AttachmentMgr] 挂载点名称重复，已忽略后者: %s" % key)
			else:
				_slots[key] = child
		elif child is Marker3D and child.has_meta("attachment_anchor"):
			var key: String = String(child.name)
			if not _anchors.has(key):
				_anchors[key] = child
		if child.get_child_count() > 0:
			_scan_slots(child)


# ──────────────────────────── 公开接口 ────────────────────────────

## 返回所有已注册的槽位名称列表（替代直接访问 _slots）
func get_slot_names() -> Array[String]:
	var names: Array[String] = []
	for k in _slots:
		names.append(k as String)
	return names

## 把一个配件装到指定名字的槽位
## 返回 true = 成功；false = 失败（槽位不存在/被占/类型不符）
func equip_to_slot(attachment: BaseAttachment, slot_name: String) -> bool:
	if not _slots.has(slot_name):
		push_error("[AttachmentMgr] 找不到挂载点: %s" % slot_name)
		return false

	var slot: AttachmentSlot = _slots[slot_name]
	var ok := slot.attach(attachment)   # 只做状态记录
	if ok:
		attachment.parent_weapon = parent_weapon
		_place_attachment(attachment, slot_name)   # 负责节点 add_child
		attachment_equipped.emit(slot, attachment)
		attachments_changed.emit()
	return ok

## 从指定名字的槽位卸下配件，并从场景树移除其节点
## 返回被卸下的配件（调用方决定删除/放回库存）
func detach_from_slot(slot_name: String) -> BaseAttachment:
	if not _slots.has(slot_name):
		return null

	var slot: AttachmentSlot = _slots[slot_name]
	var att := slot.detach()   # 只清状态，不移除节点
	if att:
		if att.get_parent():
			att.get_parent().remove_child(att)
		attachment_detached.emit(slot, att)
		attachments_changed.emit()
	return att

## 获取指定名字的挂载点
func get_slot(slot_name: String) -> AttachmentSlot:
	return _slots.get(slot_name, null)

## 获取所有已装备的配件列表
func get_all_attachments() -> Array[BaseAttachment]:
	var result: Array[BaseAttachment] = []
	for slot in _slots.values():
		if slot.is_occupied:
			result.append(slot.current_attachment)
	return result

## 获取指定槽位的当前配件
func get_attachment_in_slot(slot_name: String) -> BaseAttachment:
	var slot := get_slot(slot_name)
	if slot and slot.is_occupied:
		return slot.current_attachment
	return null


# ──────────────────────────── 节点挂载（内部） ────────────────────────────

## 将配件节点 add_child 到对应锚点（或 fallback 到武器根节点），并按需自动居中
func _place_attachment(att: BaseAttachment, slot_name: String) -> void:
	if att.config.no_visual:
		return  # 纯数值配件不需要节点挂载
	var anchor_name: String = att.config.mount_point_name
	if anchor_name == "":
		anchor_name = slot_name
	var anchor: Node3D = _anchors.get(anchor_name, null)
	if anchor:
		anchor.add_child(att)
		att.transform = Transform3D.IDENTITY
	else:
		parent_weapon.add_child(att)  # fallback：挂到武器根节点

	# 自动居中：槽位或配件任一开启即生效
	var slot: AttachmentSlot = _slots.get(slot_name, null)
	var needs_center := att.config.auto_center or (slot != null and slot.auto_center)
	if needs_center:
		_apply_auto_center(att)


## 自动居中实现
##
## 目标：配件原点可能偏离连接面几何中心，但只要在同一平面上即可。
## 此函数读取配件所有 MeshInstance3D 的合并 AABB，
## 计算 AABB 在局部 XY 平面内的中心偏移，将其反向施加到配件 position，
## 使配件几何中心线（对称轴）对准锚点 —— 只修正 X/Y，Z 保持 0（连接面不移位）。
##
## 约定：Z 轴 = 枪管方向（-Z 朝枪口），XY 平面 = 截面平面
func _apply_auto_center(att: BaseAttachment) -> void:
	# 收集所有子 MeshInstance3D 的 AABB（局部空间）
	var combined := AABB()
	var found := false
	for mesh in att.find_children("*", "MeshInstance3D", true, false):
		var mi := mesh as MeshInstance3D
		if not mi or not mi.mesh:
			continue
		# 将 mesh 的 AABB 变换到 att 的局部空间
		var local_aabb := mi.transform * mi.mesh.get_aabb()
		if not found:
			combined = local_aabb
			found = true
		else:
			combined = combined.merge(local_aabb)

	if not found:
		return  # 无 mesh，跳过

	# AABB 在 XY 平面内的中心（Z 不参与）
	var center := combined.get_center()
	# 反向偏移 X/Y，让几何中心落在锚点原点上
	att.position = Vector3(-center.x, -center.y, 0.0)


# ──────────────────────────── 缓存重建 ────────────────────────────

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
	_cache_dirty = false


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
