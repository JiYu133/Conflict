class_name HealthSystem
extends Node

# ============================================================
# 医疗子系统
# 功能：管理玩家的全部伤情、出血、意识状态；
#       通过 apply_damage() 接受所有伤害输入；
#       将致命伤映射到现有 DeathType 并调用 BasePlayer.die()。
# 用法：由 BasePlayer._initialize_subsystems() 创建并初始化。
#
# 数据流总览：
#   武器开火 → Ballistics.kinetic_energy() → HitResolver.resolve()
#       → DamageInfo → HealthSystem.apply_damage()
#           → _apply_structural_damage()  （创建 Wound，立即失血）
#           → _evaluate_state()           （状态机 + 死亡判定）
#   HealthSystem._physics_process()（每 tick_interval 秒）
#       → VitalsModel.total_bleed_rate() → 持续扣血 → blood_changed 信号
#
# 碰撞体生命周期：
#   存活：BoneAttachment3D + BodyHitbox（Area3D），由 _create_hitboxes() 在模型加载后创建
#   死亡：_on_player_died() 销毁全部 hitbox，后续命中由 PhysicalBone3D
#         ragdoll 碰撞体接管（HitResolver 按骨骼名映射部位）
#   复活：_on_player_revived() 重建 hitbox 并重置生理状态
# ============================================================

# 信号 ────────────────────────────────────────────────────────
signal damage_taken(info: DamageInfo)
signal wound_added(wound: Wound)
signal bleeding_changed(total_rate_ml_per_sec: float)
signal blood_changed(pct: float)
signal state_changed(new_state: MedicalEnums.HealthState)
signal went_unconscious
signal medically_died(death_type: PlayerRagdollSystem.DeathType, direction: Vector3)
signal pain_changed(level: float)
## P2：器官受损/被摧毁（structure_id 见 AnatomyConfig，如 &"heart"）
signal organ_damaged(part: MedicalEnums.BodyPartId, structure_id: StringName, new_state: MedicalEnums.OrganState)
## P2：骨折
signal bone_fractured(part: MedicalEnums.BodyPartId, structure_id: StringName)

# 公开属性 ────────────────────────────────────────────────────
var vitals: VitalsModel = null
var current_state: MedicalEnums.HealthState = MedicalEnums.HealthState.HEALTHY

# 私有 ─────────────────────────────────────────────────────
var _player: BasePlayer = null
var _config: HealthConfig = null
var _tick_timer: float = 0.0
var _is_dead: bool = false
var _hitboxes: Array[BodyHitbox] = []  # 存活时的命中检测区域
var _last_hit_direction: Vector3 = Vector3.ZERO  # 最后一次受击方向，供失血死亡时选择死亡动画
var _last_hit_energy_j: float = 0.0  # 最后一次命中携带的动能/冲击能量
var _last_hit_mass_kg: float = 0.0  # 最后一次命中的等效质量，用于由能量反推动量
var _last_hit_damage_type: MedicalEnums.DamageType = MedicalEnums.DamageType.BULLET
var _anatomy: AnatomyConfig = null  # P2 解剖模型
var _rng := RandomNumberGenerator.new()  # 解剖损伤概率判定
var _lethal_organ_destroyed: bool = false  # 心/脑等关键器官被摧毁 → 直接死亡

# 初始化 ────────────────────────────────────────────────────

