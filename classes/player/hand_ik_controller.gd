class_name HandIKController
extends Node

# 左手 IK 控制器（TwoBoneIK3D 版本）
# target_node 指向 Skeleton3D 下的中间 Marker3D（LeftHandTarget），
# 每帧将其变换同步到武器的 LeftHandGrip，避免跨场景树路径失效。
#
# 只对左手做 IK：武器挂在右手骨骼的 WeaponMount 下（见 BasePlayer._on_model_loaded），
# 右手天然持枪，无需 IK。若对右手也做 IK 去抓武器上的 RightHandGrip，
# 会形成「右手→武器→握把→右手」的正反馈闭环，每帧累加握把偏移导致右臂漂移。

var _config: HandIKConfig

var _ik_node: TwoBoneIK3D
var _hand_target: Marker3D      # Skeleton3D 下的中间目标点，由代码每帧更新
var _target_modifier: HandTargetModifier
var _left_hand_grip: Node3D     # 武器上的 LeftHandGrip 掌心接触点
var _left_hand_wrist_target: Node3D # 武器上的 LeftHandWristTarget 腕部目标
var _using_wrist_target_fallback: bool = false
var _current_weapon: BaseWeapon
var _enabled: bool = false
var _ik_weight: float = 1.0

# 手腕朝向标定：握把 Marker 的朝向由美术随手摆放（AK 本体握把带约 40° 倾斜，
# 导轨护木握把是 90° 翻转），直接把它套到手骨上会拧歪手腕。
# 这里记录「动画手腕朝向 相对于 握把朝向」的差值，每帧还原，手腕即保持自然姿态。
var _skeleton: Skeleton3D = null
var _hand_bone_idx: int = -1
var _middle_finger_bone_idx: int = -1
var _wrist_to_palm_local: Vector3 = Vector3.ZERO

var _is_running: bool = false
var _is_sprinting: bool = false
var _is_ads: bool = false
var _is_prone: bool = false

var _current_weight: float = 0.0
var _target_weight: float = 0.0


func initialize(_model_manager: PlayerModelManager, _lookup: ModelLookupConfig) -> void:
	pass


func setup(skeleton: Skeleton3D, config: HandIKConfig = null) -> void:
	_config = config if config else HandIKConfig.new()
	_skeleton = skeleton
	if not is_instance_valid(_skeleton):
		GlobalLogger.warn("HandIK", "未找到 Skeleton3D，手部 IK 已禁用")
		return
	if is_instance_valid(_target_modifier):
		_target_modifier.queue_free()
	_target_modifier = null
	_hand_bone_idx = skeleton.find_bone(_config.tip_bone_name)
	if _hand_bone_idx == -1:
		GlobalLogger.warn("HandIK", "未找到手腕骨骼 '%s'，手腕朝向标定不可用" % _config.tip_bone_name)
	_middle_finger_bone_idx = skeleton.find_bone("mixamorig_LeftHandMiddle1")
	if _hand_bone_idx >= 0 and _middle_finger_bone_idx >= 0:
		var hand_rest := skeleton.get_bone_global_rest(_hand_bone_idx)
		var middle_rest := skeleton.get_bone_global_rest(_middle_finger_bone_idx)
		_wrist_to_palm_local = hand_rest.basis.inverse() * (middle_rest.origin - hand_rest.origin)

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

	# 目标同步必须发生在脊柱修正之后、TwoBoneIK3D 求解之前。
	# SkeletonModifier3D 的兄弟顺序就是执行顺序，因此把同步器插到 IK 前面。
	_target_modifier = HandTargetModifier.new()
	_target_modifier.name = "LeftHandTargetSync"
	skeleton.add_child(_target_modifier)
	_target_modifier.setup(self)
	skeleton.move_child(_target_modifier, _ik_node.get_index())
	GlobalLogger.info("HandIK", "TwoBoneIK3D '%s' 已绑定，目标点: LeftHandTarget" % node_name)


