# CSGSphere3D

Inherits: CSGPrimitive3D < CSGShape3D < GeometryInstance3D < VisualInstance3D < Node3D < Node < Object

A CSG Sphere shape.

## Description

This node allows you to create a sphere for use with the CSG system.

Note: CSG nodes are intended to be used for level prototyping. Creating CSG nodes has a significant CPU cost compared to creating a MeshInstance3D with a PrimitiveMesh. Moving a CSG node within another CSG node also has a significant CPU cost, so it should be avoided during gameplay.

## Tutorials

- Prototyping levels with CSG

## Properties

Material | material |
int | radial_segments | 12
float | radius | 0.5
int | rings | 6
bool | smooth_faces | true

---

## Property Descriptions

Material material 

- void set_material(value: Material)
- Material get_material()

The material used to render the sphere.

---

int radial_segments = 12 

- void set_radial_segments(value: int)
- int get_radial_segments()

Number of vertical slices for the sphere.

---

float radius = 0.5 

- void set_radius(value: float)
- float get_radius()

Radius of the sphere.

---

int rings = 6 

- void set_rings(value: int)
- int get_rings()

Number of horizontal slices for the sphere.

---

bool smooth_faces = true 

- void set_smooth_faces(value: bool)
- bool get_smooth_faces()

If true the normals of the sphere are set to give a smooth effect making the sphere seem rounded. If false the sphere will have a flat shaded look.
