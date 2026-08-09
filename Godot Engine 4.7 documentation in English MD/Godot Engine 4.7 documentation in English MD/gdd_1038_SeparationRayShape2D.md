# SeparationRayShape2D

Inherits: Shape2D < Resource < RefCounted < Object

A 2D ray shape used for physics collision that tries to separate itself from any collider.

## Description

A 2D ray shape, intended for use in physics. Usually used to provide a shape for a CollisionShape2D. When a SeparationRayShape2D collides with an object, it tries to separate itself from it by moving its endpoint to the collision point. For example, a SeparationRayShape2D next to a character can allow it to instantly move up when touching stairs.

## Properties

float | length | 20.0
bool | slide_on_slope | false

---

## Property Descriptions

float length = 20.0 

- void set_length(value: float)
- float get_length()

The ray's length.

---

bool slide_on_slope = false 

- void set_slide_on_slope(value: bool)
- bool get_slide_on_slope()

If false (default), the shape always separates and returns a normal along its own direction.

If true, the shape can return the correct normal and separate in any direction, allowing sliding motion on slopes.
