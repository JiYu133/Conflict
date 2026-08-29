class_name DebugAPI
extends RefCounted

## Process-local, UI-independent debugging facade for tools and headless tests.

const MIN_TIME_SCALE := 0.05
const MAX_TIME_SCALE := 4.0

var tree: SceneTree
var _previous_time_scale := 1.0
var _assertions: Array[Dictionary] = []

func _init(scene_tree: SceneTree = null) -> void:
	tree = scene_tree

func _result(ok: bool, code: String, message: String = "", data: Dictionary = {}) -> Dictionary:
	return {"ok": ok, "code": code, "message": message, "data": data}

func _fail(code: String, message: String) -> Dictionary:
	return _result(false, code, message)

func get_current_scene() -> Node:
	return tree.current_scene if tree else null

func find_node(path: NodePath) -> Node:
	if not tree or not tree.root:
		return null
	return tree.root.get_node_or_null(path)

func find_group_nodes(group: String) -> Array[Node]:
	return tree.get_nodes_in_group(group) if tree else []

func find_players() -> Array[Node]:
	var players: Array[Node] = []
	if not tree:
		return players
	for node in tree.get_nodes_in_group("players"):
		if is_instance_valid(node):
			players.append(node)
	if players.is_empty() and tree.current_scene:
		_collect_players(tree.current_scene, players)
	return players

func _collect_players(node: Node, output: Array[Node]) -> void:
	if node is BasePlayer:
		output.append(node)
	for child in node.get_children():
		_collect_players(child, output)

func get_player(target: Node = null) -> Node:
	if is_instance_valid(target):
		return target
	var players := find_players()
	return players[0] if not players.is_empty() else null

func get_bot_list() -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for node in find_players():
		if node.get("is_ai_player"):
			result.append({"id": int(node.get("ai_player_id")), "name": String(node.get("ai_display_name")), "alive": bool(node.get("is_alive")), "position": _vector(node.global_position)})
	return result

func _get_bot_manager() -> Node:
	var scene := get_current_scene()
	return scene.find_child("AIPlayerManager", true, false) if scene else null

func set_bot_velocity(bot_id: int, velocity: Vector3) -> Dictionary:
	var manager := _get_bot_manager()
	if not manager: return _fail("bot_manager_not_found", "当前场景不存在 Bot 管理器。")
	if not manager.set_ai_player_test_motion(bot_id, velocity): return _fail("bot_not_found", "不存在 Bot ID=%d。" % bot_id)
	return _result(true, "ok", "", {"id": bot_id, "velocity": _vector(velocity)})

func kill_bot(bot_id: int) -> Dictionary:
	var manager := _get_bot_manager()
	if not manager: return _fail("bot_manager_not_found", "当前场景不存在 Bot 管理器。")
	if not manager.kill_ai_player(bot_id): return _fail("bot_not_found", "不存在 Bot ID=%d。" % bot_id)
	return _result(true, "ok", "", {"id": bot_id})

func remove_bot(bot_id: int) -> Dictionary:
	var manager := _get_bot_manager()
	if not manager: return _fail("bot_manager_not_found", "当前场景不存在 Bot 管理器。")
	if not manager.remove_ai_player(bot_id): return _fail("bot_not_found", "不存在 Bot ID=%d。" % bot_id)
	return _result(true, "ok", "", {"id": bot_id})

func get_scene_tree_summary() -> Dictionary:
	var scene := get_current_scene()
	return {"scene": scene.name if scene else "", "node_count": _count_nodes(tree.root) if tree and tree.root else 0, "players": find_players().size(), "bots": get_bot_list()}

func _count_nodes(node: Node) -> int:
	var count := 1
	for child in node.get_children():
		count += _count_nodes(child)
	return count

func await_frames(count: int) -> void:
	if not tree: return
	for _i in range(maxi(count, 0)):
		await tree.process_frame

func await_physics_frames(count: int) -> void:
	if not tree: return
	for _i in range(maxi(count, 0)):
		await tree.physics_frame

func await_seconds(seconds: float) -> void:
	if tree and seconds > 0.0:
		await tree.create_timer(seconds).timeout

