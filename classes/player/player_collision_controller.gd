class_name PlayerCollisionController
extends Node

## Owns the CharacterBody3D environment capsule.
##
## The rendered model and its medical hitboxes are allowed to change with any
## authored animation.  This controller samples those hitboxes through an
## injected provider and follows their vertical extent with one generic speed;
## no animation-specific capsule height is required.  When hitboxes are not yet
## available, the old stance configuration is used only as a safe fallback.
##
## Dependency direction:
##   StanceController signals + hitbox provider -> this controller -> capsule
## PlayerModelManager and PlayerMovementController never create or resize the
## capsule, so there is a single owner of the physical volume.

var _player: BasePlayer
var _stance: StanceController
var _model_manager: PlayerModelManager
var _config: MovementConfig
var _hitbox_provider: Callable
var _collision_shape: CollisionShape3D
var _floor_bottom: float = 0.0


func initialize(
	player: BasePlayer,
	stance: StanceController,
	model_manager: PlayerModelManager,
	config: MovementConfig,
	hitbox_provider: Callable = Callable()
) -> void:
	_player = player
	_stance = stance
	_model_manager = model_manager
	_config = config if config else MovementConfig.new()
	_hitbox_provider = hitbox_provider
	_ensure_collision_shape()

	if _stance:
		if not _stance.stance_changed.is_connected(_on_stance_geometry_changed):
			_stance.stance_changed.connect(_on_stance_geometry_changed)
		if not _stance.prone_geometry_changed.is_connected(_on_prone_geometry_changed):
			_stance.prone_geometry_changed.connect(_on_prone_geometry_changed)
	if _model_manager and not _model_manager.model_loaded.is_connected(_on_model_loaded):
		_model_manager.model_loaded.connect(_on_model_loaded)
	_update_model_offset()
	_floor_bottom = _config.collision_shape_y_offset - _config.collision_shape_height * 0.5


## Returns the only environment collision shape owned by this controller.
## Tests and debug UI may inspect it, but other gameplay components must not
## replace its shape or write its height/position.
func get_collision_shape() -> CollisionShape3D:
	return _collision_shape


## Re-evaluates visual and physical geometry without smoothing.  Intended for
## deterministic setup/tests; normal gameplay uses _physics_process().
func refresh_immediately() -> void:
	_update_model_offset()
	_update_collision_bounds(0.0, true)


func _physics_process(delta: float) -> void:
	if not _player or not _player.is_alive:
		return
	_update_collision_bounds(delta, false)


func _ensure_collision_shape() -> void:
	_collision_shape = _player.get_node_or_null("PlayerCollisionShape") as CollisionShape3D
	if not _collision_shape:
		_collision_shape = CollisionShape3D.new()
		_collision_shape.name = "PlayerCollisionShape"
		_player.add_child(_collision_shape)

	var capsule := _collision_shape.shape as CapsuleShape3D
	if not capsule:
		capsule = CapsuleShape3D.new()
		_collision_shape.shape = capsule
	capsule.radius = _config.collision_shape_radius
	capsule.height = maxf(_config.collision_shape_height, capsule.radius * 2.0)
	_collision_shape.position = Vector3(0.0, _config.collision_shape_y_offset, 0.0)


func _on_model_loaded(_model: Node3D) -> void:
	_update_model_offset()


func _on_stance_geometry_changed(_value: float) -> void:
	_update_model_offset()


func _on_prone_geometry_changed(_value: float) -> void:
	_update_model_offset()


func _update_model_offset() -> void:
	if not _model_manager or not is_instance_valid(_model_manager.model_node):
		return
	var stance_value: float = _stance.get_stance_value() if _stance else 0.0
	var prone_blend: float = _stance.get_prone_geometry_blend() if _stance else 0.0
	var non_prone_y := lerpf(_config.model_y_offset, _config.crouch_y_offset, stance_value)
	_model_manager.model_node.position.y = lerpf(
		non_prone_y,
		_config.prone_model_y_offset,
		prone_blend
	)


