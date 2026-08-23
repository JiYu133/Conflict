extends Node3D

const SETTINGS_SERVICE_SCRIPT := preload("res://classes/ui/settings/settings_service.gd")
const SETTINGS_MENU_SCRIPT := preload("res://classes/ui/settings/settings_menu.gd")
const CREDITS_SCENE := preload("res://assets/credits.tscn")
const GAME_SCENE := "res://assets/map/TestMap.tscn"
const MAP_LOADING_IMAGE_PATH := "res://assets/map/previews/test_map_preview.png"
const DEPLOYMENT_CONTROL_LOCK := "title_deployment"
const MAP_LOADING_INFO := {
	"title": "测试区域  /  北线设施",
	"history": "北线设施曾是边境运输网络的中转节点。冲突升级后，原有秩序迅速瓦解，留下被临时改造的防御工事与无人值守的通道。",
	"tips": [
		"保持移动，暴露在开阔地带会增加交战风险。",
		"按 V 可切换武器的射击模式。",
		"按 R 重新装填，换弹前确认掩体位置。",
		"按 H 打开医疗径向菜单。",
	]
}

@onready var menu_root: Control = $UI/MenuRoot
@onready var title_backdrop: TitleBackdropController = $Backdrop
@onready var menu: VBoxContainer = $UI/MenuRoot/Content
@onready var fade: ColorRect = $UI/Fade
@onready var status: Label = $UI/MenuRoot/Content/Status
@onready var transition_animation: AnimationPlayer = $UI/TransitionAnimation
@onready var loading_layer: Control = $UI/LoadingLayer
@onready var loading_screen: LoadingScreen = $UI/LoadingLayer
@onready var menu_music: AudioStreamPlayer = $UI/MenuMusic

var _settings_service: Node
var _settings_menu: Node
var _credits: Node
var _prepared_game_scene: Node
var _transitioning := false
var _credits_close_pending := false
var _menu_music_filter: AudioEffectLowPassFilter
var _menu_music_tween: Tween
var _music_phase := "title"

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_settings_service = SETTINGS_SERVICE_SCRIPT.new()
	add_child(_settings_service)
	_settings_service.initialize()
	_settings_service.value_changed.connect(_on_setting_changed)
	_setup_menu_music()
	$UI/MenuRoot/Content/ContinueButton.disabled = true
	$UI/MenuRoot/Content/ContinueButton.tooltip_text = "暂无存档"
	$UI/MenuRoot/Content/ContinueButton.focus_mode = Control.FOCUS_NONE
	$UI/MenuRoot/Content/StartButton.grab_focus()
	$UI/MenuRoot/Content/StartButton.pressed.connect(_start_game)
	$UI/MenuRoot/Content/SettingsButton.pressed.connect(_open_settings)
	$UI/MenuRoot/Content/CreditsButton.pressed.connect(_open_credits)
	$UI/MenuRoot/Content/QuitButton.pressed.connect(_quit_game)
	loading_screen.deploy_requested.connect(_on_loading_deploy)
	loading_screen.deployment_started.connect(_on_deployment_started)
	menu_root.modulate.a = 0.0
	var menu_tween := create_tween()
	menu_tween.tween_property(menu_root, "modulate:a", 1.0, 0.65)

func _open_settings() -> void:
	if _settings_menu:
		return
	_settings_menu = SETTINGS_MENU_SCRIPT.new()
	_settings_menu.title_mode = true
	add_child(_settings_menu)
	_settings_menu.initialize(_settings_service, null, true)
	_settings_menu.closed.connect(_on_settings_closed)
	_settings_menu.open()
	menu_root.visible = false

func _on_settings_closed() -> void:
	if is_instance_valid(_settings_menu):
		_settings_menu.queue_free()
	_settings_menu = null
	menu_root.visible = true
	$UI/MenuRoot/Content/SettingsButton.grab_focus()

func _open_credits() -> void:
	if _credits or _transitioning:
		return
	_transitioning = true
	menu_root.visible = false
	transition_animation.play("cinematic_black_in")
	await transition_animation.animation_finished
	_credits = CREDITS_SCENE.instantiate()
	add_child(_credits)
	_credits.return_requested.connect(_on_credits_closed)
	transition_animation.play("cinematic_black_out")
	await transition_animation.animation_finished
	title_backdrop.play_credits_orbit()
	_transitioning = false
	if _credits_close_pending:
		_credits_close_pending = false
		_on_credits_closed()

func _on_credits_closed() -> void:
	if _transitioning:
		_credits_close_pending = true
		return
	_transitioning = true
	transition_animation.play("cinematic_black_in")
	await transition_animation.animation_finished
	if _credits:
		_credits.queue_free()
		_credits = null
	title_backdrop.play_default_drift()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	menu_root.visible = true
	$UI/MenuRoot/Content/CreditsButton.grab_focus()
	transition_animation.play("cinematic_black_out")
	await transition_animation.animation_finished
	_transitioning = false