func initialize(player: BasePlayer, config: HealthConfig) -> void:
	_player = player
	_config = config if config else HealthConfig.new()
	vitals = VitalsModel.new()
	vitals.initialize(_config)
	_anatomy = _config.anatomy_config if _config.anatomy_config else AnatomyConfig.create_default()
	_rng.randomize()

	# 监听模型加载完成，创建 hitbox
	if _player.model_manager:
		_player.model_manager.model_loaded.connect(_on_model_loaded)
		GlobalLogger.info("HealthSystem", "Listening for model_loaded signal")
	else:
		GlobalLogger.warn("HealthSystem", "No model_manager found!")

	# 死亡时销毁 hitbox（命中检测交给布娃娃 PhysicalBone3D）；复活时重建并重置生理状态
	_player.died.connect(_on_player_died)
	_player.revived.connect(_on_player_revived)

	GlobalLogger.info("HealthSystem", "Initialized for player: %s" % player.name)

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
	if info.direction != Vector3.ZERO:
		# 缓存受击方向：之后失血死亡时仍能按最后中弹方向选择死亡动画，而非 GENERIC
		_last_hit_direction = info.direction
	if info.amount > 0.0:
		# 这里只保存通用伤害数据，不依赖武器或布娃娃系统。
		# amount 在 Combat 管线中是焦耳；非弹道伤害若未提供质量，后续使用配置的等效质量。
		_last_hit_energy_j = info.amount
		_last_hit_mass_kg = maxf(info.impact_mass_kg, 0.0)
		_last_hit_damage_type = info.type
	else:
		# 没有瞬时能量的脚本/状态伤害不能复用上一发弹药的动量。
		_last_hit_energy_j = 0.0
		_last_hit_mass_kg = 0.0
		_last_hit_damage_type = info.type
	_apply_structural_damage(info)
	damage_taken.emit(info)
	_evaluate_state(info.direction, true)

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

## 返回全部存活 hitbox 的物理 RID，供射手在 hitscan 射线中排除自身
func get_hitbox_rids() -> Array[RID]:
	var rids: Array[RID] = []
	for hitbox in _hitboxes:
		if is_instance_valid(hitbox):
			rids.append(hitbox.get_rid())
	return rids

# 状态乘数查询（P4）
func get_movement_speed_multiplier() -> float:
	if not vitals:
		return 1.0
	var mult := 1.0
	# 失血影响
	if vitals.get_blood_pct() <= _config.critical_blood_threshold_pct:
		mult *= 0.85
	# 腿部骨折/出血
	var leg_fracture := false
	for part: int in [
		MedicalEnums.BodyPartId.LEFT_THIGH,  MedicalEnums.BodyPartId.LEFT_CALF,
		MedicalEnums.BodyPartId.RIGHT_THIGH, MedicalEnums.BodyPartId.RIGHT_CALF,
	]:
		var region := vitals.get_region(part)
		if not region:
			continue
		if _region_has_fracture(region):
			leg_fracture = true
			break
		mult *= _limb_bleed_multiplier(region, 0.55, 0.80)
	if leg_fracture:
		mult *= 0.35
	return maxf(mult, 0.0)


func get_aim_stability_multiplier() -> float:
	if not vitals:
		return 1.0
	var mult := 1.0
	# 失血影响
	if vitals.get_blood_pct() <= _config.critical_blood_threshold_pct:
		mult *= 0.80
	# 呼吸受损
	mult *= vitals.breathing_effectiveness
	# 手臂骨折/出血
	var arm_fracture := false
	for part: int in [
		MedicalEnums.BodyPartId.LEFT_UPPER_ARM,  MedicalEnums.BodyPartId.LEFT_FOREARM,
		MedicalEnums.BodyPartId.RIGHT_UPPER_ARM, MedicalEnums.BodyPartId.RIGHT_FOREARM,
	]:
		var region := vitals.get_region(part)
		if not region:
			continue
		if _region_has_fracture(region):
			arm_fracture = true
			break
		mult *= _limb_bleed_multiplier(region, 0.55, 0.75)
	if arm_fracture:
		mult *= 0.30
	# 体力耗尽
	if _player.stamina_system:
		mult *= _player.stamina_system.get_aim_stability_multiplier()
	return maxf(mult, 0.0)


## 换弹速度乘数（体力耗尽时降低，供武器系统调用）
func get_reload_speed_multiplier() -> float:
	if not _player or not _player.stamina_system:
		return 1.0
	return _player.stamina_system.get_reload_speed_multiplier()


## 当前疼痛等级（0.0–1.0）
func get_pain_level() -> float:
	return vitals.pain_level if vitals else 0.0


## 腿骨折或体力配置禁止时禁止跳跃
func can_jump() -> bool:
	if not vitals:
		return true
	for part: int in [
		MedicalEnums.BodyPartId.LEFT_THIGH,  MedicalEnums.BodyPartId.LEFT_CALF,
		MedicalEnums.BodyPartId.RIGHT_THIGH, MedicalEnums.BodyPartId.RIGHT_CALF,
	]:
		var region := vitals.get_region(part)
		if region and _region_has_fracture(region):
			return false
	if _player.stamina_system and not _player.stamina_system.allows_jump():
		return false
	return true


