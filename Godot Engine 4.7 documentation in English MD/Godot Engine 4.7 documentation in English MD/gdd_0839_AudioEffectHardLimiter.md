# AudioEffectHardLimiter

Inherits: AudioEffect < Resource < RefCounted < Object

Adds a limiter audio effect to an audio bus.

Prevents audio signals from exceeding a specified volume level.

## Description

A "limiter" disallows audio signals from exceeding a given volume threshold level in dB. Hard limiters predict volume peaks, and will smoothly apply gain reduction when a peak crosses the ceiling threshold level to prevent clipping. It preserves the waveform and prevents it from crossing the ceiling threshold level. Adding one in the Master bus is recommended as a safety measure to prevent sudden volume peaks from occurring, and to prevent distortion caused by clipping, when the volume exceeds 0 dB.

If clipping is desired, consider AudioEffectDistortion.MODE_CLIP.

## Tutorials

- Audio buses
- Audio effects

## Properties

float | ceiling_db | -0.3
float | pre_gain_db | 0.0
float | release | 0.1

---

## Property Descriptions

float ceiling_db = -0.3 

- void set_ceiling_db(value: float)
- float get_ceiling_db()

The waveform's maximum allowed value, in dB. This value can range from -24 to 0.

The default value of -0.3 prevents potential inter-sample peaks (ISP) from crossing over 0 dB, which can cause slight distortion on some older hardware.

---

float pre_gain_db = 0.0 

- void set_pre_gain_db(value: float)
- float get_pre_gain_db()

Gain before limiting, in dB. Value can range from -24 to 24.

---

float release = 0.1 

- void set_release(value: float)
- float get_release()

Time it takes in seconds for the gain reduction to fully release. Value can range from 0.01 to 3.
