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
const SM_IDLE         := "Idle"
const SM_WALK         := "Walk"
const SM_CROUCH_WALK  := "CrouchWalk"
const SM_RUN          := "Run"
const SM_SPRINT       := "Sprint"
const SM_JUMP         := "Jump"
const SM_FALL         := "Fall"
const SM_LAND         := "Land"
const SM_DEATH        := "Death"
const SM_TURN_LEFT    := "TurnLeft"
const SM_TURN_RIGHT   := "TurnRight"
const SM_CROUCH_TURN_LEFT  := "CrouchTurnLeft"
const SM_CROUCH_TURN_RIGHT := "CrouchTurnRight"
const SM_PRONE_TURN_LEFT := "ProneTurnLeft"
const SM_PRONE_TURN_RIGHT := "ProneTurnRight"
const TURN_THRESHOLD_EPSILON := deg_to_rad(0.1)
## Direct prone locomotion clips bypass AnimationTree, so they need an
## explicit blend time when switching between idle and crawl directions.
const PRONE_LOCOMOTION_BLEND_TIME := 0.16

# AnimationTree 参数路径 ──────────────────────────────────────
const PARAM_PLAYBACK           := "parameters/playback"
const PARAM_WALK_BLEND         := "parameters/Walk/blend_position"
const PARAM_CROUCH_WALK_BLEND  := "parameters/CrouchWalk/blend_position"
const PARAM_RUN_BLEND          := "parameters/Run/blend_position"
const PARAM_SPRINT_BLEND       := "parameters/Sprint/blend_position"
const PARAM_STANCE_BLEND       := "parameters/Idle/blend_position"
## The authored prone lateral clips are also used by the independent prone
## turn controller. Keep the resource mapping in one place without coupling
## the movement and turn state machines.
const PRONE_LATERAL_LEFT_CLIP := &"prone_turn_left/mixamo_com"
const PRONE_LATERAL_RIGHT_CLIP := &"prone_turn_right/mixamo_com"
# Prone turns use the direct AnimationPlayer override because the imported
# AnimationTree does not contain dedicated prone turn nodes.
const TURN_STATE_NAMES := [SM_TURN_LEFT, SM_TURN_RIGHT, SM_CROUCH_TURN_LEFT, SM_CROUCH_TURN_RIGHT]


# 状态枚举 ─────────────────────────────────────────────────
enum State {
	IDLE,
	WALK,
	CROUCH_WALK,
	RUN,
	SPRINT,
	JUMP,
	FALL,
	LAND,
	DEATH,
	TURN_LEFT,
	TURN_RIGHT,
	CROUCH_TURN_LEFT,
	CROUCH_TURN_RIGHT,
	PRONE_TURN_LEFT,
	PRONE_TURN_RIGHT,
}

# 私有变量 ─────────────────────────────────────────────────
var _animation_tree: AnimationTree
var _animator: AnimationPlayer
var _playback: AnimationNodeStateMachinePlayback
var _movement: PlayerMovementController
var _player: CharacterBody3D
var _config: PlayerConfig

