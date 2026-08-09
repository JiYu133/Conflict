# AudioStreamSynchronized

Inherits: AudioStream < Resource < RefCounted < Object

Stream that can be fitted with sub-streams, which will be played in-sync.

## Description

This is a stream that can be fitted with sub-streams, which will be played in-sync. The streams begin at exactly the same time when play is pressed, and will end when the last of them ends. If one of the sub-streams loops, then playback will continue.

## Tutorials

- Audio streams

## Properties

int | stream_count | 0

## Methods

AudioStream | get_sync_stream(stream_index: int) const
float | get_sync_stream_volume(stream_index: int) const
void | set_sync_stream(stream_index: int, audio_stream: AudioStream)
void | set_sync_stream_volume(stream_index: int, volume_db: float)

---

## Constants

MAX_STREAMS = 32 

Maximum amount of streams that can be synchronized.

---

## Property Descriptions

int stream_count = 0 

- void set_stream_count(value: int)
- int get_stream_count()

Set the total amount of streams that will be played back synchronized.

---

## Method Descriptions

AudioStream get_sync_stream(stream_index: int) const 

Get one of the synchronized streams, by index.

---

float get_sync_stream_volume(stream_index: int) const 

Get the volume of one of the synchronized streams, by index.

---

void set_sync_stream(stream_index: int, audio_stream: AudioStream) 

Set one of the synchronized streams, by index.

---

void set_sync_stream_volume(stream_index: int, volume_db: float) 

Set the volume of one of the synchronized streams, by index.
