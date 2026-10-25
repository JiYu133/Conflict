extends Node

var failures := 0

func _check(ok: bool, message: String) -> void:
	if not ok:
		failures += 1
		push_error(message)

func _ready() -> void:
	var skeleton := Skeleton3D.new()
	add_child(skeleton)
	skeleton.rotation = Vector3(0.2, 0.7, -0.1)
	skeleton.add_bone("parent")
	skeleton.add_bone("child")
	skeleton.set_bone_parent(1, 0)
	skeleton.set_bone_rest(0, Transform3D(Basis.from_euler(Vector3(0.3, -0.4, 0.2)), Vector3.ZERO))
	skeleton.set_bone_rest(1, Transform3D(Basis.from_euler(Vector3(-0.6, 0.1, 0.8)), Vector3.UP))
	skeleton.reset_bone_poses()
	var force := ForceBodyModifier.new()
	skeleton.add_child(force)
	for bone_idx in [0, 1]:
		skeleton.reset_bone_poses()
		var position_before := skeleton.global_transform * skeleton.get_bone_global_pose(bone_idx).origin
		var translation := Vector3(0.05, -0.02, 0.03)
		force._apply_translation(skeleton, bone_idx, translation)
		var position_after := skeleton.global_transform * skeleton.get_bone_global_pose(bone_idx).origin
		_check((position_after - position_before).distance_to(translation) < 0.0001, "force translation stays in world space for root and child bones")
		var before := (skeleton.global_basis * skeleton.get_bone_global_pose(bone_idx).basis).get_rotation_quaternion()
		var delta := Quaternion(Vector3(1, 2, -1).normalized(), deg_to_rad(30.0))
		force._apply_rotation(skeleton, bone_idx, Vector3(1, 2, -1).normalized(), deg_to_rad(30.0))
		var actual := (skeleton.global_basis * skeleton.get_bone_global_pose(bone_idx).basis).get_rotation_quaternion()
		_check(actual.angle_to(delta * before) < 0.002, "force rotation uses current parent world space without applying rest twice")
	skeleton.queue_free()
	print("force_pose_regression=%s failures=%d" % ["ok" if failures == 0 else "failed", failures])
	get_tree().quit(0 if failures == 0 else 1)
