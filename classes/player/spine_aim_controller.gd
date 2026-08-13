class_name SpineAimController
extends Node

var _player: BasePlayer
var _camera_controller: PlayerCameraController
var _skeleton: Skeleton3D
var _config: SpineAimConfig
var _modifier: SpineAimModifier
var _current_pitch: float = 0.0
var _current_yaw: float = 0.0


func setup(
	skeleton: Skeleton3D,
	player: BasePlayer,
	camera_controller: PlayerCameraController,
	config: SpineAimConfig = null
) -> void:
	_player = player
	_camera_controller = camera_controller
	_skeleton = skeleton
	_config = config if config else SpineAimConfig.new()
	_current_pitch = 0.0
	if is_instance_valid(_modifier):
		_modifier.queue_free()
	_modifier = null

	if not is_instance_valid(_skeleton):
		GlobalLogger.warn("SpineAim", "未找到 Skeleton3D，脊柱视角旋转已禁用")
		return

	_modifier = SpineAimModifier.new()
	_modifier.name = "SpineAimModifier"
	_skeleton.add_child(_modifier)
	_modifier.setup(_player, _config)
	_move_before_first_ik_modifier()

	if _modifier.get_valid_bone_count() == 0:
		GlobalLogger.warn("SpineAim", "未找到配置中的脊柱骨骼，脊柱视角旋转已禁用")
	else:
		GlobalLogger.info("SpineAim", "脊柱视角旋转已启用，骨骼数=%d" % _modifier.get_valid_bone_count())


func process_aim(delta: float, enabled: bool = true) -> void:
	if not _modifier:
		return

	_modifier.apply_aim = enabled
	if not enabled:
		_current_pitch = 0.0
		_current_yaw = 0.0
		_modifier.pitch_radians = 0.0
		_modifier.yaw_radians = 0.0
		return
	var view_pitch := 0.0
	if is_instance_valid(_camera_controller):
		view_pitch = _camera_controller.get_vertical_angle()

	var min_pitch := -deg_to_rad(_config.max_look_down_degrees)
	var max_pitch := deg_to_rad(_config.max_look_up_degrees)
	var target_pitch := clampf(view_pitch, min_pitch, max_pitch) * _config.influence
	var blend := 1.0 - exp(-maxf(_config.response_speed, 0.0) * maxf(delta, 0.0))
	_current_pitch = lerpf(_current_pitch, target_pitch, blend)
	var target_yaw := 0.0
	if is_instance_valid(_camera_controller):
		var max_yaw := deg_to_rad(40.0)
		if _player.player_config and _player.player_config.movement_config:
			var movement_config := _player.player_config.movement_config
			max_yaw = deg_to_rad(movement_config.turn_trigger_angle_degrees)
		target_yaw = clampf(_camera_controller.get_body_yaw_offset(), -max_yaw, max_yaw) * _config.influence
	_current_yaw = lerpf(_current_yaw, target_yaw, blend)
	_modifier.pitch_radians = _current_pitch
	_modifier.yaw_radians = _current_yaw


func _move_before_first_ik_modifier() -> void:
	if not _modifier or not _skeleton:
		return
	for child in _skeleton.get_children():
		if child is TwoBoneIK3D:
			_skeleton.move_child(_modifier, child.get_index())
			return


class SpineAimModifier extends SkeletonModifier3D:
	var apply_aim: bool = true
	var pitch_radians: float = 0.0
	var yaw_radians: float = 0.0

	var _player: BasePlayer
	var _bone_indices: Array[int] = []
	var _bone_weights: Array[float] = []


	func setup(player: BasePlayer, config: SpineAimConfig) -> void:
		_player = player
		var skeleton := get_skeleton()
		if not skeleton:
			return

		var weight_sum := 0.0
		for i in config.bone_names.size():
			var bone_idx := skeleton.find_bone(config.bone_names[i])
			if bone_idx == -1:
				continue
			var weight := config.bone_weights[i] if i < config.bone_weights.size() else 1.0
			weight = maxf(weight, 0.0)
			if weight <= 0.0:
				continue
			_bone_indices.append(bone_idx)
			_bone_weights.append(weight)
			weight_sum += weight

		if weight_sum > 0.0:
			for i in _bone_weights.size():
				_bone_weights[i] /= weight_sum


	func get_valid_bone_count() -> int:
		return _bone_indices.size()


	func _process_modification() -> void:
		if not apply_aim or (absf(pitch_radians) < 0.00001 and absf(yaw_radians) < 0.00001) or not is_instance_valid(_player):
			return
		var skeleton := get_skeleton()
		if not skeleton:
			return

		# 视角俯仰围绕玩家世界空间的右轴旋转。转换到 Skeleton 空间后，
		# 即使模型根节点有 180 度朝向修正，抬头/低头方向仍保持正确。
		var skeleton_basis := skeleton.global_transform.basis.orthonormalized()
		var world_right := _player.global_transform.basis.orthonormalized().x
		var skeleton_right := (skeleton_basis.inverse() * world_right).normalized()
		var world_up := _player.global_transform.basis.orthonormalized().y
		var skeleton_up := (skeleton_basis.inverse() * world_up).normalized()

		for i in _bone_indices.size():
			_apply_global_rotation(
				skeleton,
				_bone_indices[i],
				Quaternion(skeleton_up, yaw_radians * _bone_weights[i]) * Quaternion(skeleton_right, pitch_radians * _bone_weights[i])
			)


	func _apply_global_rotation(skeleton: Skeleton3D, bone_idx: int, global_extra: Quaternion) -> void:
		var parent_idx := skeleton.get_bone_parent(bone_idx)
		var parent_basis := Basis.IDENTITY
		if parent_idx != -1:
			parent_basis = skeleton.get_bone_global_pose(parent_idx).basis.orthonormalized()

		var rest_basis := skeleton.get_bone_rest(bone_idx).basis.orthonormalized()
		var parent_extra := Quaternion(parent_basis).inverse() * global_extra * Quaternion(parent_basis)
		var local_extra := Quaternion(rest_basis).inverse() * parent_extra * Quaternion(rest_basis)
		var current_rotation := skeleton.get_bone_pose_rotation(bone_idx)
		skeleton.set_bone_pose_rotation(bone_idx, (local_extra * current_rotation).normalized())
