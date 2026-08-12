class_name AIPlayerBrain
extends Node

enum State { IDLE, MOVE_TO_OBJECTIVE, PATROL_OBJECTIVE, SEARCH, ENGAGE, SUPPRESS, TAKE_COVER, MOVE_UNDER_COVER, RESCUE, RETREAT, HOLD_EXTRACTION, RELOAD, CLEAR_MALFUNCTION, DOWNED, DEAD }

const LIMBO_TICK_SCRIPT := preload("res://classes/bot/limbo/limbo_bot_tick.gd")

var bot: BasePlayer
var ai_config: AIConfig
var squad: AISquadCommander
var navigation: AINavigationService
var default_profile: AIProfile
var combat_profile: AIProfile
var suppress_profile: AIProfile
var retreat_profile: AIProfile
var state: State = State.IDLE
var state_time := 0.0
var fire_time := 0.0
var trigger_release_time := 0.0
var sight_time := 0.0
var search_time := 0.0
var target_acquired_time := -INF
var target: BasePlayer
var bt_player: BTPlayer


func initialize(new_bot: BasePlayer, new_squad: AISquadCommander, nav: AINavigationService, config: AIConfig = null) -> void:
	bot = new_bot
	ai_config = config
	squad = new_squad
	navigation = nav
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
	_create_behavior_tree()
	_change_state(State.IDLE)


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
	_stop()
	_release_weapon()
	if bt_player and is_instance_valid(bt_player):
		bt_player.set_active(false)
		bt_player.queue_free()
	bt_player = null
	ai_config = config
	default_profile = config.get_profile("calm")
	if not default_profile:
		default_profile = AIProfile.new()
	combat_profile = config.get_profile("combat")
	if not combat_profile:
		combat_profile = default_profile
	suppress_profile = config.get_profile("suppress")
	if not suppress_profile:
		suppress_profile = combat_profile
	retreat_profile = config.get_profile("retreat")
	if not retreat_profile:
		retreat_profile = default_profile
	default_profile = default_profile.sanitized()
	combat_profile = combat_profile.sanitized()
	suppress_profile = suppress_profile.sanitized()
	retreat_profile = retreat_profile.sanitized()
	_create_behavior_tree()
	_change_state(State.IDLE)


func shutdown() -> void:
	_stop()
	_release_weapon()
	if bt_player and is_instance_valid(bt_player):
		bt_player.set_active(false)


func set_ai_active(active: bool) -> void:
	if bt_player and is_instance_valid(bt_player):
		bt_player.set_active(active)


func _create_behavior_tree() -> void:
	if not bot or not is_instance_valid(bot):
		return
	bot.set_meta("ai_player_brain", self)
	# Compatibility for old custom tasks that still query this metadata key.
	bt_player = BTPlayer.new()
	bt_player.name = "LimboBTPlayer"
	bt_player.agent_node = NodePath("..")
	bt_player.update_mode = BTPlayer.PHYSICS
	if ai_config and ai_config.behavior_tree:
		bt_player.behavior_tree = ai_config.behavior_tree
	else:
		var tree := BehaviorTree.new()
		var root := LIMBO_TICK_SCRIPT.new() as BTAction
		tree.set_root_task(root)
		bt_player.behavior_tree = tree
	bot.add_child(bt_player)


