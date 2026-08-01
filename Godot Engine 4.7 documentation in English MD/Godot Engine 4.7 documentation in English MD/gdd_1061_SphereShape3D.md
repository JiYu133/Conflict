# SphereShape3D

Inherits: Shape3D < Resource < RefCounted < Object

A 3D sphere shape used for physics collision.

## Description

A 3D sphere shape, intended for use in physics. Usually used to provide a shape for a CollisionShape3D.

Performance: SphereShape3D is fast to check collisions against. It is faster than BoxShape3D, CapsuleShape3D, and CylinderShape3D.

## Tutorials

- 3D Physics Tests Demo [https://godotengine.org/asset-library/asset/2747]

## Properties

float | radius | 0.5

---

## Property Descriptions

float radius = 0.5 

- void set_radius(value: float)
- float get_radius()

The sphere's radius. The shape's diameter is double the radius.
