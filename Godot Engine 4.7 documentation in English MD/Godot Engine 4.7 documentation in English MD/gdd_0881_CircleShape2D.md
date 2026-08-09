# CircleShape2D

Inherits: Shape2D < Resource < RefCounted < Object

A 2D circle shape used for physics collision.

## Description

A 2D circle shape, intended for use in physics. Usually used to provide a shape for a CollisionShape2D.

Performance: CircleShape2D is fast to check collisions against. It is faster than RectangleShape2D and CapsuleShape2D.

## Properties

float | radius | 10.0

---

## Property Descriptions

float radius = 10.0 

- void set_radius(value: float)
- float get_radius()

The circle's radius.
