extends RefCounted

## Dependency-light P3 regression checks. Run from a Godot test harness with:
## `var result = MedicalSystemP3Test.run_all()`.
class_name MedicalSystemP3Test

static func run_all() -> Dictionary:
	var results := {
		"multiple_wounds_coexist": _multiple_wounds_coexist(),
		"packing_only_stops_external": _packing_only_stops_external(),
		"chest_seal_does_not_stop_internal": _chest_seal_does_not_stop_internal(),
		"revive_thresholds_are_configurable": _revive_thresholds_are_configurable(),
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
