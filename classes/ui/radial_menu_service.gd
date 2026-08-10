extends CanvasLayer

const RadialMenuOptionScript := preload("res://classes/ui/radial_menu_option.gd")
const RadialMenuScript := preload("res://classes/ui/radial_menu.gd")
const HOLD_THRESHOLD := 0.25
const CONTROL_LOCK_OWNER := "radial_menu"
const MOUSE_OWNER := "radial_menu"

var _wheels: Dictionary = {}
var _player
var _menu: RadialMenu
var _active_action_id := ""
var _pending_action_id := ""
var _pending_time := 0.0
var _open := false
var _all_options: Array[RadialMenuOption] = []
var _page_index := 0
var _page_count := 1
var _last_mouse_position := Vector2.ZERO


func _ready() -> void:
	layer = 40
	_menu = RadialMenuScript.new() as RadialMenu
	_menu.name = "RadialMenu"
	_menu.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(_menu)
	set_process_input(true)


func set_player(player) -> void:
	if _player == player:
		return
	if _open:
		close(false)
	_player = player


func clear_player(player) -> void:
	if _player == player:
		close(false)
		_player = null


func register_wheel(action_id: String, input_action: String, short_press: Callable, provider: Callable) -> void:
	if action_id.is_empty() or input_action.is_empty() or not provider.is_valid():
		push_warning("RadialMenuService: invalid wheel registration: %s" % action_id)
		return
	_wheels[action_id] = {
		"input_action": input_action,
		"short_press": short_press,
		"provider": provider,
	}


func unregister_wheel(action_id: String) -> void:
	if _active_action_id == action_id:
		close(false)
	if _pending_action_id == action_id:
		_pending_action_id = ""
	_wheels.erase(action_id)


func open(action_id: String) -> bool:
	return _open_wheel(action_id)


func close(confirm: bool = true) -> void:
	if not _open:
		return
	var selected := _menu.get_selected_option()
	if confirm and selected and selected.id == "__radial_previous":
		_page_index = max(_page_index - 1, 0)
		_show_page()
		return
	if confirm and selected and selected.id == "__radial_next":
		_page_index = min(_page_index + 1, _page_count - 1)
		_show_page()
		return
	if confirm and selected and selected.is_enabled and selected.execute.is_valid():
		selected.execute.call()
	_finish_close()


func is_open() -> bool:
	return _open


func _process(delta: float) -> void:
	if _pending_action_id != "":
		var pending: Dictionary = _wheels.get(_pending_action_id, {})
		var action := String(pending.get("input_action", ""))
		if action.is_empty() or not Input.is_action_pressed(action):
			# Release events normally finish this path in _input. This fallback
			# prevents a lost event from leaving a pending short press behind.
			_pending_action_id = ""
		else:
			_pending_time += delta
			if _pending_time >= HOLD_THRESHOLD:
				var action_id := _pending_action_id
				_pending_action_id = ""
				_open_wheel(action_id)
	if _open:
		var stick := Vector2(Input.get_joy_axis(0, JOY_AXIS_RIGHT_X), Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y))
		_menu.update_stick(stick)
		if not _player or not is_instance_valid(_player) or not _player.is_alive:
			close(false)


