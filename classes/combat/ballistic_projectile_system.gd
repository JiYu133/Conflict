class_name BallisticProjectileSystem
extends Node

## Shared, allocation-light external-ballistics simulation.
## Projectile origin and direction are supplied by the weapon muzzle only.

const DEFAULT_ENVIRONMENT: BallisticEnvironmentConfig = preload("res://assets/config/ballistics/default_environment.tres")
const ENVIRONMENT_IMPACT_EFFECT = preload("res://classes/combat/environment_impact_effect.gd")
## Legacy constants retained for callers that used the original fixed limits.
const MAX_RANGE_M: float = 2000.0
const MAX_FLIGHT_TIME_S: float = 8.0
const MIN_SPEED_MPS: float = 40.0
const MAX_ACTIVE_BULLETS: int = 256
const HIT_MASK: int = PhysicsLayers.BALLISTIC_TARGETS
const COLLISION_EPSILON_M: float = 0.002
const MAX_RICOCHETS_PER_BULLET: int = 2

static var _instance: BallisticProjectileSystem = null

var _environment: BallisticEnvironmentConfig = DEFAULT_ENVIRONMENT
var _bullets: Array[Dictionary] = []


static func get_or_create(tree: SceneTree) -> BallisticProjectileSystem:
	if is_instance_valid(_instance):
		return _instance
	_instance = BallisticProjectileSystem.new()
	_instance.name = "BallisticProjectileSystem"
	tree.root.add_child(_instance)
	return _instance


func _ready() -> void:
	if not _environment:
		_environment = DEFAULT_ENVIRONMENT
	GlobalLogger.info("Ballistics", "BallisticProjectileSystem ready (gravity=%.5f m/s², density=%.3f kg/m³)" % [
		_environment.gravity_mps2, _environment.get_effective_air_density()
	])


## Replace the runtime environment. Passing null restores standard sea-level data.
func set_environment(config: BallisticEnvironmentConfig) -> void:
	_environment = config if config else DEFAULT_ENVIRONMENT


func get_environment() -> BallisticEnvironmentConfig:
	return _environment


## Public material parsing entry point for map and gameplay code.
static func get_surface_config(collider: Object) -> BallisticSurfaceConfig:
	return BallisticSurfaceConfig.from_collider(collider)


## Alias kept explicit for callers that prefer the word "resolve".
static func resolve_surface_config(collider: Object) -> BallisticSurfaceConfig:
	return get_surface_config(collider)


## Spawn a bullet at the muzzle. The source camera is deliberately not an input.
func spawn(
	origin: Vector3,
	direction: Vector3,
	config: BarrelConfig,
	source: Node,
	exclude: Array[RID],
	world: World3D
) -> void:
	if not config:
		GlobalLogger.warn("Ballistics", "spawn() 缺少 BarrelConfig（未装枪管？），弹丸未生成")
		return
	if not world:
		GlobalLogger.warn("Ballistics", "spawn() without World3D, bullet dropped")
		return
	var muzzle_direction := direction.normalized()
	if muzzle_direction == Vector3.ZERO:
		return
	if _bullets.size() >= MAX_ACTIVE_BULLETS:
		_destroy_bullet_visual(_bullets.pop_front())
		GlobalLogger.warn("Ballistics", "Active bullet cap reached, oldest bullet dropped")

	var launch_direction := _apply_random_spread(muzzle_direction, config)
	var launch_speed := maxf(config.muzzle_velocity, 0.0)
	if config.charge_variation > 0.0:
		launch_speed *= 1.0 + randf_range(-config.charge_variation, config.charge_variation)
	var velocity := launch_direction * launch_speed
	var source_ref: WeakRef = weakref(source) if is_instance_valid(source) else null
	var bullet := {
		"position": origin,
		"velocity": velocity,
		"mass_kg": maxf(config.bullet_mass_g, 0.001) / 1000.0,
		"bc": maxf(config.ballistic_coefficient, 0.0),
		"initial_speed": launch_speed,
		"twist_rate_m": config.rifling_twist_rate_m,
		"drift_axis": _get_drift_axis(launch_direction),
		"rifling_direction": config.rifling_direction,
		"spin_drift_enabled": config.enable_spin_drift,
		"spin_drift_scale": config.spin_drift_scale,
		"source": source_ref,
		"exclude": exclude.duplicate(),
		"world": world,
		"traveled": 0.0,
		"time": 0.0,
		"penetrations_this_frame": 0,
		"ricochet_count": 0,
		"skip_collider": null,
		"skip_until_time": 0.0,
		"tracer": _spawn_tracer(origin, velocity),
	}
	_bullets.append(bullet)


