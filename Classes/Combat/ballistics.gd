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


## 根据射程估算弹头速度衰减（简化指数阻力模型）。[P2 功能，P1 直接使用枪口初速]
## 模型：v(d) = v₀ × exp(−k × d)，其中 k = 0.0001 / (BC × mass_kg)
## [参数] muzzle_velocity  枪口初速（m/s）
## [参数] mass_kg          弹头质量（kg）
## [参数] bc               弹道系数（G1 标准，典型值 0.2–0.6）
## [参数] range_m          射程（m）
## [返回] 衰减后速度（m/s）；bc ≤ 0 或 range ≤ 0 时直接返回枪口初速
static func velocity_at_range(muzzle_velocity: float, mass_kg: float, bc: float, range_m: float) -> float:
	if bc <= 0.0 or range_m <= 0.0:
		return muzzle_velocity
	# 简化指数衰减：v(d) = v0 × exp(-k × d)，k 由 BC 和质量推导
	var k: float = 0.0001 / (bc * mass_kg)
	return muzzle_velocity * exp(-k * range_m)
