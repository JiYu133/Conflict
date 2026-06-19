class_name PlayerConfig
extends Resource

# ============================================================
# 玩家配置资源
# 功能：定义玩家的全部初始参数，包括移动物理、碰撞体尺寸、
#       摄像机设置和初始武器。
# 用法：在 Godot 编辑器中创建 .tres 资源，填入具体数值，
#       然后传入 BasePlayer 完成初始化。
# ============================================================

# 移动参数 ─────────────────────────────────────────────────
@export_group("移动参数")
@export var walk_speed: float = 2.0
## 行走速度，单位：m/s
@export var run_speed: float = 4.0
## 奔跑速度，单位：m/s（需按住 sprint + 前进）
@export var jump_force: float = 3.7
## 跳跃力，单位：m/s。垂直方向初速度
@export var gravity: float = 9.8
## 重力加速度，单位：m/s²。标准地球重力约 9.8
@export var acceleration: float = 9.5
## 地面加速度，单位：m/s²。值越大起步越快
@export var deceleration: float = 20.0
## 地面减速度，单位：m/s²。值越大松手后急停越快
@export var air_acceleration: float = 1.0
## 空中加速度，单位：m/s²。通常远低于地面值，还原空气阻力小、难以变向的手感
@export var air_deceleration: float = 2.0
## 空中减速度，单位：m/s²。空中松手后的惯性衰减

# 模型配置 ─────────────────────────────────────────────────
@export_group("模型")
@export var model_scene: PackedScene
## 玩家 3D 模型场景（.tscn / .glb），需要包含 Skeleton3D 和 AnimationPlayer
@export var model_config: ModelLookupConfig
## 节点查找规则（告诉 ModelManager 去哪里找骨骼、摄像机挂载点等）
@export var collision_shape_height: float = 1.8
## 碰撞胶囊体高度，单位：m。约等于角色身高
@export var collision_shape_radius: float = 0.4
## 碰撞胶囊体半径，单位：m。约等于角色身体厚度

# 摄像机配置 ───────────────────────────────────────────────
@export_group("摄像机")
@export var fov: float = 90.0
## 第一人称视野角度，单位：度（FOV，Field of View）
@export var mouse_sensitivity: float = 0.003
## 鼠标灵敏度，单位：弧度/像素。约 0.003 ≈ 中低灵敏度
@export var max_vertical_angle: float = 1.4
## 垂直视角最大角度，单位：弧度。1.4 ≈ 80 度

# 武器配置 ─────────────────────────────────────────────────
@export_group("武器配置")
@export var starting_weapon: WeaponConfig
## 玩家出生时持有的初始武器配置
