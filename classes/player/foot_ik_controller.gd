class_name FootIKController
extends Node

# 脚部 IK 控制器（TwoBoneIK3D 版本）
#
# 场景端要求（swat.tscn → Skeleton3D 下）：
#   - TwoBoneIK3D  命名 "LeftFootIK"   root=mixamorig_LeftUpLeg  tip=mixamorig_LeftFoot
#   - TwoBoneIK3D  命名 "RightFootIK"  root=mixamorig_RightUpLeg tip=mixamorig_RightFoot
#   - Marker3D      命名 "LeftFootTarget"
#   - Marker3D      命名 "RightFootTarget"
#   两个 TwoBoneIK3D 的 Target Node 分别指向对应 Marker3D
#
# 本脚本负责：
#   1. 射线检测地面 → 移动 Marker3D → 更新 influence
#   2. 脚踝旋转（FootAnkleModifier）对齐地面法线

var _skeleton: Skeleton3D
var _model_manager: PlayerModelManager
var _config: ModelLookupConfig

var _left_ik: TwoBoneIK3D
var _right_ik: TwoBoneIK3D
var _left_target: Marker3D
var _right_target: Marker3D

var _left_ray: RayCast3D
var _right_ray: RayCast3D

var _left_blend: float = 0.0
var _right_blend: float = 0.0

var _ankle_modifier: FootAnkleModifier

var _left_foot_idx: int = -1
var _right_foot_idx: int = -1

const BLEND_SPEED := 8.0
const RAY_LENGTH  := 0.5
const ANKLE_BONE_LEFT  := "mixamorig_LeftFoot"
const ANKLE_BONE_RIGHT := "mixamorig_RightFoot"

# 诊断
var _diag_timer: int = 0
const DIAG_INTERVAL := 180


func initialize(model_manager: PlayerModelManager, config: ModelLookupConfig) -> void:
	_model_manager = model_manager
	_config = config
	_skeleton = model_manager.skeleton
	_model_manager.model_loaded.connect(_on_model_loaded)


func _on_model_loaded(_model: Node3D) -> void:
	_skeleton = _model_manager.skeleton
	_setup()


func _setup() -> void:
	if not _skeleton:
		return

	_left_ik     = _skeleton.get_node_or_null("LeftFootIK")  as TwoBoneIK3D
	_right_ik    = _skeleton.get_node_or_null("RightFootIK") as TwoBoneIK3D
	_left_target = _skeleton.get_node_or_null("LeftFootTarget")  as Marker3D
	_right_target = _skeleton.get_node_or_null("RightFootTarget") as Marker3D

	if not _left_ik or not _right_ik:
		GlobalLogger.warn("FootIK", "未找到 LeftFootIK / RightFootIK，请在编辑器里 Skeleton3D 下添加 TwoBoneIK3D 节点。")

	if not _left_target or not _right_target:
		GlobalLogger.warn("FootIK", "未找到 LeftFootTarget / RightFootTarget Marker3D。")

	_setup_rays()
	_setup_ankle_modifier()

	if _left_ik:
		_left_ik.influence = 0.0
	if _right_ik:
		_right_ik.influence = 0.0

	_left_foot_idx  = _skeleton.find_bone(ANKLE_BONE_LEFT)
	_right_foot_idx = _skeleton.find_bone(ANKLE_BONE_RIGHT)

	GlobalLogger.info("FootIK", "脚部 IK 初始化完成  left_ik=%s  right_ik=%s" % [
		str(is_instance_valid(_left_ik)), str(is_instance_valid(_right_ik))])


func _setup_rays() -> void:
	_left_ray  = _model_manager.find_node_by_names(_config.left_foot_ray_names  if _config else []) as RayCast3D
	_right_ray = _model_manager.find_node_by_names(_config.right_foot_ray_names if _config else []) as RayCast3D

	if not _left_ray:
		_left_ray = _create_ray("LeftFootRay", ANKLE_BONE_LEFT)
	if not _right_ray:
		_right_ray = _create_ray("RightFootRay", ANKLE_BONE_RIGHT)


func _create_ray(ray_name: String, bone_name: String) -> RayCast3D:
	var ray := RayCast3D.new()
	ray.name = ray_name
	ray.target_position = Vector3(0.0, -RAY_LENGTH, 0.0)
	ray.collision_mask = 1
	var bone_idx := _skeleton.find_bone(bone_name)
	if bone_idx != -1:
		var attach := BoneAttachment3D.new()
		attach.bone_name = bone_name
		_skeleton.add_child(attach)
		attach.add_child(ray)
	else:
		_skeleton.add_child(ray)
	return ray


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

	var left_hit  := _get_ray_hit(_left_ray)
	var right_hit := _get_ray_hit(_right_ray)

	_left_blend  = move_toward(_left_blend,  1.0 if left_hit.colliding  else 0.0, BLEND_SPEED * delta)
	_right_blend = move_toward(_right_blend, 1.0 if right_hit.colliding else 0.0, BLEND_SPEED * delta)

	if _left_target and left_hit.colliding:
		_left_target.global_position = left_hit.point
	if _right_target and right_hit.colliding:
		_right_target.global_position = right_hit.point

	if _left_ik:
		_left_ik.influence = _left_blend
	if _right_ik:
		_right_ik.influence = _right_blend

	if _ankle_modifier:
		_ankle_modifier.left_normal  = left_hit.normal  if left_hit.colliding  else Vector3.UP
		_ankle_modifier.right_normal = right_hit.normal if right_hit.colliding else Vector3.UP
		_ankle_modifier.left_blend   = _left_blend
		_ankle_modifier.right_blend  = _right_blend

	# 周期性诊断日志
	_diag_timer += 1
	if _diag_timer >= DIAG_INTERVAL:
		_diag_timer = 0
		GlobalLogger.info("FootIK", "[诊断] L: ik=%s blend=%.2f hit=%s  R: ik=%s blend=%.2f hit=%s" % [
			str(is_instance_valid(_left_ik)),  _left_blend,  str(left_hit.colliding),
			str(is_instance_valid(_right_ik)), _right_blend, str(right_hit.colliding)
		])


func _get_ray_hit(ray: RayCast3D) -> Dictionary:
	var result := {"colliding": false, "point": Vector3.ZERO, "normal": Vector3.UP}
	if ray and ray.is_colliding():
		result.colliding = true
		result.point     = ray.get_collision_point()
		result.normal    = ray.get_collision_normal()
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

		var global_pose := skel.global_transform * skel.get_bone_global_pose(bone_idx)
		var current_up  := global_pose.basis.y.normalized()

		var dot := current_up.dot(ground_normal)
		if dot >= 0.9999:
			return

		var rot_axis := current_up.cross(ground_normal)
		if rot_axis.length_squared() < 0.0001:
			return
		var rot_angle := current_up.angle_to(ground_normal) * blend

		var world_rot  := Quaternion(rot_axis.normalized(), rot_angle)
		var skel_rot   := Quaternion(skel.global_transform.basis.orthonormalized())
		var local_extra := skel_rot.inverse() * world_rot * skel_rot

		var anim_rot := skel.get_bone_pose_rotation(bone_idx)
		skel.set_bone_pose_rotation(bone_idx, local_extra * anim_rot)
