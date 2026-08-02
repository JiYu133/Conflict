class_name BasePlayer
extends CharacterBody3D

const SETTINGS_SERVICE_SCRIPT := preload("res://classes/ui/settings/settings_service.gd")
const SETTINGS_MENU_SCRIPT := preload("res://classes/ui/settings/settings_menu.gd")
const PAUSE_MENU_SCRIPT := preload("res://classes/ui/pause_menu.gd")

# 在定义玩家对象时绑定给玩家的脚本 同时也要绑定玩家配置文件


# 导出变量


@export_group("Configuration")
@export var player_config: PlayerConfig

@export_group("State")
@export var is_alive: bool = true: # 玩家存活状态设置
	set(value):
		if is_alive == value:
			return
		is_alive = value
		# 外部直接赋值时，状态翻转自动广播信号
		if not is_alive:
			controllable = false
			died.emit()
		else:
			controllable = true
			revived.emit()
@export var controllable: bool = true
@export var faction: Faction = Faction.None # 玩家阵营
## 布娃娃激活期间为 true，movement controller 据此跳过物理更新
var is_ragdolled: bool = false




# 子系统引用

var stance_controller: StanceController
var model_manager: PlayerModelManager
var camera_controller: PlayerCameraController
var ragdoll_system: PlayerRagdollSystem
var movement_controller: PlayerMovementController
var foot_ik_controller: FootIKController
var hand_ik_controller: HandIKController
var weapon_manager: WeaponManager
var animation_controller: PlayerAnimationController
var health_system: HealthSystem
var stamina_system: StaminaSystem
var screen_effects: PlayerScreenEffects
var settings_service
var settings_menu
var pause_menu
var free_camera_controller: FreeCameraController
var medical_debug_menu: MedicalDebugMenu

# 信号


signal died
signal revived
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
		model_manager.load_model(
			player_config
		)	
	

# 子系统初始化

func _initialize_subsystems() -> void:
	GlobalLogger.info("Player", "Initializing player subsystems.")
	# 创建子系统
	settings_service = _create_subsystem(SETTINGS_SERVICE_SCRIPT.new(), "SettingsService")
	model_manager = _create_subsystem(PlayerModelManager.new(), "ModelManager")
	camera_controller = _create_subsystem(PlayerCameraController.new(),"CameraController")
	ragdoll_system = _create_subsystem(PlayerRagdollSystem.new(), "RagdollSystem")
	stance_controller = _create_subsystem(StanceController.new(), "StanceController")
	movement_controller = _create_subsystem(PlayerMovementController.new(), "MovementController")
	foot_ik_controller = _create_subsystem(FootIKController.new(), "FootIKController")
	hand_ik_controller = _create_subsystem(HandIKController.new(), "HandIKController")
	weapon_manager = _create_subsystem(WeaponManager.new(), "WeaponManager")
	animation_controller = _create_subsystem(PlayerAnimationController.new(), "AnimationController")
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
		settings_service
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

	health_system.initialize(
		self,
		player_config.health_config if player_config else null
		)

	stamina_system.initialize(self, player_config.stamina_config if player_config else null)

	screen_effects = _create_subsystem(PlayerScreenEffects.new(), "ScreenEffects")
	screen_effects.initialize(self)

	# 战斗通知桥接：连接 HealthSystem 信号到右上角通知栏
	var _combat_notif := _create_subsystem(CombatNotificationBridge.new(), "CombatNotifBridge")
	_combat_notif.initialize(self)

	# 暂停菜单拥有本地输入阻断；设置页由它打开，避免 ESC 直接跳入设置。
	settings_menu = _create_subsystem(SETTINGS_MENU_SCRIPT.new(), "SettingsMenu")
	settings_menu.initialize(settings_service)
	pause_menu = _create_subsystem(PAUSE_MENU_SCRIPT.new(), "PauseMenu")
	pause_menu.initialize(self, settings_menu)

	if OS.is_debug_build():
		free_camera_controller = _create_subsystem(FreeCameraController.new(), "FreeCameraController") as FreeCameraController
		medical_debug_menu = _create_subsystem(MedicalDebugMenu.new(), "MedicalDebugMenu") as MedicalDebugMenu
		medical_debug_menu.initialize(self)

	# 连接信号
	_connect_signals()

