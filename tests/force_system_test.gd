class_name ForceSystemTest
extends RefCounted

## 通用力系统（ForceReceiver）回归测试。
## 运行：godot --headless --script res://tests/force_system_runner.gd
## 全部用例不依赖场景树中的玩家实例，只使用程序化骨架。

const EPSILON := 0.0001


static func run_all() -> Dictionary:
	var results := {
		"decay_curves": _decay_curves(),
		"propagation_monotonic_and_bounded": _propagation_monotonic_and_bounded(),
		"propagation_chain_weight_matches_formula": _propagation_chain_weight_matches_formula(),
		"pose_cap_stops_growth_and_overload_fires_once": _pose_cap_stops_growth_and_overload_fires_once(),
		"regression_no_per_frame_drift": _regression_no_per_frame_drift(),
		"robustness_rejects_non_finite_input": _robustness_rejects_non_finite_input(),
		"impulse_matches_ragdoll_formula": _impulse_matches_ragdoll_formula(),
		"physical_recoil_angular_impulse_moves_bone": _physical_recoil_angular_impulse_moves_bone(),
		"recoil_state_persists_after_payload_cleanup": _recoil_state_persists_after_payload_cleanup(),
		"recoil_burst_accumulates_and_settles": _recoil_burst_accumulates_and_settles(),
		"recoil_extreme_input_stays_finite": _recoil_extreme_input_stays_finite(),
		"pending_impulse_is_one_shot": _pending_impulse_is_one_shot(),
		"clearing_resets_pose_and_pending": _clearing_resets_pose_and_pending(),
		"bone_for_body_part_covers_all_parts": _bone_for_body_part_covers_all_parts(),
		"local_space_direction_is_rotated": _local_space_direction_is_rotated(),
		"max_active_forces_is_enforced": _max_active_forces_is_enforced(),
		"modifier_applies_and_preserves_upstream_pose": _modifier_applies_and_preserves_upstream_pose(),
		"modifier_bone_pose_does_not_drift": _modifier_bone_pose_does_not_drift(),
		"modifier_release_preserves_current_upstream_pose": _modifier_release_preserves_current_upstream_pose(),
		"modifier_respects_translation_limits": _modifier_respects_translation_limits(),
		"ragdoll_provider_consumes_pending_impulse": _ragdoll_provider_consumes_pending_impulse(),
		"ragdoll_without_provider_falls_back": _ragdoll_without_provider_falls_back(),
		"console_death_produces_no_impulse": _console_death_produces_no_impulse(),
	}
	return results


static func _physical_recoil_angular_impulse_moves_bone() -> bool:
	var skeleton := _build_skeleton()
	var config := _make_config()
	config.recoil_bone_inertia_kg_m2["mixamorig_RightHand"] = 0.01
	var receiver := _make_receiver(skeleton, config)
	receiver.apply_recoil_impulse(
		Vector3.ZERO,
		Vector3.RIGHT * 0.1,
		"mixamorig_RightHand",
		0.1
	)
	# The impulse changes angular velocity at impact; pose angle builds on the next frame.
	receiver.update_pose_offsets(0.016)
	var offsets := receiver.get_pose_offsets()
	var hand_idx := skeleton.find_bone("mixamorig_RightHand")
	if not offsets.has(hand_idx):
		return false
	var hand_offset: Dictionary = offsets[hand_idx]
	var initial_response_ok := (
		float(hand_offset["angle"]) > 0.0
		and float(hand_offset["angle"]) <= config.recoil_max_bone_angle_rad
		and (hand_offset["axis"] as Vector3).is_finite()
	)
	# Passing the dynamics time scale must not hard-cut the response.
	receiver.update_pose_offsets(0.1)
	var continues_past_time_scale := receiver.get_active_force_count() == 1 \
		and _angle_of(receiver, "mixamorig_RightHand") > 0.0
	# It is eventually reclaimed only after naturally decaying below visibility.
	receiver.update_pose_offsets(1.0)
	return initial_response_ok and continues_past_time_scale \
		and receiver.get_active_force_count() == 0


static func _recoil_state_persists_after_payload_cleanup() -> bool:
	var skeleton := _build_skeleton()
	var config := _make_config()
	config.recoil_bone_inertia_kg_m2["mixamorig_RightHand"] = 0.01
	var receiver := _make_receiver(skeleton, config)
	receiver.apply_recoil_impulse(Vector3(0.1, 0.0, 0.0), Vector3.RIGHT * 0.1, "mixamorig_RightHand", 0.12)
	receiver.update_pose_offsets(0.016)
	if receiver._active.is_empty() or receiver._recoil_states.is_empty():
		return false
	for payload in receiver._active:
		receiver._release_payload(payload)
	receiver._active.clear()
	receiver.update_pose_offsets(0.016)
	return not receiver.get_pose_offsets().is_empty() and not receiver._recoil_states.is_empty()