func _input(event: InputEvent) -> void:
	if _open:
		if _active_action_released(event):
			close(true)
			get_viewport().set_input_as_handled()
			return
		if _active_action_pressed(event):
			get_viewport().set_input_as_handled()
			return
		if event.is_action_pressed("ui_cancel") or (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed):
			close(false)
			get_viewport().set_input_as_handled()
			return
		if event is InputEventMouseMotion:
			_last_mouse_position = event.position
			_menu.update_pointer(event.position)
			get_viewport().set_input_as_handled()
			return
		if event is InputEventKey and event.pressed and not event.echo:
			match event.keycode:
				KEY_LEFT, KEY_UP:
					_menu.move_selection(-1)
				KEY_RIGHT, KEY_DOWN:
					_menu.move_selection(1)
				_:
					pass
			get_viewport().set_input_as_handled()
			return

	for action_id in _wheels:
		var wheel: Dictionary = _wheels[action_id]
		var action := String(wheel.input_action)
		if event.is_action_pressed(action) and not (event is InputEventKey and event.echo):
			if _pending_action_id == "" and not _open and _can_start_wheel():
				_pending_action_id = action_id
				_pending_time = 0.0
				get_viewport().set_input_as_handled()
				return
		if event.is_action_released(action):
			if _pending_action_id == action_id:
				_pending_action_id = ""
				if _pending_time < HOLD_THRESHOLD:
					var callback: Callable = wheel.short_press
					if callback.is_valid():
						callback.call()
				get_viewport().set_input_as_handled()
				return
			if _open and _active_action_id == action_id:
				close(true)
				get_viewport().set_input_as_handled()
				return


func _can_start_wheel() -> bool:
	return _player and is_instance_valid(_player) and _player.is_alive and _player.controllable


func _open_wheel(action_id: String) -> bool:
	if _open or not _wheels.has(action_id) or not _can_start_wheel():
		return false
	var wheel: Dictionary = _wheels[action_id]
	var raw_options = wheel.provider.call()
	_all_options = _normalize_options(raw_options)
	if _all_options.is_empty():
		return false
	_active_action_id = action_id
	_page_index = 0
	_page_count = maxi(ceili(float(_all_options.size()) / 6.0), 1) if _all_options.size() > 8 else 1
	_open = true
	_player.acquire_control_lock(CONTROL_LOCK_OWNER)
	_player.request_mouse_mode(MOUSE_OWNER, Input.MOUSE_MODE_VISIBLE, 120)
	if _player.weapon_manager:
		_player.weapon_manager.release_trigger()
		_player.weapon_manager.set_aiming(false)
	_show_page()
	return true


func _show_page() -> void:
	var displayed: Array[RadialMenuOption] = []
	if _page_count == 1:
		for option in _all_options:
			displayed.append(option)
	else:
		var start := _page_index * 6
		var end := mini(start + 6, _all_options.size())
		for i in range(start, end):
			displayed.append(_all_options[i])
		if _page_index > 0:
			displayed.append(_navigation_option("__radial_previous", "PREVIOUS", "<", _page_index - 1))
		if _page_index < _page_count - 1:
			displayed.append(_navigation_option("__radial_next", "NEXT", ">", _page_index + 1))
	_menu.show_options(displayed, _page_index, _page_count)
	_menu.update_pointer(_last_mouse_position if _last_mouse_position != Vector2.ZERO else get_viewport().get_mouse_position())


func _active_action_released(event: InputEvent) -> bool:
	if not _wheels.has(_active_action_id):
		return false
	return event.is_action_released(String(_wheels[_active_action_id].input_action))


func _active_action_pressed(event: InputEvent) -> bool:
	if not _wheels.has(_active_action_id):
		return false
	return event.is_action_pressed(String(_wheels[_active_action_id].input_action))


func _navigation_option(id: String, title: String, icon: String, target_page: int) -> RadialMenuOption:
	var option := RadialMenuOptionScript.new() as RadialMenuOption
	option.id = id
	option.title = title
	option.description = "Go to page %d" % (target_page + 1)
	option.icon = icon
	return option


func _normalize_options(raw_options) -> Array[RadialMenuOption]:
	var result: Array[RadialMenuOption] = []
	if raw_options is Array:
		for raw in raw_options:
			if raw is RadialMenuOption:
				result.append(raw)
			elif raw is Dictionary:
				result.append(RadialMenuOptionScript.from_dictionary(raw))
	return result


func _finish_close() -> void:
	_open = false
	_active_action_id = ""
	_menu.hide_menu()
	if _player and is_instance_valid(_player):
		_player.release_control_lock(CONTROL_LOCK_OWNER)
		_player.release_mouse_mode(MOUSE_OWNER)
