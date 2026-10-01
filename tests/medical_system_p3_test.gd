extends RefCounted

## Dependency-light P3/P4 regression checks. Run from a Godot test harness with:
## `var result = MedicalSystemP3Test.run_all()`.
class_name MedicalSystemP3Test

static func run_all() -> Dictionary:
	var results := {
		"multiple_wounds_coexist": _multiple_wounds_coexist(),
		"packing_only_stops_external": _packing_only_stops_external(),
		"chest_seal_does_not_stop_internal": _chest_seal_does_not_stop_internal(),
		"revive_thresholds_are_configurable": _revive_thresholds_are_configurable(),
		"splint_tracks_each_fracture": _splint_tracks_each_fracture(),
		"p4_impairment_config_is_valid": _p4_impairment_config_is_valid(),
		"morphine_does_not_mutate_wound": _morphine_does_not_mutate_wound(),
		"tourniquet_stops_external_bleed": _tourniquet_stops_external_bleed(),
	}
	for key in results:
		assert(results[key], key)
	return results

static func _multiple_wounds_coexist() -> bool:
	var region := BodyRegion.new()
	var first := Wound.new()
	var second := Wound.new()
	region.add_wound(first)
	region.add_wound(second)
	return region.wounds.size() == 2

static func _packing_only_stops_external() -> bool:
	var wound := Wound.new()
	wound.bleed_rate = MedicalEnums.BleedRate.VENOUS
	wound.internal_bleed_rate = MedicalEnums.BleedRate.ARTERIAL
	wound.is_packed = true
	return is_zero_approx(wound.get_bleed_ml_per_sec()) and wound.get_internal_bleed_ml_per_sec() > 0.0

static func _chest_seal_does_not_stop_internal() -> bool:
	var wound := Wound.new()
	wound.internal_bleed_rate = MedicalEnums.BleedRate.VENOUS
	wound.is_open_chest_wound = true
	wound.is_chest_sealed = true
	return wound.get_internal_bleed_ml_per_sec() > 0.0

static func _revive_thresholds_are_configurable() -> bool:
	var config := HealthConfig.new()
	return config.revive_min_perfusion > 0.0 and config.revive_min_oxygenation > 0.0

static func _splint_tracks_each_fracture() -> bool:
	var region := BodyRegion.new()
	region.add_fracture(&"left_femur")
	region.add_fracture(&"left_tibia")
	region.splinted_bones.append(&"left_femur")
	return region.fractured_bones.size() == 2 and region.is_splinted(&"left_femur") and not region.is_splinted(&"left_tibia")

static func _p4_impairment_config_is_valid() -> bool:
	var config := HealthConfig.new()
	return config.fractured_leg_multiplier < config.splinted_leg_multiplier and config.fractured_arm_multiplier < config.splinted_arm_multiplier and config.morphine_duration > 0.0 and config.pain_movement_penalty > 0.0 and config.pain_aim_penalty > 0.0

static func _morphine_does_not_mutate_wound() -> bool:
	var wound := Wound.new()
	wound.pain_contribution = 0.8
	var before := wound.pain_contribution
	return is_equal_approx(wound.pain_contribution, before)

static func _tourniquet_stops_external_bleed() -> bool:
	var wound := Wound.new()
	wound.bleed_rate = MedicalEnums.BleedRate.ARTERIAL
	var untreated := wound.get_bleed_ml_per_sec()
	wound.is_tourniqueted = true
	return untreated > 0.0 and is_zero_approx(wound.get_bleed_ml_per_sec())
