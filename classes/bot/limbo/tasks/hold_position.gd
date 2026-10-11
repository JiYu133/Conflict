@tool
extends BTAction

## 原地停住，可选朝向黑板里的某个位置。永远 RUNNING，适合作为兜底分支。
## Stands still, optionally facing a Vector3 blackboard variable. Always RUNNING.

## Optional Vector3 variable to look at; leave empty to keep the current heading.
@export var face_var: StringName = &""
@export var profile_context: StringName = &"calm"
## Crouch when the profile's crouch_while_holding is on.
@export var crouch_when_holding: bool = true
@export var release_weapon: bool = true


func _generate_name() -> String:
	if face_var == &"":
		return "Hold Position"
	return "Hold Position, face %s" % LimboUtility.decorate_var(face_var)


func _enter() -> void:
	var brain := AIBT.brain_of(agent)
	if not brain:
		return
	brain.activity = get_task_name()
	brain.stop()
	if release_weapon:
		brain.release_weapon()
	brain.set_stance(crouch_when_holding and brain.get_profile(profile_context).crouch_while_holding)


func _tick(_delta: float) -> Status:
	var brain := AIBT.brain_of(agent)
	if not brain:
		return FAILURE
	brain.stop()
	var look_at: Variant = AIBT.get_position(blackboard, face_var) if face_var != &"" else null
	if look_at != null and look_at != Vector3.ZERO:
		brain.face(look_at)
	return RUNNING
