# AreaLight3D

Inherits: Light3D < VisualInstance3D < Node3D < Node < Object

An area light, such as a neon light tube or a screen.

## Description

An area light is a type of Light3D node that emits light over a two-dimensional area, in the shape of a rectangle. The light is attenuated throughout the distance. This attenuation can be configured by changing the energy, area_attenuation, and area_range.

Light is emitted in the -Z direction of the node's global basis. For an unrotated light, this means that the light is emitted forwards, illuminating the front side of a 3D model (see Vector3.FORWARD and Vector3.MODEL_FRONT).

Area lights can cast soft shadows using PCSS, which you can control by tweaking the size parameter. The shadow map is drawn from the center of the light.

Note: Area lights have limited support in the Mobile and Compatibility renderers. In the Mobile renderer, the size of the penumbra doesn't vary as it should with PCSS. In Compatibility, area lights cannot cast shadows.

Warning: Shadows cast by an area light may look incorrect if the object casting shadows doesn't have enough subdivisions and it's very close to the area light. This is the same limitation as the Dual Paraboloid shadow mode on an OmniLight3D.

Performance: Area lights are more demanding on the GPU compared to omni and spot lights. In Forward+, there is an additional GPU cost on all rendered objects as soon as one area light is present in the view frustum (due to the nature of clustered lighting). Consider using them only for cinematics or when targeting high-end devices.

## Tutorials

- 3D lights and shadows

## Properties

float | area_attenuation | 1.0
bool | area_normalize_energy | true
float | area_range | 5.0
Vector2 | area_size | Vector2(1, 1)
Texture2D | area_texture |
float | light_size | 0.5 (overrides Light3D)
float | shadow_normal_bias | 1.0 (overrides Light3D)

---

## Property Descriptions

float area_attenuation = 1.0 

- void set_param(value: float)
- float get_param()

Controls the distance attenuation function for this area light.

A value of 0.0 will maintain a constant brightness through most of the range, but will smoothly attenuate the light at the edge of the range. Use a value of 2.0 for physically accurate lights as it results in the proper inverse square attenuation.

Note: Setting attenuation to 2.0 or higher may result in distant objects receiving minimal light, even when within range. For example, with a range of 4096, an object at 100 units is attenuated by a factor of 0.0001. With a default brightness of 1, the light would not be visible at that distance.

Note: Using negative values or values higher than 10.0 may lead to unexpected results.

---

bool area_normalize_energy = true 

- void set_area_normalize_energy(value: bool)
- bool is_area_normalizing_energy()

Defines whether the energy is normalized (divided) by the surface area of the light. If set to true, changing the size does not affect the total energy output, and does not dramatically alter the brightness of the scene.

---

float area_range = 5.0 

- void set_param(value: float)
- float get_param()

The range of the area in meters. This determines the maximum distance from any point on the area at which the area can still emit light.

---

Vector2 area_size = Vector2(1, 1) 

- void set_area_size(value: Vector2)
- Vector2 get_area_size()

The extents (width and height) of the area in meters.

---

Texture2D area_texture 

- void set_area_texture(value: Texture2D)
- Texture2D get_area_texture()

An optional texture to use as a light source. Changing the texture at runtime might impact performance, as it needs to be drawn to the area light atlas with filtered mipmaps.

If no texture is assigned, the area light emits uniform light across its surface.

Note: Area light textures are only supported in the Forward+ and Mobile rendering methods, not Compatibility. To reduce the performance impact of switching textures at runtime, make sure each dimension of an area texture is either a multiple of 128 pixels, or a power of two. This removes the need for a scaling pass, which slows down texture changes. The textures don't necessarily have to be square to be optimal. Examples of optimal texture sizes include 32x64, 128x128, and 256x384.
