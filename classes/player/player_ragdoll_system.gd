class_name PlayerRagdollSystem
extends Node

# ============================================================
# 布娃娃物理系统
# 功能：管理玩家的布娃娃物理效果。PhysicalBone3D 和关节由角色场景预制，
#       系统只负责筛选、配置碰撞层并在死亡时启动模拟；
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
var _fp_hidden_meshes: Array[MeshInstance3D] = []  # 第一人称隐藏的头部 mesh（layer 2）

## 场景预制的物理骨骼列表。每项存储 {"bone": PhysicalBone3D, "bone_idx": int}
var _physical_bone_entries: Array = []

## 死亡动画到物理阶段的倒计时（秒）
var _death_anim_timer: float = 0.0

## 待施加的冲击方向（物理阶段启动时使用）
var _pending_impact_direction: Vector3 = Vector3.ZERO

## 最后一次命中的动能（J）；由 HealthSystem 传入，布娃娃系统不读取武器
var _pending_impact_energy_j: float = 0.0

## 最后一次命中的弹头/等效质量（kg）
var _pending_impact_mass_kg: float = 0.0

## 最后一次命中的通用伤害类型
var _pending_impact_damage_type: MedicalEnums.DamageType = MedicalEnums.DamageType.BULLET

## CharacterBody3D 在死亡瞬间的世界速度；用于保留移动中的尸体惯性。
var _pending_inherited_velocity: Vector3 = Vector3.ZERO

## 待施加冲击的死亡类型
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
## skeleton:      模型中的 Skeleton3D，用于查找预制物理骨骼和启动模拟
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

	# 收集第一人称隐藏的头部 mesh（layers 包含 layer 2，即 layers & 2 != 0）
	_fp_hidden_meshes.clear()
	if is_instance_valid(_skeleton):
		var model_root := _skeleton.get_parent()
		if is_instance_valid(model_root):
			for mi in model_root.find_children("*", "MeshInstance3D", true, false):
				var mesh := mi as MeshInstance3D
				if mesh and (mesh.layers & 2):
					_fp_hidden_meshes.append(mesh)

	if not _skeleton:
		GlobalLogger.warn("RagdollSystem", "Initialized without skeleton; ragdoll disabled.")
		return
	_prepare_authored_physics_bones()
	GlobalLogger.info("RagdollSystem", "Initialized with skeleton: %s" % _skeleton.name)

## 清除仅属于旧模型骨骼的缓存。模型热重载时 initialize() 会再次调用。
func _reset_skeleton_state() -> void:
	if is_instance_valid(_physical_simulator):
		if _physical_simulator.is_simulating_physics():
			_physical_simulator.physical_bones_stop_simulation()
	_physical_simulator = null
	_physical_bone_entries.clear()
	_saved_bone_poses.clear()
	_fp_hidden_meshes.clear()
	_is_active = false
	_current_phase = RagdollPhase.INACTIVE
	_death_anim_timer = 0.0
	set_process(false)


## 只使用角色场景中预制的物理骨骼。关节、碰撞形状和骨骼范围由场景资产控制，
## 代码不再创建第二套 PhysicalBone3D。
func _prepare_authored_physics_bones() -> void:
	if not is_instance_valid(_skeleton):
		return
	_physical_bone_entries.clear()
	var simulators: Array[PhysicalBoneSimulator3D] = _collect_simulators(_skeleton)
	for simulator_node in simulators:
		var simulator := simulator_node as PhysicalBoneSimulator3D
		if not simulator:
			continue
		if simulator.is_simulating_physics():
			simulator.physical_bones_stop_simulation()
		if is_instance_valid(_physical_simulator):
			GlobalLogger.error("RagdollSystem", "Model must contain exactly one PhysicalBoneSimulator3D.")
			_physical_simulator = null
			_physical_bone_entries.clear()
			return
		_physical_simulator = simulator
		simulator.active = true

		for bone in _collect_physical_bones(simulator):
			bone.collision_layer = _config.ragdoll_collision_layer
			bone.collision_mask = _config.ragdoll_collision_mask
			bone.collision_priority = 5.0
			# PhysicalBone3D 的质量和阻尼默认由引擎决定；若不覆盖，
			# 预制骨骼会过轻，普通枪击也会把尸体明显踢飞。
			bone.mass = maxf(_config.mass, 0.1)
			bone.linear_damp = maxf(_config.linear_damping, 0.0)
			bone.angular_damp = maxf(_config.angular_damping, 0.0)
			var bone_idx := _skeleton.find_bone(bone.bone_name)
			if bone_idx >= 0:
				_physical_bone_entries.append({"bone": bone, "bone_idx": bone_idx, "physical_parent_idx": _skeleton.get_bone_parent(bone_idx)})

	if not is_instance_valid(_physical_simulator):
		GlobalLogger.error("RagdollSystem", "No authored PhysicalBoneSimulator3D found; dynamic creation is disabled.")
		return
	_configure_self_collision_exceptions()
	GlobalLogger.info("RagdollSystem", "Using authored simulator '%s' with %d physical bones (%d bound to Skeleton)." % [
		_physical_simulator.name,
		_collect_physical_bones(_physical_simulator).size(),
		_physical_bone_entries.size()
	])


