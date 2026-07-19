class_name CombatNotificationBridge
extends Node

# ============================================================
# 战斗通知桥接器
# 监听 HealthSystem 各信号，通过 TopRightNotificationManager 显示伤情提示。
# 通知文字、颜色、时长由 CombatNotificationLibrary 资源配置。
# 由 BasePlayer._initialize_subsystems() 创建，调用 initialize(player) 激活。
# ============================================================

const DEFAULT_LIBRARY_PATH := "res://res/config/ui/notifications/combat_notifications.tres"

const PART_NAMES: Dictionary = {
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

var _player: BasePlayer = null
var _notif_manager: Node = null
var _lib: Resource = null  # CombatNotificationLibrary


func initialize(player: BasePlayer) -> void:
	_player = player
	_lib = load(DEFAULT_LIBRARY_PATH)
	if not _lib:
		GlobalLogger.warn("CombatNotif", "CombatNotificationLibrary 未找到，通知样式使用代码内置值")

	player.health_system.wound_added.connect(_on_wound_added)
	player.health_system.bone_fractured.connect(_on_bone_fractured)
	player.health_system.state_changed.connect(_on_state_changed)
	player.died.connect(_on_player_died)
	player.revived.connect(_on_player_revived)
	_find_notif_manager_deferred()


func _find_notif_manager_deferred() -> void:
	await get_tree().process_frame
	_notif_manager = _find_recursive(get_tree().root, "NotificationManager")
	if not _notif_manager:
		GlobalLogger.warn("CombatNotif", "TopRightNotificationManager 未找到，通知功能不可用")


func _find_recursive(node: Node, target: String) -> Node:
	if node.name == target:
		return node
	for child in node.get_children():
		var result := _find_recursive(child, target)
		if result:
			return result
	return null


# ── 信号回调 ────────────────────────────────────────────────

func _on_wound_added(wound: Wound) -> void:
	if not _notif_manager or not _lib:
		return
	var part_name: String = PART_NAMES.get(wound.body_part, "未知部位")
	match wound.bleed_rate:
		MedicalEnums.BleedRate.ARTERIAL:
			_show_dynamic("wound_arterial_%d" % wound.wound_id,
				_lib.arterial_text.format({"part": part_name}),
				_lib.arterial_color, _lib.arterial_duration)
		MedicalEnums.BleedRate.VENOUS:
			_show_dynamic("wound_venous_%d" % wound.wound_id,
				_lib.venous_text.format({"part": part_name}),
				_lib.venous_color, _lib.venous_duration)
		MedicalEnums.BleedRate.CAPILLARY:
			_show_dynamic("wound_capillary_%d" % wound.wound_id,
				_lib.capillary_text.format({"part": part_name}),
				_lib.capillary_color, _lib.capillary_duration)


func _on_bone_fractured(part: MedicalEnums.BodyPartId, _structure_id: StringName) -> void:
	if not _notif_manager or not _lib:
		return
	var part_name: String = PART_NAMES.get(part, "未知部位")
	_show_dynamic("fracture_%d" % part,
		_lib.fracture_text.format({"part": part_name}),
		_lib.fracture_color, _lib.fracture_duration)


func _on_state_changed(new_state: MedicalEnums.HealthState) -> void:
	if not _notif_manager or not _lib:
		return
	match new_state:
		MedicalEnums.HealthState.CRITICAL:
			_show_entry(_lib.critical)
		MedicalEnums.HealthState.UNCONSCIOUS:
			_show_entry(_lib.unconscious)
		MedicalEnums.HealthState.INJURED:
			if _lib.critical:
				_notif_manager.dismiss_notification(_lib.critical.notification_id)
		MedicalEnums.HealthState.HEALTHY:
			if _lib.critical:
				_notif_manager.dismiss_notification(_lib.critical.notification_id)
			if _lib.unconscious:
				_notif_manager.dismiss_notification(_lib.unconscious.notification_id)


func _on_player_died() -> void:
	if not _notif_manager or not _lib:
		return
	_show_entry(_lib.dead)


func _on_player_revived() -> void:
	if not _notif_manager or not _lib:
		return
	for entry in [_lib.dead, _lib.critical, _lib.unconscious]:
		if entry:
			_notif_manager.dismiss_notification(entry.notification_id)


# ── 工具方法 ────────────────────────────────────────────────

## 显示库中预定义的固定条目
func _show_entry(entry: TopRightNotificationEntry) -> void:
	if not entry:
		return
	# 克隆一份，避免修改原始资源的 visible 状态
	var e := entry.duplicate() as TopRightNotificationEntry
	e.visible = true
	_notif_manager.show_notification(e)

## 显示动态生成的条目（文字需拼接部位名等运行时信息）
func _show_dynamic(notif_id: StringName, text: String, accent: Color, duration: float) -> void:
	var entry := TopRightNotificationEntry.new()
	entry.notification_id = notif_id
	entry.text = text
	entry.accent_color = accent
	entry.duration = duration
	_notif_manager.show_notification(entry)
