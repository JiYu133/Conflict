# QuadOccluder3D

Inherits: Occluder3D < Resource < RefCounted < Object

Flat plane shape for use with occlusion culling in OccluderInstance3D.

## Description

QuadOccluder3D stores a flat plane shape that can be used by the engine's occlusion culling system. See also PolygonOccluder3D if you need to customize the quad's shape.

See OccluderInstance3D's documentation for instructions on setting up occlusion culling.

## Tutorials

- Occlusion culling

## Properties

Vector2 | size | Vector2(1, 1)

---

## Property Descriptions

Vector2 size = Vector2(1, 1) 

- void set_size(value: Vector2)
- Vector2 get_size()

The quad's size in 3D units.
