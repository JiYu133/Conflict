class_name HealthConfig
extends Resource

# ============================================================
# 医疗系统配置资源
# 功能：定义玩家的全部生理参数和弹道伤害换算系数。
# 用法：在 Godot 编辑器中创建 .tres 资源并在 PlayerConfig 中引用。
#       留空则 HealthSystem 使用 HealthConfig.new() 的默认值。
# ============================================================

@export_group("碰撞体配置 / Hitbox Config")
## 碰撞体形状参数配置（留空则使用默认值）
@export var hitbox_config: HitboxConfig

@export_group("解剖模型 / Anatomy（P2）")
## 内部结构（器官/骨骼/大血管）定义与伤道求解参数。
## 留空 = 使用 AnatomyConfig.create_default() 的内置人体模板。
@export var anatomy_config: AnatomyConfig

@export_group("软组织出血阈值 / Soft-Tissue Bleed（P2）")
## 软组织静脉出血的伤口严重度阈值。
## 注意：动脉出血不再由部位+严重度决定，只有伤道命中大血管才会产生。
@export var venous_severity_threshold: float = 0.4
## 软组织毛细血管出血的伤口严重度阈值
@export var capillary_severity_threshold: float = 0.1

@export_group("血量 / Blood Volume")
## 初始血量（ml）。成人正常约 4700–5500 ml，建议不低于 3000。
@export var blood_volume_ml: float = 5000.0
## 触发 CRITICAL 状态的血量百分比阈值（跌破此值进入濒危）。
## 医学参考：失血 20–30%（1000–1500 ml）进入失血性休克 Class II。
@export_range(0.0, 1.0) var critical_blood_threshold_pct: float = 0.6
## 触发 UNCONSCIOUS（失去意识）状态的血量百分比阈值（跌破此值无法操控，但仍存活可被救治）。
## 医学参考：失血 30–40% 进入 Class III，通常导致意识模糊乃至昏迷。
@export_range(0.0, 1.0) var unconscious_blood_threshold_pct: float = 0.4
## 血液耗尽死亡阈值（跌破此值即死亡）。
## 医学参考：失血 >40%（>2000 ml）为危及生命的 Class IV 失血性休克。
@export_range(0.0, 1.0) var fatal_blood_threshold_pct: float = 0.3

@export_group("部位致命阈值 / Lethality Thresholds")
## 头部单次伤口致命阈值（severity >= 此值立即死亡）。
## 注意：severity 为开放量表可超过 1.0（如 7.62×39 ≈ 1.76），阈值也允许 >1.0。
## 调参提示：值越低越容易被一枪爆头；0.5 左右为"高威力武器单发即死"，>1.0 为"需要多发或高威力弹"。
@export_range(0.0, 3.0, 0.01, "or_greater") var head_lethal_severity: float = 0.7
## 躯干单次伤口致命阈值。躯干耐受性通常高于头部，建议设为 head_lethal_severity 的 1.2–1.5 倍。
## （默认 .tres 使用 1.5，超过旧的 0–1 滑条范围，故此处放宽为开放上限。）
@export_range(0.0, 3.0, 0.01, "or_greater") var torso_lethal_severity: float = 0.85
## 头部累积伤口致命阈值（总 severity >= 此值死亡），用于多发低威力弹累积致死判定。
@export var head_cumulative_lethal: float = 1.2
## 躯干累积伤口致命阈值。
@export var torso_cumulative_lethal: float = 2.5

@export_group("弹道 / Ballistics")
## 动能（J）转伤口 severity 的换算基准。
## 公式：severity = KE / ke_per_severity_unit
## 注意：本脚本的回退默认值为 1200（与 health_config_default.tres 一致）。
## 典型值参考（ke_per_severity_unit = 1200 时）：
##   5.45×39（3.45g @ 880m/s）→ ~1335J → severity ≈ 1.11（接近躯干单发致命）
##   7.62×39（7.9g  @ 730m/s）→ ~2108J → severity ≈ 1.76（躯干高概率致命）
## 值越大则越难造成重伤；建议范围：600–2000。
@export var ke_per_severity_unit: float = 1200.0
## 受伤后立即血量损失的换算系数（模拟液压冲击效应）。
## 公式：立即失血（ml）= severity × immediate_blood_loss_per_severity
## 典型值 150：severity 1.0 → 150 ml 立即失血（约总血量的 3%）。
@export var immediate_blood_loss_per_severity: float = 150.0

@export_group("出血模拟 / Bleed Tick")
## 生理 tick 间隔（秒）。建议 0.1–0.25；越小越精确但越耗性能
@export_range(0.05, 1.0) var tick_interval: float = 0.2

@export_group("Physiology / P3")
@export_range(0.0, 1.0) var open_chest_wound_penalty: float = 0.35
@export_range(0.01, 2.0) var oxygenation_recovery_rate: float = 0.8
@export_range(0.0, 1.0) var respiratory_arrest_threshold: float = 0.05
@export_range(0.0, 1.0) var circulatory_arrest_threshold: float = 0.05
@export_range(0.0, 1.0) var unconscious_perfusion_threshold: float = 0.4
@export_range(0.0, 1.0) var unconscious_oxygenation_threshold: float = 0.35
@export_range(0.0, 1.0) var revive_min_perfusion: float = 0.55
@export_range(0.0, 1.0) var revive_min_oxygenation: float = 0.5

@export_group("Stress Response / P3")
@export var stress_enabled: bool = true
@export_range(0.0, 3.0) var stress_severe_wound_threshold: float = 0.7
@export_range(0.0, 100.0) var stress_bleed_rate_threshold: float = 5.0
@export_range(0.0, 1.0) var stress_critical_blood_pct: float = 0.65
@export_range(0.01, 10.0) var stress_rise_rate: float = 4.0
@export_range(0.01, 2.0) var stress_decay_rate: float = 0.25
@export_range(0.0, 30.0) var stress_duration: float = 8.0
@export_range(0.0, 0.5) var adrenaline_consciousness_bonus: float = 0.12
@export_range(0.0, 1.0) var adrenaline_pain_tolerance: float = 0.2
@export_range(0.0, 1.0) var adrenaline_respiratory_load: float = 0.1

## Neck, abdomen, pelvis, hands, and feet remain future BodyPartId/hitbox extensions.
