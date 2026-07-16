class_name Ballistics

# ============================================================
# 弹道学工具类（纯静态方法，无状态）
# 功能：提供动能计算和弹道衰减模型。
# 用法：Ballistics.kinetic_energy(mass_kg, velocity_mps) 返回焦耳。
# ============================================================

## 计算动能（焦耳）。公式：KE = 0.5 × m × v²
## [参数] mass_kg    弹头质量（千克）；常见值：5.45×39 ≈ 0.00345 kg，7.62×39 ≈ 0.0079 kg
## [参数] velocity_mps 速度（米/秒）；枪口初速：5.45×39 ≈ 880 m/s，7.62×39 ≈ 730 m/s
## [返回] 动能（J）；典型值：5.45×39 ≈ 1335 J，7.62×39 ≈ 2108 J
static func kinetic_energy(mass_kg: float, velocity_mps: float) -> float:
	return 0.5 * mass_kg * velocity_mps * velocity_mps


## 单位距离阻力衰减系数 k（1/m）的推导常数：k = DRAG_SCALE / BC。
## BC（G1 近似）本身已包含质量与截面积信息，因此 k 不再除以质量——
## 旧公式 k = 0.0001/(BC×mass_kg) 因质量以 kg 计而量纲失衡（k ≈ 0.1/m，
## 5.45 弹会在 30 米内失速），已修正。
## 标定：BC 0.22（5.45×39 类）→ k ≈ 0.00114/m → 880 m/s 在 300m 处 ≈ 656 m/s，
## 与实测弹道表相符。
const DRAG_SCALE: float = 0.00025


## 由弹道系数推导单位距离阻力衰减系数 k（1/m）。
## [参数] bc 弹道系数（G1 近似，典型值 0.15–0.6）
## [返回] 单位距离阻力系数 k（1/m）；bc ≤ 0 时返回 0（无阻力）
static func drag_factor(bc: float) -> float:
	if bc <= 0.0:
		return 0.0
	return DRAG_SCALE / bc


## 二次空气阻力减速度（m/s²）：dv/dt = −k·v²。
## 供 BallisticProjectileSystem 逐帧数值积分使用；与下方闭式解同一模型。
## [参数] speed_mps 当前速度（m/s）
## [参数] bc        弹道系数（G1 近似，典型值 0.15–0.6）
## [返回] 减速度（m/s²，非负）
static func drag_decel(speed_mps: float, bc: float) -> float:
	return drag_factor(bc) * speed_mps * speed_mps


## 根据射程估算弹头速度衰减（闭式解，供 hitscan 回退路径和调参参考）。
## 模型：dv/dt = −k·v² 沿弹道积分 → v(d) = v₀ / (1 + k·d)，k = DRAG_SCALE / BC
## [参数] muzzle_velocity  枪口初速（m/s）
## [参数] _mass_kg         弹头质量（kg）；保留签名兼容，质量已由 BC 编码，不再参与计算
## [参数] bc               弹道系数（G1 近似，典型值 0.15–0.6）
## [参数] range_m          射程（m）
## [返回] 衰减后速度（m/s）；bc ≤ 0 或 range ≤ 0 时直接返回枪口初速
static func velocity_at_range(muzzle_velocity: float, _mass_kg: float, bc: float, range_m: float) -> float:
	if bc <= 0.0 or range_m <= 0.0:
		return muzzle_velocity
	return muzzle_velocity / (1.0 + drag_factor(bc) * range_m)
