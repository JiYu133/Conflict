class_name EnvironmentImpactEffect
extends Node3D

enum ImpactKind { STOP, PENETRATION, RICOCHET }

const FRAME_ROOT := "res://assets/textures/effects/muzzle_flashes/bullet_impacts/wall"
const FRAME_INDICES := [1, 3, 5, 7, 9, 12, 16, 22]

static var _frame_cache: Dictionary = {}


static func spawn(
	world_parent: Node,
	position: Vector3,
	normal: Vector3,
	incoming_direction: Vector3,
	kind: int,
	energy_j: float,
	material_name: String = "hard_surface"
) -> void:
	if not world_parent:
		return
	var effect: Node3D = (load("res://classes/combat/environment_impact_effect.gd") as Script).new() as Node3D
	effect.name = "BulletImpact_%s" % ImpactKind.keys()[kind]
	world_parent.add_child(effect)
	effect.global_position = position + normal.normalized() * 0.006
	effect.call("_build", normal, incoming_direction, kind, energy_j, material_name)


func _build(normal: Vector3, _incoming_direction: Vector3, kind: int, energy_j: float, _material_name: String) -> void:
	var safe_normal := normal.normalized() if normal.length_squared() > 0.0001 else Vector3.UP
	_spawn_animation(safe_normal, kind, energy_j)
	get_tree().create_timer(1.2).timeout.connect(queue_free)


func _spawn_animation(_normal: Vector3, kind: int, energy_j: float) -> void:
	var frames := SpriteFrames.new()
	frames.remove_animation(&"default")
	frames.add_animation(&"impact")
	frames.set_animation_loop(&"impact", false)
	frames.set_animation_speed(&"impact", 36.0)
	for texture in _load_variant_frames(randi_range(1, 4)):
		frames.add_frame(&"impact", texture)
	if frames.get_frame_count(&"impact") == 0:
		return
	var sprite := AnimatedSprite3D.new()
	sprite.name = "ImpactAnimation"
	sprite.sprite_frames = frames
	sprite.animation = &"impact"
	sprite.pixel_size = 0.00042 * clampf(sqrt(maxf(energy_j, 100.0) / 1500.0), 0.7, 1.35)
	sprite.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	sprite.shaded = false
	sprite.double_sided = true
	sprite.render_priority = 3
	if kind == ImpactKind.RICOCHET:
		sprite.modulate = Color(1.35, 1.05, 0.72, 1.0)
	elif kind == ImpactKind.PENETRATION:
		sprite.modulate = Color(0.82, 0.78, 0.72, 0.88)
	add_child(sprite)
	sprite.play()


static func _load_variant_frames(variant: int) -> Array[Texture2D]:
	var cache_key := clampi(variant, 1, 4)
	if _frame_cache.has(cache_key):
		return _frame_cache[cache_key]
	var frames: Array[Texture2D] = []
	var directory := "%s/variant_%02d" % [FRAME_ROOT, cache_key]
	for index in FRAME_INDICES:
		var path := "%s/frame_%04d.png" % [directory, index]
		if ResourceLoader.exists(path):
			var texture := load(path) as Texture2D
			if texture:
				frames.append(texture)
	_frame_cache[cache_key] = frames
	return frames
