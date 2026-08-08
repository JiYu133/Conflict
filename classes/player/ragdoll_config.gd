class_name RagdollConfig
extends Resource

# ============================================================
# 布娃娃物理配置
# 功能：定义预制布娃娃的运行时参数，包括死亡动画过渡、
#       冲击力大小、碰撞层和自碰撞策略。
# 用法：在 Godot 编辑器中创建 .tres 资源，填入具体数值，
#       然后挂载到 PlayerConfig.ragdoll_config。
# ============================================================

@export_group("物理骨骼参数")
## 启用非相邻身体部位之间的碰撞，防止手臂穿过并卡入躯干
@export var enable_self_collision: bool = true

# 过渡参数 ─────────────────────────────────────────────────
@export_group("过渡参数")
## 是否在布娃娃启动前播放死亡动画；关闭则死亡后立即进入物理模拟 / Play death animation before ragdoll physics; when false, ragdoll activates instantly on death
@export var play_death_animation: bool = false
## 死亡动画播放后到启动布娃娃物理的等待时间（秒）；仅在 play_death_animation 为 true 时生效 / Seconds to wait after death anim starts before enabling ragdoll physics
@export var death_anim_to_ragdoll_time: float = 0.5

# 冲击力参数 ─────────────────────────────────────────────────
@export_group("冲击力参数")
## 默认死亡冲击力（牛顿）/ Default death impact force in Newtons
@export var default_impact_force: float = 80.0
## 冲击力持续的物理帧数；枪击测试通常为 1，最多建议 2
@export_range(1, 2, 1) var impact_force_frames: int = 1
## 爆头额外冲击力倍率 / Headshot force multiplier applied on top of default
@export var headshot_force_multiplier: float = 2.5
## 爆炸冲击力（牛顿）/ Explosion force in Newtons
@export var explosion_force: float = 300.0

# 碰撞层 ─────────────────────────────────────────────────
@export_group("碰撞层")
## 布娃娃骨骼碰撞层 / Physics layer for ragdoll bones
@export_flags_3d_physics var ragdoll_collision_layer: int = 2
## 布娃娃碰撞掩码 / Ragdoll collision mask — 必须与地图 StaticBody3D 的 layer 互相匹配
## （骨骼在 layer 2，地图 layer 1，骨骼 mask 包含 1，骨骼间不互相碰撞）
## 默认碰撞所有常用层；相邻骨骼通过 collision exception 避免互相弹飞。
@export_flags_3d_physics var ragdoll_collision_mask: int = 0x7FFFFFFF

# 冲击力目标 ─────────────────────────────────────────────────
@export_group("冲击力目标")
## 上半身骨骼名关键词，冲击力施加到匹配任一关键词的骨骼 / Upper body bone name keywords for force application
@export var upper_body_keywords: Array[String] = [
	"Spine", "Neck", "Head", "Shoulder", "Arm"
]
