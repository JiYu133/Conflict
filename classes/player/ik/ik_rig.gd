class_name IKRig
extends Node

# ============================================================
# 玩家 IK：双脚贴地 + 双臂握枪
#
# 骨骼上只有两个 IK modifier，执行顺序由这里统一维护：
#   [SpineAim、Force 等姿态叠加] → IKLegs → IKArms → PhysicalBoneSimulator3D
# 腿在手臂之前：骨盆下沉会平移整个上半身，手臂必须在最终躯干上求解。
#
# 手的目标（都是手腕骨骼的世界变换）：
#   右手（扳机手）：武器挂点 WeaponMount 在动画右手上，武器载体腰射时与挂点重合。
#                   保持「右手 ↔ 挂点」的相对关系，武器载体移动（ADS、后坐、晃动）时右手随之移动。
#   左手（扶枪手）：武器上的 LeftHandWristTarget 就是左手腕的位置与朝向。
# ============================================================

## 每帧双臂 IK 完成后发出（测试 / 采样用）。
signal arms_processed

var left_arm := ArmIK.new()
var right_arm := ArmIK.new()
var left_leg := LegIK.new()
var right_leg := LegIK.new()

var _player: CharacterBody3D
var _model_manager: PlayerModelManager
var _config: IKRigConfig
var _weapon_pose: PlayerCameraController
var _skeleton: Skeleton3D
var _legs_modifier: IKLegsModifier
var _arms_modifier: IKArmsModifier
var _chest: int = -1
var _pelvis: int = -1

var _weapon: BaseWeapon
var _support_marker: Node3D
var _support_weight: float = 1.0
var _arm_weight: float = 0.0
var _grip_slide: float = 0.0

var _legs_enabled: bool = false
var _pelvis_drop: float = 0.0
var _body_hit: Dictionary = {"colliding": false, "point": Vector3.ZERO, "normal": Vector3.UP}

const PELVIS_FADE_SPEED := 0.5


func initialize(player: CharacterBody3D, model_manager: PlayerModelManager, config: IKRigConfig, weapon_pose: PlayerCameraController) -> void:
	_player = player
	_config = config if config else IKRigConfig.new()
	_weapon_pose = weapon_pose
	if is_instance_valid(_model_manager) and _model_manager.model_unloaded.is_connected(clear):
		_model_manager.model_unloaded.disconnect(clear)
	_model_manager = model_manager
	if is_instance_valid(_model_manager):
		_model_manager.model_unloaded.connect(clear)


## 模型加载后调用：绑定骨骼链、创建 modifier 并排好顺序。
func bind_skeleton(skeleton: Skeleton3D) -> void:
	clear()
	if not is_instance_valid(skeleton):
		GlobalLogger.warn("IKRig", "未找到 Skeleton3D，IK 已禁用")
		return
	_skeleton = skeleton
	var config := _config if _config else IKRigConfig.new()
	if not left_arm.bind(skeleton, config.left_arm_bones):
		GlobalLogger.warn("IKRig", "左臂骨骼链无效：%s" % [config.left_arm_bones])
	if not right_arm.bind(skeleton, config.right_arm_bones):
		GlobalLogger.warn("IKRig", "右臂骨骼链无效：%s" % [config.right_arm_bones])
	if not left_leg.bind(skeleton, config.left_leg_bones):
		GlobalLogger.warn("IKRig", "左腿骨骼链无效：%s" % [config.left_leg_bones])
	if not right_leg.bind(skeleton, config.right_leg_bones):
		GlobalLogger.warn("IKRig", "右腿骨骼链无效：%s" % [config.right_leg_bones])
	if left_arm.is_bound():
		var clavicle := skeleton.get_bone_parent(left_arm.upper)
		_chest = skeleton.get_bone_parent(clavicle) if clavicle >= 0 else -1
		_pelvis = left_arm.upper
		while skeleton.get_bone_parent(_pelvis) >= 0:
			_pelvis = skeleton.get_bone_parent(_pelvis)
	_sample_grip_pose()

	_legs_modifier = IKLegsModifier.new()
	_legs_modifier.name = "IKLegs"
	_legs_modifier.rig = self
	skeleton.add_child(_legs_modifier)
	_arms_modifier = IKArmsModifier.new()
	_arms_modifier.name = "IKArms"
	_arms_modifier.rig = self
	skeleton.add_child(_arms_modifier)
	_order_modifiers()
	skeleton.child_entered_tree.connect(_on_skeleton_child_entered)
	_sync_modifier_activity()


