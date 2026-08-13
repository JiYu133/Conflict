class_name FootIKController
extends Node


var _skeleton: Skeleton3D
var _model_manager: PlayerModelManager
var _config: ModelLookupConfig
var _player: CharacterBody3D  # 用于排除自身碰撞

var _left_ik: TwoBoneIK3D
var _right_ik: TwoBoneIK3D
var _left_target: Marker3D
var _right_target: Marker3D

var _left_blend: float = 0.0
var _right_blend: float = 0.0

var _ankle_modifier: FootAnkleModifier

var _left_foot_idx: int = -1
var _right_foot_idx: int = -1

const BLEND_SPEED       := 8.0
const RAY_ABOVE         := 0.3    # 射线起点在脚骨上方多少米
const RAY_BELOW         := 0.4    # 射线向下扫多少米
const ANKLE_OFFSET      := 0.05   # 脚踝关节到脚底的距离（米），防止脚陷地/悬空，按实际模型微调
const ANKLE_BONE_LEFT   := "mixamorig_LeftFoot"
const ANKLE_BONE_RIGHT  := "mixamorig_RightFoot"

var _diag_timer: int = 0
const DIAG_INTERVAL := 180


func initialize(model_manager: PlayerModelManager, config: ModelLookupConfig) -> void:
	_model_manager = model_manager
	_config = config
	_skeleton = model_manager.skeleton
	# 向上找到 CharacterBody3D，用于射线排除自身
	var n: Node = model_manager
	while n:
		if n is CharacterBody3D:
			_player = n as CharacterBody3D
			break
		n = n.get_parent()
	_model_manager.model_loaded.connect(_on_model_loaded)


func _on_model_loaded(_model: Node3D) -> void:
	_skeleton = _model_manager.skeleton
	_setup()


func _setup() -> void:
	if not _skeleton:
		return

	_left_ik      = _skeleton.get_node_or_null("LeftFootIK")      as TwoBoneIK3D
	_right_ik     = _skeleton.get_node_or_null("RightFootIK")     as TwoBoneIK3D
	_left_target  = _skeleton.get_node_or_null("LeftFootTarget")  as Marker3D
	_right_target = _skeleton.get_node_or_null("RightFootTarget") as Marker3D

	if not _left_ik or not _right_ik:
		GlobalLogger.warn("FootIK", "未找到 LeftFootIK / RightFootIK，请在编辑器里 Skeleton3D 下添加 TwoBoneIK3D 节点。")
	if not _left_target or not _right_target:
		GlobalLogger.warn("FootIK", "未找到 LeftFootTarget / RightFootTarget Marker3D。")

	_setup_ankle_modifier()

	if _left_ik:
		_left_ik.influence = 0.0
	if _right_ik:
		_right_ik.influence = 0.0

	_left_foot_idx  = _skeleton.find_bone(ANKLE_BONE_LEFT)
	_right_foot_idx = _skeleton.find_bone(ANKLE_BONE_RIGHT)

	GlobalLogger.info("FootIK", "脚部 IK 初始化完成  left_ik=%s  right_ik=%s" % [
		str(is_instance_valid(_left_ik)), str(is_instance_valid(_right_ik))])


func _setup_ankle_modifier() -> void:
	_ankle_modifier = _skeleton.get_node_or_null("FootAnkleModifier") as FootAnkleModifier
	if not _ankle_modifier:
		_ankle_modifier = FootAnkleModifier.new()
		_ankle_modifier.name = "FootAnkleModifier"
		_skeleton.add_child(_ankle_modifier)
	_ankle_modifier.setup(_skeleton, self)


