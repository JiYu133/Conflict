class_name BasePlayer
extends CharacterBody3D

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




# 子系统引用

var model_manager: PlayerModelManager
var camera_controller: PlayerCameraController
var ragdoll_system: PlayerRagdollSystem
var movement_controller: PlayerMovementController
var foot_ik_controller: FootIKController
var hand_ik_controller: HandIKController
var weapon_manager: WeaponManager
var animation_controller: PlayerAnimationController
var free_camera_controller: FreeCameraController

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
	model_manager = _create_subsystem(PlayerModelManager.new(), "ModelManager")
	camera_controller = _create_subsystem(PlayerCameraController.new(),"CameraController")
	ragdoll_system = _create_subsystem(PlayerRagdollSystem.new(), "RagdollSystem")
	movement_controller = _create_subsystem(PlayerMovementController.new(), "MovementController")
	foot_ik_controller = _create_subsystem(FootIKController.new(), "FootIKController")
	hand_ik_controller = _create_subsystem(HandIKController.new(), "HandIKController")
	weapon_manager = _create_subsystem(WeaponManager.new(), "WeaponManager")
	animation_controller = _create_subsystem(PlayerAnimationController.new(), "AnimationController")
	
	# 初始化子系统
	
	camera_controller.initialize(
		self,
		model_manager,
		player_config.model_config if player_config else null,
		player_config.camera_config if player_config else null
		)
		
	movement_controller.initialize(
		self, 
		player_config
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
	# 武器切换时将新武器的 RecoilComponent 注入摄像机控制器
	weapon_manager.weapon_changed.connect(_on_weapon_changed)
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
	hand_ik_controller.process_ik(delta)


func _input(event: InputEvent) -> void:
	# ESC 切换鼠标捕捉
	if event.is_action_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	if not OS.is_debug_build():
		return

	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_F:
				if free_camera_controller:
					free_camera_controller.toggle()
			KEY_T: die(PlayerRagdollSystem.DeathType.FRONT)
			KEY_Y: die(PlayerRagdollSystem.DeathType.FRONT_HEADSHOT)
			KEY_U: die(PlayerRagdollSystem.DeathType.EXPLOSION)


func die(death_type: PlayerRagdollSystem.DeathType = PlayerRagdollSystem.DeathType.GENERIC, impact_direction: Vector3 = Vector3.ZERO) -> void:
	if not is_alive:
		return

	is_alive = false
	velocity = Vector3.ZERO
	hand_ik_controller.set_suspended(true)

	# 禁用玩家碰撞体，防止物理骨骼与自身胶囊体碰撞导致弹飞
	_set_collision_enabled(false)

	ragdoll_system.enable(death_type, impact_direction)
	camera_controller.disable_camera(model_manager.skeleton)
	GlobalLogger.info("Player", "Player " + get_parent().name + "has died. (type: %d)" % death_type)

func revive() -> void:
	if is_alive:
		return
	
	is_alive = true
	ragdoll_system.disable()
	camera_controller.enable_camera()
	hand_ik_controller.set_suspended(false)

	# 恢复玩家碰撞体
	_set_collision_enabled(true)

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
