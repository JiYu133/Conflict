# CapsuleShape2D

Inherits: Shape2D < Resource < RefCounted < Object

A 2D capsule shape used for physics collision.

## Description

A 2D capsule shape, intended for use in physics. Usually used to provide a shape for a CollisionShape2D.

Performance: CapsuleShape2D is fast to check collisions against, but it is slower than RectangleShape2D and CircleShape2D.

## Properties

float | height | 30.0
float | mid_height |
float | radius | 10.0

---

## Property Descriptions

float height = 30.0 

- void set_height(value: float)
- float get_height()

The capsule's full height, including the semicircles.

Note: The height of a capsule must be at least twice its radius. Otherwise, the capsule becomes a circle. If the height is less than twice the radius, the properties adjust to a valid value.

---

float mid_height 

- void set_mid_height(value: float)
- float get_mid_height()

The capsule's height, excluding the semicircles. This is the height of the central rectangular part in the middle of the capsule, and is the distance between the centers of the two semicircles. This is a wrapper for height.

---

float radius = 10.0 

- void set_radius(value: float)
- float get_radius()

The capsule's radius.

Note: The radius of a capsule cannot be greater than half of its height. Otherwise, the capsule becomes a circle. If the radius is greater than half of the height, the properties adjust to a valid value.
