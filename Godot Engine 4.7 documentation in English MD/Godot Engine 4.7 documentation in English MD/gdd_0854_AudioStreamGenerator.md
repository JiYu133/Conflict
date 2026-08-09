# AudioStreamGenerator

Inherits: AudioStream < Resource < RefCounted < Object

An audio stream with utilities for procedural sound generation.

## Description

AudioStreamGenerator is a type of audio stream that does not play back sounds on its own; instead, it expects a script to generate audio data for it. See also AudioStreamGeneratorPlayback.

Here's a sample on how to use it to generate a sine wave:

```
var playback # Will hold the AudioStreamGeneratorPlayback.
@onready var sample_hz = $AudioStreamPlayer.stream.mix_rate
var pulse_hz = 440.0 # The frequency of the sound wave.
var phase = 0.0
func _ready():
    $AudioStreamPlayer.play()
    playback = $AudioStreamPlayer.get_stream_playback()
    fill_buffer()
func fill_buffer():
    var increment = pulse_hz / sample_hz
    var frames_available = playback.get_frames_available()
    for i in range(frames_available):
        playback.push_frame(Vector2.ONE * sin(phase * TAU))
        phase = fmod(phase + increment, 1.0)
```

```
[Export] public AudioStreamPlayer Player { get; set; }
private AudioStreamGeneratorPlayback _playback; // Will hold the AudioStreamGeneratorPlayback.
private float _sampleHz;
private float _pulseHz = 440.0f; // The frequency of the sound wave.
private double phase = 0.0;
public override void _Ready()
{
    if (Player.Stream is AudioStreamGenerator generator) // Type as a generator to access MixRate.
    {
        _sampleHz = generator.MixRate;
        Player.Play();
        _playback = (AudioStreamGeneratorPlayback)Player.GetStreamPlayback();
        FillBuffer();
    }
}
public void FillBuffer()
{
    float increment = _pulseHz / _sampleHz;
    int framesAvailable = _playback.GetFramesAvailable();
    for (int i = 0; i < framesAvailable; i++)
    {
        _playback.PushFrame(Vector2.One * (float)Mathf.Sin(phase * Mathf.Tau));
        phase = Mathf.PosMod(phase + increment, 1.0);
    }
}
```

In the example above, the "AudioStreamPlayer" node must use an AudioStreamGenerator as its stream. The fill_buffer function provides audio data for approximating a sine wave.

See also AudioEffectSpectrumAnalyzer for performing real-time audio spectrum analysis.

Note: Due to performance constraints, this class is best used from C# or from a compiled language via GDExtension. If you still want to use this class from GDScript, consider using a lower mix_rate such as 11,025 Hz or 22,050 Hz.

## Tutorials

- Audio streams
- Audio Generator Demo [https://godotengine.org/asset-library/asset/2759]

## Properties

float | buffer_length | 0.5
float | mix_rate | 44100.0
AudioStreamGeneratorMixRate | mix_rate_mode | 2

---

## Enumerations

enum AudioStreamGeneratorMixRate
AudioStreamGeneratorMixRate MIX_RATE_OUTPUT = 0

Current AudioServer output mixing rate.

AudioStreamGeneratorMixRate MIX_RATE_INPUT = 1

Current AudioServer input mixing rate.

AudioStreamGeneratorMixRate MIX_RATE_CUSTOM = 2

Custom mixing rate, specified by mix_rate.

AudioStreamGeneratorMixRate MIX_RATE_MAX = 3

Maximum value for the mixing rate mode enum.

---

## Property Descriptions

float buffer_length = 0.5 

- void set_buffer_length(value: float)
- float get_buffer_length()

The length of the buffer to generate (in seconds). Lower values result in less latency, but require the script to generate audio data faster, resulting in increased CPU usage and more risk for audio cracking if the CPU can't keep up.

---

float mix_rate = 44100.0 

- void set_mix_rate(value: float)
- float get_mix_rate()

The sample rate to use (in Hz). Higher values are more demanding for the CPU to generate, but result in better quality.

In games, common sample rates in use are 11025, 16000, 22050, 32000, 44100, and 48000.

According to the Nyquist-Shannon sampling theorem [https://en.wikipedia.org/wiki/Nyquist%E2%80%93Shannon_sampling_theorem], there is no quality difference to human hearing when going past 40,000 Hz (since most humans can only hear up to ~20,000 Hz, often less). If you are generating lower-pitched sounds such as voices, lower sample rates such as 32000 or 22050 may be usable with no loss in quality.

Note: AudioStreamGenerator is not automatically resampling input data, to produce expected result mix_rate_mode should match the sampling rate of input data.

Note: If you are using AudioEffectCapture as the source of your data, set mix_rate_mode to MIX_RATE_INPUT or MIX_RATE_OUTPUT to automatically match current AudioServer mixing rate.

---

AudioStreamGeneratorMixRate mix_rate_mode = 2 

- void set_mix_rate_mode(value: AudioStreamGeneratorMixRate)
- AudioStreamGeneratorMixRate get_mix_rate_mode()

Mixing rate mode. If set to MIX_RATE_CUSTOM, mix_rate is used, otherwise current AudioServer mixing rate is used.
