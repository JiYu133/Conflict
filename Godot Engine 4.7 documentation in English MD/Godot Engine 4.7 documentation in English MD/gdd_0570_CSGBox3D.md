# CSGBox3D

Inherits: CSGPrimitive3D < CSGShape3D < GeometryInstance3D < VisualInstance3D < Node3D < Node < Object

A CSG Box shape.

## Description

This node allows you to create a box for use with the CSG system.

Note: CSG nodes are intended to be used for level prototyping. Creating CSG nodes has a significant CPU cost compared to creating a MeshInstance3D with a PrimitiveMesh. Moving a CSG node within another CSG node also has a significant CPU cost, so it should be avoided during gameplay.

## Tutorials

- Prototyping levels with CSG

## Properties

Material | material |
Vector3 | size | Vector3(1, 1, 1)

---

## Property Descriptions

Material material 

- void set_material(value: Material)
- Material get_material()

The material used to render the box.

---

Vector3 size = Vector3(1, 1, 1) 

- void set_size(value: Vector3)
- Vector3 get_size()

The box's width, height and depth.
