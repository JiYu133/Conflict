class_name BallisticSurfaceConfig
extends Resource

## Surface data can be assigned as collider metadata or as a Resource.
@export var material_name: String = "hard_surface"
@export var penetrable: bool = false
@export var thickness_m: float = 0.1
@export_range(0.0, 100.0, 0.1) var hardness: float = 1.0
## Fraction of the remaining energy lost after a successful penetration.
@export_range(0.0, 1.0, 0.01) var energy_loss_factor: float = 0.45
@export var penetration_resistance_j: float = 1000.0
@export_range(0.0, 90.0, 0.5) var ricochet_angle_deg: float = 15.0
@export_range(0.0, 1.0, 0.01) var ricochet_energy_retention: float = 0.65

var penetration_energy_loss: float:
	get:
		return energy_loss_factor
	set(value):
		energy_loss_factor = value


func required_penetration_energy() -> float:
	return maxf(penetration_resistance_j, maxf(thickness_m, 0.001) * maxf(hardness, 0.0) * 10000.0)


static func from_collider(collider: Object) -> BallisticSurfaceConfig:
	var result := BallisticSurfaceConfig.new()
	if not collider:
		return result

	if collider.has_method("get_ballistic_surface_config"):
		var method_value = collider.get_ballistic_surface_config()
		if method_value is BallisticSurfaceConfig:
			return method_value
		if method_value is Dictionary:
			_apply_dictionary(result, method_value)
			return result

	for key in ["ballistic_surface_config", "ballistic_surface", "ballistic_material"]:
		if collider.has_meta(key):
			var value = collider.get_meta(key)
			if value is BallisticSurfaceConfig:
				return value
			if value is Dictionary:
				_apply_dictionary(result, value)
				return result

	# Individual metadata fields are useful for map-authored collision bodies.
	var metadata_map := {
		"ballistic_material_name": "material_name",
		"ballistic_penetrable": "penetrable",
		"ballistic_thickness_m": "thickness_m",
		"ballistic_hardness": "hardness",
		"ballistic_energy_loss_factor": "energy_loss_factor",
		"ballistic_penetration_energy_loss": "energy_loss_factor",
		"ballistic_penetration_resistance_j": "penetration_resistance_j",
		"ballistic_ricochet_angle_deg": "ricochet_angle_deg",
		"ballistic_ricochet_energy_retention": "ricochet_energy_retention",
	}
	for metadata_key: String in metadata_map:
		if collider.has_meta(metadata_key):
			result.set(metadata_map[metadata_key], collider.get_meta(metadata_key))
	return result


static func _apply_dictionary(result: BallisticSurfaceConfig, values: Dictionary) -> void:
	for key: String in [
		"material_name", "penetrable", "thickness_m", "hardness",
		"energy_loss_factor", "penetration_resistance_j",
		"penetration_energy_loss", "penetration_energy_loss_factor",
		"ricochet_angle_deg", "ricochet_energy_retention"
	]:
		if values.has(key):
			result.set("energy_loss_factor" if key.begins_with("penetration_") else key, values[key])