var _state: State = State.IDLE
var _land_timer: float = 0.0
var _was_on_floor: bool = true
# 上一帧的局部水平速度，速度不变时跳过 AnimationTree 参数写入（INF 保证首帧必写）
var _last_blend_vel: Vector2 = Vector2.INF
var _last_observed_yaw: float = 0.0
var _accumulated_turn_yaw: float = 0.0
var _turn_timer: float = 0.0
var _external_turn_active: bool = false
var _external_turn_speed: float = 1.0
var _external_turn_position: float = 0.0
var _prone_animation_override: StringName = &""
var _direct_prone_turn: bool = false
var _prone_turn_release_pending: bool = false


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
	if not player.died.is_connected(_on_died):
		player.died.connect(_on_died)
	if not player.revived.is_connected(_on_revived):
		player.revived.connect(_on_revived)

	# 连接姿态控制器信号
	if player.stance_controller and not player.stance_controller.stance_changed.is_connected(_on_stance_changed):
		player.stance_controller.stance_changed.connect(_on_stance_changed)

	_animation_tree = model_manager.animation_tree
	_animator = model_manager.animator

	if not is_instance_valid(_animation_tree):
		GlobalLogger.debug("AnimationController", "未找到 AnimationTree，动画禁用。")
		return

	_playback = _animation_tree.get(PARAM_PLAYBACK) as AnimationNodeStateMachinePlayback
	if not _playback:
		GlobalLogger.warn("AnimationController", "无法获取状态机 playback，请确认 AnimationTree 根节点为 AnimationNodeStateMachine。")
		return

	GlobalLogger.info("AnimationController", "Initialized with AnimationTree.")
	_setup_animations()
	_normalize_prone_hips_height()
	_setup_turn_filters()
	_setup_turn_transitions()
	_apply_config_to_transitions()
	# _state 默认就是 IDLE，但状态机启动时仍停在 Start 节点；直接 start
	# 确保运行时实例（尤其是动态创建的 Bot）不会保留导入模型的 T-pose。
	_playback.start(SM_IDLE, true)
	_state = State.IDLE
	_reset_turn_tracking()


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
	const LOOPING_KEYWORDS := ["idle", "walk_", "run_", "sprint_", "crouch"]

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
			if _is_turn_animation_library(lib_name):
				anim = anim.duplicate(true) as Animation
				lib.remove_animation(anim_name)
				lib.add_animation(anim_name, anim)
				_neutralize_turn_hips(anim)
			if should_loop and not _is_turn_animation_library(lib_name) and anim.loop_mode != Animation.LOOP_LINEAR:
				anim.loop_mode = Animation.LOOP_LINEAR
			elif _is_turn_animation_library(lib_name):
				anim.loop_mode = Animation.LOOP_NONE

			var i := anim.get_track_count() - 1
			while i >= 0:
				var track_path := anim.track_get_path(i)
				if not _is_turn_animation_library(lib_name) \
						and not _is_prone_locomotion_library(lib_name) \
						and anim.track_get_type(i) == Animation.TYPE_POSITION_3D \
						and _is_root_motion_track(track_path):
					anim.remove_track(i)
				i -= 1


## Prone clips use different authored Hips heights (especially lateral crawl),
## which moves the whole skeleton and therefore the head-mounted camera. Keep
## the prone root at the idle height while preserving horizontal root motion.
func _normalize_prone_hips_height() -> void:
	var anim_player := _animator
	if not is_instance_valid(anim_player) and _animation_tree:
		var player_path: NodePath = _animation_tree.anim_player
		anim_player = _animation_tree.get_node(player_path) as AnimationPlayer
	if not is_instance_valid(anim_player):
		return
	var idle_library := anim_player.get_animation_library(&"prone_idle")
	if not idle_library:
		return
	var idle_animation := idle_library.get_animation(&"mixamo_com")
	var idle_height := _get_hips_height(idle_animation)
	if is_nan(idle_height):
		return
	var prone_libraries := [
		&"prone_idle", &"prone_forward", &"prone_backward",
		&"prone_crawl_backward", &"prone_turn_left", &"prone_turn_right",
		&"prone_roll", &"roll_left"
	]
	for library_name in prone_libraries:
		var library := anim_player.get_animation_library(library_name)
		if not library:
			continue
		for animation_name in library.get_animation_list():
			var source := library.get_animation(animation_name)
			if not source:
				continue
			var animation := source.duplicate(true) as Animation
			var is_roll_clip: bool = library_name in [&"prone_roll", &"roll_left"]
			_normalize_animation_hips_height(animation, idle_height, is_roll_clip)
			library.remove_animation(animation_name)
			library.add_animation(animation_name, animation)


func _get_hips_height(animation: Animation) -> float:
	if not animation:
		return NAN
	for track_index in animation.get_track_count():
		if animation.track_get_type(track_index) != Animation.TYPE_POSITION_3D:
			continue
		if not str(animation.track_get_path(track_index)).contains("mixamorig_Hips"):
			continue
		if animation.track_get_key_count(track_index) == 0:
			continue
		var value := animation.track_get_key_value(track_index, 0) as Vector3
		return value.y
	return NAN


