extends Node

# 应用生命周期管理：窗口关闭、全屏切换、FPS 显示

var _fps_label: Label


func _ready() -> void:
	get_tree().set_auto_accept_quit(false)
	get_viewport().get_window().close_requested.connect(_on_close_requested)
	_setup_fps_label()


func _setup_fps_label() -> void:
	var canvas := CanvasLayer.new()
	canvas.layer = 128
	add_child(canvas)

	_fps_label = Label.new()
	_fps_label.position = Vector2(8, 8)
	_fps_label.add_theme_font_size_override("font_size", 16)
	_fps_label.add_theme_color_override("font_color", Color.WHITE)
	_fps_label.add_theme_color_override("font_shadow_color", Color.BLACK)
	_fps_label.add_theme_constant_override("shadow_offset_x", 1)
	_fps_label.add_theme_constant_override("shadow_offset_y", 1)
	canvas.add_child(_fps_label)


func _process(_delta: float) -> void:
	_fps_label.text = "FPS: %d" % Engine.get_frames_per_second()


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		_quit()


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		match event.physical_keycode:
			KEY_F11:
				_toggle_fullscreen()
			KEY_ENTER:
				if event.alt_pressed:
					_toggle_fullscreen()


func _on_close_requested() -> void:
	_quit()


func _toggle_fullscreen() -> void:
	var window := get_viewport().get_window()
	if window.mode == Window.MODE_EXCLUSIVE_FULLSCREEN or window.mode == Window.MODE_FULLSCREEN:
		window.mode = Window.MODE_WINDOWED
	else:
		window.mode = Window.MODE_EXCLUSIVE_FULLSCREEN


func _quit() -> void:
	get_tree().quit()
