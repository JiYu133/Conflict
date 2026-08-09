# Animation

Inherits: Resource < RefCounted < Object

Holds data that can be used to animate anything in the engine.

## Description

This resource holds data that can be used to animate anything in the engine. Animations are divided into tracks and each track must be linked to a node. The state of that node can be changed through time, by adding timed keys (events) to the track.

```
# This creates an animation that makes the node "Enemy" move to the right by
# 100 pixels in 2.0 seconds.
var animation = Animation.new()
var track_index = animation.add_track(Animation.TYPE_VALUE)
animation.track_set_path(track_index, "Enemy:position:x")
animation.track_insert_key(track_index, 0.0, 0)
animation.track_insert_key(track_index, 2.0, 100)
animation.length = 2.0
```

```
// This creates an animation that makes the node "Enemy" move to the right by
// 100 pixels in 2.0 seconds.
var animation = new Animation();
int trackIndex = animation.AddTrack(Animation.TrackType.Value);
animation.TrackSetPath(trackIndex, "Enemy:position:x");
animation.TrackInsertKey(trackIndex, 0.0f, 0);
animation.TrackInsertKey(trackIndex, 2.0f, 100);
animation.Length = 2.0f;
```

Animations are just data containers, and must be added to nodes such as an AnimationPlayer to be played back. Animation tracks have different types, each with its own set of dedicated methods. Check TrackType to see available types.

Note: For 3D position/rotation/scale, using the dedicated TYPE_POSITION_3D, TYPE_ROTATION_3D and TYPE_SCALE_3D track types instead of TYPE_VALUE is recommended for performance reasons.

## Tutorials

- Animation documentation index

## Properties

bool | capture_included | false
float | length | 1.0
LoopMode | loop_mode | 0
float | step | 0.033333335

## Methods

