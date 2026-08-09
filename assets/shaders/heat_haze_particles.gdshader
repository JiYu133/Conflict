shader_type spatial;

// 粒子只作为屏幕空间扭曲载体：不显示噪波颜色，不产生漫反射或金属高光。
render_mode unshaded, blend_mix, depth_draw_never, cull_disabled, fog_disabled;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear_mipmap;
uniform sampler2D depth_texture : hint_depth_texture, repeat_disable, filter_linear_mipmap;
uniform sampler2D noise_texture : repeat_enable, filter_linear_mipmap;
uniform float distortion_strength : hint_range(0.0, 0.08) = 0.03;
uniform float opacity : hint_range(0.0, 1.0) = 0.10;
uniform float flow_speed : hint_range(0.0, 2.0) = 0.22;
uniform vec2 noise_scale = vec2(0.65, 0.90);
uniform float proximity_fade_distance : hint_range(0.01, 4.0) = 0.75;

void fragment() {
	vec2 flow_uv = (UV - vec2(0.5)) * noise_scale + vec2(0.5);
	flow_uv += vec2(TIME * flow_speed * 0.08, -TIME * flow_speed);
	float noise_x = texture(noise_texture, flow_uv).r;
	float noise_y = texture(
		noise_texture,
		flow_uv + vec2(0.21, 0.34) + vec2(-TIME * flow_speed * 0.05, TIME * flow_speed * 0.13)
	).r;
	vec2 distortion = vec2(noise_x, noise_y) * 2.0 - 1.0;
	distortion = sign(distortion) * pow(abs(distortion), vec2(1.35));

	// 面片边缘柔化，避免看到矩形几何边界。
	float edge_x = smoothstep(0.0, 0.14, UV.x) * (1.0 - smoothstep(0.86, 1.0, UV.x));
	float edge_y = smoothstep(0.0, 0.12, UV.y) * (1.0 - smoothstep(0.82, 1.0, UV.y));
	float edge_mask = edge_x * edge_y;

	// 基于深度差的近似 Proximity Fade：接近墙面/地面时降低扭曲载体透明度。
	float scene_depth = texture(depth_texture, SCREEN_UV).r;
	float depth_delta = abs(scene_depth - FRAGCOORD.z);
	float proximity = smoothstep(0.0, max(proximity_fade_distance * 0.08, 0.001), depth_delta);

	vec2 screen_uv = clamp(
		SCREEN_UV + distortion * distortion_strength * edge_mask * proximity,
		vec2(0.001), vec2(0.999)
	);
	ALBEDO = texture(screen_texture, screen_uv).rgb;
	ALPHA = COLOR.a * opacity * edge_mask * proximity;
	SPECULAR = 0.0;
	ROUGHNESS = 1.0;
}
