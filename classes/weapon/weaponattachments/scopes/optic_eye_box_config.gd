class_name OpticEyeBoxConfig
extends Resource

## Tolerances around ADSAnchor, expressed in OpticCameraAnchor axes.
@export_range(0.001, 0.2, 0.001) var horizontal_tolerance: float = 0.025
@export_range(0.001, 0.2, 0.001) var vertical_tolerance: float = 0.020
@export_range(0.001, 0.3, 0.001) var eye_relief_tolerance: float = 0.06
@export_range(0.1, 45.0, 0.1) var angle_tolerance_degrees: float = 6.0
@export_range(0.01, 2.0, 0.01) var shadow_softness: float = 0.5
@export_range(0.0, 1.0, 0.01) var minimum_visibility: float = 0.025


func evaluate(eye: Transform3D, camera_anchor: Transform3D, calibrated_eye: Transform3D) -> Dictionary:
	var basis := camera_anchor.basis.orthonormalized()
	var offset := basis.inverse() * (eye.origin - calibrated_eye.origin)
	var angular_error := acos(clampf((-eye.basis.z).normalized().dot((-calibrated_eye.basis.z).normalized()), -1.0, 1.0))
	var lateral := Vector2(offset.x / maxf(horizontal_tolerance, 0.001), offset.y / maxf(vertical_tolerance, 0.001))
	var error := maxf(lateral.length(), maxf(absf(offset.z) / maxf(eye_relief_tolerance, 0.001), angular_error / deg_to_rad(maxf(angle_tolerance_degrees, 0.1))))
	var softness := maxf(shadow_softness, 0.01)
	var shadow := smoothstep(1.0 - softness, 1.0 + softness, error)
	return {"visibility": lerpf(1.0, minimum_visibility, shadow), "offset": lateral, "shadow": shadow}