func clear() -> void:
	if is_instance_valid(_skeleton) and _skeleton.child_entered_tree.is_connected(_on_skeleton_child_entered):
		_skeleton.child_entered_tree.disconnect(_on_skeleton_child_entered)
	for modifier in [_legs_modifier, _arms_modifier]:
		if is_instance_valid(modifier):
			modifier.active = false
			if modifier.get_parent():
				modifier.get_parent().remove_child(modifier)
			modifier.queue_free()
	_legs_modifier = null
	_arms_modifier = null
	_skeleton = null
	_chest = -1
	_pelvis = -1
	_pelvis_drop = 0.0
	_arm_weight = 0.0
	_grip_slide = 0.0
	for limb in [left_arm, right_arm, left_leg, right_leg]:
		limb.clear()


## 换武器或配件后调用。support_weight 为左手（扶枪手）的权重，来自 WeaponConfig。
func set_weapon(weapon: BaseWeapon, support_weight: float = 1.0) -> void:
	if is_instance_valid(_weapon) and is_instance_valid(_weapon.attachment_manager) \
			and _weapon.attachment_manager.attachments_changed.is_connected(_refresh_support_marker):
		_weapon.attachment_manager.attachments_changed.disconnect(_refresh_support_marker)
	_weapon = weapon if is_instance_valid(weapon) else null
	_support_weight = clampf(support_weight, 0.0, 1.0)
	if _weapon and is_instance_valid(_weapon.attachment_manager):
		_weapon.attachment_manager.attachments_changed.connect(_refresh_support_marker)
	_refresh_support_marker()


## 每帧由 BasePlayer 调用。active = 存活且未进入布娃娃。
func update(delta: float, active: bool, prone: bool, sprinting: bool) -> void:
	var config := _config if _config else IKRigConfig.new()
	if active:
		var goal := config.sprint_arm_weight if sprinting else 1.0
		_arm_weight = move_toward(_arm_weight, goal, delta / maxf(config.arm_blend_time, 0.001))
	else:
		_arm_weight = 0.0
	_legs_enabled = active and not prone
	if not active:
		# 死亡 / 布娃娃：立即交还给动画与物理。
		left_leg.blend = 0.0
		right_leg.blend = 0.0
		_pelvis_drop = 0.0
	elif prone:
		# 趴下过渡：双脚逐渐释放（目标保持最后一帧的位置）。
		left_leg.blend = move_toward(left_leg.blend, 0.0, config.leg_blend_speed * delta)
		right_leg.blend = move_toward(right_leg.blend, 0.0, config.leg_blend_speed * delta)
		_pelvis_drop = move_toward(_pelvis_drop, 0.0, PELVIS_FADE_SPEED * delta)
	_sync_modifier_activity()


func get_arm_weight() -> float:
	return _arm_weight


func get_pelvis_drop() -> float:
	return _pelvis_drop


func get_grip_slide() -> float:
	return _grip_slide


func get_arms_modifier() -> SkeletonModifier3D:
	return _arms_modifier


func get_legs_modifier() -> SkeletonModifier3D:
	return _legs_modifier


## 开发辅助：返回当前左手腕（未经 IK 时即动画手腕）在 LeftHandWristTarget 父节点空间中的变换，
## 可直接写回护木 / 武器场景作为该 Marker 的 transform。
func capture_support_hand_marker() -> Transform3D:
	if not left_arm.is_bound() or not is_instance_valid(_support_marker):
		return Transform3D.IDENTITY
	var parent := _support_marker.get_parent() as Node3D
	var wrist := TwoBoneIK.bone_world_transform(_skeleton, left_arm.hand)
	return parent.global_transform.affine_inverse() * Transform3D(wrist.basis.orthonormalized(), wrist.origin)


# ── 物理帧：地面检测 ─────────────────────────────────────────

