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
var _left_pole: Marker3D
var _right_pole: Marker3D
var _left_ready: bool = false
var _right_ready: bool = false

var _left_blend: float = 0.0
var _right_blend: float = 0.0

var _ankle_modifier: FootAnkleModifier

var _left_foot_idx: int = -1
var _right_foot_idx: int = -1
var _left_hip_idx: int = -1
var _left_knee_idx: int = -1
var _right_hip_idx: int = -1
var _right_knee_idx: int = -1

const BLEND_SPEED       := 8.0
const RAY_ABOVE         := 0.3    # 射线起点在脚骨上方多少米
const RAY_BELOW         := 0.4    # 射线向下扫多少米
const ANKLE_OFFSET      := 0.05   # 脚踝关节到脚底的距离（米），防止脚陷地/悬空，按实际模型微调
const ANKLE_BONE_LEFT   := "mixamorig_LeftFoot"
const ANKLE_BONE_RIGHT  := "mixamorig_RightFoot"
const HIP_BONE_LEFT     := "mixamorig_LeftUpLeg"
const KNEE_BONE_LEFT    := "mixamorig_LeftLeg"
const HIP_BONE_RIGHT    := "mixamorig_RightUpLeg"
const KNEE_BONE_RIGHT   := "mixamorig_RightLeg"

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
	_left_pole    = _left_ik.get_node_or_null("LeftKneePole") as Marker3D if _left_ik else null
	_right_pole   = _right_ik.get_node_or_null("RightKneePole") as Marker3D if _right_ik else null

	_left_hip_idx   = _skeleton.find_bone(HIP_BONE_LEFT)
	_left_knee_idx  = _skeleton.find_bone(KNEE_BONE_LEFT)
	_left_foot_idx  = _skeleton.find_bone(ANKLE_BONE_LEFT)
	_right_hip_idx  = _skeleton.find_bone(HIP_BONE_RIGHT)
	_right_knee_idx = _skeleton.find_bone(KNEE_BONE_RIGHT)
	_right_foot_idx = _skeleton.find_bone(ANKLE_BONE_RIGHT)

	_left_ready = _configure_leg(
		"left", _left_ik, _left_target, _left_pole,
		_left_hip_idx, _left_knee_idx, _left_foot_idx,
		HIP_BONE_LEFT, KNEE_BONE_LEFT, ANKLE_BONE_LEFT
	)
	_right_ready = _configure_leg(
		"right", _right_ik, _right_target, _right_pole,
		_right_hip_idx, _right_knee_idx, _right_foot_idx,
		HIP_BONE_RIGHT, KNEE_BONE_RIGHT, ANKLE_BONE_RIGHT
	)

	_setup_ankle_modifier()
	_apply_blends()

	GlobalLogger.info("FootIK", "脚部 IK 初始化完成  left_ready=%s  right_ready=%s" % [
		str(_left_ready), str(_right_ready)])


func _configure_leg(
	side: String,
	ik: TwoBoneIK3D,
	target: Marker3D,
	pole: Marker3D,
	hip_idx: int,
	knee_idx: int,
	foot_idx: int,
	hip_name: String,
	knee_name: String,
	foot_name: String
) -> bool:
	if not _is_leg_complete(ik, target, pole, hip_idx, knee_idx, foot_idx):
		if ik:
			ik.influence = 0.0
		GlobalLogger.warn(
			"FootIK",
			"%s leg IK 配置不完整；该侧已安全禁用（需要 IK、target、pole 和连续的三段骨骼）。" % side
		)
		return false

	# Keep scene-authored nodes, but refresh every reference against the currently
	# loaded skeleton. This also makes model hot-reload safe.
	ik.set("setting_count", 1)
	ik.set("settings/0/target_node", ik.get_path_to(target))
	ik.set("settings/0/pole_node", ik.get_path_to(pole))
	ik.set("settings/0/root_bone_name", hip_name)
	ik.set("settings/0/root_bone", hip_idx)
	ik.set("settings/0/middle_bone_name", knee_name)
	ik.set("settings/0/middle_bone", knee_idx)
	ik.set("settings/0/end_bone_name", foot_name)
	ik.set("settings/0/end_bone", foot_idx)
	ik.influence = 0.0
	target.global_position = _bone_world_position(foot_idx)
	_update_leg_pole(pole, hip_idx, knee_idx, foot_idx)
	return true


func _is_leg_complete(
	ik: TwoBoneIK3D,
	target: Marker3D,
	pole: Marker3D,
	hip_idx: int,
	knee_idx: int,
	foot_idx: int
) -> bool:
	if not ik or not target or not pole or not is_instance_valid(_skeleton):
		return false
	if hip_idx < 0 or knee_idx < 0 or foot_idx < 0:
		return false
	return _skeleton.get_bone_parent(knee_idx) == hip_idx \
		and _skeleton.get_bone_parent(foot_idx) == knee_idx


func _bone_world_position(bone_idx: int) -> Vector3:
	return (_skeleton.global_transform * _skeleton.get_bone_global_pose(bone_idx)).origin


