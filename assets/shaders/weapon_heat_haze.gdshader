shader_type spatial;

render_mode unshaded, blend_mix, depth_draw_never, cull_disabled, fog_disabled;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear_mipmap;
uniform sampler2D noise_texture : repeat_enable, filter_linear_mipmap;
uniform float distortion_strength : hint_range(0.0, 0.05) = 0.01;
uniform float opacity : hint_range(0.0, 1.0) = 0.18;
uniform float flow_speed = 0.22;
uniform vec2 noise_scale = vec2(0.65, 0.90);
uniform float heat : hint_range(0.0, 2.0) = 0.0;

void fragment() {
	// 低频大块噪波：避免把噪波纹理本身当作可见图案快速滚动。
	// 采样范围小于 1，降低重复次数；热气主要是缓慢上升并带轻微横向漂移。
	vec2 flow_uv = (UV - vec2(0.5)) * noise_scale + vec2(0.5);
	flow_uv += vec2(TIME * flow_speed * 0.08, -TIME * flow_speed);
	float noise_x = texture(noise_texture, flow_uv).r;
	float noise_y = texture(
		noise_texture,
		flow_uv + vec2(0.21, 0.34) + vec2(-TIME * flow_speed * 0.05, TIME * flow_speed * 0.13)
	).r;
	vec2 distortion = vec2(noise_x, noise_y) * 2.0 - 1.0;
	// 平滑噪波响应，进一步抑制高频、颗粒状的视觉变化。
	distortion = sign(distortion) * pow(abs(distortion), vec2(1.35));

	// 软边缘：两侧、近端和远端都使用 smoothstep，避免看到矩形平面的硬边。
	float edge_x = smoothstep(0.0, 0.16, UV.x) * (1.0 - smoothstep(0.84, 1.0, UV.x));
	float edge_y = smoothstep(0.0, 0.12, UV.y) * (1.0 - smoothstep(0.82, 1.0, UV.y));
	float center_mask = 1.0 - smoothstep(0.28, 0.62, length((UV - vec2(0.5)) * vec2(1.0, 0.72)));
	float mask = edge_x * edge_y * center_mask;
	float heat_factor = smoothstep(0.0, 1.0, clamp(heat, 0.0, 1.0));
	float strength = distortion_strength * mix(0.22, 1.0, heat_factor);
	float alpha = opacity * mix(0.18, 1.0, heat_factor) * mask;

	vec2 screen_uv = clamp(SCREEN_UV + distortion * strength * mask,
		vec2(0.001), vec2(0.999));
	ALBEDO = texture(screen_texture, screen_uv).rgb;
	ALPHA = alpha;
	SPECULAR = 0.0;
}
