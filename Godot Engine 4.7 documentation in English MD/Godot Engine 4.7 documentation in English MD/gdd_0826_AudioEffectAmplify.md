# AudioEffectAmplify

Inherits: AudioEffect < Resource < RefCounted < Object

Adds a volume manipulation audio effect to an audio bus.

## Description

Increases or decreases the volume being routed through the audio bus.

## Tutorials

- Audio buses
- Audio effects

## Properties

float | volume_db | 0.0
float | volume_linear |

---

## Property Descriptions

float volume_db = 0.0 

- void set_volume_db(value: float)
- float get_volume_db()

Amount of amplification in dB. Positive values make the sound louder, negative values make it quieter. Value can range from -80 to 24.

---

float volume_linear 

- void set_volume_linear(value: float)
- float get_volume_linear()

Amount of amplification as a linear value.

Note: This member modifies volume_db for convenience. The returned value is equivalent to the result of @GlobalScope.db_to_linear() on volume_db. Setting this member is equivalent to setting volume_db to the result of @GlobalScope.linear_to_db() on a value.