void | add_marker(name: StringName, time: float)
int | add_track(type: TrackType, at_position: int = -1)
StringName | animation_track_get_key_animation(track_idx: int, key_idx: int) const
int | animation_track_insert_key(track_idx: int, time: float, animation: StringName)
void | animation_track_set_key_animation(track_idx: int, key_idx: int, animation: StringName)
float | audio_track_get_key_end_offset(track_idx: int, key_idx: int) const
float | audio_track_get_key_start_offset(track_idx: int, key_idx: int) const
Resource | audio_track_get_key_stream(track_idx: int, key_idx: int) const
int | audio_track_insert_key(track_idx: int, time: float, stream: Resource, start_offset: float = 0, end_offset: float = 0)
bool | audio_track_is_use_blend(track_idx: int) const
void | audio_track_set_key_end_offset(track_idx: int, key_idx: int, offset: float)
void | audio_track_set_key_start_offset(track_idx: int, key_idx: int, offset: float)
void | audio_track_set_key_stream(track_idx: int, key_idx: int, stream: Resource)
void | audio_track_set_use_blend(track_idx: int, enable: bool)
Vector2 | bezier_track_get_key_in_handle(track_idx: int, key_idx: int) const
Vector2 | bezier_track_get_key_out_handle(track_idx: int, key_idx: int) const
float | bezier_track_get_key_value(track_idx: int, key_idx: int) const
int | bezier_track_insert_key(track_idx: int, time: float, value: float, in_handle: Vector2 = Vector2(0, 0), out_handle: Vector2 = Vector2(0, 0))
float | bezier_track_interpolate(track_idx: int, time: float) const
void | bezier_track_set_key_in_handle(track_idx: int, key_idx: int, in_handle: Vector2, balanced_value_time_ratio: float = 1.0)
void | bezier_track_set_key_out_handle(track_idx: int, key_idx: int, out_handle: Vector2, balanced_value_time_ratio: float = 1.0)
void | bezier_track_set_key_value(track_idx: int, key_idx: int, value: float)
int | blend_shape_track_insert_key(track_idx: int, time: float, amount: float)
float | blend_shape_track_interpolate(track_idx: int, time_sec: float, backward: bool = false) const
void | clear()
void | compress(page_size: int = 8192, fps: int = 120, split_tolerance: float = 4.0)
void | copy_track(track_idx: int, to_animation: Animation)
int | find_track(path: NodePath, type: TrackType) const
StringName | get_marker_at_time(time: float) const
Color | get_marker_color(name: StringName) const
PackedStringArray | get_marker_names() const
float | get_marker_time(name: StringName) const
StringName | get_next_marker(time: float) const
StringName | get_prev_marker(time: float) const
int | get_track_count() const
bool | has_marker(name: StringName) const
StringName | method_track_get_name(track_idx: int, key_idx: int) const
Array | method_track_get_params(track_idx: int, key_idx: int) const
void | optimize(allowed_velocity_err: float = 0.01, allowed_angular_err: float = 0.01, precision: int = 3)
int | position_track_insert_key(track_idx: int, time: float, position: Vector3)
Vector3 | position_track_interpolate(track_idx: int, time_sec: float, backward: bool = false) const
void | remove_marker(name: StringName)
void | remove_track(track_idx: int)
int | rotation_track_insert_key(track_idx: int, time: float, rotation: Quaternion)
Quaternion | rotation_track_interpolate(track_idx: int, time_sec: float, backward: bool = false) const
int | scale_track_insert_key(track_idx: int, time: float, scale: Vector3)
Vector3 | scale_track_interpolate(track_idx: int, time_sec: float, backward: bool = false) const
void | set_marker_color(name: StringName, color: Color)
int | track_find_key(track_idx: int, time: float, find_mode: FindMode = 0, limit: bool = false, backward: bool = false) const
bool | track_get_interpolation_loop_wrap(track_idx: int) const
InterpolationType | track_get_interpolation_type(track_idx: int) const
int | track_get_key_count(track_idx: int) const
float | track_get_key_time(track_idx: int, key_idx: int) const
float | track_get_key_transition(track_idx: int, key_idx: int) const
Variant | track_get_key_value(track_idx: int, key_idx: int) const
NodePath | track_get_path(track_idx: int) const
TrackType | track_get_type(track_idx: int) const
int | track_insert_key(track_idx: int, time: float, key: Variant, transition: float = 1)
bool | track_is_compressed(track_idx: int) const
bool | track_is_enabled(track_idx: int) const
bool | track_is_imported(track_idx: int) const
void | track_move_down(track_idx: int)
void | track_move_to(track_idx: int, to_idx: int)
void | track_move_up(track_idx: int)
void | track_remove_key(track_idx: int, key_idx: int)
void | track_remove_key_at_time(track_idx: int, time: float)
void | track_set_enabled(track_idx: int, enabled: bool)
void | track_set_imported(track_idx: int, imported: bool)
void | track_set_interpolation_loop_wrap(track_idx: int, interpolation: bool)
void | track_set_interpolation_type(track_idx: int, interpolation: InterpolationType)
void | track_set_key_time(track_idx: int, key_idx: int, time: float)
void | track_set_key_transition(track_idx: int, key_idx: int, transition: float)
void | track_set_key_value(track_idx: int, key: int, value: Variant)
void | track_set_path(track_idx: int, path: NodePath)
void | track_swap(track_idx: int, with_idx: int)
UpdateMode | value_track_get_update_mode(track_idx: int) const
Variant | value_track_interpolate(track_idx: int, time_sec: float, backward: bool = false) const
void | value_track_set_update_mode(track_idx: int, mode: UpdateMode)

---

## Enumerations

enum TrackType
TrackType TYPE_VALUE = 0

Value tracks set values in node properties, but only those which can be interpolated. For 3D position/rotation/scale, using the dedicated TYPE_POSITION_3D, TYPE_ROTATION_3D and TYPE_SCALE_3D track types instead of TYPE_VALUE is recommended for performance reasons.

TrackType TYPE_POSITION_3D = 1

3D position track (values are stored in Vector3s).

TrackType TYPE_ROTATION_3D = 2

3D rotation track (values are stored in Quaternions).

TrackType TYPE_SCALE_3D = 3

3D scale track (values are stored in Vector3s).