func _physics_process(delta: float) -> void:
	if _bullets.is_empty():
		return
	for i in range(_bullets.size() - 1, -1, -1):
		var bullet := _bullets[i]
		bullet["penetrations_this_frame"] = 0
		var alive := _step_bullet(bullet, maxf(delta, 0.0))
		if not alive:
			_destroy_bullet_visual(bullet)
			_bullets.remove_at(i)


## Advance one frame using enough substeps to satisfy both collision limits.
func _step_bullet(b: Dictionary, delta: float) -> bool:
	var world: World3D = b["world"]
	if not is_instance_valid(world):
		return false
	var remaining := delta
	while remaining > 0.000001:
		var speed: float = (b["velocity"] as Vector3).length()
		if speed < _environment.minimum_effective_speed_mps:
			return false
		var max_dt := maxf(_environment.max_time_step_s, 0.0001)
		var max_distance := maxf(_environment.max_step_distance_m, 0.01)
		var substeps := maxi(1, ceili(maxf(remaining / max_dt, speed * remaining / max_distance)))
		var sub_delta := remaining / float(substeps)
		for _substep in range(substeps):
			if not _integrate_substep(b, sub_delta):
				return false
			if b["traveled"] >= _environment.max_range_m or b["time"] >= _environment.max_flight_time_s:
				return false
		remaining = 0.0
	return true


func _integrate_substep(b: Dictionary, delta: float) -> bool:
	var old_position: Vector3 = b["position"]
	var velocity: Vector3 = b["velocity"]
	var relative_velocity := velocity - _environment.wind_velocity_mps
	var acceleration := Ballistics.drag_acceleration(
		relative_velocity, b["bc"], _environment.get_effective_air_density()
	)
	acceleration += Vector3.DOWN * _environment.gravity_mps2
	acceleration += _spin_drift_acceleration(b)
	velocity += acceleration * delta
	var next_position := old_position + velocity * delta
	var query_exclude: Array[RID] = b["exclude"].duplicate()
	var skipped = b["skip_collider"]
	if is_instance_valid(skipped) and b["time"] < b["skip_until_time"] and skipped is CollisionObject3D:
		query_exclude.append((skipped as CollisionObject3D).get_rid())
	var query := PhysicsRayQueryParameters3D.create(old_position, next_position, HIT_MASK, query_exclude)
	query.collide_with_areas = true
	query.collide_with_bodies = true
	var world: World3D = b["world"]
	var space_state: PhysicsDirectSpaceState3D = world.direct_space_state
	if not space_state:
		return false
	var result: Dictionary = space_state.intersect_ray(query)
	var segment_distance := old_position.distance_to(next_position)
	b["time"] += delta
	b["traveled"] += segment_distance
	if result.is_empty():
		b["velocity"] = velocity
		b["position"] = next_position
		_update_tracer(b)
		return true

	var hit_position: Vector3 = result.get("position", next_position)
	b["velocity"] = velocity
	b["position"] = hit_position
	if not _handle_collision(b, result, velocity):
		return false
	_update_tracer(b)
	return true


