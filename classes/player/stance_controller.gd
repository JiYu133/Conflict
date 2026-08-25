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
signal prone_geometry_changed(new_blend: float)
## 趴下碰撞箱/模型偏移混合值改变时触发（0.0=站/蹲，1.0=趴下）


# 私有变量 ────────────────────────────────────────────────
signal prone_changed(active: bool)
signal prone_transition_changed(active: bool)

var _player: BasePlayer
var _config: PlayerConfig
var _is_prone: bool = false
var _prone_transition: bool = false
var _prone_entering: bool = false
var _prone_exit_to_stand: bool = false
var _prone_exit_clip_finished: bool = false
var _prone_timer: float = 0.0
var _stance_before_prone: float = 0.0

var _stance_value: float = 0.0  # 当前姿态（平滑插值后的值）
var _target_stance: float = 0.0  # 目标姿态（滚轮设定的目标）
var _prone_geometry_blend: float = 0.0
var _prone_geometry_target: float = 0.0
var _prone_geometry_speed: float = 3.0

# 输入防抖
var _input_cooldown: float = 0.0
var _prone_input_down: bool = false
const INPUT_COOLDOWN_TIME: float = 0.05  # 50ms防抖，避免滚轮连续触发过快
const STAND_POSE_THRESHOLD: float = 0.05


# 初始化 ────────────────────────────────────────────────────

func initialize(player: BasePlayer, config: PlayerConfig) -> void:
	_player = player
	_config = config


# 输入处理 ──────────────────────────────────────────────────

func _input(event: InputEvent) -> void:
	# 只在存活、可控时处理（移动时也可调整）
	if not _player.is_alive or not _player.controllable:
		return
	# A prone roll owns the complete pose until its authored animation finishes.
	if _player.movement_controller and _player.movement_controller.is_prone_rolling():
		return
	# Consume one toggle per physical press. The action is already bound to Z;
	# handling a second physical-key fallback caused duplicate press events.
	if event.is_action_released("prone"):
		_prone_input_down = false
	if event.is_action_pressed("prone"):
		if _prone_input_down or _prone_transition:
			return
		_prone_input_down = true
		if _is_prone:
			_exit_prone(true)
		else:
			_enter_prone()
		return

	# 姿态微调：默认绑定滚轮上/下，可在设置菜单改绑按键（允许 echo → 按住连续调整）
	var stance_step := _config.movement_config.stance_step_size if _config and _config.movement_config else 0.1
	if event.is_action_pressed("stance_raise", true):
		adjust_stance(-stance_step)  # 站起一档
	elif event.is_action_pressed("stance_lower", true):
		adjust_stance(stance_step)   # 蹲下一档

	# C 键：站立/蹲姿互切；趴下时先回到蹲姿。
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


func is_stance_transitioning() -> bool:
	"""是否正在调整站立/蹲姿高度（不含趴下过渡）。"""
	return not is_equal_approx(_stance_value, _target_stance)


func set_stance(value: float) -> void:
	"""直接设置姿态值（用于强制站起等场景）"""
	var previous := _stance_value
	_stance_value = clamp(value, 0.0, 1.0)
	_target_stance = _stance_value
	if not is_equal_approx(previous, _stance_value):
		stance_changed.emit(_stance_value)


func transition_to_stance(value: float) -> void:
	"""平滑切换到目标姿态，供 AI/自动姿态控制使用。"""
	if _prone_transition or _is_prone:
		return
	_target_stance = clamp(value, 0.0, 1.0)
	if _target_stance > STAND_POSE_THRESHOLD and _player:
		var movement = _player.get("movement_controller")
		if movement and movement.has_method("is_sprinting") and movement.is_sprinting():
			if movement.has_method("_exit_sprint"):
				movement._exit_sprint()


# 每帧更新 ──────────────────────────────────────────────────

func is_prone() -> bool:
	return _is_prone

func is_prone_transitioning() -> bool:
	return _prone_transition


func is_exiting_prone_to_stand() -> bool:
	"""Whether the active prone transition is returning to the standing pose."""
	# Before the authored exit clip finishes, the intermediate target is crouch.
	# Once that clip releases the pose, the shared stance blend continues to stand.
	return _prone_transition and not _prone_entering \
			and _prone_exit_to_stand and _prone_exit_clip_finished


func get_prone_geometry_blend() -> float:
	return _prone_geometry_blend


## Cancels the active prone geometry transition when the composition root says
## the candidate environment capsule has no clearance. This controller never
## queries physics or reaches into PlayerCollisionController directly.
func reject_collision_transition() -> void:
	if not _prone_transition:
		return
	var rejected_entry := _prone_entering
	_prone_transition = false
	_prone_entering = false
	_prone_exit_to_stand = false
	_prone_exit_clip_finished = false
	_prone_timer = 0.0
	if rejected_entry:
		_is_prone = false
		_target_stance = _stance_before_prone
		_prone_geometry_target = 0.0
		prone_changed.emit(false)
	else:
		_is_prone = true
		_target_stance = 1.0
		_prone_geometry_target = 1.0
		prone_changed.emit(true)
	prone_transition_changed.emit(false)
	if _player and _player.get("animation_controller"):
		if _is_prone:
			_player.animation_controller.play_prone_idle()
		else:
			_player.animation_controller.clear_prone_override()

