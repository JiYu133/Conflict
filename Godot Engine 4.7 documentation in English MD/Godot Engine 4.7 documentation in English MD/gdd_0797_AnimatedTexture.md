# AnimatedTexture

Deprecated: This class does not work properly in current versions and may be removed in the future. There is currently no equivalent workaround.

Inherits: Texture2D < Texture < Resource < RefCounted < Object

Proxy texture for simple frame-based animations.

## Description

AnimatedTexture is a resource format for frame-based animations, where multiple textures can be chained automatically with a predefined delay for each frame. Unlike AnimationPlayer or AnimatedSprite2D, it isn't a Node, but has the advantage of being usable anywhere a Texture2D resource can be used, e.g. in a TileSet.

The playback of the animation is controlled by the speed_scale property, as well as each frame's duration (see set_frame_duration()). The animation loops, i.e. it will restart at frame 0 automatically after playing the last frame.

AnimatedTexture currently requires all frame textures to have the same size, otherwise the bigger ones will be cropped to match the smallest one.

Note: AnimatedTexture doesn't support using AtlasTextures. Each frame needs to be a separate Texture2D.

Warning: The current implementation is not efficient for the modern renderers.

## Properties

int | current_frame |
int | frames | 1
bool | one_shot | false
bool | pause | false
bool | resource_local_to_scene | false (overrides Resource)
float | speed_scale | 1.0

## Methods

float | get_frame_duration(frame: int) const
Texture2D | get_frame_texture(frame: int) const
void | set_frame_duration(frame: int, duration: float)
void | set_frame_texture(frame: int, texture: Texture2D)

---

## Constants

MAX_FRAMES = 256 

The maximum number of frames supported by AnimatedTexture. If you need more frames in your animation, use AnimationPlayer or AnimatedSprite2D.

---

## Property Descriptions

int current_frame 

- void set_current_frame(value: int)
- int get_current_frame()

Sets the currently visible frame of the texture. Setting this frame while playing resets the current frame time, so the newly selected frame plays for its whole configured frame duration.

---

int frames = 1 

- void set_frames(value: int)
- int get_frames()

Number of frames to use in the animation. While you can create the frames independently with set_frame_texture(), you need to set this value for the animation to take new frames into account. The maximum number of frames is MAX_FRAMES.

---

bool one_shot = false 

- void set_one_shot(value: bool)
- bool get_one_shot()

If true, the animation will only play once and will not loop back to the first frame after reaching the end. Note that reaching the end will not set pause to true.

---

bool pause = false 

- void set_pause(value: bool)
- bool get_pause()

If true, the animation will pause where it currently is (i.e. at current_frame). The animation will continue from where it was paused when changing this property to false.

---

float speed_scale = 1.0 

- void set_speed_scale(value: float)
- float get_speed_scale()

The animation speed is multiplied by this value. If set to a negative value, the animation is played in reverse.

---

## Method Descriptions

float get_frame_duration(frame: int) const 

Returns the given frame's duration, in seconds.

---

Texture2D get_frame_texture(frame: int) const 

Returns the given frame's Texture2D.

---

void set_frame_duration(frame: int, duration: float) 

Sets the duration of any given frame. The final duration is affected by the speed_scale. If set to 0, the frame is skipped during playback.

---

void set_frame_texture(frame: int, texture: Texture2D) 

Assigns a Texture2D to the given frame. Frame IDs start at 0, so the first frame has ID 0, and the last frame of the animation has ID frames - 1.

You can define any number of textures up to MAX_FRAMES, but keep in mind that only frames from 0 to frames - 1 will be part of the animation.
