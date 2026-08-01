# PointLight2D

Inherits: Light2D < Node2D < CanvasItem < Node < Object

Positional 2D light source.

## Description

Casts light in a 2D environment. This light's shape is defined by a (usually grayscale) texture.

## Tutorials

- 2D lights and shadows

## Properties

float | height | 0.0
Vector2 | offset | Vector2(0, 0)
Texture2D | texture |
float | texture_scale | 1.0

---

## Property Descriptions

float height = 0.0 

- void set_height(value: float)
- float get_height()

The height of the light. Used with 2D normal mapping. The units are in pixels, e.g. if the height is 100, then it will illuminate an object 100 pixels away at a 45° angle to the plane.

---

Vector2 offset = Vector2(0, 0) 

- void set_texture_offset(value: Vector2)
- Vector2 get_texture_offset()

The offset of the light's texture.

---

Texture2D texture 

- void set_texture(value: Texture2D)
- Texture2D get_texture()

Texture2D used for the light's appearance.

---

float texture_scale = 1.0 

- void set_texture_scale(value: float)
- float get_texture_scale()

The texture's scale factor.
