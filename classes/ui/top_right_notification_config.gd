class_name TopRightNotificationConfig
extends Resource

@export_group("Startup notifications")
## Notifications shown when the manager enters the scene tree.
@export var startup_notifications: Array[TopRightNotificationEntry] = []

@export_group("Layout")
## Keep at 0 for bars that sit flush against the right edge of the viewport.
@export var margin_right: float = 0.0
## Keep at 0 so the notification stack begins at the exact top-right corner.
@export var margin_top: float = 0.0
## Vertical gap in pixels between adjacent notification cards.
@export var card_spacing: int = 4
## Notification card width in pixels.
@export var card_width: float = 390.0
## Maximum number of cards displayed simultaneously.
@export_range(1, 20, 1) var max_visible_notifications: int = 10
## Wait until the main scene is visible before starting persistent tutorial animations.
@export var startup_delay: float = 0.35
## Extra pause after one bar has completely entered and before the next begins.
@export var startup_gap: float = 0.03

@export_group("Card appearance")
## Background colour shared by all notification cards.
@export var card_background: Color = Color(0.035, 0.045, 0.06, 0.58)
## Card corner radius in pixels; zero keeps square corners.
@export var card_corner_radius: int = 0
## Inner card padding in pixels.
@export var card_padding: int = 10
## Width reserved for the notification symbol in pixels.
@export var symbol_width: float = 96.0
## Icon size in pixels.
@export var icon_size: float = 32.0

@export_group("Text")
## Bundle a CJK-capable font here to avoid platform-dependent fallback glyphs.
@export var font: Font
## Main notification text size in pixels.
@export var font_size: int = 17
## Symbol text size in pixels.
@export var symbol_font_size: int = 15
## Main notification text colour.
@export var text_color: Color = Color(0.96, 0.97, 1.0, 1.0)
## Symbol text colour.
@export var symbol_color: Color = Color(0.72, 0.86, 1.0, 1.0)

@export_group("Animation")
## Short cubic transitions keep contextual messages noticeable without interrupting play.
@export var slide_in_duration: float = 0.22
## Card exit animation duration in seconds.
@export var slide_out_duration: float = 0.18
