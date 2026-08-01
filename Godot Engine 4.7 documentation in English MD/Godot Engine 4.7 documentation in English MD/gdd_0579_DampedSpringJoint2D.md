# DampedSpringJoint2D

Inherits: Joint2D < Node2D < CanvasItem < Node < Object

A physics joint that connects two 2D physics bodies with a spring-like force.

## Description

A physics joint that connects two 2D physics bodies with a spring-like force. This behaves like a spring that always wants to stretch to a given length.

## Properties

float | damping | 1.0
float | length | 50.0
float | rest_length | 0.0
float | stiffness | 20.0

---

## Property Descriptions

float damping = 1.0 

- void set_damping(value: float)
- float get_damping()

The spring joint's damping ratio. A value between 0 and 1. When the two bodies move into different directions the system tries to align them to the spring axis again. A high damping value forces the attached bodies to align faster.

---

float length = 50.0 

- void set_length(value: float)
- float get_length()

The spring joint's maximum length. The two attached bodies cannot stretch it past this value.

---

float rest_length = 0.0 

- void set_rest_length(value: float)
- float get_rest_length()

When the bodies attached to the spring joint move they stretch or squash it. The joint always tries to resize towards this length.

---

float stiffness = 20.0 

- void set_stiffness(value: float)
- float get_stiffness()

The higher the value, the less the bodies attached to the joint will deform it. The joint applies an opposing force to the bodies, the product of the stiffness multiplied by the size difference from its resting length.
