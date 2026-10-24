extends Node

## 力系统测试入口。
## 运行：godot --headless --path . res://tests/force_system_runner.tscn
## 打印 JSON 结果，通过退出码 0/1 表示成功/失败。
##
## 历史：原为 extends SceneTree（--script 模式）。为纳入 tools/check.ps1 的场景回归
## 并与 tests/ 其余 runner 统一，已改为场景模式（同 force_integration_runner）。
## 运行器本身仍不静态引用任何依赖 autoload 的脚本，测试体在延迟调用里 load()。

func _ready() -> void:
	_run.call_deferred()


func _run() -> void:
	var test_script: GDScript = load("res://tests/force_system_test.gd")
	if test_script == null or not test_script.can_instantiate():
		print(JSON.stringify({
			"status": "failed",
			"results": {"test_script_loaded": false},
		}))
		get_tree().quit(1)
		return
	var results: Dictionary = test_script.run_all()
	var passed := true
	for key in results:
		if not results[key]:
			passed = false
	print(JSON.stringify({"status": "passed" if passed else "failed", "results": results}))
	get_tree().quit(0 if passed else 1)
