class_name AimConfig
extends Resource

## 瞄准表现配置；不修改武器和配件数据。
@export_group("瞄准过渡速度")
## 抬枪倍率：有效 ADS 时间 / 此倍率。1 保持原速，2 将过渡时间减半。
## 有效 ADS 时间 = max(武器 ads_time + 配件时间修正之和, 0.05)。
## 武器直接跟随当前手部/瞄准姿态，不额外叠加弹簧收敛时间。
@export_range(0.05, 10.0, 0.05) var raise_speed: float = 1.0
## 放下倍率；与抬枪倍率独立。
@export_range(0.05, 10.0, 0.05) var lower_speed: float = 1.0

@export_group("瞄准程序呼吸")
## 呼吸基础频率（Hz）。
@export_range(0.0, 2.0, 0.01) var breathing_frequency_hz: float = 0.3
## 视角局部空间的位移幅度（米）。
@export var breathing_position: Vector3 = Vector3(0.0015, 0.0025, 0.0008)
## 视角局部空间的旋转幅度（度）。
@export var breathing_rotation_degrees: Vector3 = Vector3(0.12, 0.08, 0.15)
## 按住左 Alt 后呼吸幅度归零所需时间（秒）；不影响后坐恢复。
@export_range(0.01, 2.0, 0.01) var hold_blend_time: float = 0.25
## 松开后恢复呼吸所需时间（秒）。
@export_range(0.01, 2.0, 0.01) var release_blend_time: float = 0.4
