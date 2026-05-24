class_name BasePlayer
extends CharacterBody3D

# 在定义玩家对象时绑定给玩家的脚本 同时也要绑定玩家配置文件

# ============================================
# 导出变量（Mod制作者可配置）
# ============================================

@export_group("Configuration")
@export var player_config: PlayerConfig

@export_group("State")
@export var is_alive: bool = true: # 玩家存活状态设置 
	set(value):
		is_alive = value
@export var controllable: bool = true
@export var faction: Faction = Faction.None # 玩家阵营



# ============================================
# 子系统引用
# ============================================

var model_manager: PlayerModelManager
var camera_controller: PlayerCameraController
var ragdoll_system: PlayerRagdollSystem
var movement_controller: PlayerMovementController
var foot_ik_controller: FootIKController

# ============================================
# 信号
# ============================================

signal died
signal revived
signal faction_changed(new_faction: Faction)

# ============================================
# 玩家阵营枚举
# ============================================

enum Faction { RU, UA, PMC, None } 

# ============================================
# 生命周期
# ============================================

func _ready() -> void:
	_initialize_subsystems()
	
	# 加载配置中的模型
	if player_config and player_config.model_scene:
		model_manager.load_model(
			player_config.model_scene,
			player_config.model_config
		)

# 在这里处理玩家的移动
func _physics_process(delta: float) -> void:
	if not is_alive or not controllable:
		return
	
	# TODO: 获取玩家输入并处理
	
	# 处理移动
	
	# TODO: 处理脚部IK
	# foot_ik_controller.process_ik(delta)

# ============================================
# 子系统初始化
# ============================================

func _initialize_subsystems() -> void:
	# 创建子系统
	model_manager = _create_subsystem(PlayerModelManager.new(), "ModelManager")
	camera_controller = _create_subsystem(PlayerCameraController.new(), "CameraController")
	ragdoll_system = _create_subsystem(PlayerRagdollSystem.new(), "RagdollSystem")
	movement_controller = _create_subsystem(PlayerMovementController.new(), "MovementController")
	foot_ik_controller = _create_subsystem(FootIKController.new(), "FootIKController")
	
	# 初始化子系统
	camera_controller.initialize(model_manager, player_config.model_config if player_config else null)
	movement_controller.initialize(self, player_config)
	foot_ik_controller.initialize(model_manager, player_config.model_config if player_config else null)
	
	# 连接信号
	_connect_signals()

func _create_subsystem(subsystem: Node, node_name: String) -> Node: # 创建子系统
	subsystem.name = node_name
	add_child(subsystem)
	return subsystem

func _connect_signals() -> void:
	# 模型加载完成后初始化依赖骨骼的子系统
	model_manager.model_loaded.connect(_on_model_loaded)

func _on_model_loaded(_model: Node3D) -> void:
	# 初始化布娃娃系统（需要骨骼）
	ragdoll_system.initialize(
		model_manager.skeleton,
		model_manager.animator
	)
	
	# 启用第一人称摄像机
	camera_controller.enable_camera()

# ============================================
# 公共API
# ============================================

func die() -> void:
	if not is_alive:
		return
	
	is_alive = false
	controllable = false
	ragdoll_system.enable()
	died.emit()
	print("玩家死亡")

func revive() -> void:
	if is_alive:
		return
	
	is_alive = true
	controllable = true
	ragdoll_system.disable()
	revived.emit()
	print("玩家复活")

func set_controllable(enabled: bool) -> void:
	controllable = enabled
	print("玩家控制: ", "启用" if enabled else "禁用")

# ============================================
# Mod热重载
# ============================================

func reload_model() -> void:
	if player_config and player_config.model_scene:
		model_manager.load_model(
			player_config.model_scene,
			player_config.model_config
		)

func change_model(new_scene: PackedScene) -> void:
	if player_config:
		player_config.model_scene = new_scene
	model_manager.load_model(new_scene, player_config.model_config if player_config else null)