func can_sprint() -> bool:
	if not vitals:
		return true
	if vitals.get_blood_pct() <= _config.critical_blood_threshold_pct:
		return false
	for part: int in [
		MedicalEnums.BodyPartId.LEFT_THIGH,  MedicalEnums.BodyPartId.LEFT_CALF,
		MedicalEnums.BodyPartId.RIGHT_THIGH, MedicalEnums.BodyPartId.RIGHT_CALF,
	]:
		var region := vitals.get_region(part)
		if not region:
			continue
		if _region_has_fracture(region):
			return false
		for w in region.wounds:
			if (w as Wound).bleed_rate == MedicalEnums.BleedRate.ARTERIAL:
				return false
	if _player.stamina_system and not _player.stamina_system.allows_sprint():
		return false
	return true


func _region_has_fracture(region: BodyRegion) -> bool:
	return region.fractured_bones.size() > 0


## arterial_mult: 动脉出血乘数, venous_mult: 静脉/毛细乘数
func _limb_bleed_multiplier(region: BodyRegion, arterial_mult: float, venous_mult: float) -> float:
	var highest := MedicalEnums.BleedRate.NONE
	for w in region.wounds:
		var rate: int = (w as Wound).bleed_rate
		if rate > highest:
			highest = rate
	match highest:
		MedicalEnums.BleedRate.ARTERIAL:
			return arterial_mult
		MedicalEnums.BleedRate.VENOUS, MedicalEnums.BleedRate.CAPILLARY:
			return venous_mult
		_:
			return 1.0

# 私有 — 伤害处理 ──────────────────────────────────────────

## 将 DamageInfo 转化为 Wound 并写入对应 BodyRegion。
## 同时触发立即失血（液压冲击近似）并发出 bleeding_changed 信号。
func _apply_structural_damage(info: DamageInfo) -> void:
	var region := vitals.get_region(info.body_part)
	if not region:
		GlobalLogger.warn("HealthSystem", "Unknown body part: %d" % info.body_part)
		return

	# 动能 → 伤口严重度（无 HP 概念）
	# severity = KE / ke_per_severity_unit
	# 例：600J 基准，600J → 1.0 severity（重伤），1200J → 2.0（极重）
	var severity: float = info.amount / _config.ke_per_severity_unit

	# 创建伤口（软组织出血分类；动脉出血由下方解剖判定升级）
	var wound := _build_wound(info, severity, region)

	# P2：解剖判定——伤道是否伤及器官/骨骼/大血管
	_resolve_anatomy(info, wound, severity, region)

	region.add_wound(wound)
	wound_added.emit(wound)

	# 立即失血（液压冲击效应近似）
	var immediate_loss: float = severity * _config.immediate_blood_loss_per_severity
	vitals.blood_volume_ml = maxf(0.0, vitals.blood_volume_ml - immediate_loss)

	bleeding_changed.emit(vitals.total_bleed_rate())
	GlobalLogger.debug("HealthSystem", "Damage on %s: %.1f J → severity %.2f, wound #%d, bleed %s/int %s" % [
		MedicalEnums.BodyPartId.keys()[info.body_part],
		info.amount,
		severity,
		wound.wound_id,
		MedicalEnums.BleedRate.keys()[wound.bleed_rate],
		MedicalEnums.BleedRate.keys()[wound.internal_bleed_rate]
	])


## P2：沿伤道求解内部结构损伤，并将结果写回伤口/部位状态。
## 有伤道信息（存活时命中 hitbox）→ 几何相交判定；
## 无伤道信息（爆炸/调试注入）→ 按截面占比盲判。
func _resolve_anatomy(info: DamageInfo, wound: Wound, severity: float, region: BodyRegion) -> void:
	var hits: Array
	if info.has_wound_channel():
		hits = AnatomySolver.solve_channel(
			info.local_entry, info.local_direction, info.amount,
			_anatomy.get_structures_for_bone(info.anchor_bone), _anatomy, _rng
		)
	else:
		hits = AnatomySolver.solve_blind(
			info.amount, _anatomy.get_structures_for_part(info.body_part), _rng
		)

	for h in hits:
		var hit := h as AnatomySolver.StructureHit
		var s := hit.structure
		match s.type:
			MedicalEnums.StructureType.MAJOR_VESSEL:
				_apply_vessel_damage(s, wound)
			MedicalEnums.StructureType.ORGAN:
				_apply_organ_damage(s, wound, severity * hit.damage_factor, region)
			MedicalEnums.StructureType.BONE:
				_apply_bone_fracture(s, wound, region)


