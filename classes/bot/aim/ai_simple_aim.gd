@tool
class_name AISimpleAim
extends AIAimProvider

## 默认瞄准：以限定角速度把**枪管**（不是眼睛）转向目标胸口，叠加
## AIProfile.aim_error_degrees 的水平随机误差，每开一枪重新随机一次。
## 用作占位，等正式瞄准系统替换。
## Placeholder aim: steer the barrel onto the target's chest at a capped turn
## rate, offset by a random yaw error that is re-rolled after every shot. The
## weapon pose can point the bore away from the commanded view, so the measured
## view-to-barrel offset is subtracted from the view command.

## 最大转向速度（度/秒）。
@export var turn_speed_degrees: float = 540.0
## 枪管与期望方向的夹角小于该值即视为对准。
@export var ready_tolerance_degrees: float = 2.0
## 视线到枪管偏差的平滑系数（每帧）。
@export_range(0.0, 1.0) var offset_smoothing: float = 0.3

var _error_yaw := 0.0
var _needs_roll := true
var _profile: AIProfile
var _yaw_offset := 0.0
var _pitch_offset := 0.0


func begin_aim(_brain: AIPlayerBrain, _target: BasePlayer) -> void:
	_needs_roll = true


func update_aim(brain: AIPlayerBrain, target: BasePlayer, profile: AIProfile, delta: float) -> bool:
	_profile = profile
	if _needs_roll:
		_roll_error()
	var current := brain.get_aim_direction()
	var barrel := brain.get_muzzle_direction()
	var wanted := (brain.get_target_aim_point(target) - brain.get_muzzle_position()).normalized()
	wanted = wanted.rotated(Vector3.UP, _error_yaw)
	if barrel != Vector3.ZERO:
		_yaw_offset = lerp_angle(_yaw_offset, angle_difference(_yaw(current), _yaw(barrel)), offset_smoothing)
		_pitch_offset = lerpf(_pitch_offset, _pitch(barrel) - _pitch(current), offset_smoothing)
	var view_goal := _direction(_yaw(wanted) - _yaw_offset, _pitch(wanted) - _pitch_offset)
	var angle := current.angle_to(view_goal)
	var max_step := deg_to_rad(turn_speed_degrees) * delta
	var next := view_goal
	if angle > max_step:
		# Opposite vectors have no slerp plane; turn around the vertical instead.
		next = current.rotated(Vector3.UP, max_step) if angle > PI - 0.01 else current.slerp(view_goal, max_step / angle)
	brain.aim_at_direction(next)
	var pointing := barrel if barrel != Vector3.ZERO else next
	return rad_to_deg(pointing.angle_to(wanted)) <= ready_tolerance_degrees


func on_shot_fired(_brain: AIPlayerBrain) -> void:
	_needs_roll = true


func _roll_error() -> void:
	_needs_roll = false
	var error := _profile.aim_error_degrees if _profile else 0.0
	_error_yaw = deg_to_rad(randf_range(-error, error))


static func _yaw(direction: Vector3) -> float:
	return atan2(-direction.x, -direction.z)


static func _pitch(direction: Vector3) -> float:
	return asin(clampf(direction.y, -1.0, 1.0))


static func _direction(yaw: float, pitch: float) -> Vector3:
	return Vector3(-sin(yaw) * cos(pitch), sin(pitch), -cos(yaw) * cos(pitch))
