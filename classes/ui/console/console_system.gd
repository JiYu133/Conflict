class_name ConsoleSystem
extends CanvasLayer

## 本地运行时控制台。它是覆盖层而不是暂停菜单，因此打开时世界继续运行，
## 但通过 PlayerControlState 独立锁阻断当前玩家输入。

const FONT_PATH := "res://res/fonts/ConflictCJKUI.ttf"
const SETTINGS_TEXT = preload("res://classes/ui/settings/settings_text.gd")
const HISTORY_PATH := "user://console_history.cfg"
const HISTORY_LIMIT := 50

const COL_BACKDROP := Color(0.0, 0.0, 0.0, 0.48)
const COL_PANEL := Color(0.063, 0.067, 0.075, 0.92)
const COL_SURFACE := Color(0.10, 0.106, 0.12, 0.82)
const COL_BORDER := Color(1.0, 1.0, 1.0, 0.12)
const COL_TEXT := Color(0.945, 0.953, 0.961)
const COL_MUTED := Color(0.61, 0.64, 0.68)
const COL_ACCENT := Color(0.55, 0.72, 0.90)
const COL_SUCCESS := Color(0.56, 0.82, 0.63)
const COL_ERROR := Color(0.92, 0.48, 0.44)

const COMMANDS := {
	"help": {"usage": "help [command]", "help": "显示命令列表或指定命令帮助。", "safe": true},
	"clear": {"usage": "clear", "help": "清空控制台输出。", "safe": true},
	"fps": {"usage": "fps", "help": "显示当前帧率。", "safe": true},
	"status": {"usage": "status", "help": "显示玩家、生命、武器和时间状态。", "safe": true},
	"timescale": {"usage": "timescale <value>", "help": "设置时间倍率，范围 0.05 - 4.00；timescale 1 恢复默认。", "safe": true},
	"freecam": {"usage": "freecam", "help": "切换自由相机。仅 Debug 构建可用。", "debug_only": true},
	"revive": {"usage": "revive", "help": "复活当前玩家。仅 Debug 构建可用。", "debug_only": true},
	"kill": {"usage": "kill", "help": "杀死当前玩家。仅 Debug 构建可用。", "debug_only": true},
	"health": {"usage": "health <0-100>", "help": "设置玩家血量百分比。仅 Debug 构建可用。", "debug_only": true},
	"clear_wounds": {"usage": "clear_wounds", "help": "清除当前玩家全部伤口。仅 Debug 构建可用。", "debug_only": true},
	"medical_wound": {"usage": "medical_wound <part> <severity> [bleed]", "help": "向指定部位注入伤口。仅 Debug 构建可用。", "debug_only": true},
	"medical_kill": {"usage": "medical_kill <front|front_headshot|explosion>", "help": "按指定类型触发医疗死亡测试。仅 Debug 构建可用。", "debug_only": true},
	"give_ammo": {"usage": "give_ammo <current_mag> <reserve_rounds> [chambered=1] [release_bolt=1]", "help": "按弹匣状态重建当前武器弹药。仅 Debug 构建可用。", "debug_only": true},
	"press_trigger": {"usage": "press_trigger", "help": "模拟按下扳机。仅 Debug 构建可用。", "debug_only": true},
	"release_trigger": {"usage": "release_trigger", "help": "模拟松开扳机。仅 Debug 构建可用。", "debug_only": true},
	"cycle_fire_mode": {"usage": "cycle_fire_mode", "help": "切换当前射击模式。仅 Debug 构建可用。", "debug_only": true},
	"bolt_release": {"usage": "bolt_release", "help": "释放空仓挂机的枪机。仅 Debug 构建可用。", "debug_only": true},
	"clear_malfunction": {"usage": "clear_malfunction", "help": "推进一次排障流程。仅 Debug 构建可用。", "debug_only": true},
	"set_aiming": {"usage": "set_aiming <0|1>", "help": "切换武器举枪状态。仅 Debug 构建可用。", "debug_only": true},
	"reload": {"usage": "reload", "help": "调用当前武器换弹流程。", "safe": true},
	"teleport": {"usage": "teleport <x> <y> <z>", "help": "将玩家移动到当前世界坐标。仅 Debug 构建可用。", "debug_only": true},
	"bot": {"usage": "bot add|list|kill|remove ...", "help": "创建、查询、击杀或删除地图内 Bot。", "safe": true},
}
const COMMAND_ORDER := [
	"help", "clear", "fps", "status", "timescale", "freecam", "revive", "kill",
	"health", "clear_wounds", "give_ammo", "press_trigger", "release_trigger",
	"medical_wound", "medical_kill", "cycle_fire_mode", "bolt_release", "clear_malfunction",
	"set_aiming", "reload", "teleport", "bot",
]

var _player
var _open := false
var _transitioning := false
var _previous_mouse_mode := Input.MOUSE_MODE_CAPTURED
var _history: Array[String] = []
var _history_index := -1
var _completion_items: Array[String] = []
var _completion_index := 0

var _theme: Theme
var _backdrop: ColorRect
var _panel: PanelContainer
var _output: VBoxContainer
var _output_scroll: ScrollContainer
var _input_line: LineEdit
var _completion_panel: PanelContainer
var _completion_list: RichTextLabel
var _parameter_hint: RichTextLabel
var _build_label: Label
var _transition: Tween


func initialize(player) -> void:
	_player = player


func is_open() -> bool:
	return _open or _transitioning


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 30
	_theme = Theme.new()
	if ResourceLoader.exists(FONT_PATH):
		_theme.default_font = load(FONT_PATH)
	_theme.default_font_size = 15
	_load_history()
	_build_ui()
	visible = false


