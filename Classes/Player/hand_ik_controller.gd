class_name HandIKController
extends Node

# 手写 FABRIK IK，驱动左臂（LeftArm → LeftForeArm → LeftHand）
# LeftShoulder 不参与 override，由动画自然驱动
# 不依赖 SkeletonIK3D（Godot 4 运行时动态创建有 build_chain 问题）

var _config: HandIKConfig

var _skeleton: Skeleton3D
var _bone_indices: Array[int] = []
var _rest_lengths: Array[float] = []
var _total_length: float = 0.0

var _left_hand_grip: Node3D
var _enabled: bool = false
var _suspended: bool = false
var _pending_weapon: BaseWeapon = null
var _ik_weight: float = 1.0
var _target_position_offset: Vector3 = Vector3.ZERO
var _target_rotation_offset: Vector3 = Vector3.ZERO
var _orientation_weight: float = 0.75


func initialize(_model_manager: PlayerModelManager, _lookup: ModelLookupConfig) -> void:
	pass


func setup(skeleton: Skeleton3D, config: HandIKConfig = null) -> void:
	_skeleton = skeleton
	_config = config if config else HandIKConfig.new()
	_bone_indices.clear()
	_rest_lengths.clear()
	_total_length = 0.0

	for bone_name in _config.bone_chain:
		var idx := skeleton.find_bone(bone_name)
		if idx == -1:
			GlobalLogger.error("HandIK", "骨骼未找到: %s" % bone_name)
			return
		_bone_indices.append(idx)

	for i in range(_bone_indices.size() - 1):
		var parent_pose: Transform3D = skeleton.get_bone_global_pose(_bone_indices[i])
		var child_pose: Transform3D  = skeleton.get_bone_global_pose(_bone_indices[i + 1])
		var len: float = (child_pose.origin - parent_pose.origin).length()
		if len < 0.001:
			len = skeleton.get_bone_rest(_bone_indices[i + 1]).origin.length()
		if len < 0.001:
			len = 0.15
		_rest_lengths.append(len)
		_total_length += len

	GlobalLogger.info("HandIK", "FABRIK 链就绪，链长=%.3f，段数=%d" % [_total_length, _bone_indices.size() - 1])

	if _pending_weapon:
		set_weapon(_pending_weapon, _ik_weight)


func set_weapon(weapon: BaseWeapon, ik_weight: float = -1.0) -> void:
	_left_hand_grip = null
	_enabled = false
	_clear_overrides()
	if not weapon:
		_pending_weapon = null
		return
	if _bone_indices.is_empty():
		_pending_weapon = weapon
		return
	_pending_weapon = null
	# ik_weight < 0 表示使用 config 默认值
	_ik_weight = ik_weight if ik_weight >= 0.0 else (_config.default_ik_weight if _config else 1.0)
	if weapon.config:
		_target_position_offset = weapon.config.left_hand_ik_position_offset
		_target_rotation_offset = weapon.config.left_hand_ik_rotation_offset_degrees
		_orientation_weight = weapon.config.left_hand_ik_orientation_weight
	_left_hand_grip = weapon.find_child("LeftHandGrip", true, false) as Node3D
	if not _left_hand_grip:
		GlobalLogger.warn("HandIK", "武器 '%s' 没有 LeftHandGrip 节点" % weapon.name)
		return
	_enabled = true
	GlobalLogger.info("HandIK", "左手 IK 启用: %s (weight=%.2f)" % [_left_hand_grip.get_path(), _ik_weight])


