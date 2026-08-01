# RectangleShape2D

Inherits: Shape2D < Resource < RefCounted < Object

A 2D rectangle shape used for physics collision.

## Description

A 2D rectangle shape, intended for use in physics. Usually used to provide a shape for a CollisionShape2D.

Performance: RectangleShape2D is fast to check collisions against. It is faster than CapsuleShape2D, but slower than CircleShape2D.

## Tutorials

- 2D Pong Demo [https://godotengine.org/asset-library/asset/2728]
- 2D Kinematic Character Demo [https://godotengine.org/asset-library/asset/2719]

## Properties

Vector2 | size | Vector2(20, 20)

---

## Property Descriptions

Vector2 size = Vector2(20, 20) 

- void set_size(value: Vector2)
- Vector2 get_size()

The rectangle's width and height.
