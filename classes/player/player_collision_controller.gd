class_name PlayerCollisionController
extends Node

## Sole owner of the CharacterBody3D environment capsule.
##
## This component knows only its body, configuration, and a value-only AABB
## provider. It does not know StanceController, PlayerModelManager,
## HealthSystem, BodyHitbox, or animation names. BasePlayer is the composition
## root that injects the provider and forwards fallback pose values.
##
## A complete 3D envelope is fitted into a capsule. The longest stable envelope
## axis becomes the capsule axis: standing bodies remain vertical while a prone
## body automatically rotates the same capsule horizontally. Axis hysteresis,
## bounded dimension changes, and bounded rotation prevent one-frame jumps.

signal geometry_changed(
	height: float,
	radius: float,
	axis: Vector3,
	center: Vector3,
	floor_y: float
)
## Emitted once when an expanding/rotating candidate cannot occupy the world.
## BasePlayer may translate this value-only event into a stance rollback.
signal transition_blocked

const ENVELOPE_SAMPLE_INTERVAL := 1.0 / 30.0
const ENVELOPE_EPSILON := 0.002
const GEOMETRY_EPSILON := 0.0005
const CLEARANCE_SKIN := 0.003
const FIT_SEARCH_STEPS := 96

var _body: CharacterBody3D
var _config: MovementConfig
var _envelope_provider: Callable
var _collision_shape: CollisionShape3D
var _floor_y: float = 0.0
var _fallback_height: float = 1.8
var _fallback_center_y: float = 0.0
var _target_axis := Vector3.UP
var _pending_axis := Vector3.UP
var _pending_axis_frames: int = 0
var _fit_axis := Vector3.UP
var _fit_center := Vector3.ZERO
var _fit_height: float = 1.8
var _fit_radius: float = 0.4
var _sample_elapsed: float = INF
var _last_sampled_envelope := AABB()
var _has_sampled_envelope: bool = false
var _fallback_dirty: bool = true
var _transition_blocked_emitted: bool = false
var _geometry_write_count: int = 0
var _envelope_sample_count: int = 0


func initialize(
	body: CharacterBody3D,
	config: MovementConfig,
	envelope_provider: Callable = Callable()
) -> void:
	_body = body
	_config = config if config else MovementConfig.new()
	_envelope_provider = envelope_provider
	_fallback_height = _config.collision_shape_height
	_floor_y = _config.collision_shape_y_offset - _config.collision_shape_height * 0.5
	_ensure_collision_shape()


## Replaces the source of player-local 3D envelope snapshots. The callable must
## return AABB and should not expose nodes or mutable component state.
func set_envelope_provider(provider: Callable) -> void:
	_envelope_provider = provider
	_has_sampled_envelope = false
	_sample_elapsed = INF


## Supplies a value-only fallback for startup/model reload. Live hitbox data
## takes priority whenever the injected provider returns a valid envelope.
func set_fallback_height(height: float) -> void:
	set_fallback_geometry(height, _fallback_center_y)


func set_fallback_geometry(height: float, center_y: float) -> void:
	var next_height := maxf(height, 0.01)
	if is_equal_approx(_fallback_height, next_height) \
		and is_equal_approx(_fallback_center_y, center_y):
		return
	_fallback_height = next_height
	_fallback_center_y = center_y
	_fallback_dirty = true


## Returns the only environment collision shape owned by this component.
## Callers may inspect it but must not replace its shape or write its transform.
func get_collision_shape() -> CollisionShape3D:
	return _collision_shape


func get_capsule_axis() -> Vector3:
	if not _collision_shape:
		return Vector3.UP
	return _collision_shape.transform.basis.y.normalized()


func get_floor_contact_y() -> float:
	if not _collision_shape or not (_collision_shape.shape is CapsuleShape3D):
		return _floor_y
	var capsule := _collision_shape.shape as CapsuleShape3D
	return _collision_shape.position.y - _vertical_half_extent(
		capsule.height,
		capsule.radius,
		get_capsule_axis()
	)


