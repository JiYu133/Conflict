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

@export_group("血量 / Blood Volume")
## 初始血量（ml）。成人正常约 4700–5500 ml
@export var blood_volume_ml: float = 5000.0
## 触发 CRITICAL 状态的血量百分比阈值（跌破此值进入濒危）
@export_range(0.0, 1.0) var critical_blood_threshold_pct: float = 0.6
## 血液耗尽死亡阈值（跌破此值即死亡）
@export_range(0.0, 1.0) var fatal_blood_threshold_pct: float = 0.3

@export_group("部位致命阈值 / Lethality Thresholds")
## 头部单次伤口致命阈值（severity >= 此值立即死亡）
@export_range(0.0, 1.0) var head_lethal_severity: float = 0.7
## 躯干单次伤口致命阈值
@export_range(0.0, 1.0) var torso_lethal_severity: float = 0.85
## 头部累积伤口致命阈值（总 severity >= 此值死亡）
@export var head_cumulative_lethal: float = 1.2
## 躯干累积伤口致命阈值
@export var torso_cumulative_lethal: float = 2.5

@export_group("弹道 / Ballistics")
## 动能（J）转伤口 severity 的换算基准（J）
## 公式：severity = KE / this_value
## 例：500J 基准 → 500J 伤害 = 1.0 severity（重伤），1000J = 2.0（致命）
@export var ke_per_severity_unit: float = 600.0
## 受伤后立即血量损失的换算系数（severity × 此值 = 立即失血 ml）
@export var immediate_blood_loss_per_severity: float = 150.0

@export_group("出血模拟 / Bleed Tick")
## 生理 tick 间隔（秒）。建议 0.1–0.25；越小越精确但越耗性能
@export_range(0.05, 1.0) var tick_interval: float = 0.2
