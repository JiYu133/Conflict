class_name PlayerConfig
extends Resource

# ============================================================
# 玩家配置资源
# 功能：汇总所有子系统配置引用，各子系统参数见对应 Config 资源。
# ============================================================

# 运动配置 ─────────────────────────────────────────────────
@export_group("运动配置")
## 运动系统参数（速度、物理、姿态、蹲下等）
@export var movement_config: MovementConfig

# 模型配置 ─────────────────────────────────────────────────
@export_group("模型")
## 玩家 3D 模型场景
@export var model_scene: PackedScene
## 节点查找规则
@export var model_config: ModelLookupConfig
## 摄像机与视角效果配置
@export var camera_config: CameraConfig

# 动画配置 ─────────────────────────────────────────────────
@export_group("动画配置")
## 进入行走状态的水平速度平方阈值（m²/s²）
@export var walk_enter_speed_sq: float = 0.25
## 退出行走状态的水平速度平方阈值（m²/s²）
@export var walk_exit_speed_sq: float = 0.0225
## 落地恢复时间（秒）
@export var land_recovery_time: float = 0.3

# 摄像机眼部高度 ────────────────────────────────────────────
@export_group("摄像机眼部高度")
## 站立时摄像机眼部高度（玩家局部 Y）
@export var camera_stand_eye_height: float = 1.6
## 蹲下时摄像机眼部高度（玩家局部 Y）
@export var camera_crouch_eye_height: float = 1.0

# 布娃娃配置 ────────────────────────────────────────────────
@export_group("布娃娃配置")
## 布娃娃物理配置
@export var ragdoll_config: RagdollConfig

# 手部 IK 配置 ──────────────────────────────────────────────
@export_group("手部 IK 配置")
## 左手 IK 参数
@export var hand_ik_config: HandIKConfig

# 武器配置 ─────────────────────────────────────────────────
@export_group("武器配置")
## 初始武器
@export var starting_weapon: WeaponConfig

# 医疗配置 ─────────────────────────────────────────────────
@export_group("医疗配置")
## 医疗系统配置
@export var health_config: HealthConfig

# 体力配置 ─────────────────────────────────────────────────
@export_group("体力配置")
## 体力系统配置（不挂载时使用默认值）
@export var stamina_config: StaminaConfig

# 转身动画 ──────────────────────────────────────────────────
@export_group("转身动画")
## 是否启用转身动画
@export var turn_in_place_enabled: bool = false
## 触发转身动画的朝向差阈值（度）
@export var turn_angle_threshold: float = 60.0
## 低于此速度（m/s）时才能触发转身动画
@export var turn_walk_speed_threshold: float = 1.2

# ── 向后兼容：直接委托给 movement_config ──────────────────────
# 以下属性供现有代码在 movement_config 迁移完成前继续使用。
# 迁移完成后可以删除。

var walk_speed: float:
	get: return movement_config.walk_speed if movement_config else 1.5
var run_speed: float:
	get: return movement_config.run_speed if movement_config else 3.5
var sprint_speed: float:
	get: return movement_config.sprint_speed if movement_config else 6.0
var crouch_speed: float:
	get: return movement_config.crouch_speed if movement_config else 1.0
var sprint_hold_threshold: float:
	get: return movement_config.sprint_hold_threshold if movement_config else 0.25
var ground_acceleration: float:
	get: return movement_config.ground_acceleration if movement_config else 6.0
var jump_force: float:
	get: return movement_config.jump_force if movement_config else 3.2
var gravity: float:
	get: return movement_config.gravity if movement_config else 9.8
var air_acceleration: float:
	get: return movement_config.air_acceleration if movement_config else 1.0
var air_deceleration: float:
	get: return movement_config.air_deceleration if movement_config else 2.0
var floor_snap_velocity: float:
	get: return movement_config.floor_snap_velocity if movement_config else -0.5
var input_dead_zone: float:
	get: return movement_config.input_dead_zone if movement_config else 0.1
var backward_dot_threshold: float:
	get: return movement_config.backward_dot_threshold if movement_config else -0.3
var lateral_dot_threshold: float:
	get: return movement_config.lateral_dot_threshold if movement_config else 0.7
var turn_decel_min_speed: float:
	get: return movement_config.turn_decel_min_speed if movement_config else 0.1
var air_input_threshold: float:
	get: return movement_config.air_input_threshold if movement_config else 0.1
var lateral_speed_ratio: float:
	get: return movement_config.lateral_speed_ratio if movement_config else 0.8
var backward_speed_ratio: float:
	get: return movement_config.backward_speed_ratio if movement_config else 0.7
var stop_brake_strength: float:
	get: return movement_config.stop_brake_strength if movement_config else 5.0
var turn_decel_factor: float:
	get: return movement_config.turn_decel_factor if movement_config else 0.85
var burst_strength: float:
	get: return movement_config.burst_strength if movement_config else 1.2
var burst_duration: float:
	get: return movement_config.burst_duration if movement_config else 0.12
var gait_frequency_walk: float:
	get: return movement_config.gait_frequency_walk if movement_config else 1.8
var gait_frequency_run: float:
	get: return movement_config.gait_frequency_run if movement_config else 2.5
var gait_frequency_sprint: float:
	get: return movement_config.gait_frequency_sprint if movement_config else 3.2
var gait_amplitude_walk: float:
	get: return movement_config.gait_amplitude_walk if movement_config else 0.06
var gait_amplitude_run: float:
	get: return movement_config.gait_amplitude_run if movement_config else 0.12
var gait_amplitude_sprint: float:
	get: return movement_config.gait_amplitude_sprint if movement_config else 0.18
var stance_transition_speed: float:
	get: return movement_config.stance_transition_speed if movement_config else 3.0
var stance_step_size: float:
	get: return movement_config.stance_step_size if movement_config else 0.1
var crouch_capsule_height: float:
	get: return movement_config.crouch_capsule_height if movement_config else 0.6
var crouch_y_offset: float:
	get: return movement_config.crouch_y_offset if movement_config else -0.85
var collision_shape_height: float:
	get: return movement_config.collision_shape_height if movement_config else 1.8
var collision_shape_radius: float:
	get: return movement_config.collision_shape_radius if movement_config else 0.4
var collision_shape_y_offset: float:
	get: return movement_config.collision_shape_y_offset if movement_config else 0.0
var model_y_offset: float:
	get: return movement_config.model_y_offset if movement_config else -0.5
