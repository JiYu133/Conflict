extends SceneTree

func _init() -> void:
	var barrel := load("res://assets/config/weapons/attachments/barrel_assemblies/ak12_barrel_assembly.tres")
	var muzzle := load("res://assets/config/weapons/attachments/muzzle_devices/ak12_muzzle_brake.tres")
	var grip := load("res://assets/config/weapons/attachments/grips/vertical_grip_magpul.tres")
	var stock := load("res://assets/config/weapons/attachments/stocks/ak12_stock.tres")

	if not (barrel is BarrelConfig):
		push_error("BarrelConfig failed to load")
		quit(1)
		return
	if not (muzzle is MuzzleDeviceConfig):
		push_error("MuzzleDeviceConfig failed to load")
		quit(1)
		return
	if not (grip is GripConfig):
		push_error("GripConfig failed to load")
		quit(1)
		return
	if not (stock is StockConfig):
		push_error("StockConfig failed to load")
		quit(1)
		return

	var cfg := WeaponConfig.new()
	var model := RecoilPhysicsModel.new()
	model.rebuild(cfg, null)
	print("recoil_snapshot=", model.get_snapshot())
	quit(0)
