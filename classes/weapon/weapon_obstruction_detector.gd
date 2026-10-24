class_name WeaponObstructionDetector
extends Node

## Physics probe only; transforms and settings are injected by composition.
signal obstruction_changed(weight: float)

var _body: Node3D
var _eye_provider: Callable
var _muzzle_provider: Callable
var _radius_provider: Callable
var _weight := 0.0
var _warned_missing := false


func initialize(body: Node3D, eye_provider: Callable, muzzle_provider: Callable, radius_provider: Callable) -> void:
	_body = body
	_eye_provider = eye_provider
	_muzzle_provider = muzzle_provider
	_radius_provider = radius_provider


func _physics_process(_delta: float) -> void:
	refresh()


func refresh() -> void:
	_weight = _probe()
	obstruction_changed.emit(_weight)


func _probe() -> float:
	if not is_instance_valid(_body) or not _eye_provider.is_valid() or not _muzzle_provider.is_valid():
		_report_missing()
		return 0.0
	var muzzle: Dictionary = _muzzle_provider.call()
	if muzzle.is_empty():
		return 0.0
	var world := _body.get_world_3d()
	if not world:
		_report_missing()
		return 0.0
	var origin: Vector3 = _eye_provider.call()
	var position: Vector3 = muzzle["position"]
	var direction: Vector3 = muzzle["direction"]
	# Keep the sweep long enough during withdrawal so retracting the weapon
	# does not hide the wall that triggered it.
	var length := maxf(origin.distance_to(position), float(muzzle.get("length", 0.1)))
	var shape := SphereShape3D.new()
	shape.radius = maxf(float(_radius_provider.call()) if _radius_provider.is_valid() else 0.035, 0.001)
	var query := PhysicsShapeQueryParameters3D.new()
	query.shape = shape
	query.transform = Transform3D(Basis.IDENTITY, origin)
	query.collision_mask = PhysicsLayers.WEAPON_OBSTRUCTION
	query.exclude = _collect_exclusions(_body)
	var space := world.direct_space_state
	# Sweeps ignore initial overlaps, so test the starting sphere explicitly.
	if not space.intersect_shape(query, 1).is_empty():
		return 1.0
	query.motion = direction.normalized() * length
	var fractions := space.cast_motion(query)
	if fractions.size() != 2:
		_report_missing()
		return 0.0
	return clampf(1.0 - float(fractions[0]), 0.0, 1.0)


func _collect_exclusions(root: Node) -> Array[RID]:
	var result: Array[RID] = []
	if root is CollisionObject3D:
		result.append((root as CollisionObject3D).get_rid())
	for child in root.find_children("*", "CollisionObject3D", true, false):
		result.append((child as CollisionObject3D).get_rid())
	return result


func _report_missing() -> void:
	if not _warned_missing:
		GlobalLogger.debug("WeaponObstruction", "Probe unavailable; shooting remains enabled")
		_warned_missing = true


func get_obstruction_weight() -> float:
	return _weight
