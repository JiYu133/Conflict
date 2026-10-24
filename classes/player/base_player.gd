class_name BasePlayer
extends CharacterBody3D

## Override with a LoggerService implementation to inject player logging.
var _logger: LoggerService = GlobalLogger

const SETTINGS_SERVICE_SCRIPT := preload("res://classes/services/settings_service.gd")
const CONTROL_STATE_SCRIPT := preload("res://classes/player/system/player_control_state.gd")
const DEATH_BLOOD_EFFECT_SCRIPT := preload("res://classes/player/medical/death_blood_effect.gd")
const WEAPON_DROP_SYSTEM_SCRIPT := preload("res://classes/player/system/weapon_drop_system.gd")

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
var _prone_collision_sampling_pending_frames: int = 0

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
var look_controller: PlayerLookController
var camera_controller: PlayerCameraController
var weapon_presentation_controller: WeaponPresentationController
var aim_breathing_controller: AimBreathingController
var weapon_obstruction_detector: WeaponObstructionDetector
var optic_render_controller: OpticRenderController
var ragdoll_system: PlayerRagdollSystem
var movement_controller: PlayerMovementController
var collision_controller: PlayerCollisionController
var ik_rig: IKRig
var spine_aim_controller: SpineAimController
var weapon_manager: WeaponManager
var weapon_feedback: PlayerWeaponFeedback
var weapon_drop_system: WeaponDropSystem
var animation_controller: PlayerAnimationController
var turn_controller: PlayerTurnController
var health_system: HealthSystem
var death_blood_effect: DeathBloodEffect
var combat_effects: CombatEffects
var stamina_system: StaminaSystem
var audio_controller: PlayerAudioController
var force_receiver: ForceReceiver
var screen_effects
var settings_service
var ui_layer: PlayerUILayer
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
var _ai_test_fire_override: int = -1 # -1=AI control, 0=forced release, 1=forced press

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

func _require_absent(stage: String, deps: Dictionary) -> void:
	for key in deps:
		assert(
			not is_instance_valid(deps[key]),
			"[Player 装配顺序] %s 应在本阶段创建「%s」，但它已经存在 —— 该阶段被执行了两次，或被提前。" % [stage, key]
		)


func _require_ready(stage: String, deps: Dictionary) -> void:
	for key in deps:
		assert(
			is_instance_valid(deps[key]),
			"[Player 装配顺序] %s 需要「%s」已就绪，但当前为空 —— 该阶段被推后，或它依赖的阶段未执行。" % [stage, key]
		)


func _initialize_subsystems() -> void:
	_logger.info("Player", "Initializing player subsystems.")
	# 本函数只做调度；每个阶段的依赖声明写在各阶段函数开头（依赖图见上方）。
	_create_core_subsystems()
	_initialize_controllers()
	_initialize_combat_feedback()
	_create_ui_subsystems()
	_connect_signals()


func _create_core_subsystems() -> void:
	_require_absent("_create_core_subsystems", {
		"control_state": control_state,
		"settings_service": settings_service,
		"model_manager": model_manager,
		"weapon_manager": weapon_manager,
		"health_system": health_system,
	})
	# 创建子系统
	control_state = _create_subsystem(CONTROL_STATE_SCRIPT.new(), "ControlState") as PlayerControlState
	control_state.set_alive(_is_alive)
	control_state.set_base_enabled(_controllable_fallback)
	settings_service = _create_subsystem(SETTINGS_SERVICE_SCRIPT.new(), "SettingsService")
	model_manager = _create_subsystem(PlayerModelManager.new(), "ModelManager")
	look_controller = _create_subsystem(PlayerLookController.new(), "LookController") as PlayerLookController
	camera_controller = _create_subsystem(PlayerCameraController.new(),"CameraController")
	if not is_ai_player:
		optic_render_controller = _create_subsystem(OpticRenderController.new(), "OpticRenderController") as OpticRenderController
	ragdoll_system = _create_subsystem(PlayerRagdollSystem.new(), "RagdollSystem")
	stance_controller = _create_subsystem(StanceController.new(), "StanceController")
	movement_controller = _create_subsystem(PlayerMovementController.new(), "MovementController")
	collision_controller = _create_subsystem(PlayerCollisionController.new(), "CollisionController")
	ik_rig = _create_subsystem(IKRig.new(), "IKRig") as IKRig
	spine_aim_controller = _create_subsystem(SpineAimController.new(), "SpineAimController")
	weapon_manager = _create_subsystem(WeaponManager.new(), "WeaponManager")
	weapon_presentation_controller = _create_subsystem(WeaponPresentationController.new(), "WeaponPresentationController") as WeaponPresentationController
	aim_breathing_controller = _create_subsystem(AimBreathingController.new(), "AimBreathingController") as AimBreathingController
	weapon_obstruction_detector = _create_subsystem(WeaponObstructionDetector.new(), "WeaponObstructionDetector") as WeaponObstructionDetector
	weapon_drop_system = _create_subsystem(WEAPON_DROP_SYSTEM_SCRIPT.new(), "WeaponDropSystem") as WeaponDropSystem
	animation_controller = _create_subsystem(PlayerAnimationController.new(), "AnimationController")
	turn_controller = _create_subsystem(PlayerTurnController.new(), "TurnController")
	health_system = _create_subsystem(HealthSystem.new(), "HealthSystem")
	stamina_system = _create_subsystem(StaminaSystem.new(), "StaminaSystem")
	audio_controller = _create_subsystem(PlayerAudioController.new(), "PlayerAudioController") as PlayerAudioController
	force_receiver = _create_subsystem(ForceReceiver.new(), "ForceReceiver") as ForceReceiver


