# AnimationNodeAnimation

Inherits: AnimationRootNode < AnimationNode < Resource < RefCounted < Object

An input animation for an AnimationNodeBlendTree.

## Description

A resource to add to an AnimationNodeBlendTree. Only has one output port using the animation property. Used as an input for AnimationNodes that blend animations together.

## Tutorials

- Using AnimationTree
- 3D Platformer Demo [https://godotengine.org/asset-library/asset/2748]
- Third Person Shooter (TPS) Demo [https://godotengine.org/asset-library/asset/2710]

## Properties

bool | advance_on_start | false
StringName | animation | &""
LoopMode | loop_mode |
PlayMode | play_mode | 0
float | start_offset |
bool | stretch_time_scale |
float | timeline_length |
bool | use_custom_timeline | false

---

## Enumerations

enum PlayMode
PlayMode PLAY_MODE_FORWARD = 0

Plays animation in forward direction.

PlayMode PLAY_MODE_BACKWARD = 1

Plays animation in backward direction.

---

## Property Descriptions

bool advance_on_start = false 

- void set_advance_on_start(value: bool)
- bool is_advance_on_start()

If true, on receiving a request to play an animation from the start, the first frame is not drawn, but only processed, and playback starts from the next frame.

See also the notes of AnimationPlayer.play().

---

StringName animation = &"" 

- void set_animation(value: StringName)
- StringName get_animation()

Animation to use as an output. It is one of the animations provided by AnimationTree.anim_player.

---

LoopMode loop_mode 

- void set_loop_mode(value: LoopMode)
- LoopMode get_loop_mode()

If use_custom_timeline is true, override the loop settings of the original Animation resource with the value.

Note: If the Animation.loop_mode isn't set to looping, the Animation.track_set_interpolation_loop_wrap() option will not be respected. If you cannot get the expected behavior, consider duplicating the Animation resource and changing the loop settings.

---

PlayMode play_mode = 0 

- void set_play_mode(value: PlayMode)
- PlayMode get_play_mode()

Determines the playback direction of the animation.

---

float start_offset 

- void set_start_offset(value: float)
- float get_start_offset()

If use_custom_timeline is true, offset the start position of the animation.

This is useful for adjusting which foot steps first in 3D walking animations.

---

bool stretch_time_scale 

- void set_stretch_time_scale(value: bool)
- bool is_stretching_time_scale()

If true, scales the time so that the length specified in timeline_length is one cycle.

This is useful for matching the periods of walking and running animations.

If false, the original animation length is respected. If you set the loop to loop_mode, the animation will loop in timeline_length.

---

float timeline_length 

- void set_timeline_length(value: float)
- float get_timeline_length()

The length of the custom timeline.

If stretch_time_scale is true, scales the animation to this length.

---

bool use_custom_timeline = false 

- void set_use_custom_timeline(value: bool)
- bool is_using_custom_timeline()

If true, AnimationNode provides an animation based on the Animation resource with some parameters adjusted.
