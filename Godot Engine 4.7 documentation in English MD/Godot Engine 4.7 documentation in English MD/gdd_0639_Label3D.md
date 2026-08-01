# Label3D

Inherits: GeometryInstance3D < VisualInstance3D < Node3D < Node < Object

A node for displaying plain text in 3D space.

## Description

A node for displaying plain text in 3D space. By adjusting various properties of this node, you can configure things such as the text's appearance and whether it always faces the camera.

## Tutorials

- 3D text

## Properties

float | alpha_antialiasing_edge | 0.0
AlphaAntiAliasing | alpha_antialiasing_mode | 0
AlphaCutMode | alpha_cut | 0
float | alpha_hash_scale | 1.0
float | alpha_scissor_threshold | 0.5
AutowrapMode | autowrap_mode | 0
BitField[LineBreakFlag] | autowrap_trim_flags | 192
BillboardMode | billboard | 0
ShadowCastingSetting | cast_shadow | 0 (overrides GeometryInstance3D)
bool | double_sided | true
bool | fixed_size | false
Font | font |
int | font_size | 32
GIMode | gi_mode | 0 (overrides GeometryInstance3D)
HorizontalAlignment | horizontal_alignment | 1
BitField[JustificationFlag] | justification_flags | 163
String | language | ""
float | line_spacing | 0.0
Color | modulate | Color(1, 1, 1, 1)
bool | no_depth_test | false
Vector2 | offset | Vector2(0, 0)
Color | outline_modulate | Color(0, 0, 0, 1)
int | outline_render_priority | -1
int | outline_size | 12
float | pixel_size | 0.005
int | render_priority | 0
bool | shaded | false
StructuredTextParser | structured_text_bidi_override | 0
Array | structured_text_bidi_override_options | []
String | text | ""
Direction | text_direction | 0
TextureFilter | texture_filter | 3
bool | uppercase | false
VerticalAlignment | vertical_alignment | 1
float | width | 500.0

## Methods

TriangleMesh | generate_triangle_mesh() const
bool | get_draw_flag(flag: DrawFlags) const
void | set_draw_flag(flag: DrawFlags, enabled: bool)

---

## Enumerations

enum DrawFlags
DrawFlags FLAG_SHADED = 0

If set, lights in the environment affect the label.

DrawFlags FLAG_DOUBLE_SIDED = 1

If set, text can be seen from the back as well. If not, the text is invisible when looking at it from behind.

DrawFlags FLAG_DISABLE_DEPTH_TEST = 2

Disables the depth test, so this object is drawn on top of all others. However, objects drawn after it in the draw order may cover it.

DrawFlags FLAG_FIXED_SIZE = 3

Label is scaled by depth so that it always appears the same size on screen.

DrawFlags FLAG_MAX = 4

Represents the size of the DrawFlags enum.

---

enum AlphaCutMode
AlphaCutMode ALPHA_CUT_DISABLED = 0

This mode performs standard alpha blending. It can display translucent areas, but transparency sorting issues may be visible when multiple transparent materials are overlapping. GeometryInstance3D.cast_shadow has no effect when this transparency mode is used; the Label3D will never cast shadows.

AlphaCutMode ALPHA_CUT_DISCARD = 1

This mode only allows fully transparent or fully opaque pixels. Harsh edges will be visible unless some form of screen-space antialiasing is enabled (see ProjectSettings.rendering/anti_aliasing/quality/screen_space_aa). This mode is also known as alpha testing or 1-bit transparency.

Note: This mode might have issues with anti-aliased fonts and outlines, try adjusting alpha_scissor_threshold or using MSDF font.

Note: When using text with overlapping glyphs (e.g., cursive scripts), this mode might have transparency sorting issues between the main text and the outline.

AlphaCutMode ALPHA_CUT_OPAQUE_PREPASS = 2

This mode draws fully opaque pixels in the depth prepass. This is slower than ALPHA_CUT_DISABLED or ALPHA_CUT_DISCARD, but it allows displaying translucent areas and smooth edges while using proper sorting.

Note: When using text with overlapping glyphs (e.g., cursive scripts), this mode might have transparency sorting issues between the main text and the outline.

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

AutowrapMode autowrap_mode = 0 

- void set_autowrap_mode(value: AutowrapMode)
- AutowrapMode get_autowrap_mode()

If set to something other than TextServer.AUTOWRAP_OFF, the text gets wrapped inside the node's bounding rectangle. If you resize the node, it will change its height automatically to show all the text.

---

BitField[LineBreakFlag] autowrap_trim_flags = 192 

- void set_autowrap_trim_flags(value: BitField[LineBreakFlag])
- BitField[LineBreakFlag] get_autowrap_trim_flags()

Autowrap space trimming flags. See TextServer.BREAK_TRIM_START_EDGE_SPACES and TextServer.BREAK_TRIM_END_EDGE_SPACES for more info.

---

BillboardMode billboard = 0 

- void set_billboard_mode(value: BillboardMode)
- BillboardMode get_billboard_mode()

The billboard mode to use for the label.

---

bool double_sided = true 

- void set_draw_flag(flag: DrawFlags, enabled: bool)
- bool get_draw_flag(flag: DrawFlags) const

If true, text can be seen from the back as well, if false, it is invisible when looking at it from behind.

---

bool fixed_size = false 

- void set_draw_flag(flag: DrawFlags, enabled: bool)
- bool get_draw_flag(flag: DrawFlags) const

