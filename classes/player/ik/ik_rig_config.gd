class_name IKRigConfig
extends Resource

# ============================================================
# 玩家 IK 配置（双臂握枪 + 双脚贴地）
# 赋值给 PlayerConfig.ik_config。骨骼链按「上 → 中 → 末端」填写。
# ============================================================


# ── 双臂 ─────────────────────────────────────────────────────
@export_group("双臂")

## 左臂（扶枪手）骨骼链：上臂、前臂、手腕。
@export var left_arm_bones: PackedStringArray = PackedStringArray([
	"mixamorig_LeftArm", "mixamorig_LeftForeArm", "mixamorig_LeftHand",
])

## 右臂（扳机手）骨骼链：上臂、前臂、手腕。
@export var right_arm_bones: PackedStringArray = PackedStringArray([
	"mixamorig_RightArm", "mixamorig_RightForeArm", "mixamorig_RightHand",
])

## 武器上左手腕目标 Marker 的名称。它的位置与朝向就是左手腕骨骼的位置与朝向：
## 移动它移动手，旋转它旋转手。
@export var support_hand_marker: StringName = &"LeftHandWristTarget"

## 冲刺时双臂 IK 的权重（其余持枪状态均为 1，手始终在枪上）。
@export_range(0.0, 1.0) var sprint_arm_weight: float = 0.15

## 双臂 IK 权重切换的过渡时间（秒）。
@export_range(0.0, 0.5) var arm_blend_time: float = 0.12

## 左手目标超过手臂长度的该比例时，沿枪管轴向枪托滑动（手留在护木上）。
@export_range(0.8, 1.0) var max_reach_ratio: float = 0.96

## 左手沿护木向枪托滑动的最大距离（米）。
@export_range(0.0, 0.3) var support_hand_max_slide: float = 0.12

## 握枪手指姿态的参考动画，取第 0 帧的手指旋转。部分片段（如 idle）没有手指轨道，
## 不套用时手指会停在平直的静止姿态。留空则手指完全跟随动画。
@export var grip_pose_animation: StringName = &"crouch_idle/mixamo_com"


# ── 双脚 ─────────────────────────────────────────────────────
@export_group("双脚")

## 左腿骨骼链：大腿、小腿、脚踝。
@export var left_leg_bones: PackedStringArray = PackedStringArray([
	"mixamorig_LeftUpLeg", "mixamorig_LeftLeg", "mixamorig_LeftFoot",
])

## 右腿骨骼链：大腿、小腿、脚踝。
@export var right_leg_bones: PackedStringArray = PackedStringArray([
	"mixamorig_RightUpLeg", "mixamorig_RightLeg", "mixamorig_RightFoot",
])

## 脚比支撑脚高出多少开始释放（米）。整体蹲低不算抬脚。
@export var plant_lift_start: float = 0.035

## 脚比支撑脚高出多少完全释放（米）。
@export var plant_lift_end: float = 0.12

## 脚部贴地权重的变化速度（每秒）。
@export var leg_blend_speed: float = 8.0

## 脚部射线从动画脚踝向上 / 向下的长度（米）。
@export var foot_ray_above: float = 0.3
@export var foot_ray_below: float = 0.4

## 着地脚超出腿长的该比例时下沉骨盆。
@export_range(0.8, 1.0) var max_leg_extension: float = 0.99

## 骨盆最大下沉量（米）。
@export var max_pelvis_drop: float = 0.2

## 骨盆下沉 / 回升的响应速度：快速下沉让新落地的脚立刻踩实，缓慢回升避免镜头随步伐起伏。
@export var pelvis_sink_response: float = 30.0
@export var pelvis_rise_response: float = 4.0

## 脚踝贴合地面法线的最大倾斜角（度）。
@export_range(0.0, 60.0) var max_ankle_tilt_degrees: float = 25.0
