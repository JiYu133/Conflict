# RayCast2D

Inherits: Node2D < CanvasItem < Node < Object

A ray in 2D space, used to find the first collision object it intersects.

## Description

A raycast represents a ray from its origin to its target_position that finds the closest object along its path, if it intersects any.

RayCast2D can ignore some objects by adding them to an exception list, by making its detection reporting ignore Area2Ds (collide_with_areas) or PhysicsBody2Ds (collide_with_bodies), or by configuring physics layers.

RayCast2D calculates intersection every physics frame, and it holds the result until the next physics frame. For an immediate raycast, or if you want to configure a RayCast2D multiple times within the same physics frame, use force_raycast_update().

To sweep over a region of 2D space, you can approximate the region with multiple RayCast2Ds or use ShapeCast2D.

## Tutorials

- Ray-casting

## Properties

bool | collide_with_areas | false
bool | collide_with_bodies | true
int | collision_mask | 1
bool | enabled | true
bool | exclude_parent | true
bool | hit_from_inside | false
Vector2 | target_position | Vector2(0, 50)

## Methods

void | add_exception(node: CollisionObject2D)
void | add_exception_rid(rid: RID)
void | clear_exceptions()
void | force_raycast_update()
Object | get_collider() const
RID | get_collider_rid() const
int | get_collider_shape() const
bool | get_collision_mask_value(layer_number: int) const
Vector2 | get_collision_normal() const
Vector2 | get_collision_point() const
bool | is_colliding() const
void | remove_exception(node: CollisionObject2D)
void | remove_exception_rid(rid: RID)
void | set_collision_mask_value(layer_number: int, value: bool)

---

## Property Descriptions

bool collide_with_areas = false 

- void set_collide_with_areas(value: bool)
- bool is_collide_with_areas_enabled()

If true, collisions with Area2Ds will be reported.

---

bool collide_with_bodies = true 

- void set_collide_with_bodies(value: bool)
- bool is_collide_with_bodies_enabled()

If true, collisions with PhysicsBody2Ds will be reported.

---

int collision_mask = 1 

- void set_collision_mask(value: int)
- int get_collision_mask()

The ray's collision mask. Only objects in at least one collision layer enabled in the mask will be detected. See Collision layers and masks in the documentation for more information.

---

bool enabled = true 

- void set_enabled(value: bool)
- bool is_enabled()

If true, collisions will be reported.

---

bool exclude_parent = true 

- void set_exclude_parent_body(value: bool)
- bool get_exclude_parent_body()

If true, this raycast will not report collisions with its parent node. This property only has an effect if the parent node is a CollisionObject2D. See also Node.get_parent() and add_exception().

---

bool hit_from_inside = false 

- void set_hit_from_inside(value: bool)
- bool is_hit_from_inside_enabled()

If true, the ray will detect a hit when starting inside shapes. In this case the collision normal will be Vector2(0, 0). Does not affect concave polygon shapes.

---

Vector2 target_position = Vector2(0, 50) 

- void set_target_position(value: Vector2)
- Vector2 get_target_position()

The ray's destination point, relative to this raycast's Node2D.position.

---

## Method Descriptions

void add_exception(node: CollisionObject2D) 

Adds a collision exception so the ray does not report collisions with the specified node.

---

void add_exception_rid(rid: RID) 

Adds a collision exception so the ray does not report collisions with the specified RID.

---

void clear_exceptions() 

Removes all collision exceptions for this ray.

---

void force_raycast_update() 

Updates the collision information for the ray immediately, without waiting for the next _physics_process call. Use this method, for example, when the ray or its parent has changed state.

Note: enabled does not need to be true for this to work.

---

Object get_collider() const 

Returns the first object that the ray intersects, or null if no object is intersecting the ray (i.e. is_colliding() returns false).

Note: This object is not guaranteed to be a CollisionObject2D. For example, if the ray intersects a TileMapLayer, the method will return a TileMapLayer instance.

---

RID get_collider_rid() const 

Returns the RID of the first object that the ray intersects, or an empty RID if no object is intersecting the ray (i.e. is_colliding() returns false).

---

int get_collider_shape() const 

Returns the shape ID of the first object that the ray intersects, or 0 if no object is intersecting the ray (i.e. is_colliding() returns false).

To get the intersected shape node, for a CollisionObject2D target, use:

```
var target = get_collider() # A CollisionObject2D.
var shape_id = get_collider_shape() # The shape index in the collider.
var owner_id = target.shape_find_owner(shape_id) # The owner ID in the collider.
var shape = target.shape_owner_get_owner(owner_id)
```

```
var target = (CollisionObject2D)GetCollider(); // A CollisionObject2D.
var shapeId = GetColliderShape(); // The shape index in the collider.
var ownerId = target.ShapeFindOwner(shapeId); // The owner ID in the collider.
var shape = target.ShapeOwnerGetOwner(ownerId);
```

---

bool get_collision_mask_value(layer_number: int) const 

Returns whether or not the specified layer of the collision_mask is enabled, given a layer_number between 1 and 32.

---

Vector2 get_collision_normal() const 

Returns the normal of the intersecting object's shape at the collision point, or Vector2(0, 0) if the ray starts inside the shape and hit_from_inside is true.

Note: Check that is_colliding() returns true before calling this method to ensure the returned normal is valid and up-to-date.

---

Vector2 get_collision_point() const 

Returns the collision point at which the ray intersects the closest object, in the global coordinate system. If hit_from_inside is true and the ray starts inside of a collision shape, this function will return the origin point of the ray.

Note: Check that is_colliding() returns true before calling this method to ensure the returned point is valid and up-to-date.

---

bool is_colliding() const 

Returns whether any object is intersecting with the ray's vector (considering the vector length).

---

void remove_exception(node: CollisionObject2D) 

Removes a collision exception so the ray can report collisions with the specified node.

---

void remove_exception_rid(rid: RID) 

Removes a collision exception so the ray can report collisions with the specified RID.

---

void set_collision_mask_value(layer_number: int, value: bool) 

Based on value, enables or disables the specified layer in the collision_mask, given a layer_number between 1 and 32.
