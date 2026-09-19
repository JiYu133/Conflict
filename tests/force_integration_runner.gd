extends SceneTree

## 力系统端到端集成测试：加载真实玩家场景，验证修饰器插槽顺序、
## 受击信号接线、以及骨骼姿态在真实动画管线下的实际变化。
## 运行：godot --headless --path . --script res://tests/force_integration_runner.gd
##
## 与 force_system_runner.gd 同理，运行器本身不能静态引用依赖 autoload
## 的脚本，动态 load() 必须在延迟调用里执行。

const PLAYER_SCENE := "res://assets/map/test_map.tscn"


func _init() -> void:
	_run.call_deferred()


func _run() -> void:
	var results := {}
	var packed: PackedScene = load(PLAYER_SCENE)
	if packed == null:
		results["scene_loaded"] = false
		_finish(results)
		return
	results["scene_loaded"] = true
	var map := packed.instantiate()
	root.add_child(map)
	# 等待模型异步加载与各子系统初始化完成
	for _frame in 30:
		await process_frame

	var player := _find_player(map)
	results["player_found"] = player != null
	if player == null:
		_finish(results)
		return

	var receiver = player.force_receiver
	results["force_receiver_present"] = receiver != null
	if receiver == null:
		_finish(results)
		return

	var skeleton: Skeleton3D = player.model_manager.skeleton
	results["skeleton_present"] = skeleton != null
	if skeleton == null:
		_finish(results)
		return

	# 修饰器必须存在，且排在 SpineAimModifier 之后、第一个 TwoBoneIK3D 之前
	var modifier = null
	var spine_index := -1
	var force_index := -1
	var ik_index := -1
	var child_index := 0
	for child in skeleton.get_children():
		if child.get_script() != null and String(child.get_script().resource_path).ends_with("force_body_modifier.gd"):
			modifier = child
			force_index = child_index
		elif child.name == "SpineAimModifier":
			spine_index = child_index
		elif child is TwoBoneIK3D and ik_index < 0:
			ik_index = child_index
		child_index += 1
	results["force_modifier_present"] = modifier != null
	results["spine_aim_before_force"] = spine_index >= 0 and force_index > spine_index
	results["force_before_first_ik"] = force_index >= 0 and ik_index >= 0 and force_index < ik_index

	# 受击必须产生姿态偏移，并且真的改写骨骼姿态
	var bone_name := "mixamorig_Spine1"
	var bone_idx := skeleton.find_bone(bone_name)
	results["spine_bone_found"] = bone_idx >= 0
	if bone_idx >= 0:
		var info := DamageInfo.new()
		info.amount = 2200.0
		info.type = MedicalEnums.DamageType.BULLET
		info.body_part = MedicalEnums.BodyPartId.TORSO
		info.direction = Vector3.BACK
		info.impact_mass_kg = 0.0079
		info.hit_position = player.global_position
		player.health_system.apply_damage(info)
		receiver.update_pose_offsets(0.016)
		results["impact_created_offset"] = not receiver.get_pose_offsets().is_empty()
		results["impact_created_pending_impulse"] = not receiver.consume_pending_impulse().is_empty()
		var base_rotation := skeleton.get_bone_pose_rotation(bone_idx)
		if modifier:
			modifier._process_modification_with_delta(0.016)
			results["bone_pose_changed"] = not skeleton.get_bone_pose_rotation(bone_idx).is_equal_approx(base_rotation)
			results["bone_pose_finite"] = (
				skeleton.get_bone_pose_rotation(bone_idx).is_finite()
				and skeleton.get_bone_pose_position(bone_idx).is_finite()
			)
		else:
			results["bone_pose_changed"] = false
			results["bone_pose_finite"] = false

	# 摄像机不参与本期力系统：不应因命中产生异常偏转接口调用
	results["camera_untouched_by_force"] = not receiver.has_method("apply_camera_force")

	# revive() 后待用冲量必须被清空
	player.is_alive = false
	player.revive()
	results["revive_clears_pending_impulse"] = receiver.consume_pending_impulse().is_empty()
	results["revive_clears_pose"] = receiver.get_pose_offsets().is_empty()

	map.queue_free()
	_finish(results)


func _find_player(node: Node) -> Node:
	# 用脚本路径判定，避免在 --script 模式下静态引用 BasePlayer
	# （其编译期依赖 GlobalLogger，会导致整个运行器无法编译）。
	var script: Variant = node.get_script()
	if script != null and String(script.resource_path).ends_with("base_player.gd") and not node.get("is_ai_player"):
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
	print(JSON.stringify({"status": "passed" if passed else "failed", "results": results}))
	quit(0 if passed else 1)
