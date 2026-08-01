# StyleBoxFlat

Inherits: StyleBox < Resource < RefCounted < Object

A customizable StyleBox that doesn't use a texture.

## Description

By configuring various properties of this style box, you can achieve many common looks without the need of a texture. This includes optionally rounded borders, antialiasing, shadows, and skew.

Setting corner radius to high values is allowed. As soon as corners overlap, the stylebox will switch to a relative system:

```
height = 30
corner_radius_top_left = 50
corner_radius_bottom_left = 100
```

The relative system now would take the 1:2 ratio of the two left corners to calculate the actual corner width. Both corners added will never be more than the height. Result:

```
corner_radius_top_left: 10
corner_radius_bottom_left: 20
```

## Properties

bool | anti_aliasing | true
float | anti_aliasing_size | 1.0
Color | bg_color | Color(0.6, 0.6, 0.6, 1)
bool | border_blend | false
Color | border_color | Color(0.8, 0.8, 0.8, 1)
int | border_width_bottom | 0
int | border_width_left | 0
int | border_width_right | 0
int | border_width_top | 0
int | corner_detail | 8
int | corner_radius_bottom_left | 0
int | corner_radius_bottom_right | 0
int | corner_radius_top_left | 0
int | corner_radius_top_right | 0
bool | draw_center | true
float | expand_margin_bottom | 0.0
float | expand_margin_left | 0.0
float | expand_margin_right | 0.0
float | expand_margin_top | 0.0
Color | shadow_color | Color(0, 0, 0, 0.6)
Vector2 | shadow_offset | Vector2(0, 0)
int | shadow_size | 0
Vector2 | skew | Vector2(0, 0)

## Methods

int | get_border_width(margin: Side) const
int | get_border_width_min() const
int | get_corner_radius(corner: Corner) const
float | get_expand_margin(margin: Side) const
void | set_border_width(margin: Side, width: int)
void | set_border_width_all(width: int)
void | set_corner_radius(corner: Corner, radius: int)
void | set_corner_radius_all(radius: int)
void | set_expand_margin(margin: Side, size: float)
void | set_expand_margin_all(size: float)

---

## Property Descriptions

bool anti_aliasing = true 

- void set_anti_aliased(value: bool)
- bool is_anti_aliased()

Antialiasing draws a small ring around the edges, which fades to transparency. As a result, edges look much smoother. This is only noticeable when using rounded corners or skew.

Note: When using beveled corners with 45-degree angles (corner_detail = 1), it is recommended to set anti_aliasing to false to ensure crisp visuals and avoid possible visual glitches.

---

float anti_aliasing_size = 1.0 

- void set_aa_size(value: float)
- float get_aa_size()

This changes the size of the antialiasing effect. 1.0 is recommended for an optimal result at 100% scale, identical to how rounded rectangles are rendered in web browsers and most vector drawing software.

Note: Higher values may produce a blur effect but can also create undesired artifacts on small boxes with large-radius corners.

---

Color bg_color = Color(0.6, 0.6, 0.6, 1) 

- void set_bg_color(value: Color)
- Color get_bg_color()

The background color of the stylebox.

---

bool border_blend = false 

- void set_border_blend(value: bool)
- bool get_border_blend()

If true, the border will fade into the background color.

---

Color border_color = Color(0.8, 0.8, 0.8, 1) 

- void set_border_color(value: Color)
- Color get_border_color()

Sets the color of the border.

---

int border_width_bottom = 0 

- void set_border_width(margin: Side, width: int)
- int get_border_width(margin: Side) const

Border width for the bottom border.

---

int border_width_left = 0 

- void set_border_width(margin: Side, width: int)
- int get_border_width(margin: Side) const

Border width for the left border.

---

int border_width_right = 0 

- void set_border_width(margin: Side, width: int)
- int get_border_width(margin: Side) const

Border width for the right border.

---

int border_width_top = 0 

- void set_border_width(margin: Side, width: int)
- int get_border_width(margin: Side) const

Border width for the top border.

---

int corner_detail = 8 

- void set_corner_detail(value: int)
- int get_corner_detail()

This sets the number of vertices used for each corner. Higher values result in rounder corners but take more processing power to compute. When choosing a value, you should take the corner radius (set_corner_radius_all()) into account.

For corner radii less than 10, 4 or 5 should be enough. For corner radii less than 30, values between 8 and 12 should be enough.

A corner detail of 1 will result in chamfered corners instead of rounded corners, which is useful for some artistic effects.

---

int corner_radius_bottom_left = 0 

- void set_corner_radius(corner: Corner, radius: int)
- int get_corner_radius(corner: Corner) const

The bottom-left corner's radius. If 0, the corner is not rounded.

---

int corner_radius_bottom_right = 0 

- void set_corner_radius(corner: Corner, radius: int)
- int get_corner_radius(corner: Corner) const

