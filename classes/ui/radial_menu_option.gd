class_name RadialMenuOption
extends Resource

## 轮盘选项数据。execute 保持通用，便于未来接入战术装备等其他轮盘。
@export var id: String = ""
@export var title: String = ""
@export_multiline var description: String = ""
## 保留图标名称接口；当前射击模式轮盘默认只显示文字。
@export var icon: String = ""
## 可由 tres 选项资源提供贴图，打开 RadialMenuConfig.show_icons 后使用。
@export var icon_texture: Texture2D
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
	var icon_texture = data.get("icon_texture")
	if icon_texture is Texture2D:
		option.icon_texture = icon_texture
	option.is_current = bool(data.get("is_current", false))
	option.is_enabled = bool(data.get("is_enabled", true))
	option.disabled_reason = String(data.get("disabled_reason", ""))
	var callback = data.get("execute", Callable())
	if callback is Callable:
		option.execute = callback
	return option
