class_name WeaponCalloutLayer
extends Control

## 改装界面的标注层：在预览图上绘制"挂载点 → 槽位卡片"的引线，
## 以及蓝图网格 / 取景角标等装饰。
##
## 与 Delta Force / 塔科夫 的直线细引线不同，这里用：
##   · 贝塞尔曲线引线（从挂载点平滑弯向卡片，带方向感）
##   · 挂载点处的双层圆环节点（选中时外环放大 + 呼吸）
##   · 引线末端的短横线"托住"卡片，形成技术图纸的引出标注感
##   · 底层蓝图网格 + 四角取景括号，强调"军械档案"而非"商店货架"

const GRID_STEP := 46.0
const NODE_RADIUS := 4.0
const NODE_RING_RADIUS := 9.0

var grid_color := Color(1.0, 1.0, 1.0, 0.028)
var line_color := Color(0.61, 0.64, 0.68, 0.55)
var line_active_color := Color(0.55, 0.72, 0.90, 1.0)
var bracket_color := Color(0.55, 0.72, 0.90, 0.40)

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


func _draw() -> void:
	_draw_grid()
	_draw_frame_brackets()
	for c in callouts:
		_draw_callout(c)


func _draw_grid() -> void:
	var w := size.x
	var h := size.y
	var x := fmod(w, GRID_STEP) * 0.5
	while x < w:
		draw_line(Vector2(x, 0), Vector2(x, h), grid_color, 1.0)
		x += GRID_STEP
	var y := fmod(h, GRID_STEP) * 0.5
	while y < h:
		draw_line(Vector2(0, y), Vector2(w, y), grid_color, 1.0)
		y += GRID_STEP


## 四角取景括号，像瞄具/技术图纸的裁切标记
func _draw_frame_brackets() -> void:
	var inset := 10.0
	var arm := 26.0
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
	var side: int = c.get("side", -1)
	var col := line_active_color if active else line_color
	var width := 2.0 if active else 1.0

	# 末端短横线：从卡片边缘朝画面中心伸出一小段，引线接在它末端
	var stub_len := 18.0
	var stub_end := target + Vector2(stub_len * -side, 0.0)
	draw_line(target, stub_end, col, width)

	# 贝塞尔引线：控制点沿水平方向拉开，形成平滑的 S 弯
	var dx: float = absf(stub_end.x - anchor.x)
	var ctrl_pull: float = clampf(dx * 0.55, 40.0, 200.0)
	var p0 := anchor
	var p1 := anchor + Vector2(ctrl_pull * -side, 0.0)
	var p2 := stub_end + Vector2(ctrl_pull * side, 0.0)
	var p3 := stub_end
	var points := PackedVector2Array()
	var steps := 26
	for i in range(steps + 1):
		points.append(_bezier(p0, p1, p2, p3, float(i) / steps))
	draw_polyline(points, col, width, true)

	# 挂载点节点：实心点 + 外环（选中时外环随呼吸放大）
	draw_circle(anchor, NODE_RADIUS, col)
	var ring := NODE_RING_RADIUS
	if active:
		ring += sin(pulse) * 2.5
	draw_arc(anchor, ring, 0.0, TAU, 28, col, width, true)


static func _bezier(p0: Vector2, p1: Vector2, p2: Vector2, p3: Vector2, t: float) -> Vector2:
	var u := 1.0 - t
	return u * u * u * p0 + 3.0 * u * u * t * p1 + 3.0 * u * t * t * p2 + t * t * t * p3