## 大血管破裂：按血管定义升级伤口的外部/内部出血等级
func _apply_vessel_damage(s: AnatomyStructure, wound: Wound) -> void:
	if s.bleed_is_internal:
		wound.internal_bleed_rate = maxi(wound.internal_bleed_rate, s.severed_bleed) as MedicalEnums.BleedRate
	else:
		wound.bleed_rate = maxi(wound.bleed_rate, s.severed_bleed) as MedicalEnums.BleedRate
	GlobalLogger.info("HealthSystem", "Vessel severed: %s (%s, %s)" % [
		s.display_name, MedicalEnums.BleedRate.keys()[s.severed_bleed],
		"internal" if s.bleed_is_internal else "external"
	])


## 器官损伤：累积伤情、状态迁移（INTACT→DAMAGED→DESTROYED）、
## 内出血、呼吸惩罚；关键器官被摧毁直接致死
func _apply_organ_damage(s: AnatomyStructure, wound: Wound, damage: float, region: BodyRegion) -> void:
	var total: float = region.add_organ_damage(s.structure_id, damage)
	var new_state := MedicalEnums.OrganState.DESTROYED if total >= s.destroy_damage_threshold \
		else MedicalEnums.OrganState.DAMAGED

	var bleed: MedicalEnums.BleedRate = s.internal_bleed_destroyed \
		if new_state == MedicalEnums.OrganState.DESTROYED else s.internal_bleed_damaged
	wound.internal_bleed_rate = maxi(wound.internal_bleed_rate, bleed) as MedicalEnums.BleedRate

	if s.breathing_penalty > 0.0:
		vitals.breathing_effectiveness = maxf(0.0, vitals.breathing_effectiveness - s.breathing_penalty * damage)

	if new_state == MedicalEnums.OrganState.DESTROYED and s.lethal_when_destroyed:
		_lethal_organ_destroyed = true

	organ_damaged.emit(s.body_part, s.structure_id, new_state)
	GlobalLogger.info("HealthSystem", "Organ %s: damage %.2f (total %.2f) → %s" % [
		s.display_name, damage, total, MedicalEnums.OrganState.keys()[new_state]
	])


## 骨折：记录到部位、追加疼痛（幂等——同一骨骼只折一次）
func _apply_bone_fracture(s: AnatomyStructure, wound: Wound, region: BodyRegion) -> void:
	if region.is_fractured(s.structure_id):
		return
	region.add_fracture(s.structure_id)
	wound.pain_contribution += 0.3  # 骨折剧痛（P4 神经系统消费）
	bone_fractured.emit(s.body_part, s.structure_id)
	GlobalLogger.info("HealthSystem", "Bone fractured: %s" % s.display_name)

## 根据 DamageInfo 和 severity 构建 Wound 实例。
## WoundType 由伤害类型决定：BULLET→PENETRATING，EXPLOSION→BLAST_TRAUMA，其余→BLUNT_TRAUMA。
## [返回] 已填充好所有字段的 Wound（尚未加入 region，由调用方负责）。
func _build_wound(info: DamageInfo, severity: float, region: BodyRegion) -> Wound:
	var w := Wound.new()
	w.wound_id = vitals.allocate_wound_id()
	w.body_part = info.body_part
	w.type = MedicalEnums.WoundType.PENETRATING if info.type == MedicalEnums.DamageType.BULLET else MedicalEnums.WoundType.BLUNT_TRAUMA
	if info.type == MedicalEnums.DamageType.EXPLOSION:
		w.type = MedicalEnums.WoundType.BLAST_TRAUMA

	w.severity = severity
	w.bleed_rate = _classify_soft_tissue_bleed(severity)
	w.pain_contribution = severity * 0.5  # P4 存根
	return w