func _update_leg_pole(pole: Marker3D, hip_idx: int, knee_idx: int, foot_idx: int) -> void:
	if not pole or hip_idx < 0 or knee_idx < 0 or foot_idx < 0:
		return
	var hip := _bone_world_position(hip_idx)
	var knee := _bone_world_position(knee_idx)
	var foot := _bone_world_position(foot_idx)
	var hip_to_foot := foot - hip
	var bend := knee - (hip + hip_to_foot * clampf(
		(knee - hip).dot(hip_to_foot) / maxf(hip_to_foot.length_squared(), 0.000001),
		0.0,
		1.0
	))
	if bend.length_squared() < 0.000001:
		bend = _skeleton.global_basis.z
	var pole_distance := maxf((knee - hip).length() + (foot - knee).length(), 0.3)
	pole.global_position = knee + bend.normalized() * pole_distance


func _setup_ankle_modifier() -> void:
	_ankle_modifier = _skeleton.get_node_or_null("FootAnkleModifier") as FootAnkleModifier
	if not _ankle_modifier:
		_ankle_modifier = FootAnkleModifier.new()
		_ankle_modifier.name = "FootAnkleModifier"
		_skeleton.add_child(_ankle_modifier)
	_ankle_modifier.setup(_skeleton, self)


func process_ik(delta: float, active: bool = true) -> void:
	if not is_instance_valid(_skeleton):
		return
	if not active:
		# Prone/roll clips author the legs, but cutting a standing solver in one
		# frame causes a visible pop. Fade the procedural layer out instead.
		_left_blend = move_toward(_left_blend, 0.0, BLEND_SPEED * delta)
		_right_blend = move_toward(_right_blend, 0.0, BLEND_SPEED * delta)
		_apply_blends()
		return
	if not _left_ready and not _right_ready:
		_apply_blends()
		return

	if _left_ready:
		_update_leg_pole(_left_pole, _left_hip_idx, _left_knee_idx, _left_foot_idx)
	if _right_ready:
		_update_leg_pole(_right_pole, _right_hip_idx, _right_knee_idx, _right_foot_idx)

	var left_hit := _raycast_foot(_left_foot_idx) if _left_ready else _empty_hit()
	var right_hit := _raycast_foot(_right_foot_idx) if _right_ready else _empty_hit()

	var on_ground := _player != null and _player.is_on_floor()

	var left_target_blend := 1.0 if (_left_ready and left_hit.colliding and on_ground) else 0.0
	var right_target_blend := 1.0 if (_right_ready and right_hit.colliding and on_ground) else 0.0

	_left_blend  = move_toward(_left_blend,  left_target_blend,  BLEND_SPEED * delta)
	_right_blend = move_toward(_right_blend, right_target_blend, BLEND_SPEED * delta)

	# target 位置 = 地面碰撞点 + 脚踝偏移，防止脚踝关节沉入地面
	if _left_ready and left_hit.colliding:
		_left_target.global_position = left_hit.point + Vector3.UP * ANKLE_OFFSET
	if _right_ready and right_hit.colliding:
		_right_target.global_position = right_hit.point + Vector3.UP * ANKLE_OFFSET

	if _ankle_modifier:
		_ankle_modifier.left_normal  = left_hit.normal  if left_hit.colliding  else Vector3.UP
		_ankle_modifier.right_normal = right_hit.normal if right_hit.colliding else Vector3.UP
	_apply_blends()

	_diag_timer += 1
	if _diag_timer >= DIAG_INTERVAL:
		_diag_timer = 0


func _apply_blends() -> void:
	if _left_ik:
		_left_ik.influence = _left_blend if _left_ready else 0.0
	if _right_ik:
		_right_ik.influence = _right_blend if _right_ready else 0.0
	if _ankle_modifier:
		_ankle_modifier.left_blend = _left_blend if _left_ready else 0.0
		_ankle_modifier.right_blend = _right_blend if _right_ready else 0.0


func _empty_hit() -> Dictionary:
	return {"colliding": false, "point": Vector3.ZERO, "normal": Vector3.UP}


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

		# set_bone_pose_rotation() expects a pose relative to the bone parent,
		# not merely relative to Skeleton3D. Include the animated parent leg so
		# slopes remain correct while the character turns or an IK solver bends it.
		var world_rot   := Quaternion(rot_axis.normalized(), rot_angle)
		var local_extra := _world_rotation_to_bone_parent_space(bone_idx, world_rot)

		skel.set_bone_pose_rotation(
			bone_idx,
			(local_extra * skel.get_bone_pose_rotation(bone_idx)).normalized()
		)


	func _world_rotation_to_bone_parent_space(bone_idx: int, world_rotation: Quaternion) -> Quaternion:
		var skel := get_skeleton()
		if not skel or bone_idx < 0:
			return Quaternion.IDENTITY
		var parent_world_basis := skel.global_basis.orthonormalized()
		var parent_idx := skel.get_bone_parent(bone_idx)
		if parent_idx >= 0:
			parent_world_basis = (
				skel.global_basis * skel.get_bone_global_pose(parent_idx).basis
			).orthonormalized()
		var parent_world_rotation := parent_world_basis.get_rotation_quaternion()
		return (
			parent_world_rotation.inverse() * world_rotation * parent_world_rotation
		).normalized()
