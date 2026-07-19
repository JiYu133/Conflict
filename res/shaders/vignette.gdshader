shader_type canvas_item;

// 体力不足时的边缘压暗效果，兼用于死亡渐黑
// strength:     0.0 = 无效果, 1.0 = 最强
// inner_radius: 压暗开始的半径（0.0 = 从屏幕中心开始, 0.5 = 正常边缘）
// outer_radius: 压暗完全不透明的半径（通常比 inner_radius 大 0.4~0.8）
uniform float strength : hint_range(0.0, 1.0) = 0.0;
uniform float inner_radius : hint_range(0.0, 2.0) = 0.4;
uniform float outer_radius : hint_range(0.0, 2.0) = 1.2;
uniform vec4 vignette_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
	vec2 uv = SCREEN_UV * 2.0 - 1.0;
	float dist = length(uv);
	float alpha = smoothstep(inner_radius, outer_radius, dist) * strength;
	COLOR = vec4(vignette_color.rgb, alpha);
}
