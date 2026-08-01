# CurveXYZTexture

Inherits: Texture2D < Texture < Resource < RefCounted < Object

A 1D texture where the red, green, and blue color channels correspond to points on 3 curves.

## Description

A 1D texture where the red, green, and blue color channels correspond to points on 3 unit Curve resources. Compared to using separate CurveTextures, this further simplifies the task of saving curves as image files.

If you only need to store one curve within a single texture, use CurveTexture instead. See also GradientTexture1D and GradientTexture2D.

## Properties

Curve | curve_x |
Curve | curve_y |
Curve | curve_z |
bool | resource_local_to_scene | false (overrides Resource)
int | width | 256

---

## Property Descriptions

Curve curve_x 

- void set_curve_x(value: Curve)
- Curve get_curve_x()

The Curve that is rendered onto the texture's red channel. Should be a unit Curve.

---

Curve curve_y 

- void set_curve_y(value: Curve)
- Curve get_curve_y()

The Curve that is rendered onto the texture's green channel. Should be a unit Curve.

---

Curve curve_z 

- void set_curve_z(value: Curve)
- Curve get_curve_z()

The Curve that is rendered onto the texture's blue channel. Should be a unit Curve.

---

int width = 256 

- void set_width(value: int)
- int get_width()

The width of the texture (in pixels). Higher values make it possible to represent high-frequency data better (such as sudden direction changes), at the cost of increased generation time and memory usage.
