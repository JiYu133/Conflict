# OpenXRSpatialComponentBounded2DList

Experimental: This class may be changed or removed in future versions.

Inherits: OpenXRSpatialComponentData < RefCounted < Object

Object for storing the queries bounded2d result data.

## Description

Object for storing the queries 2D bounding rectangle result data when calling OpenXRSpatialEntityExtension.query_snapshot().

## Methods

Transform3D | get_center_pose(index: int) const
Vector2 | get_size(index: int) const

---

## Method Descriptions

Transform3D get_center_pose(index: int) const 

Returns the center of our bounding rectangle for the entity at this index.

---

Vector2 get_size(index: int) const 

Returns the size of our bounding rectangle for the entity at this index.
