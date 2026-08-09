# AnimatedSprite2D

Inherits: Node2D < CanvasItem < Node < Object

Sprite node that contains multiple textures as frames to play for animation.

## Description

AnimatedSprite2D is similar to the Sprite2D node, except it carries multiple textures as animation frames. Animations are created using a SpriteFrames resource, which allows you to import image files (or a folder containing said files) to provide the animation frames for the sprite. The SpriteFrames resource can be configured in the editor via the SpriteFrames bottom panel.

## Tutorials

- 2D Sprite animation
- 2D Dodge The Creeps Demo [https://godotengine.org/asset-library/asset/2712]

## Properties

StringName | animation | &"default"
String | autoplay | ""
bool | centered | true
bool | flip_h | false
bool | flip_v | false
int | frame | 0
float | frame_progress | 0.0
Vector2 | offset | Vector2(0, 0)
float | speed_scale | 1.0
SpriteFrames | sprite_frames |

## Methods

float | get_playing_speed() const
bool | is_playing() const
void | pause()
void | play(name: StringName = &"", custom_speed: float = 1.0, from_end: bool = false)
void | play_backwards(name: StringName = &"")
void | set_frame_and_progress(frame: int, progress: float)
void | stop()

---

## Signals

animation_changed() 

Emitted when animation changes.

---

animation_finished() 

Emitted when the animation reaches the end, or the start if it is played in reverse. When the animation finishes, it pauses the playback.

Note: This signal is not emitted if an animation is looping.

---

animation_looped() 

Emitted when the animation loops.

---

frame_changed() 

Emitted when frame changes.

---

sprite_frames_changed() 

Emitted when sprite_frames changes.

---

## Property Descriptions

StringName animation = &"default" 

- void set_animation(value: StringName)
- StringName get_animation()

The current animation from the sprite_frames resource. If this value is changed, the frame counter and the frame_progress are reset.

---

String autoplay = "" 

- void set_autoplay(value: String)
- String get_autoplay()

The key of the animation to play when the scene loads.

---

bool centered = true 

- void set_centered(value: bool)
- bool is_centered()

If true, texture will be centered.

Note: For games with a pixel art aesthetic, textures may appear deformed when centered. This is caused by their position being between pixels. To prevent this, set this property to false, or consider enabling ProjectSettings.rendering/2d/snap/snap_2d_vertices_to_pixel and ProjectSettings.rendering/2d/snap/snap_2d_transforms_to_pixel.

---

bool flip_h = false 

- void set_flip_h(value: bool)
- bool is_flipped_h()

If true, texture is flipped horizontally.

---

bool flip_v = false 

- void set_flip_v(value: bool)
- bool is_flipped_v()

If true, texture is flipped vertically.

---

int frame = 0 

- void set_frame(value: int)
- int get_frame()

The displayed animation frame's index. Setting this property also resets frame_progress. If this is not desired, use set_frame_and_progress().

---

float frame_progress = 0.0 

- void set_frame_progress(value: float)
- float get_frame_progress()

The progress value between 0.0 and 1.0 until the current frame transitions to the next frame. If the animation is playing backwards, the value transitions from 1.0 to 0.0.

---

Vector2 offset = Vector2(0, 0) 

- void set_offset(value: Vector2)
- Vector2 get_offset()

The texture's drawing offset.

---

float speed_scale = 1.0 

- void set_speed_scale(value: float)
- float get_speed_scale()

The speed scaling ratio. For example, if this value is 1, then the animation plays at normal speed. If it's 0.5, then it plays at half speed. If it's 2, then it plays at double speed.

If set to a negative value, the animation is played in reverse. If set to 0, the animation will not advance.

---

SpriteFrames sprite_frames 

- void set_sprite_frames(value: SpriteFrames)
- SpriteFrames get_sprite_frames()

The SpriteFrames resource containing the animation(s). Allows you the option to load, edit, clear, make unique and save the states of the SpriteFrames resource.

---

## Method Descriptions

float get_playing_speed() const 

Returns the actual playing speed of current animation or 0 if not playing. This speed is the speed_scale property multiplied by custom_speed argument specified when calling the play() method.

Returns a negative value if the current animation is playing backwards.

---

bool is_playing() const 

Returns true if an animation is currently playing (even if speed_scale and/or custom_speed are 0).

---

void pause() 

Pauses the currently playing animation. The frame and frame_progress will be kept and calling play() or play_backwards() without arguments will resume the animation from the current playback position.

See also stop().

---

void play(name: StringName = &"", custom_speed: float = 1.0, from_end: bool = false) 

Plays the animation with key name. If custom_speed is negative and from_end is true, the animation will play backwards (which is equivalent to calling play_backwards()).

If this method is called with that same animation name, or with no name parameter, the assigned animation will resume playing if it was paused.

---

void play_backwards(name: StringName = &"") 

Plays the animation with key name in reverse.

This method is a shorthand for play() with custom_speed = -1.0 and from_end = true, so see its description for more information.

---

void set_frame_and_progress(frame: int, progress: float) 

Sets frame and frame_progress to the given values. Unlike setting frame, this method does not reset the frame_progress to 0.0 implicitly.

Example: Change the animation while keeping the same frame and frame_progress:

```
var current_frame = animated_sprite.get_frame()
var current_progress = animated_sprite.get_frame_progress()
animated_sprite.play("walk_another_skin")
animated_sprite.set_frame_and_progress(current_frame, current_progress)
```

---

void stop() 

Stops the currently playing animation. The animation position is reset to 0 and the custom_speed is reset to 1.0. See also pause().
