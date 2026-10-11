@tool
extends BTCondition

## 检查黑板上的布尔变量。Succeeds when a boolean blackboard variable equals
## `expected`. Missing variables count as false.

@export var flag: StringName = &"has_target"
@export var expected: bool = true


func _generate_name() -> String:
	return ("%s" if expected else "not %s") % LimboUtility.decorate_var(flag)


func _tick(_delta: float) -> Status:
	var value: bool = blackboard.get_var(flag, false, false) == true
	return SUCCESS if value == expected else FAILURE