func process_ik(_delta: float) -> void:
	if _suspended or not _enabled or not _skeleton or not _left_hand_grip or _bone_indices.is_empty():
		return
	# Persistent overrides otherwise become next frame's input and make partial roll
	# corrections accumulate into a full forearm twist.
	_clear_overrides()

	var target_transform := _get_target_transform()
	var target_global: Vector3 = target_transform.origin
	var skel_xform: Transform3D = _skeleton.global_transform

	# 跳过 bone_chain[0]（LeftShoulder），IK 从 index 1 开始
	# Shoulder 由动画自然驱动，避免肩膀旋转夸张
	var ik_start := 1
	var ik_indices := _bone_indices.slice(ik_start)
	var ik_lengths := _rest_lengths.slice(ik_start)
	var ik_total   := 0.0
	for l in ik_lengths: ik_total += l

	# 读取 IK 链各骨骼当前全局位置
	var positions: Array[Vector3] = []
	for idx in ik_indices:
		positions.append((skel_xform * _skeleton.get_bone_global_pose(idx)).origin)
	var animated_positions := positions.duplicate()

	# 武器跟随右手移动时，左手目标可能瞬间超出自然臂展。将目标限制在
	# 可达区间内并保留少量肘部弯曲，避免极限伸直放大肘部蒙皮变形。
	var root_to_target := target_global - positions[0]
	var target_distance := root_to_target.length()
	if target_distance > 0.0001:
		var min_reach := ik_total * _config.min_reach_ratio
		var max_reach := ik_total * _config.max_reach_ratio
		var clamped_distance := clampf(target_distance, min_reach, max_reach)
		target_global = positions[0] + root_to_target * (clamped_distance / target_distance)
		target_transform.origin = target_global

	var iterations: int = _config.iterations if _config else 6
	var threshold: float = _config.threshold if _config else 0.0005

	# 目标超出链长时伸直
	if (target_global - positions[0]).length() >= ik_total:
		var dir: Vector3 = (target_global - positions[0]).normalized()
		for i in range(1, positions.size()):
			positions[i] = positions[i - 1] + dir * ik_lengths[i - 1]
	else:
		for _iter in range(iterations):
			positions[-1] = target_global
			for i in range(positions.size() - 2, -1, -1):
				var d: Vector3 = (positions[i] - positions[i + 1]).normalized()
				positions[i] = positions[i + 1] + d * ik_lengths[i]
			positions[0] = (skel_xform * _skeleton.get_bone_global_pose(ik_indices[0])).origin
			for i in range(1, positions.size()):
				var d: Vector3 = (positions[i] - positions[i - 1]).normalized()
				positions[i] = positions[i - 1] + d * ik_lengths[i - 1]
			if (positions[-1] - target_global).length() < threshold:
				break

	_apply_pole_constraint(positions, ik_lengths)
	_apply_poses(positions, animated_positions, ik_indices, target_transform)


## Temporarily releases IK ownership of the arm, e.g. while ragdoll physics is active.
func set_suspended(suspended: bool) -> void:
	if _suspended == suspended:
		return
	_suspended = suspended
	if _suspended:
		# Persistent overrides must be removed completely before PhysicalBone3D takes ownership.
		_skeleton.clear_bones_global_pose_override()


func _get_target_transform() -> Transform3D:
	var offset_basis := Basis.from_euler(Vector3(
		deg_to_rad(_target_rotation_offset.x),
		deg_to_rad(_target_rotation_offset.y),
		deg_to_rad(_target_rotation_offset.z)
	))
	return _left_hand_grip.global_transform * Transform3D(offset_basis, _target_position_offset)


func _apply_pole_constraint(positions: Array[Vector3], lengths: Array[float]) -> void:
	if positions.size() < 3:
		return

	var influence: float = _config.pole_influence if _config else 0.6
	if influence <= 0.0:
		return

	var pole_vec: Vector3 = _config.pole_vector if _config else Vector3(0.0, -1.0, 0.5)

	var root: Vector3 = positions[0]   # LeftArm
	var mid: Vector3  = positions[1]   # LeftForeArm
	var tip: Vector3  = positions[2]   # LeftHand

	var axis: Vector3       = (tip - root).normalized()
	var pole_global: Vector3 = _skeleton.global_transform.basis * pole_vec

	var mid_proj:  Vector3 = mid        - root - axis * (mid        - root).dot(axis)
	var pole_proj: Vector3 = pole_global - axis * pole_global.dot(axis)

	if mid_proj.length() < 0.0001 or pole_proj.length() < 0.0001:
		return

	var angle: float = mid_proj.normalized().signed_angle_to(pole_proj.normalized(), axis) * influence
	var rot: Basis   = Basis(axis, angle)
	positions[1] = root + rot * (mid - root).normalized() * lengths[0]


