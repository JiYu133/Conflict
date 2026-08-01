# AudioEffectDelay

Inherits: AudioEffect < Resource < RefCounted < Object

Adds a delay audio effect to an audio bus.

Emulates an echo by playing the input audio back after a period of time.

## Description

A "delay" effect plays the input audio signal back after a period of time. Each repetition is called a "delay tap" or simply "tap". Delay taps may be played back multiple times to create the sound of a repeating, decaying echo. Delay effects range from a subtle echo to a pronounced blending of previous sounds with new sounds.

See also AudioEffectReverb for a blurry, continuous echo.

## Tutorials

- Audio buses
- Audio effects

## Properties

float | dry | 1.0
bool | feedback_active | false
float | feedback_delay_ms | 340.0
float | feedback_level_db | -6.0
float | feedback_lowpass | 16000.0
bool | tap1_active | true
float | tap1_delay_ms | 250.0
float | tap1_level_db | -6.0
float | tap1_pan | 0.2
bool | tap2_active | true
float | tap2_delay_ms | 500.0
float | tap2_level_db | -12.0
float | tap2_pan | -0.4

---

## Property Descriptions

float dry = 1.0 

- void set_dry(value: float)
- float get_dry()

The volume ratio of the original audio. Value can range from 0 to 1.

---

bool feedback_active = false 

- void set_feedback_active(value: bool)
- bool is_feedback_active()

If true, feedback is enabled, repeating taps after they are played.

---

float feedback_delay_ms = 340.0 

- void set_feedback_delay_ms(value: float)
- float get_feedback_delay_ms()

Feedback delay time in milliseconds. Value can range from 0 to 1500.

---

float feedback_level_db = -6.0 

- void set_feedback_level_db(value: float)
- float get_feedback_level_db()

Gain for feedback, in dB. Value can range from -60 to 0.

---

float feedback_lowpass = 16000.0 

- void set_feedback_lowpass(value: float)
- float get_feedback_lowpass()

Low-pass filter for feedback, in Hz. Frequencies above this value are filtered out. Value can range from 1 to 16000.

---

bool tap1_active = true 

- void set_tap1_active(value: bool)
- bool is_tap1_active()

If true, the first tap will be enabled.

---

float tap1_delay_ms = 250.0 

- void set_tap1_delay_ms(value: float)
- float get_tap1_delay_ms()

First tap delay time in milliseconds, compared to the original audio. Value can range from 0 to 1500.

---

float tap1_level_db = -6.0 

- void set_tap1_level_db(value: float)
- float get_tap1_level_db()

Gain for the first tap, in dB. Value can range from -60 to 0.

---

float tap1_pan = 0.2 

- void set_tap1_pan(value: float)
- float get_tap1_pan()

Pan position for the first tap. Negative values pan the sound to the left, positive pan to the right. Value can range from -1 to 1.

---

bool tap2_active = true 

- void set_tap2_active(value: bool)
- bool is_tap2_active()

If true, the second tap will be enabled.

---

float tap2_delay_ms = 500.0 

- void set_tap2_delay_ms(value: float)
- float get_tap2_delay_ms()

Second tap delay time in milliseconds, compared to the original audio. Value can range from 0 to 1500.

---

float tap2_level_db = -12.0 

- void set_tap2_level_db(value: float)
- float get_tap2_level_db()

Gain for the second tap, in dB. Value can range from -60 to 0.

---

float tap2_pan = -0.4 

- void set_tap2_pan(value: float)
- float get_tap2_pan()

Pan position for the second tap. Negative values pan the sound to the left, positive pan to the right. Value can range from -1 to 1.