func open() -> void:
	if _open or _transitioning:
		return
	_close_other_overlays()
	_previous_mouse_mode = Input.get_mouse_mode()
	_open = true
	visible = true
	if _player:
		_player.acquire_control_lock(BasePlayer.CONTROL_LOCK_CONSOLE)
		if _player.weapon_manager:
			_player.weapon_manager.release_trigger()
			_player.weapon_manager.set_aiming(false)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	_history_index = -1
	_input_line.clear()
	_hide_completion()
	_append_log("控制台已打开。输入 help 查看可用命令。", COL_ACCENT)
	_input_line.grab_focus()
	_play_open_animation()


func close() -> void:
	if not _open or _transitioning:
		return
	_open = false
	_hide_completion()
	_play_close_animation()


func _exit_tree() -> void:
	if _player:
		_player.release_control_lock(BasePlayer.CONTROL_LOCK_CONSOLE)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("console"):
		if _open:
			close()
		else:
			open()
		get_viewport().set_input_as_handled()
		return
	if not _open:
		return
	if _transitioning:
		if event is InputEventKey:
			get_viewport().set_input_as_handled()
		return
	if event is InputEventKey and event.pressed and not event.echo:
		var key := event as InputEventKey
		var physical := key.physical_keycode if key.physical_keycode != 0 else key.keycode
		match physical:
			KEY_ESCAPE:
				if _completion_active():
					_hide_completion()
				else:
					close()
				get_viewport().set_input_as_handled()
			KEY_TAB:
				if _completion_active():
					_apply_completion()
				else:
					_open_completion()
				get_viewport().set_input_as_handled()
			KEY_UP:
				if _completion_active():
					_move_completion(-1)
				else:
					_browse_history(-1)
				get_viewport().set_input_as_handled()
			KEY_DOWN:
				if _completion_active():
					_move_completion(1)
				else:
					_browse_history(1)
				get_viewport().set_input_as_handled()


func _unhandled_key_input(event: InputEvent) -> void:
	# 让 LineEdit 先在 GUI 阶段接收文本和编辑按键；GUI 未消费的键盘事件
	# 到这里统一截断，避免控制台下的游戏快捷键继续生效。
	if is_open() and event is InputEventKey:
		get_viewport().set_input_as_handled()


func _on_input_submitted(command_line: String) -> void:
	if _completion_active():
		_apply_completion()
		return
	_execute_line(command_line)


func _on_input_changed(value: String) -> void:
	_history_index = -1
	_set_parameter_hint(_get_parameter_hint(value))
	_update_completion(value)


func _execute_line(command_line: String) -> void:
	var line := command_line.strip_edges()
	if line.is_empty():
		return
	_append_log("> " + line, COL_TEXT)
	_input_line.clear()
	_history_index = -1
	_add_history(line)
	var tokens := line.split(" ", false)
	var command := String(tokens[0]).to_lower()
	if command == "giveammo" or command == "give_magazine":
		command = "give_ammo"
	var args: Array[String] = []
	for index in range(1, tokens.size()):
		args.append(String(tokens[index]))

	if not COMMANDS.has(command):
		_error("未知命令：%s。输入 help 查看命令列表。" % command)
		return
	var spec: Dictionary = COMMANDS[command]
	if spec.get("debug_only", false) and not OS.is_debug_build():
		_error("命令不可用：该命令仅在 Debug 构建中开放。")
		return
	var result := _run_command(command, args)
	if result.get("clear", false):
		_clear_output()
	else:
		_append_log(String(result.get("message", "命令执行完成。")), COL_SUCCESS if result.get("ok", false) else COL_ERROR)