## P2 软组织出血分类：仅产生 毛细/静脉 两级。
## 动脉出血【不再】由"部位 + 能量"直接决定——旧逻辑对大腿/躯干命中
## 100% 判定动脉出血是错误的。现在 ARTERIAL 只能由 _resolve_anatomy()
## 判定伤道确实伤及大血管（AnatomyStructure MAJOR_VESSEL）后升级产生；
## 动能只影响伤道长度/空腔大小/损伤概率，不直接决定出血类型。
func _classify_soft_tissue_bleed(severity: float) -> MedicalEnums.BleedRate:
	if severity >= _config.venous_severity_threshold:
		return MedicalEnums.BleedRate.VENOUS
	elif severity >= _config.capillary_severity_threshold:
		return MedicalEnums.BleedRate.CAPILLARY
	return MedicalEnums.BleedRate.NONE

# 私有 — 生理 Tick ──────────────────────────────────────────

## 生理 tick：每 tick_interval 秒调用一次。
## P1 外部出血 + P2 内部出血（器官/体腔内大血管，绷带无效）；
## P3 加入呼吸系统；P4 加入疼痛/意识。
func _run_physiology_tick(dt: float) -> void:
	var external: float = vitals.total_bleed_rate()
	var internal: float = vitals.total_internal_bleed_rate()
	var total: float = external + internal
	if total > 0.0:
		vitals.blood_volume_ml = maxf(0.0, vitals.blood_volume_ml - total * dt)
		blood_changed.emit(vitals.get_blood_pct())

	# 疼痛等级：每 tick 由伤口 pain_contribution 汇总
	vitals.recompute_pain()
	pain_changed.emit(vitals.pain_level)

	# 使用缓存的最后受击方向：失血死亡也能选择方向正确的死亡动画
	# 失血/生理状态导致的死亡没有新的瞬时碰撞，不重复使用旧子弹的动能。
	_evaluate_state(_last_hit_direction, false)

# 私有 — 状态评估与死亡桥 ──────────────────────────────────

func _evaluate_state(last_hit_direction: Vector3, include_impact_data: bool = true) -> void:
	if _is_dead:
		return

	var new_state := _compute_state()
	if new_state != current_state:
		current_state = new_state
		state_changed.emit(current_state)
		GlobalLogger.debug("HealthSystem", "State → " + MedicalEnums.HealthState.keys()[current_state])

	match current_state:
		MedicalEnums.HealthState.DEAD:
			_trigger_death(last_hit_direction, include_impact_data)
		MedicalEnums.HealthState.UNCONSCIOUS:
			if _player.controllable or _player.is_bot:
				went_unconscious.emit()
				var impact_energy := _last_hit_energy_j if include_impact_data else 0.0
				var impact_mass := _last_hit_mass_kg if include_impact_data else 0.0
				var impact_type := _last_hit_damage_type if include_impact_data else MedicalEnums.DamageType.FALL
				_player.go_unconscious(
					_last_hit_direction, impact_energy, impact_mass, impact_type
				)
		# 注意：从 UNCONSCIOUS 恢复意识需要显式治疗（P3 肾上腺素/血袋），
		# 不会因血量稳定而自动恢复——拟真设计中失血是单向的。

func _compute_state() -> MedicalEnums.HealthState:
	# P2：关键器官（心/脑）被摧毁 → 直接死亡
	if _lethal_organ_destroyed:
		return MedicalEnums.HealthState.DEAD

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

	# 失血性休克/失去意识/死亡
	var blood_pct: float = vitals.get_blood_pct()
	if blood_pct <= _config.fatal_blood_threshold_pct:
		return MedicalEnums.HealthState.DEAD
	# UNCONSCIOUS 是粘性状态：一旦昏迷，不会因血量稳定而自动恢复，
	# 只有显式治疗（P3 肾上腺素）才能唤醒。
	if current_state == MedicalEnums.HealthState.UNCONSCIOUS:
		return MedicalEnums.HealthState.UNCONSCIOUS
	if blood_pct <= _config.unconscious_blood_threshold_pct:
		return MedicalEnums.HealthState.UNCONSCIOUS
	if blood_pct <= _config.critical_blood_threshold_pct:
		return MedicalEnums.HealthState.CRITICAL

	# 有伤 = INJURED
	for part_id: int in vitals.regions:
		var region := vitals.regions[part_id] as BodyRegion
		if region.wounds.size() > 0:
			return MedicalEnums.HealthState.INJURED

	return MedicalEnums.HealthState.HEALTHY

