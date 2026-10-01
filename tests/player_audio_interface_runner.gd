extends SceneTree

## Regression check for the reserved, no-op player audio interface.
## Run: godot --headless --path . --script res://tests/player_audio_interface_runner.gd

const PLAYER_SCENE := "res://assets/map/test_map.tscn"


func _init() -> void:
	_run.call_deferred()


func _run() -> void:
	var results: Dictionary = {}
	var packed := load(PLAYER_SCENE) as PackedScene
	if not packed:
		_finish({"scene_loaded": false})
		return
	results["scene_loaded"] = true

	var map := packed.instantiate()
	root.add_child(map)
	var player := _find_player(map)
	results["player_ready"] = player != null
	if not player:
		_finish(results)
		return

	var audio = player.get("audio_controller")
	var audio_script: Variant = audio.get_script() if audio else null
	results["interface_ready"] = audio_script != null \
			and String(audio_script.resource_path).ends_with("player_audio_controller.gd")
	results["processing_disabled"] = audio != null \
			and audio.process_mode == Node.PROCESS_MODE_DISABLED
	results["no_audio_players"] = audio != null \
			and audio.find_children("*", "AudioStreamPlayer", true, false).is_empty() \
			and audio.find_children("*", "AudioStreamPlayer3D", true, false).is_empty()

	map.queue_free()
	_finish(results)


func _find_player(node: Node) -> Node:
	var script: Variant = node.get_script()
	if script != null and String(script.resource_path).ends_with("base_player.gd") \
			and not bool(node.get("is_ai_player")):
		return node
	for child in node.get_children():
		var found := _find_player(child)
		if found:
			return found
	return null


func _finish(results: Dictionary) -> void:
	var passed := true
	for key in results:
		if results[key] != true:
			passed = false
	results["status"] = "passed" if passed else "failed"
	print(JSON.stringify({"status": results["status"], "results": results}))
	quit(0 if passed else 1)