func _run_command(command: String, args: Array[String]) -> Dictionary:
	match command:
		"help":
			if args.size() > 1:
				return _error_result("参数数量错误：help 最多接受一个命令名。")
			if args.is_empty():
				var lines: Array[String] = ["可用命令："]
				for name in COMMAND_ORDER:
					var item: Dictionary = COMMANDS[name]
					if item.get("debug_only", false) and not OS.is_debug_build():
						continue
					lines.append("  %-22s %s" % [item["usage"], item["help"]])
				return _ok_result("\n".join(lines))
			var target := args[0].to_lower()
			if target == "giveammo" or target == "give_magazine":
				target = "give_ammo"
			if not COMMANDS.has(target):
				return _error_result("未知命令：%s。" % target)
			var target_spec: Dictionary = COMMANDS[target]
			if target_spec.get("debug_only", false) and not OS.is_debug_build():
				return _error_result("命令不可用：该命令仅在 Debug 构建中开放。")
			return _ok_result("%s\n用法：%s" % [target_spec["help"], target_spec["usage"]])
		"clear":
			if not args.is_empty():
				return _error_result("参数数量错误：clear 不接受参数。")
			return {"ok": true, "clear": true}
		"fps":
			if not args.is_empty():
				return _error_result("参数数量错误：fps 不接受参数。")
			return _ok_result("当前帧率：%d FPS" % Engine.get_frames_per_second())
		"status":
			if not args.is_empty():
				return _error_result("参数数量错误：status 不接受参数。")
			return _ok_result(_status_text())
		"timescale":
			if args.size() != 1:
				return _error_result("参数数量错误：用法为 timescale <value>。")
			if not args[0].is_valid_float():
				return _error_result("参数错误：时间倍率必须是数字。")
			var scale := float(args[0])
			if scale < 0.05 or scale > 4.0:
				return _error_result("范围错误：时间倍率必须在 0.05 到 4.00 之间。")
			Engine.time_scale = scale
			return _ok_result("时间倍率已设置为 %.2f。" % scale)
		"freecam":
			if not args.is_empty():
				return _error_result("参数数量错误：freecam 不接受参数。")
			if not _player.free_camera_controller:
				return _error_result("当前系统不可用：自由相机未初始化。")
			_player.free_camera_controller.toggle()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			return _ok_result("自由相机：%s。" % ("已开启" if _player.free_camera_controller.is_active() else "已关闭"))
		"revive":
			if not args.is_empty():
				return _error_result("参数数量错误：revive 不接受参数。")
			if not _player.is_alive:
				_player.revive()
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				return _ok_result("玩家已复活。")
			return _ok_result("玩家当前已经存活。")
		"kill":
			if not args.is_empty():
				return _error_result("参数数量错误：kill 不接受参数。")
			if _player.is_alive:
				_player.die()
				return _ok_result("玩家已被杀死。")
			return _ok_result("玩家当前已经死亡。")
		"health":
			if args.size() != 1:
				return _error_result("参数数量错误：用法为 health <0-100>。")
			if not args[0].is_valid_float():
				return _error_result("参数错误：血量必须是数字。")
			var health := float(args[0])
			if health < 0.0 or health > 100.0:
				return _error_result("范围错误：血量必须在 0 到 100 之间。")
			if not _player.health_system:
				return _error_result("当前系统不可用：医疗系统未初始化。")
			_player.health_system.debug_set_blood_pct(health / 100.0)
			return _ok_result("血量已设置为 %.1f%%。" % health)
		"clear_wounds":
			if not args.is_empty():
				return _error_result("参数数量错误：clear_wounds 不接受参数。")
			if not _player.health_system:
				return _error_result("当前系统不可用：医疗系统未初始化。")
			_player.health_system.debug_clear_wounds()
			return _ok_result("全部伤口已清除。")
		"medical_wound":
			return _run_medical_wound(args)
		"medical_kill":
			return _run_medical_kill(args)
		"give_ammo":
			return _run_give_ammo(args)
		"giveammo":
			return _run_give_ammo(args)
		"press_trigger":
			if not args.is_empty():
				return _error_result("参数数量错误：press_trigger 不接受参数。")
			if not _get_current_weapon():
				return _error_result("当前系统不可用：没有已装备武器。")
			_player.weapon_manager.press_trigger()
			return _ok_result("已模拟按下扳机。")
		"release_trigger":
			if not args.is_empty():
				return _error_result("参数数量错误：release_trigger 不接受参数。")
			if not _get_current_weapon():
				return _error_result("当前系统不可用：没有已装备武器。")
			_player.weapon_manager.release_trigger()
			return _ok_result("已模拟松开扳机。")
		"cycle_fire_mode":
			if not args.is_empty():
				return _error_result("参数数量错误：cycle_fire_mode 不接受参数。")
			if not _get_current_weapon():
				return _error_result("当前系统不可用：没有已装备武器。")
			if _player.weapon_manager.cycle_fire_mode():
				return _ok_result("已切换射击模式。")
			return _error_result("当前武器没有可操作的快慢机，无法切换射击模式。")
		"bolt_release":
			if not args.is_empty():
				return _error_result("参数数量错误：bolt_release 不接受参数。")
			var bolt_release_weapon: BaseWeapon = _get_current_weapon()
			if not bolt_release_weapon:
				return _error_result("当前系统不可用：没有已装备武器。")
			if bolt_release_weapon.release_bolt():
				return _ok_result("枪机已释放。")
			return _error_result("当前枪机未处于空仓挂机状态，无法释放。")
		"clear_malfunction":
			if not args.is_empty():
				return _error_result("参数数量错误：clear_malfunction 不接受参数。")
			var clearance_weapon: BaseWeapon = _get_current_weapon()
			if not clearance_weapon:
				return _error_result("当前系统不可用：没有已装备武器。")
			clearance_weapon.attempt_malfunction_clearance()
			return _ok_result("已推进一次排障流程。")
		"set_aiming":
			if args.size() != 1:
				return _error_result("参数数量错误：用法为 set_aiming <0|1>。")
			var aiming_parse: Variant = _parse_bool_arg(args[0])
			if aiming_parse == null:
				return _error_result("参数错误：set_aiming 只能是 0/1、true/false、on/off。")
			if not _get_current_weapon():
				return _error_result("当前系统不可用：没有已装备武器。")
			_player.weapon_manager.set_aiming(bool(aiming_parse))
			return _ok_result("武器举枪状态已设置为 %s。" % ("开启" if bool(aiming_parse) else "关闭"))
		"reload":
			if not args.is_empty():
				return _error_result("参数数量错误：reload 不接受参数。")
			if not _player.weapon_manager or not _player.weapon_manager.current_weapon:
				return _error_result("当前系统不可用：没有已装备武器。")
			_player.weapon_manager.reload()
			return _ok_result("已调用换弹流程。")
		"teleport":
			if args.size() != 3:
				return _error_result("参数数量错误：用法为 teleport <x> <y> <z>。")
			for value in args:
				if not value.is_valid_float():
					return _error_result("参数错误：坐标必须全部是数字。")
			_player.global_position = Vector3(float(args[0]), float(args[1]), float(args[2]))
			return _ok_result("玩家已传送到 %s。" % str(_player.global_position))
		"bot":
			return _run_bot_command(args)
	return _error_result("命令尚未实现：%s。" % command)


