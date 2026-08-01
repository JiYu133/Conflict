# DirectionalLight3D

Inherits: Light3D < VisualInstance3D < Node3D < Node < Object

Directional light from a distance, as from the Sun.

## Description

A directional light is a type of Light3D node that models an infinite number of parallel rays covering the entire scene. It is used for lights with strong intensity that are located far away from the scene to model sunlight or moonlight.

Light is emitted in the -Z direction of the node's global basis. For an unrotated light, this means that the light is emitted forwards, illuminating the front side of a 3D model (see Vector3.FORWARD and Vector3.MODEL_FRONT). The position of the node is ignored; only the basis is used to determine light direction.

## Tutorials

- 3D lights and shadows
- Faking global illumination

## Properties

bool | directional_shadow_blend_splits | false
float | directional_shadow_fade_start | 0.8
float | directional_shadow_max_distance | 100.0
ShadowMode | directional_shadow_mode | 2
float | directional_shadow_pancake_size | 20.0
float | directional_shadow_split_1 | 0.1
float | directional_shadow_split_2 | 0.2
float | directional_shadow_split_3 | 0.5
SkyMode | sky_mode | 0

---

## Enumerations

enum ShadowMode
ShadowMode SHADOW_ORTHOGONAL = 0

Renders the entire scene's shadow map from an orthogonal point of view. This is the fastest directional shadow mode. May result in blurrier shadows on close objects.

ShadowMode SHADOW_PARALLEL_2_SPLITS = 1

Splits the view frustum in 2 areas, each with its own shadow map. This shadow mode is a compromise between SHADOW_ORTHOGONAL and SHADOW_PARALLEL_4_SPLITS in terms of performance.

ShadowMode SHADOW_PARALLEL_4_SPLITS = 2

Splits the view frustum in 4 areas, each with its own shadow map. This is the slowest directional shadow mode.

---

enum SkyMode
SkyMode SKY_MODE_LIGHT_AND_SKY = 0

Makes the light visible in both scene lighting and sky rendering.

SkyMode SKY_MODE_LIGHT_ONLY = 1

Makes the light visible in scene lighting only (including direct lighting and global illumination). When using this mode, the light will not be visible from sky shaders.

SkyMode SKY_MODE_SKY_ONLY = 2

Makes the light visible to sky shaders only. When using this mode the light will not cast light into the scene (either through direct lighting or through global illumination), but can be accessed through sky shaders. This can be useful, for example, when you want to control sky effects without illuminating the scene (during a night cycle, for example).

---

## Property Descriptions

bool directional_shadow_blend_splits = false 

- void set_blend_splits(value: bool)
- bool is_blend_splits_enabled()

If true, shadow detail is sacrificed in exchange for smoother transitions between splits. Enabling shadow blend splitting also has a moderate performance cost. This is ignored when directional_shadow_mode is SHADOW_ORTHOGONAL.

---

float directional_shadow_fade_start = 0.8 

- void set_param(value: float)
- float get_param()

Proportion of directional_shadow_max_distance at which point the shadow starts to fade. At directional_shadow_max_distance, the shadow will disappear. The default value is a balance between smooth fading and distant shadow visibility. If the camera moves fast and the directional_shadow_max_distance is low, consider lowering directional_shadow_fade_start below 0.8 to make shadow transitions less noticeable. On the other hand, if you tuned directional_shadow_max_distance to cover the entire scene, you can set directional_shadow_fade_start to 1.0 to prevent the shadow from fading in the distance (it will suddenly cut off instead).

---

float directional_shadow_max_distance = 100.0 

- void set_param(value: float)
- float get_param()

The maximum distance for shadow splits. Increasing this value will make directional shadows visible from further away, at the cost of lower overall shadow detail and performance (since more objects need to be included in the directional shadow rendering).

---

ShadowMode directional_shadow_mode = 2 

- void set_shadow_mode(value: ShadowMode)
- ShadowMode get_shadow_mode()

The light's shadow rendering algorithm.

---

float directional_shadow_pancake_size = 20.0 

- void set_param(value: float)
- float get_param()

Sets the size of the directional shadow pancake. The pancake offsets the start of the shadow's camera frustum to provide a higher effective depth resolution for the shadow. However, a high pancake size can cause artifacts in the shadows of large objects that are close to the edge of the frustum. Reducing the pancake size can help. Setting the size to 0 turns off the pancaking effect.

---

float directional_shadow_split_1 = 0.1 

- void set_param(value: float)
- float get_param()

The distance from camera to shadow split 1. Relative to directional_shadow_max_distance. Only used when directional_shadow_mode is SHADOW_PARALLEL_2_SPLITS or SHADOW_PARALLEL_4_SPLITS.

---

float directional_shadow_split_2 = 0.2 

- void set_param(value: float)
- float get_param()

The distance from shadow split 1 to split 2. Relative to directional_shadow_max_distance. Only used when directional_shadow_mode is SHADOW_PARALLEL_4_SPLITS.

---

float directional_shadow_split_3 = 0.5 

- void set_param(value: float)
- float get_param()

The distance from shadow split 2 to split 3. Relative to directional_shadow_max_distance. Only used when directional_shadow_mode is SHADOW_PARALLEL_4_SPLITS.

---

SkyMode sky_mode = 0 

- void set_sky_mode(value: SkyMode)
- SkyMode get_sky_mode()

Whether this DirectionalLight3D is visible in the sky, in the scene, or both in the sky and in the scene.
