extends Node

## P3/P4 医疗系统回归测试入口。
## 运行：godot --headless --path . res://tests/medical_system_p4_runner.tscn
## 打印 JSON 结果，通过退出码 0/1 表示成功/失败。
##
## 历史：原为 extends SceneTree（--script 模式）。为纳入 tools/check.ps1 的场景回归
## 并与 tests/ 其余 runner 统一，已改为场景模式。

func _ready() -> void:
	_run.call_deferred()


func _run() -> void:
	var results := MedicalSystemP3Test.run_all()
	var passed := true
	for value in results.values():
		if not value:
			passed = false
	print(JSON.stringify({"status": "passed" if passed else "failed", "results": results}))
	get_tree().quit(0 if passed else 1)