The bottom-right corner's radius. If 0, the corner is not rounded.

---

int corner_radius_top_left = 0 

- void set_corner_radius(corner: Corner, radius: int)
- int get_corner_radius(corner: Corner) const

The top-left corner's radius. If 0, the corner is not rounded.

---

int corner_radius_top_right = 0 

- void set_corner_radius(corner: Corner, radius: int)
- int get_corner_radius(corner: Corner) const

The top-right corner's radius. If 0, the corner is not rounded.

---

bool draw_center = true 

- void set_draw_center(value: bool)
- bool is_draw_center_enabled()

Toggles drawing of the inner part of the stylebox.

---

float expand_margin_bottom = 0.0 

- void set_expand_margin(margin: Side, size: float)
- float get_expand_margin(margin: Side) const

Expands the stylebox outside of the control rect on the bottom edge. Useful in combination with border_width_bottom to draw a border outside the control rect.

Note: Unlike StyleBox.content_margin_bottom, expand_margin_bottom does not affect the size of the clickable area for Controls. This can negatively impact usability if used wrong, as the user may try to click an area of the StyleBox that cannot actually receive clicks.

---

float expand_margin_left = 0.0 

- void set_expand_margin(margin: Side, size: float)
- float get_expand_margin(margin: Side) const

Expands the stylebox outside of the control rect on the left edge. Useful in combination with border_width_left to draw a border outside the control rect.

Note: Unlike StyleBox.content_margin_left, expand_margin_left does not affect the size of the clickable area for Controls. This can negatively impact usability if used wrong, as the user may try to click an area of the StyleBox that cannot actually receive clicks.

---

float expand_margin_right = 0.0 

- void set_expand_margin(margin: Side, size: float)
- float get_expand_margin(margin: Side) const

Expands the stylebox outside of the control rect on the right edge. Useful in combination with border_width_right to draw a border outside the control rect.

Note: Unlike StyleBox.content_margin_right, expand_margin_right does not affect the size of the clickable area for Controls. This can negatively impact usability if used wrong, as the user may try to click an area of the StyleBox that cannot actually receive clicks.

---

float expand_margin_top = 0.0 

- void set_expand_margin(margin: Side, size: float)
- float get_expand_margin(margin: Side) const

Expands the stylebox outside of the control rect on the top edge. Useful in combination with border_width_top to draw a border outside the control rect.

Note: Unlike StyleBox.content_margin_top, expand_margin_top does not affect the size of the clickable area for Controls. This can negatively impact usability if used wrong, as the user may try to click an area of the StyleBox that cannot actually receive clicks.

---

Color shadow_color = Color(0, 0, 0, 0.6) 

- void set_shadow_color(value: Color)
- Color get_shadow_color()

The color of the shadow. This has no effect if shadow_size is lower than 1.

---

Vector2 shadow_offset = Vector2(0, 0) 

- void set_shadow_offset(value: Vector2)
- Vector2 get_shadow_offset()

The shadow offset in pixels. Adjusts the position of the shadow relatively to the stylebox.

---

int shadow_size = 0 

- void set_shadow_size(value: int)
- int get_shadow_size()

The shadow size in pixels.

---

Vector2 skew = Vector2(0, 0) 

- void set_skew(value: Vector2)
- Vector2 get_skew()

If set to a non-zero value on either axis, skew distorts the StyleBox horizontally and/or vertically. This can be used for "futuristic"-style UIs. Positive values skew the StyleBox towards the right (X axis) and upwards (Y axis), while negative values skew the StyleBox towards the left (X axis) and downwards (Y axis).

Note: To ensure text does not touch the StyleBox's edges, consider increasing the StyleBox's content margin (see StyleBox.content_margin_bottom). It is preferable to increase the content margin instead of the expand margin (see expand_margin_bottom), as increasing the expand margin does not increase the size of the clickable area for Controls.

---

## Method Descriptions

int get_border_width(margin: Side) const 

Returns the specified Side's border width.

---

int get_border_width_min() const 

Returns the smallest border width out of all four borders.

---

int get_corner_radius(corner: Corner) const 

Returns the given corner's radius.

---

float get_expand_margin(margin: Side) const 

Returns the size of the specified Side's expand margin.

---

void set_border_width(margin: Side, width: int) 

Sets the specified Side's border width to width pixels.

---

void set_border_width_all(width: int) 

Sets the border width to width pixels for all sides.

---

void set_corner_radius(corner: Corner, radius: int) 

Sets the corner radius to radius pixels for the given corner.

---

void set_corner_radius_all(radius: int) 

Sets the corner radius to radius pixels for all corners.

---

void set_expand_margin(margin: Side, size: float) 

Sets the expand margin to size pixels for the specified Side.

---

void set_expand_margin_all(size: float) 

Sets the expand margin to size pixels for all sides.
