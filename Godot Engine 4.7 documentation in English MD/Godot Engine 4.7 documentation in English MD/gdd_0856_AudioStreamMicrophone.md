# AudioStreamMicrophone

Inherits: AudioStream < Resource < RefCounted < Object

Plays real-time audio input data.

## Description

When used directly in an AudioStreamPlayer node, AudioStreamMicrophone plays back microphone input in real-time. This can be used in conjunction with AudioEffectCapture to process the data or save it.

Note: ProjectSettings.audio/driver/enable_input must be true for audio input to work. See also that setting's description for caveats related to permissions and operating system privacy settings.

## Tutorials

- Audio streams
- Recording with microphone
- Audio Mic Record Demo [https://github.com/godotengine/godot-demo-projects/tree/master/audio/mic_record]