## Called by the LimboAI behavior tree. The tactical domain remains here so
## existing weapon, health, navigation and squad contracts stay authoritative.
func tick_ai(delta: float) -> void:
	if not bot or not is_instance_valid(bot):
		return
	if state == State.DEAD:
		return
	state_time += delta
	fire_time = maxf(fire_time - delta, 0.0)
	trigger_release_time = maxf(trigger_release_time - delta, 0.0)
	if is_zero_approx(trigger_release_time) and bot.weapon_manager:
		bot.set_ai_fire_input(false)
	sight_time = maxf(sight_time - delta, 0.0)
	if not bot.is_alive:
		_change_state(State.DEAD)
		return
	if _is_downed():
		_change_state(State.DOWNED)
		return
	var now := Time.get_ticks_msec() / 1000.0
	if squad.blackboard.retreat_order:
		_change_state(State.HOLD_EXTRACTION if _at_extraction() else State.RETREAT)
		_tick_state(delta, retreat_profile, now)
		return
	if state in [State.DEAD, State.DOWNED, State.RELOAD, State.CLEAR_MALFUNCTION]:
		_tick_state(delta, _profile_for_state(), now)
		return
	if sight_time <= 0.0:
		_scan_for_enemy(now)
		sight_time = combat_profile.sight_check_interval
	if target and not is_instance_valid(target):
		target = null
	if not target and is_instance_valid(squad.blackboard.enemy_actor) and squad.blackboard.has_fresh_enemy(now, combat_profile.target_memory_time):
		target = squad.blackboard.enemy_actor
		target_acquired_time = now
	if _weapon_has_malfunction():
		_change_state(State.CLEAR_MALFUNCTION)
	elif _weapon_needs_reload():
		_change_state(State.RELOAD)
	elif squad.blackboard.squad_command != AIBlackboard.SquadCommand.NONE:
		_tick_player_command(delta, now)
		return
	elif target and now - target_acquired_time < combat_profile.reaction_time:
		_stop()
		_face(target.global_position)
	elif target and _can_see(target) and bot.global_position.distance_to(target.global_position) <= combat_profile.weapon_distance:
		_change_state(State.SUPPRESS if squad.is_covering(bot) else State.ENGAGE)
	elif target or squad.blackboard.has_fresh_enemy(now, combat_profile.target_memory_time):
		_change_state(State.SEARCH)
	elif bot.global_position.distance_to(squad.objective_position) > _objective_arrival_distance(default_profile):
		_change_state(State.MOVE_TO_OBJECTIVE)
	else:
		_change_state(State.PATROL_OBJECTIVE)
	_tick_state(delta, _profile_for_state(), now)


func _tick_player_command(delta: float, now: float) -> void:
	var command := squad.blackboard.squad_command
	var source := squad.blackboard.command_source
	var can_engage := target and _can_see(target) and bot.global_position.distance_to(target.global_position) <= combat_profile.weapon_distance
	if can_engage and command in [AIBlackboard.SquadCommand.ADVANCE, AIBlackboard.SquadCommand.ATTACK, AIBlackboard.SquadCommand.HOLD, AIBlackboard.SquadCommand.FOLLOW_PLAYER]:
		_change_state(State.SUPPRESS if squad.is_covering(bot) else State.ENGAGE)
		_tick_state(delta, _profile_for_state(), now)
		return
	match command:
		AIBlackboard.SquadCommand.FOLLOW_PLAYER:
			if source and is_instance_valid(source):
				_move_to(source.global_position, default_profile, delta)
			else:
				_move_to(squad.objective_position, default_profile, delta)
		AIBlackboard.SquadCommand.MOVE_TO_OBJECTIVE:
			_move_to(squad.objective_position, default_profile, delta)
		AIBlackboard.SquadCommand.ADVANCE, AIBlackboard.SquadCommand.ATTACK:
			_move_to(squad.blackboard.command_position, combat_profile, delta)
		AIBlackboard.SquadCommand.HOLD:
			_stop()
			if target:
				_face(target.global_position)
		AIBlackboard.SquadCommand.FALL_BACK:
			if source and is_instance_valid(source):
				_move_to(source.global_position, retreat_profile, delta)
			else:
				_move_to(squad.extraction_position, retreat_profile, delta)


func _tick_state(delta: float, profile: AIProfile, now: float) -> void:
	match state:
		State.IDLE:
			_stop()
		State.MOVE_TO_OBJECTIVE:
			_move_to(squad.objective_position, profile, delta)
		State.PATROL_OBJECTIVE:
			_stop()
		State.SEARCH:
			search_time += delta
			var position := squad.blackboard.last_visible_enemy_position
			_move_to(position, profile, delta)
			if search_time >= profile.search_duration:
				target = null
				search_time = 0.0
				squad.blackboard.enemy_confidence = 0.0
		State.ENGAGE, State.SUPPRESS:
			_engage(profile, now)
		State.TAKE_COVER, State.MOVE_UNDER_COVER:
			_move_to(squad.blackboard.last_visible_enemy_position, profile, delta)
		State.RETREAT:
			_release_weapon()
			_move_to(squad.blackboard.rally_position if squad.blackboard.rally_position != Vector3.ZERO else squad.extraction_position, profile, delta)
		State.HOLD_EXTRACTION:
			_stop()
			_face(squad.blackboard.last_visible_enemy_position)
		State.RELOAD:
			_stop()
			_release_weapon()
			if bot.weapon_manager and bot.weapon_manager.current_weapon and not bot.weapon_manager.current_weapon.is_reloading:
				bot.weapon_manager.reload()
			if not _weapon_needs_reload():
				_change_state(State.ENGAGE if target else State.MOVE_TO_OBJECTIVE)
		State.CLEAR_MALFUNCTION:
			_stop()
			_release_weapon()
			if bot.weapon_manager:
				bot.weapon_manager.attempt_malfunction_clearance()
			if not _weapon_has_malfunction():
				_change_state(State.ENGAGE if target else State.MOVE_TO_OBJECTIVE)
		State.DOWNED, State.DEAD:
			_stop()
			_release_weapon()


