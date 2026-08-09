extends CanvasLayer

# 死亡后逐渐黑屏+模糊，进入自由视角时恢复
# 作为 Autoload 注册，名称 DeathScreen

const BLUR_SHADER_PATH := "res://assets/shaders/death_blur.gdshader"

## 黑屏动画总时长（秒）
@export var fade_duration: float = 3.0
## 模糊最大强度（对应 shader blur_amount）
@export var max_blur: float = 4.0
## 黑屏最大不透明度（0~1）
@export var max_dark: float = 0.85
## 恢复动画时长（秒）
@export var restore_duration: float = 0.6

var _blur_rect: ColorRect
var _dark_rect: ColorRect
var _tween: Tween


func _ready() -> void:
	layer = 9  # 在游戏画面之上，在 KeyPromptManager(10) 之下

	# 模糊层：全屏 ColorRect + shader，modulate.a 控制叠加量
	_blur_rect = ColorRect.new()
	_blur_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	_blur_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_blur_rect.modulate.a = 0.0
	var mat := ShaderMaterial.new()
	mat.shader = load(BLUR_SHADER_PATH)
	mat.set_shader_parameter("blur_amount", 0.0)
	_blur_rect.material = mat
	add_child(_blur_rect)

	# 暗化层：全屏黑色 ColorRect，alpha 0 开始
	_dark_rect = ColorRect.new()
	_dark_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	_dark_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_dark_rect.color = Color(0, 0, 0, 1)
	_dark_rect.modulate.a = 0.0
	add_child(_dark_rect)


# 死亡时调用，开始渐黑+模糊
func play_death(duration: float = -1.0) -> void:
	var dur := duration if duration > 0.0 else fade_duration
	_kill_tween()
	_tween = create_tween().set_parallel(true)

	# 黑屏渐入
	_tween.tween_property(_dark_rect, "modulate:a", max_dark, dur)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)

	# 模糊渐强（通过 shader parameter）
	var mat := _blur_rect.material as ShaderMaterial
	if mat:
		_tween.tween_method(
			func(v: float): mat.set_shader_parameter("blur_amount", v),
			0.0, max_blur, dur
		).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		_blur_rect.modulate.a = 1.0


# 进入自由视角时调用，快速恢复
func restore(duration: float = -1.0) -> void:
	var dur := duration if duration > 0.0 else restore_duration
	_kill_tween()
	_tween = create_tween().set_parallel(true)

	_tween.tween_property(_dark_rect, "modulate:a", 0.0, dur)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

	var mat := _blur_rect.material as ShaderMaterial
	if mat:
		_tween.tween_method(
			func(v: float): mat.set_shader_parameter("blur_amount", v),
			max_blur, 0.0, dur
		).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	_tween.tween_property(_blur_rect, "modulate:a", 0.0, dur)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)


func _kill_tween() -> void:
	if _tween:
		_tween.kill()
