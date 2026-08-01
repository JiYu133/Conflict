# SliderJoint3D

Inherits: Joint3D < Node3D < Node < Object

A physics joint that restricts the movement of a 3D physics body along an axis relative to another physics body.

## Description

A physics joint that restricts the movement of a 3D physics body along an axis relative to another physics body. For example, Body A could be a StaticBody3D representing a piston base, while Body B could be a RigidBody3D representing the piston head, moving up and down.

## Properties

float | angular_limit/damping | 0.0
float | angular_limit/lower_angle | 0.0
float | angular_limit/restitution | 0.7
float | angular_limit/softness | 1.0
float | angular_limit/upper_angle | 0.0
float | angular_motion/damping | 1.0
float | angular_motion/restitution | 0.7
float | angular_motion/softness | 1.0
float | angular_ortho/damping | 1.0
float | angular_ortho/restitution | 0.7
float | angular_ortho/softness | 1.0
float | linear_limit/damping | 1.0
float | linear_limit/lower_distance | -1.0
float | linear_limit/restitution | 0.7
float | linear_limit/softness | 1.0
float | linear_limit/upper_distance | 1.0
float | linear_motion/damping | 0.0
float | linear_motion/restitution | 0.7
float | linear_motion/softness | 1.0
float | linear_ortho/damping | 1.0
float | linear_ortho/restitution | 0.7
float | linear_ortho/softness | 1.0

## Methods

float | get_param(param: Param) const
void | set_param(param: Param, value: float)

---

## Enumerations

enum Param
Param PARAM_LINEAR_LIMIT_UPPER = 0

Constant for accessing linear_limit/upper_distance. The maximum difference between the pivot points on their X axis before damping happens.

Param PARAM_LINEAR_LIMIT_LOWER = 1

Constant for accessing linear_limit/lower_distance. The minimum difference between the pivot points on their X axis before damping happens.

Param PARAM_LINEAR_LIMIT_SOFTNESS = 2

Constant for accessing linear_limit/softness. A factor applied to the movement across the slider axis once the limits get surpassed. The lower, the slower the movement.

Param PARAM_LINEAR_LIMIT_RESTITUTION = 3

Constant for accessing linear_limit/restitution. The amount of restitution once the limits are surpassed. The lower, the more velocity-energy gets lost.

Param PARAM_LINEAR_LIMIT_DAMPING = 4

Constant for accessing linear_limit/damping. The amount of damping once the slider limits are surpassed.

Param PARAM_LINEAR_MOTION_SOFTNESS = 5

Constant for accessing linear_motion/softness. A factor applied to the movement across the slider axis as long as the slider is in the limits. The lower, the slower the movement.

Param PARAM_LINEAR_MOTION_RESTITUTION = 6

Constant for accessing linear_motion/restitution. The amount of restitution inside the slider limits.

Param PARAM_LINEAR_MOTION_DAMPING = 7

Constant for accessing linear_motion/damping. The amount of damping inside the slider limits.

Param PARAM_LINEAR_ORTHOGONAL_SOFTNESS = 8

Constant for accessing linear_ortho/softness. A factor applied to the movement across axes orthogonal to the slider.

Param PARAM_LINEAR_ORTHOGONAL_RESTITUTION = 9

Constant for accessing linear_motion/restitution. The amount of restitution when movement is across axes orthogonal to the slider.

Param PARAM_LINEAR_ORTHOGONAL_DAMPING = 10

Constant for accessing linear_motion/damping. The amount of damping when movement is across axes orthogonal to the slider.

Param PARAM_ANGULAR_LIMIT_UPPER = 11

Constant for accessing angular_limit/upper_angle. The upper limit of rotation in the slider.

Param PARAM_ANGULAR_LIMIT_LOWER = 12

Constant for accessing angular_limit/lower_angle. The lower limit of rotation in the slider.

Param PARAM_ANGULAR_LIMIT_SOFTNESS = 13

Constant for accessing angular_limit/softness. A factor applied to the all rotation once the limit is surpassed.

Param PARAM_ANGULAR_LIMIT_RESTITUTION = 14

Constant for accessing angular_limit/restitution. The amount of restitution of the rotation when the limit is surpassed.

