# SphereMesh

Inherits: PrimitiveMesh < Mesh < Resource < RefCounted < Object

Class representing a spherical PrimitiveMesh.

## Description

Class representing a spherical PrimitiveMesh.

## Properties

float | height | 1.0
bool | is_hemisphere | false
int | radial_segments | 64
float | radius | 0.5
int | rings | 32

---

## Property Descriptions

float height = 1.0 

- void set_height(value: float)
- float get_height()

Full height of the sphere.

---

bool is_hemisphere = false 

- void set_is_hemisphere(value: bool)
- bool get_is_hemisphere()

If true, a hemisphere is created rather than a full sphere.

Note: To get a regular hemisphere, the height and radius of the sphere must be equal.

---

int radial_segments = 64 

- void set_radial_segments(value: int)
- int get_radial_segments()

Number of radial segments on the sphere.

---

float radius = 0.5 

- void set_radius(value: float)
- float get_radius()

Radius of sphere.

---

int rings = 32 

- void set_rings(value: int)
- int get_rings()

Number of segments along the height of the sphere.
