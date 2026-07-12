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
var _config: PlayerConfig

var _state: State = State.IDLE
var _land_timer: float = 0.0
var _was_on_floor: bool = true
# 上一帧的局部水平速度，速度不变时跳过 AnimationTree 参数写入（INF 保证首帧必写）
var _last_blend_vel: Vector2 = Vector2.INF


# 初始化 ────────────────────────────────────────────────────

func initialize(player: CharacterBody3D, movement: PlayerMovementController, model_manager: PlayerModelManager, anim_config: PlayerConfig = null) -> void:
	_player = player
	_movement = movement
	_config = anim_config if anim_config else PlayerConfig.new()

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
	_setup_animations()
	_transition(State.IDLE)


# 初始化动画资源设置 ────────────────────────────────────
# 遍历所有动画库，设为循环并剥离根骨骼位置轨迹（root motion）

func _setup_animations() -> void:
	var player_path: NodePath = _animation_tree.anim_player
	if player_path.is_empty():
		return
	var anim_player := _animation_tree.get_node(player_path) as AnimationPlayer
	if not anim_player:
		return

	# 只会被设为循环的动画库名关键词
	const LOOPING_KEYWORDS := ["idle", "walk_", "run_"]

	for lib_name in anim_player.get_animation_library_list():
		var lib: AnimationLibrary = anim_player.get_animation_library(lib_name)
		if not lib:
			continue

		# 判断是否为需要循环的动画
		var should_loop := false
		for key in LOOPING_KEYWORDS:
			if lib_name.contains(key):
				should_loop = true
				break

		for anim_name in lib.get_animation_list():
			var anim: Animation = lib.get_animation(anim_name)
			if not anim:
				continue

			if should_loop and anim.loop_mode != Animation.LOOP_LINEAR:
				anim.loop_mode = Animation.LOOP_LINEAR

			# 剥离根骨骼位置轨迹
			var i := anim.get_track_count() - 1
			while i >= 0:
				if anim.track_get_type(i) == Animation.TYPE_POSITION_3D and _is_root_motion_track(anim.track_get_path(i)):
					anim.remove_track(i)
				i -= 1


# 每帧检测 ──────────────────────────────────────────────────

func _is_root_motion_track(track_path: NodePath) -> bool:
	var path_text := str(track_path)
	var root_position_track_names := [
		"Root", "root", "Armature", "Hips", "mixamorig_Hips"
	]
	for root_name in root_position_track_names:
		if path_text == root_name:
			return true
		if path_text.ends_with("/" + root_name) or path_text.ends_with(":" + root_name):
			return true
		if path_text.contains("/" + root_name + ":") or path_text.contains(":" + root_name + ":"):
			return true
	return false


func _process(delta: float) -> void:
	if not is_instance_valid(_player) or not is_instance_valid(_animation_tree) or not _playback:
		return

	# 每帧更新 BlendSpace2D 混合坐标（无论当前状态，保持同步）
	_update_blend_positions()

	# 落地过渡计时：倒计时结束后按地面速度决定切回 IDLE/WALK/RUN
	if _state == State.LAND:
		_land_timer -= delta
		if _land_timer <= 0.0:
			var next_state := _resolve_ground_state()
			_was_on_floor = true  # 来自落地状态，确保后续坠落检测能正确触发
			_transition(next_state)
		return

	# 死亡状态不做任何自动切换
	if _state == State.DEATH:
		return

	var on_floor := _player.is_on_floor()

	# 跳跃完成后（垂直速度变为负值/下降中）自动进入 FALL
	if _state == State.JUMP and not on_floor and _player.velocity.y < 0:
		_transition(State.FALL)
		_was_on_floor = false
		return

	# 检测离地 → 进入 FALL（跳跃由信号处理，这里只捕获被动坠落）
	if not on_floor and _was_on_floor and _state != State.JUMP:
		_transition(State.FALL)
		_was_on_floor = false
		return

	_was_on_floor = on_floor

	# 地面状态：每帧主动驱动 IDLE ↔ WALK 切换
	# RUN 由信号和 is_running() 协同驱动
	if on_floor and _state != State.JUMP:
		_transition(_resolve_ground_state())


