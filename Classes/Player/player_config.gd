class_name PlayerConfig
extends Resource

# ============================================================
# 玩家配置资源
# 功能：定义玩家的全部初始参数，包括移动物理、碰撞体尺寸、
#       摄像机配置引用和初始武器。
# 用法：在 Godot 编辑器中创建 .tres 资源，填入具体数值，
#       然后传入 BasePlayer 完成初始化。
# ============================================================

# 移动参数 ─────────────────────────────────────────────────
@export_group("移动参数")
## 行走速度（m/s），负重 40kg 士兵战术行走约 1.2–1.5 m/s / Walk speed in m/s
@export var walk_speed: float = 1.5
## 奔跑速度（m/s），负重士兵持续跑步约 3.5–4.0 m/s / Run speed in m/s
@export var run_speed: float = 3.5
## 全力冲刺速度（m/s），长按 Shift 激活 / Sprint speed in m/s
@export var sprint_speed: float = 6.0
## 触发冲刺所需的最短按压时长（秒），低于此值视为单击切换奔跑 / Hold duration to activate sprint vs. tap-to-toggle-run
@export var sprint_hold_threshold: float = 0.25
## 地面加速度（m/s²），约 6 m/s² 使起步有明显惯性 / Ground acceleration in m/s²
@export var ground_acceleration: float = 6.0
## 跳跃力（m/s）/ Jump impulse in m/s
@export var jump_force: float = 3.2
## 重力加速度（m/s²）/ Gravity in m/s²
@export var gravity: float = 9.8
## 空中加速度（m/s²）/ Air acceleration in m/s²
@export var air_acceleration: float = 1.0
## 空中减速度（m/s²）/ Air deceleration in m/s²
@export var air_deceleration: float = 2.0
## 输入死区（方向长度低于此值视为无输入）/ Input dead zone threshold for analog/keyboard direction
@export var input_dead_zone: float = 0.1
## 接地时 Y 速度钳制值（防止向下加速累积）/ Y velocity clamp when grounded to prevent downward accumulation
@export var floor_snap_velocity: float = -0.5
## 后退判定 dot 阈值（dot < 此值视为向后移动）/ Dot product threshold below which movement is treated as backward
@export var backward_dot_threshold: float = -0.3
## 横移判定 dot 阈值（dot > 此值视为横向移动）/ Dot product threshold above which movement is treated as lateral
@export var lateral_dot_threshold: float = 0.7
## 启用转向减速的最低水平速度（m/s）/ Min horizontal speed to activate turn deceleration
@export var turn_decel_min_speed: float = 0.1
## 空中加速/减速切换的目标速度阈值（m/s）/ Air input speed threshold for switching between accel and decel
@export var air_input_threshold: float = 0.1

# 运动手感 ─────────────────────────────────────────────────
@export_group("运动手感")

# 起步爆发：从静止蹬地时的短暂速度峰值，游戏手感夸张而非物理精确
## 起步峰值速度倍率，1.2 = 起步时速度短暂超出基础值 20% / Burst speed multiplier on movement start
@export var burst_strength: float = 1.2
## 爆发持续时间（秒）/ Burst duration in seconds
@export var burst_duration: float = 0.12

# 步态波动：行走/奔跑时速度随脚步的周期性起伏，模拟重心摆动
# 参考人体步频数据：走路约 1.8 Hz（108 步/分），奔跑约 2.5 Hz（150 步/分）
## 走路步频（Hz）/ Walk gait frequency in Hz
@export var gait_frequency_walk: float = 1.8
## 跑步步频（Hz）/ Run gait frequency in Hz
@export var gait_frequency_run: float = 2.5
## 冲刺步频（Hz）/ Sprint gait frequency in Hz
@export var gait_frequency_sprint: float = 3.2
## 走路速度波动振幅（m/s）/ Walk gait speed ripple amplitude in m/s
@export var gait_amplitude_walk: float = 0.06
## 跑步速度波动振幅（m/s）/ Run gait speed ripple amplitude in m/s
@export var gait_amplitude_run: float = 0.12
## 冲刺速度波动振幅（m/s）/ Sprint gait speed ripple amplitude in m/s
@export var gait_amplitude_sprint: float = 0.18

# 转向减速：基于 dot product 的物理公式，90° 急转约损失 35–50% 速度
## 转向减速强度，0.0 = 不减速，1.0 = 完全余弦削减 / Turn deceleration factor; 0 = none, 1 = full cosine reduction
@export var turn_decel_factor: float = 0.85

# 停止卸力：负重士兵从步行速度停止约需 0.3–0.6m，对应制动强度约 4–6 m/s²
## 制动强度（m/s²），无输入时快速减速 / Braking strength in m/s² when no input
@export var stop_brake_strength: float = 5.0

# 方向速度上限：参考 Arma 3 实现，有士兵负重运动研究支撑
## 横向（纯侧移）速度上限，相对前进速度的比例 / Lateral speed cap as a ratio of forward speed
@export var lateral_speed_ratio: float = 0.8
## 后退速度上限，相对前进速度的比例 / Backward speed cap as a ratio of forward speed
@export var backward_speed_ratio: float = 0.7

# 模型配置 ─────────────────────────────────────────────────
@export_group("模型")
## 玩家 3D 模型场景，需要包含 Skeleton3D 和 AnimationPlayer / Player 3D model scene
@export var model_scene: PackedScene
## 节点查找规则，告诉 ModelManager 去哪里找骨骼、摄像机挂载点等 / Node lookup rules for ModelManager
@export var model_config: ModelLookupConfig
## 摄像机与视角效果配置（FOV、晃动、落地冲击等）/ Camera and procedural effect config
@export var camera_config: CameraConfig
## 碰撞胶囊体高度（m），约等于角色身高 / Collision capsule height in meters
@export var collision_shape_height: float = 1.8
## 碰撞胶囊体半径（m），约等于角色身体厚度 / Collision capsule radius in meters
@export var collision_shape_radius: float = 0.4
## 模型垂直偏移（m），正值上移，负值下移。用于使模型脚部对齐胶囊体底部 / Model vertical offset to align feet with collision capsule bottom
@export var model_y_offset: float = -0.5

@export_group("布娃娃配置")
## 布娃娃物理配置（留空则使用代码内默认值）/ Ragdoll physics configuration (uses code defaults if empty)
@export var ragdoll_config: RagdollConfig

# 手部 IK 配置 ──────────────────────────────────────────────
@export_group("手部 IK 配置")
## 左手 IK 参数（骨骼链、FABRIK、肘部方向等，留空则使用默认值）
@export var hand_ik_config: HandIKConfig

# 武器配置 ─────────────────────────────────────────────────
@export_group("武器配置")
## 初始武器 / Starting weapon config
@export var starting_weapon: WeaponConfig

# 动画配置 ─────────────────────────────────────────────────
@export_group("动画配置")
## 进入行走状态的水平速度平方阈值（m²/s²），默认 0.25 = 0.5 m/s / Walk enter threshold (squared speed)
@export var walk_enter_speed_sq: float = 0.25
## 退出行走状态的水平速度平方阈值（m²/s²），默认 0.0225 = 0.15 m/s / Walk exit threshold (squared speed)
@export var walk_exit_speed_sq: float = 0.0225
## 落地恢复时间（秒），落地动画播放完毕后自动切回地面状态的等待时间 / Landing recovery time in seconds
@export var land_recovery_time: float = 0.3
