# AudioEffectBandPassFilter

Inherits: AudioEffectFilter < AudioEffect < Resource < RefCounted < Object

Adds a band-pass filter to an audio bus.

## Description

A "band-pass" filter allows the frequencies at AudioEffectFilter.cutoff_hz to pass unchanged, and attenuates frequencies outside the frequency threshold. It is the opposite of AudioEffectBandLimitFilter and AudioEffectNotchFilter.

This filter can be used to emulate sounds coming from weak speakers.

## Tutorials

- Audio buses
- Audio effects
