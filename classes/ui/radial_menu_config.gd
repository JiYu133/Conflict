class_name RadialMenuConfig
extends Resource

## 射击模式轮盘的视觉配置，运行时由 radial_menu_config.tres 提供。

@export_group("布局")
## 外圆半径占屏幕短边的比例；0.20 即轮盘直径约占短边 40%。
@export_range(0.10, 0.40, 0.01) var menu_radius_ratio: float = 0.20
## 内圆半径占外圆半径的比例，数值越大中心留白越大。
@export_range(0.35, 0.85, 0.01) var inner_radius_ratio: float = 0.64
## 标签中心占外圆半径的比例。
@export_range(0.50, 0.95, 0.01) var label_radius_ratio: float = 0.82
## 相邻模块之间的角度间隙（弧度）。
@export_range(0.01, 0.20, 0.005) var sector_gap: float = 0.06
## 内侧端点向模块中心收拢的角度，用于减弱两侧斜度。
@export_range(0.0, 0.20, 0.005) var side_flatten_angle: float = 0.06
## 选中模块向外扩大的比例。
@export_range(1.0, 1.10, 0.005) var selected_scale: float = 1.045

@export_group("标签")
## 每个扇区标签的固定尺寸（像素）。
@export var label_size: Vector2 = Vector2(136.0, 30.0)
## 标签字体大小（像素）。
@export_range(8, 32, 1) var label_font_size: int = 14

@export_group("颜色")
## 未选中扇区的填充颜色。
@export var panel_color: Color = Color(0.25, 0.25, 0.25, 0.44)
## 选中扇区的填充颜色。
@export var panel_selected_color: Color = Color(0.82, 0.82, 0.82, 0.72)
## 默认扇区边框颜色。
@export var border_color: Color = Color(0.96, 0.96, 0.96, 0.62)
## 当前已启用射击模式的边框颜色。
@export var border_current_color: Color = Color(0.90, 0.90, 0.90, 0.78)
## 鼠标或手柄当前选中扇区的边框颜色。
@export var border_selected_color: Color = Color(1.0, 1.0, 1.0, 0.98)
## 正常标签文字颜色。
@export var text_color: Color = Color(0.98, 0.98, 0.98, 1.0)
## 不可用扇区的填充颜色。
@export var disabled_color: Color = Color(0.32, 0.32, 0.32, 0.30)
## 不可用扇区的文字颜色。
@export var disabled_text_color: Color = Color(0.56, 0.56, 0.56, 0.78)

@export_group("图标接口")
## 默认关闭，保留给后续需要图标的轮盘配置。
@export var show_icons: bool = false
## 图标启用时使用的固定尺寸（像素）。
@export var icon_size: Vector2 = Vector2(24.0, 24.0)
