# HingeJoint3D

Inherits: Joint3D < Node3D < Node < Object

A physics joint that restricts the rotation of a 3D physics body around an axis relative to another physics body.

## Description

A physics joint that restricts the rotation of a 3D physics body around an axis relative to another physics body. For example, Body A can be a StaticBody3D representing a door hinge that a RigidBody3D rotates around.

## Properties

float | angular_limit/bias | 0.3
bool | angular_limit/enable | false
float | angular_limit/lower | -1.5707964
float | angular_limit/relaxation | 1.0
float | angular_limit/softness | 0.9
float | angular_limit/upper | 1.5707964
bool | motor/enable | false
float | motor/max_impulse | 1.0
float | motor/target_velocity | 1.0
float | params/bias | 0.3

## Methods

bool | get_flag(flag: Flag) const
float | get_param(param: Param) const
void | set_flag(flag: Flag, enabled: bool)
void | set_param(param: Param, value: float)

---

## Enumerations

enum Param
Param PARAM_BIAS = 0

The speed with which the two bodies get pulled together when they move in different directions.

Param PARAM_LIMIT_UPPER = 1

The maximum rotation. Only active if angular_limit/enable is true.

Param PARAM_LIMIT_LOWER = 2

The minimum rotation. Only active if angular_limit/enable is true.

Param PARAM_LIMIT_BIAS = 3

The speed with which the rotation across the axis perpendicular to the hinge gets corrected.

Param PARAM_LIMIT_SOFTNESS = 4

Deprecated: This property is never used by the engine and is kept for compatibility purpose.

Param PARAM_LIMIT_RELAXATION = 5

The lower this value, the more the rotation gets slowed down.

Param PARAM_MOTOR_TARGET_VELOCITY = 6

Target speed for the motor.

Param PARAM_MOTOR_MAX_IMPULSE = 7

Maximum acceleration for the motor.

Param PARAM_MAX = 8

Represents the size of the Param enum.

---

enum Flag
Flag FLAG_USE_LIMIT = 0

If true, the hinges maximum and minimum rotation, defined by angular_limit/lower and angular_limit/upper has effects.

Flag FLAG_ENABLE_MOTOR = 1

When activated, a motor turns the hinge.

Flag FLAG_MAX = 2

Represents the size of the Flag enum.

---

## Property Descriptions

float angular_limit/bias = 0.3 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

The speed with which the rotation across the axis perpendicular to the hinge gets corrected.

---

bool angular_limit/enable = false 

- void set_flag(flag: Flag, enabled: bool)
- bool get_flag(flag: Flag) const

If true, the hinges maximum and minimum rotation, defined by angular_limit/lower and angular_limit/upper has effects.

---

float angular_limit/lower = -1.5707964 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

The minimum rotation. Only active if angular_limit/enable is true.

---

float angular_limit/relaxation = 1.0 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

The lower this value, the more the rotation gets slowed down.

---

float angular_limit/softness = 0.9 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

Deprecated: This property is never set by the engine and is kept for compatibility purposes.

---

float angular_limit/upper = 1.5707964 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

The maximum rotation. Only active if angular_limit/enable is true.

---

bool motor/enable = false 

- void set_flag(flag: Flag, enabled: bool)
- bool get_flag(flag: Flag) const

When activated, a motor turns the hinge.

---

float motor/max_impulse = 1.0 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

Maximum acceleration for the motor.

---

float motor/target_velocity = 1.0 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

Target speed for the motor.

---

float params/bias = 0.3 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

The speed with which the two bodies get pulled together when they move in different directions.

---

## Method Descriptions

bool get_flag(flag: Flag) const 

Returns the value of the specified flag.

---

float get_param(param: Param) const 

Returns the value of the specified parameter.

---

void set_flag(flag: Flag, enabled: bool) 

If true, enables the specified flag.

---

void set_param(param: Param, value: float) 

Sets the value of the specified parameter.
