class_name AIPlayerBrain
extends Node

## Senses and motor layer of one AIPlayer. The LimboAI behaviour tree decides
## *what* to do; this node only knows *how*: perception, navigation, weapon
## handling and squad information. It holds no decision state of its own.
##
## Behaviour tree tasks (classes/bot/limbo/tasks) reach it through the agent's
## "ai_player_brain" metadata, see AIBT.brain_of(). Every tick the tree's
## SenseEnvironment task calls update_perception() + write_blackboard(), so the
## rest of the tree only reads blackboard variables (see BLACKBOARD VARIABLES).

const DEFAULT_BEHAVIOR_TREE_PATH := "res://assets/config/ai/trees/ai_default_behavior_tree.tres"
# Heights above the BasePlayer origin, which is the capsule centre (~0.9 m above
# the floor when standing), measured from the head / upper torso hitboxes.
const EYE_HEIGHT := 0.6
const CHEST_HEIGHT := 0.3

## BLACKBOARD VARIABLES written by write_blackboard():
##   target: BasePlayer               current enemy (null when none)
##   has_target / target_visible / target_in_range / target_reacted: bool
##   has_enemy_memory: bool           a target or a fresh squad report exists
##   target_position / last_known_enemy_position: Vector3
##   objective_position / extraction_position / rally_position: Vector3
##   at_objective / at_extraction / retreat_order / is_suppressing: bool
##   has_command / command_ignores_enemies: bool
##   weapon_malfunction / needs_reload / is_incapacitated: bool

var bot: BasePlayer
var ai_config: AIConfig
var squad: AISquadCommander
var navigation: AINavigationService
var default_profile: AIProfile
var combat_profile: AIProfile
var suppress_profile: AIProfile
var retreat_profile: AIProfile
var bt_player: BTPlayer
var target: BasePlayer
var target_acquired_time := -INF
## Aim provider of the running AimAtTarget task, notified by FireAtTarget.
var active_aim: AIAimProvider
## Name of the behaviour tree action that last started; debug display only.
var activity := "idle"

var _target_visible := false
var _sight_timer := 0.0
var _encounter_controller: WeakRef
var _own_collider_rids: Array[RID] = []


func initialize(new_bot: BasePlayer, new_squad: AISquadCommander, nav: AINavigationService, config: AIConfig = null) -> void:
	bot = new_bot
	squad = new_squad
	navigation = nav
	_load_config(config)
	_create_behavior_tree()


func apply_profile(profile: AIProfile) -> void:
	if not profile:
		return
	default_profile = profile.sanitized()
	combat_profile = default_profile
	suppress_profile = default_profile
	retreat_profile = default_profile


## Replaces the runtime decision package without recreating the AIPlayer.
## Character visuals and equipped weapons are spawn-time concerns, so they are
## intentionally left untouched while behavior profiles and LimboAI are swapped.
func apply_config(config: AIConfig) -> void:
	if not config or not bot or not is_instance_valid(bot):
		return
	stop()
	release_weapon()
	if bt_player and is_instance_valid(bt_player):
		bt_player.set_active(false)
		bt_player.queue_free()
	bt_player = null
	_load_config(config)
	_create_behavior_tree()


func shutdown() -> void:
	stop()
	release_weapon()
	if bt_player and is_instance_valid(bt_player):
		bt_player.set_active(false)


func set_ai_active(active: bool) -> void:
	if bt_player and is_instance_valid(bt_player):
		bt_player.set_active(active)


func get_profile(context: StringName) -> AIProfile:
	match context:
		&"combat":
			return combat_profile
		&"suppress":
			return suppress_profile
		&"retreat":
			return retreat_profile
	return default_profile


func get_state_name() -> String:
	return activity


func _load_config(config: AIConfig) -> void:
	ai_config = config
	default_profile = config.get_profile("calm") if config else null
	if not default_profile:
		default_profile = AIProfile.new()
	combat_profile = config.get_profile("combat") if config else null
	if not combat_profile:
		combat_profile = default_profile
	suppress_profile = config.get_profile("suppress") if config else null
	if not suppress_profile:
		suppress_profile = combat_profile
	retreat_profile = config.get_profile("retreat") if config else null
	if not retreat_profile:
		retreat_profile = default_profile
	default_profile = default_profile.sanitized()
	combat_profile = combat_profile.sanitized()
	suppress_profile = suppress_profile.sanitized()
	retreat_profile = retreat_profile.sanitized()