func _collect_simulators(root: Node) -> Array[PhysicalBoneSimulator3D]:
	var result: Array[PhysicalBoneSimulator3D] = []
	for child in root.get_children():
		if child is PhysicalBoneSimulator3D:
			result.append(child)
		result.append_array(_collect_simulators(child))
	return result


func _collect_physical_bones(root: Node) -> Array[PhysicalBone3D]:
	var result: Array[PhysicalBone3D] = []
	for child in root.get_children():
		if child is PhysicalBone3D:
			result.append(child)
		result.append_array(_collect_physical_bones(child))
	return result

## 设置武器挂载点（死亡时隐藏、复活时恢复）
## 挂载点在 initialize() 之后才由 BasePlayer 查找到，因此单独提供设置入口
func set_weapon_mount(weapon_mount: Node3D) -> void:
	_weapon_mount = weapon_mount

# 公开方法 ──────────────────────────────────────────────────

## 启动死亡流程
## 依序执行：保存当前骨骼姿态 → 播放死亡动画 → 等待过渡时间 → 启动物理模拟
## death_type:       死亡类型，决定动画选择和冲击力默认方向
## impact_direction: 冲击方向（世界空间），Vector3.ZERO 时使用类型对应的默认方向
## impact_energy_j / impact_mass_kg: 通用命中物理数据，不依赖武器实现。
func enable(
	death_type: DeathType = DeathType.GENERIC,
	impact_direction: Vector3 = Vector3.ZERO,
	impact_energy_j: float = 0.0,
	impact_mass_kg: float = 0.0,
	impact_damage_type: MedicalEnums.DamageType = MedicalEnums.DamageType.BULLET,
	inherited_velocity: Vector3 = Vector3.ZERO
) -> void:
	if _is_active or not _skeleton:
		return

	if not is_instance_valid(_physical_simulator):
		GlobalLogger.error("RagdollSystem", "Cannot start ragdoll without authored PhysicalBoneSimulator3D.")
		return

	_is_active = true

	# JiYu 的稳定 IK 使用 persistent 骨骼覆盖。死亡后 BasePlayer 停止更新 IK，
	# 此处一次性释放最后一帧覆盖，再将骨骼所有权交给死亡动画/物理模拟。
	_skeleton.clear_bones_global_pose_override()

	# Step 1: 保存当前骨骼姿态（供复活恢复）
	_save_bone_poses()

	# Step 2: 关闭 AnimationTree，防止它覆盖骨骼姿态
	if is_instance_valid(_animation_tree):
		_animation_tree.active = false

	# Step 3: 选择并播放死亡动画（仅在配置启用时）
	_pending_impact_direction = impact_direction
	_pending_impact_energy_j = maxf(impact_energy_j, 0.0)
	_pending_impact_mass_kg = maxf(impact_mass_kg, 0.0)
	_pending_impact_damage_type = impact_damage_type
	_pending_inherited_velocity = inherited_velocity
	_pending_death_type = death_type
	_current_phase = RagdollPhase.DEATH_ANIMATION

	var played_animation := false
	if _config.play_death_animation and _animator:
		var death_anim: String = _select_death_animation(death_type)
		_animator.stop()
		_animator.active = true
		if _animator.has_animation(death_anim):
			_animator.play(death_anim)
			death_animation_started.emit(death_anim)
			GlobalLogger.info("RagdollSystem", "Death animation started: %s" % death_anim)
			played_animation = true
		else:
			GlobalLogger.warn("RagdollSystem", "Death animation not found: %s, entering physics directly." % death_anim)

	# Step 4: 有动画则等待计时器，否则立即进入物理阶段
	if played_animation:
		_death_anim_timer = _config.death_anim_to_ragdoll_time
		set_process(true)
	else:
		_start_physics_phase()

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

	# 复活：头部 mesh 恢复 layer 1+2，投影正常工作
	for mesh in _fp_hidden_meshes:
		if is_instance_valid(mesh):
			mesh.layers = 3

	_is_active = false
	_current_phase = RagdollPhase.INACTIVE
	set_process(false)

	ragdoll_disabled.emit()
	GlobalLogger.info("RagdollSystem", "Ragdoll disabled")

