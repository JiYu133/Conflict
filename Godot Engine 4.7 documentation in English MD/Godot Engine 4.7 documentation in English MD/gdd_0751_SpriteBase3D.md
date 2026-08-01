# SpriteBase3D

Inherits: GeometryInstance3D < VisualInstance3D < Node3D < Node < Object

Inherited By: AnimatedSprite3D, Sprite3D

2D sprite node in 3D environment.

## Description

A node that displays 2D texture information in a 3D environment. See also Sprite3D where many other properties are defined.

## Properties

float | alpha_antialiasing_edge | 0.0
AlphaAntiAliasing | alpha_antialiasing_mode | 0
AlphaCutMode | alpha_cut | 0
float | alpha_hash_scale | 1.0
float | alpha_scissor_threshold | 0.5
Axis | axis | 2
BillboardMode | billboard | 0
bool | centered | true
bool | double_sided | true
bool | fixed_size | false
bool | flip_h | false
bool | flip_v | false
Color | modulate | Color(1, 1, 1, 1)
bool | no_depth_test | false
Vector2 | offset | Vector2(0, 0)
float | pixel_size | 0.01
int | render_priority | 0
bool | shaded | false
TextureFilter | texture_filter | 3
bool | transparent | true

## Methods

TriangleMesh | generate_triangle_mesh() const
bool | get_draw_flag(flag: DrawFlags) const
Rect2 | get_item_rect() const
void | set_draw_flag(flag: DrawFlags, enabled: bool)

---

## Enumerations

enum DrawFlags
DrawFlags FLAG_TRANSPARENT = 0

If set, the texture's transparency and the opacity are used to make those parts of the sprite invisible.

DrawFlags FLAG_SHADED = 1

If set, lights in the environment affect the sprite.

DrawFlags FLAG_DOUBLE_SIDED = 2

If set, texture can be seen from the back as well. If not, the texture is invisible when looking at it from behind.

DrawFlags FLAG_DISABLE_DEPTH_TEST = 3

Disables the depth test, so this object is drawn on top of all others. However, objects drawn after it in the draw order may cover it.

DrawFlags FLAG_FIXED_SIZE = 4

Label is scaled by depth so that it always appears the same size on screen.

DrawFlags FLAG_MAX = 5

Represents the size of the DrawFlags enum.

---

enum AlphaCutMode
AlphaCutMode ALPHA_CUT_DISABLED = 0

This mode performs standard alpha blending. It can display translucent areas, but transparency sorting issues may be visible when multiple transparent materials are overlapping.

AlphaCutMode ALPHA_CUT_DISCARD = 1

This mode only allows fully transparent or fully opaque pixels. Harsh edges will be visible unless some form of screen-space antialiasing is enabled (see ProjectSettings.rendering/anti_aliasing/quality/screen_space_aa). On the bright side, this mode doesn't suffer from transparency sorting issues when multiple transparent materials are overlapping. This mode is also known as alpha testing or 1-bit transparency.

AlphaCutMode ALPHA_CUT_OPAQUE_PREPASS = 2

This mode draws fully opaque pixels in the depth prepass. This is slower than ALPHA_CUT_DISABLED or ALPHA_CUT_DISCARD, but it allows displaying translucent areas and smooth edges while using proper sorting.

AlphaCutMode ALPHA_CUT_HASH = 3

This mode draws cuts off all values below a spatially-deterministic threshold, the rest will remain opaque.

---

## Property Descriptions

float alpha_antialiasing_edge = 0.0 

- void set_alpha_antialiasing_edge(value: float)
- float get_alpha_antialiasing_edge()

Threshold at which antialiasing will be applied on the alpha channel.

---

AlphaAntiAliasing alpha_antialiasing_mode = 0 

- void set_alpha_antialiasing(value: AlphaAntiAliasing)
- AlphaAntiAliasing get_alpha_antialiasing()

The type of alpha antialiasing to apply.

---

AlphaCutMode alpha_cut = 0 

- void set_alpha_cut_mode(value: AlphaCutMode)
- AlphaCutMode get_alpha_cut_mode()

The alpha cutting mode to use for the sprite.

---

float alpha_hash_scale = 1.0 

- void set_alpha_hash_scale(value: float)
- float get_alpha_hash_scale()

The hashing scale for Alpha Hash. Recommended values between 0 and 2.

---

float alpha_scissor_threshold = 0.5 

- void set_alpha_scissor_threshold(value: float)
- float get_alpha_scissor_threshold()

Threshold at which the alpha scissor will discard values.

---

Axis axis = 2 

- void set_axis(value: Axis)
- Axis get_axis()

The direction in which the front of the texture faces.

