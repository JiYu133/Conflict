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
## 第一人称视野角度（度）/ Field of view in degrees
@export var fov: float = 90.0
## 鼠标灵敏度（弧度/像素），约 0.003 ≈ 中低灵敏度 / Mouse sensitivity in rad/px
@export var mouse_sensitivity: float = 0.003
## 垂直视角最大角度（弧度），1.4 ≈ 80° / Max vertical look angle in radians
@export var max_vertical_angle: float = 1.4
## bob/tilt 振幅归一化的参考速度（m/s），与 run_speed 保持一致 / Reference speed for bob/tilt amplitude normalization
@export var max_speed_reference: float = 3.5
## bob 频率切换的步行速度阈值（m/s），与 walk_speed 保持一致 / Walk speed threshold for bob frequency switch
@export var walk_speed_reference: float = 1.5

# 头部摆动 ─────────────────────────────────────────────────
@export_subgroup("头部摆动")
## 是否启用头部摆动效果 / Enable head bob
@export var bob_enabled: bool = true
## 触发头部摆动的最低水平速度（m/s）/ Min horizontal speed to activate head bob
@export var bob_min_speed: float = 0.1
## 奔跑频率触发阈值倍率（相对 walk_speed_reference），1.1 = 超过步行速度 10% 切换 / Multiplier over walk speed to trigger run bob frequency
@export var bob_run_threshold_multiplier: float = 1.1
## 走路摆动频率（Hz）/ Walk bob frequency in Hz
@export var bob_frequency_walk: float = 1.8
## 奔跑摆动频率（Hz）/ Run bob frequency in Hz
@export var bob_frequency_run: float = 2.5
## 垂直摆动幅度（m），约 0.015–0.02 m / Vertical bob amplitude in meters
@export var bob_amplitude_vertical: float = 0.015
## 停止移动后摆动归零的插值速度 / Lerp speed for bob return to zero when stopped
@export var bob_return_speed: float = 8.0

# 武器晃动 ─────────────────────────────────────────────────
@export_subgroup("武器晃动")
## 是否启用武器晃动效果 / Enable weapon sway
@export var sway_enabled: bool = true
## 鼠标横向（左右）驱动的武器横滚晃动量（弧度）/ Mouse X delta scale for weapon roll sway
@export var sway_look_amount: float = 0.015
## 鼠标纵向（上下）驱动的武器俯仰晃动量（弧度）/ Mouse Y delta scale for weapon pitch sway
@export var sway_look_amount_pitch: float = 0.015
## 移动时武器偏移基础量（m），与缩放系数相乘得实际偏移 / Base movement sway amount in meters
@export var sway_move_amount: float = 0.06
## 横向移动偏移缩放系数 / Horizontal movement offset scale factor
@export var sway_move_scale_horizontal: float = 0.01
## 纵向移动偏移缩放系数 / Vertical movement offset scale factor
@export var sway_move_scale_vertical: float = 0.005
## 武器归位插值速度，数值越大响应越灵敏 / Weapon sway return lerp speed
@export var sway_speed: float = 6.0

# 转动延迟 ─────────────────────────────────────────────────
@export_subgroup("转动延迟")
## 是否启用转动延迟效果 / Enable weapon rotation lag on fast turns
@export var weapon_lag_enabled: bool = true
## 超出死区部分的滞后缩放系数 / Scale factor converting mouse delta to lag angle
@export var weapon_lag_scale: float = 0.0015
## 最大滞后角度（弧度），约 0.12 ≈ 7° / Max lag angle in radians
@export var weapon_lag_max: float = 0.12
## 滞后复位速度（lerp speed）/ Speed at which lag returns to zero
@export var weapon_lag_return_speed: float = 5.0

# 速度倾斜 ─────────────────────────────────────────────────
@export_subgroup("速度倾斜")
## 是否启用速度倾斜效果 / Enable velocity tilt
@export var tilt_enabled: bool = true
## 最大倾斜角度（弧度），0.04 ≈ 2.3°，轻微可见 / Max tilt angle in radians
@export var tilt_max_angle: float = 0.04
## 倾斜归位的插值速度 / Tilt return lerp speed
@export var tilt_speed: float = 6.0

# 落地冲击 ─────────────────────────────────────────────────
@export_subgroup("落地冲击")
## 是否启用落地冲击效果 / Enable landing impact spring
@export var land_impact_enabled: bool = true
## 落地时给摄像机位置弹簧施加的初速度（m/s）/ Landing position spring impulse in m/s
@export var land_impact_impulse: float = 0.04
## 落地弹簧刚度 / Landing position spring stiffness
@export var land_impact_stiffness: float = 180.0
## 落地弹簧阻尼，临界阻尼 ≈ 2*sqrt(stiffness) ≈ 26.8 / Landing spring damping
@export var land_impact_damping: float = 24.0
## 起跳时给摄像机施加的上抬初速度（m/s）/ Jump lift spring impulse in m/s
@export var jump_lift_impulse: float = 0.02
## 落地时给摄像机 pitch 弹簧施加的前点冲量（弧度/s）/ Landing pitch spring impulse in rad/s
@export var land_pitch_impulse: float = 0.06
## pitch 弹簧刚度 / Pitch spring stiffness
@export var land_pitch_stiffness: float = 200.0
## pitch 弹簧阻尼，临界阻尼 ≈ 2*sqrt(stiffness) ≈ 28.3 / Pitch spring damping
@export var land_pitch_damping: float = 26.0
## 起跳时给摄像机 pitch 弹簧施加的后仰冲量（弧度/s）/ Jump pitch spring impulse in rad/s
@export var jump_pitch_impulse: float = 0.025
## 落地冲击按下落速度缩放的系数，设为 0 则固定幅度 / Velocity scale for landing impact; 0 = fixed amplitude
@export var land_impact_velocity_scale: float = 0.12

# 呼吸晃动 ─────────────────────────────────────────────────
@export_subgroup("呼吸晃动")
## 是否启用呼吸效果（静止或低速时有效）/ Enable breathing sway at low speed
@export var breathe_enabled: bool = false
## 呼吸频率（Hz），约 18 次/分钟 / Breathing frequency in Hz
@export var breathe_frequency: float = 0.3
## 呼吸垂直振幅（m）/ Breathing vertical amplitude in meters
@export var breathe_amplitude_vertical: float = 0.004
## 呼吸水平漂移振幅（m）/ Breathing horizontal amplitude in meters
@export var breathe_amplitude_horizontal: float = 0.0015
## 超过此速度（m/s）时呼吸效果完全淡出 / Speed above which breathing fades out completely
@export var breathe_max_speed: float = 0.5
