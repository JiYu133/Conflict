class_name PlayerUILayer
extends Node
## 玩家 UI 层（对应问题清单 R1：玩家层反向依赖 UI）。
##
## 拆分前 `base_player.gd` 顶部 preload 了 5 个具体界面脚本
## （设置 / 暂停 / 武器改装 / 弹药 HUD / 控制台），依赖方向是「玩家核心 → 具体界面」：
## 改任何一个界面都要动玩家核心，界面也无法脱离玩家单独构造。
##
## 拆分后依赖方向变为「UI 层 → 具体界面」：`BasePlayer` 不再 preload 任何界面脚本，
## 只保留引用字段（settings_menu / pause_menu / weapon_mod_menu / console_system）
## 与查询接口，界面节点的所有权归本层（作为本层的子节点）。
##
## 两条硬约定：
##   1. 本层自己 add_child 自己的子节点，**不回调** `BasePlayer` 的私有方法；
##   2. 所需依赖全部由 `initialize()` 显式注入，本层不自己去 `get_parent()` 摸玩家。

const SETTINGS_MENU_SCRIPT := preload("res://classes/ui/settings/settings_menu.gd")
const PAUSE_MENU_SCRIPT := preload("res://classes/ui/pause_menu.gd")
const WEAPON_MOD_MENU_SCRIPT := preload("res://classes/ui/weapon_mod/weapon_mod_menu.gd")
const AMMO_HUD_SCRIPT := preload("res://classes/ui/weapon_ammo_hud.gd")
const CONSOLE_SYSTEM_SCRIPT := preload("res://classes/ui/console/console_system.gd")
const PLAYER_WHEEL_IDS: Array[String] = ["fire_mode", "medical", "squad_command"]

## 由本层创建、供 BasePlayer 回填引用的界面实例。
var ammo_hud
var settings_menu
var pause_menu
var weapon_mod_menu
var console_system: ConsoleSystem

## 径向菜单全局服务（autoload）；本层负责把玩家相关的轮盘注册进去。
var radial_menu_service

# 注：玩家参数声明为 Node3D 而非 BasePlayer，避免与 BasePlayer 形成 class_name 循环引用。
var _player: Node3D
var _settings_service: SettingsService
var _weapon_manager: WeaponManager
var _medical_treatment_component: MedicalTreatmentComponent


func initialize(
	player: Node3D,
	settings_service: SettingsService,
	weapon_manager: WeaponManager,
	medical_treatment_component: MedicalTreatmentComponent
) -> void:
	_player = player
	_settings_service = settings_service
	_weapon_manager = weapon_manager
	_medical_treatment_component = medical_treatment_component

	# 注入即契约（问题清单 R2）：这三样必须在 UI 层之前由玩家核心建好。
	# 顺序被改坏时要立刻炸，而不是等到用的时候才发现是空引用。
	assert(is_instance_valid(_settings_service),
		"[Player 装配顺序] PlayerUILayer 需要 settings_service —— 检查 BasePlayer._initialize_subsystems。")
	assert(is_instance_valid(_weapon_manager),
		"[Player 装配顺序] PlayerUILayer 需要 weapon_manager —— 检查 BasePlayer._initialize_subsystems。")
	assert(is_instance_valid(_medical_treatment_component),
		"[Player 装配顺序] PlayerUILayer 需要 medical_treatment_component，它必须在本层之前创建。")

	# 创建顺序与拆分前逐行一致：弹药 HUD → 战斗通知桥 → 设置 → 暂停 → 武器改装 → 控制台。
	ammo_hud = _create_ui(AMMO_HUD_SCRIPT.new(), "WeaponAmmoHUD")
	ammo_hud.initialize(_player)

	# 战斗通知桥接：连接 HealthSystem 信号到右上角通知栏
	var combat_notif := _create_ui(CombatNotificationBridge.new(), "CombatNotifBridge")
	combat_notif.initialize(_player)

	# 暂停菜单拥有本地输入阻断；设置页由它打开，避免 ESC 直接跳入设置。
	settings_menu = _create_ui(SETTINGS_MENU_SCRIPT.new(), "SettingsMenu")
	settings_menu.initialize(_settings_service, _player)
	pause_menu = _create_ui(PAUSE_MENU_SCRIPT.new(), "PauseMenu")
	pause_menu.initialize(_player, settings_menu)

	# 武器改装界面：接口已就绪（open/close/toggle/is_open + opened/closed 信号），
	# 正式入口（军械库/装备界面）接入前，暂由 debug 构建的 weapon_mod_menu 动作
	# （默认 N，可在设置→控制→调试 中改绑）打开。
	weapon_mod_menu = _create_ui(WEAPON_MOD_MENU_SCRIPT.new(), "WeaponModMenu")
	weapon_mod_menu.initialize(_player)

	console_system = _create_ui(CONSOLE_SYSTEM_SCRIPT.new(), "ConsoleSystem") as ConsoleSystem
	console_system.initialize(_player)

	_register_radial_wheels()


