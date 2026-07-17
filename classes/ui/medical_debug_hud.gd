extends RichTextLabel

# ============================================================
# 医疗数据调试 HUD
# 功能：实时显示玩家血量、伤口、状态等医疗数据（左下角）
# 用法：挂载到 UI 层，通过 get_tree() 查找玩家的 HealthSystem
# 按键：H 键切换显示/隐藏
# ============================================================

var _health_system: HealthSystem = null
var _update_timer: float = 0.0
const UPDATE_INTERVAL: float = 0.1  # 100ms 更新一次
var _is_visible: bool = true

func _ready() -> void:
	# 设置样式
	bbcode_enabled = true
	fit_content = true
	scroll_active = false

	# 添加半透明背景
	add_theme_color_override("default_color", Color(1, 1, 1, 1))
	add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.8))
	add_theme_constant_override("shadow_offset_x", 2)
	add_theme_constant_override("shadow_offset_y", 2)
	add_theme_font_size_override("normal_font_size", 12)

	# 查找玩家的 HealthSystem
	await get_tree().process_frame
	_find_health_system()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_H:
			_is_visible = not _is_visible
			visible = _is_visible
			# 同时切换碰撞体可视化
			if _health_system:
				_health_system.set_hitboxes_visible(_is_visible)
				GlobalLogger.info("MedicalHUD", "Toggled hitbox visibility: " + str(_is_visible))
			else:
				GlobalLogger.warn("MedicalHUD", "No health_system found to toggle hitboxes")
			GlobalLogger.debug("MedicalHUD", "Toggle visibility: " + str(_is_visible))

func _find_health_system() -> void:
	# 遍历场景树查找 BasePlayer
	for node in get_tree().get_nodes_in_group("player"):
		if node is BasePlayer:
			_health_system = node.health_system
			GlobalLogger.info("MedicalHUD", "Found HealthSystem")
			return

	# 兜底：直接搜索 HealthSystem 节点
	var health_systems := get_tree().get_nodes_in_group("health_system")
	if health_systems.size() > 0:
		_health_system = health_systems[0] as HealthSystem
		GlobalLogger.info("MedicalHUD", "Found HealthSystem via group")
		return

	# 再兜底：递归查找
	_health_system = _find_node_recursive(get_tree().root, "HealthSystem")
	if _health_system:
		GlobalLogger.info("MedicalHUD", "Found HealthSystem via recursive search")

func _find_node_recursive(node: Node, target_name: String) -> Node:
	if node.name == target_name and node is HealthSystem:
		return node
	for child in node.get_children():
		var result := _find_node_recursive(child, target_name)
		if result:
			return result
	return null

func _process(delta: float) -> void:
	_update_timer += delta
	if _update_timer < UPDATE_INTERVAL:
		return
	_update_timer = 0.0

	if not _health_system:
		text = "[Medical HUD] No HealthSystem found"
		return

	_update_display()