func _scan_for_enemy(now: float) -> void:
	var best: BasePlayer
	var best_distance := combat_profile.perception_distance
	for actor in _get_known_actors():
		if actor == bot or not actor.is_alive or actor.faction == bot.faction:
			continue
		var distance := bot.global_position.distance_to(actor.global_position)
		if distance > best_distance or not _within_fov(actor):
			continue
		if not _can_see(actor):
			continue
		best = actor
		best_distance = distance
	if best:
		if target != best:
			target_acquired_time = now
		target = best
		squad.blackboard.publish_enemy_spotted(bot, best, best.global_position, 1.0, now)
		search_time = 0.0
	elif target and not _can_see(target):
		squad.blackboard.publish_enemy_lost(bot, target.global_position, now)


func _engage(profile: AIProfile, _now: float) -> void:
	var enemy_position := target.global_position if target and is_instance_valid(target) else squad.blackboard.enemy_position
	if enemy_position == Vector3.ZERO:
		return
	_face(enemy_position)
	if state == State.ENGAGE and bot.global_position.distance_to(enemy_position) > profile.weapon_distance:
		_move_to(enemy_position, profile, get_physics_process_delta_time())
		return
	if not _can_fire_at(enemy_position):
		_release_weapon()
		return
	if fire_time > 0.0:
		return
	if bot.weapon_manager:
		# AIPlayer only supplies the same trigger/aim input as a player. The
		# equipped weapon keeps its authored fire mode, cadence, ammo and
		# malfunction behaviour; AI never creates or applies bullet damage.
		bot.set_ai_fire_input(false)
		bot.weapon_manager.set_aiming(true)
		_apply_aim_error(profile)
		bot.set_ai_fire_input(true)
		fire_time = profile.fire_interval
		trigger_release_time = minf(profile.fire_interval * 0.8, maxf(0.08, float(profile.burst_length) * 0.1))


func _move_to(destination: Vector3, profile: AIProfile, delta: float) -> void:
	if bot.global_position.distance_to(destination) <= profile.arrival_distance:
		_stop()
		return
	var direction := navigation.get_direction(bot, destination, delta, profile.replan_interval) if navigation else (destination - bot.global_position).normalized()
	if direction == Vector3.ZERO:
		_stop()
		return
	var running := profile.run_to_objective and state in [State.MOVE_TO_OBJECTIVE, State.MOVE_UNDER_COVER, State.RETREAT]
	var sprinting := profile.sprint_when_retreating and state == State.RETREAT
	bot.set_ai_input(direction, running, sprinting)
	_face(bot.global_position + direction)


func _face(position: Vector3) -> void:
	var flat := Vector3(position.x, bot.global_position.y, position.z)
	if flat.distance_to(bot.global_position) > 0.05:
		bot.look_at(flat, Vector3.UP)


func _stop() -> void:
	bot.clear_ai_input()


func _release_weapon() -> void:
	if bot.weapon_manager:
		bot.set_ai_fire_input(false)
		bot.weapon_manager.set_aiming(false)


func _can_see(actor: BasePlayer) -> bool:
	var world := bot.get_world_3d()
	if not world or not actor:
		return false
	var origin := bot.global_position + Vector3.UP * 1.4
	var target_position := actor.global_position + Vector3.UP * 1.2
	var query := PhysicsRayQueryParameters3D.create(origin, target_position, 3)
	query.exclude = _get_visibility_exclusions()
	var hit := world.direct_space_state.intersect_ray(query)
	if hit.is_empty():
		return true
	return _belongs_to_actor(hit.get("collider", null), actor)


