class_name SuppressorAttachment
extends BaseAttachment

# ════════════════════════════════════════════════════════════════════════
# 消音器 (SuppressorAttachment)
# ════════════════════════════════════════════════════════════════════════
# 作用：螺纹式消音器（例：PBS-4、SureFire SOCOM556-RC）。
#       减少枪口火光和枪声，便于隐蔽射击。
#
# 效果由 AttachmentConfig 的抑制标志、质量、质心和长度字段提供。
# WeaponFXController 等系统读取配置；此占位脚本不实现固定加成。
# damage_modifier 尚无运行时消费者，也没有亚音速弹伤害修正分支。
# ════════════════════════════════════════════════════════════════════════

func _on_initialized() -> void:
	pass
