class_name BasePlayer
extends CharacterBody3D

const SETTINGS_SERVICE_SCRIPT := preload("res://classes/ui/settings/settings_service.gd")
const SETTINGS_MENU_SCRIPT := preload("res://classes/ui/settings/settings_menu.gd")
const PAUSE_MENU_SCRIPT := preload("res://classes/ui/pause_menu.gd")
const WEAPON_MOD_MENU_SCRIPT := preload("res://classes/ui/weapon_mod/weapon_mod_menu.gd")
const AMMO_HUD_SCRIPT := preload("res://classes/ui/weapon_ammo_hud.gd")
const CONTROL_STATE_SCRIPT := preload("res://classes/player/player_control_state.gd")
const CONSOLE_SYSTEM_SCRIPT := preload("res://classes/ui/console/console_system.gd")
const DEATH_BLOOD_EFFECT_SCRIPT := preload("res://classes/player/medical/death_blood_effect.gd")
const WEAPON_DROP_SYSTEM_SCRIPT := preload("res://classes/player/weapon_drop_system.gd")

# 在定义玩家对象时绑定给玩家的脚本 同时也要绑定玩家配置文件


# 导出变量


@export_group("Configuration")
@export var player_config: PlayerConfig
## AIPlayer 使用的完整 AI 配置包。
@export var ai_config: AIConfig
## 旧资源兼容字段；新玩法配置应使用 ai_config。

@export_group("State")
@export var is_ai_player: bool = false
@export var ai_player_id: int = -1
@export var ai_display_name: String = ""
@export var is_alive: bool = true: # 玩家存活状态设置
	set(value):
		if _is_alive == value:
			return
		_is_alive = value
		# 外部直接赋值时，状态翻转自动广播信号。
		# 生命周期状态优先于临时控制权锁，复活时再统一刷新有效控制权。
		if not _is_alive:
			if control_state:
				control_state.set_alive(false)
			died.emit()
		else:
			if control_state:
				control_state.set_alive(true)
			revived.emit()
	get:
		return _is_alive
var _is_alive: bool = true

@export var controllable: bool = true:
	set(value):
		_controllable_fallback = value
		if control_state:
			control_state.set_base_enabled(value)
	get:
		return control_state.is_controllable() if control_state else (_is_alive and _controllable_fallback)
@export var faction: Faction = Faction.None # 玩家阵营
## 布娃娃激活期间为 true，movement controller 据此跳过物理更新
var is_ragdolled: bool = false

const CONTROL_LOCK_PAUSE := "pause_menu"
const CONTROL_LOCK_FREE_CAMERA := "free_camera"
const CONTROL_LOCK_WEAPON_MOD := "weapon_mod_menu"
const CONTROL_LOCK_UNCONSCIOUS := "unconscious"
const CONTROL_LOCK_SETTINGS := "settings_menu"
const MOUSE_OWNER_CAMERA := "player_camera"
const CONTROL_LOCK_CONSOLE := "console"
const CONTROL_LOCK_RADIAL_MENU := "radial_menu"
const CONTROL_LOCK_MEDICAL := "medical_treatment"

var control_state: PlayerControlState
var _controllable_fallback: bool = true




# 子系统引用

var stance_controller: StanceController
var model_manager: PlayerModelManager
var camera_controller: PlayerCameraController
var ragdoll_system: PlayerRagdollSystem
var movement_controller: PlayerMovementController
var foot_ik_controller: FootIKController
var hand_ik_controller: HandIKController
var spine_aim_controller: SpineAimController
var weapon_manager: WeaponManager
var weapon_drop_system: WeaponDropSystem
var animation_controller: PlayerAnimationController
var turn_controller: PlayerTurnController
var health_system: HealthSystem
var death_blood_effect: DeathBloodEffect
var combat_effects: CombatEffects
var stamina_system: StaminaSystem
var screen_effects
var settings_service
var settings_menu
var pause_menu
var weapon_mod_menu
var free_camera_controller: FreeCameraController
var console_system: ConsoleSystem
var radial_menu_service
var medical_treatment_component: MedicalTreatmentComponent

## AI models and loadouts can be queued by AIPlayerManager so several bots do
## not all instantiate their expensive scene trees on the same frame.
var defer_ai_model_load: bool = false
var _ai_model_load_started: bool = false
var _ai_runtime_ready: bool = false

