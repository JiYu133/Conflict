extends Node3D

const DEFAULT_CONFIG: EncounterConfig = preload("res://assets/config/encounter/encounter_default.tres")
const CONTROLLER_SCRIPT := preload("res://classes/encounter/encounter_controller.gd")
const DIRECTOR_SCRIPT := preload("res://classes/encounter/encounter_ai_director.gd")
const HUD_SCRIPT := preload("res://classes/encounter/encounter_hud.gd")

var config: EncounterConfig
var controller: EncounterController

func _ready() -> void:
	config = DEFAULT_CONFIG.duplicate(true) as EncounterConfig
	var player := find_child("CharacterBody3D", true, false) as BasePlayer
	var manager := find_child("AIPlayerManager", true, false) as AIPlayerManager
	if not player or not manager:
		push_error("Encounter prototype requires TestMap player and AIPlayerManager")
		return
	player.global_position = config.player_spawn_position
	player.rotation.y = deg_to_rad(config.player_spawn_yaw_degrees)
	player.prepare_for_encounter_spawn(player.global_transform)
	manager.set_spawn_transform(player.global_transform)
	player.faction = BasePlayer.Faction.RU
	controller = CONTROLLER_SCRIPT.new() as EncounterController
	controller.name = "EncounterController"
	controller.config = config
	controller.objective_position = Vector3(0.0, 0.0, 0.0)
	controller.extraction_position = Vector3(-18.0, 0.0, -16.0)
	add_child(controller)
	await get_tree().process_frame
	var treatment := player.get_node_or_null("MedicalTreatment") as MedicalTreatmentComponent
	if treatment:
		treatment.initialize(player, config)
	controller.register_actor(player, player.faction)
	_spawn_bots(manager, controller)
	var director := DIRECTOR_SCRIPT.new() as EncounterAIDirector
	director.name = "EncounterAIDirector"
	add_child(director)
	director.initialize(controller)
	_add_zone_visuals(controller)
	var hud := HUD_SCRIPT.new() as EncounterHUD
	hud.name = "EncounterHUD"
	add_child(hud)
	hud.initialize(controller, player)
	controller.start_match()

func _spawn_bots(manager: AIPlayerManager, encounter: EncounterController) -> void:
	var friendly_positions := [Vector3(-15.0, 0.9, 10.0), Vector3(-10.0, 0.9, 12.0), Vector3(-5.0, 0.9, 14.0)]
	var enemy_positions := [Vector3(15.0, 0.9, -10.0), Vector3(10.0, 0.9, -12.0), Vector3(5.0, 0.9, -14.0), Vector3(18.0, 0.9, -4.0)]
	for index in range(config.friendly_ai_player_count):
		var ai_player := manager.add_ai_player("Friendly_%d" % (index + 1), BasePlayer.Faction.RU, friendly_positions[index % friendly_positions.size()], true, _ai_config_for(config.friendly_ai_configs, config.friendly_ai_config, index))
		if ai_player:
			encounter.register_actor(ai_player, BasePlayer.Faction.RU)
	for index in range(config.enemy_ai_player_count):
		var ai_player := manager.add_ai_player("Enemy_%d" % (index + 1), BasePlayer.Faction.UA, enemy_positions[index % enemy_positions.size()], true, _ai_config_for(config.enemy_ai_configs, config.enemy_ai_config, index))
		if ai_player:
			encounter.register_actor(ai_player, BasePlayer.Faction.UA)


func _ai_config_for(pool: Array[AIConfig], fallback: AIConfig, index: int) -> AIConfig:
	var valid: Array[AIConfig] = []
	for candidate in pool:
		if candidate:
			valid.append(candidate)
	if not valid.is_empty():
		return valid[index % valid.size()]
	return fallback


func _add_zone_visuals(encounter: EncounterController) -> void:
	var objective := _make_zone_mesh("ObjectiveMarker", encounter.objective_position, config.objective_radius, Color(0.1, 0.55, 0.95, 0.25))
	var extraction := _make_zone_mesh("ExtractionMarker", encounter.extraction_position, config.extraction_radius, Color(0.2, 0.85, 0.45, 0.28))
	add_child(objective)
	add_child(extraction)

func _make_zone_mesh(node_name: String, position: Vector3, radius: float, color: Color) -> MeshInstance3D:
	var mesh_node := MeshInstance3D.new()
	mesh_node.name = node_name
	mesh_node.position = position + Vector3.UP * 0.03
	var cylinder := CylinderMesh.new()
	cylinder.top_radius = radius
	cylinder.bottom_radius = radius
	cylinder.height = 0.05
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	cylinder.material = material
	mesh_node.mesh = cylinder
	return mesh_node
