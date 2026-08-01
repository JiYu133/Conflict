extends SceneTree


func _init() -> void:
	var muzzle_cfg := MuzzleDeviceConfig.new()
	muzzle_cfg.attachment_type = AttachmentConfig.AttachmentType.MUZZLE
	var muzzle_slot := AttachmentSlot.new()
	muzzle_slot.allowed_attachment_types = [AttachmentConfig.AttachmentType.MUZZLE]
	if not _check(muzzle_slot.can_accept_attachment(muzzle_cfg), "MuzzleDevice slot accepts muzzle attachment"):
		return

	var receiver_scene := load("res://res/models/attachments/receivers/ak12_receiver/ak12_receiver.tscn") as PackedScene
	var receiver := receiver_scene.instantiate()
	if not (receiver is BaseWeapon):
		_fail("AK12 receiver root should be BaseWeapon")
		return

	var manager := AttachmentManager.new()
	receiver.add_child(manager)
	manager.initialize(receiver as BaseWeapon, receiver)
	if not _check(manager.get_slot_names().has("Barrel"), "Scene Marker Barrel is registered"):
		return
	if not _check(manager.get_slot_names().has("ReceiverCover"), "Scene Marker ReceiverCover is registered"):
		return

	var dust_cfg := load("res://res/config/weapons/attachments/receiver_covers/ak12_dust_cover.tres") as AttachmentConfig
	var dust_att := AttachmentFactory.create(dust_cfg, receiver as BaseWeapon)
	if not _check(dust_att != null, "Dust cover attachment can be created"):
		return
	if not _check(manager.equip_to_slot(dust_att, "ReceiverCover"), "Dust cover can be equipped"):
		return
	if not _check(manager.get_slot_names().has("OpticRail"), "Nested OpticRail Marker is registered after parent equips"):
		return

	var sight_cfg := load("res://res/config/weapons/attachments/optics/ak12_iron_sight.tres") as AttachmentConfig
	var matched_slot := manager.find_first_available_slot_for(sight_cfg)
	if not _check(matched_slot != null and matched_slot.get_slot_key() == "OpticRail", "Auto preset matches nested OpticRail"):
		return

	var holder := Node.new()
	var left_slot := AttachmentSlot.new()
	left_slot.name = "SideRailLeft"
	left_slot.allowed_attachment_types = [AttachmentConfig.AttachmentType.SIDE]
	holder.add_child(left_slot)
	var right_slot := AttachmentSlot.new()
	right_slot.name = "SideRailRight"
	right_slot.allowed_attachment_types = [AttachmentConfig.AttachmentType.SIDE]
	holder.add_child(right_slot)
	var placement_manager := AttachmentManager.new()
	holder.add_child(placement_manager)
	placement_manager.initialize(null, holder)
	var side_cfg := AttachmentConfig.new()
	side_cfg.attachment_type = AttachmentConfig.AttachmentType.SIDE
	side_cfg.preferred_slot_names = ["SideRailRight"]
	var preferred_slot := placement_manager.find_first_available_slot_for(side_cfg)
	if not _check(preferred_slot != null and preferred_slot.get_slot_key() == "SideRailRight", "Preferred slot name wins over scene order"):
		return

	var rail_slot := AttachmentSlot.new()
	rail_slot.name = "RailOffsetTest"
	rail_slot.allowed_attachment_types = [AttachmentConfig.AttachmentType.SIDE]
	holder.add_child(rail_slot)
	var rail_manager := AttachmentManager.new()
	holder.add_child(rail_manager)
	rail_manager.initialize(null, holder)
	var rail_cfg := AttachmentConfig.new()
	rail_cfg.attachment_type = AttachmentConfig.AttachmentType.SIDE
	rail_cfg.rail_offset = 0.03
	var rail_att := BaseAttachment.new()
	rail_att.initialize(rail_cfg, null)
	if not _check(rail_manager.equip_to_slot(rail_att, "RailOffsetTest"), "Rail offset attachment can be equipped"):
		return
	if not _check(is_equal_approx(rail_att.position.z, 0.03), "Fixed rail_offset is applied on initial placement"):
		return

	print("attachment_system_check=ok")
	quit(0)


func _check(condition: bool, message: String) -> bool:
	if condition:
		return true
	push_error(message)
	quit(1)
	return false


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