# 信号


signal died
signal revived
signal ai_runtime_ready
@warning_ignore("unused_signal")
signal faction_changed(new_faction: Faction)

# 玩家阵营枚举

enum Faction { RU, UA, None } 

# 生命周期

func _ready() -> void:
	_initialize_subsystems()

	# 物理参数：防止无输入时滑行
	floor_stop_on_slope = true
	floor_max_angle = deg_to_rad(45.0)

	# 加载配置中的模型
	if player_config and player_config.model_scene:
		if is_ai_player:
			if not defer_ai_model_load:
				begin_deferred_model_load.call_deferred()
		else:
			model_manager.load_model(player_config)
	elif is_ai_player:
		_mark_ai_runtime_ready()


func begin_deferred_model_load() -> void:
	if _ai_model_load_started or _ai_runtime_ready:
		return
	_ai_model_load_started = true
	if is_inside_tree() and player_config and player_config.model_scene:
		model_manager.load_model(player_config)
		if not model_manager.model_node:
			_mark_ai_runtime_ready()
	else:
		_mark_ai_runtime_ready()


func is_ai_runtime_ready() -> bool:
	return _ai_runtime_ready
	

# 子系统初始化

func _initialize_subsystems() -> void:
	GlobalLogger.info("Player", "Initializing player subsystems.")
	# 创建子系统
	control_state = _create_subsystem(CONTROL_STATE_SCRIPT.new(), "ControlState") as PlayerControlState
	control_state.set_alive(_is_alive)
	control_state.set_base_enabled(_controllable_fallback)
	settings_service = _create_subsystem(SETTINGS_SERVICE_SCRIPT.new(), "SettingsService")
	model_manager = _create_subsystem(PlayerModelManager.new(), "ModelManager")
	camera_controller = _create_subsystem(PlayerCameraController.new(),"CameraController")
	ragdoll_system = _create_subsystem(PlayerRagdollSystem.new(), "RagdollSystem")
	stance_controller = _create_subsystem(StanceController.new(), "StanceController")
	movement_controller = _create_subsystem(PlayerMovementController.new(), "MovementController")
	foot_ik_controller = _create_subsystem(FootIKController.new(), "FootIKController")
	hand_ik_controller = _create_subsystem(HandIKController.new(), "HandIKController")
	spine_aim_controller = _create_subsystem(SpineAimController.new(), "SpineAimController")
	weapon_manager = _create_subsystem(WeaponManager.new(), "WeaponManager")
	weapon_drop_system = _create_subsystem(WEAPON_DROP_SYSTEM_SCRIPT.new(), "WeaponDropSystem") as WeaponDropSystem
	animation_controller = _create_subsystem(PlayerAnimationController.new(), "AnimationController")
	turn_controller = _create_subsystem(PlayerTurnController.new(), "TurnController")
	health_system = _create_subsystem(HealthSystem.new(), "HealthSystem")
	stamina_system = _create_subsystem(StaminaSystem.new(), "StaminaSystem")

	# 初始化子系统
	settings_service.initialize()

	stance_controller.initialize(self, player_config)

	camera_controller.initialize(
		self,
		model_manager,
		player_config.model_config if player_config else null,
		player_config.camera_config if player_config else null,
		settings_service,
		not is_ai_player
		)

	movement_controller.initialize(
		self,
		player_config,
		camera_controller
		)

	foot_ik_controller.initialize(
		model_manager,
		player_config.model_config if player_config else null
		)

	hand_ik_controller.initialize(
		model_manager,
		player_config.model_config if player_config else null
		)


	weapon_manager.set_camera_controller(camera_controller)
	weapon_manager.set_settings_service(settings_service)
	weapon_drop_system.initialize(self, weapon_manager)

	health_system.initialize(
		self,
		player_config.health_config if player_config else null
		)
	death_blood_effect = _create_subsystem(DEATH_BLOOD_EFFECT_SCRIPT.new(), "DeathBloodEffect") as DeathBloodEffect
	death_blood_effect.initialize(
		self,
		player_config.blood_effect_config if player_config else null,
		settings_service
		)

	# 命中反馈只消费医疗系统结果：伤口、喷溅、滴落与血泊不反向影响伤害判定。
	combat_effects = _create_subsystem(CombatEffects.new(), "CombatEffects")
	combat_effects.initialize(self)

	stamina_system.initialize(self, player_config.stamina_config if player_config else null)

	if not is_ai_player:
		screen_effects = _create_subsystem(PlayerScreenEffects.new(), "ScreenEffects")
		screen_effects.initialize(self, settings_service)

		# 弹药 HUD（右下角）：显示膛内状态、弹匣余弹 / 备弹、射击模式
		var ammo_hud := _create_subsystem(AMMO_HUD_SCRIPT.new(), "WeaponAmmoHUD")
		ammo_hud.initialize(self)

		# 战斗通知桥接：连接 HealthSystem 信号到右上角通知栏
		var _combat_notif := _create_subsystem(CombatNotificationBridge.new(), "CombatNotifBridge")
		_combat_notif.initialize(self)

		# 暂停菜单拥有本地输入阻断；设置页由它打开，避免 ESC 直接跳入设置。
		settings_menu = _create_subsystem(SETTINGS_MENU_SCRIPT.new(), "SettingsMenu")
		settings_menu.initialize(settings_service, self)
		pause_menu = _create_subsystem(PAUSE_MENU_SCRIPT.new(), "PauseMenu")
		pause_menu.initialize(self, settings_menu)

		# 武器改装界面：接口已就绪（open/close/toggle/is_open + opened/closed 信号），
		# 正式入口（军械库/装备界面）接入前，暂由 debug 构建的 weapon_mod_menu 动作
		# （默认 N，可在设置→控制→调试 中改绑）打开。
		weapon_mod_menu = _create_subsystem(WEAPON_MOD_MENU_SCRIPT.new(), "WeaponModMenu")
		weapon_mod_menu.initialize(self)
		console_system = _create_subsystem(CONSOLE_SYSTEM_SCRIPT.new(), "ConsoleSystem") as ConsoleSystem
		console_system.initialize(self)
		radial_menu_service = RadialMenuService
		radial_menu_service.set_player(self)
		radial_menu_service.register_wheel(
			"fire_mode",
			"cycle_fire_mode",
			func(): weapon_manager.cycle_fire_mode(),
			_get_fire_mode_wheel_options
		)
		medical_treatment_component = _create_subsystem(preload("res://classes/encounter/medical_treatment_component.gd").new(), "MedicalTreatment") as MedicalTreatmentComponent
		medical_treatment_component.initialize(self)
		radial_menu_service.register_wheel(
			"medical",
			"medical_radial",
			func(): medical_treatment_component.begin_treatment(MedicalEnums.TreatmentType.BANDAGE),
			medical_treatment_component.get_wheel_options
		)
		radial_menu_service.register_wheel(
			"squad_command",
			"squad_command_radial",
			func(): _issue_squad_command(AIBlackboard.SquadCommand.FOLLOW_PLAYER),
			_get_squad_command_options
		)

		if OS.is_debug_build():
			free_camera_controller = _create_subsystem(FreeCameraController.new(), "FreeCameraController") as FreeCameraController

	# 连接信号
	_connect_signals()

