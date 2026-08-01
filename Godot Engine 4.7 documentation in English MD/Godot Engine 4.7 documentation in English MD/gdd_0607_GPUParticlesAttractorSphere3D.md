# GPUParticlesAttractorSphere3D

Inherits: GPUParticlesAttractor3D < VisualInstance3D < Node3D < Node < Object

A spheroid-shaped attractor that influences particles from GPUParticles3D nodes.

## Description

A spheroid-shaped attractor that influences particles from GPUParticles3D nodes. Can be used to attract particles towards its origin, or to push them away from its origin.

Particle attractors work in real-time and can be moved, rotated and scaled during gameplay. Unlike collision shapes, non-uniform scaling of attractors is also supported.

Note: Particle attractors only affect GPUParticles3D, not CPUParticles3D.

## Properties

float | radius | 1.0

---

## Property Descriptions

float radius = 1.0 

- void set_radius(value: float)
- float get_radius()

The attractor sphere's radius in 3D units.

Note: Stretched ellipses can be obtained by using non-uniform scaling on the GPUParticlesAttractorSphere3D node.
