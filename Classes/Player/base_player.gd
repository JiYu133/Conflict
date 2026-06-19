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
var weapon_manager: WeaponManager
var animation_controller: PlayerAnimationController

# 信号


signal died
signal revived
signal faction_changed(new_faction: Faction)

# 玩家阵营枚举

enum Faction { RU, UA, None } 

# 生命周期

func _ready() -> void:
	_initialize_subsystems()
	
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
	weapon_manager = _create_subsystem(WeaponManager.new(), "WeaponManager")
	animation_controller = _create_subsystem(PlayerAnimationController.new(), "AnimationController")
	
	# 初始化子系统
	
	camera_controller.initialize(
		self, 
		model_manager, 
		player_config.model_config if player_config else null, 
		player_config
		)
		
	movement_controller.initialize(
		self, 
		player_config
		)
		
	foot_ik_controller.initialize(
		model_manager, 
		player_config.model_config if player_config else null
		)
	# 连接信号
	_connect_signals()

func _create_subsystem(subsystem: Node, node_name: String) -> Node: # 创建子系统
	subsystem.name = node_name
	add_child(subsystem)
	return subsystem

func _connect_signals() -> void:
	model_manager.model_loaded.connect(_on_model_loaded)
	GlobalLogger.debug("Player", "Signals have been connected. ")
		
func _on_model_loaded(_model: Node3D) -> void:

	# 初始化布娃娃系统（需要骨骼）
	ragdoll_system.initialize(
		model_manager.skeleton,
		model_manager.animator
	)

	# 初始化动画控制器（需要 AnimationPlayer，模型加载后才可用）
	animation_controller.initialize(self, movement_controller, model_manager)

	# 将模型从 ModelManager 移到自己身下，确保变换跟随
	if _model.get_parent():
		_model.get_parent().remove_child(_model)
	add_child(_model)
	
	camera_controller._find_camera_nodes()
	camera_controller.enable_camera()
	
	var mount = model_manager.find_node_by_names(["WeaponMount"], "Node3D")
	if mount:
		weapon_manager.set_mount(mount)
		GlobalLogger.info("Player", "Weapon mount has been set: " + mount.name)
	else:
		GlobalLogger.error("Player", "Cannot find any weapon mount,the weapon will be not visible.")
		GlobalLogger.error("Player", "If there's already a weapon mount,try to check if its name is \"WeaponMount\" ")

	if player_config and player_config.starting_weapon:
		GlobalLogger.debug("Player", "Initializing player's starting weapon...")
		weapon_manager.load_and_equip(player_config.starting_weapon)

# 公共API


func die() -> void:
	if not is_alive:
		return
	
	# is_alive 的 setter 已负责设 controllable=false 并 emit died，避免重复发射
	is_alive = false
	ragdoll_system.enable()
	died.emit()
	GlobalLogger.info("Player", "Player " + get_parent().name + "has died.")

func revive() -> void:
	if is_alive:
		return
	
	# is_alive 的 setter 已负责设 controllable=true 并 emit revived，避免重复发射
	is_alive = true
	ragdoll_system.disable()
	revived.emit()
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