func get_vertical_extent() -> float:
	if not _collision_shape or not (_collision_shape.shape is CapsuleShape3D):
		return 0.0
	var capsule := _collision_shape.shape as CapsuleShape3D
	return _vertical_half_extent(capsule.height, capsule.radius, get_capsule_axis()) * 2.0


func get_geometry_write_count() -> int:
	return _geometry_write_count


func get_envelope_sample_count() -> int:
	return _envelope_sample_count


## Test/debug inspection API. Normal gameplay consumes geometry_changed instead.
func contains_envelope(envelope: AABB, tolerance: float = 0.002) -> bool:
	if not _collision_shape or not (_collision_shape.shape is CapsuleShape3D):
		return false
	var capsule := _collision_shape.shape as CapsuleShape3D
	var axis := get_capsule_axis()
	for corner in _aabb_corners(envelope):
		if not _capsule_contains_point(
			corner,
			_collision_shape.position,
			axis,
			capsule.height,
			capsule.radius,
			tolerance
		):
			return false
	return true


## Deterministic setup/test hook. Normal gameplay follows the same target from
## _physics_process with speed limits and axis-switch stability.
func refresh_immediately() -> void:
	_update_geometry(0.0, true)
	_sample_elapsed = 0.0


func _physics_process(delta: float) -> void:
	if not _body or not _collision_shape or _collision_shape.disabled:
		return
	_sample_elapsed += delta
	var should_sample := _sample_elapsed >= ENVELOPE_SAMPLE_INTERVAL \
		or not _has_sampled_envelope or _fallback_dirty
	_update_geometry(delta, false, should_sample)
	if should_sample:
		_sample_elapsed = 0.0


func _ensure_collision_shape() -> void:
	_collision_shape = _body.get_node_or_null("PlayerCollisionShape") as CollisionShape3D
	if not _collision_shape:
		_collision_shape = CollisionShape3D.new()
		_collision_shape.name = "PlayerCollisionShape"
		_body.add_child(_collision_shape)

	var capsule := _collision_shape.shape as CapsuleShape3D
	if not capsule:
		capsule = CapsuleShape3D.new()
		_collision_shape.shape = capsule
	capsule.radius = _config.collision_shape_radius
	capsule.height = maxf(_config.collision_shape_height, capsule.radius * 2.0)
	_collision_shape.position = Vector3(0.0, _config.collision_shape_y_offset, 0.0)
	_collision_shape.quaternion = Quaternion.IDENTITY


func _update_geometry(delta: float, snap: bool, sample: bool = true) -> void:
	if not _collision_shape or not (_collision_shape.shape is CapsuleShape3D):
		return
	if sample:
		var envelope := _sample_envelope()
		_envelope_sample_count += 1
		var envelope_changed := not _has_sampled_envelope \
			or not _aabb_is_equal_approx(envelope, _last_sampled_envelope)
		# Axis hysteresis needs repeated samples even when the numeric envelope is
		# stable, but an already-selected pose does not need to be refitted.
		var axis_pending := _pending_axis_frames > 0
		if _envelope_is_valid(envelope):
			if envelope_changed or axis_pending or _fallback_dirty:
				_fit_envelope(envelope, snap)
		else:
			if envelope_changed or _fallback_dirty:
				_fit_fallback(snap)
		_last_sampled_envelope = envelope
		_has_sampled_envelope = true
		_fallback_dirty = false
	_apply_target(delta, snap)


func _sample_envelope() -> AABB:
	if not _config.hitbox_driven_collision or not _envelope_provider.is_valid():
		return AABB()
	var value: Variant = _envelope_provider.call()
	return value as AABB if value is AABB else AABB()


