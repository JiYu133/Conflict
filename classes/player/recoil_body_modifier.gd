class_name RecoilBodyModifier
extends SkeletonModifier3D

var recoil: RecoilComponent
var config: PlayerRecoilConfig
var _recoil_enabled: bool = true
var _bones: Array[Dictionary] = []


func set_enabled(value: bool) -> void:
	_recoil_enabled = value


func set_recoil_component(component: RecoilComponent) -> void:
	recoil = component


func setup(component: RecoilComponent, recoil_config: PlayerRecoilConfig) -> void:
	recoil = component
	config = recoil_config if is_instance_valid(recoil_config) else PlayerRecoilConfig.new()
	_collect_bones()


func _collect_bones() -> void:
	_bones.clear()
	var skeleton := get_skeleton()
	if not skeleton:
		return
	# Apply the physical transform once at the arm-chain root. The upper arm,
	# forearm, and elbow then inherit the exact rigid displacement; applying the
	# same recoil to each descendant would multiply the real motion.
	_add_bone(skeleton, ["mixamorig_RightShoulder", "RightShoulder", "mixamorig_RightArm", "RightArm", "Arm_R"], true)


func _add_bone(skeleton: Skeleton3D, names: Array[String], translation_source: bool = false) -> void:
	for name in names:
		var index := skeleton.find_bone(name)
		if index >= 0:
			_bones.append({
				"index": index,
				"translation_source": translation_source,
				"base_rotation": Quaternion.IDENTITY,
				"base_position": Vector3.ZERO,
				"has_base": false,
			})
			return


func _process_modification() -> void:
	var skeleton := get_skeleton()
	if not skeleton or _bones.is_empty():
		return
	_restore_base(skeleton)
	if not _recoil_enabled or not is_instance_valid(recoil):
		return
	var pose := recoil.get_pose_snapshot()
	var rotation := Vector3(
		float(pose.get("pitch_rad", 0.0)),
		float(pose.get("yaw_rad", 0.0)),
		float(pose.get("roll_rad", 0.0))
	)
	var translation: Vector3 = pose.get("position_local", Vector3.ZERO)
	if not rotation.is_finite() or not translation.is_finite():
		return
	var recoil_basis := _get_recoil_basis()
	for entry in _bones:
		var index: int = entry["index"]
		entry["base_rotation"] = skeleton.get_bone_pose_rotation(index)
		entry["base_position"] = skeleton.get_bone_pose_position(index)
		entry["has_base"] = true
		_apply_rotation(skeleton, index, rotation, recoil_basis)
		if bool(entry.get("translation_source", false)):
			_apply_translation(skeleton, index, translation, recoil_basis)


func _restore_base(skeleton: Skeleton3D) -> void:
	for i in range(_bones.size() - 1, -1, -1):
		var entry: Dictionary = _bones[i]
		if not bool(entry.get("has_base", false)):
			continue
		var index: int = entry["index"]
		skeleton.set_bone_pose_rotation(index, entry["base_rotation"])
		skeleton.set_bone_pose_position(index, entry["base_position"])
		entry["has_base"] = false


func _get_recoil_basis() -> Basis:
	if is_instance_valid(recoil):
		var weapon := recoil.get_parent() as Node3D
		if is_instance_valid(weapon):
			return weapon.global_transform.basis.orthonormalized()
	return get_skeleton().global_transform.basis.orthonormalized()


func _apply_rotation(skeleton: Skeleton3D, bone_idx: int, euler: Vector3, source_basis: Basis) -> void:
	if bone_idx < 0 or not euler.is_finite():
		return
	var parent_idx := skeleton.get_bone_parent(bone_idx)
	var parent_basis := Basis.IDENTITY
	if parent_idx >= 0:
		parent_basis = skeleton.get_bone_global_pose(parent_idx).basis.orthonormalized()
	var world_extra := Quaternion(source_basis.x, euler.x) \
		* Quaternion(source_basis.y, euler.y) \
		* Quaternion(source_basis.z, euler.z)
	var local_extra := Quaternion(parent_basis).inverse() * world_extra * Quaternion(parent_basis)
	var result := (local_extra * skeleton.get_bone_pose_rotation(bone_idx)).normalized()
	if result.is_finite():
		skeleton.set_bone_pose_rotation(bone_idx, result)


func _apply_translation(skeleton: Skeleton3D, bone_idx: int, translation: Vector3, source_basis: Basis) -> void:
	if not translation.is_finite():
		return
	var parent_idx := skeleton.get_bone_parent(bone_idx)
	var parent_basis := Basis.IDENTITY
	if parent_idx >= 0:
		parent_basis = skeleton.get_bone_global_pose(parent_idx).basis.orthonormalized()
	var local_translation := parent_basis.inverse() * (source_basis * translation)
	var result := skeleton.get_bone_pose_position(bone_idx) + local_translation
	if result.is_finite():
		skeleton.set_bone_pose_position(bone_idx, result)
