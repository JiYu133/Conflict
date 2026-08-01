# BoxMesh

Inherits: PrimitiveMesh < Mesh < Resource < RefCounted < Object

Generate an axis-aligned box PrimitiveMesh.

## Description

Generate an axis-aligned box PrimitiveMesh.

The box's UV layout is arranged in a 3×2 layout that allows texturing each face individually. To apply the same texture on all faces, change the material's UV property to Vector3(3, 2, 1). This is equivalent to adding UV *= vec2(3.0, 2.0) in a vertex shader.

Note: When using a large textured BoxMesh (e.g. as a floor), you may stumble upon UV jittering issues depending on the camera angle. To solve this, increase subdivide_depth, subdivide_height and subdivide_width until you no longer notice UV jittering.

## Properties

Vector3 | size | Vector3(1, 1, 1)
int | subdivide_depth | 0
int | subdivide_height | 0
int | subdivide_width | 0

---

## Property Descriptions

Vector3 size = Vector3(1, 1, 1) 

- void set_size(value: Vector3)
- Vector3 get_size()

The box's width, height and depth.

---

int subdivide_depth = 0 

- void set_subdivide_depth(value: int)
- int get_subdivide_depth()

Number of extra edge loops inserted along the Z axis.

---

int subdivide_height = 0 

- void set_subdivide_height(value: int)
- int get_subdivide_height()

Number of extra edge loops inserted along the Y axis.

---

int subdivide_width = 0 

- void set_subdivide_width(value: int)
- int get_subdivide_width()

Number of extra edge loops inserted along the X axis.
