# TextureProgressBar

Inherits: Range < Control < CanvasItem < Node < Object

Texture-based progress bar. Useful for loading screens and life or stamina bars.

## Description

TextureProgressBar works like ProgressBar, but uses up to 3 textures instead of Godot's Theme resource. It can be used to create horizontal, vertical and radial progress bars.

## Properties

int | fill_mode | 0
MouseFilter | mouse_filter | 1 (overrides Control)
bool | nine_patch_stretch | false
Vector2 | radial_center_offset | Vector2(0, 0)
float | radial_fill_degrees | 360.0
float | radial_initial_angle | 0.0
BitField[SizeFlags] | size_flags_vertical | 1 (overrides Control)
float | step | 1.0 (overrides Range)
int | stretch_margin_bottom | 0
int | stretch_margin_left | 0
int | stretch_margin_right | 0
int | stretch_margin_top | 0
Texture2D | texture_over |
Texture2D | texture_progress |
Vector2 | texture_progress_offset | Vector2(0, 0)
Texture2D | texture_under |
Color | tint_over | Color(1, 1, 1, 1)
Color | tint_progress | Color(1, 1, 1, 1)
Color | tint_under | Color(1, 1, 1, 1)

## Methods

int | get_stretch_margin(margin: Side) const
void | set_stretch_margin(margin: Side, value: int)

---

## Enumerations

enum FillMode
FillMode FILL_LEFT_TO_RIGHT = 0

The texture_progress fills from left to right.

FillMode FILL_RIGHT_TO_LEFT = 1

The texture_progress fills from right to left.

FillMode FILL_TOP_TO_BOTTOM = 2

The texture_progress fills from top to bottom.

FillMode FILL_BOTTOM_TO_TOP = 3

The texture_progress fills from bottom to top.

FillMode FILL_CLOCKWISE = 4

Turns the node into a radial bar. The texture_progress fills clockwise. See radial_center_offset, radial_initial_angle and radial_fill_degrees to control the way the bar fills up.

FillMode FILL_COUNTER_CLOCKWISE = 5

Turns the node into a radial bar. The texture_progress fills counterclockwise. See radial_center_offset, radial_initial_angle and radial_fill_degrees to control the way the bar fills up.

FillMode FILL_BILINEAR_LEFT_AND_RIGHT = 6

The texture_progress fills from the center, expanding both towards the left and the right.

FillMode FILL_BILINEAR_TOP_AND_BOTTOM = 7

The texture_progress fills from the center, expanding both towards the top and the bottom.

FillMode FILL_CLOCKWISE_AND_COUNTER_CLOCKWISE = 8

Turns the node into a radial bar. The texture_progress fills radially from the center, expanding both clockwise and counterclockwise. See radial_center_offset, radial_initial_angle and radial_fill_degrees to control the way the bar fills up.

---

## Property Descriptions

int fill_mode = 0 

- void set_fill_mode(value: int)
- int get_fill_mode()

The fill direction. See FillMode for possible values.

---

bool nine_patch_stretch = false 

- void set_nine_patch_stretch(value: bool)
- bool get_nine_patch_stretch()

If true, Godot treats the bar's textures like in NinePatchRect. Use the stretch_margin_* properties like stretch_margin_bottom to set up the nine patch's 3×3 grid. When using a radial fill_mode, this setting will only enable stretching for texture_progress, while texture_under and texture_over will be treated like in NinePatchRect.

---

Vector2 radial_center_offset = Vector2(0, 0) 

- void set_radial_center_offset(value: Vector2)
- Vector2 get_radial_center_offset()

Offsets texture_progress if fill_mode is FILL_CLOCKWISE, FILL_COUNTER_CLOCKWISE, or FILL_CLOCKWISE_AND_COUNTER_CLOCKWISE.

Note: The effective radial center always stays within the texture_progress bounds. If you need to move it outside the texture's bounds, modify the texture_progress to contain additional empty space where needed.

---

float radial_fill_degrees = 360.0 

