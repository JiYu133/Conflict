# ShapeCast3D

Inherits: Node3D < Node < Object

A 3D shape that sweeps a region of space to detect CollisionObject3Ds.

## Description

Shape casting allows to detect collision objects by sweeping its shape along the cast direction determined by target_position. This is similar to RayCast3D, but it allows for sweeping a region of space, rather than just a straight line. ShapeCast3D can detect multiple collision objects. It is useful for things like wide laser beams or snapping a simple shape to a floor.

Immediate collision overlaps can be done with the target_position set to Vector3(0, 0, 0) and by calling force_shapecast_update() within the same physics frame. This helps to overcome some limitations of Area3D when used as an instantaneous detection area, as collision information isn't immediately available to it.

Note: Shape casting is more computationally expensive than ray casting.

## Properties

bool | collide_with_areas | false
bool | collide_with_bodies | true
int | collision_mask | 1
Array | collision_result | []
Color | debug_shape_custom_color | Color(0, 0, 0, 1)
bool | enabled | true
bool | exclude_parent | true
float | margin | 0.0
int | max_results | 32
Shape3D | shape |
Vector3 | target_position | Vector3(0, -1, 0)

## Methods

void | add_exception(node: CollisionObject3D)
void | add_exception_rid(rid: RID)
void | clear_exceptions()
void | force_shapecast_update()
float | get_closest_collision_safe_fraction() const
float | get_closest_collision_unsafe_fraction() const
Object | get_collider(index: int) const
RID | get_collider_rid(index: int) const
int | get_collider_shape(index: int) const
int | get_collision_count() const
bool | get_collision_mask_value(layer_number: int) const
Vector3 | get_collision_normal(index: int) const
Vector3 | get_collision_point(index: int) const
bool | is_colliding() const
void | remove_exception(node: CollisionObject3D)
void | remove_exception_rid(rid: RID)
void | resource_changed(resource: Resource)
void | set_collision_mask_value(layer_number: int, value: bool)

---

## Property Descriptions

bool collide_with_areas = false 

- void set_collide_with_areas(value: bool)
- bool is_collide_with_areas_enabled()

If true, collisions with Area3Ds will be reported.

---

bool collide_with_bodies = true 

- void set_collide_with_bodies(value: bool)
- bool is_collide_with_bodies_enabled()

If true, collisions with PhysicsBody3Ds will be reported.

---

int collision_mask = 1 

- void set_collision_mask(value: int)
- int get_collision_mask()

The shape's collision mask. Only objects in at least one collision layer enabled in the mask will be detected. See Collision layers and masks in the documentation for more information.

---

Array collision_result = [] 

- Array get_collision_result()

Returns the complete collision information from the collision sweep. The data returned is the same as in the PhysicsDirectSpaceState3D.get_rest_info() method.

---

Color debug_shape_custom_color = Color(0, 0, 0, 1) 

- void set_debug_shape_custom_color(value: Color)
- Color get_debug_shape_custom_color()

The custom color to use to draw the shape in the editor and at run-time if Visible Collision Shapes is enabled in the Debug menu. This color will be highlighted at run-time if the ShapeCast3D is colliding with something.

If set to Color(0.0, 0.0, 0.0) (by default), the color set in ProjectSettings.debug/shapes/collision/shape_color is used.

---

bool enabled = true 

- void set_enabled(value: bool)
- bool is_enabled()

If true, collisions will be reported.

---

bool exclude_parent = true 

- void set_exclude_parent_body(value: bool)
- bool get_exclude_parent_body()

If true, the parent node will be excluded from collision detection.

---

float margin = 0.0 

- void set_margin(value: float)
- float get_margin()

The collision margin for the shape. A larger margin helps detecting collisions more consistently, at the cost of precision.

---

int max_results = 32 

- void set_max_results(value: int)
- int get_max_results()

The number of intersections can be limited with this parameter, to reduce the processing time.

---

Shape3D shape 

- void set_shape(value: Shape3D)
- Shape3D get_shape()

The shape to be used for collision queries.

---

Vector3 target_position = Vector3(0, -1, 0) 

- void set_target_position(value: Vector3)
- Vector3 get_target_position()

The shape's destination point, relative to this node's Node3D.position.

---

## Method Descriptions

void add_exception(node: CollisionObject3D) 

Adds a collision exception so the shape does not report collisions with the specified node.

---

void add_exception_rid(rid: RID) 

Adds a collision exception so the shape does not report collisions with the specified RID.

---

void clear_exceptions() 

Removes all collision exceptions for this shape.

---

void force_shapecast_update() 

Updates the collision information for the shape immediately, without waiting for the next _physics_process call. Use this method, for example, when the shape or its parent has changed state.

Note: Setting enabled to true is not required for this to work.

---

float get_closest_collision_safe_fraction() const 

Returns the fraction from this cast's origin to its target_position of how far the shape can move without triggering a collision, as a value between 0.0 and 1.0.

---

float get_closest_collision_unsafe_fraction() const 

Returns the fraction from this cast's origin to its target_position of how far the shape must move to trigger a collision, as a value between 0.0 and 1.0.

In ideal conditions this would be the same as get_closest_collision_safe_fraction(), however shape casting is calculated in discrete steps, so the precise point of collision can occur between two calculated positions.

---

Object get_collider(index: int) const 

Returns the collided Object of one of the multiple collisions at index, or null if no object is intersecting the shape (i.e. is_colliding() returns false).

---

RID get_collider_rid(index: int) const 

Returns the RID of the collided object of one of the multiple collisions at index.

---

int get_collider_shape(index: int) const 

Returns the shape ID of the colliding shape of one of the multiple collisions at index, or 0 if no object is intersecting the shape (i.e. is_colliding() returns false).

---

int get_collision_count() const 

The number of collisions detected at the point of impact. Use this to iterate over multiple collisions as provided by get_collider(), get_collider_shape(), get_collision_point(), and get_collision_normal() methods.

---

bool get_collision_mask_value(layer_number: int) const 

Returns whether or not the specified layer of the collision_mask is enabled, given a layer_number between 1 and 32.

---

Vector3 get_collision_normal(index: int) const 

Returns the normal of one of the multiple collisions at index of the intersecting object.

---

Vector3 get_collision_point(index: int) const 

Returns the collision point of one of the multiple collisions at index where the shape intersects the colliding object.

Note: This point is in the global coordinate system.

---

bool is_colliding() const 

Returns whether any object is intersecting with the shape's vector (considering the vector length).

---

void remove_exception(node: CollisionObject3D) 

Removes a collision exception so the shape does report collisions with the specified node.

---

void remove_exception_rid(rid: RID) 

Removes a collision exception so the shape does report collisions with the specified RID.

---

void resource_changed(resource: Resource) 

Deprecated: Use Resource.changed instead.

This method does nothing.

---

void set_collision_mask_value(layer_number: int, value: bool) 

Based on value, enables or disables the specified layer in the collision_mask, given a layer_number between 1 and 32.
