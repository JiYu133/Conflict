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
var _left_hand_grip: Node3D     # 武器上的 LeftHandGrip Marker3D
var _current_weapon: BaseWeapon
var _enabled: bool = false
var _ik_weight: float = 1.0

# 手腕朝向标定：握把 Marker 的朝向由美术随手摆放（AK 本体握把带约 40° 倾斜，
# 导轨护木握把是 90° 翻转），直接把它套到手骨上会拧歪手腕。
# 这里记录「动画手腕朝向 相对于 握把朝向」的差值，每帧还原，手腕即保持自然姿态。
var _skeleton: Skeleton3D = null
var _hand_bone_idx: int = -1
var _grip_to_hand_basis: Basis = Basis.IDENTITY
var _wrist_calibrated: bool = false

var _is_running: bool = false
var _is_sprinting: bool = false
var _is_ads: bool = false

var _current_weight: float = 0.0
var _target_weight: float = 0.0


func initialize(_model_manager: PlayerModelManager, _lookup: ModelLookupConfig) -> void:
	pass


func setup(skeleton: Skeleton3D, config: HandIKConfig = null) -> void:
	_config = config if config else HandIKConfig.new()
	_skeleton = skeleton
	_hand_bone_idx = skeleton.find_bone(_config.tip_bone_name)
	if _hand_bone_idx == -1:
		GlobalLogger.warn("HandIK", "未找到手腕骨骼 '%s'，手腕朝向标定不可用" % _config.tip_bone_name)

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
	_wrist_calibrated = false  # 换武器 → 握把朝向变了，重新标定手腕
	if not _left_hand_grip:
		GlobalLogger.warn("HandIK", "武器 '%s' 没有 LeftHandGrip 节点，左手 IK 不启用" % weapon.name)
	else:
		_enabled = true
		GlobalLogger.info("HandIK", "左手 IK 启用: grip=%s  weight=%.2f" % [
			_left_hand_grip.get_path(), _ik_weight])


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
	_enabled = _left_hand_grip != null
	# 换护木/握把后握把 Marker 朝向可能完全不同（导轨护木是 90° 翻转），需重新标定
	_wrist_calibrated = false
	if _enabled:
		GlobalLogger.debug("HandIK", "配件变更，左手握把更新: %s" % _left_hand_grip.get_path())
	else:
		GlobalLogger.warn("HandIK", "配件变更后未找到 LeftHandGrip，左手 IK 暂停")


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
	if not _ik_node:
		return

	# 目标点跟随武器上的左手握把（武器随右手骨骼移动，故目标每帧都在变）
	if _enabled and is_instance_valid(_left_hand_grip) and _hand_target:
		_update_hand_target()

	var blend_time := maxf(_config.weight_blend_time if _config else 0.12, 0.001)
	var effective_target := _target_weight if _enabled else 0.0
	_current_weight = move_toward(_current_weight, effective_target, delta / blend_time)
	_ik_node.influence = _current_weight


## 位置永远取握把；朝向按配置决定是否用标定后的自然手腕姿态。
func _update_hand_target() -> void:
	var grip_xf: Transform3D = _left_hand_grip.global_transform
	var grip_basis: Basis = grip_xf.basis.orthonormalized()

	if not _config.auto_calibrate_wrist:
		_hand_target.global_transform = Transform3D(
			grip_basis * Basis.from_euler(_wrist_offset_rad()), grip_xf.origin
		)
		return

	# 首帧（或换武器/换配件后）标定：此时 influence 仍在 0 附近，
	# 手腕姿态来自动画，未被 IK 污染，正好用作参考姿态。
	if not _wrist_calibrated:
		_calibrate_wrist(grip_basis)

	_hand_target.global_transform = Transform3D(
		grip_basis * _grip_to_hand_basis * Basis.from_euler(_wrist_offset_rad()),
		grip_xf.origin
	)


## 记录「动画手腕朝向 相对于 握把朝向」的差值
func _calibrate_wrist(grip_basis: Basis) -> void:
	if not _skeleton or _hand_bone_idx == -1:
		_grip_to_hand_basis = Basis.IDENTITY
		_wrist_calibrated = true
		return
	var hand_global: Basis = (
		_skeleton.global_transform.basis.orthonormalized()
		* _skeleton.get_bone_global_pose(_hand_bone_idx).basis.orthonormalized()
	)
	_grip_to_hand_basis = grip_basis.inverse() * hand_global
	_wrist_calibrated = true
	GlobalLogger.debug("HandIK", "手腕朝向已标定（握把→手腕差值已记录）")


func _wrist_offset_rad() -> Vector3:
	if not _config:
		return Vector3.ZERO
	var d := _config.wrist_rotation_offset
	return Vector3(deg_to_rad(d.x), deg_to_rad(d.y), deg_to_rad(d.z))
