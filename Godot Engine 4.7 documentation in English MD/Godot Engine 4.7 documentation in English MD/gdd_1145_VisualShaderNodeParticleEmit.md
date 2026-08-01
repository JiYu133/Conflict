# VisualShaderNodeParticleEmit

Inherits: VisualShaderNode < Resource < RefCounted < Object

A visual shader node that forces to emit a particle from a sub-emitter.

## Description

This node internally calls emit_subparticle shader method. It will emit a particle from the configured sub-emitter and also allows to customize how its emitted. Requires a sub-emitter assigned to the particles node with this shader.

## Properties

EmitFlags | flags | 31

---

## Enumerations

enum EmitFlags
EmitFlags EMIT_FLAG_POSITION = 1

If enabled, the particle starts with the position defined by this node.

EmitFlags EMIT_FLAG_ROT_SCALE = 2

If enabled, the particle starts with the rotation and scale defined by this node.

EmitFlags EMIT_FLAG_VELOCITY = 4

If enabled,the particle starts with the velocity defined by this node.

EmitFlags EMIT_FLAG_COLOR = 8

If enabled, the particle starts with the color defined by this node.

EmitFlags EMIT_FLAG_CUSTOM = 16

If enabled, the particle starts with the CUSTOM data defined by this node.

---

## Property Descriptions

EmitFlags flags = 31 

- void set_flags(value: EmitFlags)
- EmitFlags get_flags()

Flags used to override the properties defined in the sub-emitter's process material.