func _create_subsystem(subsystem: Node, node_name: String) -> Node: # 创建子系统
	subsystem.name = node_name
	add_child(subsystem)
	return subsystem

func _connect_signals() -> void:
	model_manager.model_loaded.connect(_on_model_loaded)
	weapon_manager.weapon_changed.connect(_on_weapon_changed)
	weapon_manager.weapon_stats_changed.connect(_sync_weapon_weight_to_stamina)
	# 连接姿态变化信号
	stance_controller.stance_changed.connect(_on_stance_changed)
	# Sprint 开始时强制取消 ADS，并同步 IK 状态
	movement_controller.started_sprinting.connect(_on_started_sprinting)
	# 运动状态 → 左手 IK 权重过渡
	movement_controller.started_running.connect(func(): hand_ik_controller.set_movement_state(true, false))
	movement_controller.stopped_running.connect(func(): hand_ik_controller.set_movement_state(false, false))
	movement_controller.stopped_sprinting.connect(func(): hand_ik_controller.set_movement_state(true, false))
	# 运动状态 → 体力消耗
	movement_controller.started_sprinting.connect(stamina_system.on_started_sprinting)
	movement_controller.stopped_sprinting.connect(stamina_system.on_stopped_sprinting)
	movement_controller.started_running.connect(stamina_system.on_started_running)
	movement_controller.stopped_running.connect(stamina_system.on_stopped_running)
	movement_controller.jumped.connect(stamina_system.on_jumped)
	# 体力耗尽 → 根据配置强制退出冲刺和奔跑
	stamina_system.became_exhausted.connect(func():
		if movement_controller.is_sprinting():
			movement_controller._exit_sprint()
		if stamina_system._config.exhausted_disable_run and movement_controller.is_running():
			movement_controller._exit_run()
	)
	if screen_effects:
		health_system.damage_taken.connect(screen_effects._on_damage_taken)
		health_system.pain_changed.connect(screen_effects._on_pain_changed)
		stamina_system.stamina_changed.connect(screen_effects._on_stamina_changed)
	GlobalLogger.debug("Player", "Signals have been connected. ")


