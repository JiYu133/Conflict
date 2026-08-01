# VisualShaderNodeParticleAccelerator

Inherits: VisualShaderNode < Resource < RefCounted < Object

A visual shader node that accelerates particles.

## Description

Particle accelerator can be used in "process" step of particle shader. It will accelerate the particles. Connect it to the Velocity output port.

## Properties

Mode | mode | 0

---

## Enumerations

enum Mode
Mode MODE_LINEAR = 0

The particles will be accelerated based on their velocity.

Mode MODE_RADIAL = 1

The particles will be accelerated towards or away from the center.

Mode MODE_TANGENTIAL = 2

The particles will be accelerated tangentially to the radius vector from center to their position.

Mode MODE_MAX = 3

Represents the size of the Mode enum.

---

## Property Descriptions

Mode mode = 0 

- void set_mode(value: Mode)
- Mode get_mode()

Defines in what manner the particles will be accelerated.
