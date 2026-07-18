class_name StanceController
extends Node

# ============================================================
# 姿态控制器（塔科夫风格）
# 功能：通过滚轮连续调整角色身体高度（站立↔蹲下）
# 用法：由 BasePlayer 初始化，通过信号通知其他子系统同步物理参数
# ============================================================

# 信号 ────────────────────────────────────────────────────
signal stance_changed(new_value: float)
## 姿态值改变时触发（0.0=站立, 1.0=蹲下）


# 私有变量 ────────────────────────────────────────────────
var _player: BasePlayer
var _config: PlayerConfig

var _stance_value: float = 0.0  # 当前姿态（平滑插值后的值）
var _target_stance: float = 0.0  # 目标姿态（滚轮设定的目标）

# 输入防抖
var _input_cooldown: float = 0.0
const INPUT_COOLDOWN_TIME: float = 0.05  # 50ms防抖，避免滚轮连续触发过快


# 初始化 ────────────────────────────────────────────────────

func initialize(player: BasePlayer, config: PlayerConfig) -> void:
	_player = player
	_config = config


# 输入处理 ──────────────────────────────────────────────────

func _input(event: InputEvent) -> void:
	# 只在存活、可控时处理（移动时也可调整）
	if not _player.is_alive or not _player.controllable:
		return

	# 姿态微调：默认绑定滚轮上/下，可在设置菜单改绑按键（允许 echo → 按住连续调整）
	if event.is_action_pressed("stance_raise", true):
		adjust_stance(-0.1)  # 站起一档
	elif event.is_action_pressed("stance_lower", true):
		adjust_stance(0.1)   # 蹲下一档

	# C 键：完全站立 → 最低姿态；非完全站立 → 完全站立
	if event.is_action_pressed("crouch"):
		_handle_crouch_toggle()


# 公共方法 ──────────────────────────────────────────────────

func adjust_stance(delta: float) -> void:
	"""调整姿态目标值"""
	if _input_cooldown > 0.0:
		return

	_target_stance = clamp(_target_stance + delta, 0.0, 1.0)
	_input_cooldown = INPUT_COOLDOWN_TIME

	# 向下调整姿态（进入蹲姿）时，自动退出Sprint状态
	if delta > 0.0 and _player and _player.get("movement_controller"):
		var movement = _player.get("movement_controller")
		if movement and movement.has_method("is_sprinting") and movement.is_sprinting():
			if movement.has_method("_exit_sprint"):
				movement._exit_sprint()
				GlobalLogger.debug("StanceController", "Exited sprint due to crouch stance")

	GlobalLogger.debug("StanceController", "Target stance: %.2f" % _target_stance)


func get_stance_value() -> float:
	"""获取当前姿态值（0.0=站立, 1.0=蹲下）"""
	return _stance_value


func set_stance(value: float) -> void:
	"""直接设置姿态值（用于强制站起等场景）"""
	_stance_value = clamp(value, 0.0, 1.0)
	_target_stance = _stance_value


# 每帧更新 ──────────────────────────────────────────────────

func _process(delta: float) -> void:
	# 防抖计时器递减
	if _input_cooldown > 0.0:
		_input_cooldown -= delta

	# 平滑插值到目标姿态
	if not is_equal_approx(_stance_value, _target_stance):
		var transition_speed: float = _config.stance_transition_speed if _config else 3.0
		_stance_value = move_toward(_stance_value, _target_stance, transition_speed * delta)
		stance_changed.emit(_stance_value)


func _handle_crouch_toggle() -> void:
	const STAND_THRESHOLD := 0.05  # 目标值接近 0 视为完全站立
	if _target_stance <= STAND_THRESHOLD:
		# 当前已是完全站立 → 直接蹲到最低
		_target_stance = 1.0
		_input_cooldown = INPUT_COOLDOWN_TIME
		# 蹲下时退出 Sprint
		if _player and _player.get("movement_controller"):
			var movement = _player.get("movement_controller")
			if movement and movement.has_method("is_sprinting") and movement.is_sprinting():
				if movement.has_method("_exit_sprint"):
					movement._exit_sprint()
		GlobalLogger.debug("StanceController", "C key: full crouch")
	else:
		# 非完全站立 → 起身
		_target_stance = 0.0
		_input_cooldown = INPUT_COOLDOWN_TIME
		GlobalLogger.debug("StanceController", "C key: stand up")
