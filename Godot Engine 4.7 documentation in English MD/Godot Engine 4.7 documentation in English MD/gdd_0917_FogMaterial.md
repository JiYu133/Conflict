# FogMaterial

Inherits: Material < Resource < RefCounted < Object

A material that controls how volumetric fog is rendered, to be assigned to a FogVolume.

## Description

A Material resource that can be used by FogVolumes to draw volumetric effects.

If you need more advanced effects, use a custom fog shader.

## Properties

Color | albedo | Color(1, 1, 1, 1)
float | density | 1.0
Texture3D | density_texture |
float | edge_fade | 0.1
Color | emission | Color(0, 0, 0, 1)
float | height_falloff | 0.0

---

## Property Descriptions

Color albedo = Color(1, 1, 1, 1) 

- void set_albedo(value: Color)
- Color get_albedo()

The single-scattering Color of the FogVolume. Internally, albedo is converted into single-scattering, which is additively blended with other FogVolumes and the Environment.volumetric_fog_albedo.

---

float density = 1.0 

- void set_density(value: float)
- float get_density()

The density of the FogVolume. Denser objects are more opaque, but may suffer from under-sampling artifacts that look like stripes. Negative values can be used to subtract fog from other FogVolumes or global volumetric fog.

Note: Due to limited precision, density values between -0.001 and 0.001 (exclusive) act like 0.0. This does not apply to Environment.volumetric_fog_density.

---

Texture3D density_texture 

- void set_density_texture(value: Texture3D)
- Texture3D get_density_texture()

The 3D texture that is used to scale the density of the FogVolume. This can be used to vary fog density within the FogVolume with any kind of static pattern. For animated effects, consider using a custom fog shader.

---

float edge_fade = 0.1 

- void set_edge_fade(value: float)
- float get_edge_fade()

The hardness of the edges of the FogVolume. A higher value will result in softer edges, while a lower value will result in harder edges.

---

Color emission = Color(0, 0, 0, 1) 

- void set_emission(value: Color)
- Color get_emission()

The Color of the light emitted by the FogVolume. Emitted light will not cast light or shadows on other objects, but can be useful for modulating the Color of the FogVolume independently from light sources.

---

float height_falloff = 0.0 

- void set_height_falloff(value: float)
- float get_height_falloff()

The rate by which the height-based fog decreases in density as height increases in world space. A high falloff will result in a sharp transition, while a low falloff will result in a smoother transition. A value of 0.0 results in uniform-density fog. The height threshold is determined by the height of the associated FogVolume.
