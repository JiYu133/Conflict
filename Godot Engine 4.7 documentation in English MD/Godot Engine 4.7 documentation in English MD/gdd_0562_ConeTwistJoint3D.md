# ConeTwistJoint3D

Inherits: Joint3D < Node3D < Node < Object

A physics joint that connects two 3D physics bodies in a way that simulates a ball-and-socket joint.

## Description

A physics joint that connects two 3D physics bodies in a way that simulates a ball-and-socket joint. The twist axis is initiated as the X axis of the ConeTwistJoint3D. Once the physics bodies swing, the twist axis is calculated as the middle of the X axes of the joint in the local space of the two physics bodies. Useful for limbs like shoulders and hips, lamps hanging off a ceiling, etc.

## Properties

float | bias | 0.3
float | relaxation | 1.0
float | softness | 0.8
float | swing_span | 0.7853982
float | twist_span | 3.1415927

## Methods

float | get_param(param: Param) const
void | set_param(param: Param, value: float)

---

## Enumerations

enum Param
Param PARAM_SWING_SPAN = 0

Swing is rotation from side to side, around the axis perpendicular to the twist axis.

The swing span defines, how much rotation will not get corrected along the swing axis.

Could be defined as looseness in the ConeTwistJoint3D.

If below 0.05, this behavior is locked.

Param PARAM_TWIST_SPAN = 1

Twist is the rotation around the twist axis, this value defined how far the joint can twist.

Twist is locked if below 0.05.

Param PARAM_BIAS = 2

The speed with which the swing or twist will take place.

The higher, the faster.

Param PARAM_SOFTNESS = 3

The ease with which the joint starts to twist. If it's too low, it takes more force to start twisting the joint.

Param PARAM_RELAXATION = 4

Defines, how fast the swing- and twist-speed-difference on both sides gets synced.

Param PARAM_MAX = 5

Represents the size of the Param enum.

---

## Property Descriptions

float bias = 0.3 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

The speed with which the swing or twist will take place.

The higher, the faster.

---

float relaxation = 1.0 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

Defines, how fast the swing- and twist-speed-difference on both sides gets synced.

---

float softness = 0.8 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

The ease with which the joint starts to twist. If it's too low, it takes more force to start twisting the joint.

---

float swing_span = 0.7853982 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

Swing is rotation from side to side, around the axis perpendicular to the twist axis.

The swing span defines, how much rotation will not get corrected along the swing axis.

Could be defined as looseness in the ConeTwistJoint3D.

If below 0.05, this behavior is locked.

---

float twist_span = 3.1415927 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

Twist is the rotation around the twist axis, this value defined how far the joint can twist.

Twist is locked if below 0.05.

---

## Method Descriptions

float get_param(param: Param) const 

Returns the value of the specified parameter.

---

void set_param(param: Param, value: float) 

Sets the value of the specified parameter.
