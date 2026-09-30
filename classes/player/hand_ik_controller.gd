class_name HandIKController
extends Node

# 双手 IK 控制器（TwoBoneIK3D 版本）。实际武器位于独立 WeaponPoseRoot 下，
# 左右手目标每次骨骼修改时从武器握把实时采样，因此不存在骨骼驱动武器、
# 武器又反向驱动同一骨骼的循环依赖。

var _config: HandIKConfig

var _ik_node: TwoBoneIK3D
var _hand_target: Marker3D      # Skeleton3D 下的中间目标点，由代码每帧更新
var _right_ik_node: TwoBoneIK3D
var _right_hand_target: Marker3D
var _target_modifier: HandTargetModifier
var _left_hand_grip: Node3D     # 武器上的 LeftHandGrip 掌心接触点
var _left_hand_wrist_target: Node3D # 武器上的 LeftHandWristTarget 腕部目标
var _right_hand_grip: Node3D
var _using_wrist_target_fallback: bool = false
var _model_manager: PlayerModelManager
var _owns_hand_target: bool = false
var _owns_right_hand_target: bool = false
var _current_weapon: BaseWeapon
var _enabled: bool = false
var _right_enabled: bool = false
var _ik_weight: float = 1.0
var _weapon_pose_controller: PlayerCameraController

# 左手掌根偏移用于把 TwoBoneIK 的腕骨目标从握把接触点退回到腕部。
# TwoBoneIK 负责双臂位置，手腕旋转继续来自底层动画，不直接写骨骼旋转。
var _skeleton: Skeleton3D = null
var _hand_bone_idx: int = -1
var _right_hand_bone_idx: int = -1
var _middle_finger_bone_idx: int = -1
var _wrist_to_palm_local: Vector3 = Vector3.ZERO

var _is_running: bool = false
var _is_sprinting: bool = false
var _is_ads: bool = false
var _is_prone: bool = false

var _current_weight: float = 0.0
var _target_weight: float = 0.0


func initialize(model_manager: PlayerModelManager, _lookup: ModelLookupConfig) -> void:
	if is_instance_valid(_model_manager) and _model_manager.model_unloaded.is_connected(clear):
		_model_manager.model_unloaded.disconnect(clear)
	_model_manager = model_manager
	if is_instance_valid(_model_manager):
		_model_manager.model_unloaded.connect(clear)


func set_weapon_pose_controller(controller: PlayerCameraController) -> void:
	_weapon_pose_controller = controller


## Release old modifiers before accepting a replacement model, including failed loads.
func clear() -> void:
	_disconnect_weapon_attachments()
	if is_instance_valid(_ik_node):
		_ik_node.influence = 0.0
	if is_instance_valid(_right_ik_node):
		_right_ik_node.influence = 0.0
	for modifier in [_target_modifier]:
		if is_instance_valid(modifier):
			modifier.active = false
			if modifier.get_parent():
				modifier.get_parent().remove_child(modifier)
			modifier.queue_free()
	if _owns_hand_target and is_instance_valid(_hand_target):
		if _hand_target.get_parent():
			_hand_target.get_parent().remove_child(_hand_target)
		_hand_target.queue_free()
	if _owns_right_hand_target and is_instance_valid(_right_hand_target):
		if _right_hand_target.get_parent():
			_right_hand_target.get_parent().remove_child(_right_hand_target)
		_right_hand_target.queue_free()
	_ik_node = null
	_right_ik_node = null
	_target_modifier = null
	_hand_target = null
	_right_hand_target = null
	_owns_hand_target = false
	_owns_right_hand_target = false
	_left_hand_grip = null
	_right_hand_grip = null
	_skeleton = null
	_hand_bone_idx = -1
	_right_hand_bone_idx = -1
	_enabled = false
	_right_enabled = false
	_left_hand_wrist_target = null
	_using_wrist_target_fallback = false
	_middle_finger_bone_idx = -1
	_wrist_to_palm_local = Vector3.ZERO
	_current_weight = 0.0
	_target_weight = 0.0


