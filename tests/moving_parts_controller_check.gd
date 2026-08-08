extends SceneTree


func _init() -> void:
	var weapon := BaseWeapon.new()
	get_root().add_child(weapon)

	var manager := AttachmentManager.new()
	weapon.attachment_manager = manager
	weapon.add_child(manager)

	var controller := WeaponMovingPartsController.new()
	weapon.add_child(controller)
	controller.initialize(weapon)

	var bolt_carrier := Node3D.new()
	bolt_carrier.name = "BoltCarrier"
	weapon.add_child(bolt_carrier)

	var charging_handle := Node3D.new()
	charging_handle.name = "ChargingHandleMesh"
	weapon.add_child(charging_handle)

	manager.attachments_changed.emit()
	await get_tree().process_frame

	weapon.bolt_moving.emit(0.5)

	if not _check(is_equal_approx(bolt_carrier.position.z, 0.04), "BoltCarrier follows bolt_moving after late attachment"):
		return
	if not _check(is_equal_approx(charging_handle.position.z, 0.04), "ChargingHandleMesh follows bolt_moving after late attachment"):
		return

	print("moving_parts_controller_check=ok")
	quit(0)


func _check(condition: bool, message: String) -> bool:
	if condition:
		return true
	push_error(message)
	quit(1)
	return false
