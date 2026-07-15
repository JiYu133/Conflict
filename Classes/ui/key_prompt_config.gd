class_name KeyPromptConfig
extends Resource

@export_group("布局")
## 右侧屏幕边距（像素）
@export var margin_right: float = 24.0
## 顶部屏幕边距（像素）
@export var margin_top: float = 24.0
## 卡片之间的垂直间距（像素）
@export var card_spacing: float = 8.0
## 最多同时显示的卡片数；超出后先进入队列等待
@export var max_visible_cards: int = 5

@export_group("卡片外观")
## 卡片背景色（含透明度）
@export var card_bg_color: Color = Color(0.05, 0.05, 0.05, 0.82)
## 卡片圆角半径（像素）
@export var card_corner_radius: int = 6
## 卡片内边距（四边均等，像素）
@export var card_padding: float = 10.0
## 图标显示尺寸（正方形，像素）
@export var icon_size: float = 40.0
## 图标与文字之间的水平间隔（像素）
@export var icon_label_gap: float = 10.0

@export_group("文字")
## 标签字号（像素）
@export var font_size: int = 16
## 文字颜色
@export var text_color: Color = Color(0.95, 0.95, 0.95, 1.0)
## 自定义字体；留空则使用主题默认字体
@export var custom_font: Font

@export_group("动画")
## 滑入动画时长（秒）
@export var slide_in_duration: float = 0.22
## 滑出动画时长（秒）
@export var slide_out_duration: float = 0.18
## 滑入缓动类型
@export var ease_in: Tween.EaseType = Tween.EASE_OUT
## 滑出缓动类型
@export var ease_out: Tween.EaseType = Tween.EASE_IN
## 卡片重排时的位移过渡时长（秒）
@export var reposition_duration: float = 0.15