func _initialize_controllers() -> void:
	_require_ready("_initialize_controllers", {
		"settings_service": settings_service,
		"model_manager": model_manager,
		"look_controller": look_controller,
		"camera_controller": camera_controller,
		"stance_controller": stance_controller,
		"movement_controller": movement_controller,
		"ik_rig": ik_rig,
		"weapon_presentation_controller": weapon_presentation_controller,
		"aim_breathing_controller": aim_breathing_controller,
		"weapon_obstruction_detector": weapon_obstruction_detector,
		"animation_controller": animation_controller,
		"weapon_manager": weapon_manager,
		"weapon_drop_system": weapon_drop_system,
		"health_system": health_system,
		"force_receiver": force_receiver,
	})
	# 初始化子系统
	settings_service.initialize()
	look_controller.initialize(
		self,
		player_config.camera_config if player_config else null,
		settings_service
	)

	stance_controller.initialize(self, player_config)

	camera_controller.initialize(
		self,
		model_manager,
		player_config.model_config if player_config else null,
		player_config.camera_config if player_config else null,
		settings_service,
		not is_ai_player,
		look_controller
		)

	movement_controller.initialize(
		self,
		player_config,
		camera_controller
		)

	weapon_presentation_controller.initialize(_get_weapon_presentation_state)
	var aim_config := player_config.aim_config if player_config else null
	camera_controller.set_aim_config(aim_config)
	aim_breathing_controller.initialize(aim_config, _get_aim_breathing_state)
	aim_breathing_controller.idle_pause_changed.connect(animation_controller.set_idle_paused)
	# Read the new camera blend before animation evaluates and IK samples it.
	aim_breathing_controller.process_priority = -10
	weapon_manager.weapon_changed.connect(weapon_presentation_controller.bind_weapon)
	camera_controller.set_weapon_presentation_controller(weapon_presentation_controller)
	weapon_obstruction_detector.initialize(self, _get_weapon_probe_origin, _get_weapon_probe_muzzle,
		weapon_presentation_controller.get_obstruction_probe_radius)
	weapon_obstruction_detector.obstruction_changed.connect(weapon_presentation_controller.set_obstruction_target)
	weapon_manager.set_fire_gate(_is_weapon_path_clear)
	# Camera reads look input first; the skeleton arm stage then advances weapon
	# springs using the animation pose before either hand modifies the bones.
	camera_controller.process_priority = -20
	if optic_render_controller:
		optic_render_controller.process_priority = 100

	ik_rig.initialize(
		self,
		model_manager,
		player_config.ik_config if player_config else null,
		weapon_presentation_controller
		)


	weapon_manager.set_camera_controller(camera_controller)
	weapon_manager.set_settings_service(settings_service)
	if optic_render_controller:
		optic_render_controller.initialize(self, weapon_manager, camera_controller)
		ik_rig.arms_processed.connect(optic_render_controller.refresh_render)
	weapon_drop_system.initialize(self, weapon_manager)

	health_system.initialize(
		self,
		player_config.health_config if player_config else null
		)
	# 力系统只做姿态叠加与冲量缓存，不参与伤害判定。
	force_receiver.initialize(
		self,
		player_config.force_config if player_config else null
		)


