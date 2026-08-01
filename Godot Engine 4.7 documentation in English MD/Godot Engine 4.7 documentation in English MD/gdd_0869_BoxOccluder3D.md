# BoxOccluder3D

Inherits: Occluder3D < Resource < RefCounted < Object

Cuboid shape for use with occlusion culling in OccluderInstance3D.

## Description

BoxOccluder3D stores a cuboid shape that can be used by the engine's occlusion culling system.

See OccluderInstance3D's documentation for instructions on setting up occlusion culling.

## Tutorials

- Occlusion culling

## Properties

Vector3 | size | Vector3(1, 1, 1)

---

## Property Descriptions

Vector3 size = Vector3(1, 1, 1) 

- void set_size(value: Vector3)
- Vector3 get_size()

The box's size in 3D units.