func setup(skeleton: Skeleton3D, config: HandIKConfig = null) -> void:
	clear()
	_config = config if config else HandIKConfig.new()
	_skeleton = skeleton
	if not is_instance_valid(_skeleton):
		GlobalLogger.warn("HandIK", "未找到 Skeleton3D，手部 IK 已禁用")
		return
	_hand_bone_idx = skeleton.find_bone(_config.tip_bone_name)
	_right_hand_bone_idx = skeleton.find_bone("mixamorig_RightHand")
	if _hand_bone_idx == -1:
		GlobalLogger.warn("HandIK", "未找到手腕骨骼 '%s'，手腕朝向标定不可用" % _config.tip_bone_name)
	_middle_finger_bone_idx = skeleton.find_bone("mixamorig_LeftHandMiddle1")
	if _hand_bone_idx >= 0 and _middle_finger_bone_idx >= 0:
		var hand_rest := skeleton.get_bone_global_rest(_hand_bone_idx)
		var middle_rest := skeleton.get_bone_global_rest(_middle_finger_bone_idx)
		_wrist_to_palm_local = hand_rest.basis.inverse() * (middle_rest.origin - hand_rest.origin)

	var node_name := _config.ik_node_name
	_ik_node = skeleton.get_node_or_null(node_name) as TwoBoneIK3D
	if not _ik_node or _ik_node.setting_count < 1 or _hand_bone_idx < 0:
		GlobalLogger.warn("HandIK", "Skeleton3D 下未找到 TwoBoneIK3D 节点 '%s'，请在编辑器里添加。" % node_name)
		clear()
		return
	_right_ik_node = skeleton.get_node_or_null("RightHandIK") as TwoBoneIK3D
	if not _right_ik_node or _right_ik_node.setting_count < 1 or _right_hand_bone_idx < 0:
		GlobalLogger.warn("HandIK", "Skeleton3D 下未找到可用的 RightHandIK，右手 IK 已禁用")
		_right_ik_node = null

	# 查找或创建中间目标 Marker3D（固定挂在 Skeleton3D 下，路径稳定）
	_hand_target = skeleton.get_node_or_null("LeftHandTarget") as Marker3D
	if not _hand_target:
		_hand_target = Marker3D.new()
		_owns_hand_target = true
		_hand_target.name = "LeftHandTarget"
		skeleton.add_child(_hand_target)
		GlobalLogger.info("HandIK", "已自动创建 LeftHandTarget Marker3D")
	_right_hand_target = skeleton.get_node_or_null("RightHandTarget") as Marker3D
	if not _right_hand_target:
		_right_hand_target = Marker3D.new()
		_owns_right_hand_target = true
		_right_hand_target.name = "RightHandTarget"
		skeleton.add_child(_right_hand_target)
		GlobalLogger.info("HandIK", "已自动创建 RightHandTarget Marker3D")

	# index 0 是第一条（唯一一条）IK 设置
	_ik_node.set_target_node(0, _ik_node.get_path_to(_hand_target))
	_ik_node.influence = 0.0
	if is_instance_valid(_right_ik_node):
		_right_ik_node.set_target_node(0, _right_ik_node.get_path_to(_right_hand_target))
		_right_ik_node.influence = 0.0

	# 目标同步必须发生在脊柱修正之后、TwoBoneIK3D 求解之前。
	# SkeletonModifier3D 的兄弟顺序就是执行顺序，因此把同步器插到 IK 前面。
	_target_modifier = HandTargetModifier.new()
	_target_modifier.name = "LeftHandTargetSync"
	skeleton.add_child(_target_modifier)
	_target_modifier.setup(self)
	var first_hand_ik_index := _ik_node.get_index()
	if is_instance_valid(_right_ik_node):
		first_hand_ik_index = mini(first_hand_ik_index, _right_ik_node.get_index())
	skeleton.move_child(_target_modifier, first_hand_ik_index)
	GlobalLogger.info("HandIK", "双手 IK 已绑定，目标点: LeftHandTarget / RightHandTarget")


func set_weapon(weapon: BaseWeapon, ik_weight: float = -1.0) -> void:
	_disconnect_weapon_attachments()
	_left_hand_grip = null
	_left_hand_wrist_target = null
	_right_hand_grip = null
	_enabled = false
	_right_enabled = false
	_using_wrist_target_fallback = false

	if not is_instance_valid(weapon) or not is_instance_valid(_ik_node):
		GlobalLogger.warn("HandIK", "set_weapon: weapon=%s, ik_node=%s — IK 不启用" % [
			str(weapon), str(_ik_node)])
		return

	_current_weapon = weapon
	_ik_weight = ik_weight if ik_weight >= 0.0 else (_config.default_ik_weight if _config else 1.0)
	_update_target_weight()
	_current_weight = 0.0

	if weapon.attachment_manager:
		weapon.attachment_manager.attachments_changed.connect(_on_attachments_changed)

	_left_hand_grip = weapon.find_grip_node("LeftHandGrip")
	_left_hand_wrist_target = weapon.find_grip_node("LeftHandWristTarget")
	_right_hand_grip = weapon.find_grip_node("RightHandGrip")
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
	_right_enabled = is_instance_valid(_right_ik_node) and is_instance_valid(_right_hand_grip)
	if not _right_enabled:
		GlobalLogger.warn("HandIK", "武器 '%s' 缺少 RightHandGrip 或 RightHandIK，右手 IK 不启用" % weapon.name)


func _disconnect_weapon_attachments() -> void:
	if is_instance_valid(_current_weapon) and is_instance_valid(_current_weapon.attachment_manager):
		var am := _current_weapon.attachment_manager
		if am.attachments_changed.is_connected(_on_attachments_changed):
			am.attachments_changed.disconnect(_on_attachments_changed)
	_current_weapon = null


