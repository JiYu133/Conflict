class_name WeaponPresentationConfig
extends Resource

## Procedural first-person weapon motion. Values are presentation-only; the
## muzzle transform remains the authority for projectile origin and direction.

@export_group("Pose spring")
@export var position_stiffness: float = 150.0
@export var position_damping: float = 25.0
@export var rotation_stiffness: float = 130.0
@export var rotation_damping: float = 23.0
@export_range(0.0, 0.2, 0.001) var max_substep: float = 0.016

@export_group("Breathing")
@export var breathing_frequency_hz: float = 0.6
@export var hip_breath_position: Vector3 = Vector3(0.005, 0.007, 0.002)
@export var ads_breath_position: Vector3 = Vector3(0.0015, 0.0025, 0.0008)
@export var hip_breath_rotation_degrees: Vector3 = Vector3(0.45, 0.35, 0.6)
@export var ads_breath_rotation_degrees: Vector3 = Vector3(0.12, 0.08, 0.15)

@export_group("Movement")
@export var hip_move_position_scale: Vector3 = Vector3(0.010, 0.008, 0.004)
@export var ads_move_position_scale: Vector3 = Vector3(0.0025, 0.002, 0.001)
@export var hip_move_rotation_degrees: Vector3 = Vector3(0.8, 0.7, 1.4)
@export var ads_move_rotation_degrees: Vector3 = Vector3(0.2, 0.16, 0.3)
@export var reference_move_speed: float = 4.0

@export_group("View inertia")
@export var hip_view_lag_degrees: Vector3 = Vector3(3.0, 4.0, 2.0)
@export var ads_view_lag_degrees: Vector3 = Vector3(0.7, 1.0, 0.45)
@export var view_lag_response: float = 0.055

@export_group("Obstruction")
@export var obstruction_probe_radius: float = 0.035
@export_range(0.0, 1.0, 0.01) var obstruction_fire_block_threshold: float = 0.15
@export var obstruction_position: Vector3 = Vector3(0.07, -0.055, 0.11)
@export var obstruction_rotation_degrees: Vector3 = Vector3(25.0, -8.0, -12.0)
@export var obstruction_enter_speed: float = 16.0
@export var obstruction_exit_speed: float = 10.0
