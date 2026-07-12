class_name PlayerRagdollSystem
extends Node

# ============================================================
# 布娃娃物理系统
# 功能：管理玩家的布娃娃物理效果。在模型加载时自动为骨骼创建
#       PhysicalBone3D 节点；死亡时播放死亡动画后切换到物理模拟；
#       复活时停止模拟并恢复动画系统。
# 用法：由 BasePlayer 在 _on_model_loaded() 中初始化。
# ============================================================

# 信号 ────────────────────────────────────────────────────────
signal ragdoll_enabled
## 布娃娃死亡流程已启动（含死亡动画阶段）

signal ragdoll_disabled
## 布娃娃物理已停止，动画系统已恢复

signal death_animation_started(anim_name: String)
## 死亡动画开始播放，参数为动画路径

signal ragdoll_physics_started
## 死亡动画过渡结束，物理骨骼模拟已启动

# 公开枚举 ────────────────────────────────────────────────────

## 死亡类型，决定播放哪个死亡动画及冲击力方向与大小
enum DeathType {
	FRONT,                  ## 正面死亡
	BACK,                   ## 背面死亡
	RIGHT,                  ## 右侧死亡
	FRONT_HEADSHOT,         ## 正面爆头
	BACK_HEADSHOT,          ## 背面爆头
	CROUCHING_HEADSHOT,    ## 蹲姿爆头
	EXPLOSION,             ## 爆炸
	GENERIC,               ## 通用（默认正面）
}

## 布娃娃阶段，控制死亡流程各阶段的状态
enum RagdollPhase {
	INACTIVE,              ## 未激活
	DEATH_ANIMATION,       ## 正在播放死亡动画
	RAGDOLL_PHYSICS,       ## 物理模拟已启动
}

# 公开属性 ────────────────────────────────────────────────────

## 布娃娃是否处于激活状态（只读）
var is_active: bool:
	get: return _is_active

## 当前阶段（只读）
var current_phase: RagdollPhase = RagdollPhase.INACTIVE:
	get: return _current_phase

# 私有变量 ────────────────────────────────────────────────────

var _is_active: bool = false
var _current_phase: RagdollPhase = RagdollPhase.INACTIVE
var _skeleton: Skeleton3D
var _physical_simulator: PhysicalBoneSimulator3D
var _animator: AnimationPlayer
var _animation_tree: AnimationTree
var _config: RagdollConfig
var _weapon_mount: Node3D  # 死亡时需要隐藏的武器挂载点

## 已创建的物理骨骼列表。每项存储 {"bone": PhysicalBone3D, "bone_idx": int}
var _physical_bone_entries: Array = []

## 死亡动画到物理阶段的倒计时（秒）
var _death_anim_timer: float = 0.0

## 待施加的冲击力方向（物理阶段启动时使用）
var _pending_impact_direction: Vector3 = Vector3.ZERO

## 待施加冲击力的死亡类型
var _pending_death_type: DeathType = DeathType.GENERIC

## 布娃娃激活前保存的骨骼全局变换（用于复活恢复）
var _saved_bone_poses: Dictionary = {}  # int (bone_idx) → Transform3D

# 动画路径映射 ────────────────────────────────────────────────

## DeathType → AnimationPlayer 动画路径
const DEATH_ANIM_PATHS := {
	DeathType.FRONT:              "death_front/mixamo_com",
	DeathType.BACK:               "death_back/mixamo_com",
	DeathType.RIGHT:              "death_right/mixamo_com",
	DeathType.FRONT_HEADSHOT:     "death_front_headshot/mixamo_com",
	DeathType.BACK_HEADSHOT:      "death_back_headshot/mixamo_com",
	DeathType.CROUCHING_HEADSHOT: "death_crouching_headshot/mixamo_com",
	DeathType.EXPLOSION:          "death_front/mixamo_com",
	DeathType.GENERIC:            "death_front/mixamo_com",
}

# 生命周期 ───────────────────────────────────────────────────

func _process(delta: float) -> void:
	if _current_phase != RagdollPhase.DEATH_ANIMATION:
		return

	_death_anim_timer -= delta
	if _death_anim_timer <= 0.0:
		_start_physics_phase()

# 初始化 ────────────────────────────────────────────────────

