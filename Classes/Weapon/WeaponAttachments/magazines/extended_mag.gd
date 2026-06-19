class_name ExtendedMagAttachment
extends BaseAttachment

# ════════════════════════════════════════════════════════════════════════
# 加长弹匣 (ExtendedMagAttachment)
# ════════════════════════════════════════════════════════════════════════
# 作用：扩容弹匣（例：PMAG 40发、Tapco SKS 30发）。
#       增加单弹匣容量。
#
# 效果：
#   - 弹匣容量 +N 发（在 WeaponConfig.magazine_capacity 基础上叠加）
#   - 重量增加
#   - 部分弹匣会影响可靠性
# ════════════════════════════════════════════════════════════════════════

# 扩容弹匣特有的容量加成（需要被 ammo_component 查询）
## 注：通过 getter 暴露给 AmmoComponent 计算实际弹匣容量
## 【当前状态】此值为硬编码 10、尚非配置驱动；且即便接入，
## 容量加成链路在现流程下也不会被触发（见 BaseWeapon.initialize() 中
## apply_magazine_attachments() 的说明）。补全属新增功能，本轮不实现。
var extra_capacity: int = 10

func _on_initialized() -> void:
	# 【预期不可达 / 待扩展】未来可在此从 config 读取额外容量；
	# 当前固定为默认值 10。
	pass

## 返回扩容后的额外容量（供 AmmoComponent 调用）
func get_extra_capacity() -> int:
	return extra_capacity
