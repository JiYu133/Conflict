class_name HandIKController
extends Node

# 左手 IK 控制器（TwoBoneIK3D 版本）
# target_node 指向 Skeleton3D 下的中间 Marker3D（LeftHandTarget），
# 每帧将其变换同步到武器的 LeftHandGrip，避免跨场景树路径失效。

var _config: HandIKConfig

var _ik_node: TwoBoneIK3D
var _hand_target: Marker3D      # Skeleton3D 下的中间目标点，由代码每帧更新
var _left_hand_grip: Node3D     # 武器上的 LeftHandGrip Marker3D
var _right_ik_node: TwoBoneIK3D
var _right_hand_target: Marker3D
var _right_elbow_pole: Marker3D
var _right_hand_grip: Node3D
var _current_weapon: BaseWeapon
var _enabled: bool = false
var _right_enabled: bool = false
var _ik_weight: float = 1.0
var _right_current_weight: float = 0.0

var _is_running: bool = false
var _is_sprinting: bool = false
var _is_ads: bool = false

var _current_weight: float = 0.0
var _target_weight: float = 0.0


func initialize(_model_manager: PlayerModelManager, _lookup: ModelLookupConfig) -> void:
	pass


func setup(skeleton: Skeleton3D, config: HandIKConfig = null) -> void:
	_config = config if config else HandIKConfig.new()

	var node_name := _config.ik_node_name
	_ik_node = skeleton.get_node_or_null(node_name) as TwoBoneIK3D
	if not _ik_node:
		GlobalLogger.warn("HandIK", "Skeleton3D 下未找到 TwoBoneIK3D 节点 '%s'，请在编辑器里添加。" % node_name)
		return

	# 查找或创建中间目标 Marker3D（固定挂在 Skeleton3D 下，路径稳定）
	_hand_target = skeleton.get_node_or_null("LeftHandTarget") as Marker3D
	if not _hand_target:
		_hand_target = Marker3D.new()
		_hand_target.name = "LeftHandTarget"
		skeleton.add_child(_hand_target)
		GlobalLogger.info("HandIK", "已自动创建 LeftHandTarget Marker3D")

	# index 0 是第一条（唯一一条）IK 设置
	_ik_node.set_target_node(0, _ik_node.get_path_to(_hand_target))
	_ik_node.influence = 0.0
	GlobalLogger.info("HandIK", "TwoBoneIK3D '%s' 已绑定，目标点: LeftHandTarget" % node_name)
	_setup_right_hand_ik(skeleton)


func _setup_right_hand_ik(skeleton: Skeleton3D) -> void:
	var root_idx := skeleton.find_bone("mixamorig_RightArm")
	var middle_idx := skeleton.find_bone("mixamorig_RightForeArm")
	var end_idx := skeleton.find_bone("mixamorig_RightHand")
	if root_idx == -1 or middle_idx == -1 or end_idx == -1:
		GlobalLogger.warn("HandIK", "右手骨骼未找到，右手 IK 不启用")
		return

	_right_ik_node = TwoBoneIK3D.new()
	_right_ik_node.name = "RightHandIK"
	skeleton.add_child(_right_ik_node)
	_right_ik_node.set_setting_count(1)
	_right_ik_node.set_root_bone(0, root_idx)
	_right_ik_node.set_middle_bone(0, middle_idx)
	_right_ik_node.set_end_bone(0, end_idx)
	_right_ik_node.influence = 0.0

	_right_hand_target = Marker3D.new()
	_right_hand_target.name = "RightHandTarget"
	skeleton.add_child(_right_hand_target)

	_right_elbow_pole = Marker3D.new()
	_right_elbow_pole.name = "RightElbowPole"
	skeleton.add_child(_right_elbow_pole)
	_right_elbow_pole.position = Vector3(-0.45, 1.45, -0.1)

	_right_ik_node.set_target_node(0, _right_ik_node.get_path_to(_right_hand_target))
	_right_ik_node.set_pole_node(0, _right_ik_node.get_path_to(_right_elbow_pole))
	GlobalLogger.info("HandIK", "右手 TwoBoneIK3D 已创建")


func set_weapon(weapon: BaseWeapon, ik_weight: float = -1.0) -> void:
	_disconnect_weapon_attachments()
	_left_hand_grip = null
	_enabled = false

	if not weapon or not _ik_node:
		GlobalLogger.warn("HandIK", "set_weapon: weapon=%s, ik_node=%s — IK 不启用" % [
			str(weapon), str(_ik_node)])
		return

	_current_weapon = weapon
	_ik_weight = ik_weight if ik_weight >= 0.0 else (_config.default_ik_weight if _config else 1.0)
	_update_target_weight()
	_current_weight = _target_weight

	if weapon.attachment_manager:
		weapon.attachment_manager.attachments_changed.connect(_on_attachments_changed)

	_left_hand_grip = weapon.find_grip_node("LeftHandGrip")
	if not _left_hand_grip:
		GlobalLogger.warn("HandIK", "武器 '%s' 没有 LeftHandGrip 节点，左手 IK 不启用" % weapon.name)
	else:
		_enabled = true
		GlobalLogger.info("HandIK", "左手 IK 启用: grip=%s  weight=%.2f" % [
			_left_hand_grip.get_path(), _ik_weight])

	_right_hand_grip = weapon.find_grip_node("RightHandGrip")
	_right_enabled = _right_ik_node != null and _right_hand_grip != null
	if _right_enabled:
		_right_current_weight = 1.0


func _disconnect_weapon_attachments() -> void:
	if is_instance_valid(_current_weapon) and _current_weapon.attachment_manager:
		var am := _current_weapon.attachment_manager
		if am.attachments_changed.is_connected(_on_attachments_changed):
			am.attachments_changed.disconnect(_on_attachments_changed)
	_current_weapon = null


func _on_attachments_changed() -> void:
	if not _current_weapon:
		return
	_left_hand_grip = _current_weapon.find_grip_node("LeftHandGrip")
	_enabled = _left_hand_grip != null
	_right_hand_grip = _current_weapon.find_grip_node("RightHandGrip")
	_right_enabled = _right_ik_node != null and _right_hand_grip != null


func set_movement_state(running: bool, sprinting: bool) -> void:
	_is_running = running
	_is_sprinting = sprinting
	_update_target_weight()


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
	if not _ik_node and not _right_ik_node:
		return

	if _ik_node:
		if _enabled and is_instance_valid(_left_hand_grip) and _hand_target:
			_hand_target.global_transform = _left_hand_grip.global_transform
		var blend_time := maxf(_config.weight_blend_time if _config else 0.12, 0.001)
		var effective_target := _target_weight if _enabled else 0.0
		_current_weight = move_toward(_current_weight, effective_target, delta / blend_time)
		_ik_node.influence = _current_weight

	if _right_ik_node:
		if _right_enabled and is_instance_valid(_right_hand_grip) and _right_hand_target:
			_right_hand_target.global_transform = _right_hand_grip.global_transform
		var right_target := 1.0 if _right_enabled else 0.0
		_right_current_weight = move_toward(
			_right_current_weight, right_target, delta / 0.08
		)
		_right_ik_node.influence = _right_current_weight