func _trigger_death(impact_direction: Vector3, include_impact_data: bool = true) -> void:
	if _is_dead:
		return
	_is_dead = true

	var death_type := _resolve_death_type(impact_direction)
	GlobalLogger.info("HealthSystem", "Medical death (type: %s, dir: %s)" % [
		PlayerRagdollSystem.DeathType.keys()[death_type],
		impact_direction
	])
	medically_died.emit(death_type, impact_direction)
	var impact_energy := _last_hit_energy_j if include_impact_data else 0.0
	var impact_mass := _last_hit_mass_kg if include_impact_data else 0.0
	var impact_type := _last_hit_damage_type if include_impact_data else MedicalEnums.DamageType.FALL
	_player.die(death_type, impact_direction, impact_energy, impact_mass, impact_type)

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
		# 蹲姿爆头优先判定（姿态值 > 0.5 视为蹲姿）
		var is_crouching := _player.stance_controller and _player.stance_controller.get_stance_value() > 0.5
		if is_crouching:
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


# 私有 — 死亡/复活生命周期 ─────────────────────────────────

## 死亡：销毁全部 hitbox。布娃娃启动后 PhysicalBone3D（layer 2）接管命中检测，
## HitResolver 按骨骼名映射部位；同时避免两套碰撞体在同一层重叠。
func _on_player_died() -> void:
	_destroy_hitboxes()

## 复活：重建 hitbox，并将生理状态重置为初始值（P3 治疗系统实装后
## 复活将改为保留伤情的"抢救"流程，此处的完全重置仅供调试复活使用）。
func _on_player_revived() -> void:
	vitals.initialize(_config)
	_last_hit_direction = Vector3.ZERO
	_last_hit_energy_j = 0.0
	_last_hit_mass_kg = 0.0
	_last_hit_damage_type = MedicalEnums.DamageType.BULLET
	_lethal_organ_destroyed = false
	_is_dead = false
	_tick_timer = 0.0
	current_state = MedicalEnums.HealthState.HEALTHY
	state_changed.emit(current_state)
	blood_changed.emit(vitals.get_blood_pct())
	bleeding_changed.emit(0.0)
	pain_changed.emit(0.0)
	_create_hitboxes()

# 私有 — 模型加载与 Hitbox 创建 ────────────────────────────

## 接收 model_loaded 信号后，触发 hitbox 创建流程。
func _on_model_loaded(_model: Node3D) -> void:
	GlobalLogger.info("HealthSystem", "model_loaded signal received, creating hitboxes...")
	_create_hitboxes()


## 为 Mixamo 骨架的关键骨骼创建 BodyHitbox（Area3D + CollisionShape3D）。
## 骨骼→部位映射：Head→HEAD，Spine1/Spine2→TORSO，LeftArm→LEFT_UPPER_ARM，以此类推。
## 形状参数来自 HitboxConfig；每个 hitbox 挂在对应骨骼的 BoneAttachment3D 下。
func _create_hitboxes() -> void:
	# 模型热重载/复活时先清理旧 hitbox，防止 _hitboxes 残留失效引用或重复创建
	_destroy_hitboxes()

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
		"mixamorig_Head":        MedicalEnums.BodyPartId.HEAD,
		"mixamorig_Spine2":      MedicalEnums.BodyPartId.TORSO,
		"mixamorig_Spine1":      MedicalEnums.BodyPartId.TORSO,
		"mixamorig_LeftArm":     MedicalEnums.BodyPartId.LEFT_UPPER_ARM,
		"mixamorig_LeftForeArm": MedicalEnums.BodyPartId.LEFT_FOREARM,
		"mixamorig_RightArm":    MedicalEnums.BodyPartId.RIGHT_UPPER_ARM,
		"mixamorig_RightForeArm":MedicalEnums.BodyPartId.RIGHT_FOREARM,
		"mixamorig_LeftUpLeg":   MedicalEnums.BodyPartId.LEFT_THIGH,
		"mixamorig_LeftLeg":     MedicalEnums.BodyPartId.LEFT_CALF,
		"mixamorig_RightUpLeg":  MedicalEnums.BodyPartId.RIGHT_THIGH,
		"mixamorig_RightLeg":    MedicalEnums.BodyPartId.RIGHT_CALF,
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

		# P2：为锚定在该骨骼上的内部结构创建可视化网格（H 键切换显示，
		# 用于目视校准 AnatomyConfig 的几何位置）
		for s in _anatomy.get_structures_for_bone(bone_name):
			var structure := s as AnatomyStructure
			hitbox.add_anatomy_debug_mesh(
				structure.start_point, structure.end_point, structure.radius,
				_anatomy_debug_color(structure.type)
			)

		_hitboxes.append(hitbox)

	GlobalLogger.info("HealthSystem", "Created %d hitboxes" % _hitboxes.size())