## 配件变更（换护木/握把等）后握把节点可能被替换，重新查找并更新 IK 目标
func _on_attachments_changed() -> void:
	if not is_instance_valid(_current_weapon):
		return
	_left_hand_grip = _current_weapon.find_grip_node("LeftHandGrip")
	_left_hand_wrist_target = _current_weapon.find_grip_node("LeftHandWristTarget")
	_right_hand_grip = _current_weapon.find_grip_node("RightHandGrip")
	_using_wrist_target_fallback = not is_instance_valid(_left_hand_wrist_target)
	_enabled = is_instance_valid(_left_hand_grip) or is_instance_valid(_left_hand_wrist_target)
	_right_enabled = is_instance_valid(_right_ik_node) and is_instance_valid(_right_hand_grip)
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
	if _is_prone:
		_target_weight = base * (_config.prone_ik_weight if _config else 1.0)
	elif _is_sprinting:
		_target_weight = base * (_config.sprint_ik_weight if _config else 0.1)
	elif _is_ads:
		_target_weight = base * (_config.ads_ik_weight if _config else 1.0)
	elif _is_running:
		_target_weight = base * (_config.run_ik_weight if _config else 0.6)
	else:
		_target_weight = base * (_config.walk_ik_weight if _config else 1.0)


func process_ik(delta: float, active: bool = true) -> void:
	if not is_instance_valid(_ik_node):
		return

	var left_can_solve: bool = active and _enabled \
		and (is_instance_valid(_left_hand_wrist_target) or is_instance_valid(_left_hand_grip)) \
		and is_instance_valid(_hand_target)
	var right_can_solve: bool = active and _right_enabled \
		and is_instance_valid(_right_hand_grip) and is_instance_valid(_right_hand_target)
	if is_instance_valid(_target_modifier):
		_target_modifier.sync_enabled = left_can_solve or right_can_solve

	# Sample only in the modifier chain, after spine aim and before IK.

	var blend_time := maxf(_config.weight_blend_time if _config else 0.12, 0.001)
	var effective_target := _target_weight if left_can_solve or right_can_solve else 0.0
	if not active:
		_current_weight = 0.0
		_ik_node.influence = 0.0
		if is_instance_valid(_right_ik_node):
			_right_ik_node.influence = 0.0
		return
	_current_weight = move_toward(_current_weight, effective_target, delta / blend_time)
	_ik_node.influence = _current_weight if left_can_solve else 0.0
	if is_instance_valid(_right_ik_node):
		_right_ik_node.influence = _current_weight if right_can_solve else 0.0


## Build the IK target from separate authored responsibilities:
## LeftHandGrip supplies the wrist position, while LeftHandWristTarget supplies
## only the wrist orientation. A wrist target may still provide the complete
## transform when no grip exists, preserving the legacy fallback path.
func _update_hand_target() -> void:
	_update_hand_targets()


func _update_hand_targets() -> void:
	if is_instance_valid(_weapon_pose_controller):
		_weapon_pose_controller.refresh_weapon_pose()
	if is_instance_valid(_skeleton) and is_instance_valid(_hand_target) \
			and (is_instance_valid(_left_hand_grip) or is_instance_valid(_left_hand_wrist_target)):
		_hand_target.global_transform = _get_current_wrist_target_transform()
	if is_instance_valid(_skeleton) and is_instance_valid(_right_hand_target) \
			and is_instance_valid(_right_hand_grip):
		_right_hand_target.global_transform = _get_current_right_hand_target_transform()


func _get_current_right_hand_target_transform() -> Transform3D:
	var grip_xf := _right_hand_grip.global_transform
	if not is_instance_valid(_weapon_pose_controller) or _right_hand_bone_idx < 0:
		return grip_xf
	var pose_source := _weapon_pose_controller.get_weapon_pose_source()
	if not is_instance_valid(pose_source):
		return grip_xf
	var animated_hand_world := _skeleton.global_transform \
			* _skeleton.get_bone_global_pose(_right_hand_bone_idx)
	var hand_from_source := pose_source.global_transform.affine_inverse() * animated_hand_world
	return grip_xf * hand_from_source


func _get_current_wrist_target_transform() -> Transform3D:
	var has_grip := is_instance_valid(_left_hand_grip)
	var has_wrist_target := is_instance_valid(_left_hand_wrist_target)
	if not has_grip:
		if has_wrist_target:
			return _left_hand_wrist_target.global_transform
		return Transform3D.IDENTITY

	var grip_xf := _left_hand_grip.global_transform
	var grip_basis := grip_xf.basis.orthonormalized()
	var origin := grip_xf.origin + grip_basis * _config.grip_position_offset
	origin -= _get_current_wrist_to_palm_world() * _config.fallback_palm_contact_ratio
	origin += grip_basis * _config.fallback_wrist_position_offset
	var target_basis := grip_basis * Basis.from_euler(_wrist_offset_rad())
	if has_wrist_target:
		target_basis = _left_hand_wrist_target.global_basis.orthonormalized()
	return Transform3D(target_basis, origin)


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
			_controller._update_hand_targets()
