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

## 原地转身参数：角色移动受限且视角超过阈值时，控制身体朝向与动画播放。
@export_group("原地转身")
## 是否在移动受限时播放原地转身动画。
@export var turn_in_place_enabled: bool = true
## 视角与身体偏差达到此角度后触发原地转身。
@export_range(0.0, 180.0, 0.5) var turn_trigger_angle_degrees: float = 40.0
## 原地转身和自由观察期间允许视角偏离身体的最大角度。
@export_range(0.0, 180.0, 0.5) var turn_view_limit_degrees: float = 90.0
## 视角受限时保留的最低输入灵敏度比例。
@export_range(0.0, 1.0, 0.01) var turn_view_min_sensitivity_ratio: float = 0.25
## 原地转身动画片段对应的作者标注旋转角度。
@export_range(1.0, 180.0, 0.5) var turn_clip_authored_angle_degrees: float = 90.0
## 原地转身动画的最低播放速度；提高该值会缩短转身时长而不改变转角。
@export_range(0.1, 3.0, 0.01) var turn_min_playback_speed: float = 1.25
## 原地转身动画可达到的最大播放速度。
@export_range(0.1, 3.0, 0.01) var turn_max_playback_speed: float = 1.5
## 原地转身受限时的移动速度比例。
@export_range(0.0, 1.0, 0.01) var turn_constrained_speed_ratio: float = 0.25
## 原地转身受限时的加速度比例。
@export_range(0.0, 1.0, 0.01) var turn_constrained_acceleration_ratio: float = 0.25
## 原地转身动画切换和身体 yaw 过渡的混合时长（秒）。
@export_range(0.0, 1.0, 0.01) var turn_transition_time: float = 0.12

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
@export var prone_forward_speed: float = 0.8
@export var prone_backward_speed: float = 0.55
@export var prone_lateral_speed: float = 0.65
@export var prone_roll_speed: float = 3.2
@export var prone_roll_cooldown: float = 0.15
@export var prone_roll_chain_reset_time: float = 1.0
@export var prone_roll_duration: float = 0.45
@export var prone_roll_acceleration: float = 18.0
@export var prone_capsule_height: float = 0.6
@export var prone_collision_y_offset: float = -0.6
@export var prone_model_y_offset: float = -1.18

# 碰撞体 ──────────────────────────────────────────────────────
@export_group("碰撞体")
## 碰撞胶囊体高度（m）
@export var collision_shape_height: float = 1.8
## 碰撞胶囊体半径（m）
@export var collision_shape_radius: float = 0.4
## 碰撞体 Y 轴偏移（m）
@export var collision_shape_y_offset: float = 0.0
## 根据当前 BodyHitbox 骨架中心形成的 3D 核心包络自动拟合主碰撞胶囊。
@export var hitbox_driven_collision: bool = true
## 核心包络之外保留的统一安全余量（m）。
@export_range(0.0, 0.2, 0.005) var collision_bounds_margin: float = 0.025
## 主碰撞胶囊尺寸和中心追随包络的最大速度（m/s）。
@export_range(0.1, 10.0, 0.1) var collision_bounds_follow_speed: float = 2.0
## 自动尺寸的通用安全范围；不是动画专用参数。
@export_range(0.2, 2.5, 0.05) var collision_bounds_min_height: float = 0.6
@export_range(0.5, 4.0, 0.05) var collision_bounds_max_height: float = 3.0
## 自动胶囊最大半径，限制异常动画帧造成的过宽环境碰撞体。
@export_range(0.2, 1.5, 0.05) var collision_bounds_max_radius: float = 0.75
## 新主轴必须比当前轴长到该比例才允许切换，避免站立/趴下临界点抖动。
@export_range(1.0, 2.0, 0.05) var collision_axis_switch_ratio: float = 1.15
## 主轴候选需连续稳定的物理帧数；过滤模型刚加载时的单帧 T-pose。
@export_range(1, 30, 1) var collision_axis_switch_stability_frames: int = 4
## 胶囊从竖直轴转向水平轴（或反向）的最大角速度。
@export_range(30.0, 720.0, 10.0) var collision_axis_follow_speed_degrees: float = 240.0
## 模型垂直偏移（m）
@export var model_y_offset: float = -0.5
