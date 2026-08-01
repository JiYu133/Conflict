# OpenXRSpatialComponentPlaneAlignmentList

Experimental: This class may be changed or removed in future versions.

Inherits: OpenXRSpatialComponentData < RefCounted < Object

Object for storing the queries plane alignment result data.

## Description

Object for storing the queries plane alignment result data when calling OpenXRSpatialEntityExtension.query_snapshot().

## Methods

PlaneAlignment | get_plane_alignment(index: int) const

---

## Enumerations

enum PlaneAlignment
PlaneAlignment PLANE_ALIGNMENT_HORIZONTAL_UPWARD = 0

Plane is facing upward.

PlaneAlignment PLANE_ALIGNMENT_HORIZONTAL_DOWNWARD = 1

Plane is facing downwards.

PlaneAlignment PLANE_ALIGNMENT_VERTICAL = 2

Plane is vertically aligned.

PlaneAlignment PLANE_ALIGNMENT_ARBITRARY = 3

Plane has an arbitrary alignment.

---

## Method Descriptions

PlaneAlignment get_plane_alignment(index: int) const 

Returns the plane alignment for the parent entity at this index.
