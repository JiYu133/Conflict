class_name HealthSystem
extends Node

# ============================================================
# 医疗子系统
# 功能：管理玩家的全部伤情、出血、意识状态；
#       通过 apply_damage() 接受所有伤害输入；
#       将致命伤映射到现有 DeathType 并调用 BasePlayer.die()。
# 用法：由 BasePlayer._initialize_subsystems() 创建并初始化。
# ============================================================

# 信号 ────────────────────────────────────────────────────────
signal damage_taken(info: DamageInfo)
signal wound_added(wound: Wound)
signal bleeding_changed(total_rate_ml_per_sec: float)
signal blood_changed(pct: float)
signal state_changed(new_state: MedicalEnums.HealthState)
signal went_unconscious
signal medically_died(death_type: PlayerRagdollSystem.DeathType, direction: Vector3)

# 公开属性 ────────────────────────────────────────────────────
var vitals: VitalsModel = null
var current_state: MedicalEnums.HealthState = MedicalEnums.HealthState.HEALTHY

# 私有 ─────────────────────────────────────────────────────
var _player: BasePlayer = null
var _config: HealthConfig = null
var _tick_timer: float = 0.0
var _is_dead: bool = false
var _hitboxes: Array[BodyHitbox] = []  # 存活时的命中检测区域

# 初始化 ────────────────────────────────────────────────────

func initialize(player: BasePlayer, config: HealthConfig) -> void:
	_player = player
	_config = config if config else HealthConfig.new()
	vitals = VitalsModel.new()
	vitals.initialize(_config)

	# 监听模型加载完成，创建 hitbox
	if _player.model_manager:
		_player.model_manager.model_loaded.connect(_on_model_loaded)
		GlobalLogger.info("HealthSystem", "Listening for model_loaded signal")
	else:
		GlobalLogger.warn("HealthSystem", "No model_manager found!")

	GlobalLogger.info("HealthSystem", "Initialized for player: " + player.get_parent().name)

# 生命周期 ──────────────────────────────────────────────────

func _physics_process(delta: float) -> void:
	if _is_dead:
		return
	_tick_timer += delta
	if _tick_timer >= _config.tick_interval:
		_tick_timer = 0.0
		_run_physiology_tick(_config.tick_interval)

# 公开 API ──────────────────────────────────────────────────

## 唯一伤害入口。所有伤害均需通过此函数流入。
func apply_damage(info: DamageInfo) -> void:
	if _is_dead:
		return
	_apply_structural_damage(info)
	damage_taken.emit(info)
	_evaluate_state(info.direction)

## 应用治疗（P3 实现；P1 存根返回 false）
func apply_treatment(t: MedicalEnums.TreatmentType, part: MedicalEnums.BodyPartId) -> bool:
	GlobalLogger.debug("HealthSystem", "Treatment not yet implemented (P3)")
	return false

## 返回血量百分比（0.0–1.0）
func get_blood_pct() -> float:
	return vitals.get_blood_pct()

## 返回指定部位的健康度（0.0–1.0，基于累积伤口严重度）
## 0.0 = 摧毁级伤情，1.0 = 完好无损
func get_part_health(part: MedicalEnums.BodyPartId) -> float:
	var region := vitals.get_region(part)
	if not region:
		return 0.0
	var total_severity := region.get_total_severity()
	# 将累积 severity 映射到 0.0–1.0，severity=0 → 1.0，severity>=3.0 → 0.0
	return clampf(1.0 - total_severity / 3.0, 0.0, 1.0)

## 返回当前生理状态
func get_state() -> MedicalEnums.HealthState:
	return current_state

## 切换碰撞体可视化（调试用）
func set_hitboxes_visible(visible: bool) -> void:
	for hitbox in _hitboxes:
		if is_instance_valid(hitbox):
			hitbox.set_debug_visible(visible)

# 状态乘数查询（P4 实现；P1 返回默认值）
func get_movement_speed_multiplier() -> float:
	return 1.0

func get_aim_stability_multiplier() -> float:
	return 1.0