If true, the label is rendered at the same size regardless of distance. The label's size on screen is the same as if the camera was 1.0 units away from the label's origin, regardless of the actual distance from the camera. The Camera3D's field of view (or Camera3D.size when in orthogonal/frustum mode) still affects the size the label is drawn at.

---

Font font 

- void set_font(value: Font)
- Font get_font()

Font configuration used to display text.

---

int font_size = 32 

- void set_font_size(value: int)
- int get_font_size()

Font size of the Label3D's text. To make the font look more detailed when up close, increase font_size while decreasing pixel_size at the same time.

Higher font sizes require more time to render new characters, which can cause stuttering during gameplay.

---

HorizontalAlignment horizontal_alignment = 1 

- void set_horizontal_alignment(value: HorizontalAlignment)
- HorizontalAlignment get_horizontal_alignment()

Controls the text's horizontal alignment. Supports left, center, right, and fill (also known as justify).

---

BitField[JustificationFlag] justification_flags = 163 

- void set_justification_flags(value: BitField[JustificationFlag])
- BitField[JustificationFlag] get_justification_flags()

Line fill alignment rules.

---

String language = "" 

- void set_language(value: String)
- String get_language()

Language code used for line-breaking and text shaping algorithms. If left empty, the current locale is used instead.

---

float line_spacing = 0.0 

- void set_line_spacing(value: float)
- float get_line_spacing()

Additional vertical spacing between lines (in pixels), spacing is added to line descent. This value can be negative.

---

Color modulate = Color(1, 1, 1, 1) 

- void set_modulate(value: Color)
- Color get_modulate()

Text Color of the Label3D.

---

bool no_depth_test = false 

- void set_draw_flag(flag: DrawFlags, enabled: bool)
- bool get_draw_flag(flag: DrawFlags) const

If true, depth testing is disabled and the object will be drawn in render order.

---

Vector2 offset = Vector2(0, 0) 

- void set_offset(value: Vector2)
- Vector2 get_offset()

The text drawing offset (in pixels).

---

Color outline_modulate = Color(0, 0, 0, 1) 

- void set_outline_modulate(value: Color)
- Color get_outline_modulate()

The tint of text outline.

---

int outline_render_priority = -1 

- void set_outline_render_priority(value: int)
- int get_outline_render_priority()

Sets the render priority for the text outline. Higher priority objects will be sorted in front of lower priority objects.

Note: This only applies if alpha_cut is set to ALPHA_CUT_DISABLED (default value).

Note: This only applies to sorting of transparent objects. This will not impact how transparent objects are sorted relative to opaque objects. This is because opaque objects are not sorted, while transparent objects are sorted from back to front (subject to priority).

---

int outline_size = 12 

- void set_outline_size(value: int)
- int get_outline_size()

Text outline size.

---

float pixel_size = 0.005 

- void set_pixel_size(value: float)
- float get_pixel_size()

The size of one pixel's width on the label to scale it in 3D. To make the font look more detailed when up close, increase font_size while decreasing pixel_size at the same time.

---

int render_priority = 0 

- void set_render_priority(value: int)
- int get_render_priority()

Sets the render priority for the text. Higher priority objects will be sorted in front of lower priority objects.

Note: This only applies if alpha_cut is set to ALPHA_CUT_DISABLED (default value).

Note: This only applies to sorting of transparent objects. This will not impact how transparent objects are sorted relative to opaque objects. This is because opaque objects are not sorted, while transparent objects are sorted from back to front (subject to priority).

---

bool shaded = false 

- void set_draw_flag(flag: DrawFlags, enabled: bool)
- bool get_draw_flag(flag: DrawFlags) const

If true, the Light3D in the Environment has effects on the label.

---

StructuredTextParser structured_text_bidi_override = 0 

- void set_structured_text_bidi_override(value: StructuredTextParser)
- StructuredTextParser get_structured_text_bidi_override()

Set BiDi algorithm override for the structured text.

---

Array structured_text_bidi_override_options = [] 

- void set_structured_text_bidi_override_options(value: Array)
- Array get_structured_text_bidi_override_options()

Set additional options for BiDi override.

---

String text = "" 

- void set_text(value: String)
- String get_text()

The text to display on screen.

---

Direction text_direction = 0 

- void set_text_direction(value: Direction)
- Direction get_text_direction()

Base text writing direction.

---

TextureFilter texture_filter = 3 

- void set_texture_filter(value: TextureFilter)
- TextureFilter get_texture_filter()

Filter flags for the texture.

---

bool uppercase = false 

- void set_uppercase(value: bool)
- bool is_uppercase()

If true, all the text displays as UPPERCASE.

---

VerticalAlignment vertical_alignment = 1 

- void set_vertical_alignment(value: VerticalAlignment)
- VerticalAlignment get_vertical_alignment()

Controls the text's vertical alignment. Supports top, center, and bottom.

---

float width = 500.0 

- void set_width(value: float)
- float get_width()

Text width (in pixels), used for autowrap and fill alignment.

---

## Method Descriptions

TriangleMesh generate_triangle_mesh() const 

Returns a TriangleMesh with the label's vertices following its current configuration (such as its pixel_size).

---

bool get_draw_flag(flag: DrawFlags) const 

Returns the value of the specified flag.

---

void set_draw_flag(flag: DrawFlags, enabled: bool) 

If true, the specified flag will be enabled.
