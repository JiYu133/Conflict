# CylinderShape3D

Inherits: Shape3D < Resource < RefCounted < Object

A 3D cylinder shape used for physics collision.

## Description

A 3D cylinder shape, intended for use in physics. Usually used to provide a shape for a CollisionShape3D.

Note: There are several known bugs with cylinder collision shapes. Using CapsuleShape3D or BoxShape3D instead is recommended.

Performance: CylinderShape3D is fast to check collisions against, but it is slower than CapsuleShape3D, BoxShape3D, and SphereShape3D.

## Tutorials

- Third Person Shooter (TPS) Demo [https://godotengine.org/asset-library/asset/2710]
- 3D Physics Tests Demo [https://godotengine.org/asset-library/asset/2747]
- 3D Voxel Demo [https://godotengine.org/asset-library/asset/2755]

## Properties

float | height | 2.0
float | radius | 0.5

---

## Property Descriptions

float height = 2.0 

- void set_height(value: float)
- float get_height()

The cylinder's height.

---

float radius = 0.5 

- void set_radius(value: float)
- float get_radius()

The cylinder's radius.
