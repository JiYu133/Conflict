shader_type canvas_item;
render_mode unshaded;

// Low-stamina edge darkening. The rounded frame blend keeps the vignette
// balanced on wide displays while retaining stronger coverage in the corners.
uniform float strength : hint_range(0.0, 1.0) = 0.0;
uniform float inner_radius : hint_range(0.0, 2.0) = 0.4;
uniform float outer_radius : hint_range(0.0, 2.0) = 1.2;
uniform vec4 vignette_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
	vec2 centered_uv = abs(SCREEN_UV * 2.0 - 1.0);
	float ellipse_distance = length(centered_uv);
	float frame_distance = max(centered_uv.x, centered_uv.y);
	float vignette_distance = mix(ellipse_distance, frame_distance, 0.25);

	float fade_start = min(inner_radius, outer_radius);
	float fade_end = max(inner_radius, outer_radius);
	float fade_width = max(fade_end - fade_start, 0.0001);
	float mask = smoothstep(0.0, 1.0,
		(vignette_distance - fade_start) / fade_width);
	mask = mask * mask * (3.0 - 2.0 * mask);

	float alpha = clamp(mask * strength * vignette_color.a, 0.0, 1.0);
	COLOR = vec4(vignette_color.rgb, alpha);
}
