# PinJoint2D

Inherits: Joint2D < Node2D < CanvasItem < Node < Object

A physics joint that attaches two 2D physics bodies at a single point, allowing them to freely rotate.

## Description

A physics joint that attaches two 2D physics bodies at a single point, allowing them to freely rotate. For example, a RigidBody2D can be attached to a StaticBody2D to create a pendulum or a seesaw.

## Properties

bool | angular_limit_enabled | false
float | angular_limit_lower | 0.0
float | angular_limit_upper | 0.0
bool | motor_enabled | false
float | motor_target_velocity | 0.0
float | softness | 0.0

---

## Property Descriptions

bool angular_limit_enabled = false 

- void set_angular_limit_enabled(value: bool)
- bool is_angular_limit_enabled()

If true, the pin maximum and minimum rotation, defined by angular_limit_lower and angular_limit_upper are applied.

---

float angular_limit_lower = 0.0 

- void set_angular_limit_lower(value: float)
- float get_angular_limit_lower()

The minimum rotation. Only active if angular_limit_enabled is true.

---

float angular_limit_upper = 0.0 

- void set_angular_limit_upper(value: float)
- float get_angular_limit_upper()

The maximum rotation. Only active if angular_limit_enabled is true.

---

bool motor_enabled = false 

- void set_motor_enabled(value: bool)
- bool is_motor_enabled()

When activated, a motor turns the pin.

---

float motor_target_velocity = 0.0 

- void set_motor_target_velocity(value: float)
- float get_motor_target_velocity()

Target speed for the motor. In radians per second.

---

float softness = 0.0 

- void set_softness(value: float)
- float get_softness()

The higher this value, the more the bond to the pinned partner can flex.
