# CSGMesh3D

Inherits: CSGPrimitive3D < CSGShape3D < GeometryInstance3D < VisualInstance3D < Node3D < Node < Object

A CSG Mesh shape that uses a mesh resource.

## Description

This CSG node allows you to use any mesh resource as a CSG shape, provided it is manifold. A manifold shape is closed, does not self-intersect, does not contain internal faces and has no edges that connect to more than two faces. See also CSGPolygon3D for drawing 2D extruded polygons to be used as CSG nodes.

Note: CSG nodes are intended to be used for level prototyping. Creating CSG nodes has a significant CPU cost compared to creating a MeshInstance3D with a PrimitiveMesh. Moving a CSG node within another CSG node also has a significant CPU cost, so it should be avoided during gameplay.

## Tutorials

- Prototyping levels with CSG

## Properties

Material | material
Mesh | mesh

---

## Property Descriptions

Material material 

- void set_material(value: Material)
- Material get_material()

The Material used in drawing the CSG shape.

---

Mesh mesh 

- void set_mesh(value: Mesh)
- Mesh get_mesh()

The Mesh resource to use as a CSG shape.

Note: Some Mesh types such as PlaneMesh, PointMesh, QuadMesh, and RibbonTrailMesh are excluded from the type hint for this property, as these primitives are non-manifold and thus not compatible with the CSG algorithm.

Note: When using an ArrayMesh, all vertex attributes except Mesh.ARRAY_VERTEX, Mesh.ARRAY_NORMAL and Mesh.ARRAY_TEX_UV are left unused. Only Mesh.ARRAY_VERTEX and Mesh.ARRAY_TEX_UV will be passed to the GPU.

Mesh.ARRAY_NORMAL is only used to determine which faces require the use of flat shading. By default, CSGMesh will ignore the mesh's vertex normals, recalculate them for each vertex and use a smooth shader. If a flat shader is required for a face, ensure that all vertex normals of the face are approximately equal.
