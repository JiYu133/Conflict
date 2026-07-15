class_name HitboxConfig
extends Resource

# ============================================================
# 碰撞体配置资源
# 功能：定义各身体部位的碰撞体形状参数
# 用法：在 Godot 编辑器中创建 .tres 资源，调整参数，
#       由 HealthSystem 读取并创建碰撞体
# ============================================================

## 镜像方向枚举
enum MirrorMode {
	NONE,           ## 不镜像，使用各自独立配置
	LEFT_TO_RIGHT,  ## 左→右（右侧使用左侧参数）
	RIGHT_TO_LEFT   ## 右→左（左侧使用右侧参数）
}

@export_group("镜像配置 / Mirror Settings")
## 手臂镜像模式
@export var arm_mirror_mode: MirrorMode = MirrorMode.LEFT_TO_RIGHT
## 腿部镜像模式
@export var leg_mirror_mode: MirrorMode = MirrorMode.LEFT_TO_RIGHT

@export_group("头部 / Head")
## 头部碰撞球体半径（米）
@export_range(0.05, 0.3, 0.01) var head_radius: float = 0.12
## 头部碰撞体局部位置偏移（相对骨骼原点）
@export var head_offset: Vector3 = Vector3(0, 0.1, 0)
## 头部碰撞体局部旋转（欧拉角，度）
@export var head_rotation: Vector3 = Vector3.ZERO

@export_group("躯干 / Torso")
@export_subgroup("胸部 / Chest (Spine2)")
## 胸部胶囊体半径（米）
@export_range(0.1, 0.4, 0.01) var chest_radius: float = 0.18
## 胸部胶囊体高度（米）
@export_range(0.2, 0.8, 0.01) var chest_height: float = 0.35
## 胸部碰撞体局部位置偏移
@export var chest_offset: Vector3 = Vector3(0, 0, 0)
## 胸部碰撞体局部旋转（欧拉角，度）
@export var chest_rotation: Vector3 = Vector3.ZERO

@export_subgroup("腹部 / Abdomen (Spine1)")
## 腹部胶囊体半径（米）
@export_range(0.1, 0.4, 0.01) var abdomen_radius: float = 0.16
## 腹部胶囊体高度（米）
@export_range(0.2, 0.8, 0.01) var abdomen_height: float = 0.3
## 腹部碰撞体局部位置偏移
@export var abdomen_offset: Vector3 = Vector3(0, 0, 0)
## 腹部碰撞体局部旋转（欧拉角，度）
@export var abdomen_rotation: Vector3 = Vector3.ZERO

@export_group("左臂 / Left Arm")
@export_subgroup("上臂 / Upper Arm")
## 左上臂胶囊体半径（米）
@export_range(0.03, 0.15, 0.01) var left_upper_arm_radius: float = 0.06
## 左上臂胶囊体高度（米）
@export_range(0.1, 0.4, 0.01) var left_upper_arm_height: float = 0.25
## 左上臂局部位置偏移
@export var left_upper_arm_offset: Vector3 = Vector3(0, -0.12, 0)
## 左上臂局部旋转（欧拉角，度）
@export var left_upper_arm_rotation: Vector3 = Vector3.ZERO

@export_subgroup("前臂 / Forearm")
## 左前臂胶囊体半径（米）
@export_range(0.03, 0.15, 0.01) var left_forearm_radius: float = 0.05
## 左前臂胶囊体高度（米）
@export_range(0.1, 0.4, 0.01) var left_forearm_height: float = 0.25
## 左前臂局部位置偏移
@export var left_forearm_offset: Vector3 = Vector3(0, -0.12, 0)
## 左前臂局部旋转（欧拉角，度）
@export var left_forearm_rotation: Vector3 = Vector3.ZERO

