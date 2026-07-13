class_name TopRightNotificationEntry
extends Resource

## Stable identifier used to update, hide, or dismiss this notification later.
@export var notification_id: StringName

## Main message shown beside the icon or key symbol.
@export_multiline var text: String = ""

## Text fallback for keys or short status markers when no texture icon is assigned.
@export var symbol: String = ""

## Optional texture displayed instead of symbol.
@export var icon: Texture2D

## Allows individual configured notifications to be enabled or disabled in the inspector.
@export var visible: bool = true

## Lower values appear closer to the top of the stack.
@export var display_order: int = 0

## Seconds before dismissal. Set to 0 for a persistent notification.
@export_range(0.0, 60.0, 0.1) var duration: float = 0.0

## Optional per-notification highlight color.
@export var accent_color: Color = Color(0.35, 0.72, 1.0, 1.0)
