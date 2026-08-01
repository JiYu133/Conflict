# QuadMesh

Inherits: PlaneMesh < PrimitiveMesh < Mesh < Resource < RefCounted < Object

Class representing a square mesh facing the camera.

## Description

Class representing a square PrimitiveMesh. This flat mesh does not have a thickness. By default, this mesh is aligned on the X and Y axes; this rotation is more suited for use with billboarded materials. A QuadMesh is equivalent to a PlaneMesh except its default PlaneMesh.orientation is PlaneMesh.FACE_Z.

## Tutorials

- GUI in 3D Viewport Demo [https://godotengine.org/asset-library/asset/2807]
- 2D in 3D Viewport Demo [https://godotengine.org/asset-library/asset/2803]

## Properties

Orientation | orientation | 2 (overrides PlaneMesh)
Vector2 | size | Vector2(1, 1) (overrides PlaneMesh)
