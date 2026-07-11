class_name RagdollConfig
extends Resource

# ============================================================
# 布娃娃物理配置
# 功能：定义布娃娃系统的全部物理参数，包括骨骼碰撞体尺寸、
#       关节刚度/阻尼、死亡动画过渡时间、冲击力大小及碰撞层。
# 用法：在 Godot 编辑器中创建 .tres 资源，填入具体数值，
#       然后挂载到 PlayerConfig.ragdoll_config。
# ============================================================

# 物理骨骼参数 ─────────────────────────────────────────────────
@export_group("物理骨骼参数", "物理骨骼")
## 碰撞形状半径缩放系数，相对于父骨骼长度 / Collision shape radius scale factor relative to bone length
@export var bone_radius_scale: float = 0.3
## 关节刚度，值越大骨骼越僵硬（100 = 接近刚性）/ Joint stiffness; higher = stiffer
@export var joint_stiffness: float = 10.0
## 关节阻尼，抑制骨骼摆动 / Joint damping to reduce bone oscillation
@export var joint_damping: float = 5.0
## 线速度阻尼，控制整体移动减速 / Linear damping applied to each physical bone
@export var linear_damping: float = 2.0
## 角速度阻尼，控制旋转减速 / Angular damping applied to each physical bone
@export var angular_damping: float = 5.0
## 每块物理骨骼的质量（kg）/ Mass per physical bone in kg
@export var mass: float = 1.0

# 过渡参数 ─────────────────────────────────────────────────
@export_group("过渡参数")
## 死亡动画播放后到启动布娃娃物理的等待时间（秒） / Seconds to wait after death anim starts before enabling ragdoll physics
@export var death_anim_to_ragdoll_time: float = 0.5

# 冲击力参数 ─────────────────────────────────────────────────
@export_group("冲击力参数")
## 默认死亡冲击力（牛顿）/ Default death impact force in Newtons
@export var default_impact_force: float = 500.0
## 爆头额外冲击力倍率 / Headshot force multiplier applied on top of default
@export var headshot_force_multiplier: float = 2.5
## 爆炸冲击力（牛顿）/ Explosion force in Newtons
@export var explosion_force: float = 2000.0
## 冲击力施加上半身半径（m），仅影响此半径内的上半身骨骼 / Upper body radius for force application in meters
@export var impact_upper_body_radius: float = 0.8

# 碰撞层 ─────────────────────────────────────────────────
@export_group("碰撞层")
## 布娃娃骨骼碰撞层 / Physics layer for ragdoll bones
@export_flags_3d_physics var ragdoll_collision_layer: int = 1
## 布娃娃碰撞掩码 / Ragdoll collision mask — 必须与地图 StaticBody3D 的 layer 互相匹配
## （骨骼在 layer 1，地图 layer 1，确保 mask 包含 1 + 地图 mask 包含 1）
@export_flags_3d_physics var ragdoll_collision_mask: int = 1

# 骨骼过滤 ─────────────────────────────────────────────────
@export_group("骨骼过滤")
## 排除骨骼名关键词，匹配任一关键词的骨骼不会被创建物理骨骼 / Bone name keywords excluded from physical bone creation
@export var exclude_bone_keywords: Array[String] = [
	"IK", "_End", "Toe_End", "Hand_End",
	"Thumb", "Index", "Middle", "Ring", "Pinky",
	"Weapon", "Armature", "Root"
]

# 冲击力目标 ─────────────────────────────────────────────────
@export_group("冲击力目标")
## 上半身骨骼名关键词，冲击力施加到匹配任一关键词的骨骼 / Upper body bone name keywords for force application
@export var upper_body_keywords: Array[String] = [
	"Spine", "Neck", "Head", "Shoulder", "Arm"
]