func _run_bot_command(args: Array[String]) -> Dictionary:
	if args.is_empty():
		return _error_result("参数错误：bot 子命令只能是 add、list、kill 或 remove。")
	var manager := _get_bot_manager()
	if not manager:
		return _error_result("当前系统不可用：BotManager 未初始化。")

	var subcommand := args[0].to_lower()
	match subcommand:
		"add":
			if args.size() not in [1, 2, 3, 5, 6]:
				return _error_result("参数数量错误：bot add 支持 name、faction 和三个坐标。")
			var bot_name := String(args[1]) if args.size() >= 2 else ""
			var faction := _default_bot_faction()
			var position := Vector3.ZERO
			var use_position := false
			if args.size() == 3:
				faction = _parse_bot_faction(args[2])
				if faction == -1:
					return _error_result("参数错误：无效阵营 %s，可用 ru、ua、none。" % args[2])
			elif args.size() == 5:
				var parsed_position := _parse_bot_position(args, 2)
				if not parsed_position.get("ok", false):
					return _error_result(String(parsed_position["message"]))
				position = parsed_position["position"]
				use_position = true
			elif args.size() == 6:
				faction = _parse_bot_faction(args[2])
				if faction == -1:
					return _error_result("参数错误：无效阵营 %s，可用 ru、ua、none。" % args[2])
				var parsed_position := _parse_bot_position(args, 3)
				if not parsed_position.get("ok", false):
					return _error_result(String(parsed_position["message"]))
				position = parsed_position["position"]
				use_position = true
			var bot := manager.add_bot(bot_name, faction, position, use_position)
			if not bot:
				return _error_result(manager.last_error)
			return _ok_result("Bot 已创建：ID=%d，名称=%s，阵营=%s，位置=%s。" % [
				bot.bot_id, bot.bot_display_name, _bot_faction_name(bot.faction), str(bot.global_position)
			])
		"list":
			if args.size() != 1:
				return _error_result("参数数量错误：bot list 不接受参数。")
			var bots := manager.get_bots()
			if bots.is_empty():
				return _ok_result("当前没有 Bot。")
			var lines: Array[String] = ["Bot 列表："]
			for bot in bots:
				lines.append("ID=%d 名称=%s 阵营=%s 位置=%s 存活=%s" % [
					bot.bot_id, bot.bot_display_name, _bot_faction_name(bot.faction), str(bot.global_position), "是" if bot.is_alive else "否"
				])
			return _ok_result("\n".join(lines))
		"kill", "remove":
			if args.size() != 2:
				return _error_result("参数数量错误：bot %s 用法为 bot %s <id|all>。" % [subcommand, subcommand])
			if args[1].to_lower() == "all":
				var count := manager.kill_all() if subcommand == "kill" else manager.remove_all()
				return _ok_result("已%s %d 个 Bot。" % ["击杀" if subcommand == "kill" else "删除", count])
			if not args[1].is_valid_int() or int(args[1]) <= 0:
				return _error_result("参数错误：Bot ID 必须是正整数或 all。")
			var bot_id := int(args[1])
			var ok := manager.kill_bot(bot_id) if subcommand == "kill" else manager.remove_bot(bot_id)
			if not ok:
				return _error_result(manager.last_error)
			return _ok_result("Bot ID=%d 已%s。" % [bot_id, "击杀" if subcommand == "kill" else "删除"])
		_:
			return _error_result("参数错误：未知 bot 子命令 %s，可用 add、list、kill、remove。" % args[0])


func _get_bot_manager() -> BotManager:
	var scene := get_tree().current_scene
	return scene.find_child("BotManager", true, false) as BotManager if scene else null


func _default_bot_faction() -> BasePlayer.Faction:
	if not _player:
		return BasePlayer.Faction.None
	match _player.faction:
		BasePlayer.Faction.RU:
			return BasePlayer.Faction.UA
		BasePlayer.Faction.UA:
			return BasePlayer.Faction.RU
	return BasePlayer.Faction.None


func _parse_bot_faction(value: String) -> int:
	match value.to_lower():
		"ru": return BasePlayer.Faction.RU
		"ua": return BasePlayer.Faction.UA
		"none": return BasePlayer.Faction.None
	return -1


func _bot_faction_name(faction: BasePlayer.Faction) -> String:
	match faction:
		BasePlayer.Faction.RU: return "ru"
		BasePlayer.Faction.UA: return "ua"
	return "none"


func _parse_bot_position(args: Array[String], start: int) -> Dictionary:
	if start + 2 >= args.size():
		return {"ok": false, "message": "参数数量错误：坐标必须提供 x、y、z。"}
	for index in range(start, start + 3):
		if not args[index].is_valid_float():
			return {"ok": false, "message": "参数错误：坐标必须全部是数字。"}
	return {"ok": true, "position": Vector3(float(args[start]), float(args[start + 1]), float(args[start + 2]))}


