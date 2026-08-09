class_name WeaponCalloutLayer
extends Control

## 改装界面的标注层：在预览图上绘制"挂载点 → 槽位卡片"的引线，
## 以及蓝图网格 / 取景角标等装饰。
##
## 与 Delta Force / 塔科夫 的直线细引线不同，这里用：
##   · 贝塞尔曲线引线（从挂载点平滑弯向卡片，避免直角折点）
##   · 挂载点处的双层圆环节点（选中时外环放大 + 呼吸）
##   · 引线末端的短横线"托住"卡片，形成技术图纸的引出标注感
##   · 底层蓝图网格 + 四角取景括号，强调"军械档案"而非"商店货架"

const NODE_RADIUS := 4.0
const NODE_RING_RADIUS := 9.0

var line_color := Color(0.61, 0.64, 0.68, 0.55)
var line_active_color := Color(0.55, 0.72, 0.90, 1.0)
var bracket_color := Color(0.55, 0.72, 0.90, 0.40)
var mod_config: WeaponModConfig

## 每项：{ anchor: Vector2, target: Vector2, active: bool, side: int(-1 左 / 1 右) }
var callouts: Array = []
var pulse: float = 0.0


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_process(true)


func _process(delta: float) -> void:
	# 仅在有选中项时才需要重绘呼吸效果
	var has_active := false
	for c in callouts:
		if c.get("active", false):
			has_active = true
			break
	if has_active:
		pulse = fmod(pulse + delta * 2.0, TAU)
		queue_redraw()


func set_callouts(data: Array) -> void:
	callouts = data
	queue_redraw()


## 只画会动的东西（引线 / 节点 / 角标）。
## 网格背景交给 blueprint_grid.gdshader，在 GPU 上出，不占 draw call。
func _draw() -> void:
	_draw_frame_brackets()
	for c in callouts:
		_draw_callout(c)


## 四角取景括号，像瞄具/技术图纸的裁切标记
func _draw_frame_brackets() -> void:
	var inset := mod_config.callout_frame_inset if mod_config else 10.0
	var arm := mod_config.callout_frame_arm if mod_config else 26.0
	var w := size.x - inset
	var h := size.y - inset
	var corners := [
		[Vector2(inset, inset), Vector2(1, 0), Vector2(0, 1)],
		[Vector2(w, inset), Vector2(-1, 0), Vector2(0, 1)],
		[Vector2(inset, h), Vector2(1, 0), Vector2(0, -1)],
		[Vector2(w, h), Vector2(-1, 0), Vector2(0, -1)],
	]
	for c in corners:
		var origin: Vector2 = c[0]
		draw_line(origin, origin + (c[1] as Vector2) * arm, bracket_color, 1.5)
		draw_line(origin, origin + (c[2] as Vector2) * arm, bracket_color, 1.5)


func _draw_callout(c: Dictionary) -> void:
	var anchor: Vector2 = c.get("anchor", Vector2.ZERO)
	var target: Vector2 = c.get("target", Vector2.ZERO)
	var active: bool = c.get("active", false)
	var col := line_active_color if active else line_color
	var width := 2.0 if active else 1.0

	# 根据挂载点到卡片的相对位置，选择 45 度折线路径方向。
	# 卡片现在可以出现在武器四周，不能再假定只有左右两个连接边。
	var delta := target - anchor
	var horizontal_bias := mod_config.callout_horizontal_bias if mod_config else 32.0
	var horizontal := absf(delta.x) >= absf(delta.y) + horizontal_bias
	var route_dir := Vector2(signf(delta.x), 0.0) if horizontal else Vector2(0.0, signf(delta.y))
	if route_dir == Vector2.ZERO:
		route_dir = Vector2.RIGHT

	# 末端短连接段：从卡片边缘朝挂载点伸出一小段，引线接在它末端。
	var stub_len := mod_config.callout_stub_length if mod_config else 24.0
	var stub_end := target - route_dir * stub_len
	draw_line(target, stub_end, col, width)

	# 中间使用一段精确 45 度的斜线，两侧保留水平/垂直段；
	# 这样连接方向清楚，也不会出现贝塞尔曲线贴不到卡片的情况。
	var main_distance := absf(stub_end.x - anchor.x) if horizontal else absf(stub_end.y - anchor.y)
	var cross_distance := absf(stub_end.y - anchor.y) if horizontal else absf(stub_end.x - anchor.x)
	var cross_dir := Vector2(0.0, signf(stub_end.y - anchor.y)) if horizontal else Vector2(signf(stub_end.x - anchor.x), 0.0)
	var points := PackedVector2Array([anchor])
	var min_straight := mod_config.callout_min_straight_length if mod_config else 10.0
	if cross_distance > 2.0 and main_distance >= cross_distance:
		var straight_total := maxf(main_distance - cross_distance, 0.0)
		var before_diagonal := maxf(straight_total * 0.5, min_straight)
		before_diagonal = minf(before_diagonal, straight_total)
		var lead := anchor + route_dir * before_diagonal
		var diagonal_end := lead + route_dir * cross_distance + cross_dir * cross_distance
		points.append(lead)
		points.append(diagonal_end)
	else:
		points.append(anchor + route_dir * minf(main_distance * 0.5, 24.0))
	points.append(stub_end)
	draw_polyline(points, col, width, true)

	# 挂载点节点：实心点 + 外环（选中时外环随呼吸放大）
	var node_radius := mod_config.callout_node_radius if mod_config else NODE_RADIUS
	var ring := mod_config.callout_node_ring_radius if mod_config else NODE_RING_RADIUS
	draw_circle(anchor, node_radius, col)
	if active:
		ring += sin(pulse) * 2.5
	draw_arc(anchor, ring, 0.0, TAU, 28, col, width, true)
