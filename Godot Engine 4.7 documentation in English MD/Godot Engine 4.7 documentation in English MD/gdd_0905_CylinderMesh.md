# CylinderMesh

Inherits: PrimitiveMesh < Mesh < Resource < RefCounted < Object

Class representing a cylindrical PrimitiveMesh.

## Description

Class representing a cylindrical PrimitiveMesh. This class can be used to create cones by setting either the top_radius or bottom_radius properties to 0.0.

## Properties

float | bottom_radius | 0.5
bool | cap_bottom | true
bool | cap_top | true
float | height | 2.0
int | radial_segments | 64
int | rings | 4
float | top_radius | 0.5

---

## Property Descriptions

float bottom_radius = 0.5 

- void set_bottom_radius(value: float)
- float get_bottom_radius()

Bottom radius of the cylinder. If set to 0.0, the bottom faces will not be generated, resulting in a conic shape. See also cap_bottom.

---

bool cap_bottom = true 

- void set_cap_bottom(value: bool)
- bool is_cap_bottom()

If true, generates a cap at the bottom of the cylinder. This can be set to false to speed up generation and rendering when the cap is never seen by the camera. See also bottom_radius.

Note: If bottom_radius is 0.0, cap generation is always skipped even if cap_bottom is true.

---

bool cap_top = true 

- void set_cap_top(value: bool)
- bool is_cap_top()

If true, generates a cap at the top of the cylinder. This can be set to false to speed up generation and rendering when the cap is never seen by the camera. See also top_radius.

Note: If top_radius is 0.0, cap generation is always skipped even if cap_top is true.

---

float height = 2.0 

- void set_height(value: float)
- float get_height()

Full height of the cylinder.

---

int radial_segments = 64 

- void set_radial_segments(value: int)
- int get_radial_segments()

Number of radial segments on the cylinder. Higher values result in a more detailed cylinder/cone at the cost of performance.

---

int rings = 4 

- void set_rings(value: int)
- int get_rings()

Number of edge rings along the height of the cylinder. Changing rings does not have any visual impact unless a shader or procedural mesh tool is used to alter the vertex data. Higher values result in more subdivisions, which can be used to create smoother-looking effects with shaders or procedural mesh tools (at the cost of performance). When not altering the vertex data using a shader or procedural mesh tool, rings should be kept to its default value.

---

float top_radius = 0.5 

- void set_top_radius(value: float)
- float get_top_radius()

Top radius of the cylinder. If set to 0.0, the top faces will not be generated, resulting in a conic shape. See also cap_top.
