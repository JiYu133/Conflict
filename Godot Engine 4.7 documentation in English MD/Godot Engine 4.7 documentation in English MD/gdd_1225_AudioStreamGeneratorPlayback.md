# AudioStreamGeneratorPlayback

Inherits: AudioStreamPlaybackResampled < AudioStreamPlayback < RefCounted < Object

Plays back audio generated using AudioStreamGenerator.

## Description

This class is meant to be used with AudioStreamGenerator to play back the generated audio in real-time.

## Tutorials

- Audio Generator Demo [https://godotengine.org/asset-library/asset/2759]
- Godot 3.2 will get new audio features [https://godotengine.org/article/godot-32-will-get-new-audio-features]

## Methods

bool | can_push_buffer(amount: int) const
void | clear_buffer()
int | get_frames_available() const
int | get_skips() const
bool | push_buffer(frames: PackedVector2Array)
bool | push_frame(frame: Vector2)

---

## Method Descriptions

bool can_push_buffer(amount: int) const 

Returns true if a buffer of the size amount can be pushed to the audio sample data buffer without overflowing it, false otherwise.

---

void clear_buffer() 

Clears the audio sample data buffer.

---

int get_frames_available() const 

Returns the number of frames that can be pushed to the audio sample data buffer without overflowing it. If the result is 0, the buffer is full.

---

int get_skips() const 

Returns the number of times the playback skipped due to a buffer underrun in the audio sample data. This value is reset at the start of the playback.

---

bool push_buffer(frames: PackedVector2Array) 

Pushes several audio data frames to the buffer. This is usually more efficient than push_frame() in C# and compiled languages via GDExtension, but push_buffer() may be less efficient in GDScript.

---

bool push_frame(frame: Vector2) 

Pushes a single audio data frame to the buffer. This is usually less efficient than push_buffer() in C# and compiled languages via GDExtension, but push_frame() may be more efficient in GDScript.