func _handle_collision(b: Dictionary, ray_result: Dictionary, velocity: Vector3) -> bool:
	var collider = ray_result.get("collider", null)
	if not collider:
		return false
	var surface := get_surface_config(collider)
	var energy := Ballistics.kinetic_energy(b["mass_kg"], velocity.length())
	var player_node := Projectile.find_player(collider)
	if player_node:
		_apply_player_damage(b, ray_result, velocity, player_node)
		if not surface.penetrable:
			return false

	var required_energy := surface.required_penetration_energy()
	var incoming_direction := velocity.normalized()
	var normal: Vector3 = ray_result.get("normal", Vector3.ZERO).normalized()
	var normal_dot := absf(incoming_direction.dot(normal)) if normal != Vector3.ZERO else 1.0
	var grazing_angle := rad_to_deg(asin(clampf(normal_dot, 0.0, 1.0)))
	var too_shallow := grazing_angle <= surface.ricochet_angle_deg
	var ricochet_count: int = int(b.get("ricochet_count", 0))
	var can_ricochet: bool = too_shallow and surface.hardness >= 0.5 \
		and surface.ricochet_energy_retention > 0.0 \
		and ricochet_count < MAX_RICOCHETS_PER_BULLET
	if not player_node and can_ricochet:
		_spawn_environment_impact(ray_result, incoming_direction, energy, surface, ENVIRONMENT_IMPACT_EFFECT.ImpactKind.RICOCHET)
		return _ricochet(b, ray_result, velocity, surface)
	if not surface.penetrable or energy <= required_energy:
		if not player_node:
			_spawn_environment_impact(ray_result, incoming_direction, energy, surface, ENVIRONMENT_IMPACT_EFFECT.ImpactKind.STOP)
		return false
	if b["penetrations_this_frame"] >= _environment.max_penetrations_per_frame:
		if not player_node:
			_spawn_environment_impact(ray_result, incoming_direction, energy, surface, ENVIRONMENT_IMPACT_EFFECT.ImpactKind.STOP)
		return false

	var retained_energy := maxf(energy - required_energy, 0.0)
	retained_energy *= 1.0 - clampf(surface.energy_loss_factor, 0.0, 1.0)
	if retained_energy <= 0.0:
		if not player_node:
			_spawn_environment_impact(ray_result, incoming_direction, energy, surface, ENVIRONMENT_IMPACT_EFFECT.ImpactKind.STOP)
		return false
	if not player_node:
		_spawn_environment_impact(ray_result, incoming_direction, energy, surface, ENVIRONMENT_IMPACT_EFFECT.ImpactKind.PENETRATION)
	b["velocity"] = incoming_direction * sqrt(2.0 * retained_energy / b["mass_kg"])
	b["penetrations_this_frame"] += 1
	b["skip_collider"] = collider
	b["skip_until_time"] = b["time"] + 0.02
	b["position"] += b["velocity"].normalized() * COLLISION_EPSILON_M
	return b["velocity"].length() >= _environment.minimum_effective_speed_mps


func _ricochet(b: Dictionary, ray_result: Dictionary, velocity: Vector3, surface: BallisticSurfaceConfig) -> bool:
	var normal: Vector3 = ray_result.get("normal", Vector3.ZERO).normalized()
	if normal == Vector3.ZERO:
		return false
	var bounced := velocity.bounce(normal).normalized()
	if bounced == Vector3.ZERO:
		return false
	var energy := Ballistics.kinetic_energy(b["mass_kg"], velocity.length())
	var retained := energy * clampf(surface.ricochet_energy_retention, 0.0, 1.0)
	b["velocity"] = bounced * sqrt(2.0 * retained / b["mass_kg"])
	b["ricochet_count"] += 1
	b["position"] = ray_result.get("position", b["position"]) + bounced * COLLISION_EPSILON_M
	b["skip_collider"] = ray_result.get("collider", null)
	b["skip_until_time"] = b["time"] + 0.02
	return b["velocity"].length() >= _environment.minimum_effective_speed_mps


func _spawn_environment_impact(
	ray_result: Dictionary,
	incoming_direction: Vector3,
	energy_j: float,
	surface: BallisticSurfaceConfig,
	kind: int
) -> void:
	var parent := get_tree().current_scene
	if not parent:
		return
	ENVIRONMENT_IMPACT_EFFECT.spawn(
		parent,
		ray_result.get("position", Vector3.ZERO),
		ray_result.get("normal", -incoming_direction),
		incoming_direction,
		kind,
		energy_j,
		surface.material_name
	)


