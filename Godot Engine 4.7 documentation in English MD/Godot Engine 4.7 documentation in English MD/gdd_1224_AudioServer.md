# AudioServer

Inherits: Object

Server interface for low-level audio access.

## Description

AudioServer is a low-level server interface for audio access. It is in charge of creating sample data (playable audio) as well as its playback via a voice interface.

## Tutorials

- Audio buses
- Audio Device Changer Demo [https://godotengine.org/asset-library/asset/2758]
- Audio Microphone Record Demo [https://godotengine.org/asset-library/asset/2760]
- Audio Spectrum Visualizer Demo [https://godotengine.org/asset-library/asset/2762]

## Properties

int | bus_count | 1
String | input_device | "Default"
String | output_device | "Default"
float | playback_speed_scale | 1.0

## Methods

void | add_bus(at_position: int = -1)
void | add_bus_effect(bus_idx: int, effect: AudioEffect, at_position: int = -1)
AudioBusLayout | generate_bus_layout() const
int | get_bus_channels(bus_idx: int) const
AudioEffect | get_bus_effect(bus_idx: int, effect_idx: int)
int | get_bus_effect_count(bus_idx: int)
AudioEffectInstance | get_bus_effect_instance(bus_idx: int, effect_idx: int, channel: int = 0)
int | get_bus_index(bus_name: StringName) const
String | get_bus_name(bus_idx: int) const
float | get_bus_peak_volume_left_db(bus_idx: int, channel: int) const
float | get_bus_peak_volume_right_db(bus_idx: int, channel: int) const
StringName | get_bus_send(bus_idx: int) const
float | get_bus_volume_db(bus_idx: int) const
float | get_bus_volume_linear(bus_idx: int) const
String | get_driver_name() const
int | get_input_buffer_length_frames()
PackedStringArray | get_input_device_list()
PackedVector2Array | get_input_frames(frames: int)
int | get_input_frames_available()
float | get_input_mix_rate() const
float | get_mix_rate() const
PackedStringArray | get_output_device_list()
float | get_output_latency() const
SpeakerMode | get_speaker_mode() const
float | get_time_since_last_mix() const
float | get_time_to_next_mix() const
bool | is_bus_bypassing_effects(bus_idx: int) const
bool | is_bus_effect_enabled(bus_idx: int, effect_idx: int) const
bool | is_bus_mute(bus_idx: int) const
bool | is_bus_solo(bus_idx: int) const
bool | is_stream_registered_as_sample(stream: AudioStream)
void | lock()
void | move_bus(index: int, to_index: int)
void | register_stream_as_sample(stream: AudioStream)
void | remove_bus(index: int)
void | remove_bus_effect(bus_idx: int, effect_idx: int)
void | set_bus_bypass_effects(bus_idx: int, enable: bool)
void | set_bus_effect_enabled(bus_idx: int, effect_idx: int, enabled: bool)
void | set_bus_layout(bus_layout: AudioBusLayout)
void | set_bus_mute(bus_idx: int, enable: bool)
void | set_bus_name(bus_idx: int, name: String)
void | set_bus_send(bus_idx: int, send: StringName)
void | set_bus_solo(bus_idx: int, enable: bool)
void | set_bus_volume_db(bus_idx: int, volume_db: float)
void | set_bus_volume_linear(bus_idx: int, volume_linear: float)
void | set_enable_tagging_used_audio_streams(enable: bool)
Error | set_input_device_active(active: bool)
void | swap_bus_effects(bus_idx: int, effect_idx: int, by_effect_idx: int)
void | unlock()

---

## Signals

bus_layout_changed() 

Emitted when an audio bus is added, deleted, or moved.

---

bus_renamed(bus_index: int, old_name: StringName, new_name: StringName) 

Emitted when the audio bus at bus_index is renamed from old_name to new_name.

---

## Enumerations

enum SpeakerMode
SpeakerMode SPEAKER_MODE_STEREO = 0

Two or fewer speakers were detected.

SpeakerMode SPEAKER_SURROUND_31 = 1

A 3.1 channel surround setup was detected.

SpeakerMode SPEAKER_SURROUND_51 = 2

A 5.1 channel surround setup was detected.

SpeakerMode SPEAKER_SURROUND_71 = 3

A 7.1 channel surround setup was detected.

---

enum PlaybackType
PlaybackType PLAYBACK_TYPE_DEFAULT = 0

Experimental: This constant may be changed or removed in future versions.

The playback will be considered of the type declared at ProjectSettings.audio/general/default_playback_type.

PlaybackType PLAYBACK_TYPE_STREAM = 1

Experimental: This constant may be changed or removed in future versions.

Force the playback to be considered as a stream.

PlaybackType PLAYBACK_TYPE_SAMPLE = 2

Experimental: This constant may be changed or removed in future versions.

Force the playback to be considered as a sample. This can provide lower latency and more stable playback (with less risk of audio crackling), at the cost of having less flexibility.

Note: Only currently supported on the web platform.

Note: AudioEffects are not supported when playback is considered as a sample.

PlaybackType PLAYBACK_TYPE_MAX = 3

Experimental: This constant may be changed or removed in future versions.

Represents the size of the PlaybackType enum.

---

## Property Descriptions

int bus_count = 1 

- void set_bus_count(value: int)
- int get_bus_count()

Number of available audio buses.

---

String input_device = "Default" 

- void set_input_device(value: String)
- String get_input_device()

Name of the current device for audio input (see get_input_device_list()). On systems with multiple audio inputs (such as analog, USB and HDMI audio), this can be used to select the audio input device. The value "Default" will record audio on the system-wide default audio input. If an invalid device name is set, the value will be reverted back to "Default".

Note: ProjectSettings.audio/driver/enable_input must be true for audio input to work. See also that setting's description for caveats related to permissions and operating system privacy settings.

---

String output_device = "Default" 

- void set_output_device(value: String)
- String get_output_device()

Name of the current device for audio output (see get_output_device_list()). On systems with multiple audio outputs (such as analog, USB and HDMI audio), this can be used to select the audio output device. The value "Default" will play audio on the system-wide default audio output. If an invalid device name is set, the value will be reverted back to "Default".

---

float playback_speed_scale = 1.0 

- void set_playback_speed_scale(value: float)
- float get_playback_speed_scale()

Scales the rate at which audio is played (i.e. setting it to 0.5 will make the audio be played at half its speed). See also Engine.time_scale to affect the general simulation speed, which is independent from playback_speed_scale.

---

## Method Descriptions

void add_bus(at_position: int = -1) 

Adds a bus at at_position.

---

void add_bus_effect(bus_idx: int, effect: AudioEffect, at_position: int = -1) 

Adds an AudioEffect effect to the bus bus_idx at at_position.

---

AudioBusLayout generate_bus_layout() const 

Generates an AudioBusLayout using the available buses and effects.

---

int get_bus_channels(bus_idx: int) const 

Returns the number of channels of the bus at index bus_idx.

---

AudioEffect get_bus_effect(bus_idx: int, effect_idx: int) 

Returns the AudioEffect at position effect_idx in bus bus_idx.

---

int get_bus_effect_count(bus_idx: int) 

Returns the number of effects on the bus at bus_idx.

---

AudioEffectInstance get_bus_effect_instance(bus_idx: int, effect_idx: int, channel: int = 0) 

Returns the AudioEffectInstance assigned to the given bus and effect indices (and optionally channel).

---

int get_bus_index(bus_name: StringName) const 

Returns the index of the bus with the name bus_name. Returns -1 if no bus with the specified name exist.

---

String get_bus_name(bus_idx: int) const 

Returns the name of the bus with the index bus_idx.

---

float get_bus_peak_volume_left_db(bus_idx: int, channel: int) const 

Returns the peak volume of the left speaker at bus index bus_idx and channel index channel.

---

float get_bus_peak_volume_right_db(bus_idx: int, channel: int) const 

Returns the peak volume of the right speaker at bus index bus_idx and channel index channel.

---

StringName get_bus_send(bus_idx: int) const 

Returns the name of the bus that the bus at index bus_idx sends to.

---

float get_bus_volume_db(bus_idx: int) const 

Returns the volume of the bus at index bus_idx in dB.

---

float get_bus_volume_linear(bus_idx: int) const 

Returns the volume of the bus at index bus_idx as a linear value.

Note: The returned value is equivalent to the result of @GlobalScope.db_to_linear() on the result of get_bus_volume_db().

---

String get_driver_name() const 

Returns the name of the current audio driver. The default usually depends on the operating system, but may be overridden via the --audio-driver command line argument. --headless also automatically sets the audio driver to Dummy. See also ProjectSettings.audio/driver/driver.

---

int get_input_buffer_length_frames() 

Experimental: This method may be changed or removed in future versions.

Returns the absolute size of the microphone input buffer. This is set to a multiple of the audio latency and can be used to estimate the minimum rate at which the frames need to be fetched.

---

PackedStringArray get_input_device_list() 

Returns the names of all audio input devices detected on the system.

Note: ProjectSettings.audio/driver/enable_input must be true for audio input to work. See also that setting's description for caveats related to permissions and operating system privacy settings.

---

PackedVector2Array get_input_frames(frames: int) 

Experimental: This method may be changed or removed in future versions.

Returns a PackedVector2Array containing exactly frames audio samples from the internal microphone buffer if available, otherwise returns an empty PackedVector2Array.

The buffer is filled at the rate of get_input_mix_rate() frames per second when set_input_device_active() has successfully been set to true.

The samples are signed floating-point PCM values between -1 and 1.

---

int get_input_frames_available() 

Experimental: This method may be changed or removed in future versions.

Returns the number of frames available to read using get_input_frames().

---

float get_input_mix_rate() const 

Returns the sample rate at the input of the AudioServer.

---

float get_mix_rate() const 

Returns the sample rate at the output of the AudioServer.

---

PackedStringArray get_output_device_list() 

Returns the names of all audio output devices detected on the system.

---

float get_output_latency() const 

Returns the audio driver's effective output latency. This is based on ProjectSettings.audio/driver/output_latency, but the exact returned value will differ depending on the operating system and audio driver.

Note: This can be expensive; it is not recommended to call get_output_latency() every frame.

---

SpeakerMode get_speaker_mode() const 

Returns the speaker configuration.

---

float get_time_since_last_mix() const 

Returns the relative time since the last mix occurred, in seconds.

---

float get_time_to_next_mix() const 

Returns the relative time until the next mix occurs, in seconds.

---

bool is_bus_bypassing_effects(bus_idx: int) const 

If true, the bus at index bus_idx is bypassing effects.

---

bool is_bus_effect_enabled(bus_idx: int, effect_idx: int) const 

If true, the effect at index effect_idx on the bus at index bus_idx is enabled.

---

bool is_bus_mute(bus_idx: int) const 

If true, the bus at index bus_idx is muted.

---

bool is_bus_solo(bus_idx: int) const 

If true, the bus at index bus_idx is in solo mode.

---

bool is_stream_registered_as_sample(stream: AudioStream) 

Experimental: This method may be changed or removed in future versions.

If true, the stream is registered as a sample. The engine will not have to register it before playing the sample.

If false, the stream will have to be registered before playing it. To prevent lag spikes, register the stream as sample with register_stream_as_sample().

---

void lock() 

Locks the audio driver's main loop.

Note: Remember to unlock it afterwards.

---

void move_bus(index: int, to_index: int) 

Moves the bus from index index to index to_index.

---

void register_stream_as_sample(stream: AudioStream) 

Experimental: This method may be changed or removed in future versions.

Forces the registration of a stream as a sample.

Note: Lag spikes may occur when calling this method, especially on single-threaded builds. It is suggested to call this method while loading assets, where the lag spike could be masked, instead of registering the sample right before it needs to be played.

---

void remove_bus(index: int) 

Removes the bus at index index.

---

void remove_bus_effect(bus_idx: int, effect_idx: int) 

Removes the effect at index effect_idx from the bus at index bus_idx.

---

void set_bus_bypass_effects(bus_idx: int, enable: bool) 

If true, the bus at index bus_idx is bypassing effects.

---

void set_bus_effect_enabled(bus_idx: int, effect_idx: int, enabled: bool) 

If true, the effect at index effect_idx on the bus at index bus_idx is enabled.

---

void set_bus_layout(bus_layout: AudioBusLayout) 

Overwrites the currently used AudioBusLayout.

---

void set_bus_mute(bus_idx: int, enable: bool) 

If true, the bus at index bus_idx is muted.

---

void set_bus_name(bus_idx: int, name: String) 

Sets the name of the bus at index bus_idx to name.

---

void set_bus_send(bus_idx: int, send: StringName) 

Connects the output of the bus at bus_idx to the bus named send.

---

void set_bus_solo(bus_idx: int, enable: bool) 

If true, the bus at index bus_idx is in solo mode.

---

void set_bus_volume_db(bus_idx: int, volume_db: float) 

Sets the volume in decibels of the bus at index bus_idx to volume_db.

---

void set_bus_volume_linear(bus_idx: int, volume_linear: float) 

Sets the volume as a linear value of the bus at index bus_idx to volume_linear.

Note: Using this method is equivalent to calling set_bus_volume_db() with the result of @GlobalScope.linear_to_db() on a value.

---

void set_enable_tagging_used_audio_streams(enable: bool) 

If set to true, all instances of AudioStreamPlayback will call AudioStreamPlayback._tag_used_streams() every mix step.

Note: This is enabled by default in the editor, as it is used by editor plugins for the audio stream previews.

---

Error set_input_device_active(active: bool) 

Experimental: This method may be changed or removed in future versions.

If active is true, starts the microphone input stream specified by input_device or returns an error if it failed.

If active is false, stops the input stream if it is running.

---

void swap_bus_effects(bus_idx: int, effect_idx: int, by_effect_idx: int) 

Swaps the position of two effects in bus bus_idx.

---

void unlock() 

Unlocks the audio driver's main loop. (After locking it, you should always unlock it.)
