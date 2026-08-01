# OccluderPolygon2D

Inherits: Resource < RefCounted < Object

Defines a 2D polygon for LightOccluder2D.

## Description

Editor facility that helps you draw a 2D polygon used as resource for LightOccluder2D.

## Properties

bool | closed | true
CullMode | cull_mode | 0
PackedVector2Array | polygon | PackedVector2Array()

---

## Enumerations

enum CullMode
CullMode CULL_DISABLED = 0

Culling is disabled. See cull_mode.

CullMode CULL_CLOCKWISE = 1

Culling is performed in the clockwise direction. See cull_mode.

CullMode CULL_COUNTER_CLOCKWISE = 2

Culling is performed in the counterclockwise direction. See cull_mode.

---

## Property Descriptions

bool closed = true 

- void set_closed(value: bool)
- bool is_closed()

If true, closes the polygon. A closed OccluderPolygon2D occludes the light coming from any direction. An opened OccluderPolygon2D occludes the light only at its outline's direction.

---

CullMode cull_mode = 0 

- void set_cull_mode(value: CullMode)
- CullMode get_cull_mode()

The culling mode to use.

---

PackedVector2Array polygon = PackedVector2Array() 

- void set_polygon(value: PackedVector2Array)
- PackedVector2Array get_polygon()

A Vector2 array with the index for polygon's vertices positions.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedVector2Array for more details.