func _normalize_animation_hips_height(
	animation: Animation,
	height: float,
	remove_horizontal_motion: bool = false
) -> void:
	if not animation:
		return
	for track_index in animation.get_track_count():
		if animation.track_get_type(track_index) != Animation.TYPE_POSITION_3D:
			continue
		if not str(animation.track_get_path(track_index)).contains("mixamorig_Hips"):
			continue
		if animation.track_get_key_count(track_index) == 0:
			continue
		var first_value := animation.track_get_key_value(track_index, 0) as Vector3
		for key_index in animation.track_get_key_count(track_index):
			var value := animation.track_get_key_value(track_index, key_index) as Vector3
			value.y = height
			if remove_horizontal_motion:
				# Roll distance is applied by CharacterBody3D. Keeping the authored
				# Hips X/Z track would move the mesh a second time.
				value.x = first_value.x
				value.z = first_value.z
			animation.track_set_key_value(track_index, key_index, value)


func _is_turn_animation_library(library_name: StringName) -> bool:
	return str(library_name) in ["turn_left", "turn_right", "crouch_turn_left", "crouch_turn_right", "prone_turn_left", "prone_turn_right"]


func _is_prone_locomotion_library(library_name: StringName) -> bool:
	return str(library_name) in [
		"prone_idle", "prone_forward", "prone_backward", "prone_crawl_backward",
		"prone_turn_left", "prone_turn_right", "prone_roll", "roll_left",
		"prone_enter", "prone_exit", "prone_fire"
	]


func _neutralize_turn_hips(animation: Animation) -> void:
	for track_index in animation.get_track_count():
		if not str(animation.track_get_path(track_index)).contains("mixamorig_Hips"):
			continue
		if animation.track_get_type(track_index) not in [Animation.TYPE_ROTATION_3D, Animation.TYPE_POSITION_3D]:
			continue
		var first_value: Variant = animation.track_get_key_value(track_index, 0)
		for key_index in range(1, animation.track_get_key_count(track_index)):
			animation.track_set_key_value(track_index, key_index, first_value)


func _setup_turn_filters() -> void:
	if not _animation_tree:
		return
	var sm := _animation_tree.tree_root as AnimationNodeStateMachine
	if not sm:
		return
	for state_name in TURN_STATE_NAMES:
		if not sm.has_node(state_name):
			continue
		var turn_node := sm.get_node(state_name) as AnimationNodeAnimation
		if not turn_node:
			continue
		var base_node := (sm.get_node(SM_IDLE) as AnimationRootNode).duplicate(true) as AnimationRootNode
		var layered_turn := AnimationNodeBlend2.new()
		layered_turn.filter_enabled = true
		var turn_animation := _get_animation_for_node(turn_node)
		if turn_animation:
			for track_index in turn_animation.get_track_count():
				var track_path := turn_animation.track_get_path(track_index)
				if _is_turn_lower_body_path(track_path):
					layered_turn.set_filter_path(track_path, true)
		var blend_tree := AnimationNodeBlendTree.new()
		blend_tree.add_node("Base", base_node, Vector2(0.0, 0.0))
		blend_tree.add_node("Turn", turn_node, Vector2(0.0, 120.0))
		blend_tree.add_node("Layer", layered_turn, Vector2(220.0, 60.0))
		blend_tree.connect_node("Layer", 0, "Base")
		blend_tree.connect_node("Layer", 1, "Turn")
		blend_tree.connect_node("output", 0, "Layer")
		sm.replace_node(state_name, blend_tree)
		_animation_tree.set("parameters/%s/Layer/blend_amount" % state_name, 1.0)
		_animation_tree.set("parameters/%s/Base/blend_position" % state_name, _current_stance_value())


func _get_animation_for_node(animation_node: AnimationNodeAnimation) -> Animation:
	if not animation_node or not _animation_tree:
		return null
	var animator := _animation_tree.get_node_or_null(_animation_tree.anim_player) as AnimationPlayer
	return animator.get_animation(animation_node.animation) if animator else null


func _is_turn_lower_body_path(track_path: NodePath) -> bool:
	var path_text := str(track_path)
	for bone_name in [
		"mixamorig_LeftUpLeg", "mixamorig_LeftLeg", "mixamorig_LeftFoot", "mixamorig_LeftToeBase",
		"mixamorig_RightUpLeg", "mixamorig_RightLeg", "mixamorig_RightFoot", "mixamorig_RightToeBase",
	]:
		if path_text.contains(bone_name):
			return true
	return false