## 初始化布娃娃系统
## skeleton:      模型中的 Skeleton3D，用于创建物理骨骼和启动模拟
## animator:      模型中的 AnimationPlayer，用于播放死亡动画
## animation_tree:模型中的 AnimationTree，启用布娃娃时需要关闭
## config:        布娃娃配置资源，为 null 时使用代码默认值
## weapon_mount:  武器挂载点，死亡时隐藏、复活时恢复
func initialize(
	skeleton: Skeleton3D,
	animator: AnimationPlayer = null,
	animation_tree: AnimationTree = null,
	config: RagdollConfig = null,
	weapon_mount: Node3D = null
) -> void:
	_reset_skeleton_state()
	_skeleton = skeleton
	_animator = animator
	_animation_tree = animation_tree
	_config = config if config else RagdollConfig.new()
	_weapon_mount = weapon_mount

	if not _skeleton:
		GlobalLogger.warn("RagdollSystem", "Initialized without skeleton; ragdoll disabled.")
		return
	GlobalLogger.info("RagdollSystem", "Initialized with skeleton: %s" % _skeleton.name)

## 清除仅属于旧模型骨骼的缓存。模型热重载时 initialize() 会再次调用。
func _reset_skeleton_state() -> void:
	if is_instance_valid(_physical_simulator):
		if _physical_simulator.is_simulating_physics():
			_physical_simulator.physical_bones_stop_simulation()
		_physical_simulator.queue_free()
	_physical_simulator = null
	_physical_bone_entries.clear()
	_saved_bone_poses.clear()
	_is_active = false
	_current_phase = RagdollPhase.INACTIVE
	_death_anim_timer = 0.0
	set_process(false)

## 设置武器挂载点（死亡时隐藏、复活时恢复）
## 挂载点在 initialize() 之后才由 BasePlayer 查找到，因此单独提供设置入口
func set_weapon_mount(weapon_mount: Node3D) -> void:
	_weapon_mount = weapon_mount

# 公开方法 ──────────────────────────────────────────────────

## 启动死亡流程
## 依序执行：保存当前骨骼姿态 → 播放死亡动画 → 等待过渡时间 → 启动物理模拟
## death_type:       死亡类型，决定动画选择和冲击力默认方向
## impact_direction: 冲击力方向（世界空间），Vector3.ZERO 时使用类型对应的默认方向
func enable(death_type: DeathType = DeathType.GENERIC, impact_direction: Vector3 = Vector3.ZERO) -> void:
	if _is_active or not _skeleton:
		return

	_is_active = true

	# 首次调用时惰性创建物理骨骼
	if _physical_bone_entries.is_empty():
		_create_physical_bones()

	# Step 1: 保存当前骨骼姿态（供复活恢复）
	_save_bone_poses()

	# Step 2: 关闭 AnimationTree，防止它覆盖骨骼姿态
	if is_instance_valid(_animation_tree):
		_animation_tree.active = false

	# Step 3: 选择并播放死亡动画
	var death_anim: String = _select_death_animation(death_type)
	var has_death_animation := false
	if _animator:
		_animator.stop()
		_animator.active = true
		if _animator.has_animation(death_anim):
			_animator.play(death_anim)
			death_animation_started.emit(death_anim)
			GlobalLogger.info("RagdollSystem", "Death animation started: %s" % death_anim)
			has_death_animation = true
		else:
			# 动画库中无此动画，直接跳过动画阶段入物理
			GlobalLogger.warn("RagdollSystem", "Death animation not found: %s, entering physics directly." % death_anim)

	# Step 4: 设置阶段及过渡定时器
	_pending_impact_direction = impact_direction
	_pending_death_type = death_type

	if not has_death_animation:
		# 无死亡动画，直接进入物理阶段
		_current_phase = RagdollPhase.DEATH_ANIMATION
		_start_physics_phase()
	else:
		_current_phase = RagdollPhase.DEATH_ANIMATION
		_death_anim_timer = _config.death_anim_to_ragdoll_time
		set_process(true)

	ragdoll_enabled.emit()
	GlobalLogger.info("RagdollSystem", "Ragdoll sequence started (type: %d)" % death_type)

## 停止布娃娃，恢复动画系统
func disable() -> void:
	if not _is_active or not _skeleton:
		return

	# 已在物理阶段则停止模拟
	if _current_phase == RagdollPhase.RAGDOLL_PHYSICS:
		if is_instance_valid(_physical_simulator):
			_physical_simulator.physical_bones_stop_simulation()
	elif _current_phase == RagdollPhase.DEATH_ANIMATION:
		# 还在动画阶段，停止动画播放
		if _animator:
			_animator.stop()

	# 恢复骨骼姿态到死亡前的状态
	_restore_bone_poses()

	# 重新启用 AnimationTree
	if is_instance_valid(_animator):
		_animator.active = true
	if is_instance_valid(_animation_tree):
		_animation_tree.active = true

	# 恢复武器可见性
	if is_instance_valid(_weapon_mount):
		_weapon_mount.visible = true

	_is_active = false
	_current_phase = RagdollPhase.INACTIVE
	set_process(false)

	ragdoll_disabled.emit()
	GlobalLogger.info("RagdollSystem", "Ragdoll disabled")

