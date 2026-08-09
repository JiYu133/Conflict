# Shape3D

Inherits: Resource < RefCounted < Object

Inherited By: BoxShape3D, CapsuleShape3D, ConcavePolygonShape3D, ConvexPolygonShape3D, CylinderShape3D, HeightMapShape3D, SeparationRayShape3D, SphereShape3D, WorldBoundaryShape3D

Abstract base class for 3D shapes used for physics collision.

## Description

Abstract base class for all 3D shapes, intended for use in physics.

Performance: Primitive shapes, especially SphereShape3D, are fast to check collisions against. ConvexPolygonShape3D and HeightMapShape3D are slower, and ConcavePolygonShape3D is the slowest.

## Tutorials

- Physics introduction

## Properties

float | custom_solver_bias | 0.0
float | margin | 0.04

## Methods

ArrayMesh | get_debug_mesh()

---

## Property Descriptions

float custom_solver_bias = 0.0 

- void set_custom_solver_bias(value: float)
- float get_custom_solver_bias()

The shape's custom solver bias. Defines how much bodies react to enforce contact separation when this shape is involved.

When set to 0, the default value from ProjectSettings.physics/3d/solver/default_contact_bias is used.

Note: custom_solver_bias is only effective when using GodotPhysics3D. It has no effect when using Jolt Physics.

---

float margin = 0.04 

- void set_margin(value: float)
- float get_margin()

The collision margin for the shape. This is not used in Godot Physics.

Collision margins allow collision detection to be more efficient by adding an extra shell around shapes. Collision algorithms are more expensive when objects overlap by more than their margin, so a higher value for margins is better for performance, at the cost of accuracy around edges as it makes them less sharp.

---

## Method Descriptions

ArrayMesh get_debug_mesh() 

Returns the ArrayMesh used to draw the debug collision for this Shape3D.
