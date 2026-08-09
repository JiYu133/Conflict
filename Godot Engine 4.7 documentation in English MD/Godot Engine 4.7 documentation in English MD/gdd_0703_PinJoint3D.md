# PinJoint3D

Inherits: Joint3D < Node3D < Node < Object

A physics joint that attaches two 3D physics bodies at a single point, allowing them to freely rotate.

## Description

A physics joint that attaches two 3D physics bodies at a single point, allowing them to freely rotate. For example, a RigidBody3D can be attached to a StaticBody3D to create a pendulum or a seesaw.

## Properties

float | params/bias | 0.3
float | params/damping | 1.0
float | params/impulse_clamp | 0.0

## Methods

float | get_param(param: Param) const
void | set_param(param: Param, value: float)

---

## Enumerations

enum Param
Param PARAM_BIAS = 0

The force with which the pinned objects stay in positional relation to each other. The higher, the stronger.

Param PARAM_DAMPING = 1

The force with which the pinned objects stay in velocity relation to each other. The higher, the stronger.

Param PARAM_IMPULSE_CLAMP = 2

If above 0, this value is the maximum value for an impulse that this Joint3D produces.

---

## Property Descriptions

float params/bias = 0.3 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

The force with which the pinned objects stay in positional relation to each other. The higher, the stronger.

---

float params/damping = 1.0 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

The force with which the pinned objects stay in velocity relation to each other. The higher, the stronger.

---

float params/impulse_clamp = 0.0 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

If above 0, this value is the maximum value for an impulse that this Joint3D produces.

---

## Method Descriptions

float get_param(param: Param) const 

Returns the value of the specified parameter.

---

void set_param(param: Param, value: float) 

Sets the value of the specified parameter.