func _initialize_combat_feedback() -> void:
	_require_ready("_initialize_combat_feedback", {
		"settings_service": settings_service,
		"health_system": health_system,
		"stamina_system": stamina_system,
		"audio_controller": audio_controller,
		"movement_controller": movement_controller,
		"collision_controller": collision_controller,
	})
	_require_absent("_initialize_combat_feedback", {
		"death_blood_effect": death_blood_effect,
		"combat_effects": combat_effects,
		"weapon_feedback": weapon_feedback,
	})
	var movement_config := (
		player_config.movement_config
		if player_config and player_config.movement_config
		else MovementConfig.new()
	)
	var envelope_provider := (
		Callable(health_system, "get_collision_envelope")
		if movement_config.hitbox_driven_collision
		else Callable()
	)
	collision_controller.initialize(self, movement_config, envelope_provider)
	_sync_pose_geometry()
	death_blood_effect = _create_subsystem(DEATH_BLOOD_EFFECT_SCRIPT.new(), "DeathBloodEffect") as DeathBloodEffect
	death_blood_effect.initialize(
		self,
		player_config.blood_effect_config if player_config else null,
		settings_service,
		Callable(health_system, "get_major_external_bleed_world_position")
		)

	# 命中反馈只消费医疗系统结果：伤口、喷溅、滴落与血泊不反向影响伤害判定。
	combat_effects = _create_subsystem(CombatEffects.new(), "CombatEffects")
	combat_effects.initialize(self)

	stamina_system.initialize(self, player_config.stamina_config if player_config else null)
	audio_controller.initialize(self, settings_service)

	weapon_feedback = _create_subsystem(PlayerWeaponFeedback.new(), "WeaponFeedback") as PlayerWeaponFeedback
	weapon_feedback.initialize(force_receiver, ik_rig, camera_controller, stamina_system, weapon_manager)


func _create_ui_subsystems() -> void:
	_require_ready("_create_ui_subsystems", {
		"settings_service": settings_service,
		"weapon_manager": weapon_manager,
	})
	_require_absent("_create_ui_subsystems", {
		"ui_layer": ui_layer,
		"medical_treatment_component": medical_treatment_component,
	})
	# 仅非 AI 的本地玩家：屏幕效果、医疗治疗组件、自由相机仍由玩家核心创建；
	# 全部「具体界面」（HUD / 菜单 / 控制台 / 径向菜单）交给 UI 层，玩家核心不碰界面类型。
	if not is_ai_player:
		screen_effects = _create_subsystem(PlayerScreenEffects.new(), "ScreenEffects")
		screen_effects.initialize(self, settings_service)

		# 医疗治疗组件：节点名 "MedicalTreatment" 被 encounter_prototype 按路径读取，须留在玩家下。
		medical_treatment_component = _create_subsystem(preload("res://classes/encounter/medical_treatment_component.gd").new(), "MedicalTreatment") as MedicalTreatmentComponent
		medical_treatment_component.initialize(self)

		# UI 层：自己创建并持有 HUD / 设置 / 暂停 / 改装 / 控制台，并注册径向菜单轮盘。
		# 依赖显式注入；玩家核心只把产物引用回填到自己的字段上
		# （这些字段被 console_system、medical_debug_hud 等按名读取，必须保留）。
		ui_layer = _create_subsystem(PlayerUILayer.new(), "UILayer") as PlayerUILayer
		ui_layer.initialize(self, settings_service, weapon_manager, medical_treatment_component)
		settings_menu = ui_layer.settings_menu
		pause_menu = ui_layer.pause_menu
		weapon_mod_menu = ui_layer.weapon_mod_menu
		console_system = ui_layer.console_system
		radial_menu_service = ui_layer.radial_menu_service

		if OS.is_debug_build():
			free_camera_controller = _create_subsystem(FreeCameraController.new(), "FreeCameraController") as FreeCameraController


func _create_subsystem(subsystem: Node, node_name: String) -> Node: # 创建子系统
	subsystem.name = node_name
	add_child(subsystem)
	return subsystem

