// 上下眼皮效果 —— 圆弧形眼皮
// 眼皮边缘是抛物线曲线，中央低两侧高（上眼皮），反之为下眼皮
// upper_close:  0=上眼皮藏在顶外(睁开), 1=压到中央(闭合)
// lower_close:  0=下眼皮藏在底外(睁开), 1=顶到中央(闭合)
// upper_jitter: 上眼皮独立颤抖偏移 [-1, 1]
// lower_jitter: 下眼皮独立颤抖偏移 [-1, 1]
// arc_strength: 圆弧弯曲程度(0=直线, 1=标准弧)
shader_type canvas_item;

uniform float upper_close  : hint_range(0.0, 1.0) = 0.0;
uniform float lower_close  : hint_range(0.0, 1.0) = 0.0;
uniform float upper_jitter : hint_range(-1.0, 1.0) = 0.0;
uniform float lower_jitter : hint_range(-1.0, 1.0) = 0.0;
uniform float arc_strength : hint_range(0.0, 1.0) = 0.72;

void fragment() {
	float x = SCREEN_UV.x;  // 0=左, 1=右
	float y = SCREEN_UV.y;  // 0=顶, 1=底

	// 水平中心化 [-1, 1]
	float cx = x * 2.0 - 1.0;

	// 圆弧偏移：眼皮中央最低点，两侧上翘
	// 上眼皮：中央最近，两侧向上翘起（alpha 往负 y 方向弓起）
	float upper_arc = cx * cx * arc_strength * 0.22;
	// 下眼皮：中央最近，两侧向下弓出
	float lower_arc = cx * cx * arc_strength * 0.12;

	// 上眼皮边缘（带弧和抖动）
	// upper_close=0 时藏在 -0.1, =1 时中央到 0.5
	float upper_base = mix(-0.10, 0.50, upper_close);
	float upper_edge = upper_base + upper_arc + upper_jitter * 0.018;

	// 下眼皮幅度约为上眼皮的 55%（真实比例）
	float lower_base = mix(1.10, 0.50, lower_close * 0.55);
	float lower_edge = lower_base - lower_arc + lower_jitter * 0.010;

	// 边缘软化（越闭合越模糊，模拟困倦感）
	float edge_soft = 0.014 + upper_close * 0.030;

	// 上眼皮遮罩
	float upper_alpha = 1.0 - smoothstep(upper_edge, upper_edge + edge_soft, y);
	// 下眼皮遮罩
	float lower_alpha = smoothstep(lower_edge - edge_soft, lower_edge, y);

	float lid_alpha = max(upper_alpha, lower_alpha);

	// 缝隙区域随闭合程度压暗（困倦感）
	float gap_darken = (upper_close + lower_close) * 0.5;
	float gap_overlay = (1.0 - lid_alpha) * gap_darken * 0.5;

	COLOR = vec4(0.0, 0.0, 0.0, lid_alpha + gap_overlay);
}
