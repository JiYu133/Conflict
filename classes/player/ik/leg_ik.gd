class_name LegIK
extends RefCounted

# ============================================================
# 单条腿：让着地的脚贴合不平整地面。
#
# 目标保持动画自身的脚踝高度，只叠加「脚下地面 − 身体下地面」的高度差：
# 平地上目标就是动画脚位置，台阶与斜坡上脚随地面抬高或降低。
# 抬起的脚（比支撑脚高）逐渐释放，不会被钉在地上。
# ============================================================

var upper: int = -1   # 大腿（IK 根）
var lower: int = -1   # 小腿
var foot: int = -1    # 脚踝

## 物理帧缓存的脚下地面。
var hit: Dictionary = {"colliding": false, "point": Vector3.ZERO, "normal": Vector3.UP}
## 本帧贴地权重与世界空间目标。
var blend: float = 0.0
var target: Vector3 = Vector3.ZERO


func bind(skeleton: Skeleton3D, bone_names: PackedStringArray) -> bool:
	clear()
	if bone_names.size() != 3:
		return false
	upper = skeleton.find_bone(bone_names[0])
	lower = skeleton.find_bone(bone_names[1])
	foot = skeleton.find_bone(bone_names[2])
	var chained := upper >= 0 and lower >= 0 and foot >= 0 \
		and skeleton.get_bone_parent(lower) == upper and skeleton.get_bone_parent(foot) == lower
	if not chained:
		clear()
	return chained


func clear() -> void:
	upper = -1
	lower = -1
	foot = -1
	blend = 0.0
	hit = {"colliding": false, "point": Vector3.ZERO, "normal": Vector3.UP}


func is_bound() -> bool:
	return foot >= 0


## 物理帧：从动画脚踝向下检测地面。
func probe(skeleton: Skeleton3D, space: PhysicsDirectSpaceState3D, exclude: Array[RID], config: IKRigConfig) -> void:
	hit = {"colliding": false, "point": Vector3.ZERO, "normal": Vector3.UP}
	if not is_bound():
		return
	var origin := TwoBoneIK.bone_world_position(skeleton, foot)
	var query := PhysicsRayQueryParameters3D.create(
		origin + Vector3.UP * config.foot_ray_above, origin + Vector3.DOWN * config.foot_ray_below, PhysicsLayers.WORLD)
	query.exclude = exclude
	var result := space.intersect_ray(query)
	if not result.is_empty():
		hit = {"colliding": true, "point": result.position, "normal": result.normal}


## 根据动画姿态计算贴地权重与目标。support_y 为两只动画脚中较低者的高度。
func plan(skeleton: Skeleton3D, support_y: float, body_ground_y: float, on_ground: bool, delta: float, config: IKRigConfig) -> void:
	if not is_bound():
		return
	var animated := TwoBoneIK.bone_world_position(skeleton, foot)
	var plant := 1.0 - smoothstep(config.plant_lift_start, config.plant_lift_end, maxf(animated.y - support_y, 0.0))
	var normal: Vector3 = hit.normal
	var contact: bool = on_ground and hit.colliding and normal.y > 0.1
	# 接触时渐入，但上一帧的权重永远不能把已经抬起的脚钉在地上。
	blend = minf(move_toward(blend, plant if contact else 0.0, config.leg_blend_speed * maxf(delta, 0.0)), plant)
	if not contact:
		target = animated
		return
	var point: Vector3 = hit.point
	var ground_y := point.y - (normal.x * (animated.x - point.x) + normal.z * (animated.z - point.z)) / normal.y
	target = animated + Vector3.UP * (ground_y - (body_ground_y if is_finite(body_ground_y) else ground_y))


## 这条腿要够到目标，骨盆需要下沉多少（米，已乘以贴地权重）。
func pelvis_drop_needed(skeleton: Skeleton3D, config: IKRigConfig) -> float:
	if not is_bound() or blend <= 0.0:
		return 0.0
	var hip := TwoBoneIK.bone_world_position(skeleton, upper)
	var knee := TwoBoneIK.bone_world_position(skeleton, lower)
	var ankle := TwoBoneIK.bone_world_position(skeleton, foot)
	var leg_length := hip.distance_to(knee) + knee.distance_to(ankle)
	# 动画本身已经伸直的腿（迈步）不额外下沉。
	var reach := maxf(leg_length * config.max_leg_extension, hip.distance_to(ankle))
	return drop_to_reach(target - hip, reach) * blend


## 让 offset（髋 → 目标）回到 reach 以内所需的最小竖直下沉量。
static func drop_to_reach(offset: Vector3, reach: float) -> float:
	var excess := offset.length_squared() - reach * reach
	if excess <= 0.0:
		return 0.0
	var up := offset.dot(Vector3.UP)
	var discriminant := up * up - excess
	# 横向距离已经超出时下沉也够不到，只下沉到最接近的位置。
	return maxf(-up - sqrt(discriminant) if discriminant >= 0.0 else -up, 0.0)


func solve(skeleton: Skeleton3D, config: IKRigConfig) -> void:
	if not is_bound() or blend <= 0.0:
		return
	var hip := TwoBoneIK.bone_world_position(skeleton, upper)
	var knee := TwoBoneIK.bone_world_position(skeleton, lower)
	var ankle := TwoBoneIK.bone_world_position(skeleton, foot)
	TwoBoneIK.solve(skeleton, upper, lower, foot, ankle.lerp(target, blend), _knee_pole(skeleton, hip, knee, ankle))
	if not hit.colliding:
		return
	var normal: Vector3 = hit.normal
	var axis := Vector3.UP.cross(normal)
	if axis.length_squared() < 0.0001:
		return
	var angle := minf(Vector3.UP.angle_to(normal), deg_to_rad(config.max_ankle_tilt_degrees)) * blend
	TwoBoneIK.apply_world_rotation(skeleton, foot, Quaternion(axis.normalized(), angle))


## 膝盖朝向动画膝盖的弯曲方向；腿伸直时朝角色前方。
func _knee_pole(skeleton: Skeleton3D, hip: Vector3, knee: Vector3, ankle: Vector3) -> Vector3:
	var leg := ankle - hip
	var along := clampf((knee - hip).dot(leg) / maxf(leg.length_squared(), 0.000001), 0.0, 1.0)
	var bend := knee - (hip + leg * along)
	if bend.length_squared() < 0.000001:
		# 模型面朝 Skeleton +Z（根节点再转 180° 对齐玩家前方）。
		bend = skeleton.global_basis.z
	return knee + bend.normalized() * maxf(hip.distance_to(knee) + knee.distance_to(ankle), 0.3)
