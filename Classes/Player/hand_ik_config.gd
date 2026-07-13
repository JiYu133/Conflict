class_name HandIKConfig
extends Resource

# ============================================================
# 左手 IK 配置资源
#
# 用法：
#   1. 在编辑器中右键 → New Resource → 选择 HandIKConfig
#   2. 将资源赋值给 PlayerConfig.hand_ik_config
#   3. HandIKController 在 setup() 时读取此配置
#
# 每把武器可以通过 WeaponConfig.left_hand_ik_weight 覆盖混合强度，
# 其余参数对所有武器生效。
# ============================================================


# ── 骨骼链 ──────────────────────────────────────────────────
@export_group("骨骼链")

## 左臂 IK 骨骼链名称列表（从肩膀到手腕，顺序不能颠倒）
## 使用 Mixamo 标准骨骼命名。换模型时若骨骼名不同，在此修改。
## 链长至少 3 节（肩-臂-手），缺任意一节 IK 将不工作。
@export var bone_chain: Array[String] = [
	"mixamorig_LeftShoulder",   # 肩膀：IK 链起点，提供肩膀自然抬起
	"mixamorig_LeftArm",        # 上臂
	"mixamorig_LeftForeArm",    # 前臂：与手腕做 roll 对齐
	"mixamorig_LeftHand",       # 手腕：IK 链终点，朝向由 LeftHandGrip Marker3D 决定
]


# ── FABRIK 求解器 ────────────────────────────────────────────
@export_group("FABRIK 求解器")

## 每帧 FABRIK 迭代次数
## 越高越精确，但消耗更多 CPU。4~8 对大多数情况够用。
## 目标距离手臂链长时（手臂快伸直），增大此值可减少抖动。
@export_range(1, 20) var iterations: int = 6

## 收敛阈值（米）
## 末端与目标距离小于此值时提前退出迭代，节省计算。
## 调小可提高精度，调大可节省性能。
@export_range(0.0001, 0.01, 0.0001) var threshold: float = 0.0005


# ── 肘部方向（Pole Vector） ──────────────────────────────────
@export_group("肘部方向")

## 肘部偏向方向（骨骼局部空间）
## 控制前臂弯曲时肘部朝哪个方向，避免肘部随机翻转。
##
## 调整参考：
##   Y = -1.0          → 肘部朝下（自然垂臂持枪）
##   Y = -1.0, Z = 0.5 → 肘部朝下偏后（端平持枪）
##   Y = -1.0, Z =-0.5 → 肘部朝下偏前
##   X = -1.0          → 肘部朝左外侧
##
## 最终效果还受 pole_influence 影响。
@export var pole_vector: Vector3 = Vector3(0.0, -1.0, 0.5)

## Pole vector 影响强度（0~1）
## 0 = 完全不约束肘部方向（肘部自由旋转，可能翻转）
## 1 = 肘部完全对齐 pole_vector 方向
## 0.6 是推荐值：留 40% 给动画自然姿势，避免机械感
@export_range(0.0, 1.0) var pole_influence: float = 0.6


# ── 前臂-手腕对齐 ────────────────────────────────────────────
@export_group("前臂-手腕对齐")

## 前臂与手腕的 roll（扭转）对齐强度（0~1）
## 0 = 前臂 roll 完全由动画决定（可能与手腕朝向不一致，看起来扭折）
## 1 = 前臂 roll 完全对齐手腕（LeftHandGrip 的 Z 轴方向）
## 0.5 是推荐值：前臂和手腕之间有自然过渡而不是硬接
@export_range(0.0, 1.0) var forearm_roll_align: float = 0.5


# ── 混合强度 ─────────────────────────────────────────────────
@export_group("混合强度")

## 全局 IK 混合强度（0~1）
## 0 = 完全使用动画，IK 不生效
## 1 = 完全由 IK 驱动
## 单把武器可在 WeaponConfig.left_hand_ik_weight 中覆盖此值
@export_range(0.0, 1.0) var default_ik_weight: float = 1.0


# ── 肩膀参与度 ──────────────────────────────────────────────
@export_group("肩膀参与度")

## 肩膀骨骼跟随 IK 链的混合权重（0=完全动画驱动，1=完全 IK 修正）
## 推荐 0.2~0.4，只做轻微修正，避免肩膀超伸/撕裂感
@export_range(0.0, 1.0) var shoulder_ik_weight: float = 0.3


# ── 运动状态权重 ─────────────────────────────────────────────
@export_group("运动状态权重")

## 站立/行走时的 IK 权重上限（通常保持 1.0）
@export_range(0.0, 1.0) var walk_ik_weight: float = 1.0

## 奔跑（Run）时的 IK 权重，调低让左手随动画自然摆动（推荐 0.4~0.7）
@export_range(0.0, 1.0) var run_ik_weight: float = 0.6

## 冲刺（Sprint）时的 IK 权重，参考 EFT：冲刺时左手基本放开（推荐 0.0~0.2）
@export_range(0.0, 1.0) var sprint_ik_weight: float = 0.1

## 状态切换时权重平滑过渡时间（秒），参考 EFT 约 0.12~0.15s
@export_range(0.0, 0.5) var weight_blend_time: float = 0.12


# ── 左手本地偏移 ─────────────────────────────────────────────
@export_group("左手本地偏移")

## 在 LeftHandGrip 坐标系中叠加的位置偏移（米），用于微调左手落点
@export var grip_position_offset: Vector3 = Vector3.ZERO

## 在 LeftHandGrip 坐标系中叠加的旋转偏移（度，XYZ 欧拉角），用于微调手腕朝向
@export var grip_rotation_offset: Vector3 = Vector3.ZERO


# ── ADS 姿势 ─────────────────────────────────────────────────
@export_group("ADS 姿势")

## ADS 时的 IK 权重（托腮类武器建议 0.0~0.3，前握把类保持较高值）
@export_range(0.0, 1.0) var ads_ik_weight: float = 0.8

## ADS 时在 LeftHandGrip 基础上叠加的位置偏移（LeftHandGrip 本地空间，米）
@export var ads_grip_offset: Vector3 = Vector3.ZERO

## ADS 时的额外旋转偏移（度，XYZ 欧拉角）
@export var ads_grip_rotation: Vector3 = Vector3.ZERO

## ADS 过渡时间（秒），建议与 CameraConfig.ads_time 保持一致
@export_range(0.0, 0.5) var ads_blend_time: float = 0.25