func _apply_config_to_transitions() -> void:
	var sm := _animation_tree.tree_root as AnimationNodeStateMachine
	if not sm or not _config or not _config.movement_config:
		return
	var xfade: float = _config.movement_config.crouch_walk_xfade_time
	# get_transition() 只接受索引，遍历所有过渡找涉及 CrouchWalk 的条目
	for i in sm.get_transition_count():
		var from := sm.get_transition_from(i)
		var to := sm.get_transition_to(i)
		if from == SM_CROUCH_WALK or to == SM_CROUCH_WALK:
			sm.get_transition(i).xfade_time = xfade


func _setup_turn_transitions() -> void:
	var sm := _animation_tree.tree_root as AnimationNodeStateMachine
	if not sm:
		return
	for turn_state in TURN_STATE_NAMES:
		if not sm.has_node(turn_state):
			GlobalLogger.warn("AnimationController", "Missing turn state: %s" % turn_state)
			continue
		_add_transition_if_missing(sm, SM_IDLE, turn_state)
		_add_transition_if_missing(sm, turn_state, SM_IDLE)
		for locomotion_state in [SM_WALK, SM_CROUCH_WALK, SM_RUN, SM_SPRINT]:
			_add_transition_if_missing(sm, turn_state, locomotion_state)


func _add_transition_if_missing(sm: AnimationNodeStateMachine, from: StringName, to: StringName) -> void:
	for transition_index in sm.get_transition_count():
		if sm.get_transition_from(transition_index) == from and sm.get_transition_to(transition_index) == to:
			return
	var transition := AnimationNodeStateMachineTransition.new()
	transition.xfade_time = _config.movement_config.turn_transition_time if _config and _config.movement_config else 0.12
	sm.add_transition(from, to, transition)

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
	if _prone_animation_override != &"":
		return

	# 每帧更新 BlendSpace2D 混合坐标（无论当前状态，保持同步）
	_update_blend_positions()
	# Turn-in-place is owned by PlayerTurnController. Keep this controller
	# responsible only for AnimationTree state transitions.

	if _is_turn_state(_state):
		if _external_turn_active:
			return
		_process_turn(delta)
		return

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
		var ground_state := _resolve_ground_state()
		_transition(ground_state)
		if ground_state != State.IDLE:
			_reset_turn_tracking()

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
	var sprint_blend := (vel_2d / maxf(_config.sprint_speed, 0.001)).limit_length(1.0)
	# 蹲走 BlendSpace 坐标系与普通走路旋转了 90°（Mixamo 蹲走前进方向为 +X）
	# vel_2d = (right, forward)，需转为 (forward, -right)
	var crouch_normalized := (vel_2d / maxf(_config.crouch_speed, 0.001)).limit_length(1.0)
	var crouch_blend := Vector2(crouch_normalized.y, -crouch_normalized.x)

	_animation_tree.set(PARAM_WALK_BLEND, walk_blend)
	_animation_tree.set(PARAM_CROUCH_WALK_BLEND, crouch_blend)
	_animation_tree.set(PARAM_RUN_BLEND, run_blend)
	_animation_tree.set(PARAM_SPRINT_BLEND, sprint_blend)


# 信号回调 ──────────────────────────────────────────────────

func _on_stance_changed(value: float) -> void:
	"""响应姿态变化，更新 Idle 状态的姿态混合参数，并按阈值切换 Walk/CrouchWalk"""
	if not _animation_tree:
		return
	_animation_tree.set(PARAM_STANCE_BLEND, value)
	for turn_state_name in TURN_STATE_NAMES:
		_animation_tree.set("parameters/%s/Base/blend_position" % turn_state_name, value)
	# Ground locomotion is resolved once per frame in _process(). Keeping the
	# stance signal focused on blend parameters avoids a second transition path.


func _current_stance_value() -> float:
	return _player.stance_controller.get_stance_value() if is_instance_valid(_player) and _player.stance_controller else 0.0
func _on_jumped() -> void:
	if _state == State.DEATH:
		return
	_transition(State.JUMP)

func _on_landed() -> void:
	if _state == State.DEATH:
		return
	_land_timer = _config.land_recovery_time
	_transition(State.LAND)

