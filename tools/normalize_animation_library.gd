extends SceneTree


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() != 2:
		push_error("Usage: --script res://tools/normalize_animation_library.gd -- <source> <output>")
		quit(1)
		return
	var source_path := args[0]
	var output_path := args[1]
	var source := load(source_path) as AnimationLibrary
	if not source:
		push_error("Could not load AnimationLibrary: %s" % source_path)
		quit(1)
		return
	var output := AnimationLibrary.new()
	for animation_name in source.get_animation_list():
		var animation := source.get_animation(animation_name).duplicate(true) as Animation
		for track_index in animation.get_track_count():
			var path_text := str(animation.track_get_path(track_index))
			if path_text.begins_with("Armature/"):
				animation.track_set_path(track_index, NodePath(path_text.trim_prefix("Armature/")))
		output.add_animation(animation_name, animation)
	var error := ResourceSaver.save(output, output_path)
	if error != OK:
		push_error("Failed to save %s: %s" % [output_path, error_string(error)])
		quit(1)
		return
	print("NORMALIZED ", source_path, " -> ", output_path, " animations=", output.get_animation_list())
	quit()