func _run_give_ammo(args: Array[String]) -> Dictionary:
	if args.size() < 2 or args.size() > 4:
		return _error_result("参数数量错误：用法为 give_ammo <current_mag> <reserve_rounds> [chambered=1] [release_bolt=1]。")
	var weapon: BaseWeapon = _get_current_weapon()
	if not weapon:
		return _error_result("当前系统不可用：没有已装备武器。")
	if not weapon.ammo_component:
		return _error_result("当前系统不可用：武器弹药系统未初始化。")
	if not args[0].is_valid_int() or not args[1].is_valid_int():
		return _error_result("参数错误：current_mag 和 reserve_rounds 必须是整数。")
	if int(args[0]) < 0 or int(args[1]) < 0:
		return _error_result("参数错误：current_mag 和 reserve_rounds 不能为负数。")

	var chambered := true
	var release_bolt := true
	if args.size() >= 3:
		var chambered_value: Variant = _parse_bool_arg(args[2])
		if chambered_value == null:
			return _error_result("参数错误：chambered 只能是 0/1、true/false、on/off。")
		chambered = bool(chambered_value)
	if args.size() == 4:
		var release_bolt_value: Variant = _parse_bool_arg(args[3])
		if release_bolt_value == null:
			return _error_result("参数错误：release_bolt 只能是 0/1、true/false、on/off。")
		release_bolt = bool(release_bolt_value)

	var current_mag := maxi(int(args[0]), 0)
	var reserve_rounds := maxi(int(args[1]), 0)
	weapon.debug_set_ammo_state(current_mag, reserve_rounds, chambered, release_bolt)

	return _ok_result(
		"弹匣已设置：当前弹匣 %d 发，备用 %d 发，膛内%s，枪机%s。"
		% [
			weapon.get_current_magazine_count(),
			weapon.get_reserve_ammo_count(),
			"有弹" if weapon.has_chambered_round() else "无弹",
			"已释放" if release_bolt else "保持挂机"
		]
	)


func _run_medical_wound(args: Array[String]) -> Dictionary:
	if args.size() < 2 or args.size() > 3:
		return _error_result("参数数量错误：用法为 medical_wound <part> <severity> [bleed]。")
	if not _player.health_system:
		return _error_result("当前系统不可用：医疗系统未初始化。")
	var part: Variant = _parse_medical_part(args[0])
	if part == null:
		return _error_result("参数错误：未知部位 %s，可用部位为 head、torso、left_upper_arm、left_forearm、right_upper_arm、right_forearm、left_thigh、left_calf、right_thigh、right_calf。" % args[0])
	if not args[1].is_valid_float():
		return _error_result("参数错误：severity 必须是数字。")
	var severity := float(args[1])
	if severity < 0.05 or severity > 2.0:
		return _error_result("范围错误：severity 必须在 0.05 到 2.00 之间。")
	var bleed := -1
	if args.size() == 3:
		bleed = _parse_bleed_rate(args[2])
		if bleed == -2:
			return _error_result("参数错误：未知出血等级 %s，可用 none、capillary、venous、arterial 或 auto。" % args[2])
	_player.health_system.debug_add_wound(int(part), severity, bleed)
	return _ok_result("已向 %s 注入严重度 %.2f 的伤口。" % [args[0], severity])


func _run_medical_kill(args: Array[String]) -> Dictionary:
	if args.size() != 1:
		return _error_result("参数数量错误：用法为 medical_kill <front|front_headshot|explosion>。")
	if not _player.is_alive:
		return _error_result("玩家当前已经死亡。")
	var death_type: Variant = _parse_medical_death_type(args[0])
	if death_type == null:
		return _error_result("参数错误：死亡类型只能是 front、front_headshot 或 explosion。")
	_player.die(int(death_type))
	return _ok_result("已触发医疗死亡测试：%s。" % args[0])


func _parse_medical_part(value: String):
	match value.to_lower():
		"head": return MedicalEnums.BodyPartId.HEAD
		"torso": return MedicalEnums.BodyPartId.TORSO
		"left_upper_arm": return MedicalEnums.BodyPartId.LEFT_UPPER_ARM
		"left_forearm": return MedicalEnums.BodyPartId.LEFT_FOREARM
		"right_upper_arm": return MedicalEnums.BodyPartId.RIGHT_UPPER_ARM
		"right_forearm": return MedicalEnums.BodyPartId.RIGHT_FOREARM
		"left_thigh": return MedicalEnums.BodyPartId.LEFT_THIGH
		"left_calf": return MedicalEnums.BodyPartId.LEFT_CALF
		"right_thigh": return MedicalEnums.BodyPartId.RIGHT_THIGH
		"right_calf": return MedicalEnums.BodyPartId.RIGHT_CALF
	return null


func _parse_bleed_rate(value: String) -> int:
	match value.to_lower():
		"auto": return -1
		"none": return MedicalEnums.BleedRate.NONE
		"capillary": return MedicalEnums.BleedRate.CAPILLARY
		"venous": return MedicalEnums.BleedRate.VENOUS
		"arterial": return MedicalEnums.BleedRate.ARTERIAL
	return -2


func _parse_medical_death_type(value: String):
	match value.to_lower():
		"front": return PlayerRagdollSystem.DeathType.FRONT
		"front_headshot": return PlayerRagdollSystem.DeathType.FRONT_HEADSHOT
		"explosion": return PlayerRagdollSystem.DeathType.EXPLOSION
	return null


func _get_current_weapon():
	if not _player or not _player.weapon_manager:
		return null
	return _player.weapon_manager.current_weapon


func _parse_bool_arg(value: String):
	match value.to_lower():
		"1", "true", "on", "yes":
			return true
		"0", "false", "off", "no":
			return false
	return null


func _status_text() -> String:
	var health := "未知"
	var state := "未知"
	if _player.health_system and _player.health_system.vitals:
		health = "%.1f%%" % (_player.health_system.vitals.get_blood_pct() * 100.0)
		var state_id: int = _player.health_system.current_state
		state = MedicalEnums.HealthState.keys()[state_id]
	var weapon_text := "无"
	if _player.weapon_manager and _player.weapon_manager.current_weapon:
		var ammo = _player.weapon_manager.current_weapon.ammo_component
		if ammo:
			weapon_text = "%d / %d%s" % [ammo.get_current_magazine_count(), ammo.get_reserve_count(), "（膛内）" if ammo.has_chambered_round() else ""]
	return "存活：%s\n血量：%s\n医疗状态：%s\n位置：%s\n弹药：%s\n时间倍率：%.2f" % [
		"是" if _player.is_alive else "否", health, state, str(_player.global_position), weapon_text, Engine.time_scale
	]


