extends RefCounted

## 配件目录：扫描 res://res/config/weapons/attachments/ 下的全部 AttachmentConfig 资源。
## 改装 UI 用它列出「某个槽位可以装什么」。新增 .tres 无需改代码，重进游戏即可出现。

const CATALOG_ROOT := "res://res/config/weapons/attachments"

static var _cache: Array[AttachmentConfig] = []
static var _scanned := false


## 返回全部已知配件配置（首次调用时扫描并缓存）
static func all() -> Array[AttachmentConfig]:
	if not _scanned:
		_scanned = true
		_cache.clear()
		_scan_dir(CATALOG_ROOT)
		GlobalLogger.info("WeaponMod", "配件目录已加载：%d 项" % _cache.size())
	return _cache


## 返回该槽位能接受的全部配件（已按显示名排序）
static func for_slot(slot: AttachmentSlot) -> Array[AttachmentConfig]:
	var result: Array[AttachmentConfig] = []
	if not slot:
		return result
	for cfg in all():
		if slot.can_accept_attachment(cfg):
			# 左右侧导轨在运行时是两个技术槽位，但具体模型只能落在
			# 自己声明的那一侧；没有首选槽位的通用配件仍可匹配两侧。
			var preferred := cfg.get_preferred_slot_names()
			if not preferred.is_empty() and not preferred.has(slot.get_slot_key()):
				continue
			result.append(cfg)
	result.sort_custom(func(a, b): return a.attachment_name < b.attachment_name)
	return result


## 强制重新扫描（编辑器里新增配件后调试用）
static func invalidate() -> void:
	_scanned = false


static func _scan_dir(path: String) -> void:
	var dir := DirAccess.open(path)
	if not dir:
		GlobalLogger.warn("WeaponMod", "配件目录不存在: " + path)
		return
	dir.list_dir_begin()
	var entry := dir.get_next()
	while entry != "":
		var full := path.path_join(entry)
		if dir.current_is_dir():
			if not entry.begins_with("."):
				_scan_dir(full)
		elif entry.ends_with(".tres") or entry.ends_with(".res"):
			var res := ResourceLoader.load(full)
			if res is AttachmentConfig:
				_cache.append(res)
		entry = dir.get_next()
	dir.list_dir_end()
