# CameraAttributes

Inherits: Resource < RefCounted < Object

Inherited By: CameraAttributesPhysical, CameraAttributesPractical

Parent class for camera settings.

## Description

Controls camera-specific attributes such as depth of field and exposure override.

When used in a WorldEnvironment it provides default settings for exposure, auto-exposure, and depth of field that will be used by all cameras without their own CameraAttributes, including the editor camera. When used in a Camera3D it will override any CameraAttributes set in the WorldEnvironment. When used in VoxelGI or LightmapGI, only the exposure settings will be used.

See also Environment for general 3D environment settings.

This is a pure virtual class that is inherited by CameraAttributesPhysical and CameraAttributesPractical.

## Properties

bool | auto_exposure_enabled | false
float | auto_exposure_scale | 0.4
float | auto_exposure_speed | 0.5
float | exposure_multiplier | 1.0
float | exposure_sensitivity | 100.0

---

## Property Descriptions

bool auto_exposure_enabled = false 

- void set_auto_exposure_enabled(value: bool)
- bool is_auto_exposure_enabled()

If true, enables the tonemapping auto exposure mode of the scene renderer. If true, the renderer will automatically determine the exposure setting to adapt to the scene's illumination and the observed light.

Note: Auto-exposure is only supported in the Forward+ rendering method, not Mobile or Compatibility.

---

float auto_exposure_scale = 0.4 

- void set_auto_exposure_scale(value: float)
- float get_auto_exposure_scale()

The scale of the auto exposure effect. Affects the intensity of auto exposure.

---

float auto_exposure_speed = 0.5 

- void set_auto_exposure_speed(value: float)
- float get_auto_exposure_speed()

The speed of the auto exposure effect. Affects the time needed for the camera to perform auto exposure.

---

float exposure_multiplier = 1.0 

- void set_exposure_multiplier(value: float)
- float get_exposure_multiplier()

Multiplier for the exposure amount. A higher value results in a brighter image.

---

float exposure_sensitivity = 100.0 

- void set_exposure_sensitivity(value: float)
- float get_exposure_sensitivity()

Sensitivity of camera sensors, measured in ISO. A higher sensitivity results in a brighter image.

If auto_exposure_enabled is true, this can be used as a method of exposure compensation, doubling the value will increase the exposure value (measured in EV100) by 1 stop.

Note: Only available when ProjectSettings.rendering/lights_and_shadows/use_physical_light_units is enabled.