func can_sprint() -> bool:
	return true

# 私有 — 伤害处理 ──────────────────────────────────────────

func _apply_structural_damage(info: DamageInfo) -> void:
	var region := vitals.get_region(info.body_part)
	if not region:
		GlobalLogger.warn("HealthSystem", "Unknown body part: %d" % info.body_part)
		return

	# 动能 → 伤口严重度（无 HP 概念）
	# severity = KE / ke_per_severity_unit
	# 例：600J 基准，600J → 1.0 severity（重伤），1200J → 2.0（极重）
	var severity: float = info.amount / _config.ke_per_severity_unit

	# 创建伤口
	var wound := _build_wound(info, severity, region)
	region.add_wound(wound)
	wound_added.emit(wound)

	# 立即失血（液压冲击效应近似）
	var immediate_loss: float = severity * _config.immediate_blood_loss_per_severity
	vitals.blood_volume_ml = maxf(0.0, vitals.blood_volume_ml - immediate_loss)

	bleeding_changed.emit(vitals.total_bleed_rate())
	GlobalLogger.debug("HealthSystem", "Damage on %s: %.1f J → severity %.2f, wound #%d, bleed %s" % [
		MedicalEnums.BodyPartId.keys()[info.body_part],
		info.amount,
		severity,
		wound.wound_id,
		MedicalEnums.BleedRate.keys()[wound.bleed_rate]
	])

func _build_wound(info: DamageInfo, severity: float, region: BodyRegion) -> Wound:
	var w := Wound.new()
	w.wound_id = vitals.allocate_wound_id()
	w.body_part = info.body_part
	w.type = MedicalEnums.WoundType.PENETRATING if info.type == MedicalEnums.DamageType.BULLET else MedicalEnums.WoundType.BLUNT_TRAUMA
	if info.type == MedicalEnums.DamageType.EXPLOSION:
		w.type = MedicalEnums.WoundType.BLAST_TRAUMA

	w.severity = severity
	w.bleed_rate = _classify_bleed(severity, info.body_part)
	w.pain_contribution = severity * 0.5  # P4 存根
	return w

func _classify_bleed(severity: float, part: MedicalEnums.BodyPartId) -> MedicalEnums.BleedRate:
	# 头部和躯干的伤口更容易触发动脉出血
	var is_vital: bool = part in [MedicalEnums.BodyPartId.HEAD, MedicalEnums.BodyPartId.TORSO]
	if severity >= 0.6 and is_vital:
		return MedicalEnums.BleedRate.ARTERIAL
	elif severity >= 0.4:
		return MedicalEnums.BleedRate.VENOUS
	elif severity >= 0.1:
		return MedicalEnums.BleedRate.CAPILLARY
	return MedicalEnums.BleedRate.NONE

# 私有 — 生理 Tick ──────────────────────────────────────────

func _run_physiology_tick(dt: float) -> void:
	# P1: 仅处理外部出血
	var bleed: float = vitals.total_bleed_rate()
	if bleed > 0.0:
		vitals.blood_volume_ml = maxf(0.0, vitals.blood_volume_ml - bleed * dt)
		blood_changed.emit(vitals.get_blood_pct())

	_evaluate_state(Vector3.ZERO)

# 私有 — 状态评估与死亡桥 ──────────────────────────────────

func _evaluate_state(last_hit_direction: Vector3) -> void:
	if _is_dead:
		return

	var new_state := _compute_state()
	if new_state != current_state:
		current_state = new_state
		state_changed.emit(current_state)
		GlobalLogger.debug("HealthSystem", "State → " + MedicalEnums.HealthState.keys()[current_state])

	match current_state:
		MedicalEnums.HealthState.DEAD:
			_trigger_death(last_hit_direction)
		MedicalEnums.HealthState.UNCONSCIOUS:
			if _player.controllable:
				_player.controllable = false
				went_unconscious.emit()

