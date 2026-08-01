# AnimationPlayer

Inherits: AnimationMixer < Node < Object

A node used for animation playback.

## Description

An animation player is used for general-purpose playback of animations. It contains a dictionary of AnimationLibrary resources and custom blend times between animation transitions.

Some methods and properties use a single key to reference an animation directly. These keys are formatted as the key for the library, followed by a forward slash, then the key for the animation within the library, for example "movement/run". If the library's key is an empty string (known as the default library), the forward slash is omitted, being the same key used by the library.

AnimationPlayer is better-suited than Tween for more complex animations, for example ones with non-trivial timings. It can also be used over Tween if the animation track editor is more convenient than doing it in code.

Updating the target properties of animations occurs at the process frame.

## Tutorials

- 2D Sprite animation
- Animation documentation index
- Third Person Shooter (TPS) Demo [https://godotengine.org/asset-library/asset/2710]

## Properties

StringName | assigned_animation |
StringName | autoplay | &""
StringName | current_animation | &""
float | current_animation_length |
float | current_animation_position |
bool | movie_quit_on_finish | false
bool | playback_auto_capture | true
float | playback_auto_capture_duration | -1.0
EaseType | playback_auto_capture_ease_type | 0
TransitionType | playback_auto_capture_transition_type | 0
float | playback_default_blend_time | 0.0
float | speed_scale | 1.0

## Methods

StringName | animation_get_next(animation_from: StringName) const
void | animation_set_next(animation_from: StringName, animation_to: StringName)
void | clear_queue()
float | get_blend_time(animation_from: StringName, animation_to: StringName) const
AnimationMethodCallMode | get_method_call_mode() const
float | get_playing_speed() const
AnimationProcessCallback | get_process_callback() const
Array[StringName] | get_queue()
NodePath | get_root() const
float | get_section_end_time() const
float | get_section_start_time() const
bool | has_section() const
bool | is_animation_active() const
bool | is_playing() const
void | pause()
void | play(name: StringName = &"", custom_blend: float = -1, custom_speed: float = 1.0, from_end: bool = false)
void | play_backwards(name: StringName = &"", custom_blend: float = -1)
void | play_section(name: StringName = &"", start_time: float = -1, end_time: float = -1, custom_blend: float = -1, custom_speed: float = 1.0, from_end: bool = false)
void | play_section_backwards(name: StringName = &"", start_time: float = -1, end_time: float = -1, custom_blend: float = -1)
void | play_section_with_markers(name: StringName = &"", start_marker: StringName = &"", end_marker: StringName = &"", custom_blend: float = -1, custom_speed: float = 1.0, from_end: bool = false)
void | play_section_with_markers_backwards(name: StringName = &"", start_marker: StringName = &"", end_marker: StringName = &"", custom_blend: float = -1)
void | play_with_capture(name: StringName = &"", duration: float = -1.0, custom_blend: float = -1, custom_speed: float = 1.0, from_end: bool = false, trans_type: TransitionType = 0, ease_type: EaseType = 0)
void | queue(name: StringName)
void | reset_section()
void | seek(seconds: float, update: bool = false, update_only: bool = false)
void | set_blend_time(animation_from: StringName, animation_to: StringName, sec: float)
void | set_method_call_mode(mode: AnimationMethodCallMode)
void | set_process_callback(mode: AnimationProcessCallback)
void | set_root(path: NodePath)
void | set_section(start_time: float = -1, end_time: float = -1)
void | set_section_with_markers(start_marker: StringName = &"", end_marker: StringName = &"")
void | stop(keep_state: bool = false)

---

## Signals

animation_changed(old_name: StringName, new_name: StringName) 

Emitted when a queued animation plays after the previous animation finished. See also queue().

Note: The signal is not emitted when the animation is changed via play() or by an AnimationTree.

---

current_animation_changed(anim_name: StringName) 

Emitted when current_animation changes.

---

## Enumerations

enum AnimationProcessCallback
AnimationProcessCallback ANIMATION_PROCESS_PHYSICS = 0

Deprecated: See AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_PHYSICS.

AnimationProcessCallback ANIMATION_PROCESS_IDLE = 1

Deprecated: See AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_IDLE.

AnimationProcessCallback ANIMATION_PROCESS_MANUAL = 2

Deprecated: See AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_MANUAL.

---

enum AnimationMethodCallMode
AnimationMethodCallMode ANIMATION_METHOD_CALL_DEFERRED = 0

Deprecated: See AnimationMixer.ANIMATION_CALLBACK_MODE_METHOD_DEFERRED.

AnimationMethodCallMode ANIMATION_METHOD_CALL_IMMEDIATE = 1

Deprecated: See AnimationMixer.ANIMATION_CALLBACK_MODE_METHOD_IMMEDIATE.

---

## Property Descriptions

StringName assigned_animation 

- void set_assigned_animation(value: StringName)
- StringName get_assigned_animation()

If playing, the current animation's key, otherwise, the animation last played. When set, this changes the animation, but will not play it unless already playing. See also current_animation.

---

StringName autoplay = &"" 

- void set_autoplay(value: StringName)
- StringName get_autoplay()

The key of the animation to play when the scene loads.

---

StringName current_animation = &"" 

- void set_current_animation(value: StringName)
- StringName get_current_animation()

The key of the currently playing animation. If no animation is playing, the property's value is an empty string. Changing this value does not restart the animation. See play() for more information on playing animations.

Note: While this property appears in the Inspector, it's not meant to be edited, and it's not saved in the scene. This property is mainly used to get the currently playing animation, and internally for animation playback tracks. For more information, see Animation.

---

float current_animation_length 

- float get_current_animation_length()

The length (in seconds) of the currently playing animation.

---

float current_animation_position 

- float get_current_animation_position()

The position (in seconds) of the currently playing animation.

---

bool movie_quit_on_finish = false 

- void set_movie_quit_on_finish_enabled(value: bool)
- bool is_movie_quit_on_finish_enabled()

If true and the engine is running in Movie Maker mode (see MovieWriter), exits the engine with SceneTree.quit() as soon as an animation is done playing in this AnimationPlayer. A message is printed when the engine quits for this reason.

Note: This obeys the same logic as the AnimationMixer.animation_finished signal, so it will not quit the engine if the animation is set to be looping.

---

bool playback_auto_capture = true 

- void set_auto_capture(value: bool)
- bool is_auto_capture()

If true, performs AnimationMixer.capture() before playback automatically. This means just play_with_capture() is executed with default arguments instead of play().

Note: Capture interpolation is only performed if the animation contains a capture track. See also Animation.UPDATE_CAPTURE.

---

float playback_auto_capture_duration = -1.0 

- void set_auto_capture_duration(value: float)
- float get_auto_capture_duration()

See also play_with_capture() and AnimationMixer.capture().

If playback_auto_capture_duration is negative value, the duration is set to the interval between the current position and the first key.

---

EaseType playback_auto_capture_ease_type = 0 

- void set_auto_capture_ease_type(value: EaseType)
- EaseType get_auto_capture_ease_type()

The ease type of the capture interpolation. See also EaseType.

---

TransitionType playback_auto_capture_transition_type = 0 

- void set_auto_capture_transition_type(value: TransitionType)
- TransitionType get_auto_capture_transition_type()

The transition type of the capture interpolation. See also TransitionType.

---

float playback_default_blend_time = 0.0 

- void set_default_blend_time(value: float)
- float get_default_blend_time()

The default time in which to blend animations. Ranges from 0 to 4096 with 0.01 precision.

---

float speed_scale = 1.0 

- void set_speed_scale(value: float)
- float get_speed_scale()

The speed scaling ratio. For example, if this value is 1, then the animation plays at normal speed. If it's 0.5, then it plays at half speed. If it's 2, then it plays at double speed.

If set to a negative value, the animation is played in reverse. If set to 0, the animation will not advance.

---

## Method Descriptions

StringName animation_get_next(animation_from: StringName) const 

Returns the key of the animation which is queued to play after the animation_from animation.

---

void animation_set_next(animation_from: StringName, animation_to: StringName) 

Triggers the animation_to animation when the animation_from animation completes.

---

void clear_queue() 

Clears all queued, unplayed animations.

---

float get_blend_time(animation_from: StringName, animation_to: StringName) const 

Returns the blend time (in seconds) between two animations, referenced by their keys.

---

AnimationMethodCallMode get_method_call_mode() const 

Deprecated: Use AnimationMixer.callback_mode_method instead.

Returns the call mode used for "Call Method" tracks.

---

float get_playing_speed() const 

Returns the actual playing speed of current animation or 0 if not playing. This speed is the speed_scale property multiplied by custom_speed argument specified when calling the play() method.

Returns a negative value if the current animation is playing backwards.

---

AnimationProcessCallback get_process_callback() const 

Deprecated: Use AnimationMixer.callback_mode_process instead.

Returns the process notification in which to update animations.

---

Array[StringName] get_queue() 

Returns a list of the animation keys that are currently queued to play.

---

NodePath get_root() const 

Deprecated: Use AnimationMixer.root_node instead.

Returns the node which node path references will travel from.

---

float get_section_end_time() const 

Returns the end time of the section currently being played.

---

float get_section_start_time() const 

Returns the start time of the section currently being played.

---

bool has_section() const 

Returns true if an animation is currently playing with a section.

---

bool is_animation_active() const 

Returns true if the an animation is currently active. An animation is active if it was played by calling play() and was not finished yet, or was stopped by calling stop().

This can be used to check whether an animation is currently paused or stopped.

```gdscript
var is_paused = not is_playing() and is_animation_active()
var is_stopped = not is_playing() and not is_animation_active()
```

---

bool is_playing() const 

Returns true if an animation is currently playing (even if speed_scale and/or custom_speed are 0).

---

void pause() 

Pauses the currently playing animation. The current_animation_position will be kept and calling play() or play_backwards() without arguments or with the same animation name as assigned_animation will resume the animation.

See also stop().

---

void play(name: StringName = &"", custom_blend: float = -1, custom_speed: float = 1.0, from_end: bool = false) 

Plays the animation with key name. Custom blend times and speed can be set.

The from_end option only affects when switching to a new animation track, or if the same track but at the start or end. It does not affect resuming playback that was paused in the middle of an animation. If custom_speed is negative and from_end is true, the animation will play backwards (which is equivalent to calling play_backwards()).

The AnimationPlayer keeps track of its current or last played animation with assigned_animation. If this method is called with that same animation name, or with no name parameter, the assigned animation will resume playing if it was paused.

Note: The animation will be updated the next time the AnimationPlayer is processed. If other variables are updated at the same time this is called, they may be updated too early. To perform the update immediately, call advance(0).

---

void play_backwards(name: StringName = &"", custom_blend: float = -1) 

Plays the animation with key name in reverse.

This method is a shorthand for play() with custom_speed = -1.0 and from_end = true, so see its description for more information.

---

void play_section(name: StringName = &"", start_time: float = -1, end_time: float = -1, custom_blend: float = -1, custom_speed: float = 1.0, from_end: bool = false) 

Plays the animation with key name and the section starting from start_time and ending on end_time. See also play().

Setting start_time to a value outside the range of the animation means the start of the animation will be used instead, and setting end_time to a value outside the range of the animation means the end of the animation will be used instead. start_time cannot be equal to end_time.

---

void play_section_backwards(name: StringName = &"", start_time: float = -1, end_time: float = -1, custom_blend: float = -1) 

Plays the animation with key name and the section starting from start_time and ending on end_time in reverse.

This method is a shorthand for play_section() with custom_speed = -1.0 and from_end = true, see its description for more information.

---

void play_section_with_markers(name: StringName = &"", start_marker: StringName = &"", end_marker: StringName = &"", custom_blend: float = -1, custom_speed: float = 1.0, from_end: bool = false) 

Plays the animation with key name and the section starting from start_marker and ending on end_marker.

If the start marker is empty, the section starts from the beginning of the animation. If the end marker is empty, the section ends on the end of the animation. See also play().

---

void play_section_with_markers_backwards(name: StringName = &"", start_marker: StringName = &"", end_marker: StringName = &"", custom_blend: float = -1) 

Plays the animation with key name and the section starting from start_marker and ending on end_marker in reverse.

This method is a shorthand for play_section_with_markers() with custom_speed = -1.0 and from_end = true, see its description for more information.

---

void play_with_capture(name: StringName = &"", duration: float = -1.0, custom_blend: float = -1, custom_speed: float = 1.0, from_end: bool = false, trans_type: TransitionType = 0, ease_type: EaseType = 0) 

See also AnimationMixer.capture().

You can use this method to use more detailed options for capture than those performed by playback_auto_capture. When playback_auto_capture is false, this method is almost the same as the following:

```gdscript
capture(name, duration, trans_type, ease_type)
play(name, custom_blend, custom_speed, from_end)
```

If name is blank, it specifies assigned_animation.

If duration is a negative value, the duration is set to the interval between the current position and the first key, when from_end is true, uses the interval between the current position and the last key instead.

Note: The duration takes speed_scale into account, but custom_speed does not, because the capture cache is interpolated with the blend result and the result may contain multiple animations.

---

void queue(name: StringName) 

Queues an animation for playback once the current animation and all previously queued animations are done.

Note: If a looped animation is currently playing, the queued animation will never play unless the looped animation is stopped somehow.

---

void reset_section() 

Resets the current section. Does nothing if a section has not been set.

---

void seek(seconds: float, update: bool = false, update_only: bool = false) 

Seeks the animation to the seconds point in time (in seconds). If update is true, the animation updates too, otherwise it updates at process time. Events between the current frame and seconds are skipped.

If update_only is true, the method / audio / animation playback tracks will not be processed.

Note: Seeking to the end of the animation doesn't emit AnimationMixer.animation_finished. If you want to skip animation and emit the signal, use AnimationMixer.advance().

---

void set_blend_time(animation_from: StringName, animation_to: StringName, sec: float) 

Specifies a blend time (in seconds) between two animations, referenced by their keys.

---

void set_method_call_mode(mode: AnimationMethodCallMode) 

Deprecated: Use AnimationMixer.callback_mode_method instead.

Sets the call mode used for "Call Method" tracks.

---

void set_process_callback(mode: AnimationProcessCallback) 

Deprecated: Use AnimationMixer.callback_mode_process instead.

Sets the process notification in which to update animations.

---

void set_root(path: NodePath) 

Deprecated: Use AnimationMixer.root_node instead.

Sets the node which node path references will travel from.

---

void set_section(start_time: float = -1, end_time: float = -1) 

Changes the start and end times of the section being played. The current playback position will be clamped within the new section. See also play_section().

---

void set_section_with_markers(start_marker: StringName = &"", end_marker: StringName = &"") 

Changes the start and end markers of the section being played. The current playback position will be clamped within the new section. See also play_section_with_markers().

If the argument is empty, the section uses the beginning or end of the animation. If both are empty, it means that the section is not set.

---

void stop(keep_state: bool = false) 

Stops the currently playing animation. The animation position is reset to 0 and the custom_speed is reset to 1.0. See also pause().

If keep_state is true, the animation state is not updated visually.

Note: The method / audio / animation playback tracks will not be processed by this method.