func _physics_process(_delta: float) -> void:
	if not _legs_enabled or not is_instance_valid(_skeleton) or not is_instance_valid(_player):
		return
	var config := _config if _config else IKRigConfig.new()
	var space := _skeleton.get_world_3d().direct_space_state
	var exclude: Array[RID] = [_player.get_rid()]
	left_leg.probe(_skeleton, space, exclude, config)
	right_leg.probe(_skeleton, space, exclude, config)
	var origin := _player.global_position
	var query := PhysicsRayQueryParameters3D.create(origin + Vector3.UP * 0.1, origin + Vector3.DOWN * 2.5, PhysicsLayers.WORLD)
	query.exclude = exclude
	var result := space.intersect_ray(query)
	_body_hit = {"colliding": not result.is_empty(), "point": result.get("position", Vector3.ZERO), "normal": result.get("normal", Vector3.UP)}


# ── 腿部阶段（IKLegs）─────────────────────────────────────────

func _process_legs(delta: float) -> void:
	var config := _config if _config else IKRigConfig.new()
	if _legs_enabled:
		var support_y := INF
		for leg in [left_leg, right_leg]:
			if leg.is_bound():
				support_y = minf(support_y, TwoBoneIK.bone_world_position(_skeleton, leg.foot).y)
		var on_ground := is_instance_valid(_player) and _player.is_on_floor()
		var body_ground_y: float = _body_hit.point.y if _body_hit.colliding else NAN
		left_leg.plan(_skeleton, support_y, body_ground_y, on_ground, delta, config)
		right_leg.plan(_skeleton, support_y, body_ground_y, on_ground, delta, config)
		var needed := minf(maxf(left_leg.pelvis_drop_needed(_skeleton, config), right_leg.pelvis_drop_needed(_skeleton, config)), config.max_pelvis_drop)
		var response := config.pelvis_sink_response if needed > _pelvis_drop else config.pelvis_rise_response
		_pelvis_drop = lerpf(_pelvis_drop, needed, 1.0 - exp(-response * maxf(delta, 0.0)))
	_apply_pelvis_drop()
	left_leg.solve(_skeleton, config)
	right_leg.solve(_skeleton, config)


func _apply_pelvis_drop() -> void:
	if _pelvis < 0 or _pelvis_drop <= 0.0:
		return
	var parent_basis := _skeleton.global_basis
	var parent := _skeleton.get_bone_parent(_pelvis)
	if parent >= 0:
		parent_basis *= _skeleton.get_bone_global_pose(parent).basis
	var offset := parent_basis.inverse() * (Vector3.DOWN * _pelvis_drop)
	_skeleton.set_bone_pose_position(_pelvis, _skeleton.get_bone_pose_position(_pelvis) + offset)


# ── 手臂阶段（IKArms）─────────────────────────────────────────

func _process_arms() -> void:
	if _arm_weight <= 0.0 or not is_instance_valid(_weapon):
		return
	if is_instance_valid(_weapon_pose):
		_weapon_pose.refresh_weapon_pose()
	_aim_trigger_hand()
	_aim_support_hand()
	var chest := TwoBoneIK.bone_world_position(_skeleton, _chest) if _chest >= 0 else _player.global_position
	var torso_down := (TwoBoneIK.bone_world_position(_skeleton, _pelvis) - chest).normalized() if _pelvis >= 0 else Vector3.DOWN
	for arm in [right_arm, left_arm]:
		if arm.is_bound():
			arm.solve(_skeleton, torso_down, _outward(arm, chest, torso_down))
	arms_processed.emit()


func _aim_trigger_hand() -> void:
	right_arm.has_target = false
	if not right_arm.is_bound() or not is_instance_valid(_weapon_pose):
		return
	var mount := _weapon_pose.get_weapon_pose_source()
	var carrier := _weapon.get_parent() as Node3D
	if not is_instance_valid(mount) or not is_instance_valid(carrier):
		return
	var hand_from_mount := mount.global_transform.affine_inverse() * TwoBoneIK.bone_world_transform(_skeleton, right_arm.hand)
	right_arm.target = carrier.global_transform * hand_from_mount
	right_arm.weight = _arm_weight
	right_arm.has_target = true


func _aim_support_hand() -> void:
	left_arm.has_target = false
	if not left_arm.is_bound() or not is_instance_valid(_support_marker) or _support_weight <= 0.0:
		return
	var wrist := _support_marker.global_transform
	wrist.origin = _slide_into_reach(wrist.origin)
	left_arm.target = wrist
	left_arm.weight = _arm_weight * _support_weight
	left_arm.has_target = true