# 私有 — 物理骨骼创建 ──────────────────────────────────────

## 为骨骼系统中的每一块有效骨骼创建 PhysicalBone3D 并添加胶囊碰撞体
## 过滤手指、IK 辅助骨骼、端点等不需要物理模拟的骨骼
func _create_physical_bones() -> void:
	_physical_bone_entries.clear()
	var bone_count := _skeleton.get_bone_count()
	var simulated_bones: Dictionary = {}
	for i in bone_count:
		var candidate_name := _skeleton.get_bone_name(i)
		if _is_bone_excluded(candidate_name):
			continue
		if _get_bone_segment(i).length() >= 0.001:
			simulated_bones[i] = true

	_physical_simulator = PhysicalBoneSimulator3D.new()
	_physical_simulator.name = "RagdollPhysicalBoneSimulator"
	_skeleton.add_child(_physical_simulator)
	_physical_simulator.active = true

	for i in bone_count:
		var bone_name: String = _skeleton.get_bone_name(i)

		# 过滤排除关键词
		if _is_bone_excluded(bone_name):
			continue

		if not simulated_bones.has(i):
			continue

		var physical_parent_idx := _find_physical_parent(i, simulated_bones)
		var bone_segment := _get_bone_segment(i)
		var bone_length: float = bone_segment.length()

		# 骨骼长度过短（如 0 长度 IK 辅助骨骼）跳过
		if bone_length < 0.001:
			continue

		# 创建 PhysicalBone3D
		var phys_bone := PhysicalBone3D.new()
		phys_bone.name = "PhysBone_" + bone_name

		# 先添加到骨骼系统，部分属性需要在场景树中才能设置
		_physical_simulator.add_child(phys_bone)

		# 指定绑定的骨骼名
		phys_bone.bone_name = bone_name

		# 无物理父节点的骨骼成为自由根；其余节点使用有限 Cone 关节。
		# Cone 不依赖模型特定的铰链轴，同时阻止 Pin 关节无限折叠成团。
		if physical_parent_idx < 0:
			phys_bone.joint_type = PhysicalBone3D.JOINT_TYPE_NONE
		else:
			_configure_cone_joint(phys_bone, bone_name)

		# 刚体阻尼（增大防止骨骼过度震荡）
		phys_bone.set("linear_damp", _config.linear_damping)
		phys_bone.set("angular_damp", _config.angular_damping)

		# 质量
		phys_bone.set("mass", _config.mass)

		# 碰撞层：骨骼只在第2层，不与第1层（含玩家胶囊体）碰撞
		# 仅与第1层环境几何体碰撞
		phys_bone.set("collision_layer", _config.ragdoll_collision_layer)
		phys_bone.set("collision_mask", _config.ragdoll_collision_mask)
		phys_bone.collision_priority = 5.0

		# 创建胶囊碰撞形状
		var collision_shape: Shape3D
		var body_center := bone_segment * 0.5
		if "Head" in bone_name:
			var sphere := SphereShape3D.new()
			sphere.radius = _config.head_radius
			collision_shape = sphere
			body_center = bone_segment * 0.25
		else:
			var capsule := CapsuleShape3D.new()
			var capsule_radius := _get_collider_radius(bone_name, bone_length)
			capsule.radius = capsule_radius
			capsule.height = max(bone_length, capsule_radius * 2.0)
			collision_shape = capsule

		# PhysicalBone 位于关节处；刚体中心应在关节与子骨骼之间，并沿实际骨段方向旋转。
		var align_to_segment := Quaternion(Vector3.UP, bone_segment.normalized())
		phys_bone.body_offset = Transform3D(Basis(align_to_segment), body_center)

		var col_shape := CollisionShape3D.new()
		col_shape.shape = collision_shape
		col_shape.name = "CollisionShape"

		phys_bone.add_child(col_shape)
		_physical_bone_entries.append({"bone": phys_bone, "bone_idx": i})

	GlobalLogger.info("RagdollSystem", "Created %d physical bones (skipped %d excluded/root/tiny)." % \
		[_physical_bone_entries.size(), bone_count - _physical_bone_entries.size()])

## 找到最近的已生成物理祖先，避免被过滤的辅助骨骼打断关节拓扑。
func _find_physical_parent(bone_idx: int, simulated_bones: Dictionary) -> int:
	var parent_idx := _skeleton.get_bone_parent(bone_idx)
	while parent_idx >= 0:
		if simulated_bones.has(parent_idx):
			return parent_idx
		parent_idx = _skeleton.get_bone_parent(parent_idx)
	return -1