func set_weapon(weapon: BaseWeapon, ik_weight: float = -1.0) -> void:
	_disconnect_weapon_attachments()
	_left_hand_grip = null
	_left_hand_wrist_target = null
	_enabled = false
	_using_wrist_target_fallback = false

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
	_left_hand_wrist_target = weapon.find_grip_node("LeftHandWristTarget")
	_using_wrist_target_fallback = not is_instance_valid(_left_hand_wrist_target)
	if not _left_hand_grip and _using_wrist_target_fallback:
		GlobalLogger.warn("HandIK", "武器 '%s' 缺少 LeftHandGrip 与 LeftHandWristTarget，左手 IK 不启用" % weapon.name)
	else:
		_enabled = true
		if _using_wrist_target_fallback:
			GlobalLogger.warn("HandIK", "武器 '%s' 缺少 LeftHandWristTarget，使用预设腕部目标回退" % weapon.name)
		GlobalLogger.info("HandIK", "左手 IK 启用: grip=%s  weight=%.2f" % [
			str(_left_hand_wrist_target.get_path()) if is_instance_valid(_left_hand_wrist_target) else "fallback",
			_ik_weight])


func _disconnect_weapon_attachments() -> void:
	if is_instance_valid(_current_weapon) and _current_weapon.attachment_manager:
		var am := _current_weapon.attachment_manager
		if am.attachments_changed.is_connected(_on_attachments_changed):
			am.attachments_changed.disconnect(_on_attachments_changed)
	_current_weapon = null


## 配件变更（换护木/握把等）后握把节点可能被替换，重新查找并更新 IK 目标
func _on_attachments_changed() -> void:
	if not _current_weapon:
		return
	_left_hand_grip = _current_weapon.find_grip_node("LeftHandGrip")
	_left_hand_wrist_target = _current_weapon.find_grip_node("LeftHandWristTarget")
	_using_wrist_target_fallback = not is_instance_valid(_left_hand_wrist_target)
	_enabled = is_instance_valid(_left_hand_grip) or is_instance_valid(_left_hand_wrist_target)
	# 换护木/握把后握把 Marker 朝向可能完全不同（导轨护木是 90° 翻转），需重新标定
	if _enabled:
		if _using_wrist_target_fallback:
			GlobalLogger.warn("HandIK", "配件变更后缺少 LeftHandWristTarget，使用预设腕部目标回退")
		GlobalLogger.debug("HandIK", "配件变更，左手握把更新: %s" % [
			str(_left_hand_grip.get_path()) if is_instance_valid(_left_hand_grip) else "wrist-target-only"])
	else:
		GlobalLogger.warn("HandIK", "配件变更后未找到 LeftHandGrip，左手 IK 暂停")


func set_movement_state(running: bool, sprinting: bool) -> void:
	_is_running = running
	_is_sprinting = sprinting
	_update_target_weight()


func set_ads_state(ads: bool) -> void:
	_is_ads = ads
	_update_target_weight()


func set_prone_state(prone: bool) -> void:
	_is_prone = prone
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


func process_ik(delta: float, active: bool = true) -> void:
	if not _ik_node:
		return

	var can_solve: bool = active and _enabled \
		and (is_instance_valid(_left_hand_wrist_target) or is_instance_valid(_left_hand_grip)) \
		and is_instance_valid(_hand_target)
	if _target_modifier:
		_target_modifier.sync_enabled = can_solve

	# 非 SkeletonModifier 更新路径下保留一次同步，确保编辑器和禁用修饰器的
	# 特殊场景也能工作；正式求解前还会由 HandTargetModifier 再同步一次。
	if can_solve:
		_update_hand_target()

	var blend_time := maxf(_config.weight_blend_time if _config else 0.12, 0.001)
	var effective_target := _target_weight if can_solve else 0.0
	if not active:
		_current_weight = 0.0
		_ik_node.influence = 0.0
		return
	_current_weight = move_toward(_current_weight, effective_target, delta / blend_time)
	_ik_node.influence = _current_weight