func _apply_poses(
	positions: Array[Vector3],
	animated_positions: Array[Vector3],
	ik_indices: Array[int],
	target_transform: Transform3D
) -> void:
	var skel_xform: Transform3D = _skeleton.global_transform
	var skel_inv: Transform3D   = skel_xform.affine_inverse()
	var grip_basis: Basis       = target_transform.basis
	var forearm_local_idx: int  = ik_indices.size() - 2  # LeftForeArm 在 ik_indices 里的位置
	var roll_align: float       = _config.forearm_roll_align if _config else 0.5

	for i in range(ik_indices.size() - 1):
		var bone_idx: int = ik_indices[i]
		var from: Vector3 = positions[i]
		var to: Vector3   = positions[i + 1]

		var current_global: Transform3D = skel_xform * _skeleton.get_bone_global_pose(bone_idx)
		var target_dir: Vector3  = (to - from).normalized()
		# Derive the animated bone axis from its joints. Mixamo imports do not guarantee
		# that every limb's local Y axis points toward its child.
		var current_dir: Vector3 = (animated_positions[i + 1] - animated_positions[i]).normalized()

		if current_dir.length() < 0.001 or target_dir.length() < 0.001:
			continue

		var rotation: Basis
		if i == forearm_local_idx and roll_align > 0.0:
			# 前臂：方向对齐后，额外做 roll 对齐让前臂与手腕齐平
			var q_align := Quaternion(current_dir, target_dir)
			var aligned  := Basis(q_align) * current_global.basis
			var proj_aligned := (aligned.z   - target_dir * aligned.z.dot(target_dir)).normalized()
			var proj_grip    := (grip_basis.z - target_dir * grip_basis.z.dot(target_dir)).normalized()
			if proj_aligned.length() > 0.001 and proj_grip.length() > 0.001:
				var roll_angle := proj_aligned.signed_angle_to(proj_grip, target_dir) * roll_align
				rotation = Basis(Quaternion(target_dir, roll_angle)) * aligned
			else:
				rotation = aligned
		else:
			if not current_dir.is_equal_approx(target_dir):
				rotation = Basis(Quaternion(current_dir, target_dir)) * current_global.basis
			else:
				rotation = current_global.basis

		var new_local := skel_inv * Transform3D(rotation, from)
		_skeleton.set_bone_global_pose_override(bone_idx, new_local, _ik_weight, true)

	# 手腕位置到达目标，但朝向只部分跟随，保留动画中的自然腕部旋转。
	var hand_idx: int = ik_indices[-1]
	var animated_hand := skel_xform * _skeleton.get_bone_global_pose(hand_idx)
	var hand_rotation := animated_hand.basis.get_rotation_quaternion().slerp(
		grip_basis.get_rotation_quaternion(), _orientation_weight
	)
	var softened_target := Transform3D(Basis(hand_rotation), target_transform.origin)
	var grip_local: Transform3D = skel_inv * softened_target
	_skeleton.set_bone_global_pose_override(hand_idx, grip_local, _ik_weight, true)


func _clear_overrides() -> void:
	if not _skeleton or _bone_indices.is_empty():
		return
	# 从 index 1 开始（跳过 LeftShoulder）
	for i in range(1, _bone_indices.size()):
		_skeleton.set_bone_global_pose_override(_bone_indices[i], Transform3D.IDENTITY, 0.0, false)