## 无需模型特定轴向的保守人体关节限制。
func _configure_cone_joint(physical_bone: PhysicalBone3D, bone_name: String) -> void:
	physical_bone.joint_type = PhysicalBone3D.JOINT_TYPE_CONE
	var swing_span := 45.0
	var twist_span := 25.0
	if "ForeArm" in bone_name or "Leg" in bone_name and not "UpLeg" in bone_name:
		swing_span = 35.0
		twist_span = 12.0
	elif "Shoulder" in bone_name or "Arm" in bone_name or "UpLeg" in bone_name:
		swing_span = 70.0
		twist_span = 35.0
	elif "Spine" in bone_name or "Neck" in bone_name or "Head" in bone_name:
		swing_span = 30.0
		twist_span = 20.0
	physical_bone.set("joint_constraints/swing_span", swing_span)
	physical_bone.set("joint_constraints/twist_span", twist_span)
	physical_bone.set("joint_constraints/softness", 0.8)
	physical_bone.set("joint_constraints/relaxation", 1.0)

func _get_collider_radius(bone_name: String, bone_length: float) -> float:
	if "Hips" in bone_name:
		return _config.pelvis_radius
	if "Spine" in bone_name or "Shoulder" in bone_name:
		return _config.torso_radius
	if "UpLeg" in bone_name:
		return maxf(0.09, _config.minimum_bone_radius)
	if "Leg" in bone_name:
		return maxf(0.07, _config.minimum_bone_radius)
	if "Arm" in bone_name:
		return maxf(0.055, _config.minimum_bone_radius)
	if "Hand" in bone_name or "Foot" in bone_name:
		return maxf(0.06, _config.minimum_bone_radius)
	return maxf(bone_length * _config.bone_radius_scale, _config.minimum_bone_radius)

## 返回从当前骨骼关节到一个有效子骨骼的局部向量。
## 叶骨骼回退为指向父关节的半段，避免手、脚末端产生零尺寸刚体。
func _get_bone_segment(bone_idx: int) -> Vector3:
	var children := _skeleton.get_bone_children(bone_idx)
	var longest := Vector3.ZERO
	for child_idx in children:
		var child_name := _skeleton.get_bone_name(child_idx)
		if _is_bone_excluded(child_name):
			continue
		var candidate: Vector3 = _skeleton.get_bone_rest(child_idx).origin
		if candidate.length_squared() > longest.length_squared():
			longest = candidate
	if not longest.is_zero_approx():
		return longest

	var parent_idx := _skeleton.get_bone_parent(bone_idx)
	if parent_idx < 0:
		return Vector3.ZERO
	var rest := _skeleton.get_bone_rest(bone_idx)
	return rest.basis.inverse() * -rest.origin * 0.5

## 检查骨骼名是否匹配任一排除关键词
func _is_bone_excluded(bone_name: String) -> bool:
	for keyword in _config.exclude_bone_keywords:
		if bone_name.contains(keyword):
			return true
	return false

# 私有 — 阶段切换 ──────────────────────────────────────────

## 从死亡动画切换到物理模拟阶段
func _start_physics_phase() -> void:
	_current_phase = RagdollPhase.RAGDOLL_PHYSICS

	# 停止 AnimationPlayer（动画已播完）
	if _animator:
		_animator.active = false

	# 隐藏武器，避免武器挂载点仍跟骨骼动画而武器竖立不倒
	if is_instance_valid(_weapon_mount):
		_weapon_mount.visible = false

	# 启动物理骨骼模拟
	if not is_instance_valid(_physical_simulator):
		GlobalLogger.error("RagdollSystem", "Cannot start physics without PhysicalBoneSimulator3D")
		return
	_physical_simulator.physical_bones_start_simulation()

	# 施加冲击力
	_apply_impact_force(_pending_death_type, _pending_impact_direction)

	set_process(false)
	ragdoll_physics_started.emit()
	GlobalLogger.info("RagdollSystem", "Physics simulation started")

# 私有 — 冲击力 ──────────────────────────────────────────────