## 目标超出左臂舒适长度时，沿枪管轴向枪托滑动（手仍在护木上），
## 而不是让手臂完全伸直：伸直附近肘部对微小变化极度敏感，超出后手直接脱离武器。
func _slide_into_reach(origin: Vector3) -> Vector3:
	_grip_slide = 0.0
	var config := _config if _config else IKRigConfig.new()
	var shoulder := TwoBoneIK.bone_world_position(_skeleton, left_arm.upper)
	var reach := left_arm.length(_skeleton) * config.max_reach_ratio
	var to_target := origin - shoulder
	var excess := to_target.length_squared() - reach * reach
	if excess <= 0.0:
		return origin
	var toward_stock := _weapon.global_basis.z.normalized()
	var along := to_target.dot(toward_stock)
	var discriminant := along * along - excess
	var slide := -along - sqrt(discriminant) if discriminant >= 0.0 else -along
	_grip_slide = clampf(slide, 0.0, config.support_hand_max_slide)
	return origin + toward_stock * _grip_slide


func _outward(arm: ArmIK, chest: Vector3, torso_down: Vector3) -> Vector3:
	var side := TwoBoneIK.bone_world_position(_skeleton, arm.upper) - chest
	return (side - torso_down * side.dot(torso_down)).normalized()


# ── 内部 ─────────────────────────────────────────────────────

func _refresh_support_marker() -> void:
	var config := _config if _config else IKRigConfig.new()
	_support_marker = _weapon.find_grip_node(String(config.support_hand_marker)) if is_instance_valid(_weapon) else null
	if is_instance_valid(_weapon) and not _support_marker:
		GlobalLogger.warn("IKRig", "武器 '%s' 没有 %s，左手不做 IK" % [_weapon.name, config.support_hand_marker])


func _sample_grip_pose() -> void:
	var config := _config if _config else IKRigConfig.new()
	if config.grip_pose_animation == &"" or not is_instance_valid(_model_manager):
		return
	var animator := _model_manager.animator
	if not is_instance_valid(animator) or not animator.has_animation(config.grip_pose_animation):
		GlobalLogger.warn("IKRig", "未找到握枪手指参考动画 '%s'，手指跟随动画" % config.grip_pose_animation)
		return
	var animation := animator.get_animation(config.grip_pose_animation)
	left_arm.sample_grip_pose(_skeleton, animation)
	right_arm.sample_grip_pose(_skeleton, animation)


func _sync_modifier_activity() -> void:
	if is_instance_valid(_legs_modifier):
		_legs_modifier.active = _legs_enabled or left_leg.blend > 0.0 or right_leg.blend > 0.0 or _pelvis_drop > 0.0
	if is_instance_valid(_arms_modifier):
		_arms_modifier.active = _arm_weight > 0.0 and is_instance_valid(_weapon)


func _on_skeleton_child_entered(node: Node) -> void:
	if node is SkeletonModifier3D and node != _legs_modifier and node != _arms_modifier:
		_order_modifiers.call_deferred()


## 姿态叠加 modifier（原顺序）→ IKLegs → IKArms → PhysicalBoneSimulator3D。
func _order_modifiers() -> void:
	if not is_instance_valid(_skeleton):
		return
	var layers: Array[Node] = []
	var physics: Array[Node] = []
	for child in _skeleton.get_children():
		if child == _legs_modifier or child == _arms_modifier:
			continue
		if child is PhysicalBoneSimulator3D:
			physics.append(child)
		elif child is SkeletonModifier3D:
			layers.append(child)
	var ordered: Array[Node] = []
	ordered.append_array(layers)
	ordered.append(_legs_modifier)
	ordered.append(_arms_modifier)
	ordered.append_array(physics)
	for node in ordered:
		if is_instance_valid(node) and node.get_parent() == _skeleton:
			_skeleton.move_child(node, -1)


class IKLegsModifier extends SkeletonModifier3D:
	var rig: IKRig

	func _process_modification_with_delta(delta: float) -> void:
		if is_instance_valid(rig):
			rig._process_legs(delta)


class IKArmsModifier extends SkeletonModifier3D:
	var rig: IKRig

	func _process_modification() -> void:
		if is_instance_valid(rig):
			rig._process_arms()