static func _recoil_burst_accumulates_and_settles() -> bool:
	var skeleton := _build_skeleton()
	var config := _make_config()
	config.recoil_bone_inertia_kg_m2["mixamorig_RightHand"] = 0.02
	var receiver := _make_receiver(skeleton, config)
	var bone := "mixamorig_RightHand"
	for _shot in 3:
		receiver.apply_recoil_impulse(Vector3.ZERO, Vector3.RIGHT * 0.04, bone, 0.12)
		receiver.update_pose_offsets(0.016)
	var burst_angle := _angle_of(receiver, bone)
	if burst_angle <= 0.0 or receiver._recoil_states.is_empty():
		return false
	for _frame in 240:
		receiver.update_pose_offsets(0.016)
	var settled := receiver.get_pose_offsets().is_empty() \
		and receiver._recoil_states.is_empty() \
		and is_zero_approx(_angle_of(receiver, bone))
	return settled


static func _recoil_extreme_input_stays_finite() -> bool:
	var skeleton := _build_skeleton()
	var config := _make_config()
	config.recoil_bone_inertia_kg_m2["mixamorig_RightHand"] = 0.0001
	var receiver := _make_receiver(skeleton, config)
	for _shot in 12:
		receiver.apply_recoil_impulse(Vector3.ZERO, Vector3(1.0e6, -1.0e6, 1.0e6), "mixamorig_RightHand", 0.01)
		receiver.update_pose_offsets(0.016)
		if not _offsets_are_finite(receiver):
			return false
	return true


# ── 骨架构建 ────────────────────────────────────────────────

## 程序化构建与 mixamo 命名一致的骨架，用于传播与姿态测试。
## 骨架会挂进场景树根节点：骨骼几何查询依赖 global_transform，
## 未入树的 Node3D 会返回单位变换并报错。
static func _build_skeleton() -> Skeleton3D:
	var skeleton := Skeleton3D.new()
	skeleton.name = "Skeleton3D"
	# 每项：[骨骼名, 父索引, 局部位置]
	var definitions := [
		["mixamorig_Hips", -1, Vector3(0.0, 0.95, 0.0)],
		["mixamorig_Spine", 0, Vector3(0.0, 0.11, 0.0)],
		["mixamorig_Spine1", 1, Vector3(0.0, 0.10, 0.0)],
		["mixamorig_Spine2", 2, Vector3(0.0, 0.10, 0.0)],
		["mixamorig_Neck", 3, Vector3(0.0, 0.24, 0.0)],
		["mixamorig_Neck1", 4, Vector3(0.0, 0.08, 0.0)],
		["mixamorig_Head", 5, Vector3(0.0, 0.08, 0.0)],
		["mixamorig_LeftShoulder", 3, Vector3(-0.06, 0.18, 0.0)],
		["mixamorig_LeftArm", 7, Vector3(-0.12, 0.0, 0.0)],
		["mixamorig_LeftForeArm", 8, Vector3(-0.25, 0.0, 0.0)],
		["mixamorig_LeftHand", 9, Vector3(-0.24, 0.0, 0.0)],
		["mixamorig_RightShoulder", 3, Vector3(0.06, 0.18, 0.0)],
		["mixamorig_RightArm", 11, Vector3(0.12, 0.0, 0.0)],
		["mixamorig_RightForeArm", 12, Vector3(0.25, 0.0, 0.0)],
		["mixamorig_RightHand", 13, Vector3(0.24, 0.0, 0.0)],
		["mixamorig_LeftUpLeg", 0, Vector3(-0.09, -0.40, 0.0)],
		["mixamorig_LeftLeg", 15, Vector3(0.0, -0.27, 0.0)],
		["mixamorig_LeftFoot", 16, Vector3(0.0, -0.23, 0.0)],
		["mixamorig_RightUpLeg", 0, Vector3(0.09, -0.40, 0.0)],
		["mixamorig_RightLeg", 18, Vector3(0.0, -0.27, 0.0)],
		["mixamorig_RightFoot", 19, Vector3(0.0, -0.23, 0.0)],
	]
	for definition in definitions:
		skeleton.add_bone(definition[0])
	for index in definitions.size():
		var parent_index: int = definitions[index][1]
		if parent_index >= 0:
			skeleton.set_bone_parent(index, parent_index)
		var local_position: Vector3 = definitions[index][2]
		skeleton.set_bone_rest(index, Transform3D(Basis.IDENTITY, local_position))
		skeleton.set_bone_pose_position(index, local_position)
		skeleton.set_bone_pose_rotation(index, Quaternion.IDENTITY)
	var tree := Engine.get_main_loop() as SceneTree
	if tree and tree.root:
		tree.root.add_child(skeleton)
	return skeleton


static func _make_config() -> ForceConfig:
	return ForceConfig.new()


static func _make_receiver(skeleton: Skeleton3D, config: ForceConfig) -> ForceReceiver:
	var receiver := ForceReceiver.new()
	receiver.initialize(null, config, skeleton)
	return receiver


# ── 用例 ────────────────────────────────────────────────────