func _get_parameter_hint(value: String) -> String:
	var tokens := value.strip_edges().split(" ", false)
	if tokens.is_empty():
		return "输入命令后按 Enter 执行"
	var command := String(tokens[0]).to_lower()
	if command == "giveammo" or command == "give_magazine":
		command = "give_ammo"
	if command == "bot":
		return _get_bot_parameter_hint(value)
	if COMMANDS.has(command):
		var spec: Dictionary = COMMANDS[command]
		return "%s  |  %s" % [spec["usage"], spec["help"]]
	return "未知命令；输入 help 查看命令列表"


func _get_bot_parameter_hint(value: String) -> String:
	var coords := str(_player.global_position) if _player else "(0, 0, 0)"
	var tokens := value.strip_edges().split(" ", false)
	if tokens.size() <= 1:
		return "bot add|list|kill|remove"
	match String(tokens[1]).to_lower():
		"add":
			return "bot add [name] [faction] [x] [y] [z]  | 默认坐标：%s" % coords
		"list":
			return "bot list"
		"kill":
			return "bot kill <id|all>"
		"remove":
			return "bot remove <id|all>"
	return "未知 bot 子命令；可用 add、list、kill、remove"


func _open_completion() -> void:
	_update_completion(_input_line.text, true)


## 输入首个命令词时实时显示前缀匹配；Tab 在空输入时可展开全部命令。
func _update_completion(value: String, include_all_when_empty: bool = false) -> void:
	if not _open:
		return
	var trimmed := value.strip_edges()
	var value_tokens := trimmed.split(" ", false)
	if not value_tokens.is_empty() and String(value_tokens[0]).to_lower() == "bot":
		_completion_items = _get_bot_completion_items(value)
		if _completion_items.is_empty():
			_completion_panel.visible = false
			return
		_completion_index = 0
		_refresh_completion_list()
		_completion_panel.visible = false
		return
	# 其他命令只在输入命令词时显示候选。
	if value.contains(" ") or value.contains("\t"):
		_hide_completion()
		return
	var prefix := value.strip_edges().to_lower()
	if prefix.is_empty() and not include_all_when_empty:
		_hide_completion()
		return
	_completion_items.clear()
	for name in COMMAND_ORDER:
		var spec: Dictionary = COMMANDS[name]
		if spec.get("debug_only", false) and not OS.is_debug_build():
			continue
		if prefix.is_empty() or name.begins_with(prefix):
			_completion_items.append(name)
	if _completion_items.is_empty():
		_completion_panel.visible = false
		return
	_completion_index = 0
	_refresh_completion_list()
	# 让容器按候选数量获得明确高度，避免 VBoxContainer 将可见面板压成
	# 仅有边框而看不到列表的最小高度。
	_completion_panel.visible = false


func _get_bot_completion_items(value: String) -> Array[String]:
	var trimmed := value.strip_edges()
	var tokens := trimmed.split(" ", false)
	var trailing_space := value.ends_with(" ")
	var candidates: Array[String] = []
	if tokens.size() == 1 and not trailing_space:
		if "bot".begins_with(String(tokens[0]).to_lower()):
			candidates.append("bot")
		return candidates
	if tokens.size() <= 1 or (tokens.size() == 2 and not trailing_space):
		var prefix := String(tokens[1]).to_lower() if tokens.size() > 1 else ""
		for subcommand in ["add", "list", "kill", "remove"]:
			if prefix.is_empty() or subcommand.begins_with(prefix):
				candidates.append("bot " + subcommand)
		return candidates

	var subcommand := String(tokens[1]).to_lower()
	if subcommand != "add":
		return []
	# The coordinate-bearing candidates are intentionally full commands: Tab
	# inserts the current player position, which can then be edited in place.
	var bot_name := String(tokens[2]) if tokens.size() >= 3 else _next_completion_bot_name()
	if bot_name.is_empty():
		bot_name = _next_completion_bot_name()
	var position: Vector3 = _player.global_position if _player else Vector3.ZERO
	var coords := "%.3f %.3f %.3f" % [position.x, position.y, position.z]
	var prefix := value.to_lower()
	for faction in ["ru", "ua", "none"]:
		var faction_candidate := "bot add %s %s %s" % [bot_name, faction, coords]
		if faction_candidate.to_lower().begins_with(prefix):
			candidates.append(faction_candidate)
	var position_candidate := "bot add %s %s" % [bot_name, coords]
	if position_candidate.to_lower().begins_with(prefix):
		candidates.append(position_candidate)
	return candidates


func _next_completion_bot_name() -> String:
	var manager := _get_bot_manager()
	if manager:
		var index := 1
		while not manager.is_name_available("Bot_%d" % index):
			index += 1
		return "Bot_%d" % index
	return "Bot_1"


