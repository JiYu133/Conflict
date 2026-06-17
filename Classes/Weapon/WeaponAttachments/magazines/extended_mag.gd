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
var extra_capacity: int = 10

func _on_initialized() -> void:
	# 从 config 读取额外容量（如果配置中有定义）
	# 当前默认值 10，可在 .tres 中修改
	pass

## 返回扩容后的额外容量（供 AmmoComponent 调用）
func get_extra_capacity() -> int:
	return extra_capacity
