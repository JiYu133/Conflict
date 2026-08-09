# PhysicsTestMotionResult2D

Inherits: RefCounted < Object

Describes the motion and collision result from PhysicsServer2D.body_test_motion().

## Description

Describes the motion and collision result from PhysicsServer2D.body_test_motion().

## Methods

Object | get_collider() const
int | get_collider_id() const
RID | get_collider_rid() const
int | get_collider_shape() const
Vector2 | get_collider_velocity() const
float | get_collision_depth() const
int | get_collision_local_shape() const
Vector2 | get_collision_normal() const
Vector2 | get_collision_point() const
float | get_collision_safe_fraction() const
float | get_collision_unsafe_fraction() const
Vector2 | get_remainder() const
Vector2 | get_travel() const

---

## Method Descriptions

Object get_collider() const 

Returns the colliding body's attached Object, if a collision occurred.

---

int get_collider_id() const 

Returns the unique instance ID of the colliding body's attached Object, if a collision occurred. See Object.get_instance_id().

---

RID get_collider_rid() const 

Returns the colliding body's RID used by the PhysicsServer2D, if a collision occurred.

---

int get_collider_shape() const 

Returns the colliding body's shape index, if a collision occurred. See CollisionObject2D.

---

Vector2 get_collider_velocity() const 

Returns the colliding body's velocity, if a collision occurred.

---

float get_collision_depth() const 

Returns the length of overlap along the collision normal, if a collision occurred.

---

int get_collision_local_shape() const 

Returns the moving object's colliding shape, if a collision occurred.

---

Vector2 get_collision_normal() const 

Returns the colliding body's shape's normal at the point of collision, if a collision occurred.

---

Vector2 get_collision_point() const 

Returns the point of collision in global coordinates, if a collision occurred.

---

float get_collision_safe_fraction() const 

Returns the maximum fraction of the motion that can occur without a collision, between 0 and 1.

---

float get_collision_unsafe_fraction() const 

Returns the minimum fraction of the motion needed to collide, if a collision occurred, between 0 and 1.

---

Vector2 get_remainder() const 

Returns the moving object's remaining movement vector.

---

Vector2 get_travel() const 

Returns the moving object's travel before collision.
