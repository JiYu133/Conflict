# OpenXRSpatialComponentMesh2DList

Experimental: This class may be changed or removed in future versions.

Inherits: OpenXRSpatialComponentData < RefCounted < Object

Object for storing the queries mesh2d result data.

## Description

Object for storing the queries 2D mesh result data when calling OpenXRSpatialEntityExtension.query_snapshot().

## Methods

PackedInt32Array | get_indices(snapshot: RID, index: int) const
Transform3D | get_transform(index: int) const
PackedVector2Array | get_vertices(snapshot: RID, index: int) const

---

## Method Descriptions

PackedInt32Array get_indices(snapshot: RID, index: int) const 

Returns the mesh indices for the entity at this index.

---

Transform3D get_transform(index: int) const 

Returns the transform for positioning our mesh for the entity at this index.

---

PackedVector2Array get_vertices(snapshot: RID, index: int) const 

Returns the mesh vertices for the entity at this index.