func _on_model_loaded(_model: Node3D) -> void:
	var weapon_mount := model_manager.find_node_by_names(["WeaponMount"], "Node3D") as Node3D

	# 初始化布娃娃系统（需要骨骼、动画系统及配置）
	ragdoll_system.initialize(
		model_manager.skeleton,
		model_manager.animator,
		model_manager.animation_tree,
		player_config.ragdoll_config if player_config else null,
		weapon_mount
	)

	# 将模型从 ModelManager 移到自己身下，确保变换跟随
	# 必须在 animation_controller.initialize() 之前完成，
	# 否则动画状态机可能在模型离开场景树时初始化，重挂载后状态会丢失
	if _model.get_parent():
		_model.get_parent().remove_child(_model)
	add_child(_model)
	# 模型面朝+Z时需旋转180°对齐角色朝向(-Z = forward)
	_model.rotation.y = PI

	# 模型就位后再启用动画组件并初始化控制器。Bot 没有本地相机来间接驱动
	# 模型动画，因此必须在读取 playback 和进入 Idle 前显式启用它们。
	if is_instance_valid(model_manager.animator):
		model_manager.animator.active = true
	if is_instance_valid(model_manager.animation_tree):
		model_manager.animation_tree.active = true
	animation_controller.initialize(self, movement_controller, model_manager, player_config)
	turn_controller.initialize(self, camera_controller, movement_controller, animation_controller, player_config.movement_config if player_config else null)
	spine_aim_controller.setup(
		model_manager.skeleton,
		self,
		camera_controller,
		player_config.spine_aim_config if player_config else null
	)
	hand_ik_controller.setup(model_manager.skeleton, player_config.hand_ik_config if player_config else null)
	if not is_ai_player:
		camera_controller._find_camera_nodes()
		camera_controller.enable_camera()
	else:
		# Keep authored camera nodes in the model hierarchy. They may be required
		# by animation/attachment paths, but must never become active bot cameras.
		for camera_node in _model.find_children("*", "Camera3D", true, false):
			var model_camera := camera_node as Camera3D
			if model_camera:
				model_camera.current = false
				model_camera.process_mode = Node.PROCESS_MODE_DISABLED
		_configure_bot_visuals(_model)

	if weapon_mount:
		GlobalLogger.info("Player", "Weapon mount has been set: " + weapon_mount.name)
		# 武器直接挂在右手骨骼的 BoneAttachment3D 下（WeaponMount），随右手动画移动。
		# 不要改挂到模型下的静态节点：那样只能在模型加载瞬间采样一次右手位置
		# （此时骨骼仍是 rest/T-pose），武器会被焊死在体侧且不随视角俯仰。
		# 左手再通过 IK 抓握武器上的 LeftHandGrip（见 HandIKController）。
		ragdoll_system.set_weapon_mount(weapon_mount)
		var sway_pivot: Node3D = camera_controller.setup_weapon_sway_pivot(weapon_mount)
		if sway_pivot:
			weapon_manager.set_mount(sway_pivot)
			GlobalLogger.info("Player", "Weapon sway pivot created, weapons attach under: " + sway_pivot.name)
		else:
			weapon_manager.set_mount(weapon_mount)
	else:
		GlobalLogger.error("Player", "Cannot find any weapon mount,the weapon will be not visible.")
		GlobalLogger.error("Player", "If there's already a weapon mount,try to check if its name is \"WeaponMount\" ")

	if player_config and player_config.starting_weapon:
		GlobalLogger.debug("Player", "Initializing player's starting weapon...")
		if is_ai_player:
			_load_ai_starting_weapon.call_deferred(player_config.starting_weapon)
		else:
			weapon_manager.load_and_equip(player_config.starting_weapon)
	elif is_ai_player:
		_mark_ai_runtime_ready()

	if OS.is_debug_build() and free_camera_controller:
		free_camera_controller.initialize(self, camera_controller)