TrackType TYPE_BLEND_SHAPE = 4

Blend shape track.

TrackType TYPE_METHOD = 5

Method tracks call functions with given arguments per key.

TrackType TYPE_BEZIER = 6

Bezier tracks are used to interpolate a value using custom curves. They can also be used to animate sub-properties of vectors and colors (e.g. alpha value of a Color).

TrackType TYPE_AUDIO = 7

Audio tracks are used to play an audio stream with either type of AudioStreamPlayer. The stream can be trimmed and previewed in the animation.

TrackType TYPE_ANIMATION = 8

Animation tracks play animations in other AnimationPlayer nodes.

---

enum InterpolationType
InterpolationType INTERPOLATION_NEAREST = 0

No interpolation (nearest value).

InterpolationType INTERPOLATION_LINEAR = 1

Linear interpolation.

InterpolationType INTERPOLATION_CUBIC = 2

Cubic interpolation. This looks smoother than linear interpolation, but is more expensive to interpolate. Stick to INTERPOLATION_LINEAR for complex 3D animations imported from external software, even if it requires using a higher animation framerate in return.

InterpolationType INTERPOLATION_LINEAR_ANGLE = 3

Linear interpolation with shortest path rotation.

Note: The result value is always normalized and may not match the key value.

InterpolationType INTERPOLATION_CUBIC_ANGLE = 4

Cubic interpolation with shortest path rotation.

Note: The result value is always normalized and may not match the key value.

---

enum UpdateMode
UpdateMode UPDATE_CONTINUOUS = 0

Update between keyframes and hold the value.

UpdateMode UPDATE_DISCRETE = 1

Update at the keyframes.

UpdateMode UPDATE_CAPTURE = 2

Same as UPDATE_CONTINUOUS but works as a flag to capture the value of the current object and perform interpolation in some methods. See also AnimationMixer.capture(), AnimationPlayer.playback_auto_capture, and AnimationPlayer.play_with_capture().

---

enum LoopMode
LoopMode LOOP_NONE = 0

At both ends of the animation, the animation will stop playing.

LoopMode LOOP_LINEAR = 1

At both ends of the animation, the animation will be repeated without changing the playback direction.

LoopMode LOOP_PINGPONG = 2

Repeats playback and reverse playback at both ends of the animation.

---

enum LoopedFlag
LoopedFlag LOOPED_FLAG_NONE = 0

This flag indicates that the animation proceeds without any looping.

LoopedFlag LOOPED_FLAG_END = 1

This flag indicates that the animation has reached the end of the animation and just after loop processed.

LoopedFlag LOOPED_FLAG_START = 2

This flag indicates that the animation has reached the start of the animation and just after loop processed.

---

enum FindMode
FindMode FIND_MODE_NEAREST = 0

Finds the nearest time key.

FindMode FIND_MODE_APPROX = 1

Finds only the key with approximating the time.

FindMode FIND_MODE_EXACT = 2

Finds only the key with matching the time.

---

## Property Descriptions

bool capture_included = false 

- bool is_capture_included()

Returns true if the capture track is included. This is a cached readonly value for performance.

---

float length = 1.0 

- void set_length(value: float)
- float get_length()

The total length of the animation (in seconds).

Note: Length is not delimited by the last key, as this one may be before or after the end to ensure correct interpolation and looping.

---

LoopMode loop_mode = 0 

- void set_loop_mode(value: LoopMode)
- LoopMode get_loop_mode()

Determines the behavior of both ends of the animation timeline during animation playback. This indicates whether and how the animation should be restarted, and is also used to correctly interpolate animation cycles.

---

float step = 0.033333335 

- void set_step(value: float)
- float get_step()

The animation step value.

---

## Method Descriptions

void add_marker(name: StringName, time: float) 

Adds a marker to this Animation.

---

int add_track(type: TrackType, at_position: int = -1) 

Adds a track to the Animation.

---

StringName animation_track_get_key_animation(track_idx: int, key_idx: int) const 

Returns the animation name at the key identified by key_idx. The track_idx must be the index of an Animation Track.

---