func _on_died() -> void:
	# 直接设置状态为 DEATH，不调用 _transition()。
	# 原因：AnimationTree 状态机中不存在 Death 节点，
	# travel("Death") 会静默失败。死亡动画由 RagdollSystem
	# 直接通过 AnimationPlayer 播放，此处仅阻止 _process()
	# 进行自动状态切换。
	_state = State.DEATH
	_turn_timer = 0.0
	_reset_turn_tracking()

func on_unconscious() -> void:
	# 昏迷时同样停止动画状态机，防止 AnimationTree 覆盖物理骨骼姿势
	_state = State.DEATH

func _on_revived() -> void:
	if not _playback:
		return
	_was_on_floor = _player.is_on_floor() if is_instance_valid(_player) else false
	_reset_turn_tracking()
	_transition(_resolve_ground_state())


# 内部工具 ──────────────────────────────────────────────────

# 根据当前速度、奔跑状态和姿态决定地面应处于哪个状态
func _resolve_ground_state() -> State:
	if not _player:
		return State.IDLE
	if _movement and _movement.is_sprinting():
		return State.SPRINT
	if _movement and _movement.is_running():
		return State.RUN

	var h_speed_sq := _player.velocity.x * _player.velocity.x + _player.velocity.z * _player.velocity.z
	var is_crouching: bool = is_instance_valid(_movement) and _movement.is_crouched_locomotion()

	# 滞后：当前是行走类状态时用 exit 阈值，否则用 enter 阈值
	var is_walk_state := _state in [State.WALK, State.CROUCH_WALK]
	var moving: bool
	if is_walk_state:
		moving = h_speed_sq >= _config.walk_exit_speed_sq
	else:
		moving = h_speed_sq > _config.walk_enter_speed_sq

	if not moving:
		return State.IDLE
	return State.CROUCH_WALK if is_crouching else State.WALK







func _transition(new_state: State) -> void:
	if _state == new_state:
		return
	if not _playback:
		return
	# 先 travel 再更新 _state，防止 travel 失败时状态失同步
	_playback.travel(_state_to_sm_name(new_state))
	_state = new_state


func _try_start_turn() -> void:
	# Kept as a compatibility no-op for old debug scripts. PlayerTurnController
	# owns thresholding and clip completion using AnimationTree playback data.
	return


func _process_turn(delta: float) -> void:
	var ground_state := _resolve_ground_state()
	if not _player.is_on_floor() or ground_state != State.IDLE:
		_turn_timer = 0.0
		_reset_turn_tracking()
		_transition(ground_state if _player.is_on_floor() else State.FALL)
		return

	_turn_timer -= delta
	if _turn_timer <= 0.0:
		_transition(State.IDLE)


func get_current_state() -> State:
	return _state

func _prone_player() -> AnimationPlayer:
	if not _animation_tree:
		return _animator
	var player := _animation_tree.get_node_or_null(_animation_tree.anim_player) as AnimationPlayer
	if player:
		return player
	# The model is reparented under BasePlayer after instantiation. Resolve the
	# sibling explicitly as a fallback when the imported relative path is stale.
	var parent := _animation_tree.get_parent()
	return parent.get_node_or_null("AnimationPlayer") as AnimationPlayer if parent else _animator

func play_prone_transition(kind: String) -> bool:
	var player := _prone_player()
	if not player:
		return false
	_prone_animation_override = &"prone_enter/mixamo_com" if kind == "enter" else &"prone_exit/mixamo_com"
	if not player.has_animation(_prone_animation_override):
		_prone_animation_override = &""
		if _animation_tree:
			_animation_tree.active = true
		return false
	if _animation_tree:
		_animation_tree.active = false
	# Keep the previous pose as the blend source. Stopping first discards that
	# pose and makes the camera-bearing skeleton snap to frame zero.
	player.play(_prone_animation_override, PRONE_LOCOMOTION_BLEND_TIME)
	player.seek(0.0, true)
	return true

func get_prone_transition_length(kind: String) -> float:
	var player := _prone_player()
	if not player:
		return 0.0
	var anim := &"prone_enter/mixamo_com" if kind == "enter" else &"prone_exit/mixamo_com"
	var clip := player.get_animation(anim) if player.has_animation(anim) else null
	return clip.length if clip else 0.0