func _refresh_completion_list() -> void:
	var lines: Array[String] = []
	for index in _completion_items.size():
		var item := _completion_items[index]
		var help_text: String = COMMANDS[item]["help"] if COMMANDS.has(item) else "插入当前参数建议"
		var selected := index == _completion_index
		var display_item := _escape_bbcode(item)
		var display_help := _escape_bbcode(help_text)
		var line := "> %s  -  %s" % [display_item, display_help] if selected else "  %s  -  %s" % [display_item, display_help]
		if selected:
			line = "[bgcolor=#%s][color=#%s]%s[/color][/bgcolor]" % [COL_ACCENT.to_html(false), COL_PANEL.to_html(false), line]
		else:
			line = "[color=#%s]%s[/color]" % [COL_TEXT.to_html(false), line]
		lines.append(line)
	_parameter_hint.text = "\n".join(lines)
	_parameter_hint.custom_minimum_size.y = minf(176.0, maxf(20.0, 21.0 * _completion_items.size() + 4.0))


func _completion_active() -> bool:
	return not _completion_items.is_empty()


func _set_parameter_hint(value: String) -> void:
	_parameter_hint.text = _escape_bbcode(value)
	_parameter_hint.custom_minimum_size.y = 18.0


func _escape_bbcode(value: String) -> String:
	return value.replace("[", "[lb]")


func _move_completion(delta: int) -> void:
	if _completion_items.is_empty():
		return
	_completion_index = posmod(_completion_index + delta, _completion_items.size())
	_refresh_completion_list()


func _apply_completion() -> void:
	if _completion_items.is_empty():
		return
	_input_line.text = _completion_items[_completion_index] + " "
	_input_line.caret_column = _input_line.text.length()
	_hide_completion()
	_input_line.grab_focus()


func _hide_completion() -> void:
	_completion_items.clear()
	_completion_panel.visible = false
	_set_parameter_hint(_get_parameter_hint(_input_line.text))


func _browse_history(delta: int) -> void:
	if _history.is_empty():
		return
	if _history_index < 0:
		_history_index = _history.size() if delta < 0 else -1
	_history_index = clampi(_history_index + delta, -1, _history.size())
	_input_line.text = "" if _history_index < 0 or _history_index == _history.size() else _history[_history_index]
	_input_line.caret_column = _input_line.text.length()


func _add_history(line: String) -> void:
	if _history.is_empty() or _history.back() != line:
		_history.append(line)
	if _history.size() > HISTORY_LIMIT:
		_history = _history.slice(_history.size() - HISTORY_LIMIT)
	_save_history()


func _load_history() -> void:
	var config := ConfigFile.new()
	if config.load(HISTORY_PATH) != OK:
		return
	var saved = config.get_value("console", "history", [])
	if saved is Array:
		for item in saved:
			if item is String and not item.is_empty():
				_history.append(item)
	if _history.size() > HISTORY_LIMIT:
		_history = _history.slice(_history.size() - HISTORY_LIMIT)


func _save_history() -> void:
	var config := ConfigFile.new()
	config.set_value("console", "history", _history)
	config.save(HISTORY_PATH)


func _clear_output() -> void:
	for child in _output.get_children():
		child.queue_free()


func _append_log(message: String, color: Color) -> void:
	if not _output:
		return
	var label := Label.new()
	label.text = message
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_color_override("font_color", color)
	label.add_theme_font_size_override("font_size", 14)
	_output.add_child(label)
	_output_scroll.call_deferred("ensure_control_visible", label)


func _error(message: String) -> void:
	_append_log(message, COL_ERROR)


func _ok_result(message: String) -> Dictionary:
	return {"ok": true, "message": message}


func _error_result(message: String) -> Dictionary:
	return {"ok": false, "message": message}


func _close_other_overlays() -> void:
	if not _player:
		return
	if _player.free_camera_controller:
		_player.free_camera_controller.force_exit()
	if _player.weapon_mod_menu and _player.weapon_mod_menu.is_open():
		_player.weapon_mod_menu.close()
	if _player.settings_menu and _player.settings_menu.is_open():
		_player.settings_menu.cancel_and_close()
	if _player.pause_menu and _player.pause_menu.is_open():
		_player.pause_menu.close()


