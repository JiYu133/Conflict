# KinematicCollision2D

Inherits: RefCounted < Object

Holds collision data from the movement of a PhysicsBody2D.

## Description

Holds collision data from the movement of a PhysicsBody2D, usually from PhysicsBody2D.move_and_collide(). When a PhysicsBody2D is moved, it stops if it detects a collision with another body. If a collision is detected, a KinematicCollision2D object is returned.

The collision data includes the colliding object, the remaining motion, and the collision position. This data can be used to determine a custom response to the collision.

## Methods

float | get_angle(up_direction: Vector2 = Vector2(0, -1)) const
Object | get_collider() const
int | get_collider_id() const
RID | get_collider_rid() const
Object | get_collider_shape() const
int | get_collider_shape_index() const
Vector2 | get_collider_velocity() const
float | get_depth() const
Object | get_local_shape() const
Vector2 | get_normal() const
Vector2 | get_position() const
Vector2 | get_remainder() const
Vector2 | get_travel() const

---

## Method Descriptions

float get_angle(up_direction: Vector2 = Vector2(0, -1)) const 

Returns the collision angle according to up_direction, which is Vector2.UP by default. This value is always positive.

---

Object get_collider() const 

Returns the colliding body's attached Object.

---

int get_collider_id() const 

Returns the unique instance ID of the colliding body's attached Object. See Object.get_instance_id().

---

RID get_collider_rid() const 

Returns the colliding body's RID used by the PhysicsServer2D.

---

Object get_collider_shape() const 

Returns the colliding body's shape.

---

int get_collider_shape_index() const 

Returns the colliding body's shape index. See CollisionObject2D.

---

Vector2 get_collider_velocity() const 

Returns the colliding body's velocity.

---

float get_depth() const 

Returns the colliding body's length of overlap along the collision normal.

---

Object get_local_shape() const 

Returns the moving object's colliding shape.

---

Vector2 get_normal() const 

Returns the colliding body's shape's normal at the point of collision.

---

Vector2 get_position() const 

Returns the point of collision in global coordinates.

---

Vector2 get_remainder() const 

Returns the moving object's remaining movement vector.

---

Vector2 get_travel() const 

Returns the moving object's travel before collision.