@export_group("右臂 / Right Arm")
@export_subgroup("上臂 / Upper Arm")
## 右上臂胶囊体半径（米）
@export_range(0.03, 0.15, 0.01) var right_upper_arm_radius: float = 0.06
## 右上臂胶囊体高度（米）
@export_range(0.1, 0.4, 0.01) var right_upper_arm_height: float = 0.25
## 右上臂局部位置偏移
@export var right_upper_arm_offset: Vector3 = Vector3(0, -0.12, 0)
## 右上臂局部旋转（欧拉角，度）
@export var right_upper_arm_rotation: Vector3 = Vector3.ZERO

@export_subgroup("前臂 / Forearm")
## 右前臂胶囊体半径（米）
@export_range(0.03, 0.15, 0.01) var right_forearm_radius: float = 0.05
## 右前臂胶囊体高度（米）
@export_range(0.1, 0.4, 0.01) var right_forearm_height: float = 0.25
## 右前臂局部位置偏移
@export var right_forearm_offset: Vector3 = Vector3(0, -0.12, 0)
## 右前臂局部旋转（欧拉角，度）
@export var right_forearm_rotation: Vector3 = Vector3.ZERO

@export_group("左腿 / Left Leg")
@export_subgroup("大腿 / Thigh")
## 左大腿胶囊体半径（米）
@export_range(0.05, 0.2, 0.01) var left_thigh_radius: float = 0.09
## 左大腿胶囊体高度（米）
@export_range(0.2, 0.6, 0.01) var left_thigh_height: float = 0.4
## 左大腿局部位置偏移
@export var left_thigh_offset: Vector3 = Vector3(0, -0.2, 0)
## 左大腿局部旋转（欧拉角，度）
@export var left_thigh_rotation: Vector3 = Vector3.ZERO

@export_subgroup("小腿 / Calf")
## 左小腿胶囊体半径（米）
@export_range(0.04, 0.15, 0.01) var left_calf_radius: float = 0.07
## 左小腿胶囊体高度（米）
@export_range(0.2, 0.6, 0.01) var left_calf_height: float = 0.4
## 左小腿局部位置偏移
@export var left_calf_offset: Vector3 = Vector3(0, -0.2, 0)
## 左小腿局部旋转（欧拉角，度）
@export var left_calf_rotation: Vector3 = Vector3.ZERO

@export_group("右腿 / Right Leg")
@export_subgroup("大腿 / Thigh")
## 右大腿胶囊体半径（米）
@export_range(0.05, 0.2, 0.01) var right_thigh_radius: float = 0.09
## 右大腿胶囊体高度（米）
@export_range(0.2, 0.6, 0.01) var right_thigh_height: float = 0.4
## 右大腿局部位置偏移
@export var right_thigh_offset: Vector3 = Vector3(0, -0.2, 0)
## 右大腿局部旋转（欧拉角，度）
@export var right_thigh_rotation: Vector3 = Vector3.ZERO

@export_subgroup("小腿 / Calf")
## 右小腿胶囊体半径（米）
@export_range(0.04, 0.15, 0.01) var right_calf_radius: float = 0.07
## 右小腿胶囊体高度（米）
@export_range(0.2, 0.6, 0.01) var right_calf_height: float = 0.4
## 右小腿局部位置偏移
@export var right_calf_offset: Vector3 = Vector3(0, -0.2, 0)
## 右小腿局部旋转（欧拉角，度）
@export var right_calf_rotation: Vector3 = Vector3.ZERO

@export_group("调试 / Debug")
## 调试网格颜色
@export var debug_color: Color = Color(0.0, 1.0, 0.0, 0.3)


