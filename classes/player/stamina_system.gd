class_name StaminaSystem
extends Node

# ============================================================
# 体力子系统
# 功能：跟踪玩家体力值，依据运动状态消耗/恢复体力，
#       管理耗尽状态，向移动/医疗系统暴露惩罚乘数。
# 数据流：
#   MovementController 信号 → on_started/stopped_sprinting/running/jumped
#       → 更新 _movement_state
#   _physics_process 每帧 → 消耗或恢复体力 → stamina_changed 信号
#   HealthSystem.can_sprint / get_aim_stability_multiplier 查询本系统
# ============================================================

# 运动状态枚举（内部用）
enum MovementState { IDLE, WALKING, RUNNING, SPRINTING }

# 信号 ────────────────────────────────────────────────────────
## 体力百分比变化（0.0–1.0）
signal stamina_changed(pct: float)
## 体力耗尽
signal became_exhausted
## 从耗尽状态恢复
signal recovered_from_exhaustion
## 喘气强度变化（0.0 = 正常，>0 = 需要喘气，由音效系统消费）
signal breath_intensity_changed(intensity: float)

# 公开属性 ────────────────────────────────────────────────────
var stamina: float = 100.0
var max_stamina: float = 100.0

# 私有 ─────────────────────────────────────────────────────────
var _player: BasePlayer = null
var _config: StaminaConfig = null
var _movement_state: MovementState = MovementState.IDLE
var _is_exhausted: bool = false
var _recovery_timer: float = 0.0
var _carry_weight_kg: float = 0.0  # 预留负重接口，暂不影响计算
var _prev_low_breath: bool = false  # 上一帧是否处于低体力喘气状态

# 初始化 ────────────────────────────────────────────────────────
func initialize(player: BasePlayer, config: StaminaConfig) -> void:
	_player = player
	_config = config if config else StaminaConfig.new()
	max_stamina = _config.max_stamina
	stamina = max_stamina

	# 复活时重置体力
	if _player:
		_player.revived.connect(_on_player_revived)

	GlobalLogger.info("StaminaSystem", "Initialized. max_stamina=%.1f" % max_stamina)

# 生命周期 ──────────────────────────────────────────────────────
func _physics_process(delta: float) -> void:
	if not _config or not _player or not _player.is_alive:
		return

	# 1. 每帧重算动态上限（肺部伤情可能在任意时刻改变）
	var new_max := _config.max_stamina * _compute_breathing_factor()
	if new_max != max_stamina:
		max_stamina = new_max
		stamina = minf(stamina, max_stamina)

	var prev_stamina := stamina

	# 2. 消耗或恢复
	match _movement_state:
		MovementState.SPRINTING:
			_recovery_timer = 0.0
			stamina = maxf(0.0, stamina - _config.sprint_cost_per_sec * delta)
		MovementState.RUNNING:
			_recovery_timer = 0.0
			stamina = maxf(0.0, stamina - _config.run_cost_per_sec * delta)
		MovementState.WALKING:
			_recovery_timer = 0.0
			if stamina < max_stamina:
				stamina = minf(max_stamina, stamina + _config.recovery_rate_walk * delta)
			else:
				# 满体力时行走也按消耗计（极小值，维持行走惩罚感）
				stamina = maxf(0.0, stamina - _config.walk_cost_per_sec * delta)
		MovementState.IDLE:
			_recovery_timer += delta
			if _recovery_timer >= _config.recovery_delay:
				stamina = minf(max_stamina, stamina + _config.recovery_rate_idle * delta)

	# 2b. 半蹲持续消耗：stance 越大消耗越多（按配置倍率）
	if _player.stance_controller:
		var stance := _player.stance_controller.get_stance_value()
		if stance > 0.05 and _movement_state != MovementState.SPRINTING and _movement_state != MovementState.RUNNING:
			var crouch_cost: float = stance * _config.walk_cost_per_sec * _config.crouch_cost_multiplier * delta
			stamina = maxf(0.0, stamina - crouch_cost)
			_recovery_timer = 0.0

	# 3. 耗尽状态机
	if not _is_exhausted and stamina <= _config.exhaustion_threshold:
		_is_exhausted = true
		became_exhausted.emit()
		GlobalLogger.debug("StaminaSystem", "Exhausted!")
	elif _is_exhausted and stamina >= _config.recovery_threshold \
			and _movement_state != MovementState.SPRINTING \
			and _movement_state != MovementState.RUNNING:
		_is_exhausted = false
		recovered_from_exhaustion.emit()
		GlobalLogger.debug("StaminaSystem", "Recovered from exhaustion.")

	# 4. 发信号（仅在值变化时）
	if stamina != prev_stamina:
		stamina_changed.emit(get_stamina_pct())

	# 5. 喘气信号：低于阈值时发出，穿越阈值时发一次（上升/下降各一次）
	var pct := get_stamina_pct()
	var low_breath := pct < _config.breath_signal_threshold
	if low_breath != _prev_low_breath:
		_prev_low_breath = low_breath
		breath_intensity_changed.emit(1.0 - pct if low_breath else 0.0)


