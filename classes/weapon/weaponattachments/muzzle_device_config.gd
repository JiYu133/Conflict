class_name MuzzleDeviceConfig
extends AttachmentConfig

enum VisualKind { AUTO, NONE, FLASH_HIDER, MUZZLE_BRAKE, SUPPRESSOR }

@export_group("Muzzle Visuals")
## Explicit visual classification. AUTO preserves compatibility with older configs.
@export var visual_kind: VisualKind = VisualKind.AUTO

@export_group("Muzzle Physics")
## Gas impulse vector in weapon local space. +Z = rearward recoil.
@export var gas_impulse_vector: Vector3 = Vector3(0, 0, 1)
## Scales the gas impulse contribution from the barrel/propellant data.
@export var gas_impulse_fraction: float = 1.0