## 根据部位和骨骼名称返回合适的碰撞形状
func create_shape_for_bone(bone_name: String, part: MedicalEnums.BodyPartId) -> Shape3D:
	match bone_name:
		"mixamorig_Head":
			var sphere := SphereShape3D.new()
			sphere.radius = head_radius
			return sphere
		"mixamorig_Spine2":
			var capsule := CapsuleShape3D.new()
			capsule.radius = chest_radius
			capsule.height = chest_height
			return capsule
		"mixamorig_Spine1":
			var capsule := CapsuleShape3D.new()
			capsule.radius = abdomen_radius
			capsule.height = abdomen_height
			return capsule
		"mixamorig_LeftArm":
			var capsule := CapsuleShape3D.new()
			# 镜像：如果是右→左模式，使用右臂参数
			if arm_mirror_mode == MirrorMode.RIGHT_TO_LEFT:
				capsule.radius = right_upper_arm_radius
				capsule.height = right_upper_arm_height
			else:
				capsule.radius = left_upper_arm_radius
				capsule.height = left_upper_arm_height
			return capsule
		"mixamorig_LeftForeArm":
			var capsule := CapsuleShape3D.new()
			if arm_mirror_mode == MirrorMode.RIGHT_TO_LEFT:
				capsule.radius = right_forearm_radius
				capsule.height = right_forearm_height
			else:
				capsule.radius = left_forearm_radius
				capsule.height = left_forearm_height
			return capsule
		"mixamorig_RightArm":
			var capsule := CapsuleShape3D.new()
			# 镜像：如果是左→右模式，使用左臂参数
			if arm_mirror_mode == MirrorMode.LEFT_TO_RIGHT:
				capsule.radius = left_upper_arm_radius
				capsule.height = left_upper_arm_height
			else:
				capsule.radius = right_upper_arm_radius
				capsule.height = right_upper_arm_height
			return capsule
		"mixamorig_RightForeArm":
			var capsule := CapsuleShape3D.new()
			if arm_mirror_mode == MirrorMode.LEFT_TO_RIGHT:
				capsule.radius = left_forearm_radius
				capsule.height = left_forearm_height
			else:
				capsule.radius = right_forearm_radius
				capsule.height = right_forearm_height
			return capsule
		"mixamorig_LeftUpLeg":
			var capsule := CapsuleShape3D.new()
			if leg_mirror_mode == MirrorMode.RIGHT_TO_LEFT:
				capsule.radius = right_thigh_radius
				capsule.height = right_thigh_height
			else:
				capsule.radius = left_thigh_radius
				capsule.height = left_thigh_height
			return capsule
		"mixamorig_LeftLeg":
			var capsule := CapsuleShape3D.new()
			if leg_mirror_mode == MirrorMode.RIGHT_TO_LEFT:
				capsule.radius = right_calf_radius
				capsule.height = right_calf_height
			else:
				capsule.radius = left_calf_radius
				capsule.height = left_calf_height
			return capsule
		"mixamorig_RightUpLeg":
			var capsule := CapsuleShape3D.new()
			if leg_mirror_mode == MirrorMode.LEFT_TO_RIGHT:
				capsule.radius = left_thigh_radius
				capsule.height = left_thigh_height
			else:
				capsule.radius = right_thigh_radius
				capsule.height = right_thigh_height
			return capsule
		"mixamorig_RightLeg":
			var capsule := CapsuleShape3D.new()
			if leg_mirror_mode == MirrorMode.LEFT_TO_RIGHT:
				capsule.radius = left_calf_radius
				capsule.height = left_calf_height
			else:
				capsule.radius = right_calf_radius
				capsule.height = right_calf_height
			return capsule
		_:
			var box := BoxShape3D.new()
			box.size = Vector3(0.2, 0.2, 0.2)
			return box


