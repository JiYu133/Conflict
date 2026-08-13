extends Node


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	var map_scene := load("res://assets/map/TestMap.tscn") as PackedScene
	if not map_scene:
		_fail("TestMap failed to load")
		return

	var map := map_scene.instantiate()
	add_child(map)
	await get_tree().process_frame
	await get_tree().physics_frame

	var player := map.get_node_or_null("CharacterBody3D") as BasePlayer
	if not player or not player.combat_effects or not player.model_manager.skeleton:
		_fail("CombatEffects was not initialized with the player model")
		return

	var info := DamageInfo.new()
	info.amount = 600.0
	info.type = MedicalEnums.DamageType.BULLET
	info.body_part = MedicalEnums.BodyPartId.TORSO
	info.direction = Vector3.LEFT
	info.hit_position = player.global_position + Vector3.UP * 0.7
	info.anchor_bone = "mixamorig_Spine2"

	player.combat_effects._on_damage_taken(info)
	player.combat_effects._spawn_floor_mark(false, 3.0)
	await get_tree().process_frame

	if not find_child("ImpactDroplets", true, false):
		_fail("Impact droplet burst was not created")
		return
	if not player.model_manager.skeleton.find_child("Wound_Spine2", true, false):
		_fail("Bone-following wound decal was not created")
		return
	if not find_child("FloorDroplet", true, false):
		_fail("Floor droplet decal was not created")
		return
	if not find_child("WallSplatter", true, false):
		_fail("Outgoing hit trace did not create a wall splatter decal")
		return

	if not _check_atlas_variants(player.combat_effects):
		return
	if not _check_body_part_wounds(player):
		return

	player.combat_effects._spawn_arterial_spurt(15.0)
	await get_tree().process_frame
	var spurt := find_child("ArterialSpurt", true, false) as CPUParticles3D
	if not spurt or spurt.amount > 11:
		_fail("Arterial bleeding did not create a bounded directional pulse")
		return

	print("combat_effects_check=ok")
	get_tree().quit(0)


func _check_atlas_variants(effects: CombatEffects) -> bool:
	if effects._wound_mark_variants.size() != 4:
		_fail("Wound atlas variants were not cached during initialization")
		return false
	var signatures: Array[int] = []
	var variant_size := Vector2i.ZERO
	for variant in effects._wound_mark_variants:
		if not variant or variant.get_width() <= 0 or variant.get_width() >= effects.WOUND_MARK_ATLAS.get_width():
			_fail("Atlas variant was not cropped into a Decal-compatible texture")
			return false
		var image := variant.get_image()
		if variant_size == Vector2i.ZERO:
			variant_size = image.get_size()
		elif image.get_size() != variant_size:
			_fail("Atlas variant crops do not have consistent dimensions")
			return false
		if image.get_used_rect().size == Vector2i.ZERO:
			_fail("Atlas variant crop is fully transparent")
			return false
		var signature := hash(image.get_data())
		if signature in signatures:
			_fail("Atlas contains duplicate decal variants")
			return false
		signatures.append(signature)
	return true


func _check_body_part_wounds(player: BasePlayer) -> bool:
	var cases: Array = [
		[MedicalEnums.BodyPartId.HEAD, "mixamorig_Head"],
		[MedicalEnums.BodyPartId.TORSO, "mixamorig_Spine2"],
		[MedicalEnums.BodyPartId.LEFT_UPPER_ARM, "mixamorig_LeftArm"],
		[MedicalEnums.BodyPartId.LEFT_FOREARM, "mixamorig_LeftForeArm"],
		[MedicalEnums.BodyPartId.RIGHT_UPPER_ARM, "mixamorig_RightArm"],
		[MedicalEnums.BodyPartId.RIGHT_FOREARM, "mixamorig_RightForeArm"],
		[MedicalEnums.BodyPartId.LEFT_THIGH, "mixamorig_LeftUpLeg"],
		[MedicalEnums.BodyPartId.LEFT_CALF, "mixamorig_LeftLeg"],
		[MedicalEnums.BodyPartId.RIGHT_THIGH, "mixamorig_RightUpLeg"],
		[MedicalEnums.BodyPartId.RIGHT_CALF, "mixamorig_RightLeg"],
	]
	var skeleton := player.model_manager.skeleton
	for body_case in cases:
		var part: MedicalEnums.BodyPartId = body_case[0]
		var expected_bone: String = body_case[1]
		var info := DamageInfo.new()
		info.amount = 600.0
		info.type = MedicalEnums.DamageType.BULLET
		info.body_part = part
		var bone_index := skeleton.find_bone(expected_bone)
		if bone_index < 0:
			_fail("Test model is missing %s" % expected_bone)
			return false
		var outward := skeleton.global_basis.z.normalized()
		info.direction = -outward
		info.hit_position = skeleton.global_transform * skeleton.get_bone_global_pose(bone_index).origin \
			+ outward * _surface_offset_for_part(part)
		# Intentionally omit anchor_bone: visual feedback must still resolve from body_part.
		player.combat_effects._spawn_character_wound(info)
		var attachment := skeleton.find_child(
			"Wound_%s" % expected_bone.replace("mixamorig_", ""), true, false
		) as BoneAttachment3D
		if not attachment:
			_fail("Missing wound decal fallback for %s" % expected_bone)
			return false
		var decal := attachment.get_node_or_null("WoundDecal") as Decal
		if not decal or not decal.texture_albedo or decal.size.y < 0.19:
			_fail("Wound projection is too shallow for %s" % expected_bone)
			return false
		if decal.position.length() > 0.65:
			_fail("Wound decal is not localized to %s" % expected_bone)
			return false
	return true


func _surface_offset_for_part(part: MedicalEnums.BodyPartId) -> float:
	match part:
		MedicalEnums.BodyPartId.TORSO:
			return 0.18
		MedicalEnums.BodyPartId.HEAD:
			return 0.12
		MedicalEnums.BodyPartId.LEFT_THIGH, MedicalEnums.BodyPartId.RIGHT_THIGH:
			return 0.09
		MedicalEnums.BodyPartId.LEFT_CALF, MedicalEnums.BodyPartId.RIGHT_CALF:
			return 0.07
		_:
			return 0.06


func _fail(message: String) -> void:
	push_error(message)
	get_tree().quit(1)
