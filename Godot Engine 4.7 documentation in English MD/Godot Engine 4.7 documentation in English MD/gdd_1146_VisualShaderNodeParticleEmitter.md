# VisualShaderNodeParticleEmitter

Inherits: VisualShaderNode < Resource < RefCounted < Object

Inherited By: VisualShaderNodeParticleBoxEmitter, VisualShaderNodeParticleMeshEmitter, VisualShaderNodeParticleRingEmitter, VisualShaderNodeParticleSphereEmitter

A base class for particle emitters.

## Description

Particle emitter nodes can be used in "start" step of particle shaders and they define the starting position of the particles. Connect them to the Position output port.

## Properties

bool | mode_2d | false

---

## Property Descriptions

bool mode_2d = false 

- void set_mode_2d(value: bool)
- bool is_mode_2d()

If true, the result of this emitter is projected to 2D space. By default it is false and meant for use in 3D space.
