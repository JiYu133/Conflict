shader_type canvas_item;
render_mode unshaded;

// One screen pass for pain/death blur and unconscious visual distortion.
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear_mipmap;
uniform float blur_amount : hint_range(0.0, 8.0) = 0.0;
uniform float coma_intensity : hint_range(0.0, 1.0) = 0.0;
uniform float time = 0.0;
uniform float dark_strength : hint_range(0.0, 1.0) = 0.38;
uniform vec2 hit_direction = vec2(0.0);
uniform float hit_intensity : hint_range(0.0, 1.0) = 0.0;
uniform float hit_edge_blur : hint_range(0.0, 12.0) = 8.0;

void fragment() {
	vec2 centered = abs(SCREEN_UV * 2.0 - 1.0);
	float ellipse_distance = length(centered);
	float frame_distance = max(centered.x, centered.y);
	float edge = smoothstep(0.15, 1.15,
		mix(ellipse_distance, frame_distance, 0.25));
	vec2 screen_direction = SCREEN_UV * 2.0 - 1.0;
	float direction_length = length(hit_direction);
	float directional_weight = 1.0;
	if (direction_length > 0.001 && length(screen_direction) > 0.001) {
		directional_weight = smoothstep(-0.15, 0.80,
			dot(normalize(screen_direction), hit_direction / direction_length));
	}
	float hit_edge_mask = smoothstep(0.28, 1.0, edge)
		* directional_weight * hit_intensity;

	vec2 wave_offset = vec2(
		sin(SCREEN_UV.y * 19.0 + time * 3.8) + sin(SCREEN_UV.y * 43.0 - time * 6.1),
		cos(SCREEN_UV.x * 17.0 - time * 3.2) + sin(SCREEN_UV.x * 31.0 + time * 4.7)
	) * 0.0018 * coma_intensity * (0.45 + edge * 0.8);
	vec2 uv = clamp(SCREEN_UV + wave_offset, vec2(0.001), vec2(0.999));

	vec3 center_color = texture(screen_texture, uv).rgb;
	vec3 color = center_color;
	vec3 east_color = center_color;
	vec3 west_color = center_color;
	float combined_blur = blur_amount + hit_edge_blur * hit_edge_mask;
	if (combined_blur > 0.001) {
		vec2 radius = SCREEN_PIXEL_SIZE * combined_blur * 2.0;
		east_color = texture(screen_texture, uv + vec2(radius.x, 0.0)).rgb;
		west_color = texture(screen_texture, uv - vec2(radius.x, 0.0)).rgb;
		vec3 north_color = texture(screen_texture, uv - vec2(0.0, radius.y)).rgb;
		vec3 south_color = texture(screen_texture, uv + vec2(0.0, radius.y)).rgb;
		vec3 north_east = texture(screen_texture, uv + vec2(radius.x, -radius.y)).rgb;
		vec3 north_west = texture(screen_texture, uv - radius).rgb;
		vec3 south_east = texture(screen_texture, uv + radius).rgb;
		vec3 south_west = texture(screen_texture, uv + vec2(-radius.x, radius.y)).rgb;

		color = center_color * 0.25;
		color += (east_color + west_color + north_color + south_color) * 0.125;
		color += (north_east + north_west + south_east + south_west) * 0.0625;
	}

	// Reuse horizontal blur taps for the coma color split, avoiding more samples.
	vec3 ghost = vec3(east_color.r, color.g, west_color.b);
	color = mix(color, ghost, 0.28 * coma_intensity);
	float luminance = dot(color, vec3(0.2126, 0.7152, 0.0722));
	color = mix(color, vec3(luminance), 0.20 * coma_intensity * (0.65 + edge * 0.35));
	color *= 1.0 - dark_strength * coma_intensity * (0.72 + edge * 0.28);

	COLOR = vec4(color, 1.0);
}
