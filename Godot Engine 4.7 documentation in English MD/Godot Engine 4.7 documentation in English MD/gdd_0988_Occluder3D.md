# Occluder3D

Inherits: Resource < RefCounted < Object

Inherited By: ArrayOccluder3D, BoxOccluder3D, PolygonOccluder3D, QuadOccluder3D, SphereOccluder3D

Occluder shape resource for use with occlusion culling in OccluderInstance3D.

## Description

Occluder3D stores an occluder shape that can be used by the engine's occlusion culling system.

See OccluderInstance3D's documentation for instructions on setting up occlusion culling.

## Tutorials

- Occlusion culling

## Methods

PackedInt32Array | get_indices() const
PackedVector3Array | get_vertices() const

---

## Method Descriptions

PackedInt32Array get_indices() const 

Returns the occluder shape's vertex indices.

---

PackedVector3Array get_vertices() const 

Returns the occluder shape's vertex positions.