func _load_ai_starting_weapon(config: WeaponConfig) -> void:
	# Separate the weapon scene from the model scene, then let WeaponManager
	# spread default attachments over subsequent frames.
	await get_tree().process_frame
	await weapon_manager.load_and_equip_staggered(config)
	_mark_ai_runtime_ready()


func _mark_ai_runtime_ready() -> void:
	if _ai_runtime_ready:
		return
	_ai_runtime_ready = true
	ai_runtime_ready.emit()


## Bot 没有第一人称相机，模型的所有网格都必须能被世界相机看到。
## 人物资源中的头部通常位于 layer 2，用于避开本地相机；保留该层并补上 layer 1。
func _configure_bot_visuals(model: Node3D) -> void:
	if not is_instance_valid(model):
		return
	model.visible = true
	for mesh_node in model.find_children("*", "MeshInstance3D", true, false):
		var mesh := mesh_node as MeshInstance3D
		if not mesh or _is_medical_debug_mesh(mesh, model):
			continue
		mesh.visible = true
		# 第一人称资源的头部通常使用 SHADOWS_ONLY，避免遮挡本地相机；
		# bot 没有本地相机，因此需要在运行时恢复正常渲染。
		if (mesh.layers & 2) != 0:
			mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
		mesh.layers = mesh.layers | 1


func _is_medical_debug_mesh(mesh: MeshInstance3D, model: Node3D) -> bool:
	var ancestor := mesh.get_parent()
	while ancestor and ancestor != model:
		if ancestor is BodyHitbox:
			return true
		ancestor = ancestor.get_parent()
	return false

# 公共API


func _on_weapon_changed(new_weapon: BaseWeapon) -> void:
	var weight := new_weapon.config.left_hand_ik_weight if new_weapon and new_weapon.config else 1.0
	hand_ik_controller.set_weapon(new_weapon, weight)
	_sync_weapon_weight_to_stamina()


## 将当前武器（含已装备配件）的总重量同步给耐力系统。
func _sync_weapon_weight_to_stamina() -> void:
	if not stamina_system:
		return
	var weapon := weapon_manager.current_weapon if weapon_manager else null
	if weapon and weapon.config and weapon.config.weight_affects_movement:
		stamina_system.set_carry_weight(weapon.get_total_weight())
	else:
		stamina_system.set_carry_weight(0.0)


func _process(delta: float) -> void:
	var procedural_animation_active := is_alive and not is_ragdolled
	spine_aim_controller.process_aim(delta, procedural_animation_active)
	hand_ik_controller.process_ik(delta, procedural_animation_active)
	if procedural_animation_active:
		foot_ik_controller.process_ik(delta)