func _create_behavior_tree() -> void:
	if not bot or not is_instance_valid(bot):
		return
	bot.set_meta("ai_player_brain", self)
	bt_player = BTPlayer.new()
	bt_player.name = "LimboBTPlayer"
	bt_player.agent_node = NodePath("..")
	bt_player.update_mode = BTPlayer.PHYSICS
	# Runtime-spawned players have no owner; without a hint LimboAI refuses to
	# instantiate the tree ("Failed to detect scene root").
	bt_player.set_scene_root_hint(bot)
	if ai_config and ai_config.behavior_tree:
		bt_player.behavior_tree = ai_config.behavior_tree
	else:
		bt_player.behavior_tree = load(DEFAULT_BEHAVIOR_TREE_PATH) as BehaviorTree
	bot.add_child(bt_player)


# --- Perception ---------------------------------------------------------------

## Refreshes target selection and visibility. Called once per tick by the
## SenseEnvironment task; full scans are throttled by sight_check_interval.
func update_perception(delta: float) -> void:
	if not bot or not is_instance_valid(bot) or not bot.is_alive:
		_target_visible = false
		return
	var now := _now()
	if target and (not is_instance_valid(target) or not target.is_alive):
		target = null
	_sight_timer -= delta
	if _sight_timer <= 0.0:
		_scan_for_enemy(now)
		_sight_timer = combat_profile.sight_check_interval
	if not target and squad:
		var reported := squad.blackboard.enemy_actor
		if is_instance_valid(reported) and reported.is_alive \
				and squad.blackboard.has_fresh_enemy(now, combat_profile.target_memory_time):
			target = reported
			target_acquired_time = now
	_target_visible = target != null and can_see(target)


func write_blackboard(blackboard: Blackboard) -> void:
	var now := _now()
	var has_target := target != null and is_instance_valid(target)
	var info := squad.blackboard if squad else null
	var objective := squad.objective_position if squad else bot.global_position
	var extraction := squad.extraction_position if squad else bot.global_position
	var target_position := target.global_position if has_target else (info.enemy_position if info else Vector3.ZERO)
	var rally := info.rally_position if info and info.rally_position != Vector3.ZERO else extraction
	var command := info.squad_command if info else AIBlackboard.SquadCommand.NONE

	blackboard.set_var(&"target", target if has_target else null)
	blackboard.set_var(&"has_target", has_target)
	blackboard.set_var(&"target_visible", has_target and _target_visible)
	blackboard.set_var(&"target_in_range", has_target and bot.global_position.distance_to(target_position) <= combat_profile.weapon_distance)
	blackboard.set_var(&"target_reacted", has_target and now - target_acquired_time >= combat_profile.reaction_time)
	blackboard.set_var(&"has_enemy_memory", has_target or (info != null and info.has_fresh_enemy(now, combat_profile.target_memory_time)))
	blackboard.set_var(&"target_position", target_position)
	blackboard.set_var(&"last_known_enemy_position", info.last_visible_enemy_position if info else target_position)
	blackboard.set_var(&"objective_position", objective)
	blackboard.set_var(&"extraction_position", extraction)
	blackboard.set_var(&"rally_position", rally)
	blackboard.set_var(&"at_objective", bot.global_position.distance_to(objective) <= _objective_arrival_distance(default_profile))
	blackboard.set_var(&"at_extraction", bot.global_position.distance_to(extraction) <= retreat_profile.arrival_distance)
	blackboard.set_var(&"retreat_order", info != null and info.retreat_order)
	blackboard.set_var(&"is_suppressing", squad != null and squad.is_covering(bot))
	blackboard.set_var(&"has_command", command != AIBlackboard.SquadCommand.NONE)
	blackboard.set_var(&"command_ignores_enemies", command in [AIBlackboard.SquadCommand.FALL_BACK, AIBlackboard.SquadCommand.MOVE_TO_OBJECTIVE])
	blackboard.set_var(&"weapon_malfunction", weapon_has_malfunction())
	blackboard.set_var(&"needs_reload", weapon_needs_reload())
	blackboard.set_var(&"is_incapacitated", is_incapacitated())


