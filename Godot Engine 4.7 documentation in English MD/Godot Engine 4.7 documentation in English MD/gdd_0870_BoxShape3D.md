# BoxShape3D

Inherits: Shape3D < Resource < RefCounted < Object

A 3D box shape used for physics collision.

## Description

A 3D box shape, intended for use in physics. Usually used to provide a shape for a CollisionShape3D.

Performance: BoxShape3D is fast to check collisions against. It is faster than CapsuleShape3D and CylinderShape3D, but slower than SphereShape3D.

## Tutorials

- 3D Physics Tests Demo [https://godotengine.org/asset-library/asset/2747]
- 3D Kinematic Character Demo [https://godotengine.org/asset-library/asset/2739]
- 3D Platformer Demo [https://godotengine.org/asset-library/asset/2748]

## Properties

Vector3 | size | Vector3(1, 1, 1)

---

## Property Descriptions

Vector3 size = Vector3(1, 1, 1) 

- void set_size(value: Vector3)
- Vector3 get_size()

The box's width, height and depth.
