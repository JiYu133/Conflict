# CSGCylinder3D

Inherits: CSGPrimitive3D < CSGShape3D < GeometryInstance3D < VisualInstance3D < Node3D < Node < Object

A CSG Cylinder shape.

## Description

This node allows you to create a cylinder (or cone) for use with the CSG system.

Note: CSG nodes are intended to be used for level prototyping. Creating CSG nodes has a significant CPU cost compared to creating a MeshInstance3D with a PrimitiveMesh. Moving a CSG node within another CSG node also has a significant CPU cost, so it should be avoided during gameplay.

## Tutorials

- Prototyping levels with CSG

## Properties

bool | cone | false
float | height | 2.0
Material | material |
float | radius | 0.5
int | sides | 8
bool | smooth_faces | true

---

## Property Descriptions

bool cone = false 

- void set_cone(value: bool)
- bool is_cone()

If true a cone is created, the radius will only apply to one side.

---

float height = 2.0 

- void set_height(value: float)
- float get_height()

The height of the cylinder.

---

Material material 

- void set_material(value: Material)
- Material get_material()

The material used to render the cylinder.

---

float radius = 0.5 

- void set_radius(value: float)
- float get_radius()

The radius of the cylinder.

---

int sides = 8 

- void set_sides(value: int)
- int get_sides()

The number of sides of the cylinder, the higher this number the more detail there will be in the cylinder.

---

bool smooth_faces = true 

- void set_smooth_faces(value: bool)
- bool get_smooth_faces()

If true the normals of the cylinder are set to give a smooth effect making the cylinder seem rounded. If false the cylinder will have a flat shaded look.
