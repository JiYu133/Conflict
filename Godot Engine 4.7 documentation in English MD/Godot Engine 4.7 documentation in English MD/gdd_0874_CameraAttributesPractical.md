# CameraAttributesPractical

Inherits: CameraAttributes < Resource < RefCounted < Object

Camera settings in an easy to use format.

## Description

Controls camera-specific attributes such as auto-exposure, depth of field, and exposure override.

When used in a WorldEnvironment it provides default settings for exposure, auto-exposure, and depth of field that will be used by all cameras without their own CameraAttributes, including the editor camera. When used in a Camera3D it will override any CameraAttributes set in the WorldEnvironment. When used in VoxelGI or LightmapGI, only the exposure settings will be used.

Note: Depth of field blur is only supported in the Forward+ and Mobile rendering methods, not Compatibility.

Note: Auto-exposure is only supported in the Forward+ rendering method, not Mobile or Compatibility.

## Properties

float | auto_exposure_max_sensitivity | 800.0
float | auto_exposure_min_sensitivity | 0.0
float | dof_blur_amount | 0.1
float | dof_blur_far_distance | 10.0
bool | dof_blur_far_enabled | false
float | dof_blur_far_transition | 5.0
float | dof_blur_near_distance | 2.0
bool | dof_blur_near_enabled | false
float | dof_blur_near_transition | 1.0

---

## Property Descriptions

float auto_exposure_max_sensitivity = 800.0 

- void set_auto_exposure_max_sensitivity(value: float)
- float get_auto_exposure_max_sensitivity()

The maximum sensitivity (in ISO) used when calculating auto exposure. When calculating scene average luminance, color values will be clamped to at least this value. This limits the auto-exposure from exposing below a certain brightness, resulting in a cut off point where the scene will remain bright.

---

float auto_exposure_min_sensitivity = 0.0 

- void set_auto_exposure_min_sensitivity(value: float)
- float get_auto_exposure_min_sensitivity()

The minimum sensitivity (in ISO) used when calculating auto exposure. When calculating scene average luminance, color values will be clamped to at least this value. This limits the auto-exposure from exposing above a certain brightness, resulting in a cut off point where the scene will remain dark.

---

float dof_blur_amount = 0.1 

- void set_dof_blur_amount(value: float)
- float get_dof_blur_amount()

Sets the maximum amount of blur. When using physically-based blur amounts, will instead act as a multiplier. High values lead to an increased amount of blurriness, but can be much more expensive to calculate. It is best to keep this as low as possible for a given art style.

---

float dof_blur_far_distance = 10.0 

- void set_dof_blur_far_distance(value: float)
- float get_dof_blur_far_distance()

Objects further from the Camera3D by this amount will be blurred by the depth of field effect. Measured in meters.

---

bool dof_blur_far_enabled = false 

- void set_dof_blur_far_enabled(value: bool)
- bool is_dof_blur_far_enabled()

Enables depth of field blur for objects further than dof_blur_far_distance. Strength of blur is controlled by dof_blur_amount and modulated by dof_blur_far_transition.

Note: Depth of field blur is only supported in the Forward+ and Mobile rendering methods, not Compatibility.

Note: Depth of field blur is not supported on viewports that have a transparent background (where Viewport.transparent_bg is true).

---

float dof_blur_far_transition = 5.0 

- void set_dof_blur_far_transition(value: float)
- float get_dof_blur_far_transition()

When positive, distance over which (starting from dof_blur_far_distance) blur effect will scale from 0 to dof_blur_amount. When negative, uses physically-based scaling so depth of field effect will scale from 0 at dof_blur_far_distance and will increase in a physically accurate way as objects get further from the Camera3D.

---

float dof_blur_near_distance = 2.0 

- void set_dof_blur_near_distance(value: float)
- float get_dof_blur_near_distance()

Objects closer from the Camera3D by this amount will be blurred by the depth of field effect. Measured in meters.

---

bool dof_blur_near_enabled = false 

- void set_dof_blur_near_enabled(value: bool)
- bool is_dof_blur_near_enabled()

Enables depth of field blur for objects closer than dof_blur_near_distance. Strength of blur is controlled by dof_blur_amount and modulated by dof_blur_near_transition.

Note: Depth of field blur is only supported in the Forward+ and Mobile rendering methods, not Compatibility.

Note: Depth of field blur is not supported on viewports that have a transparent background (where Viewport.transparent_bg is true).

---

float dof_blur_near_transition = 1.0 

- void set_dof_blur_near_transition(value: float)
- float get_dof_blur_near_transition()

When positive, distance over which blur effect will scale from 0 to dof_blur_amount, ending at dof_blur_near_distance. When negative, uses physically-based scaling so depth of field effect will scale from 0 at dof_blur_near_distance and will increase in a physically accurate way as objects get closer to the Camera3D.