func _get_visibility_exclusions() -> Array[RID]:
	var exclusions: Array[RID] = [bot.get_rid()]
	if bot.health_system:
		exclusions.append_array(bot.health_system.get_hitbox_rids())
	return exclusions


func _belongs_to_actor(candidate: Object, actor: BasePlayer) -> bool:
	if candidate == actor:
		return true
	var node := candidate as Node
	while node:
		if node == actor:
			return true
		node = node.get_parent()
	return false


func _can_fire_at(position: Vector3) -> bool:
	if target and target.faction == bot.faction:
		return false
	return _can_see(target) if target else position != Vector3.ZERO


func _within_fov(actor: BasePlayer) -> bool:
	var direction := actor.global_position - bot.global_position
	direction.y = 0.0
	if direction.length_squared() < 0.01:
		return true
	return rad_to_deg(acos(clampf((-bot.global_basis.z).dot(direction.normalized()), -1.0, 1.0))) <= combat_profile.field_of_view_degrees * 0.5


func _apply_aim_error(profile: AIProfile) -> void:
	if profile.aim_error_degrees <= 0.0:
		return
	# The weapon remains authoritative for projectile creation and damage. This
	# only changes the AIPlayer's commanded aim by a configurable small yaw error.
	bot.rotate_y(deg_to_rad(randf_range(-profile.aim_error_degrees, profile.aim_error_degrees)))


func _get_known_actors() -> Array[BasePlayer]:
	var result: Array[BasePlayer] = []
	var controller := get_tree().current_scene.find_child("EncounterController", true, false) if get_tree().current_scene else null
	if controller and controller.has_method("get_actors"):
		for actor in controller.get_actors():
			if actor is BasePlayer:
				result.append(actor as BasePlayer)
	return result


func _weapon_needs_reload() -> bool:
	var weapon := bot.weapon_manager.current_weapon if bot.weapon_manager else null
	if not weapon:
		return false
	var total := weapon.get_current_magazine_count() + weapon.get_reserve_ammo_count()
	var capacity := maxi(weapon.ammo_component.get_capacity(), 1) if weapon.ammo_component else 1
	return not weapon.has_chambered_round() and total <= 0 or weapon.get_current_magazine_count() <= int(float(capacity) * combat_profile.minimum_ammo_ratio) and weapon.get_reserve_ammo_count() > 0


func _weapon_has_malfunction() -> bool:
	var weapon := bot.weapon_manager.current_weapon if bot.weapon_manager else null
	return weapon != null and weapon.malfunction_component != null and weapon.malfunction_component.has_malfunction()


func _is_downed() -> bool:
	return bot.health_system != null and bot.health_system.get_state() == MedicalEnums.HealthState.UNCONSCIOUS


func _at_extraction() -> bool:
	return bot.global_position.distance_to(squad.extraction_position) <= retreat_profile.arrival_distance


func _objective_arrival_distance(profile: AIProfile) -> float:
	# Aggressive units keep pushing deeper into the objective area before
	# switching to patrol.
	return maxf(profile.arrival_distance, profile.return_to_objective_distance * lerpf(1.0, 0.55, profile.aggression))


func _profile_for_state() -> AIProfile:
	match state:
		State.RETREAT, State.HOLD_EXTRACTION:
			return retreat_profile
		State.SUPPRESS:
			return suppress_profile
		State.ENGAGE, State.SEARCH:
			return combat_profile
	return default_profile


func _change_state(next_state: State) -> void:
	if state == next_state:
		return
	_exit_state(state)
	state = next_state
	state_time = 0.0
	_enter_state(next_state)


func _enter_state(next_state: State) -> void:
	if bot:
		var profile := _profile_for_state()
		var crouching := profile.crouch_in_combat and next_state in [State.ENGAGE, State.SUPPRESS]
		crouching = crouching or profile.crouch_while_holding and next_state in [State.PATROL_OBJECTIVE, State.HOLD_EXTRACTION]
		bot.set_ai_stance(crouching)
	if next_state == State.SEARCH:
		search_time = 0.0
	if next_state == State.RETREAT or next_state == State.DOWNED or next_state == State.DEAD:
		_release_weapon()


func _exit_state(previous_state: State) -> void:
	if previous_state == State.ENGAGE or previous_state == State.SUPPRESS or previous_state == State.RELOAD or previous_state == State.CLEAR_MALFUNCTION:
		_release_weapon()


func get_state_name() -> String:
	return State.keys()[state]