## 指数曲线在 duration 处落到 decay_floor；线性曲线在 duration 处归零。
static func _decay_curves() -> bool:
	var exponential := ForceTypes.ForcePayload.new()
	exponential.magnitude = 1.0
	exponential.duration = 0.25
	exponential.decay_floor = 0.05
	exponential.decay_curve = ForceTypes.DecayCurve.EXPONENTIAL
	if not is_equal_approx(exponential.curve_weight_at(0.0), 1.0):
		return false
	if not is_equal_approx(exponential.curve_weight_at(exponential.duration), 0.05):
		return false
	# 单调递减
	if exponential.curve_weight_at(0.125) >= exponential.curve_weight_at(0.0):
		return false
	if exponential.curve_weight_at(0.24) >= exponential.curve_weight_at(0.125):
		return false
	# 超出 duration 归零
	if exponential.curve_weight_at(exponential.duration + EPSILON) != 0.0:
		return false

	var linear := ForceTypes.ForcePayload.new()
	linear.magnitude = 1.0
	linear.duration = 0.4
	linear.decay_curve = ForceTypes.DecayCurve.LINEAR
	if not is_equal_approx(linear.curve_weight_at(0.0), 1.0):
		return false
	if not is_equal_approx(linear.curve_weight_at(0.2), 0.5):
		return false
	if not is_zero_approx(linear.curve_weight_at(linear.duration)):
		return false
	if linear.curve_weight_at(linear.duration + EPSILON) != 0.0:
		return false
	return true


## 权重随层级距离单调递减；超过 max_propagation_depth 归零。
static func _propagation_monotonic_and_bounded() -> bool:
	var skeleton := _build_skeleton()
	var max_depth := 4
	var decay := 0.67
	var propagation := ForcePropagation.new()
	propagation.configure(skeleton, decay, max_depth)
	var hit_idx := skeleton.find_bone("mixamorig_Spine1")
	var weights := propagation.weights_for(hit_idx)
	if not weights.has(hit_idx):
		return false
	if not is_equal_approx(weights[hit_idx]["weight"], 1.0):
		return false
	# 每个条目都应在深度限制内，且权重等于公式值
	var max_seen_depth := 0
	for bone_idx in weights:
		var depth: int = weights[bone_idx]["depth"]
		if depth > max_depth:
			return false
		max_seen_depth = maxi(max_seen_depth, depth)
		var expected := pow(decay, float(depth))
		if not is_equal_approx(weights[bone_idx]["weight"], expected):
			return false
	# 必须真正到达过深度上限（否则测试没有覆盖到截断逻辑）
	if max_seen_depth != max_depth:
		return false
	# 层级更远的骨骼权重更小（同一条手臂链上）
	var arm := skeleton.find_bone("mixamorig_RightArm")
	var forearm := skeleton.find_bone("mixamorig_RightForeArm")
	if weights.has(arm) and weights.has(forearm):
		if weights[forearm]["depth"] <= weights[arm]["depth"]:
			return false
		if weights[forearm]["weight"] >= weights[arm]["weight"]:
			return false
	# 更远的骨骼（超过 max_depth）不应出现
	var foot := skeleton.find_bone("mixamorig_LeftFoot")
	if weights.has(foot):
		return false
	return true


## RightHand → Head 的链权重贴近 decay_per_level ^ 层级距离。
static func _propagation_chain_weight_matches_formula() -> bool:
	var skeleton := _build_skeleton()
	var decay := 0.67
	var propagation := ForcePropagation.new()
	propagation.configure(skeleton, decay, 6)
	var hit_idx := skeleton.find_bone("mixamorig_RightHand")
	var weights := propagation.weights_for(hit_idx)
	if not weights.has(hit_idx):
		return false
	# 手工数层级距离：RightHand→RightForeArm→RightArm→RightShoulder
	# →Spine2→Spine1→Spine（深度 6）
	var chain := [
		"mixamorig_RightHand",
		"mixamorig_RightForeArm",
		"mixamorig_RightArm",
		"mixamorig_RightShoulder",
		"mixamorig_Spine2",
		"mixamorig_Spine1",
		"mixamorig_Spine",
	]
	for depth in chain.size():
		var bone_idx := skeleton.find_bone(chain[depth])
		if not weights.has(bone_idx):
			return false
		if weights[bone_idx]["depth"] != depth:
			return false
		if not is_equal_approx(weights[bone_idx]["weight"], pow(decay, float(depth))):
			return false
	# Head 的层级距离：RightHand→…→Spine2→Neck→Neck1→Head = 8，超过 max_depth=6
	# 因此不应出现；这正是“深度受限”的预期行为。
	var head_idx := skeleton.find_bone("mixamorig_Head")
	if weights.has(head_idx):
		return false
	# 但以 Spine1 为作用点时，Head 必须在范围内（链条自然覆盖到头部）
	var spine_weights := propagation.weights_for(skeleton.find_bone("mixamorig_Spine1"))
	if not spine_weights.has(head_idx):
		return false
	return true


