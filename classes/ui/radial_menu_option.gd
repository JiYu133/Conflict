class_name RadialMenuOption
extends Resource

## Data passed to RadialMenu. The callable is intentionally kept generic so
## future wheels can provide tactical equipment, voice commands, and more.
@export var id: String = ""
@export var title: String = ""
@export_multiline var description: String = ""
@export var icon: String = ""
@export var is_current: bool = false
@export var is_enabled: bool = true
@export var disabled_reason: String = ""
var execute: Callable = Callable()


static func from_dictionary(data: Dictionary) -> RadialMenuOption:
	var option := RadialMenuOption.new()
	option.id = String(data.get("id", ""))
	option.title = String(data.get("title", option.id))
	option.description = String(data.get("description", ""))
	option.icon = String(data.get("icon", ""))
	option.is_current = bool(data.get("is_current", false))
	option.is_enabled = bool(data.get("is_enabled", true))
	option.disabled_reason = String(data.get("disabled_reason", ""))
	var callback = data.get("execute", Callable())
	if callback is Callable:
		option.execute = callback
	return option
