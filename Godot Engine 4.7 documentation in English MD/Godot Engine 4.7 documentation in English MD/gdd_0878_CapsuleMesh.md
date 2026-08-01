# CapsuleMesh

Inherits: PrimitiveMesh < Mesh < Resource < RefCounted < Object

Class representing a capsule-shaped PrimitiveMesh.

## Description

Class representing a capsule-shaped PrimitiveMesh.

## Properties

float | height | 2.0
int | radial_segments | 64
float | radius | 0.5
int | rings | 8

---

## Property Descriptions

float height = 2.0 

- void set_height(value: float)
- float get_height()

Total height of the capsule mesh (including the hemispherical ends).

Note: The height of a capsule must be at least twice its radius. Otherwise, the capsule becomes a circle. If the height is less than twice the radius, the properties adjust to a valid value.

---

int radial_segments = 64 

- void set_radial_segments(value: int)
- int get_radial_segments()

Number of radial segments on the capsule mesh.

---

float radius = 0.5 

- void set_radius(value: float)
- float get_radius()

Radius of the capsule mesh.

Note: The radius of a capsule cannot be greater than half of its height. Otherwise, the capsule becomes a circle. If the radius is greater than half of the height, the properties adjust to a valid value.

---

int rings = 8 

- void set_rings(value: int)
- int get_rings()

Number of rings along the height of the capsule.