func _apply_player_damage(b: Dictionary, ray_result: Dictionary, velocity: Vector3, player_node: BasePlayer) -> void:
	if not player_node.has_node("HealthSystem"):
		GlobalLogger.warn("Ballistics", "Hit player has no HealthSystem")
		return
	var source: Node = null
	var source_ref: WeakRef = b["source"]
	if source_ref:
		source = source_ref.get_ref() as Node
	var energy := Ballistics.kinetic_energy(b["mass_kg"], velocity.length())
	var info := HitResolver.resolve(
		ray_result, energy, MedicalEnums.DamageType.BULLET, source, velocity.normalized()
	)
	info.impact_velocity = velocity.length()
	info.impact_mass_kg = b["mass_kg"]
	info.is_penetrating = b["penetrations_this_frame"] > 0
	(player_node.get_node("HealthSystem") as HealthSystem).apply_damage(info)
	GlobalLogger.debug("Ballistics", "Bullet hit at %.1fm: %.0f m/s → %.0f J" % [
		b["traveled"], velocity.length(), energy
	])


func _spin_drift_acceleration(b: Dictionary) -> Vector3:
	if not b["spin_drift_enabled"] or b["rifling_direction"] == 0:
		return Vector3.ZERO
	var twist_rate := maxf(b.get("twist_rate_m", 0.195), 0.0001)
	var initial_speed: float = b["initial_speed"]
	if initial_speed <= 0.0:
		return Vector3.ZERO
	var time_factor := minf(b["time"], 1.0)
	var speed_factor := clampf((b["velocity"] as Vector3).length() / initial_speed, 0.0, 1.0)
	return Ballistics.spin_drift_acceleration(
		b["drift_axis"], initial_speed, time_factor, twist_rate,
		b["rifling_direction"], b["spin_drift_scale"], speed_factor
	)


func _get_drift_axis(direction: Vector3) -> Vector3:
	var axis := direction.cross(Vector3.UP)
	if axis.length_squared() < 0.000001:
		axis = direction.cross(Vector3.RIGHT)
	return axis.normalized()


func _apply_random_spread(direction: Vector3, config: BarrelConfig) -> Vector3:
	if not config.enable_ballistic_random_spread or config.ballistic_spread_moa <= 0.0:
		return direction
	var right := _get_drift_axis(direction)
	var up := right.cross(direction).normalized()
	var cone_angle := deg_to_rad(config.ballistic_spread_moa / 60.0) * randf()
	var rotation := randf() * TAU
	return (direction + right * cos(rotation) * cone_angle + up * sin(rotation) * cone_angle).normalized()


func _spawn_tracer(origin: Vector3, velocity: Vector3) -> Node3D:
	if not _environment.tracer_scene:
		return null
	var instance := _environment.tracer_scene.instantiate()
	if not instance is Node3D:
		if instance:
			instance.queue_free()
		return null
	add_child(instance)
	var tracer := instance as Node3D
	tracer.global_position = origin
	if velocity.length_squared() > 0.000001:
		_orient_tracer(tracer, origin, velocity)
	return tracer


func _update_tracer(b: Dictionary) -> void:
	var tracer: Node3D = b["tracer"]
	if not is_instance_valid(tracer):
		return
	tracer.global_position = b["position"]
	var velocity: Vector3 = b["velocity"]
	if velocity.length_squared() > 0.000001:
		_orient_tracer(tracer, tracer.global_position, velocity)


func _orient_tracer(tracer: Node3D, origin: Vector3, velocity: Vector3) -> void:
	var up := Vector3.UP
	if absf(velocity.normalized().dot(up)) > 0.98:
		up = Vector3.FORWARD
	tracer.look_at(origin + velocity.normalized(), up)


func _destroy_bullet_visual(b: Dictionary) -> void:
	var tracer: Node3D = b.get("tracer", null)
	if is_instance_valid(tracer):
		tracer.queue_free()


func get_active_bullet_count() -> int:
	return _bullets.size()
