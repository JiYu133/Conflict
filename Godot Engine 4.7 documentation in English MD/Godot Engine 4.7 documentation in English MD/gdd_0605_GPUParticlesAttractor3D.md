# GPUParticlesAttractor3D

Inherits: VisualInstance3D < Node3D < Node < Object

Inherited By: GPUParticlesAttractorBox3D, GPUParticlesAttractorSphere3D, GPUParticlesAttractorVectorField3D

Abstract base class for 3D particle attractors.

## Description

Particle attractors can be used to attract particles towards the attractor's origin, or to push them away from the attractor's origin.

Particle attractors work in real-time and can be moved, rotated and scaled during gameplay. Unlike collision shapes, non-uniform scaling of attractors is also supported.

Attractors can be temporarily disabled by hiding them, or by setting their strength to 0.0.

Note: Particle attractors only affect GPUParticles3D, not CPUParticles3D.

## Properties

float | attenuation | 1.0
int | cull_mask | 4294967295
float | directionality | 0.0
float | strength | 1.0

---

## Property Descriptions

float attenuation = 1.0 

- void set_attenuation(value: float)
- float get_attenuation()

The particle attractor's attenuation. Higher values result in more gradual pushing of particles as they come closer to the attractor's origin. Zero or negative values will cause particles to be pushed very fast as soon as the touch the attractor's edges.

---

int cull_mask = 4294967295 

- void set_cull_mask(value: int)
- int get_cull_mask()

The particle rendering layers (VisualInstance3D.layers) that will be affected by the attractor. By default, all particles are affected by an attractor.

After configuring particle nodes accordingly, specific layers can be unchecked to prevent certain particles from being affected by attractors. For example, this can be used if you're using an attractor as part of a spell effect but don't want the attractor to affect unrelated weather particles at the same position.

Particle attraction can also be disabled on a per-process material basis by setting ParticleProcessMaterial.attractor_interaction_enabled on the GPUParticles3D node.

---

float directionality = 0.0 

- void set_directionality(value: float)
- float get_directionality()

Adjusts how directional the attractor is. At 0.0, the attractor is not directional at all: it will attract particles towards its center. At 1.0, the attractor is fully directional: particles will always be pushed towards local -Z (or +Z if strength is negative).

Note: If directionality is greater than 0.0, the direction in which particles are pushed can be changed by rotating the GPUParticlesAttractor3D node.

---

float strength = 1.0 

- void set_strength(value: float)
- float get_strength()

Adjusts the strength of the attractor. If strength is negative, particles will be pushed in the opposite direction. Particles will be pushed away from the attractor's origin if directionality is 0.0, or towards local +Z if directionality is greater than 0.0.
