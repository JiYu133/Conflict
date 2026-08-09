# InputEventMagnifyGesture

Inherits: InputEventGesture < InputEventWithModifiers < InputEventFromWindow < InputEvent < Resource < RefCounted < Object

Represents a magnifying touch gesture.

## Description

Stores the factor of a magnifying touch gesture. This is usually performed when the user pinches the touch screen and used for zooming in/out.

Note: On Android, this requires the ProjectSettings.input_devices/pointing/android/enable_pan_and_scale_gestures project setting to be enabled.

## Tutorials

- Using InputEvent

## Properties

float | factor | 1.0

---

## Property Descriptions

float factor = 1.0 

- void set_factor(value: float)
- float get_factor()

The amount (or delta) of the event. This value is closer to 1.0 the slower the gesture is performed.
