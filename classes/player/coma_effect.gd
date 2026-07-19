class_name ComaEffect
extends CanvasLayer

# ============================================================
# 昏迷眼皮效果
# 用两个从屏幕上下边缘向中央合拢的黑色 ColorRect 模拟上下眼皮。
# 三段动画全部用代码构建，尺寸基于当前视口高度。
# 作为 BasePlayer 的子节点使用，layer=8（低于 NotificationManager 的 10）。
#
# 公开 API：
#   enter_coma()  — 闭眼 → 循环挣扎
#   wake_up()     — 停止挣扎 → 睁眼
#   die()         — 立即合拢（不播放动画，供死亡瞬间调用）
# ============================================================

# ── 动画参数 ─────────────────────────────────────────────────
## fade_in：闭眼时长（秒）
const FADE_IN_DUR: float = 1.0
## fade_out：睁眼时长（秒）
const FADE_OUT_DUR: float = 0.7
## struggle：挣扎循环时长（秒）
const STRUGGLE_DUR: float = 3.0
## 闭合时眼皮占屏幕高度的比例（留一条细缝）
const CLOSE_RATIO: float = 0.46
## struggle 期间各挣扎帧的开合比例（上眼皮，下眼皮镜像）
const STRUGGLE_KEYFRAMES: Array = [0.46, 0.35, 0.46, 0.30, 0.46, 0.40, 0.46]
const STRUGGLE_TIMES: Array   = [0.0,  0.5,  1.0,  1.5,  2.0,  2.5,  3.0]
## struggle 播放速度随机范围
const STRUGGLE_SPEED_MIN: float = 0.88
const STRUGGLE_SPEED_MAX: float = 1.12

# ── 节点引用 ─────────────────────────────────────────────────
var _upper: ColorRect = null
var _lower: ColorRect = null
var _anim: AnimationPlayer = null

# ── 状态 ─────────────────────────────────────────────────────
var _is_active: bool = false


func _ready() -> void:
	layer = 8
	_setup_nodes()
	_build_animations()
	get_viewport().size_changed.connect(_on_viewport_size_changed)


# ── 公开 API ────────────────────────────────────────────────

## 进入昏迷：播放闭眼动画，结束后循环挣扎
func enter_coma() -> void:
	_is_active = true
	visible = true
	_anim.play("fade_in")
	await _anim.animation_finished
	if _is_active:
		_anim.speed_scale = randf_range(STRUGGLE_SPEED_MIN, STRUGGLE_SPEED_MAX)
		_anim.play("struggle")

## 被唤醒：停止挣扎，播放睁眼动画
func wake_up() -> void:
	_is_active = false
	_anim.speed_scale = 1.0
	_anim.play("fade_out")
	await _anim.animation_finished
	visible = false

## 死亡：立即合拢眼皮，不播放动画
func die() -> void:
	_is_active = false
	_anim.stop()
	_anim.speed_scale = 1.0
	var h := float(get_viewport().size.y)
	_upper.size.y = h * CLOSE_RATIO
	_lower.size.y = h * CLOSE_RATIO
	visible = true


# ── 私有构建 ────────────────────────────────────────────────

func _setup_nodes() -> void:
	var h := float(get_viewport().size.y)
	var w := float(get_viewport().size.x)

	# 上眼皮：锚在顶部，高度从 0 向下增长
	_upper = ColorRect.new()
	_upper.name = "UpperEyelid"
	_upper.color = Color(0.0, 0.0, 0.0, 1.0)
	_upper.anchor_left   = 0.0
	_upper.anchor_right  = 1.0
	_upper.anchor_top    = 0.0
	_upper.anchor_bottom = 0.0
	_upper.offset_left   = 0.0
	_upper.offset_right  = 0.0
	_upper.offset_top    = 0.0
	_upper.offset_bottom = 0.0  # 初始高度=0（睁眼）
	_upper.mouse_filter  = Control.MOUSE_FILTER_IGNORE
	add_child(_upper)

	# 下眼皮：锚在底部，高度从 0 向上增长（offset_top 为负值）
	_lower = ColorRect.new()
	_lower.name = "LowerEyelid"
	_lower.color = Color(0.0, 0.0, 0.0, 1.0)
	_lower.anchor_left   = 0.0
	_lower.anchor_right  = 1.0
	_lower.anchor_top    = 1.0
	_lower.anchor_bottom = 1.0
	_lower.offset_left   = 0.0
	_lower.offset_right  = 0.0
	_lower.offset_top    = 0.0   # 初始偏移=0（睁眼，贴底边不可见）
	_lower.offset_bottom = 0.0
	_lower.mouse_filter  = Control.MOUSE_FILTER_IGNORE
	add_child(_lower)

	_anim = AnimationPlayer.new()
	_anim.name = "AnimationPlayer"
	add_child(_anim)

	visible = false


