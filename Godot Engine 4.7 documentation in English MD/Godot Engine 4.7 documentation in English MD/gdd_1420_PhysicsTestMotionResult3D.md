# PhysicsTestMotionResult3D

Inherits: RefCounted < Object

Describes the motion and collision result from PhysicsServer3D.body_test_motion().

## Description

Describes the motion and collision result from PhysicsServer3D.body_test_motion().

## Methods

Object | get_collider(collision_index: int = 0) const
int | get_collider_id(collision_index: int = 0) const
RID | get_collider_rid(collision_index: int = 0) const
int | get_collider_shape(collision_index: int = 0) const
Vector3 | get_collider_velocity(collision_index: int = 0) const
int | get_collision_count() const
float | get_collision_depth(collision_index: int = 0) const
int | get_collision_local_shape(collision_index: int = 0) const
Vector3 | get_collision_normal(collision_index: int = 0) const
Vector3 | get_collision_point(collision_index: int = 0) const
float | get_collision_safe_fraction() const
float | get_collision_unsafe_fraction() const
Vector3 | get_remainder() const
Vector3 | get_travel() const

---

## Method Descriptions

Object get_collider(collision_index: int = 0) const 

Returns the colliding body's attached Object given a collision index (the deepest collision by default), if a collision occurred.

---

int get_collider_id(collision_index: int = 0) const 

Returns the unique instance ID of the colliding body's attached Object given a collision index (the deepest collision by default), if a collision occurred. See Object.get_instance_id().

---

RID get_collider_rid(collision_index: int = 0) const 

Returns the colliding body's RID used by the PhysicsServer3D given a collision index (the deepest collision by default), if a collision occurred.

---

int get_collider_shape(collision_index: int = 0) const 

Returns the colliding body's shape index given a collision index (the deepest collision by default), if a collision occurred. See CollisionObject3D.

---

Vector3 get_collider_velocity(collision_index: int = 0) const 

Returns the colliding body's velocity given a collision index (the deepest collision by default), if a collision occurred.

---

int get_collision_count() const 

Returns the number of detected collisions.

---

float get_collision_depth(collision_index: int = 0) const 

Returns the length of overlap along the collision normal given a collision index (the deepest collision by default), if a collision occurred.

---

int get_collision_local_shape(collision_index: int = 0) const 

Returns the moving object's colliding shape given a collision index (the deepest collision by default), if a collision occurred.

---

Vector3 get_collision_normal(collision_index: int = 0) const 

Returns the colliding body's shape's normal at the point of collision given a collision index (the deepest collision by default), if a collision occurred.

---

Vector3 get_collision_point(collision_index: int = 0) const 

Returns the point of collision in global coordinates given a collision index (the deepest collision by default), if a collision occurred.

---

float get_collision_safe_fraction() const 

Returns the maximum fraction of the motion that can occur without a collision, between 0 and 1.

---

float get_collision_unsafe_fraction() const 

Returns the minimum fraction of the motion needed to collide, if a collision occurred, between 0 and 1.

---

Vector3 get_remainder() const 

Returns the moving object's remaining movement vector.

---

Vector3 get_travel() const 

Returns the moving object's travel before collision.
