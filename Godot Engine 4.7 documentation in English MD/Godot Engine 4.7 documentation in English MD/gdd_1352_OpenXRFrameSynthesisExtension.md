# OpenXRFrameSynthesisExtension

Inherits: OpenXRExtensionWrapper < Object

The OpenXR Frame synthesis extension allows for advanced reprojection at low(er) framerates.

## Description

This class implements the OpenXR Frame synthesis extension [https://registry.khronos.org/OpenXR/specs/1.1/html/xrspec.html#XR_EXT_frame_synthesis]. When enabled in the project settings and supported by the XR runtime in use, frame synthesis uses advanced reprojection techniques to inject additional frames so that your XR experience hits the full frame rate of the device.

## Properties

bool | enabled | false
bool | relax_frame_interval | false

## Methods

bool | is_available() const
void | skip_next_frame()

---

## Property Descriptions

bool enabled = false 

- void set_enabled(value: bool)
- bool is_enabled()

Enable frame synthesis. When true motion vector and depth data is provided to the XR runtime.

---

bool relax_frame_interval = false 

- void set_relax_frame_interval(value: bool)
- bool get_relax_frame_interval()

If true this informs the XR runtime we will be providing frames at a greatly reduced rate. Enable this when you expect your application to run at low framerates and wish to inject multiple reprojected frames.

---

## Method Descriptions

bool is_available() const 

Returns true if frame synthesis is enabled in the project settings and the current XR runtime supports frame synthesis. The value returned will only be valid once OpenXR has been initialized.

---

void skip_next_frame() 

Queues the next frame to be skipped when supplying motion vector and depth data. Call this after teleporting your player or a similar action has moved the player to prevent incorrect reprojection results due to this movement.