func clear_prone_override() -> void:
	_prone_animation_override = &""
	if _animator:
		_animator.stop()
	if _animation_tree:
		_animation_tree.active = true
		if _playback:
			_playback.start(SM_IDLE, true)
	_state = State.IDLE

func play_prone_idle() -> void:
	var player := _prone_player()
	if not player:
		return
	var anim: StringName = &"prone_idle/mixamo_com"
	if not player.has_animation(anim):
		clear_prone_override()
		return
	_play_prone_clip(player, anim, true, PRONE_LOCOMOTION_BLEND_TIME)

func play_prone_roll(left: bool) -> float:
	var player := _prone_player()
	if not player:
		return 0.0
	var anim: StringName = &"roll_left/mixamo_com" if left else &"prone_roll/mixamo_com"
	if not player.has_animation(anim):
		play_prone_idle()
		return 0.0
	var clip := player.get_animation(anim)
	_play_prone_clip(player, anim, false, PRONE_LOCOMOTION_BLEND_TIME)
	player.seek(0.0, true)
	return clip.length


func is_prone_roll_playing() -> bool:
	if _prone_animation_override not in [&"roll_left/mixamo_com", &"prone_roll/mixamo_com"]:
		return false
	var player := _prone_player()
	return player != null and player.is_playing()

func update_prone_motion(input_dir: Vector2, has_input: bool) -> void:
	if _prone_turn_release_pending:
		_prone_turn_release_pending = false
		return
	var player := _prone_player()
	if not player:
		return
	var anim: StringName = &"prone_idle/mixamo_com"
	if has_input:
		if abs(input_dir.x) > abs(input_dir.y):
			anim = get_prone_lateral_clip(input_dir.x < 0.0)
		elif input_dir.y < 0.0:
			anim = &"prone_forward/mixamo_com"
		else:
			anim = &"prone_backward/mixamo_com"
	if not player.has_animation(anim):
		anim = &"prone_idle/mixamo_com"
	if not player.has_animation(anim):
		clear_prone_override()
		return
	_play_prone_clip(player, anim, true, PRONE_LOCOMOTION_BLEND_TIME)


func _play_prone_clip(
	player: AnimationPlayer,
	anim: StringName,
	loop: bool,
	blend_time: float
) -> void:
	if not player or not player.has_animation(anim):
		return
	if _animation_tree:
		_animation_tree.active = false
	var clip := player.get_animation(anim)
	clip.loop_mode = Animation.LOOP_LINEAR if loop else Animation.LOOP_NONE
	_prone_animation_override = anim
	if player.current_animation != anim:
		player.play(anim, blend_time)


func get_prone_animation_name() -> StringName:
	return _prone_animation_override


## Returns the authored left/right prone clip shared by lateral locomotion and
## the separate in-place turn controller.
func get_prone_lateral_clip(left: bool) -> StringName:
	return PRONE_LATERAL_LEFT_CLIP if left else PRONE_LATERAL_RIGHT_CLIP


func begin_external_turn(turn_state: State, playback_speed: float) -> void:
	_external_turn_active = true
	_external_turn_position = 0.0
	_direct_prone_turn = turn_state in [State.PRONE_TURN_LEFT, State.PRONE_TURN_RIGHT]
	if _direct_prone_turn:
		var player := _prone_player()
		var clip := _state_to_animation_name(turn_state)
		if player and player.has_animation(clip):
			_state = turn_state
			if _animation_tree:
				_animation_tree.active = false
			_prone_animation_override = clip
			# Prone lateral crawl and prone turn share authored resources. Blend
			# into the turn clip so a large-look turn never hard-cuts the head.
			player.play(clip, PRONE_LOCOMOTION_BLEND_TIME)
			player.seek(0.0, true)
		else:
			_external_turn_active = false
			_direct_prone_turn = false
			return
	else:
		_transition(turn_state)
	set_turn_playback_speed(playback_speed)


