# XRVRS

Inherits: Object

Helper class for XR interfaces that generates VRS images.

## Description

This class is used by various XR interfaces to generate VRS textures that can be used to speed up rendering.

## Properties

float | vrs_min_radius | 20.0
Rect2i | vrs_render_region | Rect2i(0, 0, 0, 0)
float | vrs_strength | 1.0

## Methods

RID | make_vrs_texture(target_size: Vector2, eye_foci: PackedVector2Array)

---

## Property Descriptions

float vrs_min_radius = 20.0 

- void set_vrs_min_radius(value: float)
- float get_vrs_min_radius()

The minimum radius around the focal point where full quality is guaranteed if VRS is used as a percentage of screen size.

---

Rect2i vrs_render_region = Rect2i(0, 0, 0, 0) 

- void set_vrs_render_region(value: Rect2i)
- Rect2i get_vrs_render_region()

The render region that the VRS texture will be scaled to when generated.

---

float vrs_strength = 1.0 

- void set_vrs_strength(value: float)
- float get_vrs_strength()

The strength used to calculate the VRS density map. The greater this value, the more noticeable VRS is.

---

## Method Descriptions

RID make_vrs_texture(target_size: Vector2, eye_foci: PackedVector2Array) 

Generates the VRS texture based on a render target_size adjusted by our VRS tile size. For each eyes focal point passed in eye_foci a layer is created. Focal point should be in NDC.

The result will be cached, requesting a VRS texture with unchanged parameters and settings will return the cached RID.
