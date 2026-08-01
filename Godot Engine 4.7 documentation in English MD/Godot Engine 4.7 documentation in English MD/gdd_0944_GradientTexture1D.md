# GradientTexture1D

Inherits: Texture2D < Texture < Resource < RefCounted < Object

A 1D texture that uses colors obtained from a Gradient.

## Description

A 1D texture that obtains colors from a Gradient to fill the texture data. The texture is filled by sampling the gradient for each pixel. Therefore, the texture does not necessarily represent an exact copy of the gradient, as it may miss some colors if there are not enough pixels. See also GradientTexture2D, CurveTexture and CurveXYZTexture.

## Properties

Gradient | gradient |
bool | resource_local_to_scene | false (overrides Resource)
bool | use_hdr | false
int | width | 256

---

## Property Descriptions

Gradient gradient 

- void set_gradient(value: Gradient)
- Gradient get_gradient()

The Gradient used to fill the texture.

---

bool use_hdr = false 

- void set_use_hdr(value: bool)
- bool is_using_hdr()

If true, the generated texture will support high dynamic range (Image.FORMAT_RGBAF format). This allows for glow effects to work if Environment.glow_enabled is true. If false, the generated texture will use low dynamic range; overbright colors will be clamped (Image.FORMAT_RGBA8 format).

---

int width = 256 

- void set_width(value: int)
- int get_width()

The number of color samples that will be obtained from the Gradient.