func end_external_turn() -> void:
	if not _external_turn_active:
		return
	_external_turn_active = false
	_external_turn_position = 0.0
	set_turn_playback_speed(1.0)
	if _direct_prone_turn:
		_prone_turn_release_pending = true
		_direct_prone_turn = false
		_state = State.IDLE
		# A Z/C input can begin an authored prone exit on the same frame that
		# TurnController observes the new transition and cancels its turn.  Do not
		# replace that exit clip with idle while releasing the old turn ownership.
		var stance_controller = _player.get("stance_controller") if _player else null
		var stance_transitioning: bool = stance_controller != null \
				and stance_controller.is_prone_transitioning()
		if not stance_transitioning:
			play_prone_idle()
	else:
		_transition(_resolve_ground_state())


func get_turn_clip_length(turn_state: State) -> float:
	var animator := _prone_player()
	if not animator:
		return 0.0
	var animation := animator.get_animation(_state_to_animation_name(turn_state))
	return animation.length if animation else 0.0


func get_turn_playback_progress(clip_length: float) -> float:
	if not _playback or clip_length <= 0.0:
		return 1.0
	return _external_turn_position / clip_length


func advance_external_turn(delta: float) -> void:
	if not _external_turn_active:
		return
	# 当前 Godot 版本的 AnimationNodeStateMachinePlayback 没有 seek()；
	# 用独立时间累计控制身体转向，AnimationPlayer 负责同步播放动画。
	if delta <= 0.0:
		# 兼容调试脚本/外部调用：让状态机已经自然播放的进度可被读取。
		if _direct_prone_turn:
			var player := _prone_player()
			_external_turn_position = player.current_animation_position if player else 0.0
		elif _playback:
			_external_turn_position = _playback.get_current_play_position()
		return
	_external_turn_position += maxf(delta, 0.0) * _external_turn_speed


func set_turn_playback_speed(speed: float) -> void:
	_external_turn_speed = maxf(speed, 0.01)
	var animator := _animator
	if not animator and _animation_tree:
		animator = _animation_tree.get_node_or_null(_animation_tree.anim_player) as AnimationPlayer
	if animator:
		animator.speed_scale = _external_turn_speed

func get_turn_playback_speed() -> float:
	return _external_turn_speed


func _state_to_animation_name(state: State) -> StringName:
	match state:
		State.TURN_LEFT: return &"turn_left/mixamo_com"
		State.TURN_RIGHT: return &"turn_right/mixamo_com"
		State.CROUCH_TURN_LEFT: return &"crouch_turn_left/mixamo_com"
		State.CROUCH_TURN_RIGHT: return &"crouch_turn_right/mixamo_com"
		State.PRONE_TURN_LEFT: return get_prone_lateral_clip(true)
		State.PRONE_TURN_RIGHT: return get_prone_lateral_clip(false)
	return &""


func _accumulate_turn_yaw() -> void:
	var current_yaw := _player.rotation.y
	_accumulated_turn_yaw += angle_difference(_last_observed_yaw, current_yaw)
	_last_observed_yaw = current_yaw


func _reset_turn_tracking() -> void:
	_last_observed_yaw = _player.rotation.y if is_instance_valid(_player) else 0.0
	_accumulated_turn_yaw = 0.0


func _is_turn_state(state: State) -> bool:
	return state in [
		State.TURN_LEFT,
		State.TURN_RIGHT,
		State.CROUCH_TURN_LEFT,
		State.CROUCH_TURN_RIGHT,
		State.PRONE_TURN_LEFT,
		State.PRONE_TURN_RIGHT,
	]


func _state_to_sm_name(state: State) -> String:
	match state:
		State.IDLE:        return SM_IDLE
		State.WALK:        return SM_WALK
		State.CROUCH_WALK: return SM_CROUCH_WALK
		State.RUN:         return SM_RUN
		State.SPRINT:      return SM_SPRINT
		State.JUMP:        return SM_JUMP
		State.FALL:        return SM_FALL
		State.LAND:        return SM_LAND
		State.DEATH:       return SM_DEATH
		State.TURN_LEFT:   return SM_TURN_LEFT
		State.TURN_RIGHT:  return SM_TURN_RIGHT
		State.CROUCH_TURN_LEFT:  return SM_CROUCH_TURN_LEFT
		State.CROUCH_TURN_RIGHT: return SM_CROUCH_TURN_RIGHT
		State.PRONE_TURN_LEFT: return SM_PRONE_TURN_LEFT
		State.PRONE_TURN_RIGHT: return SM_PRONE_TURN_RIGHT
	return SM_IDLE