## Drops the current target and the squad's report, ending a search.
func forget_enemy() -> void:
	target = null
	_target_visible = false
	if squad:
		squad.blackboard.enemy_confidence = 0.0


func can_see(actor: BasePlayer) -> bool:
	var world := bot.get_world_3d()
	if not world or not actor:
		return false
	var query := PhysicsRayQueryParameters3D.create(get_eye_position(), get_target_aim_point(actor), 3)
	# The eye sits inside the bot's own ragdoll bones and weapon. Any own collider
	# the ray meets is remembered and skipped from then on.
	for attempt in 4:
		query.exclude = _get_visibility_exclusions()
		var hit := world.direct_space_state.intersect_ray(query)
		if hit.is_empty():
			return true
		var collider: Object = hit.get("collider", null)
		if _belongs_to_actor(collider, actor):
			return true
		if not _belongs_to_actor(collider, bot):
			return false
		_own_collider_rids.append(hit.get("rid"))
	return false


func within_fov(actor: BasePlayer) -> bool:
	var direction := actor.global_position - bot.global_position
	direction.y = 0.0
	if direction.length_squared() < 0.01:
		return true
	return rad_to_deg(acos(clampf((-bot.global_basis.z).dot(direction.normalized()), -1.0, 1.0))) <= combat_profile.field_of_view_degrees * 0.5


func get_eye_position() -> Vector3:
	return bot.global_position + Vector3.UP * EYE_HEIGHT


## Default point to aim at on an actor (upper chest).
func get_target_aim_point(actor: BasePlayer) -> Vector3:
	return actor.global_position + Vector3.UP * CHEST_HEIGHT


func _scan_for_enemy(now: float) -> void:
	var best: BasePlayer
	var best_distance := combat_profile.perception_distance
	for actor in _get_known_actors():
		if actor == bot or not actor.is_alive or actor.faction == bot.faction:
			continue
		var distance := bot.global_position.distance_to(actor.global_position)
		if distance > best_distance or not within_fov(actor):
			continue
		if not can_see(actor):
			continue
		best = actor
		best_distance = distance
	if best:
		if target != best:
			target_acquired_time = now
		target = best
		if squad:
			squad.blackboard.publish_enemy_spotted(bot, best, best.global_position, 1.0, now)
	elif target and squad and not can_see(target):
		squad.blackboard.publish_enemy_lost(bot, target.global_position, now)


## Encounter actors when an EncounterController exists, otherwise everyone the
## AIPlayerManager knows about (sandbox maps such as TestMap).
func _get_known_actors() -> Array[BasePlayer]:
	var result: Array[BasePlayer] = []
	var controller := _find_encounter_controller()
	if controller:
		for actor in controller.get_actors():
			if actor is BasePlayer:
				result.append(actor as BasePlayer)
		return result
	var manager := bot.get_parent() as AIPlayerManager
	if manager:
		result.append_array(manager.get_ai_players())
		var player := manager.get_player()
		if player:
			result.append(player)
	return result


func _find_encounter_controller() -> Node:
	var cached: Node = _encounter_controller.get_ref() if _encounter_controller else null
	if is_instance_valid(cached):
		return cached
	var scene := get_tree().current_scene
	var found := scene.find_child("EncounterController", true, false) if scene else null
	if found and found.has_method("get_actors"):
		_encounter_controller = weakref(found)
		return found
	return null


func _get_visibility_exclusions() -> Array[RID]:
	var exclusions: Array[RID] = [bot.get_rid()]
	exclusions.append_array(_own_collider_rids)
	if bot.health_system:
		exclusions.append_array(bot.health_system.get_hitbox_rids())
	return exclusions


func _belongs_to_actor(candidate: Object, actor: BasePlayer) -> bool:
	var node := candidate as Node
	while node:
		if node == actor:
			return true
		node = node.get_parent()
	return false


# --- Movement and view --------------------------------------------------------

