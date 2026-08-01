# AudioStreamPlaybackResampled

Inherits: AudioStreamPlayback < RefCounted < Object

Inherited By: AudioStreamGeneratorPlayback, AudioStreamPlaybackOggVorbis

Playback class used for resampled AudioStreams.

## Description

Playback class used to mix an AudioStream's audio samples to AudioServer.get_mix_rate() using cubic interpolation.

## Methods

float | _get_stream_sampling_rate() virtual required const
int | _mix_resampled(dst_buffer: AudioFrame*, frame_count: int) virtual required
void | begin_resample()

---

## Method Descriptions

float _get_stream_sampling_rate() virtual required const 

Returns an AudioStream's sample rate, in Hz. Used to perform resampling.

---

int _mix_resampled(dst_buffer: AudioFrame*, frame_count: int) virtual required 

Called by begin_resample() to mix an AudioStream to AudioServer.get_mix_rate(). Uses _get_stream_sampling_rate() as the source sample rate. Returns the number of mixed frames.

---

void begin_resample() 

Called when an AudioStream is played. Clears the cubic interpolation history and starts mixing by calling _mix_resampled().
