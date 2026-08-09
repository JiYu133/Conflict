# AudioStreamPlayback

Inherits: RefCounted < Object

Inherited By: AudioStreamPlaybackInteractive, AudioStreamPlaybackPlaylist, AudioStreamPlaybackPolyphonic, AudioStreamPlaybackResampled, AudioStreamPlaybackSynchronized

Meta class for playing back audio.

## Description

Can play, loop, pause a scroll through audio. See AudioStream and AudioStreamOggVorbis for usage.

## Tutorials

- Audio Generator Demo [https://godotengine.org/asset-library/asset/2759]

## Methods

int | _get_loop_count() virtual const
Variant | _get_parameter(name: StringName) virtual const
float | _get_playback_position() virtual required const
bool | _is_playing() virtual required const
int | _mix(buffer: AudioFrame*, rate_scale: float, frames: int) virtual required
void | _seek(position: float) virtual
void | _set_parameter(name: StringName, value: Variant) virtual
void | _start(from_pos: float) virtual required
void | _stop() virtual required
void | _tag_used_streams() virtual
int | get_loop_count() const
float | get_playback_position() const
AudioSamplePlayback | get_sample_playback() const
bool | is_playing() const
PackedVector2Array | mix_audio(rate_scale: float, frames: int)
void | seek(time: float = 0.0)
void | set_sample_playback(playback_sample: AudioSamplePlayback)
void | start(from_pos: float = 0.0)
void | stop()

---

## Method Descriptions

int _get_loop_count() virtual const 

Overridable method. Should return how many times this audio stream has looped. Most built-in playbacks always return 0.

---

Variant _get_parameter(name: StringName) virtual const 

Return the current value of a playback parameter by name (see AudioStream._get_parameter_list()).

---

float _get_playback_position() virtual required const 

Overridable method. Should return the current progress along the audio stream, in seconds.

---

bool _is_playing() virtual required const 

Overridable method. Should return true if this playback is active and playing its audio stream.

---

int _mix(buffer: AudioFrame*, rate_scale: float, frames: int) virtual required 

Override this method to customize how the audio stream is mixed. This method is called even if the playback is not active.

Note: It is not useful to override this method in GDScript or C#. Only GDExtension can take advantage of it.

---

void _seek(position: float) virtual 

Override this method to customize what happens when seeking this audio stream at the given position, such as by calling AudioStreamPlayer.seek().

---

void _set_parameter(name: StringName, value: Variant) virtual 

Set the current value of a playback parameter by name (see AudioStream._get_parameter_list()).

---

void _start(from_pos: float) virtual required 

Override this method to customize what happens when the playback starts at the given position, such as by calling AudioStreamPlayer.play().

---

void _stop() virtual required 

Override this method to customize what happens when the playback is stopped, such as by calling AudioStreamPlayer.stop().

---

void _tag_used_streams() virtual 

Overridable method. Called whenever the audio stream is mixed if the playback is active and AudioServer.set_enable_tagging_used_audio_streams() has been set to true. Editor plugins may use this method to "tag" the current position along the audio stream and display it in a preview.

---

int get_loop_count() const 

Returns the number of times the stream has looped.

---

float get_playback_position() const 

Returns the current position in the stream, in seconds.

---

AudioSamplePlayback get_sample_playback() const 

Experimental: This method may be changed or removed in future versions.

Returns the AudioSamplePlayback associated with this AudioStreamPlayback for playing back the audio sample of this stream.

---

bool is_playing() const 

Returns true if the stream is playing.

---

PackedVector2Array mix_audio(rate_scale: float, frames: int) 

Mixes up to frames of audio from the stream from the current position, at a rate of rate_scale, advancing the stream.

Returns a PackedVector2Array where each element holds the left and right channel volume levels of each frame.

Note: Can return fewer frames than requested, make sure to use the size of the return value.

---

void seek(time: float = 0.0) 

Seeks the stream at the given time, in seconds.

---

void set_sample_playback(playback_sample: AudioSamplePlayback) 

Experimental: This method may be changed or removed in future versions.

Associates AudioSamplePlayback to this AudioStreamPlayback for playing back the audio sample of this stream.

---

void start(from_pos: float = 0.0) 

Starts the stream from the given from_pos, in seconds.

---

void stop() 

Stops the stream.