func _start_game() -> void:
	if _transitioning:
		return
	_transitioning = true
	menu_root.visible = false
	loading_layer.visible = true
	_set_music_phase("loading", 0.45)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	var map_loading_image := ResourceLoader.load(MAP_LOADING_IMAGE_PATH) as Texture2D
	loading_screen.configure_map(
		MAP_LOADING_INFO["title"],
		MAP_LOADING_INFO["history"],
		MAP_LOADING_INFO["tips"],
		map_loading_image
	)
	loading_screen.show_loading()
	loading_screen.set_progress(0.0)
	transition_animation.play("cinematic_black_in")
	await transition_animation.animation_finished
	transition_animation.play("cinematic_black_out")
	await transition_animation.animation_finished
	var request_error := ResourceLoader.load_threaded_request(GAME_SCENE, "PackedScene")
	if request_error != OK:
		loading_screen.show_error("场景加载失败 (%d)" % request_error)
		_transitioning = false
		return
	while true:
		var progress := [0.0]
		var load_status := ResourceLoader.load_threaded_get_status(GAME_SCENE, progress)
		loading_screen.set_progress(progress[0] * 100.0)
		match load_status:
			ResourceLoader.THREAD_LOAD_LOADED:
				var packed_scene := ResourceLoader.load_threaded_get(GAME_SCENE) as PackedScene
				if packed_scene:
					_prepared_game_scene = packed_scene.instantiate()
					_prepared_game_scene.process_mode = Node.PROCESS_MODE_INHERIT
					if _prepared_game_scene is Node3D:
						(_prepared_game_scene as Node3D).visible = false
					get_tree().root.add_child(_prepared_game_scene)
					_prepared_game_scene.process_mode = Node.PROCESS_MODE_DISABLED
					_hold_prepared_player()
					await get_tree().process_frame
					await get_tree().process_frame
					loading_screen.show_ready()
					await loading_screen.deploy_requested
					_release_prepared_player()
					_prepared_game_scene.process_mode = Node.PROCESS_MODE_INHERIT
					_prepared_game_scene.call("arm_deployment_activation")
					if _prepared_game_scene is Node3D:
						(_prepared_game_scene as Node3D).visible = true
					_prepared_game_scene.get_parent().remove_child(_prepared_game_scene)
					get_tree().change_scene_to_node(_prepared_game_scene)
				else:
					loading_screen.show_error("场景资源无效")
					_transitioning = false
				return
			ResourceLoader.THREAD_LOAD_FAILED, ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
				loading_screen.show_error("场景加载失败")
				_transitioning = false
				return
		await get_tree().process_frame

func _on_loading_deploy() -> void:
	# The loading coroutine owns the prepared scene and performs the switch.
	return

func _setup_menu_music() -> void:
	var bus_index := AudioServer.get_bus_index("MenuMusic")
	if bus_index < 0:
		AudioServer.add_bus()
		bus_index = AudioServer.bus_count - 1
		AudioServer.set_bus_name(bus_index, "MenuMusic")
	if AudioServer.get_bus_effect_count(bus_index) == 0:
		_menu_music_filter = AudioEffectLowPassFilter.new()
		_menu_music_filter.cutoff_hz = 18000.0
		AudioServer.add_bus_effect(bus_index, _menu_music_filter)
	else:
		_menu_music_filter = AudioServer.get_bus_effect(bus_index, 0) as AudioEffectLowPassFilter
	menu_music.bus = "MenuMusic"
	menu_music.volume_db = -60.0
	_menu_music_filter.cutoff_hz = 18000.0
	if not menu_music.finished.is_connected(_on_menu_music_finished):
		menu_music.finished.connect(_on_menu_music_finished)
	menu_music.play()
	_set_music_phase("title", 1.15)

func _on_menu_music_finished() -> void:
	if is_instance_valid(menu_music):
		menu_music.play()

func _on_deployment_started() -> void:
	_set_music_phase("deployment", 0.45)

func _on_setting_changed(key: String, _value: Variant) -> void:
	if key in ["audio/menu_music_volume", "audio/loading_music_volume", "audio/loading_muffle"]:
		_set_music_phase(_music_phase, 0.16)

func _set_music_phase(phase: String, duration: float) -> void:
	_music_phase = phase
	if _menu_music_tween and _menu_music_tween.is_valid():
		_menu_music_tween.kill()
	var target_volume_db := -60.0
	var target_cutoff_hz := 18000.0
	match phase:
		"title":
			target_volume_db = _music_db("audio/menu_music_volume", 0.75)
		"loading":
			target_volume_db = _music_db("audio/loading_music_volume", 0.38)
			target_cutoff_hz = _loading_music_cutoff()
		"deployment":
			target_volume_db = -60.0
			target_cutoff_hz = _loading_music_cutoff()
	_menu_music_tween = create_tween()
	_menu_music_tween.set_parallel()
	_menu_music_tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	_menu_music_tween.tween_property(menu_music, "volume_db", target_volume_db, duration)
	if _menu_music_filter:
		_menu_music_tween.tween_property(_menu_music_filter, "cutoff_hz", target_cutoff_hz, duration)

func _music_db(key: String, fallback: float) -> float:
	var linear_volume := clampf(float(_settings_service.get_value(key, fallback)), 0.0, 1.0)
	return -60.0 if linear_volume <= 0.001 else linear_to_db(linear_volume)

func _loading_music_cutoff() -> float:
	var muffle := clampf(float(_settings_service.get_value("audio/loading_muffle", 0.70)), 0.0, 1.0)
	return lerpf(18000.0, 900.0, muffle)

func _hold_prepared_player() -> void:
	var player := _prepared_game_scene.find_child("CharacterBody3D", true, false) as BasePlayer
	if not player:
		return
	player.acquire_control_lock(DEPLOYMENT_CONTROL_LOCK)
	player.request_mouse_mode(DEPLOYMENT_CONTROL_LOCK, Input.MOUSE_MODE_VISIBLE, 200)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _release_prepared_player() -> void:
	var player := _prepared_game_scene.find_child("CharacterBody3D", true, false) as BasePlayer
	if not player:
		return
	player.release_control_lock(DEPLOYMENT_CONTROL_LOCK)
	player.release_mouse_mode(DEPLOYMENT_CONTROL_LOCK)

func _quit_game() -> void:
	get_tree().quit()
