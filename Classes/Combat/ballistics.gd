class_name Ballistics

# ============================================================
# 弹道学工具类（纯静态方法，无状态）
# 功能：提供动能计算和弹道衰减模型。
# 用法：Ballistics.kinetic_energy(mass_kg, velocity_mps) 返回焦耳。
# ============================================================

## 计算动能（焦耳）
## mass_kg: 弹头质量（千克）
## velocity_mps: 速度（米/秒）
## 返回：KE = 0.5 × m × v²
static func kinetic_energy(mass_kg: float, velocity_mps: float) -> float:
	return 0.5 * mass_kg * velocity_mps * velocity_mps


## 根据射程估算弹头速度衰减（简化阻力模型）
## muzzle_velocity: 枪口初速（m/s）
## mass_kg: 弹头质量（kg）
## bc: 弹道系数（G1 标准）
## range_m: 射程距离（m）
## 返回：衰减后速度（m/s），不低于 0
## P2 扩展用；P1 使用枪口初速即可
static func velocity_at_range(muzzle_velocity: float, mass_kg: float, bc: float, range_m: float) -> float:
	if bc <= 0.0 or range_m <= 0.0:
		return muzzle_velocity
	# 简化指数衰减：v(d) = v0 × exp(-k × d)，k 由 BC 和质量推导
	var k: float = 0.0001 / (bc * mass_kg)
	return muzzle_velocity * exp(-k * range_m)
