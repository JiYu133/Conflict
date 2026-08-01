# SpringBoneCollisionCapsule3D

Inherits: SpringBoneCollision3D < Node3D < Node < Object

A capsule shape collision that interacts with SpringBoneSimulator3D.

## Description

A capsule shape collision that interacts with SpringBoneSimulator3D.

## Properties

float | height | 0.5
bool | inside | false
float | mid_height |
float | radius | 0.1

---

## Property Descriptions

float height = 0.5 

- void set_height(value: float)
- float get_height()

The capsule's full height, including the hemispheres.

Note: The height of a capsule must be at least twice its radius. Otherwise, the capsule becomes a sphere. If the height is less than twice the radius, the properties adjust to a valid value.

---

bool inside = false 

- void set_inside(value: bool)
- bool is_inside()

If true, the collision acts to trap the joint within the collision.

---

float mid_height 

- void set_mid_height(value: float)
- float get_mid_height()

The capsule's height, excluding the hemispheres. This is the height of the central cylindrical part in the middle of the capsule, and is the distance between the centers of the two hemispheres. This is a wrapper for height.

---

float radius = 0.1 

- void set_radius(value: float)
- float get_radius()

The capsule's radius.

Note: The radius of a capsule cannot be greater than half of its height. Otherwise, the capsule becomes a sphere. If the radius is greater than half of the height, the properties adjust to a valid value.
