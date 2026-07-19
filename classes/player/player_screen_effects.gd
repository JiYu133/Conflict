class_name PlayerScreenEffects
extends Node

# ============================================================
# 玩家屏幕效果系统
# 效果层级（CanvasLayer.layer）：
#   1  UI CanvasLayer — vignette(z=9)、模糊(z=10)、MedicalDebugHUD
#   8  ComaEffect     — 昏迷眼皮（独立 CanvasLayer，由 base_player 创建）
#   9  _death_canvas  — 死亡全屏渐黑（动态创建）
#   10 NotificationManager — 通知，永远最顶
# ============================================================

## 喘气音效预留接口
signal should_play_breath(intensity: float)

# ── 体力/疼痛效果参数 ────────────────────────────────────────
const BLUR_PULSE_DECAY: float = 1.5
const MAX_PULSE_BLUR: float = 3.5
const MAX_BASE_BLUR: float = 1.2
const STAMINA_BLUR_START: float = 0.4
const STAMINA_VIGNETTE_START: float = 0.6
const MAX_VIGNETTE_ALPHA: float = 0.75

# ── 死亡渐黑参数 ────────────────────────────────────────────
const DEATH_FADE_TIME: float = 1.2
const DEATH_BLUR_MAX: float = 8.0

# ── 节点引用 ────────────────────────────────────────────────
var _blur_rect: ColorRect = null
var _vignette_rect: ColorRect = null
var _death_canvas: CanvasLayer = null   # layer=9，独立于 UI CanvasLayer
var _death_rect: ColorRect = null

# ── 内部状态 ────────────────────────────────────────────────
var _player: BasePlayer = null

# 疼痛/体力模糊
var _blur_pulse: float = 0.0
var _blur_base: float = 0.0
var _blur_base_target: float = 0.0
var _current_pain: float = 0.0

# 昏迷模糊（独立叠加，不与体力/疼痛基底混用）
const UNCONSCIOUS_BLUR: float = 2.5
var _unconscious_blur_active: bool = false

# 体力 vignette
var _vignette_current: float = 0.0
var _vignette_target: float = 0.0

# 死亡渐黑
var _death_progress: float = 0.0
var _death_active: bool = false


# ── 初始化 ──────────────────────────────────────────────────
func initialize(player: BasePlayer) -> void:
	_player = player

func _ready() -> void:
	await get_tree().process_frame
	var canvas := _find_ui_canvas()
	if canvas:
		_setup_overlay_nodes(canvas)
	else:
		GlobalLogger.warn("ScreenEffects", "UI CanvasLayer not found — screen effects disabled")


# ── 每帧更新 ────────────────────────────────────────────────
func _process(delta: float) -> void:
	if not _blur_rect:
		return
	_update_stamina_blur(delta)
	_update_death_fade(delta)


func _update_stamina_blur(delta: float) -> void:
	_blur_pulse = move_toward(_blur_pulse, 0.0, delta / BLUR_PULSE_DECAY)
	_blur_base = lerp(_blur_base, _blur_base_target, delta * 3.0)

	var final_blur := _blur_pulse + _blur_base
	if _unconscious_blur_active:
		final_blur = maxf(final_blur, UNCONSCIOUS_BLUR)
	if _death_active:
		final_blur = maxf(final_blur, ease(_death_progress, -2.0) * DEATH_BLUR_MAX)
	(_blur_rect.material as ShaderMaterial).set_shader_parameter("blur_amount", final_blur)
	_blur_rect.visible = final_blur > 0.001

	_vignette_current = lerp(_vignette_current, _vignette_target, delta * 2.0)
	var mat := _vignette_rect.material as ShaderMaterial
	mat.set_shader_parameter("strength", _vignette_current)
	mat.set_shader_parameter("inner_radius", 0.4)
	mat.set_shader_parameter("outer_radius", 1.2)
	_vignette_rect.visible = _vignette_current > 0.005


func _update_death_fade(delta: float) -> void:
	if not _death_active or not _death_rect:
		return
	_death_progress = minf(_death_progress + delta / DEATH_FADE_TIME, 1.0)
	_death_rect.modulate.a = ease(_death_progress, -2.0)
	_death_rect.visible = _death_progress > 0.001