int animation_track_insert_key(track_idx: int, time: float, animation: StringName) 

Inserts a key with value animation at the given time (in seconds). The track_idx must be the index of an Animation Track.

---

void animation_track_set_key_animation(track_idx: int, key_idx: int, animation: StringName) 

Sets the key identified by key_idx to value animation. The track_idx must be the index of an Animation Track.

---

float audio_track_get_key_end_offset(track_idx: int, key_idx: int) const 

Returns the end offset of the key identified by key_idx. The track_idx must be the index of an Audio Track.

End offset is the number of seconds cut off at the ending of the audio stream.

---

float audio_track_get_key_start_offset(track_idx: int, key_idx: int) const 

Returns the start offset of the key identified by key_idx. The track_idx must be the index of an Audio Track.

Start offset is the number of seconds cut off at the beginning of the audio stream.

---

Resource audio_track_get_key_stream(track_idx: int, key_idx: int) const 

Returns the audio stream of the key identified by key_idx. The track_idx must be the index of an Audio Track.

---

int audio_track_insert_key(track_idx: int, time: float, stream: Resource, start_offset: float = 0, end_offset: float = 0) 

Inserts an Audio Track key at the given time in seconds. The track_idx must be the index of an Audio Track.

stream is the AudioStream resource to play. start_offset is the number of seconds cut off at the beginning of the audio stream, while end_offset is at the ending.

---

bool audio_track_is_use_blend(track_idx: int) const 

Returns true if the track at track_idx will be blended with other animations.

---

void audio_track_set_key_end_offset(track_idx: int, key_idx: int, offset: float) 

Sets the end offset of the key identified by key_idx to value offset. The track_idx must be the index of an Audio Track.

---

void audio_track_set_key_start_offset(track_idx: int, key_idx: int, offset: float) 

Sets the start offset of the key identified by key_idx to value offset. The track_idx must be the index of an Audio Track.

---

void audio_track_set_key_stream(track_idx: int, key_idx: int, stream: Resource) 

Sets the stream of the key identified by key_idx to value stream. The track_idx must be the index of an Audio Track.

---

void audio_track_set_use_blend(track_idx: int, enable: bool) 

Sets whether the track will be blended with other animations. If true, the audio playback volume changes depending on the blend value.

---

Vector2 bezier_track_get_key_in_handle(track_idx: int, key_idx: int) const 

Returns the in handle of the key identified by key_idx. The track_idx must be the index of a Bezier Track.

---

Vector2 bezier_track_get_key_out_handle(track_idx: int, key_idx: int) const 

Returns the out handle of the key identified by key_idx. The track_idx must be the index of a Bezier Track.

---

float bezier_track_get_key_value(track_idx: int, key_idx: int) const 

Returns the value of the key identified by key_idx. The track_idx must be the index of a Bezier Track.

---

int bezier_track_insert_key(track_idx: int, time: float, value: float, in_handle: Vector2 = Vector2(0, 0), out_handle: Vector2 = Vector2(0, 0)) 

Inserts a Bezier Track key at the given time in seconds. The track_idx must be the index of a Bezier Track.

in_handle is the left-side weight of the added Bezier curve point, out_handle is the right-side one, while value is the actual value at this point.

---

float bezier_track_interpolate(track_idx: int, time: float) const 

Returns the interpolated value at the given time (in seconds). The track_idx must be the index of a Bezier Track.

---

void bezier_track_set_key_in_handle(track_idx: int, key_idx: int, in_handle: Vector2, balanced_value_time_ratio: float = 1.0) 

Sets the in handle of the key identified by key_idx to value in_handle. The track_idx must be the index of a Bezier Track.

---

void bezier_track_set_key_out_handle(track_idx: int, key_idx: int, out_handle: Vector2, balanced_value_time_ratio: float = 1.0) 

Sets the out handle of the key identified by key_idx to value out_handle. The track_idx must be the index of a Bezier Track.

---

void bezier_track_set_key_value(track_idx: int, key_idx: int, value: float) 

Sets the value of the key identified by key_idx to the given value. The track_idx must be the index of a Bezier Track.

