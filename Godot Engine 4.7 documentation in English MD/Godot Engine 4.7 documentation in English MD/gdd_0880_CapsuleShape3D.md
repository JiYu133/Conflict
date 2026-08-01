# CapsuleShape3D

Inherits: Shape3D < Resource < RefCounted < Object

A 3D capsule shape used for physics collision.

## Description

A 3D capsule shape, intended for use in physics. Usually used to provide a shape for a CollisionShape3D.

Performance: CapsuleShape3D is fast to check collisions against. It is faster than CylinderShape3D, but slower than SphereShape3D and BoxShape3D.

## Tutorials

- 3D Physics Tests Demo [https://godotengine.org/asset-library/asset/2747]

## Properties

float | height | 2.0
float | mid_height |
float | radius | 0.5

---

## Property Descriptions

float height = 2.0 

- void set_height(value: float)
- float get_height()

The capsule's full height, including the hemispheres.

Note: The height of a capsule must be at least twice its radius. Otherwise, the capsule becomes a sphere. If the height is less than twice the radius, the properties adjust to a valid value.

---

float mid_height 

- void set_mid_height(value: float)
- float get_mid_height()

The capsule's height, excluding the hemispheres. This is the height of the central cylindrical part in the middle of the capsule, and is the distance between the centers of the two hemispheres. This is a wrapper for height.

---

float radius = 0.5 

- void set_radius(value: float)
- float get_radius()

The capsule's radius.

Note: The radius of a capsule cannot be greater than half of its height. Otherwise, the capsule becomes a sphere. If the radius is greater than half of the height, the properties adjust to a valid value.