func set_time_scale(scale: float) -> Dictionary:
	if scale < MIN_TIME_SCALE or scale > MAX_TIME_SCALE:
		return _fail("invalid_time_scale", "时间倍率必须在 0.05 到 4.00 之间。")
	_previous_time_scale = Engine.time_scale
	Engine.time_scale = scale
	return _result(true, "ok", "", {"time_scale": scale})

func restore_time_scale() -> Dictionary:
	Engine.time_scale = _previous_time_scale
	return _result(true, "ok", "", {"time_scale": Engine.time_scale})

func inject_action(action: String, pressed: bool = true, strength: float = 1.0) -> Dictionary:
	if not InputMap.has_action(action):
		return _fail("unknown_action", "InputMap 中不存在 action：%s" % action)
	var event := InputEventAction.new()
	event.action = action
	event.pressed = pressed
	event.strength = clampf(strength, 0.0, 1.0)
	Input.parse_input_event(event)
	return _result(true, "ok", "", {"action": action, "pressed": pressed})

func tap_action(action: String) -> Dictionary:
	var result := inject_action(action, true)
	if not result.get("ok", false):
		return result
	return inject_action(action, false)

func inject_mouse_motion(relative: Vector2, position: Vector2 = Vector2.ZERO) -> Dictionary:
	var event := InputEventMouseMotion.new()
	event.relative = relative
	event.position = position
	Input.parse_input_event(event)
	return _result(true, "ok")

func inject_mouse_button(button: MouseButton, pressed: bool, position: Vector2 = Vector2.ZERO) -> Dictionary:
	var event := InputEventMouseButton.new()
	event.button_index = button
	event.pressed = pressed
	event.position = position
	Input.parse_input_event(event)
	return _result(true, "ok")

func get_player_snapshot(target: Node = null) -> Dictionary:
	var player := get_player(target)
	if not player:
		return _fail("player_not_found", "当前场景不存在可用玩家。")
	var health = player.get("health_system")
	var vitals = health.get("vitals") if health else null
	var weapon_manager = player.get("weapon_manager")
	var weapon = weapon_manager.get("current_weapon") if weapon_manager else null
	var stance = player.get("stance_controller")
	var stamina = player.get("stamina_system")
	return _result(true, "ok", "", {"player": {"position": _vector(player.global_position), "velocity": _vector(player.velocity), "alive": bool(player.get("is_alive")), "health_pct": vitals.get_blood_pct() if vitals else null, "medical_state": int(health.get("current_state")) if health else null, "stance": stance.get_stance_value() if stance else null, "stamina": stamina.get("stamina") if stamina else null}, "posture": get_posture_snapshot(player).get("data", {}), "weapon": get_weapon_snapshot(player)})