## 多力求和超过 pose_cap 后偏移量不再增长，且 overload 恰好触发一次。
static func _pose_cap_stops_growth_and_overload_fires_once() -> bool:
	var skeleton := _build_skeleton()
	var config := _make_config()
	config.pose_cap = 0.5
	config.overload_threshold = 0.5
	var receiver := _make_receiver(skeleton, config)
	var hit_bone := "mixamorig_Spine1"
	# GDScript 的 lambda 按值捕获局部变量，必须用容器才能从信号回调中写回。
	var overload_count := [0]
	receiver.overload_triggered.connect(func(_total: float): overload_count[0] += 1)

	receiver.apply_force(Vector3.BACK, 0.4, hit_bone, 1.0)
	receiver.update_pose_offsets(0.0)
	var first_angle := _angle_of(receiver, hit_bone)
	if first_angle <= 0.0:
		return false
	if overload_count[0] != 0:
		return false

	# 再来一发同向力，合计 0.8 > pose_cap=0.5
	receiver.apply_force(Vector3.BACK, 0.4, hit_bone, 1.0)
	receiver.update_pose_offsets(0.0)
	var second_angle := _angle_of(receiver, hit_bone)
	if overload_count[0] != 1:
		return false
	# 已到上限：偏移量必须停在 pose_cap 对应的角度上，不再增长
	if second_angle <= first_angle:
		return false
	var capped_angle := config.rotation_gain * config.pose_cap
	if not is_equal_approx(second_angle, capped_angle):
		return false
	if not is_equal_approx(first_angle, config.rotation_gain * 0.4):
		return false

	# 继续加力，偏移量保持在上限，overload 不再重复触发
	receiver.apply_force(Vector3.BACK, 0.4, hit_bone, 1.0)
	receiver.update_pose_offsets(0.0)
	if not is_equal_approx(_angle_of(receiver, hit_bone), capped_angle):
		return false
	if overload_count[0] != 1:
		return false
	return true


## 回归守卫：同一力连续模拟 N 帧，偏移量保持恒定而非线性累加。
static func _regression_no_per_frame_drift() -> bool:
	var skeleton := _build_skeleton()
	var config := _make_config()
	config.pose_cap = 10.0
	config.overload_threshold = 99.0
	# decay_floor = 1.0 让指数曲线恒定不衰减，从而把“跨帧累加”单独隔离出来：
	# 若修饰器每帧在上一帧结果上继续叠加，偏移量会线性增长而不是保持恒定。
	config.decay_floor = 1.0
	var receiver := _make_receiver(skeleton, config)
	var hit_bone := "mixamorig_RightForeArm"
	receiver.apply_force(Vector3.BACK, 1.0, hit_bone, 10.0)
	receiver.update_pose_offsets(0.0)
	var baseline := _angle_of(receiver, hit_bone)
	var baseline_translation := _translation_of(receiver, hit_bone)
	if baseline <= 0.0:
		return false
	for _frame in 120:
		receiver.update_pose_offsets(0.016)
		var angle := _angle_of(receiver, hit_bone)
		if not is_equal_approx(angle, baseline):
			return false
		if not _translation_of(receiver, hit_bone).is_equal_approx(baseline_translation):
			return false
	return true


## 零方向、零时长、非有限输入不产生 NaN/Inf 姿态。
static func _robustness_rejects_non_finite_input() -> bool:
	var skeleton := _build_skeleton()
	var config := _make_config()
	var receiver := _make_receiver(skeleton, config)
	var hit_bone := "mixamorig_Spine1"

	receiver.apply_force(Vector3.ZERO, 1.0, hit_bone)
	if receiver.get_active_force_count() != 0:
		return false
	receiver.apply_force(Vector3.BACK, 0.0, hit_bone)
	if receiver.get_active_force_count() != 0:
		return false
	receiver.apply_force(Vector3.BACK, 1.0, "")
	if receiver.get_active_force_count() != 0:
		return false
	receiver.apply_force(Vector3.BACK, 1.0, "mixamorig_NotABone")
	if receiver.get_active_force_count() != 0:
		return false
	receiver.apply_force(Vector3(NAN, 0.0, 0.0), 1.0, hit_bone)
	receiver.apply_force(Vector3.BACK, INF, hit_bone)
	receiver.apply_force(Vector3.BACK, 1.0, hit_bone, INF)
	if receiver.get_active_force_count() != 1:
		return false
	receiver.update_pose_offsets(INF)
	if not _offsets_are_finite(receiver):
		return false
	# 零时长回退到配置默认值，力应仍然生效
	receiver.clear_forces()
	receiver.apply_force(Vector3.BACK, 1.0, hit_bone, 0.0)
	if receiver.get_active_force_count() != 1:
		return false
	receiver.update_pose_offsets(0.0)
	if not is_equal_approx(_angle_of(receiver, hit_bone), config.rotation_gain):
		return false
	return true


