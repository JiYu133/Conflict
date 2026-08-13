class_name MuzzleFlashSequence
extends Node3D

const KEY_FRAME_INDICES := [1, 2, 4, 7, 10, 13, 17, 22]

static var _frame_cache: Dictionary = {}

var _using_front_view: bool = false

@export_dir var side_frames_directory: String
@export_dir var front_frames_directory: String
@export_range(0.02, 0.2, 0.005) var animation_duration: float = 0.09
@export_range(0.00001, 0.004, 0.00001) var pixel_size: float = 0.0012
@export_range(0.0, 90.0, 1.0) var front_view_angle_deg: float = 32.0
@export var flash_modulate: Color = Color(2.4, 1.55, 0.8, 1.0)
var force_front_view: bool = false
var quality: String = "high"
var maximum_visibility_distance: float = 120.0


func _ready() -> void:
	# The controller positions the effect immediately after add_child(). Waiting
	# until the deferred call ensures camera-angle selection uses that transform.
	call_deferred("_start_playback")


func preload_frames() -> void:
	if force_front_view and not front_frames_directory.is_empty():
		_load_frames(front_frames_directory)
	else:
		_load_frames(side_frames_directory)
		_load_frames(front_frames_directory)


func _start_playback() -> void:
	var frames := _select_frames()
	if frames.is_empty():
		queue_free()
		return
	var sprite_frames := SpriteFrames.new()
	sprite_frames.remove_animation(&"default")
	sprite_frames.add_animation(&"flash")
	sprite_frames.set_animation_speed(&"flash", float(frames.size()) / maxf(animation_duration, 0.02))
	sprite_frames.set_animation_loop(&"flash", false)
	for texture in frames:
		if texture:
			sprite_frames.add_frame(&"flash", texture)

	var sprite := AnimatedSprite3D.new()
	sprite.name = "Sequence"
	sprite.sprite_frames = sprite_frames
	sprite.animation = &"flash"
	sprite.pixel_size = pixel_size
	sprite.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	sprite.shaded = false
	sprite.double_sided = true
	sprite.no_depth_test = false
	sprite.flip_h = _should_flip_side_view()
	sprite.modulate = flash_modulate
	sprite.render_priority = 2
	sprite.visibility_range_end = maximum_visibility_distance
	sprite.visibility_range_end_margin = minf(15.0, maximum_visibility_distance * 0.2)
	sprite.visibility_range_fade_mode = GeometryInstance3D.VISIBILITY_RANGE_FADE_SELF
	add_child(sprite)
	sprite.animation_finished.connect(queue_free)
	sprite.play()


func _select_frames() -> Array[Texture2D]:
	_using_front_view = false
	var selected_directory := side_frames_directory
	if force_front_view and not front_frames_directory.is_empty():
		_using_front_view = true
		return _load_frames(front_frames_directory)
	var camera := get_viewport().get_camera_3d()
	if camera and not front_frames_directory.is_empty():
		var muzzle_forward := -global_basis.z.normalized()
		var to_camera := (camera.global_position - global_position).normalized()
		var front_threshold := cos(deg_to_rad(front_view_angle_deg))
		if absf(muzzle_forward.dot(to_camera)) >= front_threshold:
			selected_directory = front_frames_directory
			_using_front_view = true
	return _load_frames(selected_directory)


func _should_flip_side_view() -> bool:
	if _using_front_view:
		return false
	var camera := get_viewport().get_camera_3d()
	if not camera:
		return true
	var muzzle_forward := -global_basis.z.normalized()
	# The source side-view sequences point left. Flip them whenever the weapon's
	# forward axis projects toward the camera's screen-right direction.
	return camera.global_basis.x.dot(muzzle_forward) > 0.0


func _load_frames(directory: String) -> Array[Texture2D]:
	if directory.is_empty():
		return []
	var cache_key := "%s|%s" % [directory, quality]
	if _frame_cache.has(cache_key):
		return _frame_cache[cache_key]
	var frames: Array[Texture2D] = []
	var file_names := DirAccess.get_files_at(directory)
	file_names.sort()
	var png_files := PackedStringArray()
	for file_name in file_names:
		if file_name.get_extension().to_lower() == "png":
			png_files.append(file_name)
	for frame_index in _key_frame_indices():
		if frame_index >= png_files.size():
			continue
		var texture := load(directory.path_join(png_files[frame_index])) as Texture2D
		if texture:
			frames.append(texture)
	_frame_cache[cache_key] = frames
	return frames


func _key_frame_indices() -> Array:
	match quality:
		"low":
			return [1, 4, 10, 22]
		"medium":
			return [1, 2, 7, 13, 17, 22]
		_:
			return KEY_FRAME_INDICES
