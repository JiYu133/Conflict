# SpringBoneCollisionSphere3D

Inherits: SpringBoneCollision3D < Node3D < Node < Object

A sphere shape collision that interacts with SpringBoneSimulator3D.

## Description

A sphere shape collision that interacts with SpringBoneSimulator3D.

## Properties

bool | inside | false
float | radius | 0.1

---

## Property Descriptions

bool inside = false 

- void set_inside(value: bool)
- bool is_inside()

If true, the collision acts to trap the joint within the collision.

---

float radius = 0.1 

- void set_radius(value: float)
- float get_radius()

The sphere's radius.
