# OpenXRDpadBindingModifier

Inherits: OpenXRIPBindingModifier < OpenXRBindingModifier < Resource < RefCounted < Object

The DPad binding modifier converts an axis input to a dpad output.

## Description

The DPad binding modifier converts an axis input to a dpad output, emulating a DPad. New input paths for each dpad direction will be added to the interaction profile. When bound to actions the DPad emulation will be activated. You should not combine dpad inputs with normal inputs in the same action set for the same control, this will result in an error being returned when suggested bindings are submitted to OpenXR.

See XR_EXT_dpad_binding [https://registry.khronos.org/OpenXR/specs/1.1/html/xrspec.html#XR_EXT_dpad_binding] for in-depth details.

Note: If the DPad binding modifier extension is enabled, all dpad binding paths will be available in the action map. Adding the modifier to an interaction profile allows you to further customize the behavior.

## Properties

OpenXRActionSet | action_set |
float | center_region | 0.1
String | input_path | ""
bool | is_sticky | false
OpenXRHapticBase | off_haptic |
OpenXRHapticBase | on_haptic |
float | threshold | 0.6
float | threshold_released | 0.4
float | wedge_angle | 1.5707964

---

## Property Descriptions

OpenXRActionSet action_set 

- void set_action_set(value: OpenXRActionSet)
- OpenXRActionSet get_action_set()

Action set for which this dpad binding modifier is active.

---

float center_region = 0.1 

- void set_center_region(value: float)
- float get_center_region()

Center region in which our center position of our dpad return true.

---

String input_path = "" 

- void set_input_path(value: String)
- String get_input_path()

Input path for this dpad binding modifier.

---

bool is_sticky = false 

- void set_is_sticky(value: bool)
- bool get_is_sticky()

If false, when the joystick enters a new dpad zone this becomes true.

If true, when the joystick remains in active dpad zone, this remains true even if we overlap with another zone.

---

OpenXRHapticBase off_haptic 

- void set_off_haptic(value: OpenXRHapticBase)
- OpenXRHapticBase get_off_haptic()

Haptic pulse to emit when the user releases the input.

---

OpenXRHapticBase on_haptic 

- void set_on_haptic(value: OpenXRHapticBase)
- OpenXRHapticBase get_on_haptic()

Haptic pulse to emit when the user presses the input.

---

float threshold = 0.6 

- void set_threshold(value: float)
- float get_threshold()

When our input value is equal or larger than this value, our dpad in that direction becomes true. It stays true until it falls under the threshold_released value.

---

float threshold_released = 0.4 

- void set_threshold_released(value: float)
- float get_threshold_released()

When our input value falls below this, our output becomes false.

---

float wedge_angle = 1.5707964 

- void set_wedge_angle(value: float)
- float get_wedge_angle()

The angle of each wedge that identifies the 4 directions of the emulated dpad.
