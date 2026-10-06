class_name ArmIK
extends RefCounted

# ============================================================
# 单条手臂：把手腕放到武器上的目标位置与朝向，并把手指摆成握枪姿势。
#
# 每帧（由 IKRig 在手臂阶段调用）：
#   1. IKRig 写入 target（世界空间的手腕变换）与 weight
#   2. solve()：肘部朝向动画里的弯曲方向 → 两骨求解 → 手腕转到目标朝向 → 手指握枪
# ============================================================

var upper: int = -1   # 上臂（IK 根）
var lower: int = -1   # 前臂
var hand: int = -1    # 手腕

## 本帧手腕目标（世界空间）。has_target 为 false 时这条手臂不做 IK。
var target: Transform3D = Transform3D.IDENTITY
var has_target: bool = false
## 本帧混合权重（0 = 完全动画，1 = 手完全在目标上）。
var weight: float = 0.0

var _fingers: Array[int] = []
var _finger_grip: Array[Quaternion] = []


func bind(skeleton: Skeleton3D, bone_names: PackedStringArray) -> bool:
	clear()
	if bone_names.size() != 3:
		return false
	upper = skeleton.find_bone(bone_names[0])
	lower = skeleton.find_bone(bone_names[1])
	hand = skeleton.find_bone(bone_names[2])
	var chained := upper >= 0 and lower >= 0 and hand >= 0 \
		and skeleton.get_bone_parent(lower) == upper and skeleton.get_bone_parent(hand) == lower
	if not chained:
		clear()
	return chained


func clear() -> void:
	upper = -1
	lower = -1
	hand = -1
	has_target = false
	weight = 0.0
	_fingers.clear()
	_finger_grip.clear()


func is_bound() -> bool:
	return hand >= 0


## 从参考动画第 0 帧读取这只手所有手指骨骼的局部旋转。
func sample_grip_pose(skeleton: Skeleton3D, animation: Animation) -> void:
	_fingers.clear()
	_finger_grip.clear()
	if not is_bound() or not animation:
		return
	var rotation_tracks := {}
	for track in animation.get_track_count():
		if animation.track_get_type(track) == Animation.TYPE_ROTATION_3D:
			rotation_tracks[animation.track_get_path(track).get_concatenated_subnames()] = track
	var pending: Array[int] = []
	pending.append_array(skeleton.get_bone_children(hand))
	while not pending.is_empty():
		var bone: int = pending.pop_back()
		pending.append_array(skeleton.get_bone_children(bone))
		var track: int = rotation_tracks.get(skeleton.get_bone_name(bone), -1)
		if track >= 0:
			_fingers.append(bone)
			_finger_grip.append(animation.rotation_track_interpolate(track, 0.0))


func finger_count() -> int:
	return _fingers.size()


## 上臂 + 前臂长度（世界空间，米）。
func length(skeleton: Skeleton3D) -> float:
	var shoulder := TwoBoneIK.bone_world_position(skeleton, upper)
	var elbow := TwoBoneIK.bone_world_position(skeleton, lower)
	return shoulder.distance_to(elbow) + elbow.distance_to(TwoBoneIK.bone_world_position(skeleton, hand))


## torso_down / outward 用于动画手臂接近伸直、无法判断弯曲方向时的肘部朝向。
func solve(skeleton: Skeleton3D, torso_down: Vector3, outward: Vector3) -> void:
	if not is_bound() or not has_target or weight <= 0.0:
		return
	var shoulder := TwoBoneIK.bone_world_position(skeleton, upper)
	var elbow := TwoBoneIK.bone_world_position(skeleton, lower)
	var wrist := TwoBoneIK.bone_world_position(skeleton, hand)
	var goal := wrist.lerp(target.origin, weight)
	TwoBoneIK.solve(skeleton, upper, lower, hand, goal, _elbow_pole(shoulder, elbow, wrist, goal, torso_down, outward))
	TwoBoneIK.blend_world_rotation(skeleton, hand, target.basis, weight)
	for i in _fingers.size():
		var bone := _fingers[i]
		var current := skeleton.get_bone_pose_rotation(bone)
		skeleton.set_bone_pose_rotation(bone, current.slerp(_finger_grip[i], weight).normalized())


## 肘部朝向动画手臂当前的弯曲方向，因此跟随瞄准、蹲伏与趴下，保留动画的手臂特征。
func _elbow_pole(shoulder: Vector3, elbow: Vector3, wrist: Vector3, goal: Vector3, torso_down: Vector3, outward: Vector3) -> Vector3:
	var arm := wrist - shoulder
	var along := clampf((elbow - shoulder).dot(arm) / maxf(arm.length_squared(), 0.000001), 0.0, 1.0)
	var bend := elbow - (shoulder + arm * along)
	var direction := (torso_down * 0.85 + outward * 0.5).normalized()
	var confidence := smoothstep(0.01, 0.04, bend.length())
	if confidence > 0.0:
		direction = direction.lerp(bend.normalized(), confidence).normalized()
	var arm_length := shoulder.distance_to(elbow) + elbow.distance_to(wrist)
	return (shoulder + goal) * 0.5 + direction * arm_length