## 冲量推导必须与 PlayerRagdollSystem 原公式一致：p = sqrt(2*m*E)*ratio。
static func _impulse_matches_ragdoll_formula() -> bool:
	var skeleton := _build_skeleton()
	var config := _make_config()
	var receiver := _make_receiver(skeleton, config)
	# 与 ragdoll_config_default / ForceConfig 默认值一致的弹头参数
	var bullet_mass := 0.00345
	var energy := 1900.0
	var info := DamageInfo.new()
	info.amount = energy
	info.type = MedicalEnums.DamageType.BULLET
	info.body_part = MedicalEnums.BodyPartId.TORSO
	info.direction = Vector3.BACK
	info.impact_mass_kg = bullet_mass
	info.anchor_bone = "mixamorig_Spine1"
	receiver.apply_impact(info)

	var expected := sqrt(2.0 * bullet_mass * energy) * config.impact_energy_transfer
	var pending := receiver.consume_pending_impulse()
	if pending.is_empty():
		return false
	if not is_equal_approx(pending["impulse_ns"], expected):
		return false
	if not pending["direction"].is_equal_approx(Vector3.BACK):
		return false
	if pending["hit_bone"] != "mixamorig_Spine1":
		return false

	# 归一化强度来自同一冲量
	var magnitude := config.normalized_magnitude(expected)
	if not is_equal_approx(receiver.get_pose_snapshot()["active_forces"], 1):
		return false
	receiver.update_pose_offsets(0.0)
	if not is_equal_approx(_angle_of(receiver, "mixamorig_Spine1"), config.rotation_gain * magnitude):
		return false

	# 爆头使用更高的传递比例
	var head_receiver := _make_receiver(skeleton, config)
	var head_info := DamageInfo.new()
	head_info.amount = energy
	head_info.type = MedicalEnums.DamageType.BULLET
	head_info.body_part = MedicalEnums.BodyPartId.HEAD
	head_info.direction = Vector3.FORWARD
	head_info.impact_mass_kg = bullet_mass
	head_receiver.apply_impact(head_info)
	var head_pending := head_receiver.consume_pending_impulse()
	var head_expected := sqrt(2.0 * bullet_mass * energy) * config.headshot_energy_transfer
	if not is_equal_approx(head_pending["impulse_ns"], head_expected):
		return false
	# 爆头无 anchor_bone，应回退到 BodyPartId 映射
	if head_pending["hit_bone"] != "mixamorig_Head":
		return false

	# 弹道伤害缺少弹头质量时不产生冲量
	var no_mass_receiver := _make_receiver(skeleton, config)
	var no_mass_info := DamageInfo.new()
	no_mass_info.amount = energy
	no_mass_info.type = MedicalEnums.DamageType.BULLET
	no_mass_info.direction = Vector3.BACK
	no_mass_info.impact_mass_kg = 0.0
	no_mass_receiver.apply_impact(no_mass_info)
	if not no_mass_receiver.consume_pending_impulse().is_empty():
		return false
	if no_mass_receiver.get_active_force_count() != 0:
		return false
	return true


## consume_pending_impulse() 第二次返回空；方向与骨骼随力一起保存。
static func _pending_impulse_is_one_shot() -> bool:
	var skeleton := _build_skeleton()
	var config := _make_config()
	var receiver := _make_receiver(skeleton, config)
	var info := DamageInfo.new()
	info.amount = 1200.0
	info.type = MedicalEnums.DamageType.FRAGMENT
	info.body_part = MedicalEnums.BodyPartId.RIGHT_FOREARM
	info.direction = Vector3.LEFT
	info.impact_mass_kg = 0.0079
	info.anchor_bone = "mixamorig_RightForeArm"
	receiver.apply_impact(info)
	var first := receiver.consume_pending_impulse()
	if first.is_empty():
		return false
	if first["hit_bone"] != "mixamorig_RightForeArm":
		return false
	var second := receiver.consume_pending_impulse()
	if not second.is_empty():
		return false
	return true


## clear_forces() / clear_pending_impulse() 清空姿态与冲量（复活路径）。
static func _clearing_resets_pose_and_pending() -> bool:
	var skeleton := _build_skeleton()
	var config := _make_config()
	var receiver := _make_receiver(skeleton, config)
	var info := DamageInfo.new()
	info.amount = 1500.0
	info.type = MedicalEnums.DamageType.BULLET
	info.body_part = MedicalEnums.BodyPartId.TORSO
	info.direction = Vector3.BACK
	info.impact_mass_kg = 0.0079
	receiver.apply_impact(info)
	receiver.update_pose_offsets(0.0)
	if receiver.get_pose_offsets().is_empty():
		return false

	receiver.clear_forces()
	if not receiver.get_pose_offsets().is_empty():
		return false
	if not is_zero_approx(receiver.get_total_magnitude()):
		return false

	# clear_forces() 不应吞掉待用冲量：布娃娃仍需要它
	if receiver.consume_pending_impulse().is_empty():
		return false
	receiver.apply_impact(info)
	receiver.clear_pending_impulse()
	if not receiver.consume_pending_impulse().is_empty():
		return false
	return true


