# VideoStreamPlayer

Inherits: Control < CanvasItem < Node < Object

A control used for video playback.

## Description

A control used for playback of VideoStream resources.

Supported video formats are Ogg Theora [https://www.theora.org/] (.ogv, VideoStreamTheora) and any format exposed via a GDExtension plugin.

Warning: On Web, video playback will perform poorly due to missing architecture-specific assembly optimizations.

## Tutorials

- Playing videos

## Properties

int | audio_track | 0
bool | autoplay | false
int | buffering_msec | 500
StringName | bus | &"Master"
bool | expand | false
bool | loop | false
bool | paused | false
float | speed_scale | 1.0
VideoStream | stream |
float | stream_position |
float | volume |
float | volume_db | 0.0

## Methods

float | get_stream_length() const
String | get_stream_name() const
Texture2D | get_video_texture() const
bool | is_playing() const
void | play()
void | stop()

---

## Signals

finished() 

Emitted when playback is finished.

---

## Property Descriptions

int audio_track = 0 

- void set_audio_track(value: int)
- int get_audio_track()

The embedded audio track to play.

---

bool autoplay = false 

- void set_autoplay(value: bool)
- bool has_autoplay()

If true, playback starts when the scene loads.

---

int buffering_msec = 500 

- void set_buffering_msec(value: int)
- int get_buffering_msec()

Amount of time in milliseconds to store in buffer while playing.

---

StringName bus = &"Master" 

- void set_bus(value: StringName)
- StringName get_bus()

Audio bus to use for sound playback.

---

bool expand = false 

- void set_expand(value: bool)
- bool has_expand()

If true, the video scales to the control size. Otherwise, the control minimum size will be automatically adjusted to match the video stream's dimensions.

---

bool loop = false 

- void set_loop(value: bool)
- bool has_loop()

If true, the video restarts when it reaches its end.

---

bool paused = false 

- void set_paused(value: bool)
- bool is_paused()

If true, the video is paused.

---

float speed_scale = 1.0 

- void set_speed_scale(value: float)
- float get_speed_scale()

The stream's current speed scale. 1.0 is the normal speed, while 2.0 is double speed and 0.5 is half speed. A speed scale of 0.0 pauses the video, similar to setting paused to true.

---

VideoStream stream 

- void set_stream(value: VideoStream)
- VideoStream get_stream()

The assigned video stream. See description for supported formats.

---

float stream_position 

- void set_stream_position(value: float)
- float get_stream_position()

The current position of the stream, in seconds.

---

float volume 

- void set_volume(value: float)
- float get_volume()

Audio volume as a linear value.

---

float volume_db = 0.0 

- void set_volume_db(value: float)
- float get_volume_db()

Audio volume in dB.

---

## Method Descriptions

float get_stream_length() const 

The length of the current stream, in seconds.

---

String get_stream_name() const 

Returns the video stream's name, or "" if no video stream is assigned.

---

Texture2D get_video_texture() const 

Returns the current frame as a Texture2D.

---

bool is_playing() const 

Returns true if the video is playing.

Note: The video is still considered playing if paused during playback.

---

void play() 

Starts the video playback from the beginning. If the video is paused, this will not unpause the video.

---

void stop() 

Stops the video playback and sets the stream position to 0.

Note: Although the stream position will be set to 0, the first frame of the video stream won't become the current frame.
