class_name SelectorSwitchAttachment
extends BaseAttachment

## 快慢机配件提供模式切换能力；具体模式状态仍由 BaseWeapon 持有。
func can_switch_fire_mode() -> bool:
	return true


## 视觉配件可在此根据 mode 驱动拨片动画；当前模型没有动画时保持空实现。
func on_fire_mode_changed(_mode: String) -> void:
	pass
