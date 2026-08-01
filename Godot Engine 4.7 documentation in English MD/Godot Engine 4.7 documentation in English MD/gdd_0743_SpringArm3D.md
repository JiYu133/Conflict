# SpringArm3D

Inherits: Node3D < Node < Object

A 3D raycast that dynamically moves its children near the collision point.

## Description

SpringArm3D casts a ray or a shape along its Z axis and moves all its direct children to the collision point, with an optional margin. This is useful for 3rd person cameras that move closer to the player when inside a tight space (you may need to exclude the player's collider from the SpringArm3D's collision check).

## Tutorials

- Third-person camera with spring arm

## Properties

int | collision_mask | 1
float | margin | 0.01
Shape3D | shape |
float | spring_length | 1.0

## Methods

void | add_excluded_object(RID: RID)
void | clear_excluded_objects()
float | get_hit_length()
bool | remove_excluded_object(RID: RID)

---

## Property Descriptions

int collision_mask = 1 

- void set_collision_mask(value: int)
- int get_collision_mask()

The layers against which the collision check will be done. See Collision layers and masks in the documentation for more information.

---

float margin = 0.01 

- void set_margin(value: float)
- float get_margin()

When the collision check is made, a candidate length for the SpringArm3D is given.

The margin is then subtracted to this length and the translation is applied to the child objects of the SpringArm3D.

This margin is useful for when the SpringArm3D has a Camera3D as a child node: without the margin, the Camera3D would be placed on the exact point of collision, while with the margin the Camera3D would be placed close to the point of collision.

---

Shape3D shape 

- void set_shape(value: Shape3D)
- Shape3D get_shape()

The Shape3D to use for the SpringArm3D.

When the shape is set, the SpringArm3D will cast the Shape3D on its z axis instead of performing a ray cast.

---

float spring_length = 1.0 

- void set_length(value: float)
- float get_length()

The maximum extent of the SpringArm3D. This is used as a length for both the ray and the shape cast used internally to calculate the desired position of the SpringArm3D's child nodes.

To know more about how to perform a shape cast or a ray cast, please consult the PhysicsDirectSpaceState3D documentation.

---

## Method Descriptions

void add_excluded_object(RID: RID) 

Adds the PhysicsBody3D object with the given RID to the list of PhysicsBody3D objects excluded from the collision check.

---

void clear_excluded_objects() 

Clears the list of PhysicsBody3D objects excluded from the collision check.

---

float get_hit_length() 

Returns the spring arm's current length.

---

bool remove_excluded_object(RID: RID) 

Removes the given RID from the list of PhysicsBody3D objects excluded from the collision check.