func _compute_state() -> MedicalEnums.HealthState:
	# 单发致命伤判定（头部/躯干被摧毁性创伤击中）
	var head_region := vitals.get_region(MedicalEnums.BodyPartId.HEAD)
	if head_region and head_region.has_lethal_wound(_config.head_lethal_severity):
		return MedicalEnums.HealthState.DEAD

	var torso_region := vitals.get_region(MedicalEnums.BodyPartId.TORSO)
	if torso_region and torso_region.has_lethal_wound(_config.torso_lethal_severity):
		return MedicalEnums.HealthState.DEAD

	# 累积伤口致命判定（多次重伤累积导致器官衰竭）
	if head_region and head_region.get_total_severity() >= _config.head_cumulative_lethal:
		return MedicalEnums.HealthState.DEAD

	if torso_region and torso_region.get_total_severity() >= _config.torso_cumulative_lethal:
		return MedicalEnums.HealthState.DEAD

	# 失血性休克/死亡
	var blood_pct: float = vitals.get_blood_pct()
	if blood_pct <= _config.fatal_blood_threshold_pct:
		return MedicalEnums.HealthState.DEAD
	if blood_pct <= _config.critical_blood_threshold_pct:
		return MedicalEnums.HealthState.CRITICAL

	# 有伤 = INJURED
	for part_id: int in vitals.regions:
		var region := vitals.regions[part_id] as BodyRegion
		if region.wounds.size() > 0:
			return MedicalEnums.HealthState.INJURED

	return MedicalEnums.HealthState.HEALTHY

func _trigger_death(impact_direction: Vector3) -> void:
	if _is_dead:
		return
	_is_dead = true

	var death_type := _resolve_death_type(impact_direction)
	GlobalLogger.info("HealthSystem", "Medical death (type: %s, dir: %s)" % [
		PlayerRagdollSystem.DeathType.keys()[death_type],
		impact_direction
	])
	medically_died.emit(death_type, impact_direction)
	_player.die(death_type, impact_direction)

func _resolve_death_type(dir: Vector3) -> PlayerRagdollSystem.DeathType:
	# 将致命伤情 + 最后击中方向映射到现有 DeathType
	var head_region := vitals.get_region(MedicalEnums.BodyPartId.HEAD)
	var head_lethal: bool = head_region and (
		head_region.has_lethal_wound(_config.head_lethal_severity) or
		head_region.get_total_severity() >= _config.head_cumulative_lethal
	)

	# 判断是否正面（dir 指向玩家的入射方向，与玩家朝向 dot > 0 为正面）
	var from_front: bool = false
	if dir != Vector3.ZERO:
		from_front = dir.dot(_player.global_basis.z) > 0.0

	if head_lethal:
		# 蹲姿爆头优先判定
		if _player.movement_controller and _player.movement_controller.is_crouching():
			return PlayerRagdollSystem.DeathType.CROUCHING_HEADSHOT
		return PlayerRagdollSystem.DeathType.FRONT_HEADSHOT if from_front else PlayerRagdollSystem.DeathType.BACK_HEADSHOT

	# 检查所有伤口，看是否有爆炸伤
	for part_id: int in vitals.regions:
		for wound in (vitals.regions[part_id] as BodyRegion).wounds:
			if (wound as Wound).type == MedicalEnums.WoundType.BLAST_TRAUMA:
				return PlayerRagdollSystem.DeathType.EXPLOSION

	# 方向未知时返回 GENERIC
	if dir == Vector3.ZERO:
		return PlayerRagdollSystem.DeathType.GENERIC

	return PlayerRagdollSystem.DeathType.FRONT if from_front else PlayerRagdollSystem.DeathType.BACK


# 私有 — 模型加载与 Hitbox 创建 ────────────────────────────

func _on_model_loaded(_model: Node3D) -> void:
	GlobalLogger.info("HealthSystem", "model_loaded signal received, creating hitboxes...")
	_create_hitboxes()