func _fit_envelope(envelope: AABB, snap_axis: bool) -> void:
	var margin := maxf(_config.collision_bounds_margin, 0.0)
	var padded := AABB(
		envelope.position - Vector3.ONE * margin,
		envelope.size + Vector3.ONE * margin * 2.0
	)
	var axis := _select_axis(padded.size, snap_axis)
	var fit := _fit_containing_capsule(padded, axis)
	var radius := float(fit["radius"])
	var height := float(fit["height"])
	var center := fit["center"] as Vector3
	_fit_axis = axis
	_fit_center = center
	_fit_height = height
	_fit_radius = radius


## Fits all eight AABB corners while keeping the capsule's world-facing bottom
## on the configured floor plane. The preferred max dimensions protect against
## ordinary animation outliers; if those limits cannot contain the supplied
## envelope, containment wins instead of silently exposing part of the body.
func _fit_containing_capsule(envelope: AABB, axis: Vector3) -> Dictionary:
	var minimum_radius := maxf(_config.collision_shape_radius, 0.01)
	var preferred_max_radius := maxf(_config.collision_bounds_max_radius, minimum_radius)
	var preferred_max_height := maxf(
		_config.collision_bounds_max_height,
		_config.collision_bounds_min_height
	)
	var expanded_radius_limit := maxf(
		preferred_max_radius,
		envelope.size.length() + absf(envelope.end.y - _floor_y) + minimum_radius
	)
	var fit := _search_containing_fit(
		envelope, axis, minimum_radius, preferred_max_radius, preferred_max_height
	)
	if fit.is_empty():
		fit = _search_containing_fit(
			envelope, axis, minimum_radius, expanded_radius_limit, preferred_max_height
		)
	if fit.is_empty():
		# A longitudinal range larger than max_height cannot be reduced by radius.
		# Pick the smallest exact candidate and allow height to exceed the preferred
		# cap rather than returning a collider that misses the supplied body bounds.
		fit = _search_containing_fit(
			envelope, axis, minimum_radius, expanded_radius_limit, INF
		)
	if fit.is_empty():
		# AABB data below the authored floor cannot be enclosed by a floor-anchored
		# capsule. Preserve containment with an envelope-centered exact fallback;
		# this is safer than silently returning a collider that misses body parts.
		fit = _fit_unanchored_containing_capsule(envelope, axis, minimum_radius)
	return fit


func _search_containing_fit(
	envelope: AABB,
	axis: Vector3,
	minimum_radius: float,
	maximum_radius: float,
	maximum_height: float
) -> Dictionary:
	var span := maxf(maximum_radius - minimum_radius, 0.0)
	for step_index in range(FIT_SEARCH_STEPS + 1):
		var ratio := float(step_index) / float(FIT_SEARCH_STEPS)
		var radius := minimum_radius + span * ratio
		var required_height := _required_height_for_radius(envelope, axis, radius)
		if not is_finite(required_height):
			continue
		var height := maxf(
			required_height,
			maxf(_config.collision_bounds_min_height, radius * 2.0)
		)
		if height > maximum_height + GEOMETRY_EPSILON:
			continue
		var center := _floor_anchored_center(envelope, axis, height, radius)
		if _capsule_contains_aabb(envelope, center, axis, height, radius):
			return {"radius": radius, "height": height, "center": center}
	return {}


func _required_height_for_radius(envelope: AABB, axis: Vector3, radius: float) -> float:
	var half := envelope.size * 0.5
	if absf(axis.y) > 0.5:
		var transverse := Vector2(half.x, half.z).length()
		if transverse > radius + GEOMETRY_EPSILON:
			return INF
		var lower_height := envelope.position.y - _floor_y
		if lower_height < -GEOMETRY_EPSILON:
			return INF
		var cap_reach := sqrt(maxf(radius * radius - transverse * transverse, 0.0))
		if envelope.position.y < _floor_y + radius - cap_reach - GEOMETRY_EPSILON:
			return INF
		return maxf(
			radius * 2.0,
			envelope.end.y - _floor_y + radius - cap_reach
		)

	var cross_half := half.z if absf(axis.x) > 0.5 else half.x
	var lower_y := envelope.position.y - _floor_y
	var upper_y := envelope.end.y - _floor_y
	if lower_y < -GEOMETRY_EPSILON:
		return INF
	var lower_perpendicular := Vector2(cross_half, lower_y - radius).length()
	var upper_perpendicular := Vector2(cross_half, upper_y - radius).length()
	var farthest_perpendicular := maxf(lower_perpendicular, upper_perpendicular)
	if farthest_perpendicular > radius + GEOMETRY_EPSILON:
		return INF
	var cap_reach := sqrt(maxf(radius * radius - farthest_perpendicular * farthest_perpendicular, 0.0))
	var longitudinal_half := half.x if absf(axis.x) > 0.5 else half.z
	var segment_half := maxf(longitudinal_half - cap_reach, 0.0)
	return (radius + segment_half) * 2.0


