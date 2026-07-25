class_name RecoilComponent
extends Node

# ============================================================
# 后座组件 v2 — 摄像机真实 Kick 系统
#
# 每发施加一次性 pitch/yaw 冲量，通过 consume_* 函数读取后清零。
# PlayerCameraController 每帧消费，直接写入 _vertical_angle 和 rotate_y。
# 不自动回正，玩家需主动用鼠标压枪。
#
# 武器视觉抖动由动画系统负责，不在此处处理。
#
# 依赖：WeaponConfig（kick_* 字段）
#       AttachmentManager（配件修正，向后兼容）
# ============================================================

var config: WeaponConfig
var attachment_manager: AttachmentManager

# 摄像机 kick 冲量（一次性，消费后清零）
var _pending_kick_pitch: float = 0.0
var _pending_kick_yaw: float = 0.0


# ============================================================
# 初始化（接口不变）
# ============================================================
func initialize(cfg: WeaponConfig, am: AttachmentManager = null) -> void:
	config = cfg
	attachment_manager = am
	GlobalLogger.debug("RecoilComponent", "Initialized (v2) for: " + cfg.weapon_name)


# ============================================================
# 每发后座（主入口）
# ============================================================

## 施加一发子弹的后座效果
## stability_mult：稳定性修正系数（站立=1.0, 蹲下=0.7, 疲劳=1.3）
func apply_recoil(stability_mult: float = 1.0) -> void:
	if not config:
		return

	# 读取配件修正（向后兼容旧的 recoil_vertical/horizontal 修正通道）
	var v_mod: float = 0.0
	var h_mod: float = 0.0
	if attachment_manager:
		v_mod = attachment_manager.get_total_recoil_vertical_modifier()
		h_mod = attachment_manager.get_total_recoil_horizontal_modifier()

	# pitch kick：永久上抬摄像机（连发线性累积）
	_pending_kick_pitch += deg_to_rad(config.kick_pitch_deg + v_mod) * stability_mult

	# yaw kick：基础偏转 + 随机分量（模拟左右摆动）
	var base_yaw := config.kick_yaw_deg + h_mod
	var rand_yaw := randf_range(-config.kick_yaw_random_deg, config.kick_yaw_random_deg)
	_pending_kick_yaw += deg_to_rad(base_yaw + rand_yaw) * stability_mult


# ============================================================
# 消费接口（PlayerCameraController 每帧调用，读完即清零）
# ============================================================

## 消费 pitch kick 冲量，返回本帧应加到 _vertical_angle 的值
func consume_camera_kick_pitch() -> float:
	var v := _pending_kick_pitch
	_pending_kick_pitch = 0.0
	return v


## 消费 yaw kick 冲量，返回本帧应传入 rotate_y 的值
func consume_camera_kick_yaw() -> float:
	var v := _pending_kick_yaw
	_pending_kick_yaw = 0.0
	return v


# ============================================================
# 向后兼容接口（空实现，防止旧代码报错）
# ============================================================
func get_recoil_offset() -> float:
	return 0.0

func get_recoil_horizontal_offset() -> float:
	return 0.0
