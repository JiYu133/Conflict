# VisualShaderNodeParticleMultiplyByAxisAngle

Inherits: VisualShaderNode < Resource < RefCounted < Object

A visual shader helper node for multiplying position and rotation of particles.

## Description

This node helps to multiply a position input vector by rotation using specific axis. Intended to work with emitters.

## Properties

bool | degrees_mode | true

---

## Property Descriptions

bool degrees_mode = true 

- void set_degrees_mode(value: bool)
- bool is_degrees_mode()

If true, the angle will be interpreted in degrees instead of radians.