- void set_fill_degrees(value: float)
- float get_fill_degrees()

Upper limit for the fill of texture_progress if fill_mode is FILL_CLOCKWISE, FILL_COUNTER_CLOCKWISE, or FILL_CLOCKWISE_AND_COUNTER_CLOCKWISE. When the node's value is equal to its max_value, the texture fills up to this angle.

See Range.value, Range.max_value.

---

float radial_initial_angle = 0.0 

- void set_radial_initial_angle(value: float)
- float get_radial_initial_angle()

Starting angle for the fill of texture_progress if fill_mode is FILL_CLOCKWISE, FILL_COUNTER_CLOCKWISE, or FILL_CLOCKWISE_AND_COUNTER_CLOCKWISE. When the node's value is equal to its min_value, the texture doesn't show up at all. When the value increases, the texture fills and tends towards radial_fill_degrees.

Note: radial_initial_angle is wrapped between 0 and 360 degrees (inclusive).

---

int stretch_margin_bottom = 0 

- void set_stretch_margin(margin: Side, value: int)
- int get_stretch_margin(margin: Side) const

The height of the 9-patch's bottom row. A margin of 16 means the 9-slice's bottom corners and side will have a height of 16 pixels. You can set all 4 margin values individually to create panels with non-uniform borders. Only effective if nine_patch_stretch is true.

---

int stretch_margin_left = 0 

- void set_stretch_margin(margin: Side, value: int)
- int get_stretch_margin(margin: Side) const

The width of the 9-patch's left column. Only effective if nine_patch_stretch is true.

---

int stretch_margin_right = 0 

- void set_stretch_margin(margin: Side, value: int)
- int get_stretch_margin(margin: Side) const

The width of the 9-patch's right column. Only effective if nine_patch_stretch is true.

---

int stretch_margin_top = 0 

- void set_stretch_margin(margin: Side, value: int)
- int get_stretch_margin(margin: Side) const

The height of the 9-patch's top row. Only effective if nine_patch_stretch is true.

---

Texture2D texture_over 

- void set_over_texture(value: Texture2D)
- Texture2D get_over_texture()

Texture2D that draws over the progress bar. Use it to add highlights or an upper-frame that hides part of texture_progress.

---

Texture2D texture_progress 

- void set_progress_texture(value: Texture2D)
- Texture2D get_progress_texture()

Texture2D that clips based on the node's value and fill_mode. As value increased, the texture fills up. It shows entirely when value reaches max_value. It doesn't show at all if value is equal to min_value.

The value property comes from Range. See Range.value, Range.min_value, Range.max_value.

---

Vector2 texture_progress_offset = Vector2(0, 0) 

- void set_texture_progress_offset(value: Vector2)
- Vector2 get_texture_progress_offset()

The offset of texture_progress. Useful for texture_over and texture_under with fancy borders, to avoid transparent margins in your progress texture.

---

Texture2D texture_under 

- void set_under_texture(value: Texture2D)
- Texture2D get_under_texture()

Texture2D that draws under the progress bar. The bar's background.

---

Color tint_over = Color(1, 1, 1, 1) 

- void set_tint_over(value: Color)
- Color get_tint_over()

Multiplies the color of the bar's texture_over texture. The effect is similar to CanvasItem.modulate, except it only affects this specific texture instead of the entire node.

---

Color tint_progress = Color(1, 1, 1, 1) 

- void set_tint_progress(value: Color)
- Color get_tint_progress()

Multiplies the color of the bar's texture_progress texture.

---

Color tint_under = Color(1, 1, 1, 1) 

- void set_tint_under(value: Color)
- Color get_tint_under()

Multiplies the color of the bar's texture_under texture.

---

## Method Descriptions

int get_stretch_margin(margin: Side) const 

Returns the stretch margin with the specified index. See stretch_margin_bottom and related properties.

---

void set_stretch_margin(margin: Side, value: int) 

Sets the stretch margin with the specified index. See stretch_margin_bottom and related properties.