Param PARAM_ANGULAR_LIMIT_DAMPING = 15

Constant for accessing angular_limit/damping. The amount of damping of the rotation when the limit is surpassed.

Param PARAM_ANGULAR_MOTION_SOFTNESS = 16

Constant for accessing angular_motion/softness. A factor applied to the all rotation in the limits.

Param PARAM_ANGULAR_MOTION_RESTITUTION = 17

Constant for accessing angular_motion/restitution. The amount of restitution of the rotation in the limits.

Param PARAM_ANGULAR_MOTION_DAMPING = 18

Constant for accessing angular_motion/damping. The amount of damping of the rotation in the limits.

Param PARAM_ANGULAR_ORTHOGONAL_SOFTNESS = 19

Constant for accessing angular_ortho/softness. A factor applied to the all rotation across axes orthogonal to the slider.

Param PARAM_ANGULAR_ORTHOGONAL_RESTITUTION = 20

Constant for accessing angular_ortho/restitution. The amount of restitution of the rotation across axes orthogonal to the slider.

Param PARAM_ANGULAR_ORTHOGONAL_DAMPING = 21

Constant for accessing angular_ortho/damping. The amount of damping of the rotation across axes orthogonal to the slider.

Param PARAM_MAX = 22

Represents the size of the Param enum.

---

## Property Descriptions

float angular_limit/damping = 0.0 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

The amount of damping of the rotation when the limit is surpassed.

A lower damping value allows a rotation initiated by body A to travel to body B slower.

---

float angular_limit/lower_angle = 0.0 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

The lower limit of rotation in the slider.

---

float angular_limit/restitution = 0.7 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

The amount of restitution of the rotation when the limit is surpassed.

Does not affect damping.

---

float angular_limit/softness = 1.0 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

A factor applied to the all rotation once the limit is surpassed.

Makes all rotation slower when between 0 and 1.

---

float angular_limit/upper_angle = 0.0 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

The upper limit of rotation in the slider.

---

float angular_motion/damping = 1.0 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

The amount of damping of the rotation in the limits.

---

float angular_motion/restitution = 0.7 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

The amount of restitution of the rotation in the limits.

---

float angular_motion/softness = 1.0 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

A factor applied to the all rotation in the limits.

---

float angular_ortho/damping = 1.0 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

The amount of damping of the rotation across axes orthogonal to the slider.

---

float angular_ortho/restitution = 0.7 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

The amount of restitution of the rotation across axes orthogonal to the slider.

---

float angular_ortho/softness = 1.0 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

A factor applied to the all rotation across axes orthogonal to the slider.

---

float linear_limit/damping = 1.0 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

The amount of damping that happens once the limit defined by linear_limit/lower_distance and linear_limit/upper_distance is surpassed.

---

float linear_limit/lower_distance = -1.0 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

The minimum difference between the pivot points on their X axis before damping happens.

---

float linear_limit/restitution = 0.7 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

The amount of restitution once the limits are surpassed. The lower, the more velocity-energy gets lost.

---

float linear_limit/softness = 1.0 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

A factor applied to the movement across the slider axis once the limits get surpassed. The lower, the slower the movement.

---

float linear_limit/upper_distance = 1.0 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

The maximum difference between the pivot points on their X axis before damping happens.

---

float linear_motion/damping = 0.0 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

The amount of damping inside the slider limits.

---

float linear_motion/restitution = 0.7 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

The amount of restitution inside the slider limits.

---

float linear_motion/softness = 1.0 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

A factor applied to the movement across the slider axis as long as the slider is in the limits. The lower, the slower the movement.

---

float linear_ortho/damping = 1.0 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

The amount of damping when movement is across axes orthogonal to the slider.

---

float linear_ortho/restitution = 0.7 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

The amount of restitution when movement is across axes orthogonal to the slider.

---

float linear_ortho/softness = 1.0 

- void set_param(param: Param, value: float)
- float get_param(param: Param) const

A factor applied to the movement across axes orthogonal to the slider.

---

## Method Descriptions

float get_param(param: Param) const 

Returns the value of the given parameter.

---

void set_param(param: Param, value: float) 

Assigns value to the given parameter.
