// 全屏高斯模糊，用于死亡后视觉效果
// 采样 BackBufferCopy 的屏幕纹理，做 9-tap 分离式高斯模糊

shader_type canvas_item;

uniform float blur_amount : hint_range(0.0, 8.0) = 0.0;
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

void fragment() {
	if (blur_amount < 0.001) {
		COLOR = vec4(0.0);
		return;
	}

	vec2 ps = SCREEN_PIXEL_SIZE * blur_amount;
	vec4 col = vec4(0.0);

	// 3×3 高斯核，权重归一化
	float w0 = 0.36, w1 = 0.12, w2 = 0.04;
	col += texture(screen_texture, SCREEN_UV + vec2(-2.0, -2.0) * ps) * w2;
	col += texture(screen_texture, SCREEN_UV + vec2( 0.0, -2.0) * ps) * w1;
	col += texture(screen_texture, SCREEN_UV + vec2( 2.0, -2.0) * ps) * w2;
	col += texture(screen_texture, SCREEN_UV + vec2(-2.0,  0.0) * ps) * w1;
	col += texture(screen_texture, SCREEN_UV + vec2( 0.0,  0.0) * ps) * w0;
	col += texture(screen_texture, SCREEN_UV + vec2( 2.0,  0.0) * ps) * w1;
	col += texture(screen_texture, SCREEN_UV + vec2(-2.0,  2.0) * ps) * w2;
	col += texture(screen_texture, SCREEN_UV + vec2( 0.0,  2.0) * ps) * w1;
	col += texture(screen_texture, SCREEN_UV + vec2( 2.0,  2.0) * ps) * w2;

	// alpha 控制叠加强度，由 GDScript 通过 modulate.a 驱动
	COLOR = vec4(col.rgb, 1.0);
}
