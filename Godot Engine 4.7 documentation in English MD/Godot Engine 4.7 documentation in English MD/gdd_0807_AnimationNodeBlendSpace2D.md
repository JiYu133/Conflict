# AnimationNodeBlendSpace2D

Inherits: AnimationRootNode < AnimationNode < Resource < RefCounted < Object

A set of AnimationRootNodes placed on 2D coordinates, crossfading between the three adjacent ones. Used by AnimationTree.

## Description

A resource used by AnimationNodeBlendTree.

AnimationNodeBlendSpace2D represents a virtual 2D space on which AnimationRootNodes are placed. Outputs the linear blend of the three adjacent animations using a Vector2 weight. Adjacent in this context means the three AnimationRootNodes making up the triangle that contains the current value.

You can add vertices to the blend space with add_blend_point() and automatically triangulate it by setting auto_triangles to true. Otherwise, use add_triangle() and remove_triangle() to triangulate the blend space by hand.

## Tutorials

- Using AnimationTree
- Third Person Shooter (TPS) Demo [https://godotengine.org/asset-library/asset/2710]

## Properties

bool | auto_triangles | true
BlendMode | blend_mode | 0
float | cyclic_length | 0.0
Vector2 | max_space | Vector2(1, 1)
Vector2 | min_space | Vector2(-1, -1)
Vector2 | snap | Vector2(0.1, 0.1)
bool | sync |
SyncMode | sync_mode | 0
String | x_label | "x"
String | y_label | "y"

## Methods

void | add_blend_point(node: AnimationRootNode, pos: Vector2, at_index: int = -1, name: StringName = &"")
void | add_triangle(x: int, y: int, z: int, at_index: int = -1)
int | find_blend_point_by_name(name: StringName) const
int | get_blend_point_count() const
StringName | get_blend_point_name(point: int) const
AnimationRootNode | get_blend_point_node(point: int) const
Vector2 | get_blend_point_position(point: int) const
int | get_triangle_count() const
int | get_triangle_point(triangle: int, point: int)
void | remove_blend_point(point: int)
void | remove_triangle(triangle: int)
void | reorder_blend_point(from_index: int, to_index: int)
void | set_blend_point_name(point: int, name: StringName)
void | set_blend_point_node(point: int, node: AnimationRootNode)
void | set_blend_point_position(point: int, pos: Vector2)

---

## Signals

triangles_updated() 

Emitted every time the blend space's triangles are created, removed, or when one of their vertices changes position.

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

bool auto_triangles = true 

- void set_auto_triangles(value: bool)
- bool get_auto_triangles()

If true, the blend space is triangulated automatically. The mesh updates every time you add or remove points with add_blend_point() and remove_blend_point().

---

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

Vector2 max_space = Vector2(1, 1) 

- void set_max_space(value: Vector2)
- Vector2 get_max_space()

The blend space's X and Y axes' upper limit for the points' position. See add_blend_point().

---

Vector2 min_space = Vector2(-1, -1) 

- void set_min_space(value: Vector2)
- Vector2 get_min_space()

The blend space's X and Y axes' lower limit for the points' position. See add_blend_point().

---

Vector2 snap = Vector2(0.1, 0.1) 

- void set_snap(value: Vector2)
- Vector2 get_snap()

Position increment to snap to when moving a point.

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

String x_label = "x" 

- void set_x_label(value: String)
- String get_x_label()

Name of the blend space's X axis.

---

String y_label = "y" 

- void set_y_label(value: String)
- String get_y_label()

Name of the blend space's Y axis.

---

## Method Descriptions

void add_blend_point(node: AnimationRootNode, pos: Vector2, at_index: int = -1, name: StringName = &"") 

Adds a new point with name that represents a node at the position set by pos. You can insert it at a specific index using the at_index argument. If you use the default value for at_index, the point is inserted at the end of the blend points array.

Note: If no name is provided, safe index is used as reference. In the future, empty names will be deprecated, so explicitly passing a name is recommended.

---

void add_triangle(x: int, y: int, z: int, at_index: int = -1) 

Creates a new triangle using three points x, y, and z. Triangles can overlap. You can insert the triangle at a specific index using the at_index argument. If you use the default value for at_index, the point is inserted at the end of the blend points array.

---

int find_blend_point_by_name(name: StringName) const 

Returns the index of the blend point with the given name. Returns -1 if no blend point with that name is found.

---

int get_blend_point_count() const 

Returns the number of points in the blend space.

---

StringName get_blend_point_name(point: int) const 

Returns the name of the blend point at index point.

---

AnimationRootNode get_blend_point_node(point: int) const 

Returns the AnimationRootNode referenced by the point at index point.

---

Vector2 get_blend_point_position(point: int) const 

Returns the position of the point at index point.

---

int get_triangle_count() const 

Returns the number of triangles in the blend space.

---

int get_triangle_point(triangle: int, point: int) 

Returns the position of the point at index point in the triangle of index triangle.

---

void remove_blend_point(point: int) 

Removes the point at index point from the blend space.

---

void remove_triangle(triangle: int) 

Removes the triangle at index triangle from the blend space.

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

void set_blend_point_position(point: int, pos: Vector2) 

Updates the position of the point at index point in the blend space.
