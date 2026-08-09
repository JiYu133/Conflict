# AudioEffectPanner

Inherits: AudioEffect < Resource < RefCounted < Object

Adds a panner audio effect to an audio bus.

Pans the sound left or right.

## Description

Determines how much of the audio signal is sent to the left and right channels. This helps with audio spatialization, giving sounds distinct places in a mix.

AudioStreamPlayer2D and AudioStreamPlayer3D handle panning automatically, following where the source of the sound is on the screen.

## Tutorials

- Audio buses
- Audio effects

## Properties

float | pan | 0.0

---

## Property Descriptions

float pan = 0.0 

- void set_pan(value: float)
- float get_pan()

Pan position. Negative values pan the sound to the left, positive pan to the right. Value can range from -1 to 1.