func get_posture_snapshot(target: Node = null) -> Dictionary:
	var player := get_player(target)
	if not player:
		return _fail("player_not_found", "当前场景不存在可用玩家。")
	var animation = player.get("animation_controller")
	var look = player.get("look_controller")
	var camera = player.get("camera_controller")
	var stance = player.get("stance_controller")
	var movement = player.get("movement_controller")
	var turn = player.get("turn_controller")
	var animator = player.get("model_manager").get("animator") if player.get("model_manager") else null
	var animation_name := String(animator.current_animation) if animator else ""
	var animation_position := float(animator.current_animation_position) if animator else 0.0
	var animation_length := float(animator.current_animation_length) if animator else 0.0
	if animation and animation.has_method("get_prone_animation_name"):
		var prone_name: StringName = animation.get_prone_animation_name()
		if not prone_name.is_empty():
			animation_name = String(prone_name)
	var turn_state := -1
	var turn_state_name := ""
	var turn_progress := 0.0
	if animation and animation.has_method("get_current_state"):
		turn_state = int(animation.get_current_state())
		turn_state_name = PlayerAnimationController.State.keys()[turn_state] if turn_state >= 0 and turn_state < PlayerAnimationController.State.keys().size() else "unknown"
		if turn_state_name.contains("TURN") and animation.has_method("get_turn_clip_length") and animation.has_method("get_turn_playback_progress"):
			var clip_length := float(animation.get_turn_clip_length(turn_state))
			turn_progress = clampf(float(animation.get_turn_playback_progress(clip_length)), 0.0, 1.0) if clip_length > 0.0 else 0.0
	var view_yaw : float = look.get_view_yaw() if look and look.has_method("get_view_yaw") else (camera.get_view_yaw() if camera and camera.has_method("get_view_yaw") else player.rotation.y)
	var body_yaw : float = player.rotation.y
	var body_offset : float = look.get_body_yaw_offset() if look and look.has_method("get_body_yaw_offset") else angle_difference(body_yaw, view_yaw)
	var turn_snapshot: Dictionary = turn.get_debug_snapshot() if turn and turn.has_method("get_debug_snapshot") else {}
	if animation and animation.has_method("get_turn_playback_speed"):
		turn_snapshot["actual_playback_speed"] = animation.get_turn_playback_speed()
	return _result(true, "ok", "", {"animation_name": animation_name, "animation_position": animation_position, "animation_length": animation_length, "turn_state": turn_state, "turn_state_name": turn_state_name, "turn_progress": turn_progress, "body_yaw": body_yaw, "view_yaw": view_yaw, "body_yaw_offset": body_offset, "stance": stance.get_stance_value() if stance else null, "is_prone": stance.is_prone() if stance else false, "is_prone_transitioning": stance.is_prone_transitioning() if stance else false, "prone_geometry_blend": stance.get_prone_geometry_blend() if stance else null, "prone_roll_progress": movement.get_prone_roll_progress() if movement and movement.has_method("get_prone_roll_progress") else 0.0, "turn": turn_snapshot})

func get_weapon_snapshot(target: Node = null) -> Dictionary:
	var player := get_player(target)
	var manager = player.get("weapon_manager") if player else null
	var weapon = manager.get("current_weapon") if manager else null
	if not weapon:
		return {}
	var ammo = weapon.get("ammo_component")
	var config = weapon.get("config")
	return {"name": config.weapon_name if config else weapon.name, "magazine": ammo.get_current_magazine_count() if ammo else 0, "reserve": ammo.get_reserve_count() if ammo else 0, "chambered": ammo.has_chambered_round() if ammo else false, "fire_mode": String(weapon.get("current_fire_mode")), "bolt_position": float(weapon.get("bolt_position")), "reloading": bool(weapon.get("is_reloading"))}

func set_player_position(position: Vector3, target: Node = null) -> Dictionary:
	var player := get_player(target)
	if not player: return _fail("player_not_found", "当前场景不存在可用玩家。")
	player.global_position = position
	return _result(true, "ok", "", {"position": _vector(position)})

func set_player_stance(value: float, target: Node = null) -> Dictionary:
	var player := get_player(target)
	if not player: return _fail("player_not_found", "当前场景不存在可用玩家。")
	var stance = player.get("stance_controller")
	if not stance: return _fail("stance_not_initialized", "姿态系统尚未初始化。")
	if value < 0.0 or value > 1.0: return _fail("invalid_stance", "姿态值必须在 0 到 1 之间。")
	stance.set_stance(value)
	return _result(true, "ok", "", {"stance": value})

func set_player_health(percent: float, target: Node = null) -> Dictionary:
	var player := get_player(target)
	if not player: return _fail("player_not_found", "当前场景不存在可用玩家。")
	var health = player.get("health_system")
	if not health: return _fail("health_not_initialized", "医疗系统尚未初始化。")
	if percent < 0.0 or percent > 100.0: return _fail("invalid_health", "血量必须在 0 到 100 之间。")
	health.debug_set_blood_pct(percent / 100.0)
	return _result(true, "ok", "", {"health_pct": percent})

func clear_wounds(target: Node = null) -> Dictionary:
	var player := get_player(target)
	var health = player.get("health_system") if player else null
	if not player: return _fail("player_not_found", "当前场景不存在可用玩家。")
	if not health: return _fail("health_not_initialized", "医疗系统尚未初始化。")
	health.debug_clear_wounds()
	return _result(true, "ok")

