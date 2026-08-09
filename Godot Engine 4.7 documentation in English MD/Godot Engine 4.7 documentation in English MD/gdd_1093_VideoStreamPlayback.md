# VideoStreamPlayback

Inherits: Resource < RefCounted < Object

Internal class used by VideoStream to manage playback state when played from a VideoStreamPlayer.

## Description

This class is intended to be overridden by video decoder extensions with custom implementations of VideoStream.

## Methods

int | _get_channels() virtual const
float | _get_length() virtual const
int | _get_mix_rate() virtual const
float | _get_playback_position() virtual const
Texture2D | _get_texture() virtual const
bool | _is_paused() virtual const
bool | _is_playing() virtual const
void | _play() virtual
void | _seek(time: float) virtual
void | _set_audio_track(idx: int) virtual
void | _set_paused(paused: bool) virtual
void | _stop() virtual
void | _update(delta: float) virtual required
int | mix_audio(num_frames: int, buffer: PackedFloat32Array = PackedFloat32Array(), offset: int = 0)

---

## Method Descriptions

int _get_channels() virtual const 

Returns the number of audio channels.

---

float _get_length() virtual const 

Returns the video duration in seconds, if known, or 0 if unknown.

---

int _get_mix_rate() virtual const 

Returns the audio sample rate used for mixing.

---

float _get_playback_position() virtual const 

Return the current playback timestamp. Called in response to the VideoStreamPlayer.stream_position getter.

---

Texture2D _get_texture() virtual const 

Allocates a Texture2D in which decoded video frames will be drawn.

---

bool _is_paused() virtual const 

Returns the paused status, as set by _set_paused().

---

bool _is_playing() virtual const 

Returns the playback state, as determined by calls to _play() and _stop().

---

void _play() virtual 

Called in response to VideoStreamPlayer.autoplay or VideoStreamPlayer.play(). Note that manual playback may also invoke _stop() multiple times before this method is called. _is_playing() should return true once playing.

---

void _seek(time: float) virtual 

Seeks to time seconds. Called in response to the VideoStreamPlayer.stream_position setter.

---

void _set_audio_track(idx: int) virtual 

Select the audio track idx. Called when playback starts, and in response to the VideoStreamPlayer.audio_track setter.

---

void _set_paused(paused: bool) virtual 

Set the paused status of video playback. _is_paused() must return paused. Called in response to the VideoStreamPlayer.paused setter.

---

void _stop() virtual 

Stops playback. May be called multiple times before _play(), or in response to VideoStreamPlayer.stop(). _is_playing() should return false once stopped.

---

void _update(delta: float) virtual required 

Ticks video playback for delta seconds. Called every frame as long as both _is_paused() and _is_playing() return true.

---

int mix_audio(num_frames: int, buffer: PackedFloat32Array = PackedFloat32Array(), offset: int = 0) 

Render num_frames audio frames (of _get_channels() floats each) from buffer, starting from index offset in the array. Returns the number of audio frames rendered, or -1 on error.
