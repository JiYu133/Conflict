// 濒死/昏迷视觉：轻微暗化、画面波动和 RGB 重影。
// 该 shader 只在 unconscious 状态启用，intensity 最大为 1，
// dark_strength 保持在 0.45 以下，确保画面不会被完全遮住。
shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform float intensity : hint_range(0.0, 1.0) = 0.0;
uniform float time = 0.0;
uniform float dark_strength : hint_range(0.0, 1.0) = 0.38;

void fragment() {
	vec2 uv = SCREEN_UV;
	vec2 centered = uv * 2.0 - 1.0;
	float edge = smoothstep(0.15, 1.15, length(centered));

	// 两组低频波叠加，模拟意识模糊时的视线漂移。
	vec2 wave_offset = vec2(
		sin(uv.y * 19.0 + time * 3.8) + sin(uv.y * 43.0 - time * 6.1),
		cos(uv.x * 17.0 - time * 3.2) + sin(uv.x * 31.0 + time * 4.7)
	) * 0.0018 * intensity * (0.45 + edge * 0.8);
	uv += wave_offset;

	// 左右分离的采样会产生很轻的彩色重影，不使用整屏位移，避免眩晕过强。
	vec2 ghost_offset = vec2(
		0.0035 * sin(time * 2.7 + uv.y * 11.0),
		0.0018 * cos(time * 2.1 + uv.x * 9.0)
	) * intensity;
	vec3 base = texture(screen_texture, uv).rgb;
	vec3 ghost = vec3(
		texture(screen_texture, uv + ghost_offset).r,
		base.g,
		texture(screen_texture, uv - ghost_offset).b
	);
	vec3 color = mix(base, ghost, 0.32 * intensity);

	// 中心保留可辨识度，边缘逐渐变暗；最大暗化不会完全遮挡画面。
	float darken = dark_strength * intensity * (0.72 + edge * 0.28);
	color *= 1.0 - darken;
	COLOR = vec4(color, 1.0);
}
