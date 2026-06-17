class_name FireControlComponent
extends Node

# ============================================================
# 击发控制组件
# 功能：模拟扳机组 + 阻铁 + 保险的完整击发控制逻辑。
#       根据当前射击模式（safe / semi / auto）决定是否允许击发。
# 依赖：WeaponConfig（需要 fire_modes 判断合法性）
# 信号：由 BaseWeapon 消费，触发实际击发流程
# ============================================================

# 信号 ────────────────────────────────────────────────────
signal trigger_pulled()
## 扳机被扣下且通过了击发条件检查
signal trigger_released()
## 扳机被松开（用于复位 trigger_reset 标志）

# 公开属性 ────────────────────────────────────────────────
var config: WeaponConfig

# 私有属性 ────────────────────────────────────────────────
var _trigger_reset: bool = true
## 扳机是否已复位（只有复位后才能再次进行半自动击发）
## semi 模式下：每发子弹都需要松开-扣下的完整动作
## auto 模式下：按住扳机不松会持续自动击发


# ============================================================
# 初始化
# ============================================================
func initialize(cfg: WeaponConfig) -> void:
	config = cfg
	print("FireControl 初始化完成")


# ============================================================
# 扳机控制
# ============================================================

## 扣下扳机
## mode：当前射击模式
##   - "safe"：保险状态，任何击发请求都被忽略
##   - "semi"：半自动，只有扳机复位后才允许击发一次
##   - "auto"：全自动，按住扳机会持续击发（由上游的 _handle_cycle_complete 控制循环）
func press_trigger(mode: String) -> void:
	if mode == "safe":
		return

	match mode:
		"semi":
			# 半自动：扳机未复位时不重复击发（防止按住一扣打一串）
			if _trigger_reset:
				trigger_pulled.emit()
				_trigger_reset = false
		"auto":
			# 全自动：每次调用都触发，上游通过 trigger_held 控制续火
			trigger_pulled.emit()
		# burst（三发点射）未实现，后续扩展时在这里加分支

## 松开扳机 → 扳机复位
func release_trigger() -> void:
	_trigger_reset = true
	trigger_released.emit()
