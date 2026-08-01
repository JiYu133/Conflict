# PlaneMesh

Inherits: PrimitiveMesh < Mesh < Resource < RefCounted < Object

Inherited By: QuadMesh

Class representing a planar PrimitiveMesh.

## Description

Class representing a planar PrimitiveMesh. This flat mesh does not have a thickness. By default, this mesh is aligned on the X and Z axes; this default rotation isn't suited for use with billboarded materials. For billboarded materials, change orientation to FACE_Z.

Note: When using a large textured PlaneMesh (e.g. as a floor), you may stumble upon UV jittering issues depending on the camera angle. To solve this, increase subdivide_depth and subdivide_width until you no longer notice UV jittering.

## Properties

Vector3 | center_offset | Vector3(0, 0, 0)
Orientation | orientation | 1
Vector2 | size | Vector2(2, 2)
int | subdivide_depth | 0
int | subdivide_width | 0

---

## Enumerations

enum Orientation
Orientation FACE_X = 0

PlaneMesh will face the positive X-axis.

Orientation FACE_Y = 1

PlaneMesh will face the positive Y-axis. This matches the behavior of the PlaneMesh in Godot 3.x.

Orientation FACE_Z = 2

PlaneMesh will face the positive Z-axis. This matches the behavior of the QuadMesh in Godot 3.x.

---

## Property Descriptions

Vector3 center_offset = Vector3(0, 0, 0) 

- void set_center_offset(value: Vector3)
- Vector3 get_center_offset()

Offset of the generated plane. Useful for particles.

---

Orientation orientation = 1 

- void set_orientation(value: Orientation)
- Orientation get_orientation()

Direction that the PlaneMesh is facing.

---

Vector2 size = Vector2(2, 2) 

- void set_size(value: Vector2)
- Vector2 get_size()

Size of the generated plane.

---

int subdivide_depth = 0 

- void set_subdivide_depth(value: int)
- int get_subdivide_depth()

Number of subdivision along the Z axis.

---

int subdivide_width = 0 

- void set_subdivide_width(value: int)
- int get_subdivide_width()

Number of subdivision along the X axis.
