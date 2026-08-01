# ResourceImporterOggVorbis

Inherits: ResourceImporter < RefCounted < Object

Imports an Ogg Vorbis audio file for playback.

## Description

Ogg Vorbis is a lossy audio format, with better audio quality compared to ResourceImporterMP3 at a given bitrate.

In most cases, it's recommended to use Ogg Vorbis over MP3. However, if you're using an MP3 sound source with no higher quality source available, then it's recommended to use the MP3 file directly to avoid double lossy compression.

Ogg Vorbis requires more CPU to decode than ResourceImporterWAV. If you need to play a lot of simultaneous sounds, it's recommended to use WAV for those sounds instead, especially if targeting low-end devices.

## Tutorials

- Importing audio samples

## Properties

int | bar_beats | 4
int | beat_count | 0
float | bpm | 0
bool | loop | false
float | loop_offset | 0

## Methods

AudioStreamOggVorbis | load_from_buffer(stream_data: PackedByteArray) static
AudioStreamOggVorbis | load_from_file(path: String) static

---

## Property Descriptions

int bar_beats = 4 

The number of beats within a single bar in the audio track. This is only relevant for music that wishes to make use of interactive music functionality, not sound effects.

A more convenient editor for bar_beats is provided in the Advanced Import Settings dialog, as it lets you preview your changes without having to reimport the audio.

---

int beat_count = 0 

The length of the audio track, in beats. The actual duration of the audio file might be longer than what is indicated by this property. This is only relevant for music that wishes to make use of interactive music functionality, not sound effects.

A more convenient editor for beat_count is provided in the Advanced Import Settings dialog, as it lets you preview your changes without having to reimport the audio.

---

float bpm = 0 

The tempo of the audio track, measured in beats per minute. This should match the BPM measure that was used to compose the track. This is only relevant for music that wishes to make use of interactive music functionality, not sound effects.

A more convenient editor for bpm is provided in the Advanced Import Settings dialog, as it lets you preview your changes without having to reimport the audio.

---

bool loop = false 

If enabled, the audio will begin playing either from the beginning or from loop_offset, after playback ends by either reaching the end of the audio or reaching the end of the last beat according to the amount specified in beat_count.

Note: In AudioStreamPlayer, the AudioStreamPlayer.finished signal won't be emitted for looping audio when it reaches the end of the audio file, as the audio will keep playing indefinitely.

---

float loop_offset = 0 

Determines where audio will start to loop after playback reaches the end of the audio. This can be used to only loop a part of the audio file, which is useful for some ambient sounds or music. The value is determined in seconds relative to the beginning of the audio. A value of 0.0 will loop the entire audio file.

Only has an effect if loop is true.

A more convenient editor for loop_offset is provided in the Advanced Import Settings dialog, as it lets you preview your changes without having to reimport the audio.

---

## Method Descriptions

AudioStreamOggVorbis load_from_buffer(stream_data: PackedByteArray) static 

Deprecated: Use AudioStreamOggVorbis.load_from_buffer() instead.

Creates a new AudioStreamOggVorbis instance from the given buffer. The buffer must contain Ogg Vorbis data.

---

AudioStreamOggVorbis load_from_file(path: String) static 

Deprecated: Use AudioStreamOggVorbis.load_from_file() instead.

Creates a new AudioStreamOggVorbis instance from the given file path. The file must be in Ogg Vorbis format.