func _build_animations() -> void:
	var h := float(get_viewport().size.y)
	var lib := AnimationLibrary.new()

	lib.add_animation("fade_in",  _make_fade_in(h))
	lib.add_animation("struggle", _make_struggle(h))
	lib.add_animation("fade_out", _make_fade_out(h))

	_anim.add_animation_library("", lib)

	# struggle 动画结束时随机调整速度，避免机械重复感
	if not _anim.animation_finished.is_connected(_on_struggle_loop):
		_anim.animation_finished.connect(_on_struggle_loop)


func _make_fade_in(h: float) -> Animation:
	var anim := Animation.new()
	anim.length = FADE_IN_DUR

	var upper_track := anim.add_track(Animation.TYPE_VALUE)
	anim.track_set_path(upper_track, "UpperEyelid:offset_bottom")
	anim.track_set_interpolation_type(upper_track, Animation.INTERPOLATION_CUBIC)
	# 0s → 0，0.3s → 15%H，0.6s → 40%H，1.0s → 46%H（Ease-In 用关键帧间距实现）
	anim.track_insert_key(upper_track, 0.0,  0.0)
	anim.track_insert_key(upper_track, 0.3,  h * 0.15)
	anim.track_insert_key(upper_track, 0.6,  h * 0.40)
	anim.track_insert_key(upper_track, FADE_IN_DUR, h * CLOSE_RATIO)

	var lower_track := anim.add_track(Animation.TYPE_VALUE)
	anim.track_set_path(lower_track, "LowerEyelid:offset_top")
	anim.track_set_interpolation_type(lower_track, Animation.INTERPOLATION_CUBIC)
	anim.track_insert_key(lower_track, 0.0,  0.0)
	anim.track_insert_key(lower_track, 0.3,  -h * 0.15)
	anim.track_insert_key(lower_track, 0.6,  -h * 0.40)
	anim.track_insert_key(lower_track, FADE_IN_DUR, -h * CLOSE_RATIO)

	return anim


func _make_struggle(h: float) -> Animation:
	var anim := Animation.new()
	anim.length = STRUGGLE_DUR
	anim.loop_mode = Animation.LOOP_LINEAR

	var upper_track := anim.add_track(Animation.TYPE_VALUE)
	anim.track_set_path(upper_track, "UpperEyelid:offset_bottom")
	anim.track_set_interpolation_type(upper_track, Animation.INTERPOLATION_CUBIC)

	var lower_track := anim.add_track(Animation.TYPE_VALUE)
	anim.track_set_path(lower_track, "LowerEyelid:offset_top")
	anim.track_set_interpolation_type(lower_track, Animation.INTERPOLATION_CUBIC)

	for i in STRUGGLE_TIMES.size():
		var t: float = STRUGGLE_TIMES[i]
		var ratio: float = STRUGGLE_KEYFRAMES[i]
		anim.track_insert_key(upper_track, t,  h * ratio)
		anim.track_insert_key(lower_track, t, -h * ratio)

	return anim


func _make_fade_out(h: float) -> Animation:
	var anim := Animation.new()
	anim.length = FADE_OUT_DUR

	var upper_track := anim.add_track(Animation.TYPE_VALUE)
	anim.track_set_path(upper_track, "UpperEyelid:offset_bottom")
	anim.track_set_interpolation_type(upper_track, Animation.INTERPOLATION_CUBIC)
	anim.track_insert_key(upper_track, 0.0,             h * CLOSE_RATIO)
	anim.track_insert_key(upper_track, 0.5,             h * 0.10)
	anim.track_insert_key(upper_track, FADE_OUT_DUR,    0.0)

	var lower_track := anim.add_track(Animation.TYPE_VALUE)
	anim.track_set_path(lower_track, "LowerEyelid:offset_top")
	anim.track_set_interpolation_type(lower_track, Animation.INTERPOLATION_CUBIC)
	anim.track_insert_key(lower_track, 0.0,             -h * CLOSE_RATIO)
	anim.track_insert_key(lower_track, 0.5,             -h * 0.10)
	anim.track_insert_key(lower_track, FADE_OUT_DUR,    0.0)

	return anim


func _on_struggle_loop(anim_name: StringName) -> void:
	if anim_name == &"struggle" and _is_active:
		_anim.speed_scale = randf_range(STRUGGLE_SPEED_MIN, STRUGGLE_SPEED_MAX)
		_anim.play(&"struggle")


func _on_viewport_size_changed() -> void:
	# 视口尺寸改变时重建动画关键帧，并同步眼皮当前位置
	var was_playing := _anim.is_playing()
	var current_anim := _anim.current_animation
	var current_pos := _anim.current_animation_position
	_build_animations()
	if was_playing and current_anim != "":
		_anim.play(current_anim)
		_anim.seek(current_pos, true)