func _floor_anchored_center(
	envelope: AABB,
	axis: Vector3,
	height: float,
	radius: float
) -> Vector3:
	var center := envelope.get_center()
	center.y = _floor_y + _vertical_half_extent(height, radius, axis)
	return center


func _fit_unanchored_containing_capsule(
	envelope: AABB,
	axis: Vector3,
	minimum_radius: float
) -> Dictionary:
	var half := envelope.size * 0.5
	var transverse := Vector2(half.x, half.z).length()
	var longitudinal_half := half.y
	if absf(axis.x) > 0.5:
		transverse = Vector2(half.y, half.z).length()
		longitudinal_half = half.x
	elif absf(axis.z) > 0.5:
		transverse = Vector2(half.x, half.y).length()
		longitudinal_half = half.z
	var radius := maxf(minimum_radius, transverse)
	var cap_reach := sqrt(maxf(radius * radius - transverse * transverse, 0.0))
	var segment_half := maxf(longitudinal_half - cap_reach, 0.0)
	var height := maxf(
		(radius + segment_half) * 2.0,
		maxf(_config.collision_bounds_min_height, radius * 2.0)
	)
	return {
		"radius": radius,
		"height": height,
		"center": envelope.get_center(),
	}


func _fit_fallback(_snap_axis: bool) -> void:
	# Fallback dimensions are authored as a vertical capsule. Returning to this
	# axis is still smoothed by _apply_target during gameplay.
	_target_axis = Vector3.UP
	_pending_axis = Vector3.UP
	_pending_axis_frames = 0
	var axis := Vector3.UP
	var radius := _config.collision_shape_radius
	var minimum_height := maxf(_config.collision_bounds_min_height, radius * 2.0)
	var height := clampf(
		maxf(_fallback_height, minimum_height),
		minimum_height,
		maxf(_config.collision_bounds_max_height, minimum_height)
	)
	_fit_axis = axis
	_fit_center = Vector3(0.0, _fallback_center_y, 0.0)
	_fit_height = height
	_fit_radius = radius


func _select_axis(size: Vector3, snap: bool) -> Vector3:
	var candidate := Vector3.UP
	var candidate_length := size.y
	if size.x > candidate_length:
		candidate = Vector3.RIGHT
		candidate_length = size.x
	if size.z > candidate_length:
		candidate = Vector3.BACK
		candidate_length = size.z

	if candidate == _target_axis:
		_pending_axis = candidate
		_pending_axis_frames = 0
		return _target_axis
	var current_length := _axis_extent(size, _target_axis)
	if candidate_length < current_length * maxf(_config.collision_axis_switch_ratio, 1.0):
		_pending_axis = _target_axis
		_pending_axis_frames = 0
		return _target_axis
	if snap:
		_target_axis = candidate
		_pending_axis = candidate
		_pending_axis_frames = 0
		return _target_axis
	if candidate != _pending_axis:
		_pending_axis = candidate
		_pending_axis_frames = 1
	else:
		_pending_axis_frames += 1
	if _pending_axis_frames >= maxi(_config.collision_axis_switch_stability_frames, 1):
		_target_axis = candidate
		_pending_axis_frames = 0
	return _target_axis