func _build_ui() -> void:
	_backdrop = ColorRect.new()
	_backdrop.color = COL_BACKDROP
	_backdrop.set_anchors_preset(Control.PRESET_FULL_RECT)
	_backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(_backdrop)

	_panel = PanelContainer.new()
	_panel.theme = _theme
	_panel.add_theme_stylebox_override("panel", _box(COL_PANEL, COL_BORDER, 4))
	_panel.custom_minimum_size = Vector2(960, 600)
	_panel.set_anchors_preset(Control.PRESET_CENTER)
	_panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
	_panel.grow_vertical = Control.GROW_DIRECTION_BOTH
	_backdrop.add_child(_panel)

	var margin := MarginContainer.new()
	for side in ["left", "right", "top", "bottom"]:
		margin.add_theme_constant_override("margin_" + side, 24)
	_panel.add_child(margin)
	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 10)
	margin.add_child(root)

	var header := HBoxContainer.new()
	root.add_child(header)
	var titles := VBoxContainer.new()
	titles.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(titles)
	var title := Label.new()
	title.text = SETTINGS_TEXT.CONSOLE_TITLE
	title.add_theme_font_size_override("font_size", 23)
	title.add_theme_color_override("font_color", COL_TEXT)
	titles.add_child(title)
	var subtitle := Label.new()
	subtitle.text = SETTINGS_TEXT.CONSOLE_SUBTITLE
	subtitle.add_theme_font_size_override("font_size", 13)
	subtitle.add_theme_color_override("font_color", COL_MUTED)
	titles.add_child(subtitle)
	_build_label = Label.new()
	_build_label.text = "DEBUG 构建" if OS.is_debug_build() else "正式构建"
	_build_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_build_label.add_theme_color_override("font_color", COL_ACCENT if OS.is_debug_build() else COL_MUTED)
	header.add_child(_build_label)
	root.add_child(_divider())

	_output_scroll = ScrollContainer.new()
	_output_scroll.custom_minimum_size = Vector2(0, 300)
	_output_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_output_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	root.add_child(_output_scroll)
	_output = VBoxContainer.new()
	_output.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_output.add_theme_constant_override("separation", 4)
	_output_scroll.add_child(_output)

	_completion_panel = PanelContainer.new()
	_completion_panel.add_theme_stylebox_override("panel", _box(COL_SURFACE, COL_BORDER, 3))
	_completion_panel.custom_minimum_size = Vector2(0, 42)
	_completion_panel.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	_completion_panel.visible = false
	root.add_child(_completion_panel)
	_completion_list = RichTextLabel.new()
	_completion_list.theme = _theme
	_completion_list.bbcode_enabled = true
	_completion_list.fit_content = false
	_completion_list.scroll_active = true
	_completion_list.custom_minimum_size = Vector2(0, 36)
	_completion_list.custom_maximum_size = Vector2(0, 176)
	_completion_list.add_theme_font_size_override("normal_font_size", 14)
	_completion_list.add_theme_color_override("default_color", COL_TEXT)
	_completion_list.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_completion_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_completion_list.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	_completion_panel.add_child(_completion_list)

	_parameter_hint = RichTextLabel.new()
	_parameter_hint.theme = _theme
	_parameter_hint.bbcode_enabled = true
	_parameter_hint.fit_content = false
	_parameter_hint.scroll_active = false
	_parameter_hint.custom_minimum_size = Vector2(0, 18)
	_parameter_hint.text = _escape_bbcode(SETTINGS_TEXT.CONSOLE_INPUT_HINT)
	_parameter_hint.add_theme_font_size_override("font_size", 12)
	_parameter_hint.add_theme_font_size_override("normal_font_size", 12)
	_parameter_hint.add_theme_color_override("default_color", COL_MUTED)
	_parameter_hint.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(_parameter_hint)

	_input_line = LineEdit.new()
	_input_line.custom_minimum_size = Vector2(0, 38)
	_input_line.placeholder_text = SETTINGS_TEXT.CONSOLE_INPUT_PLACEHOLDER
	_input_line.clear_button_enabled = true
	_input_line.add_theme_color_override("font_color", COL_TEXT)
	_input_line.add_theme_stylebox_override("normal", _box(COL_SURFACE, COL_BORDER, 3))
	_input_line.add_theme_stylebox_override("focus", _box(COL_SURFACE, COL_ACCENT, 3))
	_input_line.text_submitted.connect(_on_input_submitted)
	_input_line.text_changed.connect(_on_input_changed)
	root.add_child(_input_line)

	var footer := Label.new()
	footer.text = SETTINGS_TEXT.CONSOLE_FOOTER_HINT
	footer.add_theme_font_size_override("font_size", 12)
	footer.add_theme_color_override("font_color", COL_MUTED)
	root.add_child(footer)
	_fit_panel_to_viewport()


func _fit_panel_to_viewport() -> void:
	if not _panel:
		return
	var size := get_viewport().get_visible_rect().size
	_panel.custom_minimum_size = Vector2(minf(960.0, maxf(320.0, size.x - 32.0)), minf(680.0, maxf(360.0, size.y - 32.0)))
	_panel.reset_size()
	_panel.position = (size - _panel.size) * 0.5


func _play_open_animation() -> void:
	_stop_transition()
	_transitioning = true
	_backdrop.modulate.a = 0.0
	_panel.modulate.a = 0.0
	var size := get_viewport().get_visible_rect().size
	_panel.position = (size - _panel.size) * 0.5 + Vector2(0.0, 8.0)
	_transition = create_tween()
	_transition.set_ignore_time_scale(true)
	_transition.set_parallel()
	_transition.tween_property(_backdrop, "modulate:a", 1.0, 0.12)
	_transition.tween_property(_panel, "modulate:a", 1.0, 0.12)
	_transition.tween_property(_panel, "position", (size - _panel.size) * 0.5, 0.12)
	_transition.chain().tween_callback(func(): _transitioning = false)


func _play_close_animation() -> void:
	_stop_transition()
	_transitioning = true
	_transition = create_tween()
	_transition.set_ignore_time_scale(true)
	_transition.set_parallel()
	_transition.tween_property(_backdrop, "modulate:a", 0.0, 0.10)
	_transition.tween_property(_panel, "modulate:a", 0.0, 0.10)
	_transition.tween_property(_panel, "position", _panel.position + Vector2(0.0, 8.0), 0.10)
	_transition.chain().tween_callback(_finish_close)


func _finish_close() -> void:
	_transitioning = false
	visible = false
	_panel.modulate.a = 1.0
	if _player:
		_player.release_control_lock(BasePlayer.CONTROL_LOCK_CONSOLE)
	Input.set_mouse_mode(_previous_mouse_mode)


func _stop_transition() -> void:
	if _transition and _transition.is_valid():
		_transition.kill()
	_transition = null


func _divider() -> ColorRect:
	var line := ColorRect.new()
	line.color = COL_BORDER
	line.custom_minimum_size = Vector2(0, 1)
	return line


func _box(background: Color, border: Color, radius: int, border_width: int = 1) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = background
	box.border_color = border
	box.set_border_width_all(border_width)
	box.set_corner_radius_all(radius)
	box.content_margin_left = 12
	box.content_margin_right = 12
	box.content_margin_top = 7
	box.content_margin_bottom = 7
	return box