## 为骨骼创建 BodyHitbox（Area3D + CollisionShape3D）
func _create_hitboxes() -> void:
	if not _player or not _player.model_manager or not _player.model_manager.skeleton:
		GlobalLogger.warn("HealthSystem", "Cannot create hitboxes: skeleton not found")
		return

	var skeleton := _player.model_manager.skeleton
	GlobalLogger.info("HealthSystem", "Skeleton found: " + skeleton.name)

	# 调试：列出所有骨骼名称
	GlobalLogger.info("HealthSystem", "Total bones: " + str(skeleton.get_bone_count()))
	for i in range(min(skeleton.get_bone_count(), 20)):  # 只显示前20个
		GlobalLogger.debug("HealthSystem", "Bone[%d]: %s" % [i, skeleton.get_bone_name(i)])

	# 获取碰撞体配置（优先使用 HealthConfig 中的配置，否则使用默认）
	var hitbox_cfg := _config.hitbox_config if _config.hitbox_config else HitboxConfig.new()
	GlobalLogger.info("HealthSystem", "Using HitboxConfig: " + ("custom" if _config.hitbox_config else "default"))

	# 骨骼名称 → 身体部位映射（使用实际骨骼名称：mixamorig_）
	# 扩展：躯干分为胸部和腹部，手臂和腿分为前后两段
	var bone_mapping: Dictionary = {
		"mixamorig_Head": MedicalEnums.BodyPartId.HEAD,
		# 躯干：胸部 + 腹部
		"mixamorig_Spine2": MedicalEnums.BodyPartId.TORSO,
		"mixamorig_Spine1": MedicalEnums.BodyPartId.TORSO,
		# 左臂：上臂 + 前臂
		"mixamorig_LeftArm": MedicalEnums.BodyPartId.LEFT_ARM,
		"mixamorig_LeftForeArm": MedicalEnums.BodyPartId.LEFT_ARM,
		# 右臂：上臂 + 前臂
		"mixamorig_RightArm": MedicalEnums.BodyPartId.RIGHT_ARM,
		"mixamorig_RightForeArm": MedicalEnums.BodyPartId.RIGHT_ARM,
		# 左腿：大腿 + 小腿
		"mixamorig_LeftUpLeg": MedicalEnums.BodyPartId.LEFT_LEG,
		"mixamorig_LeftLeg": MedicalEnums.BodyPartId.LEFT_LEG,
		# 右腿：大腿 + 小腿
		"mixamorig_RightUpLeg": MedicalEnums.BodyPartId.RIGHT_LEG,
		"mixamorig_RightLeg": MedicalEnums.BodyPartId.RIGHT_LEG,
	}

	# 为每个部位创建碰撞盒
	for bone_name: String in bone_mapping:
		var part_id: MedicalEnums.BodyPartId = bone_mapping[bone_name]
		var bone_idx := skeleton.find_bone(bone_name)
		if bone_idx < 0:
			GlobalLogger.warn("HealthSystem", "Bone not found: " + bone_name)
			continue

		GlobalLogger.info("HealthSystem", "Creating hitbox for: " + bone_name + " (bone index: " + str(bone_idx) + ")")

		# 创建 BoneAttachment3D 作为 hitbox 的父节点
		var bone_attach := BoneAttachment3D.new()
		bone_attach.bone_name = bone_name
		bone_attach.name = "Hitbox_" + bone_name.replace("mixamorig_", "")
		skeleton.add_child(bone_attach)

		# 创建 BodyHitbox（Area3D）
		var hitbox := BodyHitbox.new()
		var shape := hitbox_cfg.create_shape_for_bone(bone_name, part_id)
		hitbox.setup(part_id, shape, hitbox_cfg.debug_color)
		hitbox.name = "Hitbox_" + MedicalEnums.BodyPartId.keys()[part_id]

		# 应用局部位置和旋转偏移（按骨骼名称）
		hitbox.position = hitbox_cfg.get_offset_for_bone(bone_name)
		hitbox.rotation_degrees = hitbox_cfg.get_rotation_for_bone(bone_name)

		bone_attach.add_child(hitbox)

		_hitboxes.append(hitbox)

	GlobalLogger.info("HealthSystem", "Created %d hitboxes" % _hitboxes.size())
