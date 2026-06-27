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
@export var walk_speed: float = 1.5
## 行走速度，单位：m/s（参考：负重 40kg 士兵战术行走约 1.2–1.5 m/s）
@export var run_speed: float = 3.5
## 奔跑速度，单位：m/s（参考：负重士兵持续跑步约 3.5–4.0 m/s）
@export var ground_acceleration: float = 6.0
## 地面加速度，单位：m/s²。负重下约 6 m/s²，使起步有明显惯性（~0.6s 到达步行速度）
@export var jump_force: float = 3.2
## 跳跃力，单位：m/s。负重时跳跃力略低于空手
@export var gravity: float = 9.8
## 重力加速度，单位：m/s²
@export var air_acceleration: float = 1.0
## 空中加速度，单位：m/s²
@export var air_deceleration: float = 2.0
## 空中减速度，单位：m/s²

# 运动手感 ─────────────────────────────────────────────────
@export_group("运动手感")

# 起步爆发：从静止蹬地时的短暂速度峰值，游戏手感夸张而非物理精确
@export var burst_strength: float = 1.2
## 起步峰值速度倍率。负重下爆发感较弱，1.2 足够
@export var burst_duration: float = 0.12
## 爆发持续时间（秒）

# 步态波动：行走/奔跑时速度随脚步的周期性起伏，模拟重心摆动
# 参考人体步频数据：走路约 1.8 Hz（108 步/分），奔跑约 2.5 Hz（150 步/分）
@export var gait_frequency_walk: float = 1.8
## 走路步频（Hz）
@export var gait_frequency_run: float = 2.5
## 跑步步频（Hz）
@export var gait_amplitude_walk: float = 0.06
## 走路速度波动振幅（m/s）。负重下重心摆动较小
@export var gait_amplitude_run: float = 0.12
## 跑步速度波动振幅（m/s）

# 转向减速：基于 dot product 的物理公式，90° 急转约损失 35–50% 速度
@export var turn_decel_factor: float = 0.85
## 转向减速强度。0.0 = 不减速，1.0 = 完全余弦削减；0.85 接近真实士兵负重数据

# 停止卸力：负重士兵从步行速度停止约需 0.3–0.6m，对应制动强度约 4–6 m/s²
@export var stop_brake_strength: float = 5.0
## 制动强度（m/s²）。负重下制动能力显著下降，避免瞬间急停

# 方向速度上限：参考 Arma 3 实现，有士兵负重运动研究支撑
@export var lateral_speed_ratio: float = 0.8
## 横向（纯侧移）速度上限，相对于前进速度的比例
@export var backward_speed_ratio: float = 0.7
## 后退速度上限，相对于前进速度的比例

# 模型配置 ─────────────────────────────────────────────────
@export_group("模型")
@export var model_scene: PackedScene
## 玩家 3D 模型场景（.tscn / .glb），需要包含 Skeleton3D 和 AnimationPlayer
@export var model_config: ModelLookupConfig
## 节点查找规则（告诉 ModelManager 去哪里找骨骼、摄像机挂载点等）
@export var camera_config: CameraConfig
## 摄像机与视角效果配置（FOV、晃动、落地冲击等）
@export var collision_shape_height: float = 1.8
## 碰撞胶囊体高度，单位：m。约等于角色身高
@export var collision_shape_radius: float = 0.4
## 碰撞胶囊体半径，单位：m。约等于角色身体厚度

# 武器配置 ─────────────────────────────────────────────────
@export_group("武器配置")
@export var starting_weapon: WeaponConfig
## 初始武器
