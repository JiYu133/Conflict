# AudioStreamPlaylist

Inherits: AudioStream < Resource < RefCounted < Object

AudioStream that includes sub-streams and plays them back like a playlist.

## Description

An audio stream that can play back sub-streams in sequence. Streams can be added to the Playlist with set_list_stream(), and shuffled with shuffle.

## Tutorials

- Audio streams

## Properties

float | fade_time | 0.3
bool | loop | true
bool | shuffle | false
int | stream_count | 0

## Methods

float | get_bpm() const
AudioStream | get_list_stream(stream_index: int) const
void | set_list_stream(stream_index: int, audio_stream: AudioStream)

---

## Constants

MAX_STREAMS = 64 

Maximum amount of streams supported in the playlist.

---

## Property Descriptions

float fade_time = 0.3 

- void set_fade_time(value: float)
- float get_fade_time()

Fade time used when a stream ends, when going to the next one. Streams are expected to have an extra bit of audio after the end to help with fading.

---

bool loop = true 

- void set_loop(value: bool)
- bool has_loop()

If true, the playlist will loop, otherwise the playlist will end when the last stream is finished.

---

bool shuffle = false 

- void set_shuffle(value: bool)
- bool get_shuffle()

If true, the playlist will shuffle each time playback starts and each time it loops.

---

int stream_count = 0 

- void set_stream_count(value: int)
- int get_stream_count()

Amount of streams in the playlist.

---

## Method Descriptions

float get_bpm() const 

Returns the BPM of the playlist, which can vary depending on the clip being played.

---

AudioStream get_list_stream(stream_index: int) const 

Returns the stream at playback position index.

---

void set_list_stream(stream_index: int, audio_stream: AudioStream) 

Sets the stream at playback position index.
