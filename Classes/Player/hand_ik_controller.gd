class_name HandIKController
extends Node

# 手写 FABRIK IK，驱动左臂（LeftArm → LeftForeArm → LeftHand）
# LeftShoulder 由 shoulder_ik_weight 做轻微修正，避免超伸
# 支持运动状态权重平滑过渡、ADS 目标偏移、每把武器本地偏移微调

var _config: HandIKConfig

var _skeleton: Skeleton3D
var _bone_indices: Array[int] = []
var _rest_lengths: Array[float] = []
var _total_length: float = 0.0

var _left_hand_grip: Node3D
var _enabled: bool = false
var _pending_weapon: BaseWeapon = null
var _ik_weight: float = 1.0       # 武器基础权重（来自 WeaponConfig）

# 运动/ADS 状态
var _is_running: bool = false
var _is_sprinting: bool = false
var _is_ads: bool = false

# 平滑权重
var _current_weight: float = 1.0  # 每帧实际使用的权重
var _target_weight: float = 1.0

# ADS 过渡进度
var _ads_progress: float = 0.0


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
	_ik_weight = ik_weight if ik_weight >= 0.0 else (_config.default_ik_weight if _config else 1.0)
	_update_target_weight()
	_current_weight = _target_weight  # 换枪时不过渡，直接跳到目标权重
	_left_hand_grip = weapon.find_child("LeftHandGrip", true, false) as Node3D
	if not _left_hand_grip:
		GlobalLogger.warn("HandIK", "武器 '%s' 没有 LeftHandGrip 节点" % weapon.name)
		return
	_enabled = true
	GlobalLogger.info("HandIK", "左手 IK 启用: %s (weight=%.2f)" % [_left_hand_grip.get_path(), _ik_weight])


## 由 BasePlayer 在运动状态变化时调用
func set_movement_state(running: bool, sprinting: bool) -> void:
	_is_running = running
	_is_sprinting = sprinting
	_update_target_weight()


## 由 BasePlayer 在 ADS 状态变化时调用
func set_ads_state(ads: bool) -> void:
	_is_ads = ads
	_update_target_weight()


func _update_target_weight() -> void:
	var base := _ik_weight
	if _is_sprinting:
		_target_weight = base * (_config.sprint_ik_weight if _config else 0.1)
	elif _is_running:
		_target_weight = base * (_config.run_ik_weight if _config else 0.6)
	elif _is_ads:
		_target_weight = base * (_config.ads_ik_weight if _config else 0.8)
	else:
		_target_weight = base * (_config.walk_ik_weight if _config else 1.0)


func process_ik(delta: float) -> void:
	if not _enabled or not _skeleton or not _left_hand_grip or _bone_indices.is_empty():
		return

	# ── 1. 平滑权重（EFT 风格：状态切换约 0.12s 过渡）──────────
	var blend_time := maxf(_config.weight_blend_time if _config else 0.12, 0.001)
	_current_weight = move_toward(_current_weight, _target_weight, delta / blend_time)

	# ── 2. 平滑 ADS 进度 ────────────────────────────────────────
	var ads_time := maxf(_config.ads_blend_time if _config else 0.25, 0.001)
	_ads_progress = move_toward(_ads_progress, 1.0 if _is_ads else 0.0, delta / ads_time)

	# 权重为零时跳过求解，但保持 override 为 0（不清空，避免一帧跳变）
	if _current_weight < 0.001:
		_clear_overrides_weighted()
		return

	# ── 3. 计算有效目标变换（叠加本地偏移 + ADS 偏移）──────────
	var effective_target := _get_effective_target()
	var target_global := effective_target.origin

	var skel_xform: Transform3D = _skeleton.global_transform

	# 跳过 bone_chain[0]（LeftShoulder），IK 从 index 1 开始
	var ik_start := 1
	var ik_indices := _bone_indices.slice(ik_start)
	var ik_lengths := _rest_lengths.slice(ik_start)
	var ik_total := 0.0
	for l in ik_lengths:
		ik_total += l

	# ── 4. 读取 IK 链各骨骼当前全局位置 ────────────────────────
	var positions: Array[Vector3] = []
	for idx in ik_indices:
		positions.append((skel_xform * _skeleton.get_bone_global_pose(idx)).origin)

	# 根点固定（防止跑动时抽搐）
	var root_pos: Vector3 = positions[0]

	var iterations: int = _config.iterations if _config else 6
	var threshold: float = _config.threshold if _config else 0.0005

	# ── 5. FABRIK 求解 ───────────────────────────────────────────
	if (target_global - root_pos).length() >= ik_total:
		var dir: Vector3 = (target_global - root_pos).normalized()
		for i in range(1, positions.size()):
			positions[i] = positions[i - 1] + dir * ik_lengths[i - 1]
	else:
		for _iter in range(iterations):
			positions[-1] = target_global
			for i in range(positions.size() - 2, -1, -1):
				var d: Vector3 = (positions[i] - positions[i + 1]).normalized()
				positions[i] = positions[i + 1] + d * ik_lengths[i]
			positions[0] = root_pos
			for i in range(1, positions.size()):
				var d: Vector3 = (positions[i] - positions[i - 1]).normalized()
				positions[i] = positions[i - 1] + d * ik_lengths[i - 1]
			if (positions[-1] - target_global).length() < threshold:
				break

	_apply_pole_constraint(positions, ik_lengths)
	_apply_poses(positions, ik_indices, effective_target)