## 内部结构可视化配色：器官红、骨骼白、血管深红
func _anatomy_debug_color(type: MedicalEnums.StructureType) -> Color:
	match type:
		MedicalEnums.StructureType.ORGAN:
			return Color(1.0, 0.25, 0.25, 0.55)
		MedicalEnums.StructureType.BONE:
			return Color(0.95, 0.95, 0.85, 0.55)
		MedicalEnums.StructureType.MAJOR_VESSEL:
			return Color(0.75, 0.0, 0.12, 0.7)
	return Color(1, 1, 1, 0.5)


## 销毁全部 hitbox 及其 BoneAttachment3D 父节点，并清空引用列表
func _destroy_hitboxes() -> void:
	for hitbox in _hitboxes:
		if not is_instance_valid(hitbox):
			continue
		var attach := hitbox.get_parent()
		if attach is BoneAttachment3D:
			attach.queue_free()
		else:
			hitbox.queue_free()
	_hitboxes.clear()


# ── 调试接口（仅供 Debug 构建控制台指令使用）────────────────

## 直接注入一个伤口，用于测试出血/死亡流程。
## bleed_override < 0 时按软组织规则自动分类（P2：调试注入无伤道信息，
## 不会自动产生动脉出血；需要动脉测试请显式指定 ARTERIAL）。
func debug_add_wound(part: MedicalEnums.BodyPartId, severity: float, bleed_override: int = -1) -> void:
	if _is_dead or not vitals:
		return
	var region := vitals.get_region(part)
	if not region:
		return
	var w := Wound.new()
	w.wound_id = vitals.allocate_wound_id()
	w.body_part = part
	w.type = MedicalEnums.WoundType.PENETRATING
	w.severity = severity
	w.bleed_rate = (bleed_override as MedicalEnums.BleedRate) if bleed_override >= 0 else _classify_soft_tissue_bleed(severity)
	w.pain_contribution = severity * 0.5
	region.add_wound(w)
	wound_added.emit(w)
	bleeding_changed.emit(vitals.total_bleed_rate())
	GlobalLogger.debug("HealthSystem", "[DEBUG] Wound injected: %s severity %.2f bleed %s" % [
		MedicalEnums.BodyPartId.keys()[part], severity, MedicalEnums.BleedRate.keys()[w.bleed_rate]
	])
	_evaluate_state(Vector3.ZERO)


## 直接设置血量百分比（0.0–1.0）。降到致命阈值以下会正常触发死亡流程。
func debug_set_blood_pct(pct: float) -> void:
	if _is_dead or not vitals:
		return
	vitals.blood_volume_ml = clampf(pct, 0.0, 1.0) * vitals.max_blood_volume_ml
	blood_changed.emit(vitals.get_blood_pct())
	GlobalLogger.debug("HealthSystem", "[DEBUG] Blood set to %.0f%%" % (pct * 100.0))
	_evaluate_state(Vector3.ZERO)


## 清除全部伤口及 P2 结构伤情（器官损伤/骨折/呼吸惩罚）
## （不恢复已流失的血量；如需满血用 debug_set_blood_pct(1.0)）
func debug_clear_wounds() -> void:
	if not vitals:
		return
	for part_id: int in vitals.regions:
		var region := vitals.regions[part_id] as BodyRegion
		region.wounds.clear()
		region.organ_damage.clear()
		region.fractured_bones.clear()
	vitals.breathing_effectiveness = 1.0
	_lethal_organ_destroyed = false
	bleeding_changed.emit(0.0)
	GlobalLogger.debug("HealthSystem", "[DEBUG] All wounds and structural damage cleared")
	_evaluate_state(Vector3.ZERO)
