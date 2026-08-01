# OpenXRSpatialComponentMesh3DList

Experimental: This class may be changed or removed in future versions.

Inherits: OpenXRSpatialComponentData < RefCounted < Object

Object for storing the queries mesh3d result data.

## Description

Object for storing the queries 3d mesh result data when calling OpenXRSpatialEntityExtension.query_snapshot().

## Methods

Mesh | get_mesh(index: int) const
Transform3D | get_transform(index: int) const

---

## Method Descriptions

Mesh get_mesh(index: int) const 

Returns the mesh for the entity at this index.

---

Transform3D get_transform(index: int) const 

Returns the transform for positioning our mesh for the entity at this index.