func _input(event: InputEvent) -> void:
	# 暂停菜单/设置页/改装界面打开时，本地玩家让出全部输入。
	if (settings_menu and settings_menu.is_open()) or (pause_menu and pause_menu.is_open()) \
			or (weapon_mod_menu and weapon_mod_menu.is_open()) or (console_system and console_system.is_open()) \
			or (radial_menu_service and radial_menu_service.is_open()):
		return

	if is_alive and controllable:
		# 换弹
		if event.is_action_pressed("reload"):
			weapon_manager.reload()
		# 开火
		if event.is_action_pressed("fire"):
			weapon_manager.press_trigger()
		if event.is_action_released("fire"):
			weapon_manager.release_trigger()
		# 切换射击模式
		# 排障
		if event.is_action_pressed("clear_malfunction"):
			weapon_manager.attempt_malfunction_clearance()

	if not OS.is_debug_build():
		return

	# 自由视角切换（可在设置菜单重绑定，默认 F）
	if event.is_action_pressed("toggle_free_cam"):
		if free_camera_controller:
			free_camera_controller.toggle()

	# 调试复活（默认 G）：与 R 分开，把 R 留给正式换弹
	if event.is_action_pressed("debug_revive"):
		if not is_alive:
			revive()
		_debug_refill_ammo()

	# 改装界面（debug 临时入口，默认 N，可在设置中改绑）
	if event.is_action_pressed("weapon_mod_menu"):
		if weapon_mod_menu:
			weapon_mod_menu.toggle()

	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			# 受伤镜头效果调试：不写入医疗状态，只复用正式的 damage_taken 表现路径。
			KEY_P:
				_debug_trigger_pain_feedback(global_transform.basis.x)
			KEY_O:
				_debug_trigger_pain_feedback(-global_transform.basis.x)
			KEY_T:
				if free_camera_controller:
					free_camera_controller.debug_shoot(MedicalEnums.BodyPartId.TORSO)
			KEY_I:
				if free_camera_controller:
					free_camera_controller.debug_shoot(MedicalEnums.BodyPartId.HEAD)
			KEY_U:
				if free_camera_controller:
					free_camera_controller.debug_shoot_explosion()
			KEY_R:
				# R = 换弹（已走正式分段换弹流程）。
				# 备弹耗尽时补满，方便持续测试；正式流程上线后删掉这个兜底即可。
				if weapon_manager and weapon_manager.current_weapon:
					var weapon = weapon_manager.current_weapon
					if weapon.get_reserve_ammo_count() <= 0:
						_debug_refill_ammo()
					else:
						weapon_manager.reload()


func _get_fire_mode_wheel_options() -> Array[RadialMenuOption]:
	var result: Array[RadialMenuOption] = []
	if not weapon_manager or not weapon_manager.current_weapon:
		return result
	var weapon: BaseWeapon = weapon_manager.current_weapon
	if not weapon.config:
		return result
	var available := weapon_manager.get_available_fire_modes()
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
	return func(): weapon_manager.set_fire_mode(mode)


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
		director.issue_player_command(command, self)


func _make_squad_command_callback(command: AIBlackboard.SquadCommand) -> Callable:
	return func(): _issue_squad_command(command)


func _get_encounter_bot_director() -> EncounterAIDirector:
	var scene := get_tree().current_scene if get_tree() else null
	return scene.find_child("EncounterAIDirector", true, false) as EncounterAIDirector if scene else null


## 调试用弹药重置：补满当前武器全部弹匣并上膛
func _debug_refill_ammo() -> void:
	var weapon = weapon_manager.current_weapon if weapon_manager else null
	if weapon:
		weapon.debug_refill_ammo()


## ConsoleSystem 使用的稳定调试接口；内部实现仍与原有调试入口共用。
func debug_refill_ammo() -> void:
	_debug_refill_ammo()


## Debug-only 受击镜头测试：通过正式 screen effect 回调触发，避免改写血量或伤口。
func _debug_trigger_pain_feedback(world_direction: Vector3) -> void:
	if not screen_effects or not is_alive or not controllable:
		return
	var info := DamageInfo.new()
	info.amount = 600.0
	info.body_part = MedicalEnums.BodyPartId.TORSO
	info.direction = world_direction.normalized()
	screen_effects._on_damage_taken(info)


func _on_started_sprinting() -> void:
	hand_ik_controller.set_movement_state(true, true)
	weapon_manager.release_trigger()
	weapon_manager.set_aiming(false)


func _on_stance_changed(value: float) -> void:
	"""协调所有受姿态影响的子系统"""
	if movement_controller:
		movement_controller._on_stance_changed(value)
	if camera_controller:
		camera_controller._on_stance_changed(value)


func go_unconscious(
	impact_direction: Vector3 = Vector3.ZERO,
	impact_energy_j: float = 0.0,
	impact_mass_kg: float = 0.0,
	impact_damage_type: MedicalEnums.DamageType = MedicalEnums.DamageType.BULLET
) -> void:
	if not is_alive:
		return
	acquire_control_lock(CONTROL_LOCK_UNCONSCIOUS)
	# 停止动画控制器的状态机，防止 AnimationTree 每帧覆盖物理骨骼姿势导致穿地
	animation_controller.on_unconscious()
	_activate_ragdoll(
		PlayerRagdollSystem.DeathType.GENERIC, impact_direction,
		impact_energy_j, impact_mass_kg, impact_damage_type
	)
	if screen_effects:
		screen_effects.trigger_unconscious_blur()
	GlobalLogger.info("Player", get_parent().name + " fell unconscious")


