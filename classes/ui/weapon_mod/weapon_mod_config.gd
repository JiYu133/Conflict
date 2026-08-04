class_name WeaponModConfig
extends Resource

## 武器改装界面的布局、动画和本地化文案配置。
## 数值集中在资源中，方便设计调整和按语言制作不同的 .tres。

@export_category("布局")
## 卡片尺寸，单位是屏幕像素：Vector2(宽度, 高度)。
@export var chip_size := Vector2(184, 52)
## 卡片相互重叠时的最小间距，数值越大卡片越分散。
@export var chip_gap := 12.0
## 卡片与武器挂载点之间的距离，数值越大引线越长、卡片离武器越远。
@export var chip_anchor_gap := 52.0
## 卡片距离舞台边缘的最小距离，单位是屏幕像素。
@export var stage_margin := 8.0
## 详情面板相对卡片的横向间距，单位是屏幕像素。
@export var detail_panel_offset := 28.0
## 详情面板占用的横向空间，用于限制它贴近舞台边缘的位置。
@export var detail_panel_width := 368.0
## 详情面板预留的纵向空间，用于限制它贴近舞台底部的位置。
@export var detail_panel_height := 380.0

@export_category("引线")
## 挂载点实心圆的半径，单位是屏幕像素。
@export var callout_node_radius := 4.0
## 挂载点外环的半径，单位是屏幕像素。
@export var callout_node_ring_radius := 9.0
## 引线接入卡片前的最后一段直线长度，单位是屏幕像素。
@export var callout_stub_length := 24.0
## 判断引线走水平还是垂直方向的偏置，数值越大越倾向走垂直线。
@export var callout_horizontal_bias := 32.0
## 45 度斜线前保留的最短直线长度，单位是屏幕像素。
@export var callout_min_straight_length := 10.0
## 舞台四角取景括号距离边缘的距离，单位是屏幕像素。
@export var callout_frame_inset := 10.0
## 舞台四角取景括号的边长，单位是屏幕像素。
@export var callout_frame_arm := 26.0

@export_category("动画")
## 武器配件变化后，相机中心和距离过渡到新位置所需的秒数。
@export var camera_transition_duration := 0.28
## 卡片第一次出现时的淡入和缩放动画时长，单位是秒。
@export var chip_appearance_duration := 0.22
## 卡片已有目标位置变化时的移动动画时长，单位是秒。
@export var chip_move_duration := 0.14
## 选中卡片与其他卡片之间的淡化过渡时长，单位是秒。
@export var chip_focus_duration := 0.16
## 配件详情面板跟随卡片移动的动画时长，单位是秒。
@export var detail_panel_move_duration := 0.14
## 底部武器参数进度条变化的动画时长，单位是秒。
@export var stat_bar_duration := 0.25
## 未选中卡片的不透明度，范围 0 到 1；数值越小越淡。
@export var unfocused_chip_alpha := 0.34
## 未选中卡片的缩放比例，1 为原始大小。
@export var unfocused_chip_scale := 0.97

@export_category("交互")
## 鼠标按下后移动超过该像素数才视为拖动，否则视为点击。
@export var view_drag_threshold := 6.0
## 视角旋转灵敏度，数值越大同样的鼠标移动旋转角度越大。
@export var view_rotation_sensitivity := 0.010
## 导轨滑块每次移动的最小步长，数值越小调整越精细。
@export var rail_slider_step := 0.001

@export_category("界面文案")
## 改装界面的主标题。
@export var title := "武器改装"
## 标题下方的说明文字。
@export var subtitle := "点击引线标注的挂载点卡片，安装或卸下配件 · 应用后生效"
## 复位视角按钮文字。
@export var reset_view := "复位视角"
## 配件数量文字格式，必须保留一个 %d 用于插入数量。
@export var option_count := "%d 个可用配件"
## 空槽位安装按钮文字。
@export var install := "安装"
## 卸下按钮的短文字。
@export var detach_short := "卸下"
## 配件没有数值修正时显示的文字。
@export var no_modifier := "无数值修正"
## 没有装备武器时的标题。
@export var no_weapon := "当前没有装备武器"
## 没有装备武器时的提示。
@export var no_weapon_hint := "装备一把武器后再打开改装界面"
## 武器没有挂载点时的提示。
@export var no_slots := "该武器没有可用挂载点"
## 槽位没有安装配件时的文字。
@export var slot_empty := "空"
## 槽位不可拆卸时的文字。
@export var slot_locked := "不可拆卸"
## 没有可用配件时的提示。
@export var list_empty := "没有适配此挂载点的配件"
## 当前配件行的说明文字。
@export var detach := "卸下当前配件"
## 已安装配件的状态文字。
@export var installed := "已安装"
## 左右侧导轨合并后的显示名称。
@export var side_rail := "侧导轨"
## 侧导轨内部左侧槽位的名称。
@export var side_rail_left := "左侧"
## 侧导轨内部右侧槽位的名称。
@export var side_rail_right := "右侧"
## 侧导轨安装数量格式，必须保留一个 %d 用于插入数量。
@export var side_rail_status := "已安装 %d / 2"
## 导轨滑块上方的标题。
@export var rail_position := "导轨位置"
## 鼠标悬停在导轨滑块上时的提示。
@export var rail_position_hint := "拖动调整配件在导轨上的前后位置"
## 关闭按钮文字。
@export var close := "关闭"
## 应用按钮文字。
@export var apply := "应用更改"
## 放弃草稿按钮文字。
@export var revert := "放弃更改"
## 已有配件时的替换按钮文字。
@export var replace := "更换"
## 底部操作提示。
@export var footer_hint := "改装先在预览中生效，点「应用更改」写入武器 · ESC 关闭"
## 核心槽位名称后追加的标签。
@export var core_tag := "· 核心"
## 核心槽位为空时的卡片状态文字。
@export var core_missing := "缺少核心配件"
## 核心配件可以在草稿中暂时卸下时的提示。
@export var core_hint := "核心配件可暂时卸下，但应用前必须装回"
## 应用失败时的提示格式，必须保留一个 %s 用于插入槽位名称。
@export var core_blocked := "无法应用：以下核心挂载点为空 — %s"
## 底部参数栏标题。
@export var stat_header := "武器参数"
## 腰射散布参数名称。
@export var stat_spread_hip := "腰射散布"
## 机瞄散布参数名称。
@export var stat_spread_ads := "机瞄散布"
## 垂直后座参数名称。
@export var stat_recoil_v := "单发俯仰角速度(°/s)"
## 水平后座参数名称。
@export var stat_recoil_h := "单发偏航角速度(°/s)"
## 重量参数名称。
@export var stat_weight := "总重量"
## 枪械全长参数名称。
@export var stat_length := "全长"
## 配件安装失败提示格式，必须保留一个 %s。
@export var equip_failed := "安装失败：%s"
## 配件前置条件提示格式，必须保留一个 %s。
@export var slot_requires := "需要先安装：%s"
## 配件腰射修正的前缀。
@export var modifier_hipfire := "腰射"
## 配件机瞄修正的前缀。
@export var modifier_ads := "机瞄"
## 配件重量修正的前缀。
@export var modifier_weight := "重量"
## 多条配件修正之间的分隔符。
@export var modifier_separator := " · "
