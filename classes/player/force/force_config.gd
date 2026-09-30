class_name ForceConfig
extends Resource

# ============================================================
# 通用力系统配置
# 功能：定义力沿骨骼链传播的衰减、姿态偏移增益与安全上限，
#       并集中保存冲量换算比例。
# 用法：在编辑器中创建 .tres 资源，挂到 PlayerConfig.force_config。
# ============================================================

@export_group("传播")
## 每层骨骼的力衰减系数；权重 = decay_per_level ^ 层级距离。
@export_range(0.01, 1.0, 0.01) var decay_per_level: float = 0.67
## 传播的最大层级距离；超出后权重归零。
@export_range(0, 32, 1) var max_propagation_depth: int = 6
## 未显式指定持续时间时使用的默认时长（秒）。
@export_range(0.01, 5.0, 0.01) var default_duration: float = 0.25
## 指数衰减曲线在 duration 处的残余权重（0–1）；1.0 表示“不衰减”。
@export_range(0.0, 1.0, 0.01) var decay_floor: float = 0.05

@export_group("姿态偏移")
## 单位力（magnitude=1）对应的旋转偏移量（弧度）。
@export_range(0.0, 3.14159, 0.001) var rotation_gain: float = 0.35
## 单位力（magnitude=1）对应的位移偏移量（米）。
@export_range(0.0, 1.0, 0.001) var translation_gain: float = 0.05
## 单骨骼位移偏移的硬上限（米），防止骨骼拉伸/穿插。
@export_range(0.0, 0.5, 0.001) var max_translation_m: float = 0.06
## 施加位移偏移的最大层级距离；更深的骨骼只旋转不位移。
@export_range(0, 32, 1) var translation_max_depth: int = 1

@export_group("叠加与上限")
## 逐骨骼姿态偏移的求和上限；超过后不再增加偏移量。
@export_range(0.01, 10.0, 0.01) var pose_cap: float = 1.6
## 触发 overload 的求和阈值。
@export_range(0.01, 10.0, 0.01) var overload_threshold: float = 1.6
## overload 时的微幅抖动振幅；0 表示关闭。
@export_range(0.0, 0.2, 0.001) var overload_jitter: float = 0.0
## 同时存在的最大力数量；超出时丢弃最旧的力。
@export_range(1, 64, 1) var max_active_forces: int = 8

@export_group("冲量换算")
## 归一化 magnitude 的换算基准冲量（N·s）；impulse/基准 = magnitude。
@export_range(0.01, 200.0, 0.01) var pose_reference_impulse: float = 12.0
## 命中动能转化为布娃娃冲量的比例。
@export_range(0.0, 1.0, 0.01) var impact_energy_transfer: float = 0.35
## 爆头命中使用的能量传递比例。
@export_range(0.0, 1.0, 0.01) var headshot_energy_transfer: float = 0.50
## 爆炸伤害使用的能量传递比例。
@export_range(0.0, 1.0, 0.01) var explosion_energy_transfer: float = 0.20
## 非弹道伤害缺少弹头质量时使用的等效质量（kg）。
@export_range(0.01, 20.0, 0.01) var fallback_impact_mass_kg: float = 1.0
## 爆头时额外集中到头部的冲量比例（相对于本次总冲量）。
@export_range(0.0, 1.0, 0.01) var headshot_extra_impulse_ratio: float = 0.25
## 上半身骨骼名关键词，用于布娃娃冲量分配。
@export var upper_body_keywords: Array[String] = [
	"Spine", "Neck", "Head", "Shoulder", "Arm"
]


## 按衰减曲线返回某个层级距离处的传播权重。
func propagation_weight(depth: int) -> float:
	if depth < 0 or depth > max_propagation_depth:
		return 0.0
	return pow(clampf(decay_per_level, 0.0, 1.0), float(depth))


## 按冲量推导归一化力强度；非法输入返回 0。
func normalized_magnitude(impulse_ns: float) -> float:
	if not is_finite(impulse_ns) or impulse_ns <= 0.0:
		return 0.0
	return impulse_ns / maxf(pose_reference_impulse, 0.001)
