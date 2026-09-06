extends SceneTree

func _init() -> void:
	var results := RecoilPhysicsTest.run_all()
	var passed := true
	for value in results.values():
		if not value:
			passed = false
	print(JSON.stringify({"status": "passed" if passed else "failed", "results": results}))
	quit(0 if passed else 1)
