extends SceneTree

const SettingsService = preload("res://classes/ui/settings/settings_service.gd")

var _failures := 0


func _init() -> void:
	var service := SettingsService.new()
	root.add_child(service)
	_check(service.get_value("graphics/muzzle_flash_distance") == 120.0, "default muzzle flash distance")
	_check(service.get_value("graphics/muzzle_light_distance") == 35.0, "default muzzle light distance")
	_check(service.get_value("graphics/muzzle_flash_offscreen_culling") == true, "default offscreen culling")
	_check(service.get_value("graphics/muzzle_flash_quality") == "medium", "default muzzle flash quality")
	service.set_value("graphics/muzzle_flash_distance", 999.0)
	service.set_value("graphics/muzzle_light_distance", 0.0)
	service.set_value("graphics/muzzle_flash_quality", "invalid")
	_check(service.get_value("graphics/muzzle_flash_distance") == 300.0, "muzzle flash distance clamps")
	_check(service.get_value("graphics/muzzle_light_distance") == 5.0, "muzzle light distance clamps")
	_check(service.get_value("graphics/muzzle_flash_quality") == "medium", "invalid quality falls back")
	quit(0 if _failures == 0 else 1)


func _check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		_failures += 1
		push_error("FAIL: " + label)
