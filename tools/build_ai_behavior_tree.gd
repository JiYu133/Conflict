extends SceneTree

## Regenerates the default AI behaviour tree resource from code.
##   godot --headless --path . -s tools/build_ai_behavior_tree.gd
## Autoload "GlobalLogger" errors from the -s run are expected and harmless.
## WARNING: overwrites assets/config/ai/trees/ai_default_behavior_tree.tres. Once
## the tree has been edited in the LimboAI editor, edit it there instead.

const TREE_PATH := "res://assets/config/ai/trees/ai_default_behavior_tree.tres"
const TREE_UID := "uid://bh3ru3mbh5ens"
const TASKS := "res://classes/bot/limbo/tasks/"


func _init() -> void:
	var tree := BehaviorTree.new()
	tree.description = "Default AIPlayer behaviour: sense, then the highest-priority branch whose conditions hold."
	tree.root_task = _build_root()
	var error := ResourceSaver.save(tree, TREE_PATH)
	if error == OK:
		ResourceSaver.set_uid(TREE_PATH, ResourceUID.text_to_id(TREE_UID))
	print("build_ai_behavior_tree: ", error_string(error))
	quit(0 if error == OK else 1)


func _build_root() -> BTTask:
	var root := _composite(BTDynamicSequence.new(), "AI Root", [
		_task("sense_environment"),
		_composite(BTDynamicSelector.new(), "Decide (top = highest priority)", [
			_branch("Incapacitated", [_flag("is_incapacitated")],
				_task("hold_position", {crouch_when_holding = false})),
			_branch("Retreat", [_flag("retreat_order")],
				_composite(BTDynamicSelector.new(), "Hold at extraction or fall back", [
					_branch("Hold extraction", [_flag("at_extraction")],
						_task("hold_position", {face_var = &"last_known_enemy_position", profile_context = &"retreat"})),
					_task("move_to", {destination_var = &"rally_position", profile_context = &"retreat", run = true, sprint = true, release_weapon = true}),
				])),
			_branch("Clear malfunction", [_flag("weapon_malfunction")], _task("clear_malfunction")),
			_branch("Reload", [_flag("needs_reload")], _task("reload_weapon")),
			_branch("Ordered move (ignores enemies)", [_flag("command_ignores_enemies")], _task("follow_squad_command")),
			_branch("React to new target", [_flag("has_target"), _flag("target_visible"), _flag("target_reacted", false)],
				_task("hold_position", {face_var = &"target_position", profile_context = &"combat", crouch_when_holding = false})),
			_branch("Suppress", [_flag("has_target"), _flag("target_visible"), _flag("is_suppressing")],
				_engage(&"suppress")),
			_branch("Engage", [_flag("has_target"), _flag("target_visible"), _flag("target_in_range")],
				_engage(&"combat")),
			_branch("Follow squad command", [_flag("has_command")], _task("follow_squad_command")),
			_branch("Chase", [_flag("has_target"), _flag("target_visible")],
				_task("move_to", {destination_var = &"target_position", profile_context = &"combat"})),
			_branch("Search", [_flag("has_enemy_memory")], _task("search_last_known")),
			_branch("Move to objective", [_flag("at_objective", false)],
				_task("move_to", {destination_var = &"objective_position", run = true})),
			_task("hold_position", {custom_name = "Patrol objective (hold)"}),
		]),
	])
	return root


## Aim and fire run side by side; FireAtTarget only shoots while aim_ready.
func _engage(context: StringName) -> BTTask:
	var parallel := BTParallel.new()
	parallel.custom_name = "Aim + Fire (%s)" % context
	parallel.num_successes_required = 1
	parallel.num_failures_required = 1
	parallel.repeat = false
	parallel.add_child(_task("aim_at_target", {aim_provider = AISimpleAim.new(), profile_context = context}))
	parallel.add_child(_task("fire_at_target", {profile_context = context}))
	return parallel


## A dynamic sequence re-checks its conditions every tick, so a running action
## is aborted as soon as one of them stops holding.
func _branch(title: String, conditions: Array, action: BTTask) -> BTTask:
	return _composite(BTDynamicSequence.new(), title, conditions + [action])


func _composite(composite: BTTask, title: String, children: Array) -> BTTask:
	composite.custom_name = title
	for child in children:
		composite.add_child(child)
	return composite


func _flag(name: String, expected := true) -> BTTask:
	return _task("check_flag", {flag = StringName(name), expected = expected})


func _task(script_name: String, properties := {}) -> BTTask:
	var task := (load(TASKS + script_name + ".gd") as GDScript).new() as BTTask
	for key in properties:
		task.set(key, properties[key])
	return task
