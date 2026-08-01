# GPUParticlesCollisionBox3D

Inherits: GPUParticlesCollision3D < VisualInstance3D < Node3D < Node < Object

A box-shaped 3D particle collision shape affecting GPUParticles3D nodes.

## Description

A box-shaped 3D particle collision shape affecting GPUParticles3D nodes.

Particle collision shapes work in real-time and can be moved, rotated and scaled during gameplay. Unlike attractors, non-uniform scaling of collision shapes is not supported.

Note: ParticleProcessMaterial.collision_mode must be ParticleProcessMaterial.COLLISION_RIGID or ParticleProcessMaterial.COLLISION_HIDE_ON_CONTACT on the GPUParticles3D's process material for collision to work.

Note: Particle collision only affects GPUParticles3D, not CPUParticles3D.

## Properties

Vector3 | size | Vector3(2, 2, 2)

---

## Property Descriptions

Vector3 size = Vector3(2, 2, 2) 

- void set_size(value: Vector3)
- Vector3 get_size()

The collision box's size in 3D units.