func _update_display() -> void:
	var vitals := _health_system.vitals
	if not vitals:
		text = "[Medical HUD] Vitals not initialized"
		return

	var lines: PackedStringArray = []

	# === 标题 ===
	lines.append("[b]MEDICAL STATUS[/b]")
	lines.append("─────────────────────────")

	# === 状态 + 警告 ===
	var state_name : String = MedicalEnums.HealthState.keys()[_health_system.current_state]
	var state_color := _get_state_color(_health_system.current_state)
	lines.append("[color=%s][b]状态: %s[/b][/color]" % [state_color, state_name])

	# 血量
	var blood_pct := vitals.get_blood_pct()
	var blood_color := _get_blood_color(blood_pct)
	lines.append("[color=%s]血量: %d/%d ml (%.0f%%)[/color]" % [
		blood_color,
		int(vitals.blood_volume_ml),
		int(vitals.max_blood_volume_ml),
		blood_pct * 100.0
	])

	# 致命阈值警告
	var config := _health_system._config
	if blood_pct <= config.fatal_blood_threshold_pct:
		lines.append("[color=#ff0000][b]⚠ 失血性死亡！[/b][/color]")
	elif blood_pct <= config.critical_blood_threshold_pct:
		lines.append("[color=#ff8800]⚠ 危险：失血性休克[/color]")

	# 出血速率（P2：外部 + 内部分开显示）
	var bleed_rate := vitals.total_bleed_rate()
	var internal_rate := vitals.total_internal_bleed_rate()
	var total_rate := bleed_rate + internal_rate
	if bleed_rate > 0.0:
		var bleed_color := "#ff4444" if bleed_rate >= 5.0 else "#ffaa44"
		lines.append("[color=%s]外部失血: %.1f ml/s[/color]" % [bleed_color, bleed_rate])
	if internal_rate > 0.0:
		var int_color := "#ff44aa" if internal_rate >= 5.0 else "#ffaa88"
		lines.append("[color=%s]内出血: %.1f ml/s（绷带无效）[/color]" % [int_color, internal_rate])
	if total_rate > 0.0:
		var time_to_death := (vitals.blood_volume_ml - config.fatal_blood_threshold_pct * vitals.max_blood_volume_ml) / total_rate
		if time_to_death > 0.0:
			lines.append("[color=#888888]预计 %.0fs 后失血死亡[/color]" % time_to_death)

	# P2：呼吸效率（肺部受损时显示）
	if vitals.breathing_effectiveness < 1.0:
		lines.append("[color=#88ccff]呼吸效率: %.0f%%[/color]" % (vitals.breathing_effectiveness * 100.0))

	# === 各部位详情 ===
	lines.append("")
	lines.append("[b]部位伤情:[/b]")

	var part_display := {
		MedicalEnums.BodyPartId.HEAD:           "头部",
		MedicalEnums.BodyPartId.TORSO:          "躯干",
		MedicalEnums.BodyPartId.LEFT_UPPER_ARM: "左上臂",
		MedicalEnums.BodyPartId.LEFT_FOREARM:   "左前臂",
		MedicalEnums.BodyPartId.RIGHT_UPPER_ARM:"右上臂",
		MedicalEnums.BodyPartId.RIGHT_FOREARM:  "右前臂",
		MedicalEnums.BodyPartId.LEFT_THIGH:     "左大腿",
		MedicalEnums.BodyPartId.LEFT_CALF:      "左小腿",
		MedicalEnums.BodyPartId.RIGHT_THIGH:    "右大腿",
		MedicalEnums.BodyPartId.RIGHT_CALF:     "右小腿",
	}

	for part_id in [
		MedicalEnums.BodyPartId.HEAD,
		MedicalEnums.BodyPartId.TORSO,
		MedicalEnums.BodyPartId.LEFT_UPPER_ARM,
		MedicalEnums.BodyPartId.LEFT_FOREARM,
		MedicalEnums.BodyPartId.RIGHT_UPPER_ARM,
		MedicalEnums.BodyPartId.RIGHT_FOREARM,
		MedicalEnums.BodyPartId.LEFT_THIGH,
		MedicalEnums.BodyPartId.LEFT_CALF,
		MedicalEnums.BodyPartId.RIGHT_THIGH,
		MedicalEnums.BodyPartId.RIGHT_CALF,
	]:
		var region := vitals.get_region(part_id)
		if not region:
			continue

		var part_name : String = part_display[part_id]
		var total_severity := region.get_total_severity()
		var wound_count := region.wounds.size()
		var part_health := _health_system.get_part_health(part_id)

		# 部位标题行
		var severity_color := _get_severity_color(total_severity)
		if wound_count > 0:
			lines.append("[color=%s]• %s: %.2f severity (%d伤口) [%.0f%%][/color]" % [
				severity_color,
				part_name,
				total_severity,
				wound_count,
				part_health * 100.0
			])

			# 致命伤警告（仅头部和躯干有致命阈值）
			var is_vital : bool = part_id in [MedicalEnums.BodyPartId.HEAD, MedicalEnums.BodyPartId.TORSO]
			if is_vital:
				var lethal_threshold := config.head_lethal_severity if part_id == MedicalEnums.BodyPartId.HEAD else config.torso_lethal_severity
				var cumulative_threshold := config.head_cumulative_lethal if part_id == MedicalEnums.BodyPartId.HEAD else config.torso_cumulative_lethal
				if region.has_lethal_wound(lethal_threshold):
					lines.append("  [color=#ff0000]⚠ 单发致命伤！[/color]")
				elif total_severity >= cumulative_threshold:
					lines.append("  [color=#ff0000]⚠ 累积致命伤！[/color]")
				elif total_severity >= cumulative_threshold * 0.7:
					lines.append("  [color=#ff8800]⚠ 接近累积致死阈值[/color]")

			# 列出各个伤口
			for wound in region.wounds:
				var w := wound as Wound
				var wound_type : String = MedicalEnums.WoundType.keys()[w.type]
				var bleed_name : String = MedicalEnums.BleedRate.keys()[w.bleed_rate]
				var wound_color := _get_severity_color(w.severity)
				var internal_suffix := ""
				if w.internal_bleed_rate != MedicalEnums.BleedRate.NONE:
					internal_suffix = " / 内%s" % MedicalEnums.BleedRate.keys()[w.internal_bleed_rate]
				lines.append("  [color=%s]#%d: %s (%.2f) - %s%s[/color]" % [
					wound_color,
					w.wound_id,
					wound_type,
					w.severity,
					bleed_name,
					internal_suffix
				])
		else:
			if region.organ_damage.is_empty() and region.fractured_bones.is_empty():
				lines.append("[color=#888888]• %s: 完好[/color]" % part_name)
			else:
				lines.append("[color=#ffaa44]• %s:[/color]" % part_name)

		# P2：器官伤情
		for organ_id: StringName in region.organ_damage:
			var dmg: float = region.organ_damage[organ_id]
			var organ_color := "#ff4444" if dmg >= 1.0 else "#ff8800"
			lines.append("  [color=%s]器官 %s: 损伤 %.2f[/color]" % [organ_color, organ_id, dmg])

		# P2：骨折
		for bone_id: StringName in region.fractured_bones:
			lines.append("  [color=#ffffff]骨折: %s[/color]" % bone_id)
	text = "\n".join(lines)

func _get_state_color(state: MedicalEnums.HealthState) -> String:
	match state:
		MedicalEnums.HealthState.HEALTHY:
			return "#00ff00"
		MedicalEnums.HealthState.INJURED:
			return "#ffff00"
		MedicalEnums.HealthState.CRITICAL:
			return "#ff8800"
		MedicalEnums.HealthState.UNCONSCIOUS:
			return "#ff0088"
		MedicalEnums.HealthState.DEAD:
			return "#ff0000"
	return "#ffffff"

func _get_blood_color(pct: float) -> String:
	if pct > 0.7:
		return "#00ff00"
	elif pct > 0.5:
		return "#ffff00"
	elif pct > 0.3:
		return "#ff8800"
	else:
		return "#ff0000"

func _get_severity_color(severity: float) -> String:
	if severity < 0.5:
		return "#ffff00"  # 轻伤
	elif severity < 1.0:
		return "#ff8800"  # 中度
	elif severity < 2.0:
		return "#ff4444"  # 重伤
	else:
		return "#ff0000"  # 极重