func regain_consciousness() -> void:
	if not is_alive or controllable:
		return
	var pos := global_position
	ragdoll_system.disable()
	global_position = pos
	is_ragdolled = false
	release_control_lock(CONTROL_LOCK_UNCONSCIOUS)
	if not is_ai_player:
		set_controllable(true)
	if not is_ai_player:
		camera_controller.enable_camera()
	_set_collision_enabled(true)
	if screen_effects:
		screen_effects.clear_death_blur()
	GlobalLogger.info("Player", get_parent().name + " regained consciousness")


func die(
	death_type: PlayerRagdollSystem.DeathType = PlayerRagdollSystem.DeathType.GENERIC,
	impact_direction: Vector3 = Vector3.ZERO,
	impact_energy_j: float = 0.0,
	impact_mass_kg: float = 0.0,
	impact_damage_type: MedicalEnums.DamageType = MedicalEnums.DamageType.BULLET
) -> void:
	if not is_alive:
		return
	var inherited_velocity := velocity
	is_alive = false
	_activate_ragdoll(
		death_type, impact_direction,
		impact_energy_j, impact_mass_kg, impact_damage_type, inherited_velocity
	)
	if screen_effects:
		screen_effects.trigger_death_blur()
	GlobalLogger.info("Player", "Player " + get_parent().name + "has died. (type: %d)" % death_type)


## 启动布娃娃物理的公共逻辑，die() 和 go_unconscious() 共用
func _activate_ragdoll(
	death_type: PlayerRagdollSystem.DeathType,
	impact_direction: Vector3,
	impact_energy_j: float = 0.0,
	impact_mass_kg: float = 0.0,
	impact_damage_type: MedicalEnums.DamageType = MedicalEnums.DamageType.BULLET,
	inherited_velocity: Vector3 = Vector3.ZERO
) -> void:
	if free_camera_controller:
		free_camera_controller.force_exit()
	if camera_controller:
		camera_controller.clear_pain_impulse()
		camera_controller.set_ragdoll_camera_shake(false)
	is_ragdolled = true
	velocity = Vector3.ZERO
	_set_collision_enabled(false)
	# 轻微上移玩家原点，给物理骨骼初始位置留出与地面的间隙，
	# 防止 Jolt 检测到初始穿插后将骨骼向下弹出
	global_position.y += 0.05
	if not is_ai_player and camera_controller:
		camera_controller.disable_camera(model_manager.skeleton)
		camera_controller.set_ragdoll_camera_shake(true)
		if not ragdoll_system.ragdoll_physics_started.is_connected(camera_controller.on_ragdoll_physics_started):
			ragdoll_system.ragdoll_physics_started.connect(camera_controller.on_ragdoll_physics_started, CONNECT_ONE_SHOT)
	ragdoll_system.enable.call_deferred(
		death_type, impact_direction,
		impact_energy_j, impact_mass_kg, impact_damage_type, inherited_velocity
	)

func revive() -> void:
	if is_alive:
		return

	# 记录当前位置，ragdoll_system.disable() 会重置骨骼位置
	var revive_position := global_position

	# 先恢复所有运行时组件，再广播 revived。否则监听者会在布娃娃仍处于
	# active 状态时重建碰撞体/动画，复活后的第一帧可能再次被控制流程拦截。
	ragdoll_system.disable()
	is_ragdolled = false
	velocity = Vector3.ZERO

	# 恢复到死亡时的位置
	global_position = revive_position

	if not is_ai_player:
		camera_controller.enable_camera()
	# 恢复玩家碰撞体
	_set_collision_enabled(true)

	if screen_effects:
		screen_effects.clear_death_blur()

	# 清理仅属于昏迷生命周期的锁；菜单等外部组件的锁由其自身释放。
	release_control_lock(CONTROL_LOCK_UNCONSCIOUS)
	is_alive = true

	GlobalLogger.info("Player", "Player " + get_parent().name + "has revived.")