## Walks toward destination through the player's own locomotion. run/sprint are
## requests, honoured only when the profile allows them. Returns true on arrival.
func move_to(destination: Vector3, profile: AIProfile, delta: float, run := false, sprint := false) -> bool:
	if bot.global_position.distance_to(destination) <= profile.arrival_distance:
		stop()
		return true
	var direction := navigation.get_direction(bot, destination, delta, profile.replan_interval) if navigation else (destination - bot.global_position).normalized()
	if direction == Vector3.ZERO:
		stop()
		return true
	bot.set_ai_input(direction, run and profile.run_to_objective, sprint and profile.sprint_when_retreating)
	# Navigation commands a level heading; terrain height must not pitch the weapon.
	face(bot.global_position + Vector3(direction.x, 0.0, direction.z))
	return false


func stop() -> void:
	bot.clear_ai_input()


func face(position: Vector3) -> void:
	bot.set_ai_aim_direction(position - bot.global_position)


## Points body yaw and view pitch along a world direction. Aim providers use this.
func aim_at_direction(direction: Vector3) -> bool:
	return bot.set_ai_aim_direction(direction)


## The direction the AI is currently commanding (body yaw + view pitch).
func get_aim_direction() -> Vector3:
	var pitch := bot.camera_controller.get_vertical_angle() if bot.camera_controller else 0.0
	return -bot.global_basis.z * cos(pitch) + Vector3.UP * sin(pitch)


## Where the equipped weapon's bore starts, or the eye when unarmed.
func get_muzzle_position() -> Vector3:
	var weapon := bot.weapon_manager.current_weapon if bot.weapon_manager else null
	return weapon._get_muzzle_position() if weapon else get_eye_position()


## Where the equipped weapon's bore actually points after the pose chain, or
## Vector3.ZERO when unarmed. Can differ from get_aim_direction().
func get_muzzle_direction() -> Vector3:
	var weapon := bot.weapon_manager.current_weapon if bot.weapon_manager else null
	return weapon._get_muzzle_direction() if weapon else Vector3.ZERO


func set_stance(crouching: bool) -> void:
	bot.set_ai_stance(crouching)


# --- Weapon -------------------------------------------------------------------
# AIPlayer only supplies the same trigger/aim input as a player. The equipped
# weapon keeps its authored fire mode, cadence, ammo and malfunction behaviour;
# AI never creates bullets or applies damage.

func pull_trigger() -> void:
	if not bot.weapon_manager:
		return
	bot.set_ai_fire_input(false)
	bot.weapon_manager.set_aiming(true)
	bot.set_ai_fire_input(true)


func release_trigger() -> void:
	if bot.weapon_manager:
		bot.set_ai_fire_input(false)


func release_weapon() -> void:
	if bot.weapon_manager:
		bot.set_ai_fire_input(false)
		bot.weapon_manager.set_aiming(false)


func reload_weapon() -> void:
	var weapon := bot.weapon_manager.current_weapon if bot.weapon_manager else null
	if weapon and not weapon.is_reloading:
		bot.weapon_manager.reload()


func clear_malfunction() -> void:
	if bot.weapon_manager:
		bot.weapon_manager.attempt_malfunction_clearance()


func weapon_needs_reload() -> bool:
	var weapon := bot.weapon_manager.current_weapon if bot.weapon_manager else null
	if not weapon:
		return false
	var total := weapon.get_current_magazine_count() + weapon.get_reserve_ammo_count()
	var capacity := maxi(weapon.ammo_component.get_capacity(), 1) if weapon.ammo_component else 1
	return not weapon.has_chambered_round() and total <= 0 or weapon.get_current_magazine_count() <= int(float(capacity) * combat_profile.minimum_ammo_ratio) and weapon.get_reserve_ammo_count() > 0


func weapon_has_malfunction() -> bool:
	var weapon := bot.weapon_manager.current_weapon if bot.weapon_manager else null
	return weapon != null and weapon.malfunction_component != null and weapon.malfunction_component.has_malfunction()


# --- Health -------------------------------------------------------------------

## Dead or unconscious. Projected from HealthSystem, never decided by the AI.
func is_incapacitated() -> bool:
	if not bot.is_alive:
		return true
	return bot.health_system != null and bot.health_system.get_state() == MedicalEnums.HealthState.UNCONSCIOUS


func _objective_arrival_distance(profile: AIProfile) -> float:
	# Aggressive units keep pushing deeper into the objective area before
	# switching to patrol.
	return maxf(profile.arrival_distance, profile.return_to_objective_distance * lerpf(1.0, 0.55, profile.aggression))


func _now() -> float:
	return Time.get_ticks_msec() / 1000.0
