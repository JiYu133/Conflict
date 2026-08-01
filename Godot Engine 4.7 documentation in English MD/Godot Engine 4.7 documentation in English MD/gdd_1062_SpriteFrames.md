# SpriteFrames

Inherits: Resource < RefCounted < Object

Sprite frame library for AnimatedSprite2D and AnimatedSprite3D.

## Description

Sprite frame library for an AnimatedSprite2D or AnimatedSprite3D node. Contains frames and animation data for playback.

## Methods

void | add_animation(anim: StringName)
void | add_frame(anim: StringName, texture: Texture2D, duration: float = 1.0, at_position: int = -1)
void | clear(anim: StringName)
void | clear_all()
void | duplicate_animation(anim_from: StringName, anim_to: StringName)
bool | get_animation_loop(anim: StringName) const
LoopMode | get_animation_loop_mode(anim: StringName) const
PackedStringArray | get_animation_names() const
float | get_animation_speed(anim: StringName) const
int | get_frame_count(anim: StringName) const
float | get_frame_duration(anim: StringName, idx: int) const
Texture2D | get_frame_texture(anim: StringName, idx: int) const
bool | has_animation(anim: StringName) const
void | remove_animation(anim: StringName)
void | remove_frame(anim: StringName, idx: int)
void | rename_animation(anim: StringName, newname: StringName)
void | set_animation_loop(anim: StringName, loop: bool)
void | set_animation_loop_mode(anim: StringName, loop_mode: LoopMode)
void | set_animation_speed(anim: StringName, fps: float)
void | set_frame(anim: StringName, idx: int, texture: Texture2D, duration: float = 1.0)

---

## Enumerations

enum LoopMode
LoopMode LOOP_NONE = 0

The animation plays once and stops when it reaches the end, or the start if played in reverse.

LoopMode LOOP_LINEAR = 1

The animation restarts from the beginning when it reaches the end, or from the end if played in reverse, repeating continuously.

LoopMode LOOP_PINGPONG = 2

The animation alternates direction each time it reaches the end or start, playing forward and then in reverse repeatedly.

Note: Both AnimatedSprite2D and AnimatedSprite3D play the first/last frame for its duration only once at each end of the animation loop (instead of twice, once per forward/backward animation direction).

---

## Method Descriptions

void add_animation(anim: StringName) 

Adds a new anim animation to the library.

---

void add_frame(anim: StringName, texture: Texture2D, duration: float = 1.0, at_position: int = -1) 

Adds a frame to the anim animation. If at_position is -1, the frame will be added to the end of the animation. duration specifies the relative duration, see get_frame_duration() for details.

---

void clear(anim: StringName) 

Removes all frames from the anim animation.

---

void clear_all() 

Removes all animations. An empty default animation will be created.

---

void duplicate_animation(anim_from: StringName, anim_to: StringName) 

Duplicates the animation anim_from to a new animation named anim_to. Fails if anim_to already exists, or if anim_from does not exist.

---

bool get_animation_loop(anim: StringName) const 

Deprecated: Use get_animation_loop_mode() instead.

Returns true if get_animation_loop_mode(anim) == LOOP_LINEAR. Otherwise, returns false.

---

LoopMode get_animation_loop_mode(anim: StringName) const 

Returns the loop mode for the anim animation.

---

PackedStringArray get_animation_names() const 

Returns an array containing the names associated to each animation. Values are placed in alphabetical order.

---

float get_animation_speed(anim: StringName) const 

Returns the speed in frames per second for the anim animation.

---

int get_frame_count(anim: StringName) const 

Returns the number of frames for the anim animation.

---

float get_frame_duration(anim: StringName, idx: int) const 

Returns a relative duration of the frame idx in the anim animation (defaults to 1.0). For example, a frame with a duration of 2.0 is displayed twice as long as a frame with a duration of 1.0. You can calculate the absolute duration (in seconds) of a frame using the following formula:

```gdscript
absolute_duration = relative_duration / (animation_fps * abs(playing_speed))
```

In this example, playing_speed refers to either AnimatedSprite2D.get_playing_speed() or AnimatedSprite3D.get_playing_speed().

---

Texture2D get_frame_texture(anim: StringName, idx: int) const 

Returns the texture of the frame idx in the anim animation.

---

bool has_animation(anim: StringName) const 

Returns true if the anim animation exists.

---

void remove_animation(anim: StringName) 

Removes the anim animation.

---

void remove_frame(anim: StringName, idx: int) 

Removes the anim animation's frame idx.

---

void rename_animation(anim: StringName, newname: StringName) 

Changes the anim animation's name to newname.

---

void set_animation_loop(anim: StringName, loop: bool) 

Deprecated: Use set_animation_loop_mode() instead.

If loop is false equivalent to set_animation_loop_mode(LOOP_NONE).

If loop is true equivalent to set_animation_loop_mode(LOOP_LINEAR).

---

void set_animation_loop_mode(anim: StringName, loop_mode: LoopMode) 

Sets the loop_mode for the anim animation.

---

void set_animation_speed(anim: StringName, fps: float) 

Sets the speed for the anim animation in frames per second.

---

void set_frame(anim: StringName, idx: int, texture: Texture2D, duration: float = 1.0) 

Sets the texture and the duration of the frame idx in the anim animation. duration specifies the relative duration, see get_frame_duration() for details.
