class_name EncounterZone
extends Area3D

@export var radius: float = 8.0

func _ready() -> void:
	monitoring = true
	monitorable = true
	_rebuild_shape()

func set_radius(value: float) -> void:
	radius = maxf(value, 0.1)
	_rebuild_shape()

func get_encounter_actors() -> Array[Node3D]:
	var result: Array[Node3D] = []
	for body in get_overlapping_bodies():
		if body is Node3D and body.has_method("get_match_faction"):
			result.append(body as Node3D)
		elif body is Node3D and body.get("faction") != null:
			result.append(body as Node3D)
	return result

func _rebuild_shape() -> void:
	if not is_inside_tree():
		return
	var shape_node := get_node_or_null("CollisionShape3D") as CollisionShape3D
	if not shape_node:
		shape_node = CollisionShape3D.new()
		shape_node.name = "CollisionShape3D"
		add_child(shape_node)
	var sphere := SphereShape3D.new()
	sphere.radius = radius
	shape_node.shape = sphere

