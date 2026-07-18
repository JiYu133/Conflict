class_name MovementConfig
extends Resource

# ============================================================
# 玩家运动系统配置
# 功能：定义移动速度、物理手感、姿态、蹲下等全部运动参数。
# 用法：在编辑器中创建 .tres 资源，挂载到 PlayerConfig.movement_config。
# ============================================================

# 基础速度 ────────────────────────────────────────────────────
@export_group("基础速度")
## 行走速度（m/s）
@export var walk_speed: float = 1.5
## 奔跑速度（m/s）
@export var run_speed: float = 3.5
## 冲刺速度（m/s）
@export var sprint_speed: float = 6.0
## 蹲走速度（m/s）
@export var crouch_speed: float = 1.0
## 触发冲刺所需的最短按压时长（秒）
@export var sprint_hold_threshold: float = 0.25

# 物理参数 ────────────────────────────────────────────────────
@export_group("物理参数")
## 地面加速度（m/s²）
@export var ground_acceleration: float = 6.0
## 跳跃力（m/s）
@export var jump_force: float = 3.2
## 重力加速度（m/s²）
@export var gravity: float = 9.8
## 空中加速度（m/s²）
@export var air_acceleration: float = 1.0
## 空中减速度（m/s²）
@export var air_deceleration: float = 2.0
## 接地时 Y 速度钳制值
@export var floor_snap_velocity: float = -0.5
## 输入死区
@export var input_dead_zone: float = 0.1
## 后退判定 dot 阈值
@export var backward_dot_threshold: float = -0.3
## 横移判定 dot 阈值
@export var lateral_dot_threshold: float = 0.7
## 启用转向减速的最低水平速度（m/s）
@export var turn_decel_min_speed: float = 0.1
## 空中加速/减速切换的目标速度阈值（m/s）
@export var air_input_threshold: float = 0.1
## 横向速度上限比例
@export var lateral_speed_ratio: float = 0.8
## 后退速度上限比例
@export var backward_speed_ratio: float = 0.7
## 制动强度（m/s²）
@export var stop_brake_strength: float = 5.0
## 转向减速强度（0=不减速，1=完全余弦削减）
@export var turn_decel_factor: float = 0.85

# 运动手感 ────────────────────────────────────────────────────
@export_group("运动手感")
## 起步峰值速度倍率
@export var burst_strength: float = 1.2
## 爆发持续时间（秒）
@export var burst_duration: float = 0.12
## 走路步频（Hz）
@export var gait_frequency_walk: float = 1.8
## 跑步步频（Hz）
@export var gait_frequency_run: float = 2.5
## 冲刺步频（Hz）
@export var gait_frequency_sprint: float = 3.2
## 走路速度波动振幅（m/s）
@export var gait_amplitude_walk: float = 0.06
## 跑步速度波动振幅（m/s）
@export var gait_amplitude_run: float = 0.12
## 冲刺速度波动振幅（m/s）
@export var gait_amplitude_sprint: float = 0.18

# 姿态与蹲下 ──────────────────────────────────────────────────
@export_group("姿态与蹲下")
## 姿态过渡速度（单位/秒）
@export var stance_transition_speed: float = 3.0
## 姿态调整步进值（每次滚轮的增量，0.0~1.0）
@export var stance_step_size: float = 0.1
## 蹲下碰撞胶囊体高度（m）
@export var crouch_capsule_height: float = 0.6
## 蹲下时模型 Y 轴偏移
@export var crouch_y_offset: float = -0.85
## Walk → CrouchWalk 动画过渡时间（秒），建议与 1/stance_transition_speed 一致
@export var crouch_walk_xfade_time: float = 0.3

# 碰撞体 ──────────────────────────────────────────────────────
@export_group("碰撞体")
## 碰撞胶囊体高度（m）
@export var collision_shape_height: float = 1.8
## 碰撞胶囊体半径（m）
@export var collision_shape_radius: float = 0.4
## 碰撞体 Y 轴偏移（m）
@export var collision_shape_y_offset: float = 0.0
## 模型垂直偏移（m）
@export var model_y_offset: float = -0.5