## 根据骨骼名称返回局部位置偏移
func get_offset_for_bone(bone_name: String) -> Vector3:
	match bone_name:
		"mixamorig_Head": return head_offset
		"mixamorig_Spine2": return chest_offset
		"mixamorig_Spine1": return abdomen_offset
		"mixamorig_LeftArm":
			return right_upper_arm_offset if arm_mirror_mode == MirrorMode.RIGHT_TO_LEFT else left_upper_arm_offset
		"mixamorig_LeftForeArm":
			return right_forearm_offset if arm_mirror_mode == MirrorMode.RIGHT_TO_LEFT else left_forearm_offset
		"mixamorig_RightArm":
			return left_upper_arm_offset if arm_mirror_mode == MirrorMode.LEFT_TO_RIGHT else right_upper_arm_offset
		"mixamorig_RightForeArm":
			return left_forearm_offset if arm_mirror_mode == MirrorMode.LEFT_TO_RIGHT else right_forearm_offset
		"mixamorig_LeftUpLeg":
			return right_thigh_offset if leg_mirror_mode == MirrorMode.RIGHT_TO_LEFT else left_thigh_offset
		"mixamorig_LeftLeg":
			return right_calf_offset if leg_mirror_mode == MirrorMode.RIGHT_TO_LEFT else left_calf_offset
		"mixamorig_RightUpLeg":
			return left_thigh_offset if leg_mirror_mode == MirrorMode.LEFT_TO_RIGHT else right_thigh_offset
		"mixamorig_RightLeg":
			return left_calf_offset if leg_mirror_mode == MirrorMode.LEFT_TO_RIGHT else right_calf_offset
		_: return Vector3.ZERO


## 根据骨骼名称返回局部旋转（欧拉角，度）
func get_rotation_for_bone(bone_name: String) -> Vector3:
	match bone_name:
		"mixamorig_Head": return head_rotation
		"mixamorig_Spine2": return chest_rotation
		"mixamorig_Spine1": return abdomen_rotation
		"mixamorig_LeftArm":
			if arm_mirror_mode == MirrorMode.RIGHT_TO_LEFT:
				# 右→左镜像：Y和Z轴取反
				return Vector3(right_upper_arm_rotation.x, -right_upper_arm_rotation.y, -right_upper_arm_rotation.z)
			return left_upper_arm_rotation
		"mixamorig_LeftForeArm":
			if arm_mirror_mode == MirrorMode.RIGHT_TO_LEFT:
				return Vector3(right_forearm_rotation.x, -right_forearm_rotation.y, -right_forearm_rotation.z)
			return left_forearm_rotation
		"mixamorig_RightArm":
			if arm_mirror_mode == MirrorMode.LEFT_TO_RIGHT:
				# 左→右镜像：Y和Z轴取反
				return Vector3(left_upper_arm_rotation.x, -left_upper_arm_rotation.y, -left_upper_arm_rotation.z)
			return right_upper_arm_rotation
		"mixamorig_RightForeArm":
			if arm_mirror_mode == MirrorMode.LEFT_TO_RIGHT:
				return Vector3(left_forearm_rotation.x, -left_forearm_rotation.y, -left_forearm_rotation.z)
			return right_forearm_rotation
		"mixamorig_LeftUpLeg":
			if leg_mirror_mode == MirrorMode.RIGHT_TO_LEFT:
				return Vector3(right_thigh_rotation.x, -right_thigh_rotation.y, -right_thigh_rotation.z)
			return left_thigh_rotation
		"mixamorig_LeftLeg":
			if leg_mirror_mode == MirrorMode.RIGHT_TO_LEFT:
				return Vector3(right_calf_rotation.x, -right_calf_rotation.y, -right_calf_rotation.z)
			return left_calf_rotation
		"mixamorig_RightUpLeg":
			if leg_mirror_mode == MirrorMode.LEFT_TO_RIGHT:
				return Vector3(left_thigh_rotation.x, -left_thigh_rotation.y, -left_thigh_rotation.z)
			return right_thigh_rotation
		"mixamorig_RightLeg":
			if leg_mirror_mode == MirrorMode.LEFT_TO_RIGHT:
				return Vector3(left_calf_rotation.x, -left_calf_rotation.y, -left_calf_rotation.z)
			return right_calf_rotation
		_: return Vector3.ZERO