func _connect_signals() -> void:
	_require_ready("_connect_signals", {
		"model_manager": model_manager,
		"weapon_manager": weapon_manager,
		"stance_controller": stance_controller,
		"collision_controller": collision_controller,
		"movement_controller": movement_controller,
		"stamina_system": stamina_system,
		"health_system": health_system,
		"force_receiver": force_receiver,
		"weapon_feedback": weapon_feedback,
	})
	model_manager.model_loaded.connect(_on_model_loaded)
	weapon_manager.weapon_changed.connect(weapon_feedback.on_weapon_changed)
	weapon_manager.weapon_stats_changed.connect(weapon_feedback.sync_carry_weight_to_stamina)
	# 连接姿态变化信号
	stance_controller.stance_changed.connect(_on_stance_changed)
	stance_controller.prone_geometry_changed.connect(_on_prone_geometry_changed)
	stance_controller.prone_transition_changed.connect(_on_prone_transition_changed)
	collision_controller.transition_blocked.connect(_on_collision_transition_blocked)
	# Sprint 开始时强制取消 ADS，并同步 IK 状态
	movement_controller.started_sprinting.connect(_on_started_sprinting)
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
	# 受击反馈：本期唯一接入点。力系统消费 damage_taken，
	# 姿态偏移由 ForceBodyModifier 叠加，冲量缓存供布娃娃消费。
	health_system.damage_taken.connect(force_receiver.apply_impact)
	_logger.debug("Player", "Signals have been connected. ")


func _on_model_loaded(_model: Node3D) -> void:
	# 模型接入装配管线：按「布娃娃 → 挂模型 → 动画/控制器 → 骨骼相关 → 相机 → 武器挂点 → 初始武器」
	# 的顺序分步执行。原先这是一个 87 行的单体函数，拆开后每一步都能单独读懂与定位。
	var weapon_mount := model_manager.find_node_by_names(["WeaponMount"], "Node3D") as Node3D
	_setup_ragdoll(weapon_mount)
	_attach_model_to_player(_model)
	_activate_animation_and_controllers()
	_bind_skeleton_systems()
	_setup_camera_activation(_model)
	_setup_weapon_mount(weapon_mount, _model)
	_equip_starting_weapon()
	if OS.is_debug_build() and free_camera_controller:
		free_camera_controller.initialize(self, camera_controller)


## 初始化布娃娃系统（需要骨骼、动画系统及配置）


func _setup_ragdoll(weapon_mount: Node3D) -> void:
	ragdoll_system.initialize(
		model_manager.skeleton,
		model_manager.animator,
		model_manager.animation_tree,
		player_config.ragdoll_config if player_config else null,
		weapon_mount
	)


## 将模型从 ModelManager 移到自己身下，确保变换跟随。
## 必须在 animation_controller.initialize() 之前完成，
## 否则动画状态机可能在模型离开场景树时初始化，重挂载后状态会丢失。


func _attach_model_to_player(model: Node3D) -> void:
	if model.get_parent():
		model.get_parent().remove_child(model)
	add_child(model)
	# 模型面朝 +Z 时需旋转 180° 对齐角色朝向（-Z = forward）
	model.rotation.y = PI
	_sync_pose_geometry()


## 模型就位后再启用动画组件并初始化控制器。Bot 没有本地相机来间接驱动
## 模型动画，因此必须在读取 playback 和进入 Idle 前显式启用它们。


func _activate_animation_and_controllers() -> void:
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


## 力系统在骨骼就绪后接管姿态叠加，并成为布娃娃的力提供者。
## IKRig 把自己的 modifier 排在这些姿态叠加之后，IK 拥有最终发言权。


func _bind_skeleton_systems() -> void:
	force_receiver.set_skeleton(model_manager.skeleton)
	_setup_force_modifier(model_manager.skeleton)
	ragdoll_system.set_force_provider(force_receiver)
	ik_rig.bind_skeleton(model_manager.skeleton)


## 本地玩家：直接启用相机。
## Bot：保留模型层级里的 authored 相机节点（动画/附件路径可能依赖它们），
## 但绝不允许它们成为活动的 bot 相机。


func _setup_camera_activation(model: Node3D) -> void:
	if not is_ai_player:
		camera_controller._find_camera_nodes()
		camera_controller.enable_camera()
		return
	for camera_node in model.find_children("*", "Camera3D", true, false):
		var model_camera := camera_node as Camera3D
		if model_camera:
			model_camera.current = false
			model_camera.process_mode = Node.PROCESS_MODE_DISABLED
	_configure_bot_visuals(model)