func _get_effective_target() -> Transform3D:
	var base := _left_hand_grip.global_transform
	# 常规偏移（始终叠加，在 LeftHandGrip 本地坐标系中）
	var pos_off := base.basis * (_config.grip_position_offset if _config else Vector3.ZERO)
	var rot_deg := (_config.grip_rotation_offset if _config else Vector3.ZERO)
	var rot_basis := Basis.from_euler(rot_deg * (PI / 180.0))
	var result := Transform3D(rot_basis * base.basis, base.origin + pos_off)
	# ADS 额外偏移（按 _ads_progress 插值）
	if _ads_progress > 0.001 and _config:
		var ads_pos := base.basis * _config.ads_grip_offset * _ads_progress
		var ads_rot_basis := Basis.from_euler(_config.ads_grip_rotation * (PI / 180.0))
		result.origin += ads_pos
		result.basis = result.basis.slerp(ads_rot_basis * result.basis, _ads_progress)
	return result


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

	var axis: Vector3        = (tip - root).normalized()
	var pole_global: Vector3 = _skeleton.global_transform.basis * pole_vec

	# 去掉各向量在 axis 方向上的分量，得到垂直于链轴的平面投影
	var mid_proj_vec:  Vector3 = mid        - root - axis * (mid        - root).dot(axis)
	var pole_proj_vec: Vector3 = pole_global       - axis * pole_global.dot(axis)

	var mp_len := mid_proj_vec.length()
	var pp_len := pole_proj_vec.length()
	# 任一投影过小（链接近伸直或 pole 与轴平行）时跳过，防止数值翻转
	if mp_len < 0.001 or pp_len < 0.001:
		return

	var angle: float = (mid_proj_vec / mp_len).signed_angle_to(pole_proj_vec / pp_len, axis) * influence
	var rot: Basis   = Basis(axis, angle)
	positions[1] = root + rot * (mid - root).normalized() * lengths[0]


