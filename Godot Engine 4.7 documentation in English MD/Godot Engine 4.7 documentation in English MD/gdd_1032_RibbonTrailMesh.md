# RibbonTrailMesh

Inherits: PrimitiveMesh < Mesh < Resource < RefCounted < Object

Represents a straight ribbon-shaped PrimitiveMesh with variable width.

## Description

RibbonTrailMesh represents a straight ribbon-shaped mesh with variable width. The ribbon is composed of a number of flat or cross-shaped sections, each with the same section_length and number of section_segments. A curve is sampled along the total length of the ribbon, meaning that the curve determines the size of the ribbon along its length.

This primitive mesh is usually used for particle trails.

## Tutorials

- 3D Particle trails
- Particle systems (3D)

## Properties

Curve | curve |
float | section_length | 0.2
int | section_segments | 3
int | sections | 5
Shape | shape | 1
float | size | 1.0

---

## Enumerations

enum Shape
Shape SHAPE_FLAT = 0

Gives the mesh a single flat face.

Shape SHAPE_CROSS = 1

Gives the mesh two perpendicular flat faces, making a cross shape.

---

## Property Descriptions

Curve curve 

- void set_curve(value: Curve)
- Curve get_curve()

Determines the size of the ribbon along its length. The size of a particular section segment is obtained by multiplying the baseline size by the value of this curve at the given distance. For values smaller than 0, the faces will be inverted. Should be a unit Curve.

---

float section_length = 0.2 

- void set_section_length(value: float)
- float get_section_length()

The length of a section of the ribbon.

---

int section_segments = 3 

- void set_section_segments(value: int)
- int get_section_segments()

The number of segments in a section. The curve is sampled on each segment to determine its size. Higher values result in a more detailed ribbon at the cost of performance.

---

int sections = 5 

- void set_sections(value: int)
- int get_sections()

The total number of sections on the ribbon.

---

Shape shape = 1 

- void set_shape(value: Shape)
- Shape get_shape()

Determines the shape of the ribbon.

---

float size = 1.0 

- void set_size(value: float)
- float get_size()

The baseline size of the ribbon. The size of a particular section segment is obtained by multiplying this size by the value of the curve at the given distance.