## BodyPartId → 骨骼名映射覆盖全部十个部位，且都能在真实命名规则下解析。
static func _bone_for_body_part_covers_all_parts() -> bool:
	var expected := {
		MedicalEnums.BodyPartId.HEAD: "mixamorig_Head",
		MedicalEnums.BodyPartId.TORSO: "mixamorig_Spine1",
		MedicalEnums.BodyPartId.LEFT_UPPER_ARM: "mixamorig_LeftArm",
		MedicalEnums.BodyPartId.LEFT_FOREARM: "mixamorig_LeftForeArm",
		MedicalEnums.BodyPartId.RIGHT_UPPER_ARM: "mixamorig_RightArm",
		MedicalEnums.BodyPartId.RIGHT_FOREARM: "mixamorig_RightForeArm",
		MedicalEnums.BodyPartId.LEFT_THIGH: "mixamorig_LeftUpLeg",
		MedicalEnums.BodyPartId.LEFT_CALF: "mixamorig_LeftLeg",
		MedicalEnums.BodyPartId.RIGHT_THIGH: "mixamorig_RightUpLeg",
		MedicalEnums.BodyPartId.RIGHT_CALF: "mixamorig_RightLeg",
	}
	var skeleton := _build_skeleton()
	for part in expected:
		var bone_name: String = ForceTypes.bone_for_body_part(part)
		if bone_name != expected[part]:
			return false
		if skeleton.find_bone(bone_name) < 0:
			return false
	return true


## LOCAL 空间的力方向会按玩家朝向旋转后再传播。
static func _local_space_direction_is_rotated() -> bool:
	var skeleton := _build_skeleton()
	var config := _make_config()
	var receiver := _make_receiver(skeleton, config)
	var player := Node3D.new()
	# 玩家绕 Y 轴旋转 90°，局部 +X 应变成世界 -Z
	player.global_transform = Transform3D(
		Basis(Vector3.UP, PI * 0.5),
		Vector3.ZERO
	)
	var tree := Engine.get_main_loop() as SceneTree
	if tree and tree.root:
		tree.root.add_child(player)
	receiver.initialize(player, config, skeleton)
	receiver.apply_force(Vector3.RIGHT, 1.0, "mixamorig_Spine1", 1.0, "exponential", Vector3.ZERO, ForceTypes.Space.LOCAL)
	receiver.update_pose_offsets(0.0)
	var axis := _axis_of(receiver, "mixamorig_Spine1")
	if axis.length_squared() <= 0.0:
		player.free()
		return false
	# 世界空间的偏移方向应为 -Z（局部 +X 旋转 90° 后）
	var offset_direction := _translation_of(receiver, "mixamorig_Spine1")
	player.queue_free()
	if offset_direction.length_squared() <= 0.0:
		return false
	return offset_direction.normalized().dot(Vector3.FORWARD) > 0.9


## 超过 max_active_forces 时丢弃最旧的力。
static func _max_active_forces_is_enforced() -> bool:
	var skeleton := _build_skeleton()
	var config := _make_config()
	config.max_active_forces = 2
	var receiver := _make_receiver(skeleton, config)
	for index in 4:
		receiver.apply_force(Vector3.BACK, 0.1, "mixamorig_Spine1", 5.0, "exponential", Vector3.ZERO, ForceTypes.Space.WORLD)
	receiver.update_pose_offsets(0.0)
	if receiver.get_active_force_count() != 2:
		return false
	# 仅剩 2 份力，总量应为 0.2（其余被丢弃）
	if not is_equal_approx(receiver.get_total_magnitude(), 0.2):
		return false
	return true


# ── 断言辅助 ────────────────────────────────────────────────

## 布娃娃优先消费力系统缓存的冲量（方向 + 总冲量）。
static func _ragdoll_provider_consumes_pending_impulse() -> bool:
	var skeleton := _build_skeleton()
	var config := _make_config()
	var receiver := _make_receiver(skeleton, config)
	var ragdoll := PlayerRagdollSystem.new()
	ragdoll.set_force_provider(receiver)

	var impulse := 7.5
	receiver._pending_impulse = {
		"direction": Vector3.LEFT,
		"impulse_ns": impulse,
		"hit_bone": "mixamorig_Spine1",
	}
	var consumed := ragdoll._consume_pending_impulse()
	if consumed.is_empty():
		return false
	if not is_equal_approx(float(consumed["impulse_ns"]), impulse):
		return false
	if not (consumed["direction"] as Vector3).is_equal_approx(Vector3.LEFT):
		return false
	# 一次性：第二次必须为空
	if not ragdoll._consume_pending_impulse().is_empty():
		return false
	return true


## 未接入力提供者时布娃娃完全回退：消费接口返回空，不产生凭空冲量。
static func _ragdoll_without_provider_falls_back() -> bool:
	var ragdoll := PlayerRagdollSystem.new()
	if not ragdoll._consume_pending_impulse().is_empty():
		return false
	# 无提供者时能量→冲量回退公式必须与 ForceConfig 的换算一致
	var config := _make_config()
	var mass := 0.0079
	var energy := 1870.0
	var expected := sqrt(2.0 * mass * energy) * config.impact_energy_transfer
	if not is_equal_approx(expected, sqrt(2.0 * mass * energy) * 0.35):
		return false

	var receiver := _make_receiver(_build_skeleton(), config)
	ragdoll.set_force_provider(receiver)
	# 已接入但无待用冲量：仍应回退
	if not ragdoll._consume_pending_impulse().is_empty():
		return false
	return true


