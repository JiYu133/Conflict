# MultiMeshInstance3D

Inherits: GeometryInstance3D < VisualInstance3D < Node3D < Node < Object

Node that instances a MultiMesh.

## Description

MultiMeshInstance3D is a specialized node to instance GeometryInstance3Ds based on a MultiMesh resource.

This is useful to optimize the rendering of a high number of instances of a given mesh (for example trees in a forest or grass strands).

## Tutorials

- Using MultiMeshInstance
- Optimization using MultiMeshes
- Animating thousands of fish with MultiMeshInstance

## Properties

MultiMesh | multimesh

---

## Property Descriptions

MultiMesh multimesh 

- void set_multimesh(value: MultiMesh)
- MultiMesh get_multimesh()

The MultiMesh resource that will be used and shared among all instances of the MultiMeshInstance3D.
