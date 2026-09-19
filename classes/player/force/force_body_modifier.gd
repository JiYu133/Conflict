class_name ForceBodyModifier
extends SkeletonModifier3D

# ============================================================
# 力的骨骼姿态叠加器
# 功能：每帧先把上一帧改动过的骨骼还原到基准姿态，再重新应用当前力
#       产生的旋转与限幅位移。还原步骤是“每帧累加漂移”问题的根因修复：
#       不做还原的话，任何常驻力都会逐帧叠加成无限旋转。
# 用法：由 BasePlayer 在模型加载后创建，插在 SpineAimModifier 之后、
#       第一个 TwoBoneIK3D 之前，使 IK 拥有最终发言权。
# ============================================================

var _receiver: ForceReceiver = null
## 上一帧被改动过的骨骼及其基准姿态：bone_idx → {rotation, position}
var _touched: Dictionary = {}


## 绑定力接收器；骨架由 SkeletonModifier3D 的父节点自动解析。
func setup(receiver: ForceReceiver) -> void:
	_receiver = receiver
	_touched.clear()


func get_touched_bone_count() -> int:
	return _touched.size()


func _process_modification_with_delta(_delta: float) -> void:
	var skeleton := get_skeleton()
	if not skeleton:
		return
	# 第一步：还原基准姿态，杜绝跨帧累加。
	_restore_base(skeleton)
	if not is_instance_valid(_receiver):
		return
	var offsets := _receiver.get_pose_offsets()
	if offsets.is_empty():
		return
	_apply_offsets(skeleton, offsets)


# 内部 — 还原 ───────────────────────────────────────────────

func _restore_base(skeleton: Skeleton3D) -> void:
	if _touched.is_empty():
		return
	# 先深后浅：父骨骼的姿态会影响子骨骼，从叶子往根还原更稳妥。
	var indices := _touched.keys()
	indices.sort()
	var i := indices.size() - 1
	while i >= 0:
		var bone_idx: int = int(indices[i])
		i -= 1
		var entry: Dictionary = _touched[bone_idx]
		if bone_idx < 0 or bone_idx >= skeleton.get_bone_count():
			continue
		var rotation: Quaternion = entry["rotation"]
		var position: Vector3 = entry["position"]
		skeleton.set_bone_pose_rotation(bone_idx, rotation)
		skeleton.set_bone_pose_position(bone_idx, position)
	_touched.clear()


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
		_touched[bone_idx] = {
			"rotation": skeleton.get_bone_pose_rotation(bone_idx),
			"position": skeleton.get_bone_pose_position(bone_idx),
		}
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
