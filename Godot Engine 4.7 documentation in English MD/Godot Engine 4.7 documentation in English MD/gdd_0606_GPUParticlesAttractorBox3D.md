# GPUParticlesAttractorBox3D

Inherits: GPUParticlesAttractor3D < VisualInstance3D < Node3D < Node < Object

A box-shaped attractor that influences particles from GPUParticles3D nodes.

## Description

A box-shaped attractor that influences particles from GPUParticles3D nodes. Can be used to attract particles towards its origin, or to push them away from its origin.

Particle attractors work in real-time and can be moved, rotated and scaled during gameplay. Unlike collision shapes, non-uniform scaling of attractors is also supported.

Note: Particle attractors only affect GPUParticles3D, not CPUParticles3D.

## Properties

Vector3 | size | Vector3(2, 2, 2)

---

## Property Descriptions

Vector3 size = Vector3(2, 2, 2) 

- void set_size(value: Vector3)
- Vector3 get_size()

The attractor box's size in 3D units.