## 绑定武器挂点。WeaponMount 只作为动画姿态来源，真正的武器挂在独立骨架上，
## 让双手都能向握把求解，避免旧的「右手→武器→右手」反馈环。


func _setup_weapon_mount(weapon_mount: Node3D, model: Node3D) -> void:
	if not weapon_mount:
		_logger.error("Player", "Cannot find any weapon mount,the weapon will be not visible.")
		_logger.error("Player", "If there's already a weapon mount,try to check if its name is \"WeaponMount\" ")
		return
	_logger.info("Player", "Weapon mount has been set: " + weapon_mount.name)
	var sway_pivot: Node3D = camera_controller.setup_weapon_sway_pivot(weapon_mount, model)
	if sway_pivot:
		weapon_manager.set_mount(sway_pivot)
		ragdoll_system.set_weapon_mount(camera_controller.get_weapon_pose_root())
		_logger.info("Player", "Weapon sway pivot created, weapons attach under: " + sway_pivot.name)
	else:
		weapon_manager.set_mount(weapon_mount)
		ragdoll_system.set_weapon_mount(weapon_mount)


## 装备配置里的初始武器；AI 走延迟加载，避免多 bot 同帧构建场景树。


func _equip_starting_weapon() -> void:
	if player_config and player_config.starting_weapon:
		_logger.debug("Player", "Initializing player's starting weapon...")
		if is_ai_player:
			_load_ai_starting_weapon.call_deferred(player_config.starting_weapon)
		else:
			weapon_manager.load_and_equip(player_config.starting_weapon)
	elif is_ai_player:
		_mark_ai_runtime_ready()


## 创建力姿态修饰器。IKRig 会把它排在 IK 之前，IK 在力偏移之上求解，
## 把被推开的双手拉回武器；摄像机不参与本期力系统。


func _setup_force_modifier(skeleton: Skeleton3D) -> void:
	if not is_instance_valid(skeleton) or not force_receiver:
		return
	var modifier := ForceBodyModifier.new()
	modifier.name = "ForceBodyModifier"
	skeleton.add_child(modifier)
	modifier.setup(force_receiver)


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

## Distribute one weapon recoil wrench over the active stock and hand contacts.
func apply_weapon_recoil(weapon: BaseWeapon, recoil_data: Dictionary) -> void:
	if is_ragdolled:
		return
	weapon_feedback.apply_recoil(weapon, recoil_data)


func _process(delta: float) -> void:
	if weapon_manager and weapon_manager.is_aiming and (not is_alive or not controllable):
		weapon_manager.cancel_aiming()
	var stance_geometry_settled := not stance_controller \
			or not stance_controller.is_stance_transitioning()
	if _prone_collision_sampling_pending_frames > 0 \
			and stance_controller \
			and not stance_controller.is_prone_transitioning() \
			and stance_geometry_settled:
		_prone_collision_sampling_pending_frames -= 1
		if _prone_collision_sampling_pending_frames == 0 and collision_controller:
			collision_controller.set_envelope_sampling_enabled(true)
	var procedural_animation_active := is_alive and not is_ragdolled
	var prone := stance_controller and (stance_controller.is_prone() or stance_controller.is_prone_transitioning())
	if prone:
		_sync_prone_mesh_floor_offset()
	# Prone clips own the spine and lower body, but the left hand must continue
	# following the weapon grip or the full-body clip lets it release the rifle.
	spine_aim_controller.process_aim(delta, procedural_animation_active and not prone)
	# The independent weapon rig still samples the authored hand pose when arm IK
	# is disabled, including the pre-physics death-animation phase.
	if not procedural_animation_active and not is_ragdolled:
		weapon_presentation_controller.ensure_pose_current(delta)
	ik_rig.update(delta, procedural_animation_active, prone, movement_controller.is_sprinting())