# ── 公开 API ────────────────────────────────────────────────

## 昏迷：启用持续模糊
func trigger_unconscious_blur() -> void:
	_unconscious_blur_active = true

## 死亡：渐黑 + 模糊
func trigger_death_blur() -> void:
	_unconscious_blur_active = false
	_death_active = true
	_death_progress = 0.0

## 复活/恢复意识：清除所有覆盖
func clear_death_blur() -> void:
	_unconscious_blur_active = false
	_death_active = false
	_death_progress = 0.0
	if _death_rect:
		_death_rect.modulate.a = 0.0
		_death_rect.visible = false
	_blur_pulse = 0.0
	_vignette_target = 0.0
	_vignette_current = 0.0


# ── 信号回调 ────────────────────────────────────────────────

func _on_damage_taken(info: DamageInfo) -> void:
	var ke_ref := 600.0
	var pulse_strength := (info.amount / ke_ref) * MAX_PULSE_BLUR * 0.5
	pulse_strength = maxf(pulse_strength, _current_pain * MAX_PULSE_BLUR * 0.6)
	_blur_pulse = maxf(_blur_pulse, pulse_strength)

func _on_pain_changed(level: float) -> void:
	_current_pain = level
	var pain_base := maxf(0.0, (level - 0.5) * 2.0) * (MAX_BASE_BLUR * 0.3)
	_blur_base_target = maxf(_blur_base_target, pain_base)

func _on_stamina_changed(pct: float) -> void:
	if pct < STAMINA_VIGNETTE_START:
		_vignette_target = (1.0 - pct / STAMINA_VIGNETTE_START) * MAX_VIGNETTE_ALPHA
	else:
		_vignette_target = 0.0

	if pct < STAMINA_BLUR_START:
		var stamina_base := (1.0 - pct / STAMINA_BLUR_START) * MAX_BASE_BLUR
		_blur_base_target = maxf(_current_pain * MAX_BASE_BLUR * 0.3, stamina_base)
	else:
		_blur_base_target = maxf(0.0, (_current_pain - 0.5) * 2.0 * MAX_BASE_BLUR * 0.3)


# ── 私有工具 ────────────────────────────────────────────────

func _find_ui_canvas() -> CanvasLayer:
	if not get_tree():
		return null
	return _find_canvas_recursive(get_tree().root)

func _find_canvas_recursive(node: Node) -> CanvasLayer:
	if node is CanvasLayer and node.name == "UI":
		return node as CanvasLayer
	for child in node.get_children():
		var result := _find_canvas_recursive(child)
		if result:
			return result
	return null

func _setup_overlay_nodes(canvas: CanvasLayer) -> void:
	# z=9  体力 vignette（在 UI CanvasLayer 内）
	_vignette_rect = _make_fullscreen_rect(canvas, "StaminaVignetteRect", 9,
		load("res://res/shaders/vignette.gdshader"))

	# z=10 疼痛/体力模糊（在 UI CanvasLayer 内）
	_blur_rect = _make_fullscreen_rect(canvas, "PainBlurRect", 10,
		load("res://res/shaders/death_blur.gdshader"))

	# 死亡渐黑独立 CanvasLayer(layer=9)，高于眼皮(8)、低于通知(10)
	_death_canvas = CanvasLayer.new()
	_death_canvas.name = "DeathFadeCanvas"
	_death_canvas.layer = 9
	get_tree().root.add_child(_death_canvas)

	_death_rect = ColorRect.new()
	_death_rect.name = "DeathFadeRect"
	_death_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_death_rect.color = Color(0.0, 0.0, 0.0, 1.0)
	_death_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_death_rect.modulate.a = 0.0
	_death_rect.visible = false
	_death_canvas.add_child(_death_rect)

	GlobalLogger.info("ScreenEffects", "Overlay nodes created.")


func _make_fullscreen_rect(canvas: CanvasLayer, node_name: String, z: int, shader: Shader) -> ColorRect:
	var rect := ColorRect.new()
	rect.name = node_name
	rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var mat := ShaderMaterial.new()
	mat.shader = shader
	rect.material = mat
	rect.z_index = z
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	rect.visible = false
	canvas.add_child(rect)
	return rect
