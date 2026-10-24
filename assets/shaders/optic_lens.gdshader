shader_type spatial;
render_mode unshaded, cull_disabled;

uniform sampler2D optic_texture : filter_linear;
uniform float eye_visibility = 1.0;
uniform vec2 eye_offset = vec2(0.0);
uniform float eye_shadow = 0.0;

void fragment() {
	vec2 aperture_uv = (UV - vec2(0.5)) * 2.0 + clamp(eye_offset, vec2(-2.0), vec2(2.0)) * 0.35;
	float edge = 1.0 - smoothstep(0.75, 1.0, length(aperture_uv));
	float aperture = mix(1.0, edge, eye_shadow);
	ALBEDO = texture(optic_texture, UV).rgb * eye_visibility * aperture;
}