func _sync_prone_mesh_floor_offset() -> void:
	if not model_manager or not player_config or not player_config.movement_config:
		return
	var config := player_config.movement_config
	var stance_value := stance_controller.get_stance_value() if stance_controller else 0.0
	var prone_blend := stance_controller.get_prone_geometry_blend() if stance_controller else 0.0
	var non_prone_model_y := lerpf(config.model_y_offset, config.crouch_y_offset, stance_value)
	var target_offset := lerpf(non_prone_model_y, config.prone_model_y_offset, prone_blend)
	# Keep one mesh-root reference for every prone locomotion clip. Per-frame
	# hitbox bounds vary with the animation and would move the head-mounted
	# camera when idle/forward/lateral clips cross-fade.
	model_manager.set_model_vertical_offset(target_offset)


func _input(event: InputEvent) -> void:
	# 任一界面（暂停 / 设置 / 改装 / 控制台 / 径向菜单）打开时，本地玩家让出全部输入。
	if _is_ui_capturing_input():
		return
	_handle_gameplay_input(event)
	if not OS.is_debug_build():
		return
	_handle_debug_action_input(event)
	_handle_debug_key_input(event)


## 有界面正在独占输入时不响应玩家输入。


func _is_ui_capturing_input() -> bool:
	return (settings_menu and settings_menu.is_open()) \
			or (pause_menu and pause_menu.is_open()) \
			or (weapon_mod_menu and weapon_mod_menu.is_open()) \
			or (console_system and console_system.is_open()) \
			or (radial_menu_service and radial_menu_service.is_open())


## 正式玩法输入：瞄准 / 换弹 / 开火 / 排障。


func _handle_gameplay_input(event: InputEvent) -> void:
	if not (is_alive and controllable):
		return
	# 瞄准：按住与切换模式共享同一个可重绑定动作。
	if event.is_action_pressed("aim"):
		var ads_mode := String(settings_service.get_value("controls/ads_input_mode", "hold"))
		_request_aim(not weapon_manager.is_aiming if ads_mode == "toggle" else true)
	elif event.is_action_released("aim") \
			and String(settings_service.get_value("controls/ads_input_mode", "hold")) == "hold":
		_request_aim(false)
	# 换弹
	if event.is_action_pressed("reload"):
		weapon_manager.reload()
	# 开火
	if event.is_action_pressed("fire"):
		weapon_manager.press_trigger()
	if event.is_action_released("fire"):
		weapon_manager.release_trigger()
	# 排障
	if event.is_action_pressed("clear_malfunction"):
		weapon_manager.attempt_malfunction_clearance()


## Debug 构建专属：可重绑定动作触发的调试开关（自由相机 / 调试复活 / 改装界面）。


func _handle_debug_action_input(event: InputEvent) -> void:
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


## Debug 构建专属：裸键位调试动作。


func _handle_debug_key_input(event: InputEvent) -> void:
	if not (event is InputEventKey and event.pressed and not event.echo):
		return
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


## 径向菜单「内容构建 + 轮盘注册」已整体下移到 UI 层：
## classes/ui/player_ui_layer.gd（_register_radial_wheels / _get_*_wheel_options / _issue_squad_command）。
## 玩家核心不再持有任何轮盘内容或回调构造逻辑。


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
	weapon_manager.release_trigger()
	weapon_manager.cancel_aiming()


func _request_aim(enabled: bool) -> void:
	if enabled and movement_controller and movement_controller.is_sprinting():
		movement_controller.suppress_sprint_until_release()
	weapon_manager.set_aiming(enabled)


func _on_stance_changed(value: float) -> void:
	"""协调所有受姿态影响的子系统"""
	if movement_controller:
		movement_controller.apply_stance_value(value)
	if camera_controller:
		camera_controller.apply_stance_value(value)
	_sync_pose_geometry()


func _on_prone_geometry_changed(_blend: float) -> void:
	_sync_pose_geometry()


func _on_prone_transition_changed(_active: bool) -> void:
	if collision_controller:
		if _active:
			_prone_collision_sampling_pending_frames = 0
			collision_controller.set_envelope_sampling_enabled(false)
		elif stance_controller and stance_controller.is_prone():
			# Keep the prone capsule on the same authored fallback path used by
			# crouch. Re-enabling animation-envelope fitting while prone would let
			# an idle/roll pose replace the interpolated target and move the body
			# root, which is visible immediately through the head-mounted camera.
			_prone_collision_sampling_pending_frames = 0
			collision_controller.set_envelope_sampling_enabled(false)
		else:
			# AnimationPlayer applies the post-transition clip on the next frame.
			# Keep envelope fitting disabled until that pose is visible, otherwise
			# the old prone skeleton is sampled as the new standing state begins.
			_prone_collision_sampling_pending_frames = 2
	_sync_pose_geometry()


