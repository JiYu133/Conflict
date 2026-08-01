class_name StockConfig
extends AttachmentConfig

@export_group("Stock Physics")
## Local offset from the stock mount point to the shoulder contact.
@export var shoulder_contact_local: Vector3 = Vector3(0, -0.03, 0.25)
## Additional control stiffness provided by the shoulder contact.
@export var support_stiffness: float = 0.0
## Additional control damping provided by the shoulder contact.
@export var support_damping: float = 0.0