func _create_subsystem(subsystem: Node, node_name: String) -> Node: # 创建子系统
	subsystem.name = node_name
	add_child(subsystem)
	return subsystem

func _connect_signals() -> void:
	model_manager.model_loaded.connect(_on_model_loaded)
	weapon_manager.weapon_changed.connect(_on_weapon_changed)
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
	# 生理/体力状态 → 视觉效果
	health_system.damage_taken.connect(screen_effects._on_damage_taken)
	health_system.pain_changed.connect(screen_effects._on_pain_changed)
	stamina_system.stamina_changed.connect(screen_effects._on_stamina_changed)
	GlobalLogger.debug("Player", "Signals have been connected. ")


func _on_model_loaded(_model: Node3D) -> void:

	# 初始化布娃娃系统（需要骨骼、动画系统及配置）
	# 武器挂载点此时尚未查找到，待下方定位后通过 set_weapon_mount() 注入
	ragdoll_system.initialize(
		model_manager.skeleton,
		model_manager.animator,
		model_manager.animation_tree,
		player_config.ragdoll_config if player_config else null
	)

	# 将模型从 ModelManager 移到自己身下，确保变换跟随
	# 必须在 animation_controller.initialize() 之前完成，
	# 否则 travel("Idle") 在模型离开场景树时触发，重挂载后 playback 状态丢失
	if _model.get_parent():
		_model.get_parent().remove_child(_model)
	add_child(_model)
	# 模型面朝+Z时需旋转180°对齐角色朝向(-Z = forward)
	_model.rotation.y = PI

		# 模型就位后再初始化动画控制器，确保 AnimationTree 已稳定在场景树中
	animation_controller.initialize(self, movement_controller, model_manager, player_config)
	hand_ik_controller.setup(model_manager.skeleton, player_config.hand_ik_config if player_config else null)
	camera_controller._find_camera_nodes()
	camera_controller.enable_camera()
	
	var mount = model_manager.find_node_by_names(["WeaponMount"], "Node3D")
	if mount:
		GlobalLogger.info("Player", "Weapon mount has been set: " + mount.name)
		# 武器直接挂在右手骨骼的 BoneAttachment3D 下（WeaponMount），随右手动画移动。
		# 不要改挂到模型下的静态节点：那样只能在模型加载瞬间采样一次右手位置
		# （此时骨骼仍是 rest/T-pose），武器会被焊死在体侧且不随视角俯仰。
		# 左手再通过 IK 抓握武器上的 LeftHandGrip（见 HandIKController）。
		ragdoll_system.set_weapon_mount(mount)
		var sway_pivot: Node3D = camera_controller.setup_weapon_sway_pivot(mount)
		if sway_pivot:
			weapon_manager.set_mount(sway_pivot)
			GlobalLogger.info("Player", "Weapon sway pivot created, weapons attach under: " + sway_pivot.name)
		else:
			weapon_manager.set_mount(mount)
	else:
		GlobalLogger.error("Player", "Cannot find any weapon mount,the weapon will be not visible.")
		GlobalLogger.error("Player", "If there's already a weapon mount,try to check if its name is \"WeaponMount\" ")

	if player_config and player_config.starting_weapon:
		GlobalLogger.debug("Player", "Initializing player's starting weapon...")
		weapon_manager.load_and_equip(player_config.starting_weapon)

	if OS.is_debug_build() and free_camera_controller:
		free_camera_controller.initialize(self, camera_controller)

# 公共API


func _on_weapon_changed(new_weapon: BaseWeapon) -> void:
	if new_weapon and new_weapon.recoil_component:
		camera_controller.set_recoil_component(new_weapon.recoil_component)
	else:
		camera_controller.set_recoil_component(null)
	var weight := new_weapon.config.left_hand_ik_weight if new_weapon and new_weapon.config else 1.0
	hand_ik_controller.set_weapon(new_weapon, weight)


func _process(delta: float) -> void:
	if is_alive:
		hand_ik_controller.process_ik(delta)
		foot_ik_controller.process_ik(delta)