## Collision owns world-clearance policy; stance owns pose state. BasePlayer is
## the only place that translates the value-only rejection signal between them.
func _on_collision_transition_blocked() -> void:
	if stance_controller:
		stance_controller.reject_collision_transition()


## BasePlayer is the composition root for pose presentation. Components receive
## primitive values through public interfaces and never retain one another.
func _sync_pose_geometry() -> void:
	if not player_config or not player_config.movement_config:
		return
	var config := player_config.movement_config
	var stance_value := stance_controller.get_stance_value() if stance_controller else 0.0
	var prone_blend := stance_controller.get_prone_geometry_blend() if stance_controller else 0.0
	var non_prone_height := lerpf(
		config.collision_shape_height,
		config.crouch_capsule_height,
		stance_value
	)
	var fallback_height := lerpf(non_prone_height, config.prone_capsule_height, prone_blend)
	var non_prone_center := config.collision_shape_y_offset \
		+ (non_prone_height - config.collision_shape_height) * 0.5
	var fallback_center_y := lerpf(
		non_prone_center,
		config.prone_collision_y_offset,
		prone_blend
	)
	if collision_controller:
		collision_controller.set_fallback_geometry(fallback_height, fallback_center_y)
	var non_prone_model_y := lerpf(config.model_y_offset, config.crouch_y_offset, stance_value)
	var model_y := lerpf(non_prone_model_y, config.prone_model_y_offset, prone_blend)
	if model_manager:
		model_manager.set_model_vertical_offset(model_y)


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
	_logger.info("Player", get_parent().name + " fell unconscious")


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
	_logger.info("Player", get_parent().name + " regained consciousness")


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
	weapon_manager.cancel_aiming()
	is_alive = false
	# Recoil and hit pose state must not leak into the ragdoll lifecycle. The
	# pending impact impulse is kept separately for PlayerRagdollSystem.
	if force_receiver:
		force_receiver.clear_recoil_state()
	_activate_ragdoll(
		death_type, impact_direction,
		impact_energy_j, impact_mass_kg, impact_damage_type, inherited_velocity
	)
	if screen_effects:
		screen_effects.trigger_death_blur()
	_logger.info("Player", "Player " + get_parent().name + "has died. (type: %d)" % death_type)


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
		camera_controller.reset_weapon_pose_to_hip()
	is_ragdolled = true
	spine_aim_controller.process_aim(0.0, false)
	ik_rig.update(0.0, false, false, false)
	velocity = Vector3.ZERO
	clear_ai_player_test_fire()
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
	# 复活后不保留旧受力与旧冲量，避免下一帧姿态突变或误用死亡前的动量。
	if force_receiver:
		force_receiver.clear_forces()
		force_receiver.clear_pending_impulse()
	is_alive = true

	_logger.info("Player", "Player " + get_parent().name + "has revived.")


## 初始化遭遇战出生状态，清理死亡、昏迷、布娃娃和控制锁残留。
func prepare_for_encounter_spawn(spawn_transform: Transform3D) -> void:
	if not is_alive:
		revive()
	elif health_system:
		health_system.reset_for_spawn()

	if ragdoll_system and is_ragdolled:
		ragdoll_system.disable()
	is_ragdolled = false
	# 重生同样不继承上一局的受力与冲量。
	if force_receiver:
		force_receiver.clear_forces()
		force_receiver.clear_pending_impulse()
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
	_logger.info("Player", "Controller of player " + get_parent().name + " has been" + ("ENABLED" if enabled else "DISABLED"))

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


## AI owns body yaw; elevation is consumed by the same spine aim as local view input.
func set_ai_aim_direction(world_direction: Vector3) -> bool:
	if not is_ai_player or not is_alive or is_ragdolled or not camera_controller:
		return false
	if not world_direction.is_finite() or world_direction.is_zero_approx():
		return false
	var direction := world_direction.normalized()
	var horizontal := Vector3(direction.x, 0.0, direction.z)
	if horizontal.length_squared() > 0.000001:
		look_at(global_position + horizontal, Vector3.UP)
	var pitch := atan2(direction.y, horizontal.length())
	camera_controller.set_ai_view_angles(rotation.y, pitch)
	return true


