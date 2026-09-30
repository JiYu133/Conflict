class_name ForceBodyModifier
extends SkeletonModifier3D

# ============================================================
# 力的骨骼姿态叠加器
# 功能：把当前力产生的旋转与限幅位移叠加到当前帧的上游骨骼姿态。
#       SkeletonModifier3D 执行前已经收到动画和前序 modifier 的新姿态；
#       不能回写上一帧缓存，否则后坐力结束时会插入旧姿势并产生跳变。
# 用法：由 BasePlayer 在模型加载后创建，插在 SpineAimModifier 之后、
#       第一个 TwoBoneIK3D 之前，使 IK 拥有最终发言权。
# ============================================================

var _receiver: ForceReceiver = null


## 绑定力接收器；骨架由 SkeletonModifier3D 的父节点自动解析。
func setup(receiver: ForceReceiver) -> void:
	_receiver = receiver


func get_touched_bone_count() -> int:
	# Compatibility/debug API. No cross-frame pose state is retained.
	return 0


func _process_modification_with_delta(_delta: float) -> void:
	var skeleton := get_skeleton()
	if not skeleton:
		return
	if not is_instance_valid(_receiver):
		return
	var offsets := _receiver.get_pose_offsets()
	if offsets.is_empty():
		return
	_apply_offsets(skeleton, offsets)


# 内部 — 应用 ───────────────────────────────────────────────

func _apply_offsets(skeleton: Skeleton3D, offsets: Dictionary) -> void:
	var bone_count := skeleton.get_bone_count()
	# 自上而下应用，保证父骨骼的全局姿态在子骨骼换算前已经就绪。
	var indices := offsets.keys()
	indices.sort()
	for bone_idx_value in indices:
		var bone_idx: int = int(bone_idx_value)
		if bone_idx < 0 or bone_idx >= bone_count:
			continue
		var entry: Dictionary = offsets[bone_idx_value]
		_apply_translation(skeleton, bone_idx, entry.get("translation", Vector3.ZERO))
		_apply_rotation(skeleton, bone_idx, entry.get("axis", Vector3.ZERO), float(entry.get("angle", 0.0)))


## 位移叠加：把世界空间的位移换算到父骨骼空间后加到骨骼局部位置上。
func _apply_translation(skeleton: Skeleton3D, bone_idx: int, translation: Vector3) -> void:
	if not translation.is_finite() or translation.length_squared() <= 0.0:
		return
	var parent_basis := _parent_basis(skeleton, bone_idx)
	var local_translation := parent_basis.inverse() * translation
	if not local_translation.is_finite():
		return
	var result := skeleton.get_bone_pose_position(bone_idx) + local_translation
	if result.is_finite():
		skeleton.set_bone_pose_position(bone_idx, result)


## 旋转叠加：沿用 SpineAimModifier 已验证的“父骨骼 basis⁻¹ → 全局旋转
## → 骨骼局部”换算，使传入的世界空间轴在任意父级朝向下都成立。
func _apply_rotation(skeleton: Skeleton3D, bone_idx: int, axis: Vector3, angle: float) -> void:
	if not axis.is_finite() or not is_finite(angle) or absf(angle) <= 0.000001:
		return
	if axis.length_squared() <= 0.0000001:
		return
	var global_extra := Quaternion(axis.normalized(), angle)
	var parent_basis := _parent_basis(skeleton, bone_idx)
	var rest_basis := skeleton.get_bone_rest(bone_idx).basis.orthonormalized()
	var parent_extra := Quaternion(parent_basis).inverse() * global_extra * Quaternion(parent_basis)
	var local_extra := Quaternion(rest_basis).inverse() * parent_extra * Quaternion(rest_basis)
	var result := (local_extra * skeleton.get_bone_pose_rotation(bone_idx)).normalized()
	if result.is_finite():
		skeleton.set_bone_pose_rotation(bone_idx, result)


func _parent_basis(skeleton: Skeleton3D, bone_idx: int) -> Basis:
	var parent_idx := skeleton.get_bone_parent(bone_idx)
	if parent_idx < 0:
		return Basis.IDENTITY
	return skeleton.get_bone_global_pose(parent_idx).basis.orthonormalized()
