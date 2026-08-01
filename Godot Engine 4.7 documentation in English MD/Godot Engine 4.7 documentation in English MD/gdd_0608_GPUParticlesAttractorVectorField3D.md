# GPUParticlesAttractorVectorField3D

Inherits: GPUParticlesAttractor3D < VisualInstance3D < Node3D < Node < Object

A box-shaped attractor with varying directions and strengths defined in it that influences particles from GPUParticles3D nodes.

## Description

A box-shaped attractor with varying directions and strengths defined in it that influences particles from GPUParticles3D nodes.

Unlike GPUParticlesAttractorBox3D, GPUParticlesAttractorVectorField3D uses a texture to affect attraction strength within the box. This can be used to create complex attraction scenarios where particles travel in different directions depending on their location. This can be useful for weather effects such as sandstorms.

Particle attractors work in real-time and can be moved, rotated and scaled during gameplay. Unlike collision shapes, non-uniform scaling of attractors is also supported.

Note: Particle attractors only affect GPUParticles3D, not CPUParticles3D.

## Properties

Vector3 | size | Vector3(2, 2, 2)
Texture3D | texture |

---

## Property Descriptions

Vector3 size = Vector3(2, 2, 2) 

- void set_size(value: Vector3)
- Vector3 get_size()

The size of the vector field box in 3D units.

---

Texture3D texture 

- void set_texture(value: Texture3D)
- Texture3D get_texture()

The 3D texture to be used. Values are linearly interpolated between the texture's pixels.

Note: To get better performance, the 3D texture's resolution should reflect the size of the attractor. Since particle attraction is usually low-frequency data, the texture can be kept at a low resolution such as 64×64×64.
