class_name TwoBoneIK
extends RefCounted

# ============================================================
# 两骨 IK 解析求解与骨骼旋转工具
#
# 输入的目标点 / pole 都是世界坐标；内部换算到 Skeleton 空间计算，
# 模型根节点的缩放和 180° 朝向修正不会混进骨骼旋转。
# 只旋转根骨骼与中间骨骼，末端骨骼的朝向由调用方单独决定。
# ============================================================


## 旋转 root / middle，使 end 骨骼原点到达 target，并在朝向 pole 的平面内弯曲。
## 超出链长的目标会让链条伸直指向它，不会拉长骨骼。
static func solve(skeleton: Skeleton3D, root: int, middle: int, end: int, target_world: Vector3, pole_world: Vector3) -> void:
	var to_skeleton := skeleton.global_transform.affine_inverse()
	var target := to_skeleton * target_world
	var pole := to_skeleton * pole_world
	var root_pos := skeleton.get_bone_global_pose(root).origin
	var middle_pos := skeleton.get_bone_global_pose(middle).origin
	var end_pos := skeleton.get_bone_global_pose(end).origin
	var upper := root_pos.distance_to(middle_pos)
	var lower := middle_pos.distance_to(end_pos)
	var reach := target - root_pos
	if upper < 0.00001 or lower < 0.00001 or reach.length_squared() < 0.0000001:
		return

	var direction := reach.normalized()
	var distance := clampf(reach.length(), absf(upper - lower) + 0.0001, upper + lower - 0.0001)
	var bend := _perpendicular(pole - root_pos, direction)
	if bend == Vector3.ZERO:
		bend = _perpendicular(middle_pos - root_pos, direction)
	if bend == Vector3.ZERO:
		bend = _perpendicular(Vector3.UP if absf(direction.y) < 0.9 else Vector3.RIGHT, direction)

	# 余弦定理求肩/髋处的张角，得到中间关节应在的位置。
	var cos_root := clampf((upper * upper + distance * distance - lower * lower) / (2.0 * upper * distance), -1.0, 1.0)
	var solved_middle := root_pos + direction * (upper * cos_root) + bend * (upper * sqrt(1.0 - cos_root * cos_root))
	var solved_end := root_pos + direction * distance

	aim_bone(skeleton, root, middle_pos - root_pos, solved_middle - root_pos)
	var middle_now := skeleton.get_bone_global_pose(middle).origin
	aim_bone(skeleton, middle, skeleton.get_bone_global_pose(end).origin - middle_now, solved_end - middle_now)


## 以最短弧把骨骼从 from 方向转到 to 方向（Skeleton 空间）。
static func aim_bone(skeleton: Skeleton3D, bone: int, from_dir: Vector3, to_dir: Vector3) -> void:
	if from_dir.length_squared() < 0.0000001 or to_dir.length_squared() < 0.0000001:
		return
	var from := from_dir.normalized()
	var to := to_dir.normalized()
	var arc: Quaternion
	if from.dot(to) < -0.9999:
		arc = Quaternion(_perpendicular(Vector3.UP if absf(from.y) < 0.9 else Vector3.RIGHT, from), PI)
	else:
		arc = Quaternion(from, to)
	apply_skeleton_rotation(skeleton, bone, arc)


## 在 Skeleton 空间对骨骼追加一次旋转（作用于骨骼当前的全局朝向）。
static func apply_skeleton_rotation(skeleton: Skeleton3D, bone: int, delta: Quaternion) -> void:
	var parent_rotation := _parent_rotation(skeleton, bone)
	var local_delta := parent_rotation.inverse() * delta * parent_rotation
	skeleton.set_bone_pose_rotation(bone, (local_delta * skeleton.get_bone_pose_rotation(bone)).normalized())


## 在世界空间对骨骼追加一次旋转。
static func apply_world_rotation(skeleton: Skeleton3D, bone: int, delta: Quaternion) -> void:
	var skeleton_rotation := skeleton.global_basis.get_rotation_quaternion()
	apply_skeleton_rotation(skeleton, bone, skeleton_rotation.inverse() * delta * skeleton_rotation)


## 把骨骼的世界朝向向 world_basis 混合 weight（0..1）。
static func blend_world_rotation(skeleton: Skeleton3D, bone: int, world_basis: Basis, weight: float) -> void:
	var desired := skeleton.global_basis.get_rotation_quaternion().inverse() * world_basis.get_rotation_quaternion()
	var local := _parent_rotation(skeleton, bone).inverse() * desired
	var current := skeleton.get_bone_pose_rotation(bone)
	skeleton.set_bone_pose_rotation(bone, current.slerp(local, clampf(weight, 0.0, 1.0)).normalized())


static func bone_world_transform(skeleton: Skeleton3D, bone: int) -> Transform3D:
	return skeleton.global_transform * skeleton.get_bone_global_pose(bone)


static func bone_world_position(skeleton: Skeleton3D, bone: int) -> Vector3:
	return skeleton.global_transform * skeleton.get_bone_global_pose(bone).origin


static func _parent_rotation(skeleton: Skeleton3D, bone: int) -> Quaternion:
	var parent := skeleton.get_bone_parent(bone)
	if parent < 0:
		return Quaternion.IDENTITY
	return skeleton.get_bone_global_pose(parent).basis.get_rotation_quaternion()


static func _perpendicular(vector: Vector3, axis: Vector3) -> Vector3:
	var result := vector - axis * vector.dot(axis)
	if result.length_squared() < 0.0000001:
		return Vector3.ZERO
	return result.normalized()
