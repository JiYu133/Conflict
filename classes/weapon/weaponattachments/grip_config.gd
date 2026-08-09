class_name GripConfig
extends AttachmentConfig

@export_group("Grip Physics")
## Local offset from the grip mount point to the support contact.
@export var grip_point_local: Vector3 = Vector3.ZERO
## Rotational control stiffness added through the grip lever arm.
@export var support_stiffness: float = 0.0
## Rotational control damping added through the grip lever arm.
@export var support_damping: float = 0.0