func _unhandled_input(event: InputEvent) -> void:
	# Prone is handled in _input so it is not affected by UI/event consumption.
	return

func _enter_prone() -> void:
	if _prone_transition or _is_prone:
		return
	_stance_before_prone = _target_stance
	_target_stance = 1.0
	_prone_geometry_target = 1.0
	_is_prone = true
	_prone_transition = true
	_prone_entering = true
	_prone_exit_clip_finished = false
	_prone_timer = 0.55
	prone_changed.emit(true)
	prone_transition_changed.emit(true)
	if _player.get("animation_controller"):
		var animation: PlayerAnimationController = _player.animation_controller
		if animation.play_prone_transition("enter"):
			_prone_timer = maxf(animation.get_prone_transition_length("enter"), 0.01)
		else:
			_prone_transition = false
			prone_transition_changed.emit(false)
			_player.animation_controller.play_prone_idle()
	_prone_geometry_speed = 1.0 / maxf(_prone_timer, 0.01)

func _exit_prone(to_stand: bool) -> void:
	if _prone_transition or not _is_prone:
		return
	_prone_transition = true
	_prone_entering = false
	_prone_exit_to_stand = to_stand
	_prone_exit_clip_finished = false
	# The authored exit clip ends in a crouched pose. Z then continues with the
	# normal stance blend to standing; C remains crouched after the clip.
	_target_stance = 1.0
	_prone_geometry_target = 0.0
	_is_prone = false
	prone_changed.emit(false)
	_prone_timer = 1.97
	prone_transition_changed.emit(true)
	if _player.get("animation_controller"):
		var animation: PlayerAnimationController = _player.animation_controller
		if animation.play_prone_transition("exit"):
			_prone_timer = maxf(animation.get_prone_transition_length("exit"), 0.01)
		else:
			_finish_prone_exit()
	else:
		_finish_prone_exit()
	_prone_geometry_speed = 1.0 / maxf(_prone_timer, 0.01)

func _finish_prone_exit() -> void:
	if not _prone_transition:
		return
	# The authored exit clip can finish while the shared stance blend is still
	# between prone and standing. Keep the transition owned by this controller
	# until the stand target is reached; otherwise the animation system briefly
	# sees a crouch pose and the collision capsule changes owner in one frame.
	if not _prone_entering and _prone_exit_to_stand and not _prone_exit_clip_finished:
		_prone_exit_clip_finished = true
		_target_stance = 0.0
		_prone_timer = 0.0
		return
	var completing_entry := _prone_entering
	_prone_entering = false
	var was_prone := _is_prone
	_is_prone = completing_entry
	# C exits into crouch. Z starts crouched, then reaches standing through the
	# regular stance interpolation after the authored prone-exit clip.
	_target_stance = 0.0 if not completing_entry and _prone_exit_to_stand else 1.0
	_prone_geometry_target = 1.0 if completing_entry else 0.0
	_prone_exit_to_stand = false
	_prone_exit_clip_finished = false
	_prone_transition = false
	# Publish only after every pose field is coherent. In particular, listeners
	# must never observe transition=false while is_prone still has its old value.
	if was_prone != _is_prone:
		prone_changed.emit(_is_prone)
	prone_transition_changed.emit(false)
	if _player and _player.get("animation_controller"):
		if _is_prone:
			_player.animation_controller.play_prone_idle()
		else:
			_player.animation_controller.clear_prone_override()

func _process(delta: float) -> void:
	if _prone_transition:
		if not _prone_exit_clip_finished:
			_prone_timer -= delta
		if (_prone_exit_clip_finished and _stance_value <= STAND_POSE_THRESHOLD) \
				or (not _prone_exit_clip_finished and _prone_timer <= 0.0):
			_finish_prone_exit()
	# 防抖计时器递减
	if _input_cooldown > 0.0:
		_input_cooldown -= delta

	# Collision and model offsets need their own blend. is_prone changes at the
	# start of an exit for gameplay/animation ownership, but geometry must not
	# switch between the prone and crouched capsules in that same frame.
	if not is_equal_approx(_prone_geometry_blend, _prone_geometry_target):
		_prone_geometry_blend = move_toward(
			_prone_geometry_blend,
			_prone_geometry_target,
			_prone_geometry_speed * delta
		)
		prone_geometry_changed.emit(_prone_geometry_blend)

	# 平滑插值到目标姿态
	if not is_equal_approx(_stance_value, _target_stance):
		var transition_speed: float = _config.stance_transition_speed if _config else 3.0
		# 指数平滑避免小步进在单帧内突然跳到下一姿态阶段。
		var blend := 1.0 - exp(-maxf(transition_speed, 0.01) * delta)
		_stance_value = lerpf(_stance_value, _target_stance, blend)
		if absf(_stance_value - _target_stance) < 0.001:
			_stance_value = _target_stance
		stance_changed.emit(_stance_value)


func _handle_crouch_toggle() -> void:
	if _prone_transition:
		return
	if _is_prone:
		_exit_prone(false)
		return
	if _target_stance <= STAND_POSE_THRESHOLD:
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
