extends SceneTree

func _init() -> void:
	var barrel := load("res://res/config/weapons/attachments/ak12_barrel_assembly.tres")
	var muzzle := load("res://res/config/weapons/attachments/ak12_muzzle_brake.tres")
	var grip := load("res://res/config/weapons/attachments/vertical_grip_magpul.tres")
	var stock := load("res://res/config/weapons/attachments/ak12_stock.tres")

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
