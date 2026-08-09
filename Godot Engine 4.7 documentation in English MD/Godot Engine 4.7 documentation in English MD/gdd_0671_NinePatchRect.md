# NinePatchRect

Inherits: Control < CanvasItem < Node < Object

A control that displays a texture by keeping its corners intact, but tiling its edges and center.

## Description

Also known as 9-slice panels, NinePatchRect produces clean panels of any size based on a small texture. To do so, it splits the texture in a 3×3 grid. When you scale the node, it tiles the texture's edges horizontally or vertically, tiles the center on both axes, and leaves the corners unchanged.

## Properties

AxisStretchMode | axis_stretch_horizontal | 0
AxisStretchMode | axis_stretch_vertical | 0
bool | draw_center | true
MouseFilter | mouse_filter | 2 (overrides Control)
int | patch_margin_bottom | 0
int | patch_margin_left | 0
int | patch_margin_right | 0
int | patch_margin_top | 0
Rect2 | region_rect | Rect2(0, 0, 0, 0)
Texture2D | texture |

## Methods

int | get_patch_margin(margin: Side) const
void | set_patch_margin(margin: Side, value: int)

---

## Signals

texture_changed() 

Emitted when the node's texture changes.

---

## Enumerations

enum AxisStretchMode
AxisStretchMode AXIS_STRETCH_MODE_STRETCH = 0

Stretches the center texture across the NinePatchRect. This may cause the texture to be distorted.

AxisStretchMode AXIS_STRETCH_MODE_TILE = 1

Repeats the center texture across the NinePatchRect. This won't cause any visible distortion. The texture must be seamless for this to work without displaying artifacts between edges.

AxisStretchMode AXIS_STRETCH_MODE_TILE_FIT = 2

Repeats the center texture across the NinePatchRect, but will also stretch the texture to make sure each tile is visible in full. This may cause the texture to be distorted, but less than AXIS_STRETCH_MODE_STRETCH. The texture must be seamless for this to work without displaying artifacts between edges.

---

## Property Descriptions

AxisStretchMode axis_stretch_horizontal = 0 

- void set_h_axis_stretch_mode(value: AxisStretchMode)
- AxisStretchMode get_h_axis_stretch_mode()

The stretch mode to use for horizontal stretching/tiling.

---

AxisStretchMode axis_stretch_vertical = 0 

- void set_v_axis_stretch_mode(value: AxisStretchMode)
- AxisStretchMode get_v_axis_stretch_mode()

The stretch mode to use for vertical stretching/tiling.

---

bool draw_center = true 

- void set_draw_center(value: bool)
- bool is_draw_center_enabled()

If true, draw the panel's center. Else, only draw the 9-slice's borders.

---

int patch_margin_bottom = 0 

- void set_patch_margin(margin: Side, value: int)
- int get_patch_margin(margin: Side) const

The height of the 9-slice's bottom row. A margin of 16 means the 9-slice's bottom corners and side will have a height of 16 pixels. You can set all 4 margin values individually to create panels with non-uniform borders.

---

int patch_margin_left = 0 

- void set_patch_margin(margin: Side, value: int)
- int get_patch_margin(margin: Side) const

The width of the 9-slice's left column. A margin of 16 means the 9-slice's left corners and side will have a width of 16 pixels. You can set all 4 margin values individually to create panels with non-uniform borders.

---

int patch_margin_right = 0 

- void set_patch_margin(margin: Side, value: int)
- int get_patch_margin(margin: Side) const

The width of the 9-slice's right column. A margin of 16 means the 9-slice's right corners and side will have a width of 16 pixels. You can set all 4 margin values individually to create panels with non-uniform borders.

---

int patch_margin_top = 0 

- void set_patch_margin(margin: Side, value: int)
- int get_patch_margin(margin: Side) const

The height of the 9-slice's top row. A margin of 16 means the 9-slice's top corners and side will have a height of 16 pixels. You can set all 4 margin values individually to create panels with non-uniform borders.

---

Rect2 region_rect = Rect2(0, 0, 0, 0) 

- void set_region_rect(value: Rect2)
- Rect2 get_region_rect()

Rectangular region of the texture to sample from. If you're working with an atlas, use this property to define the area the 9-slice should use. All other properties are relative to this one. If the rect is empty, NinePatchRect will use the whole texture.

---

Texture2D texture 

- void set_texture(value: Texture2D)
- Texture2D get_texture()

The node's texture resource.

---

## Method Descriptions

int get_patch_margin(margin: Side) const 

Returns the size of the margin on the specified Side.

---

void set_patch_margin(margin: Side, value: int) 

Sets the size of the margin on the specified Side to value pixels.