## 非相邻部位互相碰撞以阻止穿模；关节邻居、同父兄弟和祖孙骨骼保持例外，
## 避免静止姿态中本就重叠的胶囊体产生巨大分离冲量。
func _configure_self_collision_exceptions() -> void:
	if not _config.enable_self_collision:
		return
	for i in range(_physical_bone_entries.size()):
		var entry_a: Dictionary = _physical_bone_entries[i]
		var bone_a: PhysicalBone3D = entry_a["bone"]
		for j in range(i + 1, _physical_bone_entries.size()):
			var entry_b: Dictionary = _physical_bone_entries[j]
			if not _should_ignore_self_collision(entry_a, entry_b):
				continue
			var bone_b: PhysicalBone3D = entry_b["bone"]
			bone_a.add_collision_exception_with(bone_b)
			bone_b.add_collision_exception_with(bone_a)

func _should_ignore_self_collision(entry_a: Dictionary, entry_b: Dictionary) -> bool:
	var idx_a: int = entry_a["bone_idx"]
	var idx_b: int = entry_b["bone_idx"]
	var parent_a: int = entry_a["physical_parent_idx"]
	var parent_b: int = entry_b["physical_parent_idx"]
	if parent_a == idx_b or parent_b == idx_a:
		return true
	if parent_a >= 0 and parent_a == parent_b:
		return true
	return _is_close_ancestor(idx_a, idx_b, 2) or _is_close_ancestor(idx_b, idx_a, 2)

func _is_close_ancestor(ancestor_idx: int, bone_idx: int, max_steps: int) -> bool:
	var current := _skeleton.get_bone_parent(bone_idx)
	for _step in max_steps:
		if current < 0:
			return false
		if current == ancestor_idx:
			return true
		current = _skeleton.get_bone_parent(current)
	return false

# 私有 — 阶段切换 ──────────────────────────────────────────

## 从死亡动画切换到物理模拟阶段
func _start_physics_phase() -> void:
	if not is_instance_valid(_physical_simulator):
		GlobalLogger.error("RagdollSystem", "Cannot start physics without PhysicalBoneSimulator3D")
		_is_active = false
		_current_phase = RagdollPhase.INACTIVE
		set_process(false)
		return

	_current_phase = RagdollPhase.RAGDOLL_PHYSICS

	# 停止 AnimationPlayer（动画已播完）
	if _animator:
		_animator.active = false

	# 隐藏武器，避免武器挂载点仍跟骨骼动画而武器竖立不倒
	if is_instance_valid(_weapon_mount):
		_weapon_mount.visible = false

	# 本地玩家的头部只保留第一人称隐藏层；Bot 没有本地摄像机，必须继续对世界摄像机可见。
	var player := get_parent()
	var belongs_to_bot: bool = bool(player.get("is_bot")) if player else false
	for mesh in _fp_hidden_meshes:
		if is_instance_valid(mesh):
			mesh.layers = 3 if belongs_to_bot else 2

	# 物理骨架已经由场景资产完整定义，直接启动该模拟器下的全部预制骨骼。
	_physical_simulator.physical_bones_start_simulation()
	_apply_inherited_velocity()

	# 用命中能量和质量计算动量后施加冲量
	_apply_impact_impulse(
		_pending_death_type,
		_pending_impact_direction,
		_pending_impact_energy_j,
		_pending_impact_mass_kg,
		_pending_impact_damage_type
	)

	set_process(false)
	ragdoll_physics_started.emit()
	GlobalLogger.info("RagdollSystem", "Physics simulation started")

