class_name PlayerAnimationController
extends Node

# ============================================================
# 玩家动画控制器
# 功能：根据玩家运动状态驱动 AnimationPlayer，
#       维护一个显式状态机以避免动画抖动。
# 用法：由 BasePlayer 初始化，传入 movement_controller 和 model_manager。
#       动画资源通过 AnimationPlayer 中的动画名称对应，名称见下方常量。
# ============================================================

# 动画名称常量 ─────────────────────────────────────────────
# 后续在 AnimationPlayer 中创建同名动画即可自动生效
const ANIM_IDLE        := "idle"
const ANIM_WALK        := "walk"
const ANIM_RUN         := "run"
const ANIM_JUMP        := "jump"
const ANIM_FALL        := "fall"
const ANIM_LAND        := "land"
const ANIM_DEATH       := "death"

# 落地过渡动画播放完毕后自动切回 idle/walk/run 的等待时间（秒）
const LAND_RECOVERY_TIME := 0.3

# 状态枚举 ─────────────────────────────────────────────────
enum State {
	IDLE,
	WALK,
	RUN,
	JUMP,
	FALL,
	LAND,
	DEATH,
}

# 私有变量 ─────────────────────────────────────────────────
var _animator: AnimationPlayer
var _movement: PlayerMovementController
var _player: CharacterBody3D

var _state: State = State.IDLE
var _land_timer: float = 0.0
var _was_on_floor: bool = true


# 初始化 ────────────────────────────────────────────────────

func initialize(player: CharacterBody3D, movement: PlayerMovementController, model_manager: PlayerModelManager) -> void:
	_player = player
	_movement = movement
	_animator = model_manager.animator

	# 连接移动控制器信号
	movement.jumped.connect(_on_jumped)
	movement.landed.connect(_on_landed)
	movement.started_running.connect(_on_started_running)
	movement.stopped_running.connect(_on_stopped_running)

	# 连接玩家死亡/复活信号
	player.died.connect(_on_died)
	player.revived.connect(_on_revived)

	GlobalLogger.info("AnimationController", "Initialized.")
	_transition(State.IDLE)


# 每帧检测 ──────────────────────────────────────────────────

func _process(delta: float) -> void:
	if not _player or not _animator:
		return

	# 落地过渡计时
	if _state == State.LAND:
		_land_timer -= delta
		if _land_timer <= 0.0:
			_transition(_resolve_ground_state())
		return

	# 死亡状态不做任何自动切换
	if _state == State.DEATH:
		return

	# 检测离地 → 进入 FALL（跳跃由信号处理，这里只捕获被动坠落）
	var on_floor := _player.is_on_floor()
	if not on_floor and _was_on_floor and _state != State.JUMP:
		_transition(State.FALL)
	_was_on_floor = on_floor


# 信号回调 ──────────────────────────────────────────────────

func _on_jumped() -> void:
	_transition(State.JUMP)

func _on_landed() -> void:
	_land_timer = LAND_RECOVERY_TIME
	_transition(State.LAND)

func _on_started_running() -> void:
	if _state not in [State.JUMP, State.FALL, State.LAND, State.DEATH]:
		_transition(State.RUN)

func _on_stopped_running() -> void:
	if _state == State.RUN:
		_transition(_resolve_ground_state())

func _on_died() -> void:
	_transition(State.DEATH)

func _on_revived() -> void:
	_transition(State.IDLE)


# 内部工具 ──────────────────────────────────────────────────

# 根据当前速度决定地面状态应该是 IDLE 还是 WALK
func _resolve_ground_state() -> State:
	if not _player:
		return State.IDLE
	var h_speed := Vector2(_player.velocity.x, _player.velocity.z).length()
	return State.WALK if h_speed > 0.2 else State.IDLE


func _transition(new_state: State) -> void:
	if _state == new_state:
		return
	_state = new_state

	var anim_name := _state_to_anim(new_state)
	if not _animator:
		return

	if _animator.has_animation(anim_name):
		_animator.play(anim_name)
	else:
		# 动画资源尚未添加时静默跳过，避免运行时报错
		GlobalLogger.debug("AnimationController", "Animation not found: " + anim_name)


func _state_to_anim(state: State) -> String:
	match state:
		State.IDLE:  return ANIM_IDLE
		State.WALK:  return ANIM_WALK
		State.RUN:   return ANIM_RUN
		State.JUMP:  return ANIM_JUMP
		State.FALL:  return ANIM_FALL
		State.LAND:  return ANIM_LAND
		State.DEATH: return ANIM_DEATH
	return ANIM_IDLE
