# StyleBoxTexture

Inherits: StyleBox < Resource < RefCounted < Object

A texture-based nine-patch StyleBox.

## Description

A texture-based nine-patch StyleBox, in a way similar to NinePatchRect. This stylebox performs a 3×3 scaling of a texture, where only the center cell is fully stretched. This makes it possible to design bordered styles regardless of the stylebox's size.

## Properties

AxisStretchMode | axis_stretch_horizontal | 0
AxisStretchMode | axis_stretch_vertical | 0
bool | draw_center | true
float | expand_margin_bottom | 0.0
float | expand_margin_left | 0.0
float | expand_margin_right | 0.0
float | expand_margin_top | 0.0
Color | modulate_color | Color(1, 1, 1, 1)
Rect2 | region_rect | Rect2(0, 0, 0, 0)
Texture2D | texture |
float | texture_margin_bottom | 0.0
float | texture_margin_left | 0.0
float | texture_margin_right | 0.0
float | texture_margin_top | 0.0

## Methods

float | get_expand_margin(margin: Side) const
float | get_texture_margin(margin: Side) const
void | set_expand_margin(margin: Side, size: float)
void | set_expand_margin_all(size: float)
void | set_texture_margin(margin: Side, size: float)
void | set_texture_margin_all(size: float)

---

## Enumerations

enum AxisStretchMode
AxisStretchMode AXIS_STRETCH_MODE_STRETCH = 0

Stretch the stylebox's texture. This results in visible distortion unless the texture size matches the stylebox's size perfectly.

AxisStretchMode AXIS_STRETCH_MODE_TILE = 1

Repeats the stylebox's texture to match the stylebox's size according to the nine-patch system.

AxisStretchMode AXIS_STRETCH_MODE_TILE_FIT = 2

Repeats the stylebox's texture to match the stylebox's size according to the nine-patch system. Unlike AXIS_STRETCH_MODE_TILE, the texture may be slightly stretched to make the nine-patch texture tile seamlessly.

---

## Property Descriptions

AxisStretchMode axis_stretch_horizontal = 0 

- void set_h_axis_stretch_mode(value: AxisStretchMode)
- AxisStretchMode get_h_axis_stretch_mode()

Controls how the stylebox's texture will be stretched or tiled horizontally.

---

AxisStretchMode axis_stretch_vertical = 0 

- void set_v_axis_stretch_mode(value: AxisStretchMode)
- AxisStretchMode get_v_axis_stretch_mode()

Controls how the stylebox's texture will be stretched or tiled vertically.

---

bool draw_center = true 

- void set_draw_center(value: bool)
- bool is_draw_center_enabled()

If true, the nine-patch texture's center tile will be drawn.

---

float expand_margin_bottom = 0.0 

- void set_expand_margin(margin: Side, size: float)
- float get_expand_margin(margin: Side) const

Expands the bottom margin of this style box when drawing, causing it to be drawn larger than requested.

---

float expand_margin_left = 0.0 

- void set_expand_margin(margin: Side, size: float)
- float get_expand_margin(margin: Side) const

Expands the left margin of this style box when drawing, causing it to be drawn larger than requested.

---

float expand_margin_right = 0.0 

- void set_expand_margin(margin: Side, size: float)
- float get_expand_margin(margin: Side) const

Expands the right margin of this style box when drawing, causing it to be drawn larger than requested.

---

float expand_margin_top = 0.0 

- void set_expand_margin(margin: Side, size: float)
- float get_expand_margin(margin: Side) const

Expands the top margin of this style box when drawing, causing it to be drawn larger than requested.

---

Color modulate_color = Color(1, 1, 1, 1) 

- void set_modulate(value: Color)
- Color get_modulate()

Modulates the color of the texture when this style box is drawn.

---

Rect2 region_rect = Rect2(0, 0, 0, 0) 

- void set_region_rect(value: Rect2)
- Rect2 get_region_rect()

The region to use from the texture.

This is equivalent to first wrapping the texture in an AtlasTexture with the same region.

If empty (Rect2(0, 0, 0, 0)), the whole texture is used.

---

Texture2D texture 

- void set_texture(value: Texture2D)
- Texture2D get_texture()

The texture to use when drawing this style box.

---

float texture_margin_bottom = 0.0 

- void set_texture_margin(margin: Side, size: float)
- float get_texture_margin(margin: Side) const

Increases the bottom margin of the 3×3 texture box.

A higher value means more of the source texture is considered to be part of the bottom border of the 3×3 box.

This is also the value used as fallback for StyleBox.content_margin_bottom if it is negative.

---

float texture_margin_left = 0.0 

- void set_texture_margin(margin: Side, size: float)
- float get_texture_margin(margin: Side) const

Increases the left margin of the 3×3 texture box.

A higher value means more of the source texture is considered to be part of the left border of the 3×3 box.

This is also the value used as fallback for StyleBox.content_margin_left if it is negative.

---

float texture_margin_right = 0.0 

- void set_texture_margin(margin: Side, size: float)
- float get_texture_margin(margin: Side) const

Increases the right margin of the 3×3 texture box.

A higher value means more of the source texture is considered to be part of the right border of the 3×3 box.

This is also the value used as fallback for StyleBox.content_margin_right if it is negative.

---

float texture_margin_top = 0.0 

- void set_texture_margin(margin: Side, size: float)
- float get_texture_margin(margin: Side) const

Increases the top margin of the 3×3 texture box.

A higher value means more of the source texture is considered to be part of the top border of the 3×3 box.

This is also the value used as fallback for StyleBox.content_margin_top if it is negative.

---

## Method Descriptions

float get_expand_margin(margin: Side) const 

Returns the expand margin size of the specified Side.

---

float get_texture_margin(margin: Side) const 

Returns the margin size of the specified Side.

---

void set_expand_margin(margin: Side, size: float) 

Sets the expand margin to size pixels for the specified Side.

---

void set_expand_margin_all(size: float) 

Sets the expand margin to size pixels for all sides.

---

void set_texture_margin(margin: Side, size: float) 

Sets the margin to size pixels for the specified Side.

---

void set_texture_margin_all(size: float) 

Sets the margin to size pixels for all sides.