func _apply_target(delta: float, snap: bool) -> void:
	var capsule := _collision_shape.shape as CapsuleShape3D
	var target_height := _fit_height
	var target_radius := _fit_radius
	var target_axis := _fit_axis
	var target_center := _fit_center
	var next_height := target_height
	var next_radius := target_radius
	var next_axis := target_axis
	var next_center := target_center

	if not snap:
		var linear_step := maxf(_config.collision_bounds_follow_speed, 0.01) * delta
		next_radius = move_toward(capsule.radius, target_radius, linear_step)
		# Respect Godot's height >= 2 * radius invariant without allowing the
		# resource to enlarge height by more than the configured linear step.
		var constrained_height_target := maxf(target_height, next_radius * 2.0)
		next_height = move_toward(capsule.height, constrained_height_target, linear_step)
		next_radius = minf(next_radius, next_height * 0.5)
		next_axis = _rotate_axis_toward(
			get_capsule_axis(),
			target_axis,
			deg_to_rad(maxf(_config.collision_axis_follow_speed_degrees, 1.0)) * delta
		)
		next_center.x = move_toward(_collision_shape.position.x, target_center.x, linear_step)
		next_center.z = move_toward(_collision_shape.position.z, target_center.z, linear_step)

	next_height = maxf(next_height, next_radius * 2.0)
	next_center.y = target_center.y
	if not _geometry_differs(capsule, next_height, next_radius, next_axis, next_center):
		_transition_blocked_emitted = false
		return
	if not snap and _requires_clearance(
		capsule, next_height, next_radius, next_axis, next_center
	) and not _candidate_has_clearance(next_height, next_radius, next_axis, next_center):
		if not _transition_blocked_emitted:
			_transition_blocked_emitted = true
			transition_blocked.emit()
		return

	_transition_blocked_emitted = false
	_set_capsule_dimensions(capsule, next_height, next_radius)
	_collision_shape.quaternion = Quaternion(Vector3.UP, next_axis).normalized()
	_collision_shape.position = next_center
	_geometry_write_count += 1
	geometry_changed.emit(
		capsule.height,
		capsule.radius,
		next_axis,
		next_center,
		get_floor_contact_y()
	)


func _geometry_differs(
	capsule: CapsuleShape3D,
	height: float,
	radius: float,
	axis: Vector3,
	center: Vector3
) -> bool:
	return absf(capsule.height - height) > GEOMETRY_EPSILON \
		or absf(capsule.radius - radius) > GEOMETRY_EPSILON \
		or get_capsule_axis().angle_to(axis) > GEOMETRY_EPSILON \
		or _collision_shape.position.distance_to(center) > GEOMETRY_EPSILON


func _requires_clearance(
	capsule: CapsuleShape3D,
	height: float,
	radius: float,
	axis: Vector3,
	center: Vector3
) -> bool:
	var current_axis := get_capsule_axis()
	var same_axis := current_axis.angle_to(axis) <= GEOMETRY_EPSILON
	var same_horizontal_center := Vector2(
		_collision_shape.position.x,
		_collision_shape.position.z
	).distance_to(Vector2(center.x, center.z)) <= GEOMETRY_EPSILON
	var only_floor_anchored_shrink := same_axis \
		and same_horizontal_center \
		and height <= capsule.height + GEOMETRY_EPSILON \
		and radius <= capsule.radius + GEOMETRY_EPSILON
	return not only_floor_anchored_shrink


func _candidate_has_clearance(
	height: float,
	radius: float,
	axis: Vector3,
	center: Vector3
) -> bool:
	if not _body or not _body.is_inside_tree() or not _body.get_world_3d():
		return true
	var query_shape := CapsuleShape3D.new()
	var query_radius := maxf(radius - CLEARANCE_SKIN, 0.001)
	var query_height := maxf(height - CLEARANCE_SKIN * 2.0, query_radius * 2.0)
	query_shape.radius = query_radius
	query_shape.height = query_height
	var parameters := PhysicsShapeQueryParameters3D.new()
	parameters.shape = query_shape
	parameters.transform = _body.global_transform * Transform3D(
		Basis(Quaternion(Vector3.UP, axis).normalized()),
		center
	)
	parameters.exclude = [_body.get_rid()]
	parameters.collision_mask = _body.collision_mask
	parameters.collide_with_bodies = true
	parameters.collide_with_areas = false
	parameters.margin = 0.0
	return _body.get_world_3d().direct_space_state.intersect_shape(parameters, 1).is_empty()


