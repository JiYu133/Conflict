# ResourceImporterWAV

Inherits: ResourceImporter < RefCounted < Object

Imports a WAV audio file for playback.

## Description

WAV is an uncompressed format, which can provide higher quality compared to Ogg Vorbis and MP3. It also has the lowest CPU cost to decode. This means high numbers of WAV sounds can be played at the same time, even on low-end devices.

By default, Godot imports WAV files using the lossy Quite OK Audio compression. You may change this by setting the compress/mode property.

## Tutorials

- Importing audio samples

## Properties

int | compress/mode | 2
int | edit/loop_begin | 0
int | edit/loop_end | -1
int | edit/loop_mode | 0
bool | edit/normalize | false
bool | edit/trim | false
bool | force/8_bit | false
bool | force/max_rate | false
float | force/max_rate_hz | 44100
bool | force/mono | false

---

## Property Descriptions

int compress/mode = 2 

The compression mode to use on import.

- PCM (Uncompressed): Imports audio data without any form of compression, preserving the highest possible quality. It has the lowest CPU cost, but the highest memory usage.
- IMA ADPCM: Applies fast, lossy compression during import, noticeably decreasing the quality, but with low CPU cost and memory usage. Does not support seeking and only Forward loop mode is supported.
- `Quite OK Audio `__: Also applies lossy compression on import, having a slightly higher CPU cost compared to IMA ADPCM, but much higher quality and the lowest memory usage.

---

int edit/loop_begin = 0 

The begin loop point to use when edit/loop_mode is Forward, Ping-Pong, or Backward. This is set in samples after the beginning of the audio file.

---

int edit/loop_end = -1 

The end loop point to use when edit/loop_mode is Forward, Ping-Pong, or Backward. This is set in samples after the beginning of the audio file. A value of -1 uses the end of the audio file as the end loop point.

---

int edit/loop_mode = 0 

Controls how audio should loop.

- Detect From WAV: Uses loop information from the WAV metadata.
- Disabled: Don't loop audio, even if the metadata indicates the file playback should loop.
- Forward: Standard audio looping. Plays the audio forward from the beginning to edit/loop_end, then returns to edit/loop_begin and repeats.
- Ping-Pong: Plays the audio forward until edit/loop_end, then backwards to edit/loop_begin, repeating this cycle.
- Backward: Plays the audio backwards from edit/loop_end to edit/loop_begin, then repeats.

Note: In AudioStreamPlayer, the AudioStreamPlayer.finished signal won't be emitted for looping audio when it reaches the end of the audio file, as the audio will keep playing indefinitely.

---

bool edit/normalize = false 

If true, normalize the audio volume so that its peak volume is equal to 0 dB. When enabled, normalization will make audio sound louder depending on its original peak volume.

---

bool edit/trim = false 

If true, automatically trim the beginning and end of the audio if it's lower than -50 dB after normalization (see edit/normalize). This prevents having files with silence at the beginning or end, which increases their size unnecessarily and adds latency to the moment they are played back. A fade-in/fade-out period of 500 samples is also used during trimming to avoid audible pops.

---

bool force/8_bit = false 

If true, forces the imported audio to use 8-bit quantization if the source file is 16-bit or higher.

Enabling this is generally not recommended, as 8-bit quantization decreases audio quality significantly. If you need smaller file sizes, consider using Ogg Vorbis or MP3 audio instead.

---

bool force/max_rate = false 

If set to a value greater than 0, forces the audio's sample rate to be reduced to a value lower than or equal to the value specified in force/max_rate_hz.

This can decrease file size noticeably on certain sounds, without impacting quality depending on the actual sound's contents. See Best practices for more information.

---

float force/max_rate_hz = 44100 

The frequency to limit the imported audio sample to (in Hz). Only effective if force/max_rate is true.

---

bool force/mono = false 

If true, forces the imported audio to be mono if the source file is stereo. This decreases the file size by 50% by merging the two channels into one.
