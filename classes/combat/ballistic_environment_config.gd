class_name BallisticEnvironmentConfig
extends Resource

## Runtime environment used by BallisticProjectileSystem.
@export_group("Atmosphere")
## Gravitational acceleration in metres per second squared.
@export var gravity_mps2: float = 9.80665
## Air density in kilograms per cubic metre.
@export var air_density_kg_m3: float = 1.225
## Ambient air temperature in degrees Celsius.
@export var temperature_c: float = 15.0
## Ambient air pressure in pascals.
@export var pressure_pa: float = 101325.0
## Wind velocity vector in metres per second.
@export var wind_velocity_mps: Vector3 = Vector3.ZERO

@export_group("Simulation limits")
## Maximum simulated projectile range in metres.
@export var max_range_m: float = 2000.0
## Maximum simulated projectile flight time in seconds.
@export var max_flight_time_s: float = 8.0
## Speeds below this value stop ballistic simulation.
@export var minimum_effective_speed_mps: float = 40.0
## Maximum integration time step in seconds.
@export var max_time_step_s: float = 1.0 / 240.0
## Maximum integration distance per step in metres.
@export var max_step_distance_m: float = 2.0
## Maximum surface penetrations processed per frame.
@export_range(0, 32, 1) var max_penetrations_per_frame: int = 4

@export_group("Visuals")
## Empty by default: ballistic logic never creates a placeholder visual.
@export var tracer_scene: PackedScene

## Short aliases keep runtime callers independent of the serialized unit suffix.
var wind_velocity: Vector3:
	get:
		return wind_velocity_mps
	set(value):
		wind_velocity_mps = value

var wind_speed_mps: float:
	get:
		return wind_velocity_mps.length()
	set(value):
		var direction := wind_velocity_mps.normalized()
		wind_velocity_mps = direction * maxf(value, 0.0)

var wind_speed: float:
	get:
		return wind_speed_mps
	set(value):
		wind_speed_mps = value

var wind_direction: Vector3:
	get:
		return wind_velocity_mps.normalized()
	set(value):
		if value.length_squared() > 0.000001:
			wind_velocity_mps = value.normalized() * wind_velocity_mps.length()


func get_effective_air_density() -> float:
	if air_density_kg_m3 > 0.0:
		return air_density_kg_m3
	if temperature_c <= -273.15 or pressure_pa <= 0.0:
		return 1.225
	# Ideal gas fallback when a caller intentionally clears air density.
	return pressure_pa / (287.05 * (temperature_c + 273.15))
