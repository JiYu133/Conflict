class_name KeyPromptEntry
extends Resource

@export_group("内容")
## 按键图标贴图，建议 64×64 PNG，存放于 res://res/textures/ui/key_icons/
@export var key_icon: Texture2D
## 描述文字，如 "前进"、"跳跃"
@export var label_text: String = ""

@export_group("行为")
## 显示持续时间（秒）。0 = 永久显示，直到手动 dismiss
@export var duration: float = 4.0
## 排序权重，数值越小越靠近顶部
@export var sort_order: int = 0
