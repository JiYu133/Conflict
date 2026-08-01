# ArrayOccluder3D

Inherits: Occluder3D < Resource < RefCounted < Object

3D polygon shape for use with occlusion culling in OccluderInstance3D.

## Description

ArrayOccluder3D stores an arbitrary 3D polygon shape that can be used by the engine's occlusion culling system. This is analogous to ArrayMesh, but for occluders.

See OccluderInstance3D's documentation for instructions on setting up occlusion culling.

## Tutorials

- Occlusion culling

## Properties

PackedInt32Array | indices | PackedInt32Array()
PackedVector3Array | vertices | PackedVector3Array()

## Methods

void | set_arrays(vertices: PackedVector3Array, indices: PackedInt32Array)

---

## Property Descriptions

PackedInt32Array indices = PackedInt32Array() 

- void set_indices(value: PackedInt32Array)
- PackedInt32Array get_indices()

The occluder's index position. Indices determine which points from the vertices array should be drawn, and in which order.

Note: The occluder is always updated after setting this value. If creating occluders procedurally, consider using set_arrays() instead to avoid updating the occluder twice when it's created.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedInt32Array for more details.

---

PackedVector3Array vertices = PackedVector3Array() 

- void set_vertices(value: PackedVector3Array)
- PackedVector3Array get_vertices()

The occluder's vertex positions in local 3D coordinates.

Note: The occluder is always updated after setting this value. If creating occluders procedurally, consider using set_arrays() instead to avoid updating the occluder twice when it's created.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedVector3Array for more details.

---

## Method Descriptions

void set_arrays(vertices: PackedVector3Array, indices: PackedInt32Array) 

Sets indices and vertices, while updating the final occluder only once after both values are set.
