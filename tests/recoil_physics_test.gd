extends RefCounted

## Dependency-light checks for the physically driven six-DOF recoil model.
## Run from a Godot harness with: `RecoilPhysicsTest.run_all()`.
class_name RecoilPhysicsTest

const RECOIL_MODEL_SCRIPT = preload("res://classes/weapon/recoil_physics_model.gd")
const RECOIL_COMPONENT_SCRIPT = preload("res://classes/weapon/recoil_component.gd")

static func run_all() -> Dictionary:
	var results := {
		"symmetric_shot_has_rearward_impulse": _symmetric_shot_has_rearward_impulse(),
		"symmetric_shot_has_pitch_but_no_roll": _symmetric_shot_has_pitch_but_no_roll(),
		"off_axis_bore_produces_yaw_and_roll": _off_axis_bore_produces_yaw_and_roll(),
		"mass_changes_linear_velocity": _mass_changes_linear_velocity(),
		"pose_snapshot_has_six_dof_state": _pose_snapshot_has_six_dof_state(),
	}
	for key in results:
		assert(results[key], key)
	return results

static func _model(cfg: WeaponConfig):
	var model = RECOIL_MODEL_SCRIPT.new()
	model.rebuild(cfg, null)
	return model

static func _base_config() -> WeaponConfig:
	var cfg := WeaponConfig.new()
	cfg.weapon_name = "recoil_test"
	cfg.receiver_mass_kg = 3.0
	cfg.bore_point_local = Vector3(0.0, 0.06, -0.35)
	cfg.shoulder_pivot_local = Vector3(0.0, -0.04, 0.35)
	cfg.shooter_impulse_noise = 0.0
	return cfg

static func _symmetric_shot_has_rearward_impulse() -> bool:
	var model := _model(_base_config())
	return model.shot_impulse_local.z > 0.0 and model.shot_linear_velocity_local.z > 0.0

static func _symmetric_shot_has_pitch_but_no_roll() -> bool:
	var model := _model(_base_config())
	return absf(model.pitch_impulse_rad_s) > 0.001 and is_zero_approx(model.roll_impulse_rad_s)

static func _off_axis_bore_produces_yaw_and_roll() -> bool:
	var cfg := _base_config()
	cfg.bore_point_local.x = 0.08
	var model := _model(cfg)
	return absf(model.yaw_impulse_rad_s) > 0.001 and absf(model.roll_impulse_rad_s) > 0.001

static func _mass_changes_linear_velocity() -> bool:
	var light_cfg := _base_config()
	light_cfg.receiver_mass_kg = 2.0
	var heavy_cfg := _base_config()
	heavy_cfg.receiver_mass_kg = 4.0
	var light := _model(light_cfg)
	var heavy := _model(heavy_cfg)
	return light.shot_linear_velocity_local.z > heavy.shot_linear_velocity_local.z

static func _pose_snapshot_has_six_dof_state() -> bool:
	var component = RECOIL_COMPONENT_SCRIPT.new()
	component.initialize(_base_config())
	component.apply_recoil()
	var pose := component.get_pose_snapshot()
	return pose.has("pitch_rad") and pose.has("yaw_rad") and pose.has("roll_rad") and pose.has("position_local") and pose.has("velocity_local") and pose.has("angular_velocity")
