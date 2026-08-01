# AudioStreamOggVorbis

Inherits: AudioStream < Resource < RefCounted < Object

A class representing an Ogg Vorbis audio stream.

## Description

The AudioStreamOggVorbis class is a specialized AudioStream for handling Ogg Vorbis file formats. It offers functionality for loading and playing back Ogg Vorbis files, as well as managing looping and other playback properties. More info can be found in ResourceImporterOggVorbis.

This class is part of the audio stream system, which also supports WAV files through the AudioStreamWAV class, and MP3 files through the AudioStreamMP3 class.

## Tutorials

- Audio streams
- Runtime file loading and saving

## Properties

int | bar_beats | 4
int | beat_count | 0
float | bpm | 0.0
bool | loop | false
float | loop_offset | 0.0
OggPacketSequence | packet_sequence |
Dictionary | tags | {}

## Methods

AudioStreamOggVorbis | load_from_buffer(stream_data: PackedByteArray) static
AudioStreamOggVorbis | load_from_file(path: String) static

---

## Property Descriptions

int bar_beats = 4 

- void set_bar_beats(value: int)
- int get_bar_beats()

The number of beats within a single bar in the audio track.

---

int beat_count = 0 

- void set_beat_count(value: int)
- int get_beat_count()

The length of the audio track, in beats. The actual duration of the audio file might be longer than what is indicated by this property. It defines the end of the audio for looping, AudioStreamPlaylist, and AudioStreamInteractive.

---

float bpm = 0.0 

- void set_bpm(value: float)
- float get_bpm()

The tempo of the audio track, measured in beats per minute.

---

bool loop = false 

- void set_loop(value: bool)
- bool has_loop()

If true, the stream will play again from the specified loop_offset once it reaches the end of the audio track, or once it reaches the end of the last beat according to the amount specified in beat_count. Useful for ambient sounds and background music.

---

float loop_offset = 0.0 

- void set_loop_offset(value: float)
- float get_loop_offset()

Time in seconds at which the stream starts after being looped.

---

OggPacketSequence packet_sequence 

- void set_packet_sequence(value: OggPacketSequence)
- OggPacketSequence get_packet_sequence()

Contains the raw Ogg data for this stream.

---

Dictionary tags = {} 

- void set_tags(value: Dictionary)
- Dictionary get_tags()

Contains user-defined tags if found in the Ogg Vorbis data.

Commonly used tags include title, artist, album, tracknumber, and date (date does not have a standard date format).

Note: No tag is guaranteed to be present in every file, so make sure to account for the keys not always existing.

---

## Method Descriptions

AudioStreamOggVorbis load_from_buffer(stream_data: PackedByteArray) static 

Creates a new AudioStreamOggVorbis instance from the given buffer. The buffer must contain Ogg Vorbis data.

---

AudioStreamOggVorbis load_from_file(path: String) static 

Creates a new AudioStreamOggVorbis instance from the given file path. The file must be in Ogg Vorbis format.