func set_ai_fire_input(pressed: bool) -> void:
	if not is_ai_player or not weapon_manager:
		return
	if _ai_test_fire_override != -1:
		return
	_apply_ai_fire_input(pressed)


## Debug-only trigger override used by console commands. "auto" returns
## ownership to the tactical brain; the other actions keep it overridden.
func set_ai_player_test_fire(action: String) -> bool:
	if not is_ai_player or not is_alive or not weapon_manager \
			or not weapon_manager.current_weapon:
		return false
	match action.to_lower():
		"press":
			if _ai_test_fire_override != 1:
				_apply_ai_fire_input(false)
			_ai_test_fire_override = 1
			_apply_ai_fire_input(true)
		"release":
			_ai_test_fire_override = 0
			_apply_ai_fire_input(false)
		"tap":
			_ai_test_fire_override = 0
			_apply_ai_fire_input(false)
			_apply_ai_fire_input(true)
			_finish_ai_test_fire_tap.call_deferred()
		"auto":
			_apply_ai_fire_input(false)
			_ai_test_fire_override = -1
		_:
			return false
	return true


func clear_ai_player_test_fire() -> void:
	if weapon_manager:
		weapon_manager.release_trigger()
	_ai_test_fire_override = -1


func _finish_ai_test_fire_tap() -> void:
	if _ai_test_fire_override == 0:
		_apply_ai_fire_input(false)


func _apply_ai_fire_input(pressed: bool) -> void:
	if pressed:
		weapon_manager.press_trigger()
	else:
		weapon_manager.release_trigger()


## AIPlayer 姿态输入，复用与玩家 C 键/滚轮相同的 StanceController。
func set_ai_stance(crouching: bool) -> bool:
	if not is_ai_player or not stance_controller or not is_alive:
		return false
	stance_controller.transition_to_stance(1.0 if crouching else 0.0)
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


func _get_weapon_probe_origin() -> Vector3:
	var camera := camera_controller.get_active_camera()
	return camera.global_position if is_instance_valid(camera) else global_position + Vector3.UP * 1.6


func _get_weapon_probe_muzzle() -> Dictionary:
	var weapon := weapon_manager.current_weapon
	if not is_instance_valid(weapon) or is_ragdolled:
		return {}
	var length := weapon.config.weapon_length if weapon.config else 0.7
	if weapon.attachment_manager:
		length += weapon.attachment_manager.get_total_length_modifier()
	return {"position": weapon.get_muzzle_position(), "direction": weapon.get_muzzle_direction(), "length": length}


func _is_weapon_path_clear() -> bool:
	if not is_instance_valid(weapon_presentation_controller) or not is_instance_valid(weapon_obstruction_detector):
		return true
	var threshold := weapon_presentation_controller.get_obstruction_fire_threshold()
	return maxf(weapon_obstruction_detector.get_obstruction_weight(),
		weapon_presentation_controller.get_obstruction_weight()) < threshold


func _get_weapon_presentation_state() -> Dictionary:
	var camera := camera_controller.get_active_camera()
	var view := camera.global_transform if is_instance_valid(camera) else Transform3D(
		Basis.from_euler(Vector3(camera_controller.get_vertical_angle(), camera_controller.get_view_yaw(), 0.0)), global_position)
	return {
		"active": not is_ragdolled,
		"view": view,
		"ads_blend": camera_controller.get_ads_blend(),
		"ads_breath_pose": aim_breathing_controller.get_breath_pose(),
		"local_velocity": global_basis.orthonormalized().inverse() * velocity,
		"stability": health_system.get_aim_stability_multiplier() if health_system else 1.0,
	}


func _get_aim_breathing_state() -> Dictionary:
	var aiming := weapon_manager.is_aiming and is_alive and not is_ragdolled and controllable
	var input_allowed := not is_ai_player and controllable
	input_allowed = input_allowed and not (
		(settings_menu and settings_menu.is_open()) or (pause_menu and pause_menu.is_open())
		or (weapon_mod_menu and weapon_mod_menu.is_open()) or (console_system and console_system.is_open())
		or (radial_menu_service and radial_menu_service.is_open()))
	return {
		"aiming": aiming,
		"hold_requested": input_allowed and Input.is_action_pressed("hold_breath"),
	}