## 控制台 die()/失血死亡没有命中能量 → 不产生任何待用冲量。
static func _console_death_produces_no_impulse() -> bool:
	var skeleton := _build_skeleton()
	var config := _make_config()
	var receiver := _make_receiver(skeleton, config)
	# 无能量的脚本伤害
	var info := DamageInfo.new()
	info.amount = 0.0
	info.type = MedicalEnums.DamageType.BULLET
	info.body_part = MedicalEnums.BodyPartId.TORSO
	info.direction = Vector3.BACK
	info.impact_mass_kg = 0.0079
	receiver.apply_impact(info)
	if not receiver.consume_pending_impulse().is_empty():
		return false
	if receiver.get_active_force_count() != 0:
		return false
	# 方向为零的伤害同样不产生力
	var no_direction := DamageInfo.new()
	no_direction.amount = 1500.0
	no_direction.type = MedicalEnums.DamageType.BULLET
	no_direction.direction = Vector3.ZERO
	no_direction.impact_mass_kg = 0.0079
	receiver.apply_impact(no_direction)
	if not receiver.consume_pending_impulse().is_empty():
		return false
	return true

## 力修饰器必须真的改写骨骼姿态，且在力消失后保留当前上游姿态。
static func _modifier_applies_and_preserves_upstream_pose() -> bool:
	var skeleton := _build_skeleton()
	var config := _make_config()
	config.decay_floor = 1.0
	var receiver := _make_receiver(skeleton, config)
	var modifier := ForceBodyModifier.new()
	skeleton.add_child(modifier)
	modifier.setup(receiver)
	var bone_idx := skeleton.find_bone("mixamorig_Spine1")
	var base_rotation := skeleton.get_bone_pose_rotation(bone_idx)
	var base_position := skeleton.get_bone_pose_position(bone_idx)

	receiver.apply_force(Vector3.BACK, 1.0, "mixamorig_Spine1", 10.0)
	receiver.update_pose_offsets(0.0)
	modifier._process_modification_with_delta(0.016)
	var pushed_rotation := skeleton.get_bone_pose_rotation(bone_idx)
	var pushed_position := skeleton.get_bone_pose_position(bone_idx)
	if pushed_rotation.is_equal_approx(base_rotation):
		return false
	if pushed_position.is_equal_approx(base_position):
		return false
	if not pushed_rotation.is_finite() or not pushed_position.is_finite():
		return false

	# 上游动画在下一帧重新提供基准姿态；无偏移时修改器必须保持它不动。
	receiver.clear_forces()
	receiver.update_pose_offsets(0.0)
	skeleton.set_bone_pose_rotation(bone_idx, base_rotation)
	skeleton.set_bone_pose_position(bone_idx, base_position)
	modifier._process_modification_with_delta(0.016)
	var restored_rotation := skeleton.get_bone_pose_rotation(bone_idx)
	var restored_position := skeleton.get_bone_pose_position(bone_idx)
	if not restored_rotation.is_equal_approx(base_rotation):
		return false
	if not restored_position.is_equal_approx(base_position):
		return false
	return true


## 真实骨骼姿态层面的漂移守卫：常驻力下每帧结果必须恒定。
static func _modifier_bone_pose_does_not_drift() -> bool:
	var skeleton := _build_skeleton()
	var config := _make_config()
	config.decay_floor = 1.0
	config.pose_cap = 10.0
	config.overload_threshold = 99.0
	var receiver := _make_receiver(skeleton, config)
	var modifier := ForceBodyModifier.new()
	skeleton.add_child(modifier)
	modifier.setup(receiver)
	var bone_idx := skeleton.find_bone("mixamorig_Spine1")
	receiver.apply_force(Vector3.BACK, 1.0, "mixamorig_Spine1", 10.0)
	receiver.update_pose_offsets(0.0)
	modifier._process_modification_with_delta(0.016)
	var baseline_rotation := skeleton.get_bone_pose_rotation(bone_idx)
	var baseline_position := skeleton.get_bone_pose_position(bone_idx)
	if baseline_rotation.is_equal_approx(Quaternion.IDENTITY):
		return false
	for _frame in 90:
		receiver.update_pose_offsets(0.016)
		# Emulate the engine rebuilding the upstream animation pose before the
		# SkeletonModifier chain runs again.
		skeleton.reset_bone_poses()
		modifier._process_modification_with_delta(0.016)
		var rotation := skeleton.get_bone_pose_rotation(bone_idx)
		var position := skeleton.get_bone_pose_position(bone_idx)
		if not rotation.is_equal_approx(baseline_rotation):
			return false
		if not position.is_equal_approx(baseline_position):
			return false
	return true


