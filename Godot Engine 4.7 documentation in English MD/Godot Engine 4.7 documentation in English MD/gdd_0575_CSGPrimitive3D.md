# CSGPrimitive3D

Inherits: CSGShape3D < GeometryInstance3D < VisualInstance3D < Node3D < Node < Object

Inherited By: CSGBox3D, CSGCylinder3D, CSGMesh3D, CSGPolygon3D, CSGSphere3D, CSGTorus3D

Base class for CSG primitives.

## Description

Parent class for various CSG primitives. It contains code and functionality that is common between them. It cannot be used directly. Instead use one of the various classes that inherit from it.

Note: CSG nodes are intended to be used for level prototyping. Creating CSG nodes has a significant CPU cost compared to creating a MeshInstance3D with a PrimitiveMesh. Moving a CSG node within another CSG node also has a significant CPU cost, so it should be avoided during gameplay.

## Tutorials

- Prototyping levels with CSG

## Properties

bool | flip_faces | false

---

## Property Descriptions

bool flip_faces = false 

- void set_flip_faces(value: bool)
- bool get_flip_faces()

If set, the order of the vertices in each triangle are reversed resulting in the backside of the mesh being drawn.