func _input(event: InputEvent) -> void:
	# 暂停菜单/设置页打开时，本地玩家让出全部输入。
	if (settings_menu and settings_menu.is_open()) or (pause_menu and pause_menu.is_open()):
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
		# 瞄准（ADS）
		if event.is_action_pressed("aim"):
			weapon_manager.set_aiming(true)
		if event.is_action_released("aim"):
			weapon_manager.set_aiming(false)
		# 切换射击模式
		if event.is_action_pressed("cycle_fire_mode"):
			weapon_manager.cycle_fire_mode()
		# 排障
		if event.is_action_pressed("clear_malfunction"):
			weapon_manager.attempt_malfunction_clearance()

	if not OS.is_debug_build():
		return

	# 自由视角切换（可在设置菜单重绑定，默认 F）
	if event.is_action_pressed("toggle_free_cam"):
		if free_camera_controller:
			free_camera_controller.toggle()

	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_F11:
				# 切换全屏/窗口模式
				if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
					DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
					GlobalLogger.info("Player", "切换到窗口模式")
				else:
					DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
					GlobalLogger.info("Player", "切换到全屏模式")
			KEY_T:
				if free_camera_controller:
					free_camera_controller.debug_shoot(MedicalEnums.BodyPartId.TORSO)
			KEY_Y:
				if free_camera_controller:
					free_camera_controller.debug_shoot(MedicalEnums.BodyPartId.HEAD)
			KEY_U:
				if free_camera_controller:
					free_camera_controller.debug_shoot_explosion()
			KEY_R:
				# 调试复活（仅 debug 构建）：死亡状态下按 R 原地复活并清除全部伤情。
				if not is_alive:
					revive()


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


func go_unconscious(impact_direction: Vector3 = Vector3.ZERO) -> void:
	if not is_alive:
		return
	# 停止动画控制器的状态机，防止 AnimationTree 每帧覆盖物理骨骼姿势导致穿地
	animation_controller.on_unconscious()
	_activate_ragdoll(PlayerRagdollSystem.DeathType.GENERIC, impact_direction)
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
	controllable = true
	camera_controller.enable_camera()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	_set_collision_enabled(true)
	if screen_effects:
		screen_effects.clear_death_blur()
	GlobalLogger.info("Player", get_parent().name + " regained consciousness")


func die(death_type: PlayerRagdollSystem.DeathType = PlayerRagdollSystem.DeathType.GENERIC, impact_direction: Vector3 = Vector3.ZERO) -> void:
	if not is_alive:
		return
	is_alive = false
	_activate_ragdoll(death_type, impact_direction)
	if screen_effects:
		screen_effects.trigger_death_blur()
	GlobalLogger.info("Player", "Player " + get_parent().name + "has died. (type: %d)" % death_type)


## 启动布娃娃物理的公共逻辑，die() 和 go_unconscious() 共用
func _activate_ragdoll(death_type: PlayerRagdollSystem.DeathType, impact_direction: Vector3) -> void:
	is_ragdolled = true
	velocity = Vector3.ZERO
	_set_collision_enabled(false)
	# 轻微上移玩家原点，给物理骨骼初始位置留出与地面的间隙，
	# 防止 Jolt 检测到初始穿插后将骨骼向下弹出
	global_position.y += 0.05
	camera_controller.disable_camera(model_manager.skeleton)
	if not ragdoll_system.ragdoll_physics_started.is_connected(camera_controller.on_ragdoll_physics_started):
		ragdoll_system.ragdoll_physics_started.connect(camera_controller.on_ragdoll_physics_started, CONNECT_ONE_SHOT)
	ragdoll_system.enable.call_deferred(death_type, impact_direction)

func revive() -> void:
	if is_alive:
		return

	# 记录当前位置，ragdoll_system.disable() 会重置骨骼位置
	var revive_position := global_position

	is_alive = true
	is_ragdolled = false
	velocity = Vector3.ZERO
	ragdoll_system.disable()

	# 恢复到死亡时的位置
	global_position = revive_position

	camera_controller.enable_camera()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	# 恢复玩家碰撞体
	_set_collision_enabled(true)

	if screen_effects:
		screen_effects.clear_death_blur()

	GlobalLogger.info("Player", "Player " + get_parent().name + "has revived.")


func set_controllable(enabled: bool) -> void:
	controllable = enabled
	GlobalLogger.info("Player", "Controller of player " + get_parent().name + " has been" + ("ENABLED" if enabled else "DISABLED"))


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
