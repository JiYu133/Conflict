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

var _body: CharacterBody3D
var _config: MovementConfig
var _envelope_provider: Callable
var _collision_shape: CollisionShape3D
var _floor_y: float = 0.0
var _fallback_height: float = 1.8
var _target_axis := Vector3.UP
var _pending_axis := Vector3.UP
var _pending_axis_frames: int = 0
var _fit_axis := Vector3.UP
var _fit_center := Vector3.ZERO
var _fit_height: float = 1.8
var _fit_radius: float = 0.4


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


## Supplies a value-only fallback for startup/model reload. Live hitbox data
## takes priority whenever the injected provider returns a valid envelope.
func set_fallback_height(height: float) -> void:
	_fallback_height = maxf(height, 0.01)


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


## Deterministic setup/test hook. Normal gameplay follows the same target from
## _physics_process with speed limits and axis-switch stability.
func refresh_immediately() -> void:
	_update_geometry(0.0, true)


func _physics_process(delta: float) -> void:
	if not _body:
		return
	_update_geometry(delta, false)


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


func _update_geometry(delta: float, snap: bool) -> void:
	if not _collision_shape or not (_collision_shape.shape is CapsuleShape3D):
		return
	var envelope := _sample_envelope()
	if _envelope_is_valid(envelope):
		_fit_envelope(envelope, snap)
	else:
		_fit_fallback(snap)
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
	var center := padded.get_center()
	var radius: float
	var height: float
	if absf(axis.y) > 0.5:
		radius = maxf(padded.size.x, padded.size.z) * 0.5
		# A standing capsule must reach the highest hitbox from the fixed foot
		# plane. This also covers authored hitboxes that stop above the soles.
		height = maxf(padded.end.y - _floor_y, padded.size.y)
	else:
		# Once the body is horizontal, use the envelope's actual thickness rather
		# than its absolute Y offset. Grounding that thickness at the stable foot
		# plane avoids turning an authored prone pose offset into empty capsule
		# space below the body.
		var cross_axis_width := padded.size.z if absf(axis.x) > 0.5 else padded.size.x
		radius = maxf(cross_axis_width, padded.size.y) * 0.5
		height = padded.size.x if absf(axis.x) > 0.5 else padded.size.z

	radius = clampf(
		radius,
		_config.collision_shape_radius,
		maxf(_config.collision_bounds_max_radius, _config.collision_shape_radius)
	)
	var minimum_height := maxf(_config.collision_bounds_min_height, radius * 2.0)
	height = clampf(
		maxf(height, minimum_height),
		minimum_height,
		maxf(_config.collision_bounds_max_height, minimum_height)
	)
	center.y = _floor_y + _vertical_half_extent(height, radius, axis)
	_fit_axis = axis
	_fit_center = center
	_fit_height = height
	_fit_radius = radius


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
	_fit_center = Vector3(0.0, _floor_y + height * 0.5, 0.0)
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
	_set_capsule_dimensions(capsule, next_height, next_radius)
	_collision_shape.quaternion = Quaternion(Vector3.UP, next_axis).normalized()
	next_center.y = _floor_y + _vertical_half_extent(
		capsule.height,
		capsule.radius,
		next_axis
	)
	_collision_shape.position = next_center
	geometry_changed.emit(
		capsule.height,
		capsule.radius,
		next_axis,
		next_center,
		get_floor_contact_y()
	)


func _set_capsule_dimensions(capsule: CapsuleShape3D, height: float, radius: float) -> void:
	# Godot enforces height >= 2 * radius. Assignment order matters while radius
	# grows or shrinks, otherwise the resource can silently rewrite the other
	# property and bypass our configured per-frame limit.
	if radius > capsule.radius:
		capsule.height = maxf(height, radius * 2.0)
		capsule.radius = radius
	else:
		capsule.radius = radius
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


func _envelope_is_valid(envelope: AABB) -> bool:
	return envelope.size.x > 0.0 and envelope.size.y > 0.0 and envelope.size.z > 0.0