## 将死亡瞬间 CharacterBody3D 的速度复制到全部物理骨骼。
## 这是速度继承，不属于枪械命中冲量；枪械冲量仍由 _apply_impact_impulse() 计算。
func _apply_inherited_velocity() -> void:
	if _pending_inherited_velocity.length_squared() <= 0.0001:
		return
	for entry in _physical_bone_entries:
		var bone := entry["bone"] as PhysicalBone3D
		if is_instance_valid(bone):
			bone.linear_velocity = _pending_inherited_velocity

# 私有 — 动能冲量 ────────────────────────────────────────────

## 根据命中动能计算弹头动量，再按骨骼质量比例分配总冲量。
## p = m*v = sqrt(2*m*E)，因此这里没有固定的牛顿力或固定击飞力。
func _apply_impact_impulse(
	death_type: DeathType,
	direction: Vector3,
	impact_energy_j: float,
	impact_mass_kg: float,
	impact_damage_type: MedicalEnums.DamageType
) -> void:
	if impact_energy_j <= 0.0:
		# 控制台直接 die()、失血死亡等没有命中能量，不制造虚假飞行动量。
		return

	var effective_mass := impact_mass_kg
	if effective_mass <= 0.0:
		# 普通子弹/破片没有质量就无法从能量唯一确定动量；不猜一个质量，
		# 防止调试伤害被误当成重物产生异常尸体飞行。
		if impact_damage_type == MedicalEnums.DamageType.BULLET or \
				impact_damage_type == MedicalEnums.DamageType.FRAGMENT:
			return
		effective_mass = _config.fallback_impact_mass_kg
	effective_mass = maxf(effective_mass, 0.001)

	var is_headshot: bool = death_type in [
		DeathType.FRONT_HEADSHOT, DeathType.BACK_HEADSHOT, DeathType.CROUCHING_HEADSHOT
	]
	var transfer_ratio := _config.impact_energy_transfer
	if is_headshot:
		transfer_ratio = _config.headshot_energy_transfer
	elif death_type == DeathType.EXPLOSION or impact_damage_type == MedicalEnums.DamageType.EXPLOSION:
		transfer_ratio = _config.explosion_energy_transfer
	transfer_ratio = clampf(transfer_ratio, 0.0, 1.0)

	var total_impulse := sqrt(2.0 * effective_mass * impact_energy_j) * transfer_ratio
	if total_impulse <= 0.0:
		return

	# 默认方向：死亡类型推断
	if direction == Vector3.ZERO:
		direction = _get_default_impact_direction(death_type)

	var dir_normalized := direction.normalized()

	# 收集受力骨骼；总冲量不能对每块骨骼重复全额施加。
	var targets: Array[PhysicalBone3D] = []
	var total_target_mass := 0.0
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
		total_target_mass += maxf(pb.mass, 0.001)

	if targets.is_empty() or total_target_mass <= 0.0:
		return

	# 质量越大的骨骼获得的冲量份额越大，使同一组骨骼的初始速度响应一致。
	for target in targets:
		var mass_share := maxf(target.mass, 0.001) / total_target_mass
		target.apply_central_impulse(dir_normalized * total_impulse * mass_share)

	# 爆头：在已经按能量计算的总冲量之外，将少量动量集中到头部。
	if is_headshot:
		for entry in _physical_bone_entries:
			var pb: PhysicalBone3D = entry["bone"]
			if not is_instance_valid(pb):
				continue
			if "Head" in pb.bone_name:
				var extra_impulse := total_impulse * clampf(_config.headshot_extra_impulse_ratio, 0.0, 1.0)
				pb.apply_central_impulse(dir_normalized * extra_impulse)
				GlobalLogger.debug("RagdollSystem", "Headshot extra impulse on %s: %.2f kg*m/s" % [pb.bone_name, extra_impulse])
				break

	GlobalLogger.info("RagdollSystem", "Applied kinetic impulse %.2f kg*m/s (E=%.1f J, m=%.5f kg, transfer=%.2f) across %d bones (dir: %s)" % \
		[total_impulse, impact_energy_j, effective_mass, transfer_ratio, targets.size(), dir_normalized])

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
