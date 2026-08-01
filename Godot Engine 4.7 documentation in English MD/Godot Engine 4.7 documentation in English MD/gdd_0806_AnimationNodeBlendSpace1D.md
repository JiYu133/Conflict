# AnimationNodeBlendSpace1D

Inherits: AnimationRootNode < AnimationNode < Resource < RefCounted < Object

A set of AnimationRootNodes placed on a virtual axis, crossfading between the two adjacent ones. Used by AnimationTree.

## Description

A resource used by AnimationNodeBlendTree.

AnimationNodeBlendSpace1D represents a virtual axis on which any type of AnimationRootNodes can be added using add_blend_point(). Outputs the linear blend of the two AnimationRootNodes adjacent to the current value.

You can set the extents of the axis with min_space and max_space.

## Tutorials

- Using AnimationTree

## Properties

BlendMode | blend_mode | 0
float | cyclic_length | 0.0
float | max_space | 1.0
float | min_space | -1.0
float | snap | 0.1
bool | sync |
SyncMode | sync_mode | 0
String | value_label | "value"

## Methods

void | add_blend_point(node: AnimationRootNode, pos: float, at_index: int = -1, name: StringName = &"")
int | find_blend_point_by_name(name: StringName) const
int | get_blend_point_count() const
StringName | get_blend_point_name(point: int) const
AnimationRootNode | get_blend_point_node(point: int) const
float | get_blend_point_position(point: int) const
void | remove_blend_point(point: int)
void | reorder_blend_point(from_index: int, to_index: int)
void | set_blend_point_name(point: int, name: StringName)
void | set_blend_point_node(point: int, node: AnimationRootNode)
void | set_blend_point_position(point: int, pos: float)

---

## Enumerations

enum BlendMode
BlendMode BLEND_MODE_INTERPOLATED = 0

The interpolation between animations is linear.

BlendMode BLEND_MODE_DISCRETE = 1

The blend space plays the animation of the animation node which blending position is closest to. Useful for frame-by-frame 2D animations.

BlendMode BLEND_MODE_DISCRETE_CARRY = 2

Similar to BLEND_MODE_DISCRETE, but starts the new animation at the last animation's playback position.

---

enum SyncMode
SyncMode SYNC_MODE_NONE = 0

Inactive animations are frozen and do not advance.

SyncMode SYNC_MODE_INDEPENDENT = 1

Inactive animations advance with a weight of 0. This is equivalent to the previous sync = true behavior.

SyncMode SYNC_MODE_CYCLIC_MUTABLE = 2

All animations are time-scaled so they stay in sync, with the cycle length dynamically computed from active blend weights. This is self-normalizing: a solo animation plays at normal speed.

Note: If you apply AnimationNodeTimeSeek to the result when handling animations of different lengths, synchronization will be broken. In such cases, it is recommended to use AnimationNodeAnimation.use_custom_timeline to align the animation lengths.

SyncMode SYNC_MODE_CYCLIC_CONSTANT = 3

All animations are time-scaled so they complete one cycle in cyclic_length seconds, keeping them in sync regardless of their individual lengths.

Note: If you apply AnimationNodeTimeSeek to the result when handling animations of different lengths, synchronization will be broken. In such cases, it is recommended to use AnimationNodeAnimation.use_custom_timeline to align the animation lengths.

---

## Property Descriptions

BlendMode blend_mode = 0 

- void set_blend_mode(value: BlendMode)
- BlendMode get_blend_mode()

Controls the interpolation between animations.

---

float cyclic_length = 0.0 

- void set_cyclic_length(value: float)
- float get_cyclic_length()

The cycle length in seconds used by SYNC_MODE_CYCLIC_CONSTANT. All animations are time-scaled so they complete one full cycle in this duration. Must be greater than 0 for cyclic sync to take effect.

---

float max_space = 1.0 

- void set_max_space(value: float)
- float get_max_space()

The blend space's axis's upper limit for the points' position. See add_blend_point().

---

float min_space = -1.0 

- void set_min_space(value: float)
- float get_min_space()

The blend space's axis's lower limit for the points' position. See add_blend_point().

---

float snap = 0.1 

- void set_snap(value: float)
- float get_snap()

Position increment to snap to when moving a point on the axis.

---

bool sync 

- void set_use_sync(value: bool)
- bool is_using_sync()

Deprecated: Use sync_mode instead.

If true, sync mode is enabled (equivalent to SYNC_MODE_INDEPENDENT). This property is kept for backward compatibility.

---

SyncMode sync_mode = 0 

- void set_sync_mode(value: SyncMode)
- SyncMode get_sync_mode()

Controls how animations are synced when blended. See SyncMode for available options.

---

String value_label = "value" 

- void set_value_label(value: String)
- String get_value_label()

Label of the virtual axis of the blend space.

---

## Method Descriptions

void add_blend_point(node: AnimationRootNode, pos: float, at_index: int = -1, name: StringName = &"") 

Adds a new point with name that represents a node on the virtual axis at a given position set by pos. You can insert it at a specific index using the at_index argument. If you use the default value for at_index, the point is inserted at the end of the blend points array.

Note: If no name is provided, safe index is used as reference. In the future, empty names will be deprecated, so explicitly passing a name is recommended.

---

int find_blend_point_by_name(name: StringName) const 

Returns the index of the blend point with the given name. Returns -1 if no blend point with that name is found.

---

int get_blend_point_count() const 

Returns the number of points on the blend axis.

---

StringName get_blend_point_name(point: int) const 

Returns the name of the blend point at index point.

---

AnimationRootNode get_blend_point_node(point: int) const 

Returns the AnimationNode referenced by the point at index point.

---

float get_blend_point_position(point: int) const 

Returns the position of the point at index point.

---

void remove_blend_point(point: int) 

Removes the point at index point from the blend axis.

---

void reorder_blend_point(from_index: int, to_index: int) 

Swaps the blend points at indices from_index and to_index, exchanging their positions and properties.

---

void set_blend_point_name(point: int, name: StringName) 

Sets the name of the blend point at index point. If the name conflicts with an existing point, a unique name will be generated automatically.

---

void set_blend_point_node(point: int, node: AnimationRootNode) 

Changes the AnimationNode referenced by the point at index point.

---

void set_blend_point_position(point: int, pos: float) 

Updates the position of the point at index point on the blend axis.