func _create_ui(ui: Node, node_name: String) -> Node:
	ui.name = node_name
	add_child(ui)
	return ui


func _exit_tree() -> void:
	# A newer local player may already own the service during a scene change.
	# Only clear the registrations when this layer's player still owns it.
	if is_instance_valid(radial_menu_service):
		radial_menu_service.clear_player(_player, PLAYER_WHEEL_IDS)


# ============================================================
# 径向菜单：内容构建 + 轮盘注册
# 这两件事原本都写在玩家核心的 `_input()` 邻域里，属界面职责，故一并收进本层。
# ============================================================

func _register_radial_wheels() -> void:
	radial_menu_service = RadialMenuService
	radial_menu_service.set_player(_player)
	radial_menu_service.register_wheel(
		"fire_mode",
		"cycle_fire_mode",
		func(): _weapon_manager.cycle_fire_mode(),
		_get_fire_mode_wheel_options
	)
	radial_menu_service.register_wheel(
		"medical",
		"medical_radial",
		func(): _medical_treatment_component.begin_treatment(MedicalEnums.TreatmentType.BANDAGE),
		_medical_treatment_component.get_wheel_options
	)
	radial_menu_service.register_wheel(
		"squad_command",
		"squad_command_radial",
		func(): _issue_squad_command(AIBlackboard.SquadCommand.FOLLOW_PLAYER),
		_get_squad_command_options
	)


func _get_fire_mode_wheel_options() -> Array[RadialMenuOption]:
	var result: Array[RadialMenuOption] = []
	if not _weapon_manager or not _weapon_manager.current_weapon:
		return result
	var weapon: BaseWeapon = _weapon_manager.current_weapon
	if not weapon.config:
		return result
	var available := _weapon_manager.get_available_fire_modes()
	for mode in weapon.config.fire_modes:
		var option := RadialMenuOption.new()
		option.id = mode
		option.title = _fire_mode_display(mode)
		option.is_current = mode == weapon.current_fire_mode
		option.is_enabled = available.has(mode)
		option.disabled_reason = "Selector switch unavailable" if not option.is_enabled else ""
		option.execute = _make_fire_mode_callback(mode)
		result.append(option)
	return result


func _make_fire_mode_callback(mode: String) -> Callable:
	return func(): _weapon_manager.set_fire_mode(mode)


func _fire_mode_display(mode: String) -> String:
	match mode:
		"safe": return "SAFE"
		"semi": return "SEMI"
		"auto": return "AUTO"
		"burst": return "BURST"
		_: return mode.to_upper()


func _get_squad_command_options() -> Array[RadialMenuOption]:
	var result: Array[RadialMenuOption] = []
	var commands := [
		[AIBlackboard.SquadCommand.FOLLOW_PLAYER, "跟随我", "跟随玩家移动"],
		[AIBlackboard.SquadCommand.MOVE_TO_OBJECTIVE, "前往目标", "移动并占领目标区"],
		[AIBlackboard.SquadCommand.ADVANCE, "推进", "向敌情或目标方向推进"],
		[AIBlackboard.SquadCommand.HOLD, "坚守", "原地警戒并保持阵地"],
		[AIBlackboard.SquadCommand.FALL_BACK, "撤回", "撤回到玩家附近"],
		[AIBlackboard.SquadCommand.ATTACK, "攻击", "攻击当前共享敌情"],
	]
	var director := _get_encounter_bot_director()
	for entry in commands:
		var option := RadialMenuOption.new()
		option.id = AIBlackboard.command_name(entry[0])
		option.title = entry[1]
		option.description = entry[2]
		option.is_enabled = director != null
		option.disabled_reason = "当前没有可指挥的队友" if not director else ""
		option.execute = _make_squad_command_callback(entry[0])
		result.append(option)
	return result


func _issue_squad_command(command: AIBlackboard.SquadCommand) -> void:
	var director := _get_encounter_bot_director()
	if director:
		director.issue_player_command(command, _player)


func _make_squad_command_callback(command: AIBlackboard.SquadCommand) -> Callable:
	return func(): _issue_squad_command(command)


func _get_encounter_bot_director() -> EncounterAIDirector:
	var scene := get_tree().current_scene if get_tree() else null
	return scene.find_child("EncounterAIDirector", true, false) as EncounterAIDirector if scene else null
