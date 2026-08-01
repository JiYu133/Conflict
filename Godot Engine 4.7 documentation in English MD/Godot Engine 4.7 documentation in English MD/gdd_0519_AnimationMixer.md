# AnimationMixer

Inherits: Node < Object

Inherited By: AnimationPlayer, AnimationTree

Base class for AnimationPlayer and AnimationTree.

## Description

Base class for AnimationPlayer and AnimationTree to manage animation lists. It also has general properties and methods for playback and blending.

After instantiating the playback information data within the extended class, the blending is processed by the AnimationMixer.

## Tutorials

- Migrating Animations from Godot 4.0 to 4.3 [https://godotengine.org/article/migrating-animations-from-godot-4-0-to-4-3/]

## Properties

bool | active | true
int | audio_max_polyphony | 32
AnimationCallbackModeDiscrete | callback_mode_discrete | 1
AnimationCallbackModeMethod | callback_mode_method | 0
AnimationCallbackModeProcess | callback_mode_process | 1
bool | deterministic | false
bool | reset_on_save | true
bool | root_motion_local | false
NodePath | root_motion_track | NodePath("")
NodePath | root_node | NodePath("..")

## Methods

Variant | _post_process_key_value(animation: Animation, track: int, value: Variant, object_id: int, object_sub_idx: int) virtual const
Error | add_animation_library(name: StringName, library: AnimationLibrary)
void | advance(delta: float)
void | capture(name: StringName, duration: float, trans_type: TransitionType = 0, ease_type: EaseType = 0)
void | clear_caches()
StringName | find_animation(animation: Animation) const
StringName | find_animation_library(animation: Animation) const
Animation | get_animation(name: StringName) const
AnimationLibrary | get_animation_library(name: StringName) const
Array[StringName] | get_animation_library_list() const
PackedStringArray | get_animation_list() const
Vector3 | get_root_motion_position() const
Vector3 | get_root_motion_position_accumulator() const
Quaternion | get_root_motion_rotation() const
Quaternion | get_root_motion_rotation_accumulator() const
Vector3 | get_root_motion_scale() const
Vector3 | get_root_motion_scale_accumulator() const
bool | has_animation(name: StringName) const
bool | has_animation_library(name: StringName) const
void | remove_animation_library(name: StringName)
void | rename_animation_library(name: StringName, newname: StringName)

---

## Signals

animation_finished(anim_name: StringName) 

Notifies when an animation finished playing.

Note: This signal is not emitted if an animation is looping.

---

animation_libraries_updated() 

Notifies when the animation libraries have changed.

---

animation_list_changed() 

Notifies when an animation list is changed.

---

animation_started(anim_name: StringName) 

Notifies when an animation starts playing.

Note: This signal is not emitted if an animation is looping.

---

caches_cleared() 

Notifies when the caches have been cleared, either automatically, or manually via clear_caches().

---

mixer_applied() 

Notifies when the blending result related have been applied to the target objects.

---

mixer_updated() 

Notifies when the property related process have been updated.

---

## Enumerations

enum AnimationCallbackModeProcess
AnimationCallbackModeProcess ANIMATION_CALLBACK_MODE_PROCESS_PHYSICS = 0

Process animation during physics frames (see Node.NOTIFICATION_INTERNAL_PHYSICS_PROCESS). This is especially useful when animating physics bodies.

AnimationCallbackModeProcess ANIMATION_CALLBACK_MODE_PROCESS_IDLE = 1

Process animation during process frames (see Node.NOTIFICATION_INTERNAL_PROCESS).

AnimationCallbackModeProcess ANIMATION_CALLBACK_MODE_PROCESS_MANUAL = 2

Do not process animation. Use advance() to process the animation manually.

---

enum AnimationCallbackModeMethod
AnimationCallbackModeMethod ANIMATION_CALLBACK_MODE_METHOD_DEFERRED = 0

Batch method calls during the animation process, then do the calls after events are processed. This avoids bugs involving deleting nodes or modifying the AnimationPlayer while playing.

AnimationCallbackModeMethod ANIMATION_CALLBACK_MODE_METHOD_IMMEDIATE = 1

Make method calls immediately when reached in the animation.

---

enum AnimationCallbackModeDiscrete
AnimationCallbackModeDiscrete ANIMATION_CALLBACK_MODE_DISCRETE_DOMINANT = 0

An Animation.UPDATE_DISCRETE track value takes precedence when blending Animation.UPDATE_CONTINUOUS or Animation.UPDATE_CAPTURE track values and Animation.UPDATE_DISCRETE track values.

AnimationCallbackModeDiscrete ANIMATION_CALLBACK_MODE_DISCRETE_RECESSIVE = 1

An Animation.UPDATE_CONTINUOUS or Animation.UPDATE_CAPTURE track value takes precedence when blending the Animation.UPDATE_CONTINUOUS or Animation.UPDATE_CAPTURE track values and the Animation.UPDATE_DISCRETE track values. This is the default behavior for AnimationPlayer.

AnimationCallbackModeDiscrete ANIMATION_CALLBACK_MODE_DISCRETE_FORCE_CONTINUOUS = 2

Always treat the Animation.UPDATE_DISCRETE track value as Animation.UPDATE_CONTINUOUS with Animation.INTERPOLATION_NEAREST. This is the default behavior for AnimationTree.

If a value track has un-interpolatable type key values, it is internally converted to use ANIMATION_CALLBACK_MODE_DISCRETE_RECESSIVE with Animation.UPDATE_DISCRETE.

Un-interpolatable type list:

- @GlobalScope.TYPE_NIL
- @GlobalScope.TYPE_NODE_PATH
- @GlobalScope.TYPE_RID
- @GlobalScope.TYPE_OBJECT
- @GlobalScope.TYPE_CALLABLE
- @GlobalScope.TYPE_SIGNAL
- @GlobalScope.TYPE_DICTIONARY
- @GlobalScope.TYPE_PACKED_BYTE_ARRAY

@GlobalScope.TYPE_BOOL and @GlobalScope.TYPE_INT are treated as @GlobalScope.TYPE_FLOAT during blending and rounded when the result is retrieved.

It is same for arrays and vectors with them such as @GlobalScope.TYPE_PACKED_INT32_ARRAY or @GlobalScope.TYPE_VECTOR2I, they are treated as @GlobalScope.TYPE_PACKED_FLOAT32_ARRAY or @GlobalScope.TYPE_VECTOR2. Also note that for arrays, the size is also interpolated.

@GlobalScope.TYPE_STRING and @GlobalScope.TYPE_STRING_NAME are interpolated between character codes and lengths, but note that there is a difference in algorithm between interpolation between keys and interpolation by blending.

---

## Property Descriptions

bool active = true 

- void set_active(value: bool)
- bool is_active()

If true, the AnimationMixer will be processing.

---

int audio_max_polyphony = 32 

- void set_audio_max_polyphony(value: int)
- int get_audio_max_polyphony()

The number of possible simultaneous sounds for each of the assigned AudioStreamPlayers.

For example, if this value is 32 and the animation has two audio tracks, the two AudioStreamPlayers assigned can play simultaneously up to 32 voices each.

---

AnimationCallbackModeDiscrete callback_mode_discrete = 1 

- void set_callback_mode_discrete(value: AnimationCallbackModeDiscrete)
- AnimationCallbackModeDiscrete get_callback_mode_discrete()

Ordinarily, tracks can be set to Animation.UPDATE_DISCRETE to update infrequently, usually when using nearest interpolation.

However, when blending with Animation.UPDATE_CONTINUOUS several results are considered. The callback_mode_discrete specify it explicitly. See also AnimationCallbackModeDiscrete.

To make the blended results look good, it is recommended to set this to ANIMATION_CALLBACK_MODE_DISCRETE_FORCE_CONTINUOUS to update every frame during blending. Other values exist for compatibility and they are fine if there is no blending, but not so, may produce artifacts.

---

AnimationCallbackModeMethod callback_mode_method = 0 

- void set_callback_mode_method(value: AnimationCallbackModeMethod)
- AnimationCallbackModeMethod get_callback_mode_method()

The call mode used for "Call Method" tracks.

---

AnimationCallbackModeProcess callback_mode_process = 1 

- void set_callback_mode_process(value: AnimationCallbackModeProcess)
- AnimationCallbackModeProcess get_callback_mode_process()

The process notification in which to update animations.

---

bool deterministic = false 

- void set_deterministic(value: bool)
- bool is_deterministic()

If true, the blending uses the deterministic algorithm. The total weight is not normalized and the result is accumulated with an initial value (0 or a "RESET" animation if present).

This means that if the total amount of blending is 0.0, the result is equal to the "RESET" animation.

If the number of tracks between the blended animations is different, the animation with the missing track is treated as if it had the initial value.

If false, The blend does not use the deterministic algorithm. The total weight is normalized and always 1.0. If the number of tracks between the blended animations is different, nothing is done about the animation that is missing a track.

Note: In AnimationTree, the blending with AnimationNodeAdd2, AnimationNodeAdd3, AnimationNodeSub2 or the weight greater than 1.0 may produce unexpected results.

For example, if AnimationNodeAdd2 blends two nodes with the amount 1.0, then total weight is 2.0 but it will be normalized to make the total amount 1.0 and the result will be equal to AnimationNodeBlend2 with the amount 0.5.

---

bool reset_on_save = true 

- void set_reset_on_save_enabled(value: bool)
- bool is_reset_on_save_enabled()

This is used by the editor. If set to true, the scene will be saved with the effects of the reset animation (the animation with the key "RESET") applied as if it had been seeked to time 0, with the editor keeping the values that the scene had before saving.

This makes it more convenient to preview and edit animations in the editor, as changes to the scene will not be saved as long as they are set in the reset animation.

---

bool root_motion_local = false 

- void set_root_motion_local(value: bool)
- bool is_root_motion_local()

If true, get_root_motion_position() value is extracted as a local translation value before blending. In other words, it is treated like the translation is done after the rotation.

---

NodePath root_motion_track = NodePath("") 

- void set_root_motion_track(value: NodePath)
- NodePath get_root_motion_track()

The path to the Animation track used for root motion. Paths must be valid scene-tree paths to a node, and must be specified starting from the parent node of the node that will reproduce the animation. The root_motion_track uses the same format as Animation.track_set_path(), but note that a bone must be specified.

If the track has type Animation.TYPE_POSITION_3D, Animation.TYPE_ROTATION_3D, or Animation.TYPE_SCALE_3D the transformation will be canceled visually, and the animation will appear to stay in place. See also get_root_motion_position(), get_root_motion_rotation(), get_root_motion_scale(), and RootMotionView.

---

NodePath root_node = NodePath("..") 

- void set_root_node(value: NodePath)
- NodePath get_root_node()

The node which node path references will travel from.

---

## Method Descriptions

Variant _post_process_key_value(animation: Animation, track: int, value: Variant, object_id: int, object_sub_idx: int) virtual const 

A virtual function for processing after getting a key during playback.

---

Error add_animation_library(name: StringName, library: AnimationLibrary) 

Adds library to the animation player, under the key name.

AnimationMixer has a global library by default with an empty string as key. For adding an animation to the global library:

```
var global_library = mixer.get_animation_library("")
global_library.add_animation("animation_name", animation_resource)
```

---

void advance(delta: float) 

Manually advance the animations by the specified time (in seconds).

---

void capture(name: StringName, duration: float, trans_type: TransitionType = 0, ease_type: EaseType = 0) 

If the animation track specified by name has an option Animation.UPDATE_CAPTURE, stores current values of the objects indicated by the track path as a cache. If there is already a captured cache, the old cache is discarded.

After this it will interpolate with current animation blending result during the playback process for the time specified by duration, working like a crossfade.

You can specify trans_type as the curve for the interpolation. For better results, it may be appropriate to specify Tween.TRANS_LINEAR for cases where the first key of the track begins with a non-zero value or where the key value does not change, and Tween.TRANS_QUAD for cases where the key value changes linearly.

---

void clear_caches() 

AnimationMixer caches animated nodes. It may not notice if a node disappears; clear_caches() forces it to update the cache again.

---

StringName find_animation(animation: Animation) const 

Returns the key of animation or an empty StringName if not found.

---

StringName find_animation_library(animation: Animation) const 

Returns the key for the AnimationLibrary that contains animation or an empty StringName if not found.

---

Animation get_animation(name: StringName) const 

Returns the Animation with the key name. If the animation does not exist, null is returned and an error is logged.

---

AnimationLibrary get_animation_library(name: StringName) const 

Returns the first AnimationLibrary with key name or null if not found.

To get the AnimationMixer's global animation library, use get_animation_library("").

---

Array[StringName] get_animation_library_list() const 

Returns the list of stored library keys.

---

PackedStringArray get_animation_list() const 

Returns the list of stored animation keys.

---

Vector3 get_root_motion_position() const 

Retrieve the motion delta of position with the root_motion_track as a Vector3 that can be used elsewhere.

If root_motion_track is not a path to a track of type Animation.TYPE_POSITION_3D, returns Vector3(0, 0, 0).

See also root_motion_track and RootMotionView.

The most basic example is applying position to CharacterBody3D:

```
var current_rotation
func _process(delta):
    if Input.is_action_just_pressed("animate"):
        current_rotation = get_quaternion()
        state_machine.travel("Animate")
    var velocity = current_rotation * animation_tree.get_root_motion_position() / delta
    set_velocity(velocity)
    move_and_slide()
```

By using this in combination with get_root_motion_rotation_accumulator(), you can apply the root motion position more correctly to account for the rotation of the node.

```
func _process(delta):
    if Input.is_action_just_pressed("animate"):
        state_machine.travel("Animate")
    set_quaternion(get_quaternion() * animation_tree.get_root_motion_rotation())
    var velocity = (animation_tree.get_root_motion_rotation_accumulator().inverse() * get_quaternion()) * animation_tree.get_root_motion_position() / delta
    set_velocity(velocity)
    move_and_slide()
```

If root_motion_local is true, returns the pre-multiplied translation value with the inverted rotation.

In this case, the code can be written as follows:

```
func _process(delta):
    if Input.is_action_just_pressed("animate"):
        state_machine.travel("Animate")
    set_quaternion(get_quaternion() * animation_tree.get_root_motion_rotation())
    var velocity = get_quaternion() * animation_tree.get_root_motion_position() / delta
    set_velocity(velocity)
    move_and_slide()
```

---

Vector3 get_root_motion_position_accumulator() const 

Retrieve the blended value of the position tracks with the root_motion_track as a Vector3 that can be used elsewhere.

This is useful in cases where you want to respect the initial key values of the animation.

For example, if an animation with only one key Vector3(0, 0, 0) is played in the previous frame and then an animation with only one key Vector3(1, 0, 1) is played in the next frame, the difference can be calculated as follows:

```
var prev_root_motion_position_accumulator
func _process(delta):
    if Input.is_action_just_pressed("animate"):
        state_machine.travel("Animate")
    var current_root_motion_position_accumulator = animation_tree.get_root_motion_position_accumulator()
    var difference = current_root_motion_position_accumulator - prev_root_motion_position_accumulator
    prev_root_motion_position_accumulator = current_root_motion_position_accumulator
    transform.origin += difference
```

However, if the animation loops, an unintended discrete change may occur, so this is only useful for some simple use cases.

---

Quaternion get_root_motion_rotation() const 

Retrieve the motion delta of rotation with the root_motion_track as a Quaternion that can be used elsewhere.

If root_motion_track is not a path to a track of type Animation.TYPE_ROTATION_3D, returns Quaternion(0, 0, 0, 1).

See also root_motion_track and RootMotionView.

The most basic example is applying rotation to CharacterBody3D:

```
func _process(delta):
    if Input.is_action_just_pressed("animate"):
        state_machine.travel("Animate")
    set_quaternion(get_quaternion() * animation_tree.get_root_motion_rotation())
```

---

Quaternion get_root_motion_rotation_accumulator() const 

Retrieve the blended value of the rotation tracks with the root_motion_track as a Quaternion that can be used elsewhere.

This is necessary to apply the root motion position correctly, taking rotation into account. See also get_root_motion_position().

Also, this is useful in cases where you want to respect the initial key values of the animation.

For example, if an animation with only one key Quaternion(0, 0, 0, 1) is played in the previous frame and then an animation with only one key Quaternion(0, 0.707, 0, 0.707) is played in the next frame, the difference can be calculated as follows:

```
var prev_root_motion_rotation_accumulator
func _process(delta):
    if Input.is_action_just_pressed("animate"):
        state_machine.travel("Animate")
    var current_root_motion_rotation_accumulator = animation_tree.get_root_motion_rotation_accumulator()
    var difference = prev_root_motion_rotation_accumulator.inverse() * current_root_motion_rotation_accumulator
    prev_root_motion_rotation_accumulator = current_root_motion_rotation_accumulator
    transform.basis *=  Basis(difference)
```

However, if the animation loops, an unintended discrete change may occur, so this is only useful for some simple use cases.

---

Vector3 get_root_motion_scale() const 

Retrieve the motion delta of scale with the root_motion_track as a Vector3 that can be used elsewhere.

If root_motion_track is not a path to a track of type Animation.TYPE_SCALE_3D, returns Vector3(0, 0, 0).

See also root_motion_track and RootMotionView.

The most basic example is applying scale to CharacterBody3D:

```
var current_scale = Vector3(1, 1, 1)
var scale_accum = Vector3(1, 1, 1)
func _process(delta):
    if Input.is_action_just_pressed("animate"):
        current_scale = get_scale()
        scale_accum = Vector3(1, 1, 1)
        state_machine.travel("Animate")
    scale_accum += animation_tree.get_root_motion_scale()
    set_scale(current_scale * scale_accum)
```

---

Vector3 get_root_motion_scale_accumulator() const 

Retrieve the blended value of the scale tracks with the root_motion_track as a Vector3 that can be used elsewhere.

For example, if an animation with only one key Vector3(1, 1, 1) is played in the previous frame and then an animation with only one key Vector3(2, 2, 2) is played in the next frame, the difference can be calculated as follows:

```
var prev_root_motion_scale_accumulator
func _process(delta):
    if Input.is_action_just_pressed("animate"):
        state_machine.travel("Animate")
    var current_root_motion_scale_accumulator = animation_tree.get_root_motion_scale_accumulator()
    var difference = current_root_motion_scale_accumulator - prev_root_motion_scale_accumulator
    prev_root_motion_scale_accumulator = current_root_motion_scale_accumulator
    transform.basis = transform.basis.scaled(difference)
```

However, if the animation loops, an unintended discrete change may occur, so this is only useful for some simple use cases.

---

bool has_animation(name: StringName) const 

Returns true if the AnimationMixer stores an Animation with key name.

---

bool has_animation_library(name: StringName) const 

Returns true if the AnimationMixer stores an AnimationLibrary with key name.

---

void remove_animation_library(name: StringName) 

Removes the AnimationLibrary associated with the key name.

---

void rename_animation_library(name: StringName, newname: StringName) 

Moves the AnimationLibrary associated with the key name to the key newname.