# BlendSpace2D 混合坐标更新 ───────────────────────────────────

func _update_blend_positions() -> void:
	if not is_instance_valid(_player) or not _movement:
		return

	# 将世界速度转换到玩家局部坐标系，取水平分量
	# 玩家 basis 只做 yaw 旋转（正交），transposed() 等价于 inverse() 且更便宜
	var local_vel: Vector3 = _player.global_transform.basis.transposed() * _player.velocity
	# 局部坐标：X = 右，-Z = 前；BlendSpace2D 约定 Y 轴正方向 = 前进
	var vel_2d := Vector2(local_vel.x, -local_vel.z)

	# 速度与上一帧相同（如静止站立）时跳过写入，避免无谓的参数路径解析
	if vel_2d == _last_blend_vel:
		return
	_last_blend_vel = vel_2d

	# 各混合空间按各自步态的最大速度归一化：
	# 以 walk_speed 行走时 Walk 空间应采样到单位圆上（满幅行走姿态），
	# 统一除以 run_speed 会让行走姿态被稀释产生滑步
	var walk_blend := (vel_2d / maxf(_config.walk_speed, 0.001)).limit_length(1.0)
	var run_blend := (vel_2d / maxf(_config.run_speed, 0.001)).limit_length(1.0)

	_animation_tree.set(PARAM_WALK_BLEND, walk_blend)
	_animation_tree.set(PARAM_RUN_BLEND, run_blend)


# 信号回调 ──────────────────────────────────────────────────

func _on_jumped() -> void:
	if _state == State.DEATH:
		return
	_transition(State.JUMP)

func _on_landed() -> void:
	if _state == State.DEATH:
		return
	_land_timer = _config.land_recovery_time
	_transition(State.LAND)

func _on_started_running() -> void:
	if _state not in [State.JUMP, State.FALL, State.LAND, State.DEATH]:
		_transition(State.RUN)

func _on_stopped_running() -> void:
	if _state == State.RUN:
		_transition(_resolve_ground_state())

func _on_died() -> void:
	# 直接设置状态为 DEATH，不调用 _transition()。
	# 原因：AnimationTree 状态机中不存在 Death 节点，
	# travel("Death") 会静默失败。死亡动画由 RagdollSystem
	# 直接通过 AnimationPlayer 播放，此处仅阻止 _process()
	# 进行自动状态切换。
	_state = State.DEATH

func _on_revived() -> void:
	if not _playback:
		return
	_was_on_floor = _player.is_on_floor() if is_instance_valid(_player) else false
	_transition(_resolve_ground_state())


# 内部工具 ──────────────────────────────────────────────────

# 根据当前速度和奔跑状态决定地面应处于哪个状态
func _resolve_ground_state() -> State:
	if not _player:
		return State.IDLE
	if _movement and _movement.is_running():
		return State.RUN
	# 显式标量计算，避免临时 Vector2 分配
	var h_speed_sq := _player.velocity.x * _player.velocity.x + _player.velocity.z * _player.velocity.z
	# 滞后阈值来自 PlayerConfig，默认值适用于步态波动约 0.06 m/s、walk_speed 约 1.5 m/s：
	#   进入 WALK：速度 > 0.5 m/s（远大于步态波动，不会因波动误触发）
	#   离开 WALK：速度 < 0.15 m/s（给制动足够空间，避免停步时抖动）
	if _state == State.WALK:
		return State.IDLE if h_speed_sq < _config.walk_exit_speed_sq else State.WALK
	else:
		return State.WALK if h_speed_sq > _config.walk_enter_speed_sq else State.IDLE







func _transition(new_state: State) -> void:
	if _state == new_state:
		return
	if not _playback:
		return
	# 先 travel 再更新 _state，防止 travel 失败时状态失同步
	_playback.travel(_state_to_sm_name(new_state))
	_state = new_state


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