## 根据死亡类型和方向对上身骨骼施加冲击力
func _apply_impact_force(death_type: DeathType, direction: Vector3) -> void:
	# 确定冲击力大小
	var force_magnitude := _config.default_impact_force
	var is_headshot: bool = death_type in [
		DeathType.FRONT_HEADSHOT, DeathType.BACK_HEADSHOT, DeathType.CROUCHING_HEADSHOT
	]

	if is_headshot:
		force_magnitude *= _config.headshot_force_multiplier
	elif death_type == DeathType.EXPLOSION:
		force_magnitude = _config.explosion_force

	# 默认方向：死亡类型推断
	if direction == Vector3.ZERO:
		direction = _get_default_impact_direction(death_type)

	var dir_normalized := direction.normalized()

	# 收集受力骨骼。force_magnitude 表示整个身体的总冲量，不能对每块骨骼重复全额施加。
	var targets: Array[PhysicalBone3D] = []
	for entry in _physical_bone_entries:
		var pb: PhysicalBone3D = entry["bone"]
		if not is_instance_valid(pb):
			continue
		var bn: String = pb.bone_name
		var is_upper := false
		for keyword in _config.upper_body_keywords:
			if keyword in bn:
				is_upper = true
				break
		if not is_upper:
			continue

		targets.append(pb)

	# 配置使用牛顿，而 apply_central_impulse() 使用 N·s。将 1~2 个物理帧的
	# 短时力转换为一次等效冲量，避免把 500 N 错当成 500 N·s 发射角色。
	var physics_hz := maxf(float(Engine.physics_ticks_per_second), 1.0)
	var impact_duration := float(_config.impact_force_frames) / physics_hz
	var total_impulse := force_magnitude * impact_duration
	var impulse_per_bone := total_impulse / maxf(float(targets.size()), 1.0)
	for target in targets:
		target.apply_central_impulse(dir_normalized * impulse_per_bone)

	# 爆头：对头部骨骼额外施加更大的力
	if is_headshot:
		for entry in _physical_bone_entries:
			var pb: PhysicalBone3D = entry["bone"]
			if not is_instance_valid(pb):
				continue
			if "Head" in pb.bone_name:
				pb.apply_central_impulse(dir_normalized * total_impulse * 0.5)
				GlobalLogger.debug("RagdollSystem", "Headshot extra impulse on %s: %.2f N*s" % [pb.bone_name, total_impulse * 0.5])
				break

	GlobalLogger.info("RagdollSystem", "Applied %.1f N for %d physics frame(s) = %.2f N*s across %d bones (dir: %s)" % \
		[force_magnitude, _config.impact_force_frames, total_impulse, targets.size(), dir_normalized])

## 根据死亡类型推断默认的冲击力方向（世界空间）
func _get_default_impact_direction(death_type: DeathType) -> Vector3:
	var local_direction: Vector3
	match death_type:
		DeathType.FRONT, DeathType.FRONT_HEADSHOT:
			local_direction = Vector3.BACK
		DeathType.BACK, DeathType.BACK_HEADSHOT:
			local_direction = Vector3.FORWARD
		DeathType.RIGHT:
			local_direction = Vector3.LEFT
		DeathType.EXPLOSION:
			local_direction = Vector3.UP + Vector3.BACK * 0.5
		DeathType.CROUCHING_HEADSHOT:
			local_direction = Vector3.BACK + Vector3.UP * 0.3
		_:
			local_direction = Vector3.BACK + Vector3.UP * 0.3
	var player := get_parent() as Node3D
	return player.global_basis * local_direction if is_instance_valid(player) else local_direction

# 私有 — 动画选择 ──────────────────────────────────────────

## 根据死亡类型返回 AnimationPlayer 中的动画路径
func _select_death_animation(death_type: DeathType) -> String:
	return DEATH_ANIM_PATHS.get(death_type, DEATH_ANIM_PATHS[DeathType.GENERIC])

# 私有 — 姿态保存/恢复 ──────────────────────────────────────

## 保存当前所有骨骼的全局姿态，供复活恢复使用
func _save_bone_poses() -> void:
	_saved_bone_poses.clear()
	var bone_count := _skeleton.get_bone_count()
	for i in bone_count:
		_saved_bone_poses[i] = _skeleton.get_bone_global_pose(i)
	GlobalLogger.debug("RagdollSystem", "Saved %d bone poses." % bone_count)

## 恢复之前保存的骨骼姿态（用于复活时从布娃娃状态恢复）
func _restore_bone_poses() -> void:
	if _saved_bone_poses.is_empty():
		return
	_skeleton.clear_bones_global_pose_override()
	var bone_count := _skeleton.get_bone_count()
	for i in bone_count:
		if _saved_bone_poses.has(i):
			# persistent=false：只覆盖一帧，避免死亡姿态永久压过复活后的 AnimationTree 输出
			_skeleton.set_bone_global_pose_override(i, _saved_bone_poses[i], 1.0, false)
	_saved_bone_poses.clear()
	GlobalLogger.debug("RagdollSystem", "Restored bone poses.")
