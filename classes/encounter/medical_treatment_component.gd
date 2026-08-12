class_name MedicalTreatmentComponent
extends Node

const OPTION_SCRIPT := preload("res://classes/ui/radial_menu_option.gd")

var player: BasePlayer
var config: EncounterConfig
var inventory: Dictionary = {}
var active := false
var active_target: BasePlayer
var active_treatment: int = -1
var active_time := 0.0

signal treatment_started(target: BasePlayer, treatment: int)
signal treatment_finished(target: BasePlayer, treatment: int, success: bool)

func initialize(owner: BasePlayer, encounter_config: EncounterConfig = null) -> void:
	player = owner
	config = encounter_config if encounter_config else EncounterConfig.new()
	inventory = {
		MedicalEnums.TreatmentType.BANDAGE: config.bandage_count,
		MedicalEnums.TreatmentType.TOURNIQUET: config.tourniquet_count,
		MedicalEnums.TreatmentType.CHEST_SEAL: config.chest_seal_count,
		MedicalEnums.TreatmentType.SPLINT: config.splint_count,
		MedicalEnums.TreatmentType.MORPHINE: config.morphine_count,
	}

func get_wheel_options() -> Array[RadialMenuOption]:
	var options: Array[RadialMenuOption] = []
	for treatment in [
		MedicalEnums.TreatmentType.BANDAGE,
		MedicalEnums.TreatmentType.TOURNIQUET,
		MedicalEnums.TreatmentType.CHEST_SEAL,
		MedicalEnums.TreatmentType.SPLINT,
		MedicalEnums.TreatmentType.MORPHINE,
	]:
		var option := OPTION_SCRIPT.new() as RadialMenuOption
		option.id = str(treatment)
		option.title = _display_name(treatment)
		option.description = "剩余 %d" % int(inventory.get(treatment, 0))
		option.is_enabled = can_start_treatment(treatment)
		option.disabled_reason = "当前目标不适用" if not option.is_enabled else ""
		option.execute = Callable(self, "begin_treatment").bind(treatment)
		options.append(option)
	return options

func can_start_treatment(treatment: int) -> bool:
	if active or not player or not player.is_alive:
		return false
	if int(inventory.get(treatment, 0)) <= 0:
		return false
	var target := _find_target()
	return target != null and _allowed_target(treatment, target) and _find_treatment_part(target, treatment) >= 0

func begin_treatment(treatment: int) -> bool:
	if not can_start_treatment(treatment):
		return false
	active_target = _find_target()
	active_treatment = treatment
	active_time = 0.0
	active = true
	player.acquire_control_lock(BasePlayer.CONTROL_LOCK_MEDICAL)
	if player.weapon_manager:
		player.weapon_manager.release_trigger()
		player.weapon_manager.set_aiming(false)
	treatment_started.emit(active_target, treatment)
	return true

func cancel_treatment() -> void:
	_finish(false)

func get_inventory(treatment: int) -> int:
	return int(inventory.get(treatment, 0))

static func can_treat_self(treatment: int) -> bool:
	return treatment != MedicalEnums.TreatmentType.WOUND_PACKING

func _process(delta: float) -> void:
	if not active:
		return
	if not is_instance_valid(active_target) or not active_target.is_alive or not player.is_alive:
		_finish(false)
		return
	if player.global_position.distance_to(active_target.global_position) > config.max_medical_distance:
		_finish(false)
		return
	active_time += delta
	if active_time < config.treatment_duration:
		return
	var part := _find_treatment_part(active_target, active_treatment)
	var success := part >= 0 and active_target.health_system.apply_treatment(active_treatment, part)
	if success:
		inventory[active_treatment] = int(inventory[active_treatment]) - 1
	_finish(success)

func _finish(success: bool) -> void:
	if not active:
		return
	var target := active_target
	var treatment := active_treatment
	active = false
	active_target = null
	active_treatment = -1
	active_time = 0.0
	if player:
		player.release_control_lock(BasePlayer.CONTROL_LOCK_MEDICAL)
	treatment_finished.emit(target, treatment, success)

func _find_target() -> BasePlayer:
	if not player:
		return null
	var camera := player.get_viewport().get_camera_3d()
	if camera:
		var query := PhysicsRayQueryParameters3D.create(
			camera.global_position,
			camera.global_position - camera.global_basis.z * config.max_medical_distance
		)
		query.exclude = [player]
		var hit := player.get_world_3d().direct_space_state.intersect_ray(query)
		var collider = hit.get("collider")
		while collider and collider is Node and collider != player:
			if collider is BasePlayer:
				return collider as BasePlayer
			collider = collider.get_parent()
	return player

func _allowed_target(treatment: int, target: BasePlayer) -> bool:
	if target == player:
		return can_treat_self(treatment)
	return target.faction == player.faction and player.global_position.distance_to(target.global_position) <= config.max_medical_distance

func _find_treatment_part(target: BasePlayer, treatment: int) -> int:
	if not target or not target.health_system or not target.health_system.vitals:
		return -1
	return target.health_system.get_first_treatable_part(treatment)

func _display_name(treatment: int) -> String:
	match treatment:
		MedicalEnums.TreatmentType.BANDAGE: return "绷带"
		MedicalEnums.TreatmentType.TOURNIQUET: return "止血带"
		MedicalEnums.TreatmentType.CHEST_SEAL: return "胸封"
		MedicalEnums.TreatmentType.SPLINT: return "夹板"
		MedicalEnums.TreatmentType.MORPHINE: return "吗啡"
	return "医疗"

