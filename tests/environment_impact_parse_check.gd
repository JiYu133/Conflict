extends SceneTree

const IMPACT_EFFECT = preload("res://classes/combat/environment_impact_effect.gd")


func _init() -> void:
	for variant in range(1, 5):
		for frame_index in IMPACT_EFFECT.FRAME_INDICES:
			var path := "%s/variant_%02d/frame_%04d.png" % [IMPACT_EFFECT.FRAME_ROOT, variant, frame_index]
			if not ResourceLoader.exists(path):
				push_error("missing environment impact frame: " + path)
				quit(1)
				return
	print("environment_impact_parse_check=ok")
	quit(0)