## Recoil completion must not restore a pose cached before the current frame.
static func _modifier_release_preserves_current_upstream_pose() -> bool:
	var skeleton := _build_skeleton()
	var config := _make_config()
	config.recoil_bone_inertia_kg_m2["mixamorig_RightHand"] = 0.02
	var receiver := _make_receiver(skeleton, config)
	var modifier := ForceBodyModifier.new()
	skeleton.add_child(modifier)
	modifier.setup(receiver)
	var bone_idx := skeleton.find_bone("mixamorig_RightHand")
	var first_upstream := Quaternion.from_euler(Vector3(0.1, -0.2, 0.05))
	skeleton.set_bone_pose_rotation(bone_idx, first_upstream)
	receiver.apply_recoil_impulse(
		Vector3.ZERO, Vector3.RIGHT * 0.04, "mixamorig_RightHand", 0.12
	)
	receiver.update_pose_offsets(0.016)
	modifier._process_modification_with_delta(0.016)
	if skeleton.get_bone_pose_rotation(bone_idx).is_equal_approx(first_upstream):
		return false

	# Stop adding impulses and let the persistent state decay on its own.
	for _frame in 240:
		receiver.update_pose_offsets(0.016)
	if not receiver.get_pose_offsets().is_empty() or not receiver._recoil_states.is_empty():
		return false

	var current_upstream := Quaternion.from_euler(Vector3(-0.25, 0.35, -0.1))
	skeleton.set_bone_pose_rotation(bone_idx, current_upstream)
	modifier._process_modification_with_delta(0.016)
	return skeleton.get_bone_pose_rotation(bone_idx).is_equal_approx(current_upstream) \
		and modifier.get_touched_bone_count() == 0


## 位移偏移受 max_translation_m 硬性钳制，且只施加在浅层骨骼上。
static func _modifier_respects_translation_limits() -> bool:
	var skeleton := _build_skeleton()
	var config := _make_config()
	config.decay_floor = 1.0
	config.translation_gain = 5.0
	config.max_translation_m = 0.02
	config.pose_cap = 99.0
	config.translation_max_depth = 1
	var receiver := _make_receiver(skeleton, config)
	var modifier := ForceBodyModifier.new()
	skeleton.add_child(modifier)
	modifier.setup(receiver)
	receiver.apply_force(Vector3.BACK, 1.0, "mixamorig_Spine1", 10.0)
	receiver.update_pose_offsets(0.0)

	# 深层骨骼只旋转、不位移
	var deep_idx := skeleton.find_bone("mixamorig_Head")
	var deep_offset: Dictionary = receiver.get_pose_offsets().get(deep_idx, {})
	if deep_offset.is_empty():
		return false
	if (deep_offset["translation"] as Vector3).length_squared() > 0.0:
		return false
	if float(deep_offset["angle"]) <= 0.0:
		return false

	# 浅层骨骼位移被钳制在 max_translation_m 内
	var near_idx := skeleton.find_bone("mixamorig_Spine1")
	var base_position := skeleton.get_bone_pose_position(near_idx)
	modifier._process_modification_with_delta(0.016)
	var moved := (skeleton.get_bone_pose_position(near_idx) - base_position).length()
	if moved > config.max_translation_m + EPSILON:
		return false
	if moved <= 0.0:
		return false
	return true

static func _angle_of(receiver: ForceReceiver, bone_name: String) -> float:
	var skeleton := receiver.get_skeleton()
	if not is_instance_valid(skeleton):
		return 0.0
	return _angle_for_index(receiver, skeleton.find_bone(bone_name))


static func _axis_of(receiver: ForceReceiver, bone_name: String) -> Vector3:
	var skeleton := receiver.get_skeleton()
	if not is_instance_valid(skeleton):
		return Vector3.ZERO
	return _axis_for_index(receiver, skeleton.find_bone(bone_name))


static func _translation_of(receiver: ForceReceiver, bone_name: String) -> Vector3:
	var skeleton := receiver.get_skeleton()
	if not is_instance_valid(skeleton):
		return Vector3.ZERO
	return _translation_for_index(receiver, skeleton.find_bone(bone_name))


static func _angle_for_index(receiver: ForceReceiver, bone_idx: int) -> float:
	var offsets := receiver.get_pose_offsets()
	if not offsets.has(bone_idx):
		return 0.0
	return float(offsets[bone_idx]["angle"])


static func _axis_for_index(receiver: ForceReceiver, bone_idx: int) -> Vector3:
	var offsets := receiver.get_pose_offsets()
	if not offsets.has(bone_idx):
		return Vector3.ZERO
	return offsets[bone_idx]["axis"]


static func _translation_for_index(receiver: ForceReceiver, bone_idx: int) -> Vector3:
	var offsets := receiver.get_pose_offsets()
	if not offsets.has(bone_idx):
		return Vector3.ZERO
	return offsets[bone_idx]["translation"]


## 所有姿态偏移数值必须有限，否则视为出现了 NaN/Inf。
static func _offsets_are_finite(receiver: ForceReceiver) -> bool:
	for bone_idx in receiver.get_pose_offsets():
		var entry: Dictionary = receiver.get_pose_offsets()[bone_idx]
		if not is_finite(float(entry["angle"])):
			return false
		if not (entry["axis"] as Vector3).is_finite():
			return false
		if not (entry["translation"] as Vector3).is_finite():
			return false
		if not is_finite(float(entry["raw_strength"])):
			return false
	if not is_finite(receiver.get_total_magnitude()):
		return false
	return true
