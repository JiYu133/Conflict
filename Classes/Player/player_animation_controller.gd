class_name PlayerAnimationController
extends Node

# ============================================================
# 玩家动画控制器（AnimationTree 版本）
# 功能：通过 AnimationTree + AnimationNodeStateMachine 驱动动画，
#       Walk / Run 状态使用 BlendSpace2D 实现 8 方向混合。
# 用法：由 BasePlayer 初始化，传入 movement_controller 和 model_manager。
#       状态机节点名称见下方常量，必须与编辑器里的节点名完全一致。
# ============================================================

# 状态机节点名称（必须与 AnimationTree 编辑器中的节点名一致）──────
const SM_IDLE  := "Idle"
const SM_WALK  := "Walk"
const SM_RUN   := "Run"
const SM_JUMP  := "Jump"
const SM_FALL  := "Fall"
const SM_LAND  := "Land"
const SM_DEATH := "Death"

# AnimationTree 参数路径 ──────────────────────────────────────
const PARAM_PLAYBACK   := "parameters/playback"
const PARAM_WALK_BLEND := "parameters/Walk/blend_position"
const PARAM_RUN_BLEND  := "parameters/Run/blend_position"

# 落地动画播放完毕后自动切回地面状态的等待时间（秒）
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
var _animation_tree: AnimationTree
var _playback: AnimationNodeStateMachinePlayback
var _movement: PlayerMovementController
var _player: CharacterBody3D

var _state: State = State.IDLE
var _land_timer: float = 0.0
var _was_on_floor: bool = true


# 初始化 ────────────────────────────────────────────────────

func initialize(player: CharacterBody3D, movement: PlayerMovementController, model_manager: PlayerModelManager) -> void:
	_player = player
	_movement = movement

	# 信号连接与 AnimationTree 无关，始终建立，防止提前返回导致信号缺失
	if not movement.jumped.is_connected(_on_jumped):
		movement.jumped.connect(_on_jumped)
	if not movement.landed.is_connected(_on_landed):
		movement.landed.connect(_on_landed)
	if not movement.started_running.is_connected(_on_started_running):
		movement.started_running.connect(_on_started_running)
	if not movement.stopped_running.is_connected(_on_stopped_running):
		movement.stopped_running.connect(_on_stopped_running)
	if not player.died.is_connected(_on_died):
		player.died.connect(_on_died)
	if not player.revived.is_connected(_on_revived):
		player.revived.connect(_on_revived)

	_animation_tree = model_manager.animation_tree

	if not is_instance_valid(_animation_tree):
		GlobalLogger.debug("AnimationController", "未找到 AnimationTree，动画禁用。")
		return

	_playback = _animation_tree.get(PARAM_PLAYBACK) as AnimationNodeStateMachinePlayback
	if not _playback:
		GlobalLogger.warn("AnimationController", "无法获取状态机 playback，请确认 AnimationTree 根节点为 AnimationNodeStateMachine。")
		return

	GlobalLogger.info("AnimationController", "Initialized with AnimationTree.")
	_transition(State.IDLE)


# 每帧检测 ──────────────────────────────────────────────────

func _process(delta: float) -> void:
	if not _player or not is_instance_valid(_animation_tree) or not _playback:
		return

	# 每帧更新 BlendSpace2D 混合坐标（无论当前状态，保持同步）
	_update_blend_positions()

	# 落地过渡计时
	if _state == State.LAND:
		_land_timer -= delta
		_was_on_floor = _player.is_on_floor()
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


# BlendSpace2D 混合坐标更新 ───────────────────────────────────

func _update_blend_positions() -> void:
	# 用实际速度驱动混合坐标，确保被动位移（击退、传送带等）也能正确播放动画
	# 将世界速度转换到玩家局部坐标系，取水平分量
	var local_vel: Vector3 = _player.global_transform.basis.inverse() * _player.velocity
	# 局部坐标：X = 右，-Z = 前；BlendSpace2D 约定 Y 轴正方向 = 前进
	var blend_pos := Vector2(local_vel.x, -local_vel.z)

	# 按最大速度归一化，让混合坐标保持在 [-1, 1] 范围内
	var max_speed: float = _movement.get_max_speed() if _movement.has_method("get_max_speed") else 4.0
	if max_speed > 0.0:
		blend_pos /= max_speed

	# 超出单位圆时归一化
	if blend_pos.length_squared() > 1.0:
		blend_pos = blend_pos.normalized()

	_animation_tree.set(PARAM_WALK_BLEND, blend_pos)
	_animation_tree.set(PARAM_RUN_BLEND, blend_pos)


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
	_transition(_resolve_ground_state())


# 内部工具 ──────────────────────────────────────────────────

# 根据当前速度和奔跑状态决定地面应处于哪个状态
func _resolve_ground_state() -> State:
	if not _player:
		return State.IDLE
	if _movement and _movement.is_running():
		return State.RUN
	var h_speed_sq := Vector2(_player.velocity.x, _player.velocity.z).length_squared()
	return State.WALK if h_speed_sq > 0.04 else State.IDLE


func _transition(new_state: State) -> void:
	if _state == new_state:
		return
	if not _playback:
		return
	_state = new_state
	_playback.travel(_state_to_sm_name(new_state))


func _state_to_sm_name(state: State) -> String:
	match state:
		State.IDLE:  return SM_IDLE
		State.WALK:  return SM_WALK
		State.RUN:   return SM_RUN
		State.JUMP:  return SM_JUMP
		State.FALL:  return SM_FALL
		State.LAND:  return SM_LAND
		State.DEATH: return SM_DEATH
	return SM_IDLE