# 公开查询 API ──────────────────────────────────────────────────

func is_exhausted() -> bool:
	return _is_exhausted

func get_stamina_pct() -> float:
	if max_stamina <= 0.0:
		return 0.0
	return stamina / max_stamina

## 耗尽时降低瞄准稳定性（由 HealthSystem.get_aim_stability_multiplier 消费）
func get_aim_stability_multiplier() -> float:
	return _config.exhausted_aim_penalty if _is_exhausted else 1.0

## 耗尽时降低换弹速度（由武器系统后续消费）
func get_reload_speed_multiplier() -> float:
	return _config.exhausted_reload_speed_mult if _is_exhausted else 1.0

## 体力是否允许冲刺（耗尽禁止 + 阈值禁止）
func allows_sprint() -> bool:
	if _is_exhausted and _config.exhausted_disable_sprint:
		return false
	if _config.sprint_disable_below > 0.0 and get_stamina_pct() < _config.sprint_disable_below:
		return false
	return true

## 体力是否允许奔跑（耗尽禁止 + 阈值禁止）
func allows_run() -> bool:
	if _is_exhausted and _config.exhausted_disable_run:
		return false
	if _config.run_disable_below > 0.0 and get_stamina_pct() < _config.run_disable_below:
		return false
	return true

## 体力是否允许跳跃（耗尽禁止）
func allows_jump() -> bool:
	if _is_exhausted and _config.exhausted_disable_jump:
		return false
	return true

## 预留：负重设置（暂不影响任何计算，供后续负重系统调用）
func set_carry_weight(kg: float) -> void:
	_carry_weight_kg = kg


# 运动状态切换（由 BasePlayer._connect_signals 挂接 MovementController 信号）──

func on_started_sprinting() -> void:
	_movement_state = MovementState.SPRINTING
	_recovery_timer = 0.0

func on_stopped_sprinting() -> void:
	# 冲刺停止后可能仍在 Running，由后续 on_started/stopped_running 同步
	if _movement_state == MovementState.SPRINTING:
		_movement_state = MovementState.RUNNING

func on_started_running() -> void:
	if _movement_state != MovementState.SPRINTING:
		_movement_state = MovementState.RUNNING
	_recovery_timer = 0.0

func on_stopped_running() -> void:
	if _movement_state == MovementState.RUNNING:
		_movement_state = MovementState.IDLE

func on_jumped() -> void:
	stamina = maxf(0.0, stamina - _config.jump_cost)
	stamina_changed.emit(get_stamina_pct())


# 私有 ──────────────────────────────────────────────────────────

## 根据肺部呼吸效率计算体力上限缩放因子。
## breathing_effectiveness 由 HealthSystem.vitals 维护（1.0 = 完好，0.0 = 完全受损）。
## 线性映射到 [breathing_stamina_min_factor, 1.0]。
func _compute_breathing_factor() -> float:
	if not _player or not _player.health_system or not _player.health_system.vitals:
		return 1.0
	var be: float = _player.health_system.vitals.breathing_effectiveness
	# be 已在 HealthSystem 中 clamp 到 [0, 1]
	return lerp(_config.breathing_stamina_min_factor, 1.0, be)


func _on_player_revived() -> void:
	stamina = _config.max_stamina * _compute_breathing_factor()
	max_stamina = stamina
	_is_exhausted = false
	_recovery_timer = 0.0
	_movement_state = MovementState.IDLE
	stamina_changed.emit(get_stamina_pct())
	GlobalLogger.info("StaminaSystem", "Reset on revive.")
