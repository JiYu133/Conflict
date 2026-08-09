# AudioEffectStereoEnhance

Inherits: AudioEffect < Resource < RefCounted < Object

Adds a stereo manipulation audio effect to an audio bus.

Controls gain of the side channels, and widens the stereo image.

## Description

Adjusts gain of the left and right channels, and makes mono sounds stereo through phase shifting.

## Tutorials

- Audio buses
- Audio effects

## Properties

float | pan_pullout | 1.0
float | surround | 0.0
float | time_pullout_ms | 0.0

---

## Property Descriptions

float pan_pullout = 1.0 

- void set_pan_pullout(value: float)
- float get_pan_pullout()

Gain of the side channels, if they exist. A value of 0 will downmix stereo to mono. Value can range from 0 to 4.

---

float surround = 0.0 

- void set_surround(value: float)
- float get_surround()

Widens the stereo image through phase shifting in conjunction with time_pullout_ms. Just pans sound to the left channel if time_pullout_ms is 0. Value can range from 0 to 1.

---

float time_pullout_ms = 0.0 

- void set_time_pullout(value: float)
- float get_time_pullout()

Widens the stereo image through phase shifting in conjunction with surround. Just delays the right channel if surround is 0. Value is in milliseconds, and can range from 0 to 50.
