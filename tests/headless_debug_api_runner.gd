extends Node

var _api: DebugAPI

func _ready() -> void:
	_api = DebugAPI.new(get_tree())
	await _run()

func _run() -> void:
	var started := Time.get_ticks_msec()
	_api.clear_assertions()
	_run_keybind_checks()
	_api.assert_equal(_api.get_current_scene(), self, "current_scene")
	_api.assert_equal(_api.get_scene_tree_summary().get("players"), 0, "empty_player_list")
	var missing := _api.get_player_snapshot()
	_api.assert_equal(missing.get("code"), "player_not_found", "missing_player_error")
	var non_player := Node.new()
	add_child(non_player)
	_api.assert_equal(_api.get_player_snapshot(non_player).get("code"), "player_not_found", "non_player_snapshot_error")
	_api.assert_equal(_api.set_player_position(Vector3.ONE, non_player).get("code"), "player_not_found", "non_player_position_error")
	non_player.queue_free()
	var original_scale := Engine.time_scale
	_api.assert_equal(_api.set_time_scale(0.5).get("ok"), true, "set_time_scale")
	_api.assert_equal(Engine.time_scale, 0.5, "time_scale_value")
	_api.assert_equal(_api.set_time_scale(0.25).get("ok"), true, "set_time_scale_repeated")
	_api.assert_equal(Engine.time_scale, 0.25, "repeated_time_scale_value")
	_api.restore_time_scale()
	_api.assert_equal(Engine.time_scale, original_scale, "restore_time_scale")
	_api.assert_equal(_api.set_time_scale(99.0).get("code"), "invalid_time_scale", "invalid_time_scale")
	_api.assert_equal(_api.inject_action("ui_accept").get("ok"), true, "input_action")
	_api.assert_equal(_api.inject_action("__missing_action__").get("code"), "unknown_action", "unknown_action")
	_run_prone_turn_config_checks()
	await _api.await_frames(2)
	_api.assert_equal(true, true, "await_frames")
	var report := _api.get_assertion_report()
	report["duration_ms"] = Time.get_ticks_msec() - started
	report["status"] = "passed" if report.get("ok", false) else "failed"
	print(JSON.stringify(report))
	get_tree().quit(0 if report.get("ok", false) else 1)


func _run_keybind_checks() -> void:
	var keybind_store = load("res://classes/ui/settings/keybind_store.gd")
	var snapshot: Dictionary = keybind_store.snapshot_bindings()
	keybind_store.apply_saved()
	var loaded_events := InputMap.action_get_events("crouch")
	_api.assert_equal(loaded_events.size() >= 1, true, "saved_crouch_binding_loaded")
	if not loaded_events.is_empty():
		_api.assert_equal((loaded_events[0] as InputEventKey).physical_keycode, KEY_C, "saved_crouch_binding_usable")
	keybind_store.restore_bindings(snapshot)
	var replacement := InputEventKey.new()
	replacement.physical_keycode = KEY_F
	keybind_store.rebind_action_slot("crouch", 0, replacement, false)
	var events := InputMap.action_get_events("crouch")
	_api.assert_equal(events.size(), 1, "single_key_rebind_event_count")
	_api.assert_equal((events[0] as InputEventKey).physical_keycode, KEY_F, "single_key_rebind_event_code")
	_api.assert_equal(Input.is_action_just_pressed("crouch"), false, "single_key_rebind_input_map_ready")
	keybind_store.restore_bindings(snapshot)


func _run_prone_turn_config_checks() -> void:
	var config := load("res://assets/config/player/movement_config_default.tres") as MovementConfig
	_api.assert_equal(config != null, true, "prone_turn_config_loaded")
	if not config:
		return
	_api.assert_equal(config.prone_turn_min_playback_speed, 1.0, "prone_static_turn_speed_min")
	_api.assert_equal(config.prone_turn_max_playback_speed, 1.0, "prone_static_turn_speed_max")
	_api.assert_equal(config.prone_crawl_turn_speed_multiplier, 0.8, "prone_crawl_turn_multiplier")
	# The public snapshot contract is checked here even without a player scene;
	# gameplay-specific assertions run in scenes that provide a player.
	var missing := _api.get_posture_snapshot()
	_api.assert_equal(missing.get("code"), "player_not_found", "prone_snapshot_without_player")
