# GradientTexture2D

Inherits: Texture2D < Texture < Resource < RefCounted < Object

A 2D texture that creates a pattern with colors obtained from a Gradient.

## Description

A 2D texture that obtains colors from a Gradient to fill the texture data. This texture is able to transform a color transition into different patterns such as a linear or a radial gradient. The texture is filled by interpolating colors starting from fill_from to fill_to offsets by default, but the gradient fill can be repeated to cover the entire texture.

The gradient is sampled individually for each pixel so it does not necessarily represent an exact copy of the gradient (see width and height). See also GradientTexture1D, CurveTexture and CurveXYZTexture.

## Properties

Fill | fill | 0
Vector2 | fill_from | Vector2(0, 0)
Vector2 | fill_to | Vector2(1, 0)
Gradient | gradient |
int | height | 64
Repeat | repeat | 0
bool | resource_local_to_scene | false (overrides Resource)
bool | use_hdr | false
int | width | 64

---

## Enumerations

enum Fill
Fill FILL_LINEAR = 0

The colors are linearly interpolated in a straight line.

Fill FILL_RADIAL = 1

The colors are linearly interpolated in a circular pattern.

Fill FILL_SQUARE = 2

The colors are linearly interpolated in a square pattern.

Fill FILL_CONIC = 3

The colors are linearly interpolated in a cone pattern.

---

enum Repeat
Repeat REPEAT_NONE = 0

The gradient fill is restricted to the range defined by fill_from to fill_to offsets.

Repeat REPEAT = 1

The texture is filled starting from fill_from to fill_to offsets, repeating the same pattern in both directions.

Repeat REPEAT_MIRROR = 2

The texture is filled starting from fill_from to fill_to offsets, mirroring the pattern in both directions.

---

## Property Descriptions

Fill fill = 0 

- void set_fill(value: Fill)
- Fill get_fill()

The gradient's fill type.

---

Vector2 fill_from = Vector2(0, 0) 

- void set_fill_from(value: Vector2)
- Vector2 get_fill_from()

The initial offset used to fill the texture specified in UV coordinates.

---

Vector2 fill_to = Vector2(1, 0) 

- void set_fill_to(value: Vector2)
- Vector2 get_fill_to()

The final offset used to fill the texture specified in UV coordinates.

---

Gradient gradient 

- void set_gradient(value: Gradient)
- Gradient get_gradient()

The Gradient used to fill the texture.

---

int height = 64 

- void set_height(value: int)
- int get_height()

The number of vertical color samples that will be obtained from the Gradient, which also represents the texture's height.

---

Repeat repeat = 0 

- void set_repeat(value: Repeat)
- Repeat get_repeat()

The gradient's repeat type.

---

bool use_hdr = false 

- void set_use_hdr(value: bool)
- bool is_using_hdr()

If true, the generated texture will support high dynamic range (Image.FORMAT_RGBAF format). This allows for glow effects to work if Environment.glow_enabled is true. If false, the generated texture will use low dynamic range; overbright colors will be clamped (Image.FORMAT_RGBA8 format).

---

int width = 64 

- void set_width(value: int)
- int get_width()

The number of horizontal color samples that will be obtained from the Gradient, which also represents the texture's width.
