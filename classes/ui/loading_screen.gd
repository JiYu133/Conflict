class_name LoadingScreen
extends Control

## 可复用的场景加载展示组件。加载线程由宿主控制，本组件只负责反馈。

@onready var map_title: Label = $LoadingContent/ContentLayout/InfoColumn/MapTitle
@onready var map_image: TextureRect = $LoadingContent/ContentLayout/ImageColumn/MapImage
@onready var image_slot_hint: Label = $LoadingContent/ContentLayout/ImageColumn/MapImage/ImageSlotHint
@onready var history: Label = $LoadingContent/ContentLayout/InfoColumn/History
@onready var tip: Label = $LoadingContent/ContentLayout/InfoColumn/Tip
@onready var status: Label = $LoadingContent/ContentLayout/InfoColumn/Status
@onready var progress: ProgressBar = $LoadingContent/ContentLayout/InfoColumn/Progress
@onready var actions: HBoxContainer = $LoadingContent/ContentLayout/InfoColumn/Actions
@onready var deploy_button: Button = $LoadingContent/ContentLayout/InfoColumn/Actions/DeployButton
@onready var deployment_overlay: Control = $DeploymentOverlay
@onready var deployment_background: TextureRect = $DeploymentOverlay/Background
@onready var deployment_countdown: Label = $DeploymentOverlay/Countdown
@onready var deployment_fade: ColorRect = $DeploymentFade
@onready var loading_content: Control = $LoadingContent

signal deploy_requested
signal deployment_started

var _tips: Array[String] = []
var _tip_index := 0
var _tip_elapsed := 0.0
var _status_elapsed := 0.0
var _deploying := false

@export var default_map_image: Texture2D

func _ready() -> void:
	deploy_button.pressed.connect(_begin_deployment)
	actions.visible = false
	map_image.texture = default_map_image
	_refresh_image_placeholder()
	deployment_overlay.visible = false
	loading_content.visible = true
	deployment_fade.color.a = 0.0

func show_loading() -> void:
	_deploying = false
	deployment_overlay.visible = false
	loading_content.visible = true
	loading_content.modulate.a = 0.0
	deployment_fade.color.a = 0.0
	progress.visible = true
	progress.modulate.a = 1.0
	actions.visible = false
	actions.modulate.a = 0.0
	set_status("正在准备测试区域")
	_fade_control(loading_content, 1.0, 0.45)

func show_ready() -> void:
	progress.value = 100.0
	var tween := create_tween()
	tween.set_parallel()
	tween.tween_property(progress, "modulate:a", 0.0, 0.28)
	actions.visible = true
	tween.tween_property(actions, "modulate:a", 1.0, 0.42).set_delay(0.16)
	tween.chain().tween_callback(func(): progress.visible = false)
	set_status("区域已准备完毕")
	deploy_button.grab_focus()

func _begin_deployment() -> void:
	if _deploying:
		return
	_deploying = true
	deploy_button.disabled = true
	deployment_background.texture = map_image.texture
	loading_content.visible = false
	deployment_overlay.visible = true
	deployment_started.emit()
	deployment_fade.color.a = 1.0
	await _fade_deployment_screen(0.0, 0.55)
	var start_usec := Time.get_ticks_usec()
	const COUNTDOWN_USEC := 5_000_000
	while true:
		var elapsed_usec := Time.get_ticks_usec() - start_usec
		var remaining_usec: int = maxi(0, COUNTDOWN_USEC - elapsed_usec)
		var total_seconds := remaining_usec / 1_000_000
		var minutes := total_seconds / 60
		var seconds := total_seconds % 60
		var milliseconds := (remaining_usec / 1000) % 1000
		deployment_countdown.text = "%02d:%02d:%03d" % [minutes, seconds, milliseconds]
		if remaining_usec <= 0:
			break
		await get_tree().process_frame
	await _fade_deployment_screen(1.0, 0.45)
	deploy_requested.emit()

func _fade_deployment_screen(target_alpha: float, duration: float) -> void:
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(deployment_fade, "color:a", target_alpha, duration)
	await tween.finished

func _fade_control(control: Control, target_alpha: float, duration: float) -> void:
	var tween := create_tween()
	tween.tween_property(control, "modulate:a", target_alpha, duration)

func configure_map(title: String, history_text: String, tips: Array, image: Texture2D = null) -> void:
	map_title.text = title
	history.text = history_text
	map_image.texture = image if image else default_map_image
	_refresh_image_placeholder()
	_tips.clear()
	for item in tips:
		_tips.append(String(item))
	_tip_index = 0
	_tip_elapsed = 0.0
	_refresh_tip()

func set_status(message: String) -> void:
	status.text = message
	_status_elapsed = 0.0

func set_progress(value: float) -> void:
	progress.value = clampf(value, 0.0, 100.0)

func show_error(message: String) -> void:
	set_status(message)
	progress.value = 0.0

func _process(delta: float) -> void:
	# 轮播提示和状态省略号让异步加载期间始终有活跃反馈。
	_tip_elapsed += delta
	_status_elapsed += delta
	if _tips.size() > 1 and _tip_elapsed >= 4.0:
		_tip_elapsed = 0.0
		_tip_index = (_tip_index + 1) % _tips.size()
		_refresh_tip()
	if _status_elapsed >= 0.45 and status.text.ends_with("..."):
		_status_elapsed = 0.0
		status.text = status.text.trim_suffix("...")
	elif _status_elapsed >= 0.45 and status.text != "" and not status.text.ends_with("..."):
		_status_elapsed = 0.0
		status.text += "."

func _refresh_tip() -> void:
	if _tips.is_empty():
		tip.text = ""
	else:
		tip.text = "TIP  /  " + _tips[_tip_index]

func _refresh_image_placeholder() -> void:
	image_slot_hint.visible = map_image.texture == null
