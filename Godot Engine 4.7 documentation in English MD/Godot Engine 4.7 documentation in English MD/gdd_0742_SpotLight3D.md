# SpotLight3D

Inherits: Light3D < VisualInstance3D < Node3D < Node < Object

A spotlight, such as a reflector spotlight or a lantern.

## Description

A Spotlight is a type of Light3D node that emits lights in a specific direction, in the shape of a cone. The light is attenuated through the distance. This attenuation can be configured by changing the energy, radius and attenuation parameters of Light3D.

Light is emitted in the -Z direction of the node's global basis. For an unrotated light, this means that the light is emitted forwards, illuminating the front side of a 3D model (see Vector3.FORWARD and Vector3.MODEL_FRONT).

Note: When using the Mobile rendering method, only 8 spot lights can be displayed on each mesh resource. Attempting to display more than 8 spot lights on a single mesh resource will result in spot lights flickering in and out as the camera moves. When using the Compatibility rendering method, only 8 spot lights can be displayed on each mesh resource by default, but this can be increased by adjusting ProjectSettings.rendering/limits/opengl/max_lights_per_object.

Note: When using the Mobile or Compatibility rendering methods, spot lights will only correctly affect meshes whose visibility AABB intersects with the light's AABB. If using a shader to deform the mesh in a way that makes it go outside its AABB, GeometryInstance3D.extra_cull_margin must be increased on the mesh. Otherwise, the light may not be visible on the mesh.

## Tutorials

- 3D lights and shadows
- Faking global illumination
- Third Person Shooter (TPS) Demo [https://godotengine.org/asset-library/asset/2710]

## Properties

float | light_specular | 0.5 (overrides Light3D)
float | shadow_bias | 0.03 (overrides Light3D)
float | shadow_normal_bias | 1.0 (overrides Light3D)
float | spot_angle | 45.0
float | spot_angle_attenuation | 1.0
float | spot_attenuation | 1.0
float | spot_range | 5.0

---

## Property Descriptions

float spot_angle = 45.0 

- void set_param(value: float)
- float get_param()

The spotlight's angle in degrees. This is the angular radius, meaning the angle from the -Z axis, the cone's center, to the edge of the cone. The default angular radius of 45 degrees corresponds to a cone with an angular diameter of 90 degrees.

Note: spot_angle is not affected by Node3D.scale (the light's scale or its parent's scale).

---

float spot_angle_attenuation = 1.0 

- void set_param(value: float)
- float get_param()

The spotlight's angular attenuation curve. See also spot_attenuation.

---

float spot_attenuation = 1.0 

- void set_param(value: float)
- float get_param()

Controls the distance attenuation function for spotlights.

A value of 0.0 will maintain a constant brightness through most of the range, but smoothly attenuate the light at the edge of the range. Use a value of 2.0 for physically accurate lights as it results in the proper inverse square attenutation.

Note: Setting attenuation to 2.0 or higher may result in distant objects receiving minimal light, even within range. For example, with a range of 4096, an object at 100 units is attenuated by a factor of 0.0001. With a default brightness of 1, the light would not be visible at that distance.

Note: Using negative or values higher than 10.0 may lead to unexpected results.

---

float spot_range = 5.0 

- void set_param(value: float)
- float get_param()

The maximal range that can be reached by the spotlight. Note that the effectively lit area may appear to be smaller depending on the spot_attenuation in use. No matter the spot_attenuation in use, the light will never reach anything outside this range.

Note: spot_range is not affected by Node3D.scale (the light's scale or its parent's scale).
