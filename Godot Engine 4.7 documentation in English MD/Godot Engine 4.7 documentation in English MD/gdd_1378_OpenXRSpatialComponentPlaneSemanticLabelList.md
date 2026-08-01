# OpenXRSpatialComponentPlaneSemanticLabelList

Experimental: This class may be changed or removed in future versions.

Inherits: OpenXRSpatialComponentData < RefCounted < Object

Object for storing the queries plane semantic label result data.

## Description

Object for storing the queries plane semantic label result data when calling OpenXRSpatialEntityExtension.query_snapshot().

## Methods

PlaneSemanticLabel | get_plane_semantic_label(index: int) const

---

## Enumerations

enum PlaneSemanticLabel
PlaneSemanticLabel PLANE_SEMANTIC_LABEL_UNCATEGORIZED = 1

Uncategorized plane.

PlaneSemanticLabel PLANE_SEMANTIC_LABEL_FLOOR = 2

Plane represents a floor.

PlaneSemanticLabel PLANE_SEMANTIC_LABEL_WALL = 3

Plane represents a wall.

PlaneSemanticLabel PLANE_SEMANTIC_LABEL_CEILING = 4

Plane represents a ceiling.

PlaneSemanticLabel PLANE_SEMANTIC_LABEL_TABLE = 5

Plane represents the surface of a table.

---

## Method Descriptions

PlaneSemanticLabel get_plane_semantic_label(index: int) const 

Returns the plane semantic label for the parent entity at this index.
