# GrooveJoint2D

Inherits: Joint2D < Node2D < CanvasItem < Node < Object

A physics joint that restricts the movement of two 2D physics bodies to a fixed axis.

## Description

A physics joint that restricts the movement of two 2D physics bodies to a fixed axis. For example, a StaticBody2D representing a piston base can be attached to a RigidBody2D representing the piston head, moving up and down.

## Properties

float | initial_offset | 25.0
float | length | 50.0

---

## Property Descriptions

float initial_offset = 25.0 

- void set_initial_offset(value: float)
- float get_initial_offset()

The body B's initial anchor position defined by the joint's origin and a local offset initial_offset along the joint's Y axis (along the groove).

---

float length = 50.0 

- void set_length(value: float)
- float get_length()

The groove's length. The groove is from the joint's origin towards length along the joint's local Y axis.