func _update_collision_bounds(delta: float, snap: bool) -> void:
	if not _collision_shape or not (_collision_shape.shape is CapsuleShape3D):
		return
	var target_bounds := _sample_hitbox_bounds()
	if not _bounds_are_valid(target_bounds):
		target_bounds = _fallback_stance_bounds()
	else:
		# Medical hitboxes stop at the calves rather than the soles, so the main
		# capsule keeps its stable floor contact. Highest/lowest hitbox positions
		# still determine the required volume; a pose extending below the floor is
		# conservatively added above it instead of pushing CharacterBody downward.
		var height_from_floor := target_bounds.y - _floor_bottom
		var sampled_height := target_bounds.y - target_bounds.x
		var environment_height := maxf(height_from_floor, sampled_height) \
			+ _config.collision_bounds_margin
		target_bounds = Vector2(_floor_bottom, _floor_bottom + environment_height)
	target_bounds = _clamp_bounds_height(target_bounds)

	var capsule := _collision_shape.shape as CapsuleShape3D
	var current_bounds := Vector2(
		_collision_shape.position.y - capsule.height * 0.5,
		_collision_shape.position.y + capsule.height * 0.5
	)
	var next_bounds := target_bounds
	if not snap:
		var step := maxf(_config.collision_bounds_follow_speed, 0.01) * delta
		next_bounds = Vector2(
			move_toward(current_bounds.x, target_bounds.x, step),
			move_toward(current_bounds.y, target_bounds.y, step)
		)
	next_bounds = _clamp_bounds_height(next_bounds)
	capsule.height = next_bounds.y - next_bounds.x
	_collision_shape.position.y = (next_bounds.x + next_bounds.y) * 0.5


func _sample_hitbox_bounds() -> Vector2:
	if not _config.hitbox_driven_collision or not _hitbox_provider.is_valid():
		return Vector2(INF, -INF)
	var hitboxes_value: Variant = _hitbox_provider.call()
	if not hitboxes_value is Array:
		return Vector2(INF, -INF)
	var bounds := Vector2(INF, -INF)
	for hitbox_value in hitboxes_value as Array:
		var hitbox := hitbox_value as Node
		if not is_instance_valid(hitbox) or not hitbox.has_method("get_vertical_bounds"):
			continue
		var hitbox_bounds: Vector2 = hitbox.call("get_vertical_bounds", _player)
		if not _bounds_are_valid(hitbox_bounds):
			continue
		bounds.x = minf(bounds.x, hitbox_bounds.x)
		bounds.y = maxf(bounds.y, hitbox_bounds.y)
	return bounds


func _fallback_stance_bounds() -> Vector2:
	var stance_value: float = _stance.get_stance_value() if _stance else 0.0
	var prone_blend: float = _stance.get_prone_geometry_blend() if _stance else 0.0
	var standing_height := _config.collision_shape_height
	var non_prone_height := lerpf(standing_height, _config.crouch_capsule_height, stance_value)
	var configured_height := lerpf(non_prone_height, _config.prone_capsule_height, prone_blend)
	var non_prone_center := _config.collision_shape_y_offset \
		+ (non_prone_height - standing_height) * 0.5
	var center := lerpf(non_prone_center, _config.prone_collision_y_offset, prone_blend)
	var bottom := center - configured_height * 0.5
	var minimum_height := maxf(
		_config.collision_bounds_min_height,
		(_collision_shape.shape as CapsuleShape3D).radius * 2.0
	)
	var height := clampf(configured_height, minimum_height, _config.collision_bounds_max_height)
	# Preserve the authored floor contact when the legacy fallback requests a
	# capsule shorter than 2 * radius. Godot capsules cannot represent that size.
	return Vector2(bottom, bottom + height)


func _clamp_bounds_height(bounds: Vector2) -> Vector2:
	var capsule := _collision_shape.shape as CapsuleShape3D
	var minimum_height := maxf(_config.collision_bounds_min_height, capsule.radius * 2.0)
	var maximum_height := maxf(_config.collision_bounds_max_height, minimum_height)
	var center := (bounds.x + bounds.y) * 0.5
	var height := clampf(bounds.y - bounds.x, minimum_height, maximum_height)
	return Vector2(center - height * 0.5, center + height * 0.5)


func _bounds_are_valid(bounds: Vector2) -> bool:
	return is_finite(bounds.x) and is_finite(bounds.y) and bounds.y > bounds.x