func _apply_poses(positions: Array[Vector3], ik_indices: Array[int], effective_target: Transform3D) -> void:
	var skel_xform: Transform3D = _skeleton.global_transform
	var skel_inv: Transform3D   = skel_xform.affine_inverse()
	var grip_basis: Basis       = effective_target.basis
	var forearm_local_idx: int  = ik_indices.size() - 2
	var roll_align: float       = _config.forearm_roll_align if _config else 0.5

	for i in range(ik_indices.size() - 1):
		var bone_idx: int = ik_indices[i]
		var from: Vector3 = positions[i]
		var to: Vector3   = positions[i + 1]

		var current_global: Transform3D = skel_xform * _skeleton.get_bone_global_pose(bone_idx)
		var target_dir: Vector3  = (to - from).normalized()
		var current_dir: Vector3 = current_global.basis.y.normalized()

		if current_dir.length() < 0.001 or target_dir.length() < 0.001:
			continue

		var rotation: Basis
		if i == forearm_local_idx and roll_align > 0.0:
			var q_align := _safe_rotation_quaternion(current_dir, target_dir)
			var aligned  := Basis(q_align) * current_global.basis
			var proj_aligned := (aligned.z   - target_dir * aligned.z.dot(target_dir))
			var proj_grip    := (grip_basis.z - target_dir * grip_basis.z.dot(target_dir))
			var pa_len := proj_aligned.length()
			var pg_len := proj_grip.length()
			if pa_len > 0.001 and pg_len > 0.001:
				var roll_angle := (proj_aligned / pa_len).signed_angle_to(proj_grip / pg_len, target_dir) * roll_align
				rotation = Basis(Quaternion(target_dir, roll_angle)) * aligned
			else:
				rotation = aligned
		else:
			var q := _safe_rotation_quaternion(current_dir, target_dir)
			rotation = Basis(q) * current_global.basis

		var new_local := skel_inv * Transform3D(rotation, from)
		_skeleton.set_bone_global_pose_override(bone_idx, new_local, _current_weight, true)

	# 手腕朝向完全由 effective_target（含偏移）的 basis 决定
	var hand_idx: int = ik_indices[-1]
	var grip_local: Transform3D = skel_inv * effective_target
	_skeleton.set_bone_global_pose_override(hand_idx, grip_local, _current_weight, true)

	# ── 肩膀修正（clavicle_alpha）──────────────────────────────
	# 让 LeftShoulder 轻微跟随 LeftArm IK 结果，避免肩膀超伸
	var shoulder_weight := (_config.shoulder_ik_weight if _config else 0.3) * _current_weight
	if shoulder_weight > 0.001 and _bone_indices.size() > 0:
		var shoulder_idx: int = _bone_indices[0]
		var shoulder_global := skel_xform * _skeleton.get_bone_global_pose(shoulder_idx)
		var arm_ik_pos   := positions[0]
		var arm_anim_pos := (skel_xform * _skeleton.get_bone_global_pose(ik_indices[0])).origin
		# 只在 IK 确实偏离动画时才修正
		if (arm_ik_pos - arm_anim_pos).length() > 0.001:
			var target_dir_s := (arm_ik_pos - shoulder_global.origin).normalized()
			var current_dir_s := shoulder_global.basis.y.normalized()
			var q_s := _safe_rotation_quaternion(current_dir_s, target_dir_s)
			var new_basis_s := Basis(q_s) * shoulder_global.basis
			var new_local_s := skel_inv * Transform3D(new_basis_s, shoulder_global.origin)
			_skeleton.set_bone_global_pose_override(shoulder_idx, new_local_s, shoulder_weight, true)


# 安全的方向旋转四元数：当 from/to 接近反向时选择稳定的旋转轴，避免翻转
func _safe_rotation_quaternion(from: Vector3, to: Vector3) -> Quaternion:
	var dot := from.dot(to)
	# 几乎相同方向，不旋转
	if dot >= 0.9999:
		return Quaternion.IDENTITY
	# 接近反向（dot ≤ -0.9999）：Quaternion(from,to) 会数值爆炸，选正交轴做 180° 旋转
	if dot <= -0.9999:
		var ortho := from.cross(Vector3.UP)
		if ortho.length_squared() < 0.001:
			ortho = from.cross(Vector3.RIGHT)
		return Quaternion(ortho.normalized(), PI)
	return Quaternion(from, to)


func _clear_overrides() -> void:
	if not _skeleton or _bone_indices.is_empty():
		return
	# 包含 LeftShoulder（index 0）
	for i in range(_bone_indices.size()):
		_skeleton.set_bone_global_pose_override(_bone_indices[i], Transform3D.IDENTITY, 0.0, false)


# 权重淡出到接近 0 时用于保持平滑：设 weight=0 而不是直接清空
func _clear_overrides_weighted() -> void:
	if not _skeleton or _bone_indices.is_empty():
		return
	for i in range(_bone_indices.size()):
		_skeleton.set_bone_global_pose_override(_bone_indices[i], Transform3D.IDENTITY, 0.0, false)
