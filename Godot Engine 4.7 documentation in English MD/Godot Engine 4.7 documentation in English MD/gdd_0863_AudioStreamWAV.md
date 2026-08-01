# AudioStreamWAV

Inherits: AudioStream < Resource < RefCounted < Object

Stores audio data loaded from WAV files.

## Description

AudioStreamWAV stores sound samples loaded from WAV files. To play the stored sound, use an AudioStreamPlayer (for non-positional audio) or AudioStreamPlayer2D/AudioStreamPlayer3D (for positional audio). The sound can be looped.

This class can also be used to store dynamically-generated PCM audio data. See also AudioStreamGenerator for procedural audio generation.

## Tutorials

- Audio streams
- Runtime file loading and saving

## Properties

PackedByteArray | data | PackedByteArray()
Format | format | 0
int | loop_begin | 0
int | loop_end | 0
LoopMode | loop_mode | 0
int | mix_rate | 44100
bool | stereo | false
Dictionary | tags | {}

## Methods

AudioStreamWAV | load_from_buffer(stream_data: PackedByteArray, options: Dictionary = {}) static
AudioStreamWAV | load_from_file(path: String, options: Dictionary = {}) static
Error | save_to_wav(path: String)

---

## Enumerations

enum Format
Format FORMAT_8_BITS = 0

8-bit PCM audio codec.

Format FORMAT_16_BITS = 1

16-bit PCM audio codec.

Format FORMAT_IMA_ADPCM = 2

Audio is lossily compressed as IMA ADPCM.

Format FORMAT_QOA = 3

Audio is lossily compressed as Quite OK Audio [https://qoaformat.org/].

---

enum LoopMode
LoopMode LOOP_DISABLED = 0

Audio does not loop.

LoopMode LOOP_FORWARD = 1

Audio loops the data between loop_begin and loop_end, playing forward only.

LoopMode LOOP_PINGPONG = 2

Audio loops the data between loop_begin and loop_end, playing back and forth.

LoopMode LOOP_BACKWARD = 3

Audio loops the data between loop_begin and loop_end, playing backward only.

---

## Property Descriptions

PackedByteArray data = PackedByteArray() 

- void set_data(value: PackedByteArray)
- PackedByteArray get_data()

Contains the audio data in bytes.

Note: If format is set to FORMAT_8_BITS, this property expects signed 8-bit PCM data. To convert from unsigned 8-bit PCM, subtract 128 from each byte.

Note: If format is set to FORMAT_QOA, this property expects data from a full QOA file.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedByteArray for more details.

---

Format format = 0 

- void set_format(value: Format)
- Format get_format()

Audio format.

---

int loop_begin = 0 

- void set_loop_begin(value: int)
- int get_loop_begin()

The loop start point (in number of samples, relative to the beginning of the stream).

---

int loop_end = 0 

- void set_loop_end(value: int)
- int get_loop_end()

The loop end point (in number of samples, relative to the beginning of the stream).

---

LoopMode loop_mode = 0 

- void set_loop_mode(value: LoopMode)
- LoopMode get_loop_mode()

The loop mode.

---

int mix_rate = 44100 

- void set_mix_rate(value: int)
- int get_mix_rate()

The sample rate for mixing this audio. Higher values require more storage space, but result in better quality.

In games, common sample rates in use are 11025, 16000, 22050, 32000, 44100, and 48000.

According to the Nyquist-Shannon sampling theorem [https://en.wikipedia.org/wiki/Nyquist%E2%80%93Shannon_sampling_theorem], there is no quality difference to human hearing when going past 40,000 Hz (since most humans can only hear up to ~20,000 Hz, often less). If you are using lower-pitched sounds such as voices, lower sample rates such as 32000 or 22050 may be usable with no loss in quality.

---

bool stereo = false 

- void set_stereo(value: bool)
- bool is_stereo()

If true, audio is stereo.

---

Dictionary tags = {} 

- void set_tags(value: Dictionary)
- Dictionary get_tags()

Contains user-defined tags if found in the WAV data.

Commonly used tags include title, artist, album, tracknumber, and date (date does not have a standard date format).

Note: No tag is guaranteed to be present in every file, so make sure to account for the keys not always existing.

Note: Only WAV files using a LIST chunk with an identifier of INFO to encode the tags are currently supported.

---

## Method Descriptions

AudioStreamWAV load_from_buffer(stream_data: PackedByteArray, options: Dictionary = {}) static 

Creates a new AudioStreamWAV instance from the given buffer. The buffer must contain WAV data.

The keys and values of options match the properties of ResourceImporterWAV. The usage of options is identical to load_from_file().

---

AudioStreamWAV load_from_file(path: String, options: Dictionary = {}) static 

Creates a new AudioStreamWAV instance from the given file path. The file must be in WAV format.

The keys and values of options match the properties of ResourceImporterWAV.

Example: Load the first file dropped as a WAV and play it:

```gdscript
@onready var audio_player = $AudioStreamPlayer
func _ready():
    get_window().files_dropped.connect(_on_files_dropped)
func _on_files_dropped(files):
    if files[0].get_extension() == "wav":
        audio_player.stream = AudioStreamWAV.load_from_file(files[0], {
                "force/max_rate": true,
                "force/max_rate_hz": 11025
            })
        audio_player.play()
```

---

Error save_to_wav(path: String) 

Saves the AudioStreamWAV as a WAV file to path. Samples with IMA ADPCM or Quite OK Audio formats can't be saved.

Note: A .wav extension is automatically appended to path if it is missing.
