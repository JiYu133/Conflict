# AudioEffectRecord

Inherits: AudioEffect < Resource < RefCounted < Object

Audio effect used for recording the sound from an audio bus.

## Description

Allows the user to record the sound from an audio bus into an AudioStreamWAV. When used on the Master audio bus, this includes all audio output by Godot.

Unlike AudioEffectCapture, this effect encodes the recording with the given format (8-bit, 16-bit, or compressed) instead of giving access to the raw audio samples.

Can be used (with an AudioStreamMicrophone) to record from a microphone.

Note: ProjectSettings.audio/driver/enable_input must be true for audio input to work. See also that setting's description for caveats related to permissions and operating system privacy settings.

## Tutorials

- Recording with microphone
- Audio Microphone Record Demo [https://godotengine.org/asset-library/asset/2760]

## Properties

Format | format | 1

## Methods

AudioStreamWAV | get_recording() const
bool | is_recording_active() const
void | set_recording_active(record: bool)

---

## Property Descriptions

Format format = 1 

- void set_format(value: Format)
- Format get_format()

Specifies the format in which the sample will be recorded.

---

## Method Descriptions

AudioStreamWAV get_recording() const 

Returns the recorded sample.

---

bool is_recording_active() const 

Returns whether the recording is active or not.

---

void set_recording_active(record: bool) 

If true, the sound will be recorded. Note that restarting the recording will remove the previously recorded sample.