## 位置永远取握把；朝向按配置决定是否用标定后的自然手腕姿态。
func _update_hand_target() -> void:
	_refresh_weapon_mount()
	var target_xf := _get_current_wrist_target_transform()
	_hand_target.global_transform = target_xf


func _get_current_wrist_target_transform() -> Transform3D:
	if is_instance_valid(_left_hand_wrist_target):
		return _left_hand_wrist_target.global_transform
	if not is_instance_valid(_left_hand_grip):
		return Transform3D.IDENTITY

	var grip_xf := _left_hand_grip.global_transform
	var grip_basis := grip_xf.basis.orthonormalized()
	var origin := grip_xf.origin + grip_basis * _config.grip_position_offset
	origin -= _get_current_wrist_to_palm_world() * _config.fallback_palm_contact_ratio
	origin += grip_basis * _config.fallback_wrist_position_offset
	return Transform3D(grip_basis * Basis.from_euler(_wrist_offset_rad()), origin)


func _get_current_wrist_to_palm_local() -> Vector3:
	if not is_instance_valid(_skeleton) or _hand_bone_idx < 0 or _middle_finger_bone_idx < 0:
		return _wrist_to_palm_local

	var hand_pose := _skeleton.get_bone_global_pose(_hand_bone_idx)
	var middle_pose := _skeleton.get_bone_global_pose(_middle_finger_bone_idx)
	var palm_offset := middle_pose.origin - hand_pose.origin
	if palm_offset.length_squared() < 0.000001:
		return _wrist_to_palm_local
	return hand_pose.basis.orthonormalized().inverse() * palm_offset


func _get_current_wrist_to_palm_world() -> Vector3:
	if not is_instance_valid(_skeleton) or _hand_bone_idx < 0 or _middle_finger_bone_idx < 0:
		return _skeleton.global_transform.basis.orthonormalized() * _wrist_to_palm_local if is_instance_valid(_skeleton) else Vector3.ZERO

	var hand_pose := _skeleton.get_bone_global_pose(_hand_bone_idx)
	var middle_pose := _skeleton.get_bone_global_pose(_middle_finger_bone_idx)
	var palm_offset := middle_pose.origin - hand_pose.origin
	if palm_offset.length_squared() < 0.000001:
		return _skeleton.global_transform.basis.orthonormalized() * _wrist_to_palm_local
	return _skeleton.global_transform.basis.orthonormalized() * palm_offset


## The rendered grip is the source of truth. BoneAttachment3D owns the exact
## authored offset and internal pose conversion, so recreating its transform
## from a skeleton pose is not reliable across imported models.
func _get_current_grip_transform() -> Transform3D:
	if not is_instance_valid(_left_hand_grip):
		return Transform3D.IDENTITY
	return _left_hand_grip.global_transform


func _refresh_weapon_mount() -> void:
	var node: Node = _left_hand_grip if is_instance_valid(_left_hand_grip) else _left_hand_wrist_target
	while is_instance_valid(node):
		if node is BoneAttachment3D:
			(node as BoneAttachment3D).on_skeleton_update()
			return
		node = node.get_parent()


## 记录「动画手腕朝向 相对于 握把朝向」的差值
func _wrist_offset_rad() -> Vector3:
	if not _config:
		return Vector3.ZERO
	var d := _config.wrist_rotation_offset
	return Vector3(deg_to_rad(d.x), deg_to_rad(d.y), deg_to_rad(d.z))


class HandTargetModifier extends SkeletonModifier3D:
	var sync_enabled: bool = false
	var _controller: HandIKController


	func setup(controller: HandIKController) -> void:
		_controller = controller


	func _process_modification() -> void:
		if sync_enabled and is_instance_valid(_controller):
			_controller._update_hand_target()
