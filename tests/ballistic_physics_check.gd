extends SceneTree

const ENVIRONMENT_IMPACT_EFFECT = preload("res://classes/combat/environment_impact_effect.gd")

func _init() -> void:
	var environment := load("res://assets/config/ballistics/default_environment.tres") as BallisticEnvironmentConfig
	var barrel := load("res://assets/config/weapons/attachments/barrel_assemblies/ak12_barrel_assembly.tres") as BarrelConfig
	if not environment or not barrel:
		_fail("ballistic resources failed to load")
		return
	_check(is_equal_approx(environment.gravity_mps2, 9.80665), "standard gravity")
	_check(is_equal_approx(environment.air_density_kg_m3, 1.225), "standard air density")
	_check(is_equal_approx(barrel.bullet_diameter_mm, 5.45), "AK-12 bullet diameter")
	_check(is_equal_approx(barrel.bullet_mass_g, 3.45), "AK-12 bullet mass")

	var fast_bc_drag := Ballistics.drag_acceleration(Vector3(900, 0, 0), 0.22).length()
	var slow_bc_drag := Ballistics.drag_acceleration(Vector3(900, 0, 0), 0.44).length()
	_check(fast_bc_drag > slow_bc_drag, "lower BC loses more speed")
	var still_air_drag := Ballistics.drag_acceleration(Vector3(900, 0, 0) - Vector3(0, 0, 0), 0.22)
	var tail_wind_drag := Ballistics.drag_acceleration(Vector3(900, 0, 0) - Vector3(100, 0, 0), 0.22)
	_check(tail_wind_drag.length() < still_air_drag.length(), "relative wind changes drag")

	var right_spin := Ballistics.spin_drift_acceleration(Vector3.RIGHT, 890.0, 0.1, 0.195, 1)
	var left_spin := Ballistics.spin_drift_acceleration(Vector3.RIGHT, 890.0, 0.1, 0.195, -1)
	_check(right_spin.dot(Vector3.RIGHT) > 0.0, "right-hand spin direction")
	_check(left_spin.dot(Vector3.RIGHT) < 0.0, "left-hand spin direction")
	_check(right_spin.length() > Ballistics.spin_drift_acceleration(Vector3.RIGHT, 890.0, 0.1, 0.39, 1).length(), "twist rate affects drift")

	var surface := BallisticSurfaceConfig.new()
	surface.penetrable = true
	surface.thickness_m = 0.05
	surface.hardness = 1.0
	_check(surface.required_penetration_energy() > 0.0, "surface penetration energy")
	_check(surface.ricochet_angle_deg > 0.0, "surface ricochet angle is configured")
	_check(surface.ricochet_energy_retention > 0.0, "surface retains energy after ricochet")
	var glancing_direction := Vector3(1.0, -0.05, 0.0).normalized()
	var grazing_angle := rad_to_deg(asin(absf(glancing_direction.dot(Vector3.UP))))
	_check(grazing_angle <= surface.ricochet_angle_deg, "glancing impact enters ricochet angle")
	var reflected := glancing_direction.bounce(Vector3.UP)
	_check(reflected.y > 0.0, "ricochet reflection leaves the surface")
	_check(ResourceLoader.exists("%s/variant_01/frame_0001.png" % ENVIRONMENT_IMPACT_EFFECT.FRAME_ROOT), "wall impact animation resource exists")
	_check(environment.tracer_scene == null, "default environment has no tracer")
	print("ballistic_physics_check=ok")
	quit(0)


func _check(condition: bool, label: String) -> void:
	if not condition:
		_fail(label)


func _fail(label: String) -> void:
	push_error("ballistic_physics_check failed: " + label)
	quit(1)