func process_ik(delta: float) -> void:
	if not _left_ik and not _right_ik:
		return
	if not is_instance_valid(_skeleton):
		return

	var left_hit  := _raycast_foot(_left_foot_idx)
	var right_hit := _raycast_foot(_right_foot_idx)

	var on_ground := _player != null and _player.is_on_floor()

	var left_target_blend  := 1.0 if (left_hit.colliding  and on_ground) else 0.0
	var right_target_blend := 1.0 if (right_hit.colliding and on_ground) else 0.0

	_left_blend  = move_toward(_left_blend,  left_target_blend,  BLEND_SPEED * delta)
	_right_blend = move_toward(_right_blend, right_target_blend, BLEND_SPEED * delta)

	# target 位置 = 地面碰撞点 + 脚踝偏移，防止脚踝关节沉入地面
	if _left_target and left_hit.colliding:
		_left_target.global_position = left_hit.point + Vector3.UP * ANKLE_OFFSET
	if _right_target and right_hit.colliding:
		_right_target.global_position = right_hit.point + Vector3.UP * ANKLE_OFFSET

	if _left_ik:
		_left_ik.influence = _left_blend
	if _right_ik:
		_right_ik.influence = _right_blend

	if _ankle_modifier:
		_ankle_modifier.left_normal  = left_hit.normal  if left_hit.colliding  else Vector3.UP
		_ankle_modifier.right_normal = right_hit.normal if right_hit.colliding else Vector3.UP
		_ankle_modifier.left_blend   = _left_blend
		_ankle_modifier.right_blend  = _right_blend

	_diag_timer += 1
	if _diag_timer >= DIAG_INTERVAL:
		_diag_timer = 0
		GlobalLogger.info("FootIK", "[诊断] L: blend=%.2f hit=%s  R: blend=%.2f hit=%s" % [
			_left_blend, str(left_hit.colliding), _right_blend, str(right_hit.colliding)])


# 从脚骨骼世界位置上方向下投射射线，不依赖 BoneAttachment3D
func _raycast_foot(bone_idx: int) -> Dictionary:
	var result := {"colliding": false, "point": Vector3.ZERO, "normal": Vector3.UP}
	if bone_idx == -1 or not is_instance_valid(_skeleton):
		return result

	# 脚骨骼当前世界位置
	var foot_world: Vector3 = (_skeleton.global_transform * _skeleton.get_bone_global_pose(bone_idx)).origin
	var ray_from := foot_world + Vector3.UP * RAY_ABOVE
	var ray_to   := foot_world + Vector3.DOWN * RAY_BELOW

	var query := PhysicsRayQueryParameters3D.create(ray_from, ray_to)
	query.collision_mask = PhysicsLayers.WORLD
	if _player:
		query.exclude = [_player.get_rid()]

	var space := _skeleton.get_world_3d().direct_space_state
	if not space:
		return result

	var hit := space.intersect_ray(query)
	if not hit.is_empty():
		result.colliding = true
		result.point     = hit.position
		result.normal    = hit.normal
	return result


# ─────────────────────────────────────────────────────────────
# 脚踝法线对齐修改器
# ─────────────────────────────────────────────────────────────
class FootAnkleModifier extends SkeletonModifier3D:

	var _skeleton: Skeleton3D
	var _left_idx: int  = -1
	var _right_idx: int = -1

	var left_normal:  Vector3 = Vector3.UP
	var right_normal: Vector3 = Vector3.UP
	var left_blend:   float   = 0.0
	var right_blend:  float   = 0.0


	func setup(skeleton: Skeleton3D, _controller: FootIKController) -> void:
		_skeleton = skeleton
		_left_idx  = skeleton.find_bone(ANKLE_BONE_LEFT)
		_right_idx = skeleton.find_bone(ANKLE_BONE_RIGHT)


	func _process_modification() -> void:
		if _left_idx != -1 and left_blend > 0.001:
			_apply_ankle_rotation(_left_idx, left_normal, left_blend)
		if _right_idx != -1 and right_blend > 0.001:
			_apply_ankle_rotation(_right_idx, right_normal, right_blend)


	func _apply_ankle_rotation(bone_idx: int, ground_normal: Vector3, blend: float) -> void:
		var skel := get_skeleton()
		if not skel:
			return

		# 计算世界 UP → 地面法线的旋转
		var dot := Vector3.UP.dot(ground_normal)
		if dot >= 0.9999:
			return  # 平地，不旋转

		var rot_axis := Vector3.UP.cross(ground_normal)
		if rot_axis.length_squared() < 0.0001:
			return
		var rot_angle := Vector3.UP.angle_to(ground_normal) * blend

		# 限制最大旋转角（防止极端斜面扭断脚踝）
		rot_angle = clampf(rot_angle, -deg_to_rad(25.0), deg_to_rad(25.0))

		# 转到骨骼本地空间叠加
		var world_rot   := Quaternion(rot_axis.normalized(), rot_angle)
		var skel_basis  := skel.global_transform.basis.orthonormalized()
		var local_extra := Quaternion(skel_basis).inverse() * world_rot * Quaternion(skel_basis)

		skel.set_bone_pose_rotation(bone_idx, local_extra * skel.get_bone_pose_rotation(bone_idx))
