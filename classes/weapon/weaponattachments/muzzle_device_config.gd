class_name MuzzleDeviceConfig
extends AttachmentConfig

@export_group("Muzzle Physics")
## Gas impulse vector in weapon local space. +Z = rearward recoil.
@export var gas_impulse_vector: Vector3 = Vector3(0, 0, 1)
## Scales the gas impulse contribution from the barrel/propellant data.
@export var gas_impulse_fraction: float = 1.0
