# TubeTrailMesh

Inherits: PrimitiveMesh < Mesh < Resource < RefCounted < Object

Represents a straight tube-shaped PrimitiveMesh with variable width.

## Description

TubeTrailMesh represents a straight tube-shaped mesh with variable width. The tube is composed of a number of cylindrical sections, each with the same section_length and number of section_rings. A curve is sampled along the total length of the tube, meaning that the curve determines the radius of the tube along its length.

This primitive mesh is usually used for particle trails.

## Tutorials

- 3D Particle trails
- Particle systems (3D)

## Properties

bool | cap_bottom | true
bool | cap_top | true
Curve | curve |
int | radial_steps | 8
float | radius | 0.5
float | section_length | 0.2
int | section_rings | 3
int | sections | 5

---

## Property Descriptions

bool cap_bottom = true 

- void set_cap_bottom(value: bool)
- bool is_cap_bottom()

If true, generates a cap at the bottom of the tube. This can be set to false to speed up generation and rendering when the cap is never seen by the camera.

---

bool cap_top = true 

- void set_cap_top(value: bool)
- bool is_cap_top()

If true, generates a cap at the top of the tube. This can be set to false to speed up generation and rendering when the cap is never seen by the camera.

---

Curve curve 

- void set_curve(value: Curve)
- Curve get_curve()

Determines the radius of the tube along its length. The radius of a particular section ring is obtained by multiplying the baseline radius by the value of this curve at the given distance. For values smaller than 0, the faces will be inverted. Should be a unit Curve.

---

int radial_steps = 8 

- void set_radial_steps(value: int)
- int get_radial_steps()

The number of sides on the tube. For example, a value of 5 means the tube will be pentagonal. Higher values result in a more detailed tube at the cost of performance.

---

float radius = 0.5 

- void set_radius(value: float)
- float get_radius()

The baseline radius of the tube. The radius of a particular section ring is obtained by multiplying this radius by the value of the curve at the given distance.

---

float section_length = 0.2 

- void set_section_length(value: float)
- float get_section_length()

The length of a section of the tube.

---

int section_rings = 3 

- void set_section_rings(value: int)
- int get_section_rings()

The number of rings in a section. The curve is sampled on each ring to determine its radius. Higher values result in a more detailed tube at the cost of performance.

---

int sections = 5 

- void set_sections(value: int)
- int get_sections()

The total number of sections on the tube.
