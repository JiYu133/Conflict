# AudioEffectChorus

Inherits: AudioEffect < Resource < RefCounted < Object

Adds a chorus audio effect to an audio bus.

Gives the impression of multiple audio sources.

## Description

A "chorus" effect creates multiple copies of the original audio (called "voices") with variations in pitch, and layers on top of the original, giving the impression that the sound comes from multiple sources. This creates spectral and spatial movement.

Each voice is played a short period of time after the original audio, controlled by delay. An internal low-frequency oscillator (LFO) controls their pitch, and depth controls the LFO's maximum amount.

In the real world, this kind of effect is found in pianos, choirs, and instrument ensembles.

This effect can also be used to widen mono audio and make digital sounds have a more natural or analog quality.

## Tutorials

- Audio buses
- Audio effects

## Properties

float | dry | 1.0
float | voice/1/cutoff_hz | 8000.0
float | voice/1/delay_ms | 15.0
float | voice/1/depth_ms | 2.0
float | voice/1/level_db | 0.0
float | voice/1/pan | -0.5
float | voice/1/rate_hz | 0.8
float | voice/2/cutoff_hz | 8000.0
float | voice/2/delay_ms | 20.0
float | voice/2/depth_ms | 3.0
float | voice/2/level_db | 0.0
float | voice/2/pan | 0.5
float | voice/2/rate_hz | 1.2
float | voice/3/cutoff_hz |
float | voice/3/delay_ms |
float | voice/3/depth_ms |
float | voice/3/level_db |
float | voice/3/pan |
float | voice/3/rate_hz |
float | voice/4/cutoff_hz |
float | voice/4/delay_ms |
float | voice/4/depth_ms |
float | voice/4/level_db |
float | voice/4/pan |
float | voice/4/rate_hz |
int | voice_count | 2
float | wet | 0.5

## Methods

float | get_voice_cutoff_hz(voice_idx: int) const
float | get_voice_delay_ms(voice_idx: int) const
float | get_voice_depth_ms(voice_idx: int) const
float | get_voice_level_db(voice_idx: int) const
float | get_voice_pan(voice_idx: int) const
float | get_voice_rate_hz(voice_idx: int) const
void | set_voice_cutoff_hz(voice_idx: int, cutoff_hz: float)
void | set_voice_delay_ms(voice_idx: int, delay_ms: float)
void | set_voice_depth_ms(voice_idx: int, depth_ms: float)
void | set_voice_level_db(voice_idx: int, level_db: float)
void | set_voice_pan(voice_idx: int, pan: float)
void | set_voice_rate_hz(voice_idx: int, rate_hz: float)

---

## Property Descriptions

float dry = 1.0 

- void set_dry(value: float)
- float get_dry()

The volume ratio of the original audio. Value can range from 0 to 1.

---

float voice/1/cutoff_hz = 8000.0 

- void set_voice_cutoff_hz(voice_idx: int, cutoff_hz: float)
- float get_voice_cutoff_hz(voice_idx: int) const

The frequency threshold of the voice's low-pass filter in Hz.

---

float voice/1/delay_ms = 15.0 

- void set_voice_delay_ms(voice_idx: int, delay_ms: float)
- float get_voice_delay_ms(voice_idx: int) const

The delay of the voice in milliseconds, compared to the original audio.

---

float voice/1/depth_ms = 2.0 

- void set_voice_depth_ms(voice_idx: int, depth_ms: float)
- float get_voice_depth_ms(voice_idx: int) const

The depth of the voice's low-frequency oscillator in milliseconds.

---

float voice/1/level_db = 0.0 

- void set_voice_level_db(voice_idx: int, level_db: float)
- float get_voice_level_db(voice_idx: int) const

The gain of the voice in dB.

---

float voice/1/pan = -0.5 

- void set_voice_pan(voice_idx: int, pan: float)
- float get_voice_pan(voice_idx: int) const

The pan position of the voice.

---

float voice/1/rate_hz = 0.8 

- void set_voice_rate_hz(voice_idx: int, rate_hz: float)
- float get_voice_rate_hz(voice_idx: int) const

The rate of the voice's low-frequency oscillator in Hz.

---

float voice/2/cutoff_hz = 8000.0 

- void set_voice_cutoff_hz(voice_idx: int, cutoff_hz: float)
- float get_voice_cutoff_hz(voice_idx: int) const

The frequency threshold of the voice's low-pass filter in Hz.

---

float voice/2/delay_ms = 20.0 

- void set_voice_delay_ms(voice_idx: int, delay_ms: float)
- float get_voice_delay_ms(voice_idx: int) const

The delay of the voice in milliseconds, compared to the original audio.

---

float voice/2/depth_ms = 3.0 

- void set_voice_depth_ms(voice_idx: int, depth_ms: float)
- float get_voice_depth_ms(voice_idx: int) const

The depth of the voice's low-frequency oscillator in milliseconds.

---

float voice/2/level_db = 0.0 

- void set_voice_level_db(voice_idx: int, level_db: float)
- float get_voice_level_db(voice_idx: int) const

The gain of the voice in dB.

---

float voice/2/pan = 0.5 

- void set_voice_pan(voice_idx: int, pan: float)
- float get_voice_pan(voice_idx: int) const