---

BillboardMode billboard = 0 

- void set_billboard_mode(value: BillboardMode)
- BillboardMode get_billboard_mode()

The billboard mode to use for the sprite.

Note: When billboarding is enabled and the material also casts shadows, billboards will face the camera in the scene when rendering shadows. In scenes with multiple cameras, the intended shadow cannot be determined and this will result in undefined behavior. See GitHub Pull Request #72638 [https://github.com/godotengine/godot/pull/72638] for details.

---

bool centered = true 

- void set_centered(value: bool)
- bool is_centered()

If true, texture will be centered.

---

bool double_sided = true 

- void set_draw_flag(flag: DrawFlags, enabled: bool)
- bool get_draw_flag(flag: DrawFlags) const

If true, texture can be seen from the back as well, if false, it is invisible when looking at it from behind.

---

bool fixed_size = false 

- void set_draw_flag(flag: DrawFlags, enabled: bool)
- bool get_draw_flag(flag: DrawFlags) const

If true, the texture is rendered at the same size regardless of distance. The texture's size on screen is the same as if the camera was 1.0 units away from the texture's origin, regardless of the actual distance from the camera. The Camera3D's field of view (or Camera3D.size when in orthogonal/frustum mode) still affects the size the sprite is drawn at.

---

bool flip_h = false 

- void set_flip_h(value: bool)
- bool is_flipped_h()

If true, texture is flipped horizontally.

---

bool flip_v = false 

- void set_flip_v(value: bool)
- bool is_flipped_v()

If true, texture is flipped vertically.

---

Color modulate = Color(1, 1, 1, 1) 

- void set_modulate(value: Color)
- Color get_modulate()

A color value used to multiply the texture's colors. Can be used for mood-coloring or to simulate the color of ambient light.

Note: Unlike CanvasItem.modulate for 2D, colors with values above 1.0 (overbright) are not supported.

Note: If a GeometryInstance3D.material_override is defined on the SpriteBase3D, the material override must be configured to take vertex colors into account for albedo. Otherwise, the color defined in modulate will be ignored. For a BaseMaterial3D, BaseMaterial3D.vertex_color_use_as_albedo must be true. For a ShaderMaterial, ALBEDO *= COLOR.rgb; must be inserted in the shader's fragment() function.

---

bool no_depth_test = false 

- void set_draw_flag(flag: DrawFlags, enabled: bool)
- bool get_draw_flag(flag: DrawFlags) const

If true, depth testing is disabled and the object will be drawn in render order.

---

Vector2 offset = Vector2(0, 0) 

- void set_offset(value: Vector2)
- Vector2 get_offset()

The texture's drawing offset.

Note: When you increase offset.y in Sprite3D, the sprite moves upward in world space (i.e., +Y is up).

---

float pixel_size = 0.01 

- void set_pixel_size(value: float)
- float get_pixel_size()

The size of one pixel's width on the sprite to scale it in 3D.

---

int render_priority = 0 

- void set_render_priority(value: int)
- int get_render_priority()

Sets the render priority for the sprite. Higher priority objects will be sorted in front of lower priority objects.

Note: This only applies if alpha_cut is set to ALPHA_CUT_DISABLED (default value).

Note: This only applies to sorting of transparent objects. This will not impact how transparent objects are sorted relative to opaque objects. This is because opaque objects are not sorted, while transparent objects are sorted from back to front (subject to priority).

---

bool shaded = false 

- void set_draw_flag(flag: DrawFlags, enabled: bool)
- bool get_draw_flag(flag: DrawFlags) const

If true, the Light3D in the Environment has effects on the sprite.

---

TextureFilter texture_filter = 3 

- void set_texture_filter(value: TextureFilter)
- TextureFilter get_texture_filter()

Filter flags for the texture.

Note: Linear filtering may cause artifacts around the edges, which are especially noticeable on opaque textures. To prevent this, use textures with transparent or identical colors around the edges.

---

bool transparent = true 

- void set_draw_flag(flag: DrawFlags, enabled: bool)
- bool get_draw_flag(flag: DrawFlags) const

If true, the texture's transparency and the opacity are used to make those parts of the sprite invisible.

---

## Method Descriptions

TriangleMesh generate_triangle_mesh() const 

Returns a TriangleMesh with the sprite's vertices following its current configuration (such as its axis and pixel_size).

---

bool get_draw_flag(flag: DrawFlags) const 

Returns the value of the specified flag.

---

Rect2 get_item_rect() const 

Returns the rectangle representing this sprite.

---

void set_draw_flag(flag: DrawFlags, enabled: bool) 

If true, the specified flag will be enabled.
