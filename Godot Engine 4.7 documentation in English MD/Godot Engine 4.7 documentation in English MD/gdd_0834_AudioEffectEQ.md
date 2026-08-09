# AudioEffectEQ

Inherits: AudioEffect < Resource < RefCounted < Object

Inherited By: AudioEffectEQ10, AudioEffectEQ21, AudioEffectEQ6

Base class for audio equalizers (EQ). Gives you control over frequencies.

Use it to create a custom equalizer if AudioEffectEQ6, AudioEffectEQ10, or AudioEffectEQ21 don't fit your needs.

## Description

An "equalizer" gives you control over the gain of frequencies in the entire spectrum, by allowing their adjustment through bands. A band is a point in the frequency spectrum, and each band means a division of the spectrum that can be adjusted.

Use equalizers to compensate for existing deficiencies in the audio, make room for other elements, or remove undesirable frequencies. AudioEffectEQs are useful on the Master bus to balance the entire mix or give it more character. They are also useful when a game is run on a mobile device, to adjust the mix to that kind of speakers (it can be disabled when headphones are plugged in).

## Tutorials

- Audio buses
- Audio effects

## Methods

int | get_band_count() const
float | get_band_gain_db(band_idx: int) const
void | set_band_gain_db(band_idx: int, volume_db: float)

---

## Method Descriptions

int get_band_count() const 

Returns the number of bands of the equalizer.

---

float get_band_gain_db(band_idx: int) const 

Returns the band's gain at the specified index, in dB.

---

void set_band_gain_db(band_idx: int, volume_db: float) 

Sets band's gain at the specified index, in dB.