The pan position of the voice.

---

float voice/2/rate_hz = 1.2 

- void set_voice_rate_hz(voice_idx: int, rate_hz: float)
- float get_voice_rate_hz(voice_idx: int) const

The rate of the voice's low-frequency oscillator in Hz.

---

float voice/3/cutoff_hz 

- void set_voice_cutoff_hz(voice_idx: int, cutoff_hz: float)
- float get_voice_cutoff_hz(voice_idx: int) const

The frequency threshold of the voice's low-pass filter in Hz.

---

float voice/3/delay_ms 

- void set_voice_delay_ms(voice_idx: int, delay_ms: float)
- float get_voice_delay_ms(voice_idx: int) const

The delay of the voice in milliseconds, compared to the original audio.

---

float voice/3/depth_ms 

- void set_voice_depth_ms(voice_idx: int, depth_ms: float)
- float get_voice_depth_ms(voice_idx: int) const

The depth of the voice's low-frequency oscillator in milliseconds.

---

float voice/3/level_db 

- void set_voice_level_db(voice_idx: int, level_db: float)
- float get_voice_level_db(voice_idx: int) const

The gain of the voice in dB.

---

float voice/3/pan 

- void set_voice_pan(voice_idx: int, pan: float)
- float get_voice_pan(voice_idx: int) const

The pan position of the voice.

---

float voice/3/rate_hz 

- void set_voice_rate_hz(voice_idx: int, rate_hz: float)
- float get_voice_rate_hz(voice_idx: int) const

The rate of the voice's low-frequency oscillator in Hz.

---

float voice/4/cutoff_hz 

- void set_voice_cutoff_hz(voice_idx: int, cutoff_hz: float)
- float get_voice_cutoff_hz(voice_idx: int) const

The frequency threshold of the voice's low-pass filter in Hz.

---

float voice/4/delay_ms 

- void set_voice_delay_ms(voice_idx: int, delay_ms: float)
- float get_voice_delay_ms(voice_idx: int) const

The delay of the voice in milliseconds, compared to the original audio.

---

float voice/4/depth_ms 

- void set_voice_depth_ms(voice_idx: int, depth_ms: float)
- float get_voice_depth_ms(voice_idx: int) const

The depth of the voice's low-frequency oscillator in milliseconds.

---

float voice/4/level_db 

- void set_voice_level_db(voice_idx: int, level_db: float)
- float get_voice_level_db(voice_idx: int) const

The gain of the voice in dB.

---

float voice/4/pan 

- void set_voice_pan(voice_idx: int, pan: float)
- float get_voice_pan(voice_idx: int) const

The pan position of the voice.

---

float voice/4/rate_hz 

- void set_voice_rate_hz(voice_idx: int, rate_hz: float)
- float get_voice_rate_hz(voice_idx: int) const

The rate of the voice's low-frequency oscillator in Hz.

---

int voice_count = 2 

- void set_voice_count(value: int)
- int get_voice_count()

The number of voices in the effect. Value can range from 1 to 4.

---

float wet = 0.5 

- void set_wet(value: float)
- float get_wet()

The volume ratio of all voices. Value can range from 0 to 1.

---

## Method Descriptions

float get_voice_cutoff_hz(voice_idx: int) const 

Returns the frequency threshold of a given voice_idx's low-pass filter in Hz. Frequencies above this value are removed from the voice.

---

float get_voice_delay_ms(voice_idx: int) const 

Returns the delay of a given voice_idx in milliseconds, compared to the original audio.

---

float get_voice_depth_ms(voice_idx: int) const 

Returns the depth of a given voice_idx's low-frequency oscillator in milliseconds.

---

float get_voice_level_db(voice_idx: int) const 

Returns the gain of a given voice_idx in dB.

---

float get_voice_pan(voice_idx: int) const 

Returns the pan position of a given voice_idx. Negative values mean the left channel, positive mean the right.

---

float get_voice_rate_hz(voice_idx: int) const 

Returns the rate of a given voice_idx's low-frequency oscillator in Hz.

---

void set_voice_cutoff_hz(voice_idx: int, cutoff_hz: float) 

Sets the frequency threshold of a given voice_idx's low-pass filter in Hz. Frequencies above cutoff_hz are removed from voice_idx. Value can range from 1 to 20500.

---

void set_voice_delay_ms(voice_idx: int, delay_ms: float) 

Sets the delay of a given voice_idx in milliseconds, compared to the original audio. Value can range from 0 to 50.

---

void set_voice_depth_ms(voice_idx: int, depth_ms: float) 

Sets the depth of a given voice_idx's low-frequency oscillator in milliseconds. Value can range from 0 to 20.

---

void set_voice_level_db(voice_idx: int, level_db: float) 

Sets the gain of a given voice_idx in dB. Value can range from -60 to 24.

---

void set_voice_pan(voice_idx: int, pan: float) 

Sets the pan position of a given voice_idx. Negative values pan the sound to the left, positive pan to the right. Value can range from -1 to 1.

---

void set_voice_rate_hz(voice_idx: int, rate_hz: float) 

Sets the rate of a given voice_idx's low-frequency oscillator in Hz. Value can range from 0.1 to 20.
