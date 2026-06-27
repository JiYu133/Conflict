class_name CameraConfig
extends Resource

# ============================================================
# 摄像机配置资源
# 功能：定义第一人称摄像机的全部视角与程序化动画参数，
#       包括 FOV、鼠标灵敏度、头部摆动、武器晃动、
#       速度倾斜、落地冲击弹簧和呼吸摆动。
# 用法：在 Godot 编辑器中创建 .tres 资源，填入具体数值，
#       赋值给 PlayerConfig.camera_config，
#       由 PlayerCameraController 在初始化时读取。
# ============================================================

# 视角控制 ─────────────────────────────────────────────────
@export_group("视角控制")
@export var fov: float = 90.0
## 第一人称视野角度，单位：度（FOV，Field of View）
@export var mouse_sensitivity: float = 0.003
## 鼠标灵敏度，单位：弧度/像素。约 0.003 ≈ 中低灵敏度
@export var max_vertical_angle: float = 1.4
## 垂直视角最大角度，单位：弧度。1.4 ≈ 80 度
@export var max_speed_reference: float = 3.5
## 用于 bob/tilt 振幅归一化的参考速度（m/s），与 PlayerConfig.run_speed 保持一致
@export var walk_speed_reference: float = 1.5
## 用于 bob 频率切换的步行速度阈值（m/s），与 PlayerConfig.walk_speed 保持一致

# 头部摆动 ─────────────────────────────────────────────────
@export_subgroup("头部摆动")
@export var bob_enabled: bool = true
## 是否启用头部摆动效果
@export var bob_frequency_walk: float = 1.8
## 走路摆动频率（Hz），与步频保持一致
@export var bob_frequency_run: float = 2.5
## 奔跑摆动频率（Hz）
@export var bob_amplitude_vertical: float = 0.015
## 垂直摆动幅度（m）。负重士兵约 0.015–0.02 m
@export var bob_amplitude_horizontal: float = 0.008
## 水平摆动幅度（m）。约为垂直幅度的一半，产生 figure-8 轨迹
@export var bob_return_speed: float = 8.0
## 停止移动后摆动归零的插值速度

# 武器晃动 ─────────────────────────────────────────────────
@export_subgroup("武器晃动")
@export var sway_enabled: bool = true
## 是否启用武器晃动效果
@export var sway_look_amount: float = 0.015
## 鼠标转动时武器偏移量（弧度）。数值越大晃动越明显
@export var sway_move_amount: float = 0.06
## 移动时武器偏移量（m）。模拟持枪重量感
@export var sway_speed: float = 6.0
## 武器归位插值速度。数值越大响应越灵敏

# 速度倾斜 ─────────────────────────────────────────────────
@export_subgroup("速度倾斜")
@export var tilt_enabled: bool = true
## 是否启用速度倾斜效果
@export var tilt_max_angle: float = 0.04
## 最大倾斜角度（弧度）。0.04 ≈ 2.3°，轻微可见；0.08 ≈ 4.6°，明显
@export var tilt_speed: float = 6.0
## 倾斜归位的插值速度。值越大响应越灵敏

# 落地冲击 ─────────────────────────────────────────────────
@export_subgroup("落地冲击")
@export var land_impact_enabled: bool = true
## 是否启用落地冲击效果
@export var land_impact_impulse: float = 0.04
## 落地时给摄像机位置弹簧施加的初速度（m/s）。数值越大画面下沉越明显
@export var land_impact_stiffness: float = 180.0
## 落地弹簧刚度
@export var land_impact_damping: float = 24.0
## 落地弹簧阻尼。临界阻尼 ≈ 2*sqrt(stiffness)，约 26.8。24 接近临界，回弹一次即止
@export var jump_lift_impulse: float = 0.02
## 起跳时给摄像机施加的上抬初速度（m/s）
@export var land_pitch_impulse: float = 0.06
## 落地时给摄像机 pitch 弹簧施加的前点冲量（弧度/s）。数值越大头部前点越明显
@export var land_pitch_stiffness: float = 200.0
## pitch 弹簧刚度
@export var land_pitch_damping: float = 26.0
## pitch 弹簧阻尼。临界阻尼 ≈ 2*sqrt(stiffness)，约 28.3。26 接近临界，俯仰一次即止
@export var jump_pitch_impulse: float = 0.025
## 起跳时给摄像机 pitch 弹簧施加的后仰冲量（弧度/s）
@export var land_impact_velocity_scale: float = 0.12
## 落地冲击按下落速度缩放的系数。下落越快动静越大，设为 0 则固定幅度

# 呼吸晃动 ─────────────────────────────────────────────────
@export_subgroup("呼吸晃动")
@export var breathe_enabled: bool = false
## 是否启用呼吸效果（静止或低速时有效）。默认关闭，开启后站立时有细微上下漂移
@export var breathe_frequency: float = 0.3
## 呼吸频率（Hz），约 18 次/分钟，静息呼吸
@export var breathe_amplitude_vertical: float = 0.004
## 呼吸垂直振幅（m）
@export var breathe_amplitude_horizontal: float = 0.0015
## 呼吸水平漂移振幅（m）
@export var breathe_max_speed: float = 0.5
## 超过此水平速度（m/s）时呼吸效果完全淡出，平滑过渡到步态摆动