---

int blend_shape_track_insert_key(track_idx: int, time: float, amount: float) 

Inserts a key in a given blend shape track. Returns the key index.

---

float blend_shape_track_interpolate(track_idx: int, time_sec: float, backward: bool = false) const 

Returns the interpolated blend shape value at the given time (in seconds). The track_idx must be the index of a blend shape track.

---

void clear() 

Clear the animation (clear all tracks and reset all).

---

void compress(page_size: int = 8192, fps: int = 120, split_tolerance: float = 4.0) 

Compress the animation and all its tracks in-place. This will make track_is_compressed() return true once called on this Animation. Compressed tracks require less memory to be played, and are designed to be used for complex 3D animations (such as cutscenes) imported from external 3D software. Compression is lossy, but the difference is usually not noticeable in real world conditions.

Note: Compressed tracks have various limitations (such as not being editable from the editor), so only use compressed animations if you actually need them.

---

void copy_track(track_idx: int, to_animation: Animation) 

Adds a new track to to_animation that is a copy of the given track from this animation.

---

int find_track(path: NodePath, type: TrackType) const 

Returns the index of the specified track. If the track is not found, return -1.

---

StringName get_marker_at_time(time: float) const 

Returns the name of the marker located at the given time.

---

Color get_marker_color(name: StringName) const 

Returns the given marker's color.

---

PackedStringArray get_marker_names() const 

Returns every marker in this Animation, sorted ascending by time.

---

float get_marker_time(name: StringName) const 

Returns the given marker's time.

---

StringName get_next_marker(time: float) const 

Returns the closest marker that comes after the given time. If no such marker exists, an empty string is returned.

---

StringName get_prev_marker(time: float) const 

Returns the closest marker that comes before the given time. If no such marker exists, an empty string is returned.

---

int get_track_count() const 

Returns the amount of tracks in the animation.

---

bool has_marker(name: StringName) const 

Returns true if this Animation contains a marker with the given name.

---

StringName method_track_get_name(track_idx: int, key_idx: int) const 

Returns the method name of a method track.

---

Array method_track_get_params(track_idx: int, key_idx: int) const 

Returns the arguments values to be called on a method track for a given key in a given track.

---

void optimize(allowed_velocity_err: float = 0.01, allowed_angular_err: float = 0.01, precision: int = 3) 

Optimize the animation and all its tracks in-place. This will preserve only as many keys as are necessary to keep the animation within the specified bounds.

---

int position_track_insert_key(track_idx: int, time: float, position: Vector3) 

Inserts a key in a given 3D position track. Returns the key index.

---

Vector3 position_track_interpolate(track_idx: int, time_sec: float, backward: bool = false) const 

Returns the interpolated position value at the given time (in seconds). The track_idx must be the index of a 3D position track.

---

void remove_marker(name: StringName) 

Removes the marker with the given name from this Animation.

---

void remove_track(track_idx: int) 

Removes a track by specifying the track index.

---

int rotation_track_insert_key(track_idx: int, time: float, rotation: Quaternion) 

Inserts a key in a given 3D rotation track. Returns the key index.

---

Quaternion rotation_track_interpolate(track_idx: int, time_sec: float, backward: bool = false) const 

Returns the interpolated rotation value at the given time (in seconds). The track_idx must be the index of a 3D rotation track.

---

int scale_track_insert_key(track_idx: int, time: float, scale: Vector3) 

Inserts a key in a given 3D scale track. Returns the key index.

---

Vector3 scale_track_interpolate(track_idx: int, time_sec: float, backward: bool = false) const 

Returns the interpolated scale value at the given time (in seconds). The track_idx must be the index of a 3D scale track.

---

void set_marker_color(name: StringName, color: Color) 

Sets the given marker's color.

---

int track_find_key(track_idx: int, time: float, find_mode: FindMode = 0, limit: bool = false, backward: bool = false) const 

Finds the key index by time in a given track. Optionally, only find it if the approx/exact time is given.

If limit is true, it does not return keys outside the animation range.

If backward is true, the direction is reversed in methods that rely on one directional processing.