## 初始化遭遇战出生状态，清理死亡、昏迷、布娃娃和控制锁残留。
func prepare_for_encounter_spawn(spawn_transform: Transform3D) -> void:
	if not is_alive:
		revive()
	elif health_system:
		health_system.reset_for_spawn()

	if ragdoll_system and is_ragdolled:
		ragdoll_system.disable()
	is_ragdolled = false
	velocity = Vector3.ZERO
	clear_ai_motion()
	clear_ai_input()
	if movement_controller:
		movement_controller.clear_locomotion_state()
	_set_collision_enabled(true)

	_controllable_fallback = true
	if control_state:
		control_state.reset_for_spawn()
	else:
		controllable = true
	if not is_ai_player:
		request_mouse_mode(MOUSE_OWNER_CAMERA, Input.MOUSE_MODE_CAPTURED, 0)
		if camera_controller:
			camera_controller.enable_camera()
	global_transform = spawn_transform


func set_controllable(enabled: bool) -> void:
	controllable = enabled
	GlobalLogger.info("Player", "Controller of player " + get_parent().name + " has been" + ("ENABLED" if enabled else "DISABLED"))

## Debug-only Bot motion bridge. The actual movement remains in the normal
## CharacterBody3D movement controller and is therefore visible to ragdoll.
func set_ai_player_test_motion(world_velocity: Vector3) -> bool:
	if not is_ai_player or not movement_controller or not is_alive:
		return false
	movement_controller.set_test_motion_velocity(world_velocity)
	return true

func stop_ai_player_test_motion() -> bool:
	if not is_ai_player or not movement_controller:
		return false
	movement_controller.clear_test_motion()
	return true

func is_bot_test_motion_active() -> bool:
	return is_ai_player and movement_controller and movement_controller.is_test_motion_active()


## Runtime AI movement bridge. This is separate from the console-only test
## motion bridge, while still using the normal CharacterBody3D movement path.
func set_ai_motion(world_velocity: Vector3) -> bool:
	if not is_ai_player or not movement_controller or not is_alive:
		return false
	movement_controller.set_ai_motion_velocity(world_velocity)
	return true


## Runtime AI virtual input. Movement is calculated by the same locomotion
## path used by the player, including stance, stamina, injury and acceleration.
func set_ai_input(world_direction: Vector3, running: bool = false, sprinting: bool = false) -> bool:
	if not is_ai_player or not movement_controller or not is_alive:
		return false
	movement_controller.set_ai_input(world_direction, running, sprinting)
	return true


func clear_ai_input() -> void:
	if movement_controller:
		movement_controller.clear_ai_input()


func set_ai_fire_input(pressed: bool) -> void:
	if not is_ai_player or not weapon_manager:
		return
	if pressed:
		weapon_manager.press_trigger()
	else:
		weapon_manager.release_trigger()


## AIPlayer 姿态输入，复用与玩家 C 键/滚轮相同的 StanceController。
func set_ai_stance(crouching: bool) -> bool:
	if not is_ai_player or not stance_controller or not is_alive:
		return false
	stance_controller.set_stance(1.0 if crouching else 0.0)
	return true


func clear_ai_motion() -> void:
	if movement_controller:
		movement_controller.clear_ai_motion()


## 由需要临时接管输入的组件持有独立锁，避免互相覆盖控制状态。
func acquire_control_lock(owner: String) -> void:
	if owner.is_empty():
		return
	if control_state:
		control_state.acquire_lock(owner)


## 释放指定组件的输入锁，不影响其他锁或玩家生命周期状态。
func release_control_lock(owner: String) -> void:
	if owner.is_empty():
		return
	if control_state:
		control_state.release_lock(owner)


func has_control_lock(owner: String) -> bool:
	return control_state.has_lock(owner) if control_state else false


func request_mouse_mode(owner: String, mode: int, priority: int = 0) -> void:
	if control_state:
		control_state.request_mouse_mode(owner, mode, priority)


func release_mouse_mode(owner: String) -> void:
	if control_state:
		control_state.release_mouse_mode(owner)


# Mod热重载
func reload_model() -> void:
	if player_config and player_config.model_scene:
		model_manager.load_model(
			player_config
		)
		

# 切换所有 CollisionShape3D 子节点的启用状态
# 布娃娃激活时需禁用，防止物理骨骼与自身碰撞体冲突
func _set_collision_enabled(enabled: bool) -> void:
	for child in get_children():
		if child is CollisionShape3D:
			child.disabled = not enabled
