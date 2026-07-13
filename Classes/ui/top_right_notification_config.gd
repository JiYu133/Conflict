class_name TopRightNotificationConfig
extends Resource

@export_group("Startup notifications")
## Notifications shown when the manager enters the scene tree.
@export var startup_notifications: Array[TopRightNotificationEntry] = []

@export_group("Layout")
@export var margin_right: float = 24.0
@export var margin_top: float = 24.0
@export var card_spacing: int = 7
@export var card_width: float = 390.0
@export_range(1, 20, 1) var max_visible_notifications: int = 10

@export_group("Card appearance")
@export var card_background: Color = Color(0.035, 0.045, 0.06, 0.88)
@export var card_corner_radius: int = 6
@export var card_padding: int = 10
@export var symbol_width: float = 96.0
@export var icon_size: float = 32.0

@export_group("Text")
## Bundle a CJK-capable font here to avoid platform-dependent fallback glyphs.
@export var font: Font
@export var font_size: int = 17
@export var symbol_font_size: int = 15
@export var text_color: Color = Color(0.96, 0.97, 1.0, 1.0)
@export var symbol_color: Color = Color(0.72, 0.86, 1.0, 1.0)

@export_group("Animation")
@export var fade_in_duration: float = 0.16
@export var fade_out_duration: float = 0.16
