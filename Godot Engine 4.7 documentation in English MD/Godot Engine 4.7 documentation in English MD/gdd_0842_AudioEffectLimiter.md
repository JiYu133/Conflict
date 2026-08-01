# AudioEffectLimiter

Deprecated: Use AudioEffectHardLimiter instead.

Inherits: AudioEffect < Resource < RefCounted < Object

Adds a soft-clip limiter audio effect to an audio bus.

## Description

A "limiter" is an audio effect designed to stop audio signals from exceeding a specified volume threshold level, and usually works by decreasing the volume or soft-clipping the audio. Adding one in the Master bus is always recommended to prevent clipping when the volume goes above 0 dB.

Soft clipping starts to decrease the peaks a little below the volume threshold level and progressively increases its effect as the input volume increases such that the threshold level is never exceeded.

If hard clipping is desired, consider AudioEffectDistortion.MODE_CLIP.

## Tutorials

- Audio buses
- Audio effects

## Properties

float | ceiling_db | -0.1
float | soft_clip_db | 2.0
float | soft_clip_ratio | 10.0
float | threshold_db | 0.0

---

## Property Descriptions

float ceiling_db = -0.1 

- void set_ceiling_db(value: float)
- float get_ceiling_db()

The waveform's maximum allowed value, in dB. Value can range from -20 to -0.1.

---

float soft_clip_db = 2.0 

- void set_soft_clip_db(value: float)
- float get_soft_clip_db()

Modifies the volume of the limited waves, in dB. Value can range from 0 to 6.

---

float soft_clip_ratio = 10.0 

- void set_soft_clip_ratio(value: float)
- float get_soft_clip_ratio()

This property has no effect on the audio. Use AudioEffectHardLimiter instead, as this Limiter effect is deprecated.

---

float threshold_db = 0.0 

- void set_threshold_db(value: float)
- float get_threshold_db()

The volume threshold level from which the limiter begins to be active, in dB. Value can range from -30 to 0.
