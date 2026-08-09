# Light3D

Inherits: VisualInstance3D < Node3D < Node < Object

Inherited By: AreaLight3D, DirectionalLight3D, OmniLight3D, SpotLight3D

Provides a base class for different kinds of light nodes.

## Description

Light3D is the abstract base class for light nodes. As it can't be instantiated, it shouldn't be used directly. Other types of light nodes inherit from it. Light3D contains the common variables and parameters used for lighting.

## Tutorials

- 3D lights and shadows
- Faking global illumination
- Third Person Shooter (TPS) Demo [https://godotengine.org/asset-library/asset/2710]

## Properties

float | distance_fade_begin | 40.0
bool | distance_fade_enabled | false
float | distance_fade_length | 10.0
float | distance_fade_shadow | 50.0
bool | editor_only | false
float | light_angular_distance | 0.0
BakeMode | light_bake_mode | 2
Color | light_color | Color(1, 1, 1, 1)
int | light_cull_mask | 4294967295
float | light_energy | 1.0
float | light_indirect_energy | 1.0
float | light_intensity_lumens |
float | light_intensity_lux |
bool | light_negative | false
Texture2D | light_projector |
float | light_size | 0.0
float | light_specular | 1.0
float | light_temperature |
float | light_volumetric_fog_energy | 1.0
float | shadow_bias | 0.1
float | shadow_blur | 1.0
int | shadow_caster_mask | 4294967295
bool | shadow_enabled | false
float | shadow_normal_bias | 2.0
float | shadow_opacity | 1.0
bool | shadow_reverse_cull_face | false
float | shadow_transmittance_bias | 0.05

## Methods

Color | get_correlated_color() const
float | get_param(param: Param) const
void | set_param(param: Param, value: float)

---

## Enumerations

enum Param
Param PARAM_ENERGY = 0

Constant for accessing light_energy.

Param PARAM_INDIRECT_ENERGY = 1

Constant for accessing light_indirect_energy.

Param PARAM_VOLUMETRIC_FOG_ENERGY = 2

Constant for accessing light_volumetric_fog_energy.

Param PARAM_SPECULAR = 3

Constant for accessing light_specular.

Param PARAM_RANGE = 4

Constant for accessing OmniLight3D.omni_range or SpotLight3D.spot_range.

Param PARAM_SIZE = 5

Constant for accessing light_size.

Param PARAM_ATTENUATION = 6

Constant for accessing OmniLight3D.omni_attenuation or SpotLight3D.spot_attenuation.

Param PARAM_SPOT_ANGLE = 7

Constant for accessing SpotLight3D.spot_angle.

Param PARAM_SPOT_ATTENUATION = 8

Constant for accessing SpotLight3D.spot_angle_attenuation.

Param PARAM_SHADOW_MAX_DISTANCE = 9

Constant for accessing DirectionalLight3D.directional_shadow_max_distance.

Param PARAM_SHADOW_SPLIT_1_OFFSET = 10

Constant for accessing DirectionalLight3D.directional_shadow_split_1.

Param PARAM_SHADOW_SPLIT_2_OFFSET = 11

Constant for accessing DirectionalLight3D.directional_shadow_split_2.

Param PARAM_SHADOW_SPLIT_3_OFFSET = 12

Constant for accessing DirectionalLight3D.directional_shadow_split_3.

Param PARAM_SHADOW_FADE_START = 13

Constant for accessing DirectionalLight3D.directional_shadow_fade_start.

Param PARAM_SHADOW_NORMAL_BIAS = 14

Constant for accessing shadow_normal_bias.

Param PARAM_SHADOW_BIAS = 15

Constant for accessing shadow_bias.

Param PARAM_SHADOW_PANCAKE_SIZE = 16

Constant for accessing DirectionalLight3D.directional_shadow_pancake_size.

Param PARAM_SHADOW_OPACITY = 17

Constant for accessing shadow_opacity.

Param PARAM_SHADOW_BLUR = 18

Constant for accessing shadow_blur.

Param PARAM_TRANSMITTANCE_BIAS = 19

Constant for accessing shadow_transmittance_bias.

Param PARAM_INTENSITY = 20

Constant for accessing light_intensity_lumens and light_intensity_lux. Only used when ProjectSettings.rendering/lights_and_shadows/use_physical_light_units is true.

Param PARAM_MAX = 21

Represents the size of the Param enum.

---

enum BakeMode
BakeMode BAKE_DISABLED = 0

Light is ignored when baking. This is the fastest mode, but the light will not be taken into account when baking global illumination. This mode should generally be used for dynamic lights that change quickly, as the effect of global illumination is less noticeable on those lights.

Note: Hiding a light does not affect baking LightmapGI. Hiding a light will still affect baking VoxelGI and SDFGI (see Environment.sdfgi_enabled).

BakeMode BAKE_STATIC = 1

Light is taken into account in static baking (VoxelGI, LightmapGI, SDFGI (Environment.sdfgi_enabled)). The light can be moved around or modified, but its global illumination will not update in real-time. This is suitable for subtle changes (such as flickering torches), but generally not large changes such as toggling a light on and off.

Note: The light is not baked in LightmapGI if editor_only is true.

BakeMode BAKE_DYNAMIC = 2

Light is taken into account in dynamic baking (VoxelGI and SDFGI (Environment.sdfgi_enabled) only). The light can be moved around or modified with global illumination updating in real-time. The light's global illumination appearance will be slightly different compared to BAKE_STATIC. This has a greater performance cost compared to BAKE_STATIC. When using SDFGI, the update speed of dynamic lights is affected by ProjectSettings.rendering/global_illumination/sdfgi/frames_to_update_lights.

---

## Property Descriptions

float distance_fade_begin = 40.0 

- void set_distance_fade_begin(value: float)
- float get_distance_fade_begin()

The distance from the camera at which the light begins to fade away (in 3D units).

Note: Only effective for OmniLight3D and SpotLight3D.

---

bool distance_fade_enabled = false 

- void set_enable_distance_fade(value: bool)
- bool is_distance_fade_enabled()

If true, the light will smoothly fade away when far from the active Camera3D starting at distance_fade_begin. This acts as a form of level of detail (LOD). The light will fade out over distance_fade_begin + distance_fade_length, after which it will be culled and not sent to the shader at all. Use this to reduce the number of active lights in a scene and thus improve performance.

Note: Only effective for OmniLight3D and SpotLight3D.

---

float distance_fade_length = 10.0 

- void set_distance_fade_length(value: float)
- float get_distance_fade_length()

Distance over which the light and its shadow fades. The light's energy and shadow's opacity is progressively reduced over this distance and is completely invisible at the end.

Note: Only effective for OmniLight3D and SpotLight3D.

---

float distance_fade_shadow = 50.0 

- void set_distance_fade_shadow(value: float)
- float get_distance_fade_shadow()

The distance from the camera at which the light's shadow cuts off (in 3D units). Set this to a value lower than distance_fade_begin + distance_fade_length to further improve performance, as shadow rendering is often more expensive than light rendering itself.

Note: Only effective for OmniLight3D and SpotLight3D, and only when shadow_enabled is true.

---

bool editor_only = false 

- void set_editor_only(value: bool)
- bool is_editor_only()

If true, the light only appears in the editor and will not be visible at runtime. If true, the light will never be baked in LightmapGI regardless of its light_bake_mode.

---

float light_angular_distance = 0.0 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

The light's angular size in degrees. Increasing this will make shadows softer at greater distances (also called percentage-closer soft shadows, or PCSS). Only available for DirectionalLight3Ds. For reference, the Sun from the Earth is approximately 0.5. Increasing this value above 0.0 for lights with shadows enabled will have a noticeable performance cost due to PCSS.

Note: light_angular_distance is not affected by Node3D.scale (the light's scale or its parent's scale).

Note: PCSS for directional lights is only supported in the Forward+ rendering method, not Mobile or Compatibility.

---

BakeMode light_bake_mode = 2 

- void set_bake_mode(value: BakeMode)
- BakeMode get_bake_mode()

The light's bake mode. This will affect the global illumination techniques that have an effect on the light's rendering.

Note: Meshes' global illumination mode will also affect the global illumination rendering. See GeometryInstance3D.gi_mode.

---

Color light_color = Color(1, 1, 1, 1) 

- void set_color(value: Color)
- Color get_color()

The light's color in nonlinear sRGB encoding. An overbright color can be used to achieve a result equivalent to increasing the light's light_energy.

---

int light_cull_mask = 4294967295 

- void set_cull_mask(value: int)
- int get_cull_mask()

The light will affect objects in the selected layers.

Note: The light cull mask is ignored by VoxelGI, SDFGI, LightmapGI, and volumetric fog. These will always render lights in a way that ignores the cull mask. See also VisualInstance3D.layers.

---

float light_energy = 1.0 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

The light's strength multiplier (this is not a physical unit). For OmniLight3D and SpotLight3D, changing this value will only change the light color's intensity, not the light's radius.

---

float light_indirect_energy = 1.0 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

Secondary multiplier used with indirect light (light bounces). Used with VoxelGI and SDFGI (see Environment.sdfgi_enabled).

Note: This property is ignored if light_energy is equal to 0.0, as the light won't be present at all in the GI shader.

---

float light_intensity_lumens 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

Used by positional lights (OmniLight3D and SpotLight3D) when ProjectSettings.rendering/lights_and_shadows/use_physical_light_units is true. Sets the intensity of the light source measured in Lumens. Lumens are a measure of luminous flux, which is the total amount of visible light emitted by a light source per unit of time.

For SpotLight3Ds, we assume that the area outside the visible cone is surrounded by a perfect light absorbing material. Accordingly, the apparent brightness of the cone area does not change as the cone increases and decreases in size.

A typical household lightbulb can range from around 600 lumens to 1,200 lumens, a candle is about 13 lumens, while a streetlight can be approximately 60,000 lumens.

---

float light_intensity_lux 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

Used by DirectionalLight3Ds when ProjectSettings.rendering/lights_and_shadows/use_physical_light_units is true. Sets the intensity of the light source measured in Lux. Lux is a measure of luminous flux per unit area, it is equal to one lumen per square meter. Lux is the measure of how much light hits a surface at a given time.

On a clear sunny day a surface in direct sunlight may be approximately 100,000 lux, a typical room in a home may be approximately 50 lux, while the moonlit ground may be approximately 0.1 lux.

---

bool light_negative = false 

- void set_negative(value: bool)
- bool is_negative()

If true, the light's effect is reversed, darkening areas and casting bright shadows.

---

Texture2D light_projector 

- void set_projector(value: Texture2D)
- Texture2D get_projector()

Texture2D projected by light. shadow_enabled must be on for the projector to work. Light projectors make the light appear as if it is shining through a colored but transparent object, almost like light shining through stained-glass.

Note: Unlike BaseMaterial3D whose filter mode can be adjusted on a per-material basis, the filter mode for light projector textures is set globally with ProjectSettings.rendering/textures/light_projectors/filter.

Note: Light projector textures are only supported in the Forward+ and Mobile rendering methods, not Compatibility.

---

float light_size = 0.0 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

The simulated size of the light in Godot units, affecting shading and shadows. For OmniLight3Ds and SpotLight3Ds, increasing this value simulates a spherical area light, expanding the size of specular highlights. If shadows are enabled, a penumbra is rendered, making shadows appear blurrier. For AreaLight3Ds, only the shadows are affected. Penumbras are simulated with percentage-closer soft shadows, or PCSS, which has a noticeable performance cost for values above 0.0.

Note: light_size is not affected by Node3D.scale (the light's scale or its parent's scale).

Note: PCSS for positional lights is only supported in the Forward+ and Mobile rendering methods, not Compatibility.

---

float light_specular = 1.0 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

The intensity of the specular blob in objects affected by the light. At 0, the light becomes a pure diffuse light. When not baking emission, this can be used to avoid unrealistic reflections when placing lights above an emissive surface.

---

float light_temperature 

- void set_temperature(value: float)
- float get_temperature()

Sets the color temperature of the light source, measured in Kelvin. This is used to calculate a correlated color temperature which tints the light_color.

The sun on a cloudy day is approximately 6500 Kelvin, on a clear day it is between 5500 to 6000 Kelvin, and on a clear day at sunrise or sunset it ranges to around 1850 Kelvin.

---

float light_volumetric_fog_energy = 1.0 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

Secondary multiplier multiplied with light_energy then used with the Environment's volumetric fog (if enabled). If set to 0.0, computing volumetric fog will be skipped for this light, which can improve performance for large amounts of lights when volumetric fog is enabled.

Note: To prevent short-lived dynamic light effects from poorly interacting with volumetric fog, lights used in those effects should have light_volumetric_fog_energy set to 0.0 unless Environment.volumetric_fog_temporal_reprojection_enabled is disabled (or unless the reprojection amount is significantly lowered).

---

float shadow_bias = 0.1 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

Used to adjust shadow appearance. Too small a value results in self-shadowing ("shadow acne"), while too large a value causes shadows to separate from casters ("peter-panning"). Adjust as needed.

---

float shadow_blur = 1.0 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

Blurs the edges of the shadow. Can be used to hide pixel artifacts in low-resolution shadow maps. A high value can impact performance, make shadows appear grainy and can cause other unwanted artifacts. Try to keep as near default as possible.

---

int shadow_caster_mask = 4294967295 

- void set_shadow_caster_mask(value: int)
- int get_shadow_caster_mask()

The light will only cast shadows using objects in the selected layers.

---

bool shadow_enabled = false 

- void set_shadow(value: bool)
- bool has_shadow()

If true, the light will cast real-time shadows. This has a significant performance cost. Only enable shadow rendering when it makes a noticeable difference in the scene's appearance, and consider using distance_fade_enabled to hide the light when far away from the Camera3D.

---

float shadow_normal_bias = 2.0 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

Offsets the lookup into the shadow map by the object's normal. This can be used to reduce self-shadowing artifacts without using shadow_bias. In practice, this value should be tweaked along with shadow_bias to reduce artifacts as much as possible.

---

float shadow_opacity = 1.0 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

The opacity to use when rendering the light's shadow map. Values lower than 1.0 make the light appear through shadows. This can be used to fake global illumination at a low performance cost.

---

bool shadow_reverse_cull_face = false 

- void set_shadow_reverse_cull_face(value: bool)
- bool get_shadow_reverse_cull_face()

If true, reverses the backface culling of the mesh. This can be useful when you have a flat mesh that has a light behind it. If you need to cast a shadow on both sides of the mesh, set the mesh to use double-sided shadows with GeometryInstance3D.SHADOW_CASTING_SETTING_DOUBLE_SIDED.

---

float shadow_transmittance_bias = 0.05 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

There is currently no description for this property. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

## Method Descriptions

Color get_correlated_color() const 

Returns the Color of an idealized blackbody at the given light_temperature. This value is calculated internally based on the light_temperature. This Color is multiplied by light_color before being sent to the RenderingServer.

---

float get_param(param: Param) const 

Returns the value of the specified Param parameter.

---

void set_param(param: Param, value: float) 

Sets the value of the specified Param parameter.
