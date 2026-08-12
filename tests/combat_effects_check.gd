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

	print("combat_effects_check=ok")
	get_tree().quit(0)


func _fail(message: String) -> void:
	push_error(message)
	get_tree().quit(1)
