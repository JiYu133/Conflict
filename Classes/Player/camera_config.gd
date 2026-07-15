class_name CameraConfig
extends Resource

# ============================================================
# 摄像机配置资源
# 功能：定义第一人称摄像机的全部视角与弹簧稳定器参数。
# 用法：在 Godot 编辑器中创建 .tres 资源，填入具体数值，
#       赋值给 PlayerConfig.camera_config，
#       由 PlayerCameraController 在初始化时读取。
# ============================================================

# 视角控制 ─────────────────────────────────────────────────
@export_group("视角控制")
## 第一人称视野角度（度）/ Field of view in degrees
@export var fov: float = 90.0
## 鼠标灵敏度（弧度/像素），约 0.003 ≈ 中低灵敏度 / Mouse sensitivity in rad/px
@export var mouse_sensitivity: float = 0.003
## 垂直视角最大角度（弧度），1.4 ≈ 80° / Max vertical look angle in radians
@export var max_vertical_angle: float = 1.4

# 弹簧稳定器 ─────────────────────────────────────────────
@export_group("弹簧稳定器")

## 水平（X/Z）弹簧刚度，越大跟踪越快（推荐 300-1000）/ Horizontal spring stiffness
@export var spring_stiffness_h: float = 500.0
## 水平弹簧阻尼（推荐 30-60）/ Horizontal spring damping
@export var spring_damping_h: float = 40.0
## 垂直（Y）弹簧刚度，越小越平滑（推荐 60-200）/ Vertical spring stiffness
@export var spring_stiffness_v: float = 120.0
## 垂直弹簧阻尼（推荐 15-30）/ Vertical spring damping
@export var spring_damping_v: float = 20.0
## ADS 时弹簧刚度倍率（>1 = 瞄准时更硬，晃动更少）/ Stiffness multiplier when ADS
@export var ads_stiffness_multiplier: float = 2.0

# 头显偏移 ─────────────────────────────────────────────
@export_group("头显偏移")
## 头部位置偏移（局部坐标），靠前可减少贴脸感 / Head position offset in local space
@export var head_offset: Vector3 = Vector3(0.07, 0.1, -0.15)
## 布娃娃死亡时摄像机在头骨骼局部空间的偏移，把镜头从骨骼关节移到眼睛位置
@export var ragdoll_eye_offset: Vector3 = Vector3(0.0, 0.06, 0.08)
