# MobileVRInterface

Inherits: XRInterface < RefCounted < Object

Generic mobile VR implementation.

## Description

This is a generic mobile VR implementation where you need to provide details about the phone and HMD used. It does not rely on any existing framework. This is the most basic interface we have. For the best effect, you need a mobile phone with a gyroscope and accelerometer.

Note that even though there is no positional tracking, the camera will assume the headset is at a height of 1.85 meters. You can change this by setting eye_height.

You can initialize this interface as follows:

```gdscript
var interface = XRServer.find_interface("Native mobile")
if interface and interface.initialize():
    get_viewport().use_xr = true
```

Note: For Android, ProjectSettings.input_devices/sensors/enable_accelerometer, ProjectSettings.input_devices/sensors/enable_gravity, ProjectSettings.input_devices/sensors/enable_gyroscope and ProjectSettings.input_devices/sensors/enable_magnetometer must be enabled.

## Properties

float | display_to_lens | 4.0
float | display_width | 14.5
float | eye_height | 1.85
float | iod | 6.0
float | k1 | 0.215
float | k2 | 0.215
Rect2 | offset_rect | Rect2(0, 0, 1, 1)
float | oversample | 1.5
float | vrs_min_radius | 20.0
float | vrs_strength | 1.0
PlayAreaMode | xr_play_area_mode | 1 (overrides XRInterface)

---

## Property Descriptions

float display_to_lens = 4.0 

- void set_display_to_lens(value: float)
- float get_display_to_lens()

The distance between the display and the lenses inside of the device in centimeters.

---

float display_width = 14.5 

- void set_display_width(value: float)
- float get_display_width()

The width of the display in centimeters.

---

float eye_height = 1.85 

- void set_eye_height(value: float)
- float get_eye_height()

The height at which the camera is placed in relation to the ground (i.e. XROrigin3D node).

---

float iod = 6.0 

- void set_iod(value: float)
- float get_iod()

The interocular distance, also known as the interpupillary distance. The distance between the pupils of the left and right eye.

---

float k1 = 0.215 

- void set_k1(value: float)
- float get_k1()

The k1 lens factor is one of the two constants that define the strength of the lens used and directly influences the lens distortion effect.

---

float k2 = 0.215 

- void set_k2(value: float)
- float get_k2()

The k2 lens factor, see k1.

---

Rect2 offset_rect = Rect2(0, 0, 1, 1) 

- void set_offset_rect(value: Rect2)
- Rect2 get_offset_rect()

Set the offset rect relative to the area being rendered. A length of 1 represents the whole rendering area on that axis.

---

float oversample = 1.5 

- void set_oversample(value: float)
- float get_oversample()

The oversample setting. Because of the lens distortion we have to render our buffers at a higher resolution then the screen can natively handle. A value between 1.5 and 2.0 often provides good results but at the cost of performance.

---

float vrs_min_radius = 20.0 

- void set_vrs_min_radius(value: float)
- float get_vrs_min_radius()

The minimum radius around the focal point where full quality is guaranteed if VRS is used as a percentage of screen size.

Note: Mobile and Forward+ renderers only. Requires Viewport.vrs_mode to be set to Viewport.VRS_XR.

---

float vrs_strength = 1.0 

- void set_vrs_strength(value: float)
- float get_vrs_strength()

The strength used to calculate the VRS density map. The greater this value, the more noticeable VRS is. This improves performance at the cost of quality.

Note: Mobile and Forward+ renderers only. Requires Viewport.vrs_mode to be set to Viewport.VRS_XR.
