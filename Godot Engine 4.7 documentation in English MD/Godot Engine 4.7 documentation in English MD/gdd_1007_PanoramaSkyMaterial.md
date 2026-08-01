# PanoramaSkyMaterial

Inherits: Material < Resource < RefCounted < Object

A material that provides a special texture to a Sky, usually an HDR panorama.

## Description

A resource referenced in a Sky that is used to draw a background. PanoramaSkyMaterial functions similar to skyboxes in other engines, except it uses an equirectangular sky map instead of a Cubemap.

Using an HDR panorama is strongly recommended for accurate, high-quality reflections. Godot supports the Radiance HDR (.hdr) and OpenEXR (.exr) image formats for this purpose.

You can use this tool [https://danilw.github.io/GLSL-howto/cubemap_to_panorama_js/cubemap_to_panorama.html] to convert a cubemap to an equirectangular sky map.

## Properties

float | energy_multiplier | 1.0
bool | filter | true
Texture2D | panorama |

---

## Property Descriptions

float energy_multiplier = 1.0 

- void set_energy_multiplier(value: float)
- float get_energy_multiplier()

The sky's overall brightness multiplier. Higher values result in a brighter sky.

---

bool filter = true 

- void set_filtering_enabled(value: bool)
- bool is_filtering_enabled()

A boolean value to determine if the background texture should be filtered or not.

---

Texture2D panorama 

- void set_panorama(value: Texture2D)
- Texture2D get_panorama()

Texture2D to be applied to the PanoramaSkyMaterial.
