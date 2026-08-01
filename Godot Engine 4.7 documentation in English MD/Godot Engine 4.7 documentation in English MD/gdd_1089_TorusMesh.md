# TorusMesh

Inherits: PrimitiveMesh < Mesh < Resource < RefCounted < Object

Class representing a torus PrimitiveMesh.

## Description

Class representing a torus PrimitiveMesh.

## Properties

float | inner_radius | 0.5
float | outer_radius | 1.0
int | ring_segments | 32
int | rings | 64

---

## Property Descriptions

float inner_radius = 0.5 

- void set_inner_radius(value: float)
- float get_inner_radius()

The inner radius of the torus.

---

float outer_radius = 1.0 

- void set_outer_radius(value: float)
- float get_outer_radius()

The outer radius of the torus.

---

int ring_segments = 32 

- void set_ring_segments(value: int)
- int get_ring_segments()

The number of edges each ring of the torus is constructed of.

---

int rings = 64 

- void set_rings(value: int)
- int get_rings()

The number of slices the torus is constructed of.