func add_wound(part: int, severity: float, bleed_override: int = -1, target: Node = null) -> Dictionary:
	var player := get_player(target)
	var health = player.get("health_system") if player else null
	if not player: return _fail("player_not_found", "当前场景不存在可用玩家。")
	if not health: return _fail("health_not_initialized", "医疗系统尚未初始化。")
	if severity < 0.05 or severity > 2.0: return _fail("invalid_wound_severity", "伤口严重度必须在 0.05 到 2.00 之间。")
	health.debug_add_wound(part, severity, bleed_override)
	return _result(true, "ok", "", {"part": part, "severity": severity})

func revive(target: Node = null) -> Dictionary:
	var player := get_player(target)
	if not player: return _fail("player_not_found", "当前场景不存在可用玩家。")
	player.revive()
	return _result(true, "ok")

func kill(target: Node = null) -> Dictionary:
	var player := get_player(target)
	if not player: return _fail("player_not_found", "当前场景不存在可用玩家。")
	player.die()
	return _result(true, "ok")

func set_ammo(current_mag: int, reserve: int, chambered: bool = true, release_bolt: bool = true, target: Node = null) -> Dictionary:
	var player := get_player(target)
	var manager = player.get("weapon_manager") if player else null
	var weapon = manager.get("current_weapon") if manager else null
	if not player: return _fail("player_not_found", "当前场景不存在可用玩家。")
	if not weapon: return _fail("weapon_not_found", "当前没有已装备武器。")
	if not weapon.get("ammo_component"): return _fail("ammo_not_initialized", "武器弹药系统尚未初始化。")
	if current_mag < 0 or reserve < 0: return _fail("invalid_ammo", "弹药数量不能为负数。")
	weapon.debug_set_ammo_state(current_mag, reserve, chambered, release_bolt)
	return _result(true, "ok", "", get_weapon_snapshot(player))

func press_trigger(target: Node = null) -> Dictionary: return _weapon_call("press_trigger", target)
func release_trigger(target: Node = null) -> Dictionary: return _weapon_call("release_trigger", target)
func reload(target: Node = null) -> Dictionary: return _weapon_call("reload", target)
func cycle_fire_mode(target: Node = null) -> Dictionary: return _weapon_call("cycle_fire_mode", target)
func set_aiming(aiming: bool, target: Node = null) -> Dictionary: return _weapon_call("set_aiming", target, [aiming])

func _weapon_call(method: String, target: Node, args: Array = []) -> Dictionary:
	var player := get_player(target)
	var manager = player.get("weapon_manager") if player else null
	if not player: return _fail("player_not_found", "当前场景不存在可用玩家。")
	var weapon = manager.get("current_weapon") if manager else null
	if not weapon: return _fail("weapon_not_found", "当前没有已装备武器。")
	if method == "cycle_fire_mode":
		if not weapon.cycle_fire_mode(): return _fail("operation_failed", "当前武器无法切换射击模式。")
	elif method == "set_aiming": manager.set_aiming(args[0])
	else: weapon.callv(method, args)
	return _result(true, "ok", "", get_weapon_snapshot(player))

func get_runtime_snapshot() -> Dictionary:
	return {"scene": get_current_scene().name if get_current_scene() else "", "player": get_player_snapshot().get("data", {}).get("player", {}), "weapon": get_weapon_snapshot(), "bots": get_bot_list(), "time_scale": Engine.time_scale, "tree": get_scene_tree_summary()}

func assert_equal(actual: Variant, expected: Variant, name: String, message: String = "") -> Dictionary:
	var result := _result(actual == expected, "ok" if actual == expected else "assertion_failed", message if actual == expected else (message if not message.is_empty() else "%s: 实际值与期望值不一致" % name), {"name": name, "actual": actual, "expected": expected})
	_assertions.append(result)
	return result

func get_assertion_report() -> Dictionary:
	var passed := 0
	for result in _assertions:
		if result.get("ok", false): passed += 1
	return {"total": _assertions.size(), "passed": passed, "failed": _assertions.size() - passed, "results": _assertions, "ok": passed == _assertions.size()}

func clear_assertions() -> void: _assertions.clear()

func _vector(value: Vector3) -> Dictionary:
	return {"x": value.x, "y": value.y, "z": value.z}
