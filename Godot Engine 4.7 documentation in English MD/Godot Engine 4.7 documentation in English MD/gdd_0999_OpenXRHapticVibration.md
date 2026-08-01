# OpenXRHapticVibration

Inherits: OpenXRHapticBase < Resource < RefCounted < Object

Vibration haptic feedback.

## Description

This haptic feedback resource makes it possible to define a vibration based haptic feedback pulse that can be triggered through actions in the OpenXR action map.

## Properties

float | amplitude | 1.0
int | duration | -1
float | frequency | 0.0

---

## Property Descriptions

float amplitude = 1.0 

- void set_amplitude(value: float)
- float get_amplitude()

The amplitude of the pulse between 0.0 and 1.0.

---

int duration = -1 

- void set_duration(value: int)
- int get_duration()

The duration of the pulse in nanoseconds. Use -1 for a minimum duration pulse for the current XR runtime.

---

float frequency = 0.0 

- void set_frequency(value: float)
- float get_frequency()

The frequency of the pulse in Hz. 0.0 will let the XR runtime chose an optimal frequency for the device used.
