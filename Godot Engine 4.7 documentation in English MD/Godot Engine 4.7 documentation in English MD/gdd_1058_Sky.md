# Sky

Inherits: Resource < RefCounted < Object

Defines a 3D environment's background by using a Material.

## Description

The Sky class uses a Material to render a 3D environment's background and the light it emits by updating the reflection/radiance cubemaps.

## Properties

ProcessMode | process_mode | 0
RadianceSize | radiance_size | 3
Material | sky_material |

---

## Enumerations

enum RadianceSize
RadianceSize RADIANCE_SIZE_32 = 0

Radiance texture size is 32×32 pixels.

RadianceSize RADIANCE_SIZE_64 = 1

Radiance texture size is 64×64 pixels.

RadianceSize RADIANCE_SIZE_128 = 2

Radiance texture size is 128×128 pixels.

RadianceSize RADIANCE_SIZE_256 = 3

Radiance texture size is 256×256 pixels.

RadianceSize RADIANCE_SIZE_512 = 4

Radiance texture size is 512×512 pixels.

RadianceSize RADIANCE_SIZE_1024 = 5

Radiance texture size is 1024×1024 pixels.

RadianceSize RADIANCE_SIZE_2048 = 6

Radiance texture size is 2048×2048 pixels.

RadianceSize RADIANCE_SIZE_MAX = 7

Represents the size of the RadianceSize enum.

---

enum ProcessMode
ProcessMode PROCESS_MODE_AUTOMATIC = 0

Automatically selects the appropriate process mode based on your sky shader. If your shader uses TIME or POSITION, this will use PROCESS_MODE_REALTIME. If your shader uses any of the LIGHT_* variables or any custom uniforms, this uses PROCESS_MODE_INCREMENTAL. Otherwise, this defaults to PROCESS_MODE_QUALITY.

ProcessMode PROCESS_MODE_QUALITY = 1

Uses high quality importance sampling to process the radiance map. In general, this results in much higher quality than PROCESS_MODE_REALTIME but takes much longer to generate. This should not be used if you plan on changing the sky at runtime. If you are finding that the reflection is not blurry enough and is showing sparkles or fireflies, try increasing ProjectSettings.rendering/reflections/sky_reflections/ggx_samples.

ProcessMode PROCESS_MODE_INCREMENTAL = 2

Uses the same high quality importance sampling to process the radiance map as PROCESS_MODE_QUALITY, but updates over several frames. The number of frames is determined by ProjectSettings.rendering/reflections/sky_reflections/roughness_layers. Use this when you need highest quality radiance maps, but have a sky that updates slowly.

ProcessMode PROCESS_MODE_REALTIME = 3

Uses the fast filtering algorithm to process the radiance map. In general this results in lower quality, but substantially faster run times. If you need better quality, but still need to update the sky every frame, consider turning on ProjectSettings.rendering/reflections/sky_reflections/fast_filter_high_quality.

Note: The fast filtering algorithm is limited to 256×256 cubemaps, so radiance_size must be set to RADIANCE_SIZE_256. Otherwise, a warning is printed and the overridden radiance size is ignored.

---

## Property Descriptions

ProcessMode process_mode = 0 

- void set_process_mode(value: ProcessMode)
- ProcessMode get_process_mode()

The method for generating the radiance map from the sky. The radiance map is a cubemap with increasingly blurry versions of the sky corresponding to different levels of roughness. Radiance maps can be expensive to calculate.

---

RadianceSize radiance_size = 3 

- void set_radiance_size(value: RadianceSize)
- RadianceSize get_radiance_size()

The Sky's radiance map size. The higher the radiance map size, the more detailed the lighting from the Sky will be.

Note: Some hardware will have trouble with higher radiance sizes, especially RADIANCE_SIZE_512 and above. Only use such high values on high-end hardware.

---

Material sky_material 

- void set_material(value: Material)
- Material get_material()

Material used to draw the background. Can be PanoramaSkyMaterial, ProceduralSkyMaterial, PhysicalSkyMaterial, or even a ShaderMaterial if you want to use your own custom shader.