func _set_capsule_dimensions(capsule: CapsuleShape3D, height: float, radius: float) -> void:
	# Godot enforces height >= 2 * radius. Assignment order matters while radius
	# grows or shrinks, otherwise the resource can silently rewrite the other
	# property and bypass our configured per-frame limit.
	if radius > capsule.radius:
		if absf(capsule.height - height) > GEOMETRY_EPSILON:
			capsule.height = maxf(height, radius * 2.0)
		if absf(capsule.radius - radius) > GEOMETRY_EPSILON:
			capsule.radius = radius
	else:
		if absf(capsule.radius - radius) > GEOMETRY_EPSILON:
			capsule.radius = radius
		if absf(capsule.height - height) > GEOMETRY_EPSILON:
			capsule.height = maxf(height, radius * 2.0)


func _rotate_axis_toward(current: Vector3, target: Vector3, maximum_angle: float) -> Vector3:
	var angle := current.angle_to(target)
	if angle <= maximum_angle or is_zero_approx(angle):
		return target
	return current.slerp(target, clampf(maximum_angle / angle, 0.0, 1.0)).normalized()


func _vertical_half_extent(height: float, radius: float, axis: Vector3) -> float:
	var segment_half := maxf(height * 0.5 - radius, 0.0)
	return radius + absf(axis.y) * segment_half


func _axis_extent(size: Vector3, axis: Vector3) -> float:
	if absf(axis.x) > 0.5:
		return size.x
	if absf(axis.z) > 0.5:
		return size.z
	return size.y


func _aabb_is_equal_approx(first: AABB, second: AABB) -> bool:
	return first.position.distance_to(second.position) <= ENVELOPE_EPSILON \
		and first.size.distance_to(second.size) <= ENVELOPE_EPSILON


func _aabb_corners(envelope: AABB) -> Array[Vector3]:
	var minimum := envelope.position
	var maximum := envelope.end
	return [
		Vector3(minimum.x, minimum.y, minimum.z),
		Vector3(minimum.x, minimum.y, maximum.z),
		Vector3(minimum.x, maximum.y, minimum.z),
		Vector3(minimum.x, maximum.y, maximum.z),
		Vector3(maximum.x, minimum.y, minimum.z),
		Vector3(maximum.x, minimum.y, maximum.z),
		Vector3(maximum.x, maximum.y, minimum.z),
		Vector3(maximum.x, maximum.y, maximum.z),
	]


func _capsule_contains_aabb(
	envelope: AABB,
	center: Vector3,
	axis: Vector3,
	height: float,
	radius: float
) -> bool:
	for corner in _aabb_corners(envelope):
		if not _capsule_contains_point(
			corner, center, axis, height, radius, GEOMETRY_EPSILON
		):
			return false
	return true


func _capsule_contains_point(
	point: Vector3,
	center: Vector3,
	axis: Vector3,
	height: float,
	radius: float,
	tolerance: float = 0.0
) -> bool:
	var normalized_axis := axis.normalized()
	var segment_half := maxf(height * 0.5 - radius, 0.0)
	var relative := point - center
	var projected := clampf(relative.dot(normalized_axis), -segment_half, segment_half)
	var nearest := center + normalized_axis * projected
	var allowed_radius := radius + maxf(tolerance, 0.0)
	return point.distance_squared_to(nearest) <= allowed_radius * allowed_radius


func _envelope_is_valid(envelope: AABB) -> bool:
	return envelope.size.x > 0.0 and envelope.size.y > 0.0 and envelope.size.z > 0.0
