# AudioStreamPlayer

Inherits: Node < Object

A node for audio playback.

## Description

The AudioStreamPlayer node plays an audio stream non-positionally. It is ideal for user interfaces, menus, or background music.

To use this node, stream needs to be set to a valid AudioStream resource. Playing more than one sound at the same time is also supported, see max_polyphony.

If you need to play audio at a specific position, use AudioStreamPlayer2D or AudioStreamPlayer3D instead.

## Tutorials

- Audio streams
- 2D Dodge The Creeps Demo [https://godotengine.org/asset-library/asset/2712]
- Audio Device Changer Demo [https://godotengine.org/asset-library/asset/2758]
- Audio Generator Demo [https://godotengine.org/asset-library/asset/2759]
- Audio Microphone Record Demo [https://godotengine.org/asset-library/asset/2760]
- Audio Spectrum Visualizer Demo [https://godotengine.org/asset-library/asset/2762]

## Properties

bool | autoplay | false
StringName | bus | &"Master"
int | max_polyphony | 1
MixTarget | mix_target | 0
float | pitch_scale | 1.0
PlaybackType | playback_type | 0
bool | playing | false
AudioStream | stream |
bool | stream_paused | false
float | volume_db | 0.0
float | volume_linear |

## Methods

float | get_playback_position()
AudioStreamPlayback | get_stream_playback()
bool | has_stream_playback()
void | play(from_position: float = 0.0)
void | seek(to_position: float)
void | stop()

---

## Signals

finished() 

Emitted when a sound finishes playing without interruptions. This signal is not emitted when calling stop(), or when exiting the tree while sounds are playing.

---

## Enumerations

enum MixTarget
MixTarget MIX_TARGET_STEREO = 0

The audio will be played only on the first channel. This is the default.

MixTarget MIX_TARGET_SURROUND = 1

The audio will be played on all surround channels.

MixTarget MIX_TARGET_CENTER = 2

The audio will be played on the second channel, which is usually the center.

---

## Property Descriptions

bool autoplay = false 

- void set_autoplay(value: bool)
- bool is_autoplay_enabled()

If true, this node calls play() when entering the tree.

---

StringName bus = &"Master" 

- void set_bus(value: StringName)
- StringName get_bus()

The target bus name. All sounds from this node will be playing on this bus.

Note: At runtime, if no bus with the given name exists, all sounds will fall back on "Master". See also AudioServer.get_bus_name().

---

int max_polyphony = 1 

- void set_max_polyphony(value: int)
- int get_max_polyphony()

The maximum number of sounds this node can play at the same time. Calling play() after this value is reached will cut off the oldest sounds.

---

MixTarget mix_target = 0 

- void set_mix_target(value: MixTarget)
- MixTarget get_mix_target()

The mix target channels. Has no effect when two speakers or less are detected (see SpeakerMode).

---

float pitch_scale = 1.0 

- void set_pitch_scale(value: float)
- float get_pitch_scale()

The audio's pitch and tempo, as a multiplier of the stream's sample rate. A value of 2.0 doubles the audio's pitch, while a value of 0.5 halves the pitch.

---

PlaybackType playback_type = 0 

- void set_playback_type(value: PlaybackType)
- PlaybackType get_playback_type()

Experimental: This property may be changed or removed in future versions.

The playback type of the stream player. If set other than to the default value, it will force that playback type.

---

bool playing = false 

- void set_playing(value: bool)
- bool is_playing()

If true, this node is playing sounds. Setting this property has the same effect as play() and stop().

---

AudioStream stream 

- void set_stream(value: AudioStream)
- AudioStream get_stream()

The AudioStream resource to be played. Setting this property stops all currently playing sounds. If left empty, the AudioStreamPlayer does not work.

---

bool stream_paused = false 

- void set_stream_paused(value: bool)
- bool get_stream_paused()

If true, the sounds are paused. Setting stream_paused to false resumes all sounds.

Note: This property is automatically changed when exiting or entering the tree, or this node is paused (see Node.process_mode).

---

float volume_db = 0.0 

- void set_volume_db(value: float)
- float get_volume_db()

Volume of sound, in decibels. This is an offset of the stream's volume.

Note: To convert between decibel and linear energy (like most volume sliders do), use volume_linear, or @GlobalScope.db_to_linear() and @GlobalScope.linear_to_db().

---

float volume_linear 

- void set_volume_linear(value: float)
- float get_volume_linear()

Volume of sound, as a linear value.

Note: This member modifies volume_db for convenience. The returned value is equivalent to the result of @GlobalScope.db_to_linear() on volume_db. Setting this member is equivalent to setting volume_db to the result of @GlobalScope.linear_to_db() on a value.

---

## Method Descriptions

float get_playback_position() 

Returns the position in the AudioStream of the latest sound, in seconds. Returns 0.0 if no sounds are playing.

Note: The position is not always accurate, as the AudioServer does not mix audio every processed frame. To get more accurate results, add AudioServer.get_time_since_last_mix() to the returned position.

Note: This method always returns 0.0 if the stream is an AudioStreamInteractive, since it can have multiple clips playing at once.

---

AudioStreamPlayback get_stream_playback() 

Returns the latest AudioStreamPlayback of this node, usually the most recently created by play(). If no sounds are playing, this method fails and returns an empty playback.

---

bool has_stream_playback() 

Returns true if any sound is active, even if stream_paused is set to true. See also playing and get_stream_playback().

---

void play(from_position: float = 0.0) 

Plays a sound from the beginning, or the given from_position in seconds.

---

void seek(to_position: float) 

Restarts all sounds to be played from the given to_position, in seconds. Does nothing if no sounds are playing.

---

void stop() 

Stops all sounds from this node.
