# AudioStreamMP3

Inherits: AudioStream < Resource < RefCounted < Object

MP3 audio stream driver.

## Description

MP3 audio stream driver. See data if you want to load an MP3 file at run-time. More info can be found in ResourceImporterMP3.

Note: This class can optionally support legacy MP1 and MP2 formats, provided that the engine is compiled with the minimp3_extra_formats=yes SCons option. These extra formats are not enabled by default.

## Tutorials

- Audio streams
- Runtime file loading and saving

## Properties

int | bar_beats | 4
int | beat_count | 0
float | bpm | 0.0
PackedByteArray | data | PackedByteArray()
bool | loop | false
float | loop_offset | 0.0

## Methods

AudioStreamMP3 | load_from_buffer(stream_data: PackedByteArray) static
AudioStreamMP3 | load_from_file(path: String) static

---

## Property Descriptions

int bar_beats = 4 

- void set_bar_beats(value: int)
- int get_bar_beats()

The number of beats within a single bar in the audio track.

---

int beat_count = 0 

- void set_beat_count(value: int)
- int get_beat_count()

The length of the audio track, in beats. The actual duration of the audio file might be longer than what is indicated by this property. It defines the end of the audio for looping, AudioStreamPlaylist, and AudioStreamInteractive.

---

float bpm = 0.0 

- void set_bpm(value: float)
- float get_bpm()

The tempo of the audio track, measured in beats per minute.

---

PackedByteArray data = PackedByteArray() 

- void set_data(value: PackedByteArray)
- PackedByteArray get_data()

Contains the audio data in bytes.

You can load a file without having to import it beforehand using the code snippet below. Keep in mind that this snippet loads the whole file into memory and may not be ideal for huge files (hundreds of megabytes or more).

```
func load_mp3(path):
    var file = FileAccess.open(path, FileAccess.READ)
    var sound = AudioStreamMP3.new()
    sound.data = file.get_buffer(file.get_length())
    return sound
```

```
public AudioStreamMP3 LoadMP3(string path)
{
    using var file = FileAccess.Open(path, FileAccess.ModeFlags.Read);
    var sound = new AudioStreamMP3();
    sound.Data = file.GetBuffer(file.GetLength());
    return sound;
}
```

Note: The returned array is copied and any changes to it will not update the original property value. See PackedByteArray for more details.

---

bool loop = false 

- void set_loop(value: bool)
- bool has_loop()

If true, the stream will play again from the specified loop_offset once it reaches the end of the audio track, or once it reaches the end of the last beat according to the amount specified in beat_count. Useful for ambient sounds and background music.

---

float loop_offset = 0.0 

- void set_loop_offset(value: float)
- float get_loop_offset()

Time in seconds at which the stream starts after being looped.

---

## Method Descriptions

AudioStreamMP3 load_from_buffer(stream_data: PackedByteArray) static 

Creates a new AudioStreamMP3 instance from the given buffer. The buffer must contain MP3 data.

---

AudioStreamMP3 load_from_file(path: String) static 

Creates a new AudioStreamMP3 instance from the given file path. The file must be in MP3 format.
