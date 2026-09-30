extends SceneTree

## 力系统测试入口。
## 运行：godot --headless --path . --script res://tests/force_system_runner.gd
## 打印 JSON 结果，通过退出码 0/1 表示成功/失败。
##
## 注意：--script 模式下 autoload 标识符（GlobalLogger 等）在 _init() 的
## 编译期不可解析。因此运行器本身不能静态引用任何依赖 autoload 的脚本，
## 必须在延迟调用里通过 load() 动态取用——此时 autoload 已注册完毕。

func _init() -> void:
	_run.call_deferred()


func _run() -> void:
	var test_script: GDScript = load("res://tests/force_system_test.gd")
	if test_script == null or not test_script.can_instantiate():
		print(JSON.stringify({
			"status": "failed",
			"results": {"test_script_loaded": false},
		}))
		quit(1)
		return
	var results: Dictionary = test_script.run_all()
	var passed := true
	for key in results:
		if not results[key]:
			passed = false
	print(JSON.stringify({"status": "passed" if passed else "failed", "results": results}))
	quit(0 if passed else 1)