For example, in case find_mode is FIND_MODE_NEAREST, if there is no key in the current position just after seeked, the first key found is retrieved by searching before the position, but if backward is true, the first key found is retrieved after the position.

---

bool track_get_interpolation_loop_wrap(track_idx: int) const 

Returns true if the track at track_idx wraps the interpolation loop. New tracks wrap the interpolation loop by default.

---

InterpolationType track_get_interpolation_type(track_idx: int) const 

Returns the interpolation type of a given track.

---

int track_get_key_count(track_idx: int) const 

Returns the number of keys in a given track.

---

float track_get_key_time(track_idx: int, key_idx: int) const 

Returns the time at which the key is located.

---

float track_get_key_transition(track_idx: int, key_idx: int) const 

Returns the transition curve (easing) for a specific key (see the built-in math function @GlobalScope.ease()).

---

Variant track_get_key_value(track_idx: int, key_idx: int) const 

Returns the value of a given key in a given track.

---

NodePath track_get_path(track_idx: int) const 

Gets the path of a track. For more information on the path format, see track_set_path().

---

TrackType track_get_type(track_idx: int) const 

Gets the type of a track.

---

int track_insert_key(track_idx: int, time: float, key: Variant, transition: float = 1) 

Inserts a generic key in a given track. Returns the key index.

---

bool track_is_compressed(track_idx: int) const 

Returns true if the track is compressed, false otherwise. See also compress().

---

bool track_is_enabled(track_idx: int) const 

Returns true if the track at index track_idx is enabled.

---

bool track_is_imported(track_idx: int) const 

Returns true if the given track is imported. Else, return false.

---

void track_move_down(track_idx: int) 

Moves a track down.

---

void track_move_to(track_idx: int, to_idx: int) 

Changes the index position of track track_idx to the one defined in to_idx.

---

void track_move_up(track_idx: int) 

Moves a track up.

---

void track_remove_key(track_idx: int, key_idx: int) 

Removes a key by index in a given track.

---

void track_remove_key_at_time(track_idx: int, time: float) 

Removes a key at time in a given track.

---

void track_set_enabled(track_idx: int, enabled: bool) 

Enables/disables the given track. Tracks are enabled by default.

---

void track_set_imported(track_idx: int, imported: bool) 

Sets the given track as imported or not.

---

void track_set_interpolation_loop_wrap(track_idx: int, interpolation: bool) 

If true, the track at track_idx wraps the interpolation loop.

---

void track_set_interpolation_type(track_idx: int, interpolation: InterpolationType) 

Sets the interpolation type of a given track.

---

void track_set_key_time(track_idx: int, key_idx: int, time: float) 

Sets the time of an existing key.

---

void track_set_key_transition(track_idx: int, key_idx: int, transition: float) 

Sets the transition curve (easing) for a specific key (see the built-in math function @GlobalScope.ease()).

---

void track_set_key_value(track_idx: int, key: int, value: Variant) 

Sets the value of an existing key.

---

void track_set_path(track_idx: int, path: NodePath) 

Sets the path of a track. Paths must be valid scene-tree paths to a node and must be specified starting from the AnimationMixer.root_node that will reproduce the animation. Tracks that control properties or bones must append their name after the path, separated by ":".

For example, "character/skeleton:ankle" or "character/mesh:transform/local".

---

void track_swap(track_idx: int, with_idx: int) 

Swaps the track track_idx's index position with the track with_idx.

---

UpdateMode value_track_get_update_mode(track_idx: int) const 

Returns the update mode of a value track.

---

Variant value_track_interpolate(track_idx: int, time_sec: float, backward: bool = false) const 

Returns the interpolated value at the given time (in seconds). The track_idx must be the index of a value track.

A backward mainly affects the direction of key retrieval of the track with UPDATE_DISCRETE converted by AnimationMixer.ANIMATION_CALLBACK_MODE_DISCRETE_FORCE_CONTINUOUS to match the result with track_find_key().

---

void value_track_set_update_mode(track_idx: int, mode: UpdateMode) 

Sets the update mode of a value track.
