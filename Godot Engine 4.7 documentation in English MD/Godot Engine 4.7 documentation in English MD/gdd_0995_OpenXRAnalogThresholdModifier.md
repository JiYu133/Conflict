# OpenXRAnalogThresholdModifier

Inherits: OpenXRActionBindingModifier < OpenXRBindingModifier < Resource < RefCounted < Object

The analog threshold binding modifier can modify a float input to a boolean input with specified thresholds.

## Description

The analog threshold binding modifier can modify a float input to a boolean input with specified thresholds.

See XR_VALVE_analog_threshold [https://registry.khronos.org/OpenXR/specs/1.1/html/xrspec.html#XR_VALVE_analog_threshold] for in-depth details.

## Properties

OpenXRHapticBase | off_haptic |
float | off_threshold | 0.4
OpenXRHapticBase | on_haptic |
float | on_threshold | 0.6

---

## Property Descriptions

OpenXRHapticBase off_haptic 

- void set_off_haptic(value: OpenXRHapticBase)
- OpenXRHapticBase get_off_haptic()

Haptic pulse to emit when the user releases the input.

---

float off_threshold = 0.4 

- void set_off_threshold(value: float)
- float get_off_threshold()

When our input value falls below this, our output becomes false.

---

OpenXRHapticBase on_haptic 

- void set_on_haptic(value: OpenXRHapticBase)
- OpenXRHapticBase get_on_haptic()

Haptic pulse to emit when the user presses the input.

---

float on_threshold = 0.6 

- void set_on_threshold(value: float)
- float get_on_threshold()

When our input value is equal or larger than this value, our output becomes true. It stays true until it falls under the off_threshold value.
