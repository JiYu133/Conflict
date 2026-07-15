class_name UpperBodyAimController
extends SkeletonModifier3D

# 上半身瞄准旋转（Arma3 / EFT 风格）
# 继承 SkeletonModifier3D，_process_modification() 在 AnimationTree 之后、
# 渲染之前执行，保证写入不被覆盖。

var _config: UpperBodyAimConfig
var _camera_controller: PlayerCameraController
var _bone_idx: int = -1
var _target_weight: float = 1.0
var _master_weight: float = 1.0


func setup(
	skeleton: Skeleton3D,
	aim_config: UpperBodyAimConfig,
	camera_controller: PlayerCameraController
) -> void:
	_config = aim_config if aim_config else UpperBodyAimConfig.new()
	_camera_controller = camera_controller

	if not skeleton:
		return

	# SkeletonModifier3D 必须是 Skeleton3D 的子节点
	if get_parent() != skeleton:
		if get_parent():
			get_parent().remove_child(self)
		skeleton.add_child(self)

	_bone_idx = skeleton.find_bone(_config.spine_bone_name)
	if _bone_idx == -1:
		push_warning("UpperBodyAimController: 骨骼未找到: %s" % _config.spine_bone_name)
		return

	GlobalLogger.info("UpperBody", "绑定骨骼 '%s' (idx=%d)" % [_config.spine_bone_name, _bone_idx])


func set_enabled(enabled: bool) -> void:
	_target_weight = 1.0 if enabled else 0.0


func _process_modification() -> void:
	if _bone_idx == -1 or not _camera_controller or not _config:
		return

	var smooth_speed: float = _config.weight_smooth_speed
	_master_weight = move_toward(_master_weight, _target_weight, smooth_speed * get_process_delta_time())
	if _master_weight <= 0.001:
		return

	var skeleton: Skeleton3D = get_skeleton()
	var pitch: float = _camera_controller.get_vertical_angle() * _master_weight * _config.pitch_scale * _config.pitch_sign

	# 骨骼全局右轴作为俯仰旋转轴，不受动画侧转影响
	var global_pose: Transform3D = skeleton.global_transform * skeleton.get_bone_global_pose(_bone_idx)
	var right_axis: Vector3 = global_pose.basis.x.normalized()

	# 世界空间旋转转骨骼局部空间后叠加到动画旋转
	var world_rot: Quaternion = Quaternion(right_axis, pitch)
	var skel_rot: Quaternion = Quaternion(skeleton.global_transform.basis.orthonormalized())
	var local_extra: Quaternion = skel_rot.inverse() * world_rot * skel_rot

	var anim_rot: Quaternion = skeleton.get_bone_pose_rotation(_bone_idx)
	skeleton.set_bone_pose_rotation(_bone_idx, local_extra * anim_rot)
