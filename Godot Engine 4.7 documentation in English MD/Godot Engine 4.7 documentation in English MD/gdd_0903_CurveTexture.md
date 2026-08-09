# CurveTexture

Inherits: Texture2D < Texture < Resource < RefCounted < Object

A 1D texture where pixel brightness corresponds to points on a curve.

## Description

A 1D texture where pixel brightness corresponds to points on a unit Curve resource, either in grayscale or in red. This visual representation simplifies the task of saving curves as image files.

If you need to store up to 3 curves within a single texture, use CurveXYZTexture instead. See also GradientTexture1D and GradientTexture2D.

## Properties

Curve | curve |
bool | resource_local_to_scene | false (overrides Resource)
TextureMode | texture_mode | 0
int | width | 256

---

## Enumerations

enum TextureMode
TextureMode TEXTURE_MODE_RGB = 0

Store the curve equally across the red, green and blue channels. This uses more video memory, but is more compatible with shaders that only read the green and blue values.

TextureMode TEXTURE_MODE_RED = 1

Store the curve only in the red channel. This saves video memory, but some custom shaders may not be able to work with this.

---

## Property Descriptions

Curve curve 

- void set_curve(value: Curve)
- Curve get_curve()

The Curve that is rendered onto the texture. Should be a unit Curve.

---

TextureMode texture_mode = 0 

- void set_texture_mode(value: TextureMode)
- TextureMode get_texture_mode()

The format the texture should be generated with. When passing a CurveTexture as an input to a Shader, this may need to be adjusted.

---

int width = 256 

- void set_width(value: int)
- int get_width()

The width of the texture (in pixels). Higher values make it possible to represent high-frequency data better (such as sudden direction changes), at the cost of increased generation time and memory usage.
