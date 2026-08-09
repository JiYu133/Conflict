shader_type canvas_item;

// 蓝图网格背景（改装界面）
// 全部在片元着色器里算，网格本身不产生任何 draw call，也不需要重绘；
// 之前用 GDScript 循环 draw_line() 画，每帧几十次 CPU 绘制，纯属浪费。
// 支持主次网格线：每 major_every 格加粗一条，接近真实工程图纸。

uniform vec2 rect_size = vec2(1920.0, 1080.0);
uniform vec4 minor_color : source_color = vec4(1.0, 1.0, 1.0, 0.030);
uniform vec4 major_color : source_color = vec4(1.0, 1.0, 1.0, 0.055);
uniform float grid_step = 46.0;
uniform float major_every = 4.0;
uniform float line_width = 1.0;

// 返回该像素落在网格线上的强度（0~1，带一像素羽化做抗锯齿）
float grid_mask(vec2 px, float step_size, float width) {
	vec2 cell = mod(px, step_size);
	// 同时考虑靠近 0 和靠近 step_size 两侧，避免边界漏画
	vec2 dist = min(cell, step_size - cell);
	vec2 line = 1.0 - smoothstep(width * 0.5, width * 0.5 + 1.0, dist);
	return clamp(max(line.x, line.y), 0.0, 1.0);
}

void fragment() {
	vec2 px = UV * rect_size;

	float minor = grid_mask(px, grid_step, line_width);
	float major = grid_mask(px, grid_step * major_every, line_width * 1.4);

	// 主线覆盖次线
	vec4 col = vec4(minor_color.rgb, minor_color.a * minor);
	col = mix(col, vec4(major_color.rgb, major_color.a * major), major);

	COLOR = col;
}
