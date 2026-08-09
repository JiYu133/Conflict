# KinematicCollision3D

Inherits: RefCounted < Object

Holds collision data from the movement of a PhysicsBody3D.

## Description

Holds collision data from the movement of a PhysicsBody3D, usually from PhysicsBody3D.move_and_collide(). When a PhysicsBody3D is moved, it stops if it detects a collision with another body. If a collision is detected, a KinematicCollision3D object is returned.

The collision data includes the colliding object, the remaining motion, and the collision position. This data can be used to determine a custom response to the collision.

## Methods

float | get_angle(collision_index: int = 0, up_direction: Vector3 = Vector3(0, 1, 0)) const
Object | get_collider(collision_index: int = 0) const
int | get_collider_id(collision_index: int = 0) const
RID | get_collider_rid(collision_index: int = 0) const
Object | get_collider_shape(collision_index: int = 0) const
int | get_collider_shape_index(collision_index: int = 0) const
Vector3 | get_collider_velocity(collision_index: int = 0) const
int | get_collision_count() const
float | get_depth() const
Object | get_local_shape(collision_index: int = 0) const
Vector3 | get_normal(collision_index: int = 0) const
Vector3 | get_position(collision_index: int = 0) const
Vector3 | get_remainder() const
Vector3 | get_travel() const

---

## Method Descriptions

float get_angle(collision_index: int = 0, up_direction: Vector3 = Vector3(0, 1, 0)) const 

Returns the collision angle according to up_direction, which is Vector3.UP by default. This value is always positive.

---

Object get_collider(collision_index: int = 0) const 

Returns the colliding body's attached Object given a collision index (the deepest collision by default).

---

int get_collider_id(collision_index: int = 0) const 

Returns the unique instance ID of the colliding body's attached Object given a collision index (the deepest collision by default). See Object.get_instance_id().

---

RID get_collider_rid(collision_index: int = 0) const 

Returns the colliding body's RID used by the PhysicsServer3D given a collision index (the deepest collision by default).

---

Object get_collider_shape(collision_index: int = 0) const 

Returns the colliding body's shape given a collision index (the deepest collision by default).

---

int get_collider_shape_index(collision_index: int = 0) const 

Returns the colliding body's shape index given a collision index (the deepest collision by default). See CollisionObject3D.

---

Vector3 get_collider_velocity(collision_index: int = 0) const 

Returns the colliding body's velocity given a collision index (the deepest collision by default).

---

int get_collision_count() const 

Returns the number of detected collisions.

---

float get_depth() const 

Returns the colliding body's length of overlap along the collision normal.

---

Object get_local_shape(collision_index: int = 0) const 

Returns the moving object's colliding shape given a collision index (the deepest collision by default).

---

Vector3 get_normal(collision_index: int = 0) const 

Returns the colliding body's shape's normal at the point of collision given a collision index (the deepest collision by default).

---

Vector3 get_position(collision_index: int = 0) const 

Returns the point of collision in global coordinates given a collision index (the deepest collision by default).

---

Vector3 get_remainder() const 

Returns the moving object's remaining movement vector.

---

Vector3 get_travel() const 

Returns the moving object's travel before collision.
