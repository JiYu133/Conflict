class_name RagdollConfig
extends Resource

# ============================================================
# 布娃娃物理配置
# 功能：定义预制布娃娃的运行时参数，包括死亡动画过渡、
#       动能传递、碰撞层和自碰撞策略。
# 用法：在 Godot 编辑器中创建 .tres 资源，填入具体数值，
#       然后挂载到 PlayerConfig.ragdoll_config。
# ============================================================

@export_group("物理骨骼参数")
## 每块预制物理骨骼的基础质量（kg）。当前模型约 11 块骨骼，4 kg 约等于 44 kg 的布娃娃总质量。
@export_range(0.1, 20.0, 0.1) var mass: float = 4.0
## 骨骼线速度阻尼；越高越不容易被冲击持续推走。
@export_range(0.0, 20.0, 0.1) var linear_damping: float = 2.0
## 骨骼角速度阻尼；越高越不容易被踢得翻滚。
@export_range(0.0, 20.0, 0.1) var angular_damping: float = 5.0
## 启用非相邻身体部位之间的碰撞，防止手臂穿过并卡入躯干
@export var enable_self_collision: bool = true

# 过渡参数 ─────────────────────────────────────────────────
@export_group("过渡参数")
## 是否在布娃娃启动前播放死亡动画；关闭则死亡后立即进入物理模拟 / Play death animation before ragdoll physics; when false, ragdoll activates instantly on death
@export var play_death_animation: bool = false
## 死亡动画播放后到启动布娃娃物理的等待时间（秒）；仅在 play_death_animation 为 true 时生效 / Seconds to wait after death anim starts before enabling ragdoll physics
@export var death_anim_to_ragdoll_time: float = 0.5

# 动能传递参数 ─────────────────────────────────────────────────
@export_group("动能传递参数")
## 命中动能中转化为布娃娃冲量的比例；子弹的动量由 sqrt(2*m*E) 计算。
@export_range(0.0, 1.0, 0.01) var impact_energy_transfer: float = 0.35
## 爆头通常有更集中的局部响应，因此使用更高的能量传递比例。
@export_range(0.0, 1.0, 0.01) var headshot_energy_transfer: float = 0.50
## 非弹道伤害没有弹头质量时使用的等效质量（kg），仅用于爆炸/近战等通用伤害。
@export_range(0.01, 20.0, 0.01) var fallback_impact_mass_kg: float = 1.0
## 爆炸伤害的能量传递比例；爆炸的 amount 仍由伤害来源提供，不在布娃娃中硬编码力。
@export_range(0.0, 1.0, 0.01) var explosion_energy_transfer: float = 0.20
## 爆头额外集中到头部的冲量比例（相对于本次总冲量）。
@export_range(0.0, 1.0, 0.01) var headshot_extra_impulse_ratio: float = 0.25

# 碰撞层 ─────────────────────────────────────────────────
@export_group("碰撞层")
## 布娃娃骨骼碰撞层 / Physics layer for ragdoll bones
@export_flags_3d_physics var ragdoll_collision_layer: int = PhysicsLayers.CHARACTER
## 布娃娃默认与环境、其他角色及掉落武器碰撞，但不接触弹壳或未来新增层。
## 相邻骨骼通过 collision exception 避免互相弹飞。
@export_flags_3d_physics var ragdoll_collision_mask: int = PhysicsLayers.RAGDOLL_DEFAULT_MASK

# 冲击力目标 ─────────────────────────────────────────────────
@export_group("冲击力目标")
## 上半身骨骼名关键词，冲击力施加到匹配任一关键词的骨骼 / Upper body bone name keywords for force application
@export var upper_body_keywords: Array[String] = [
	"Spine", "Neck", "Head", "Shoulder", "Arm"
]
