# Generic6DOFJoint3D

Inherits: Joint3D < Node3D < Node < Object

A physics joint that allows for complex movement and rotation between two 3D physics bodies.

## Description

The Generic6DOFJoint3D (6 Degrees Of Freedom) joint allows for implementing custom types of joints by locking the rotation and translation of certain axes.

The first 3 DOF represent the linear motion of the physics bodies and the last 3 DOF represent the angular motion of the physics bodies. Each axis can be either locked, or limited.

## Properties

float | angular_limit_x/damping | 1.0
bool | angular_limit_x/enabled | true
float | angular_limit_x/erp | 0.5
float | angular_limit_x/force_limit | 0.0
float | angular_limit_x/lower_angle | 0.0
float | angular_limit_x/restitution | 0.0
float | angular_limit_x/softness | 0.5
float | angular_limit_x/upper_angle | 0.0
float | angular_limit_y/damping | 1.0
bool | angular_limit_y/enabled | true
float | angular_limit_y/erp | 0.5
float | angular_limit_y/force_limit | 0.0
float | angular_limit_y/lower_angle | 0.0
float | angular_limit_y/restitution | 0.0
float | angular_limit_y/softness | 0.5
float | angular_limit_y/upper_angle | 0.0
float | angular_limit_z/damping | 1.0
bool | angular_limit_z/enabled | true
float | angular_limit_z/erp | 0.5
float | angular_limit_z/force_limit | 0.0
float | angular_limit_z/lower_angle | 0.0
float | angular_limit_z/restitution | 0.0
float | angular_limit_z/softness | 0.5
float | angular_limit_z/upper_angle | 0.0
bool | angular_motor_x/enabled | false
float | angular_motor_x/force_limit | 300.0
float | angular_motor_x/target_velocity | 0.0
bool | angular_motor_y/enabled | false
float | angular_motor_y/force_limit | 300.0
float | angular_motor_y/target_velocity | 0.0
bool | angular_motor_z/enabled | false
float | angular_motor_z/force_limit | 300.0
float | angular_motor_z/target_velocity | 0.0
float | angular_spring_x/damping | 0.0
bool | angular_spring_x/enabled | false
float | angular_spring_x/equilibrium_point | 0.0
float | angular_spring_x/stiffness | 0.0
float | angular_spring_y/damping | 0.0
bool | angular_spring_y/enabled | false
float | angular_spring_y/equilibrium_point | 0.0
float | angular_spring_y/stiffness | 0.0
float | angular_spring_z/damping | 0.0
bool | angular_spring_z/enabled | false
float | angular_spring_z/equilibrium_point | 0.0
float | angular_spring_z/stiffness | 0.0
float | linear_limit_x/damping | 1.0
bool | linear_limit_x/enabled | true
float | linear_limit_x/lower_distance | 0.0
float | linear_limit_x/restitution | 0.5
float | linear_limit_x/softness | 0.7
float | linear_limit_x/upper_distance | 0.0
float | linear_limit_y/damping | 1.0
bool | linear_limit_y/enabled | true
float | linear_limit_y/lower_distance | 0.0
float | linear_limit_y/restitution | 0.5
float | linear_limit_y/softness | 0.7
float | linear_limit_y/upper_distance | 0.0
float | linear_limit_z/damping | 1.0
bool | linear_limit_z/enabled | true
float | linear_limit_z/lower_distance | 0.0
float | linear_limit_z/restitution | 0.5
float | linear_limit_z/softness | 0.7
float | linear_limit_z/upper_distance | 0.0
bool | linear_motor_x/enabled | false
float | linear_motor_x/force_limit | 0.0
float | linear_motor_x/target_velocity | 0.0
bool | linear_motor_y/enabled | false
float | linear_motor_y/force_limit | 0.0
float | linear_motor_y/target_velocity | 0.0
bool | linear_motor_z/enabled | false
float | linear_motor_z/force_limit | 0.0
float | linear_motor_z/target_velocity | 0.0
float | linear_spring_x/damping | 0.01
bool | linear_spring_x/enabled | false
float | linear_spring_x/equilibrium_point | 0.0
float | linear_spring_x/stiffness | 0.01
float | linear_spring_y/damping | 0.01
bool | linear_spring_y/enabled | false
float | linear_spring_y/equilibrium_point | 0.0
float | linear_spring_y/stiffness | 0.01
float | linear_spring_z/damping | 0.01
bool | linear_spring_z/enabled | false
float | linear_spring_z/equilibrium_point | 0.0
float | linear_spring_z/stiffness | 0.01

## Methods

bool | get_flag_x(flag: Flag) const
bool | get_flag_y(flag: Flag) const
bool | get_flag_z(flag: Flag) const
float | get_param_x(param: Param) const
float | get_param_y(param: Param) const
float | get_param_z(param: Param) const
void | set_flag_x(flag: Flag, value: bool)
void | set_flag_y(flag: Flag, value: bool)
void | set_flag_z(flag: Flag, value: bool)
void | set_param_x(param: Param, value: float)
void | set_param_y(param: Param, value: float)
void | set_param_z(param: Param, value: float)

---

## Enumerations

enum Param
Param PARAM_LINEAR_LOWER_LIMIT = 0

The minimum difference between the pivot points' axes.

Param PARAM_LINEAR_UPPER_LIMIT = 1

The maximum difference between the pivot points' axes.

Param PARAM_LINEAR_LIMIT_SOFTNESS = 2

A factor applied to the movement across the axes. The lower, the slower the movement.

Param PARAM_LINEAR_RESTITUTION = 3

The amount of restitution on the axes' movement. The lower, the more momentum gets lost.

Param PARAM_LINEAR_DAMPING = 4

The amount of damping that happens at the linear motion across the axes.

Param PARAM_LINEAR_MOTOR_TARGET_VELOCITY = 5

The velocity the linear motor will try to reach.

Param PARAM_LINEAR_MOTOR_FORCE_LIMIT = 6

The maximum force the linear motor will apply while trying to reach the velocity target.

Param PARAM_LINEAR_SPRING_STIFFNESS = 7

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

Param PARAM_LINEAR_SPRING_DAMPING = 8

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

Param PARAM_LINEAR_SPRING_EQUILIBRIUM_POINT = 9

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

Param PARAM_ANGULAR_LOWER_LIMIT = 10

The minimum rotation in negative direction to break loose and rotate around the axes.

Param PARAM_ANGULAR_UPPER_LIMIT = 11

The minimum rotation in positive direction to break loose and rotate around the axes.

Param PARAM_ANGULAR_LIMIT_SOFTNESS = 12

The speed of all rotations across the axes.

Param PARAM_ANGULAR_DAMPING = 13

The amount of rotational damping across the axes. The lower, the more damping occurs.

Param PARAM_ANGULAR_RESTITUTION = 14

The amount of rotational restitution across the axes. The lower, the more restitution occurs.

Param PARAM_ANGULAR_FORCE_LIMIT = 15

The maximum amount of force that can occur, when rotating around the axes.

Param PARAM_ANGULAR_ERP = 16

When rotating across the axes, this error tolerance factor defines how much the correction gets slowed down. The lower, the slower.

Param PARAM_ANGULAR_MOTOR_TARGET_VELOCITY = 17

Target speed for the motor at the axes.

Param PARAM_ANGULAR_MOTOR_FORCE_LIMIT = 18

Maximum acceleration for the motor at the axes.

Param PARAM_ANGULAR_SPRING_STIFFNESS = 19

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

Param PARAM_ANGULAR_SPRING_DAMPING = 20

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

Param PARAM_ANGULAR_SPRING_EQUILIBRIUM_POINT = 21

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

Param PARAM_MAX = 22

Represents the size of the Param enum.

---

enum Flag
Flag FLAG_ENABLE_LINEAR_LIMIT = 0

If enabled, linear motion is possible within the given limits.

Flag FLAG_ENABLE_ANGULAR_LIMIT = 1

If enabled, rotational motion is possible within the given limits.

Flag FLAG_ENABLE_LINEAR_SPRING = 3

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

Flag FLAG_ENABLE_ANGULAR_SPRING = 2

There is currently no description for this enum. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

Flag FLAG_ENABLE_MOTOR = 4

If enabled, there is a rotational motor across these axes.

Flag FLAG_ENABLE_LINEAR_MOTOR = 5

If enabled, there is a linear motor across these axes.

Flag FLAG_MAX = 6

Represents the size of the Flag enum.

---

## Property Descriptions

float angular_limit_x/damping = 1.0 

- void set_param_x(param: Param, value: float)
- float get_param_x(param: Param) const

The amount of rotational damping across the X axis.

The lower, the longer an impulse from one side takes to travel to the other side.

---

bool angular_limit_x/enabled = true 

- void set_flag_x(flag: Flag, value: bool)
- bool get_flag_x(flag: Flag) const

If true, rotation across the X axis is limited.

---

float angular_limit_x/erp = 0.5 

- void set_param_x(param: Param, value: float)
- float get_param_x(param: Param) const

When rotating across the X axis, this error tolerance factor defines how much the correction gets slowed down. The lower, the slower.

---

float angular_limit_x/force_limit = 0.0 

- void set_param_x(param: Param, value: float)
- float get_param_x(param: Param) const

The maximum amount of force that can occur, when rotating around the X axis.

---

float angular_limit_x/lower_angle = 0.0 

- void set_param_x(param: Param, value: float)
- float get_param_x(param: Param) const

The minimum rotation in negative direction to break loose and rotate around the X axis.

---

float angular_limit_x/restitution = 0.0 

- void set_param_x(param: Param, value: float)
- float get_param_x(param: Param) const

The amount of rotational restitution across the X axis. The lower, the more restitution occurs.

---

float angular_limit_x/softness = 0.5 

- void set_param_x(param: Param, value: float)
- float get_param_x(param: Param) const

The speed of all rotations across the X axis.

---

float angular_limit_x/upper_angle = 0.0 

- void set_param_x(param: Param, value: float)
- float get_param_x(param: Param) const

The minimum rotation in positive direction to break loose and rotate around the X axis.

---

float angular_limit_y/damping = 1.0 

- void set_param_y(param: Param, value: float)
- float get_param_y(param: Param) const

The amount of rotational damping across the Y axis. The lower, the more damping occurs.

---

bool angular_limit_y/enabled = true 

- void set_flag_y(flag: Flag, value: bool)
- bool get_flag_y(flag: Flag) const

If true, rotation across the Y axis is limited.

---

float angular_limit_y/erp = 0.5 

- void set_param_y(param: Param, value: float)
- float get_param_y(param: Param) const

When rotating across the Y axis, this error tolerance factor defines how much the correction gets slowed down. The lower, the slower.

---

float angular_limit_y/force_limit = 0.0 

- void set_param_y(param: Param, value: float)
- float get_param_y(param: Param) const

The maximum amount of force that can occur, when rotating around the Y axis.

---

float angular_limit_y/lower_angle = 0.0 

- void set_param_y(param: Param, value: float)
- float get_param_y(param: Param) const

The minimum rotation in negative direction to break loose and rotate around the Y axis.

---

float angular_limit_y/restitution = 0.0 

- void set_param_y(param: Param, value: float)
- float get_param_y(param: Param) const

The amount of rotational restitution across the Y axis. The lower, the more restitution occurs.

---

float angular_limit_y/softness = 0.5 

- void set_param_y(param: Param, value: float)
- float get_param_y(param: Param) const

The speed of all rotations across the Y axis.

---

float angular_limit_y/upper_angle = 0.0 

- void set_param_y(param: Param, value: float)
- float get_param_y(param: Param) const

The minimum rotation in positive direction to break loose and rotate around the Y axis.

---

float angular_limit_z/damping = 1.0 

- void set_param_z(param: Param, value: float)
- float get_param_z(param: Param) const

The amount of rotational damping across the Z axis. The lower, the more damping occurs.

---

bool angular_limit_z/enabled = true 

- void set_flag_z(flag: Flag, value: bool)
- bool get_flag_z(flag: Flag) const

If true, rotation across the Z axis is limited.

---

float angular_limit_z/erp = 0.5 

- void set_param_z(param: Param, value: float)
- float get_param_z(param: Param) const

When rotating across the Z axis, this error tolerance factor defines how much the correction gets slowed down. The lower, the slower.

---

float angular_limit_z/force_limit = 0.0 

- void set_param_z(param: Param, value: float)
- float get_param_z(param: Param) const

The maximum amount of force that can occur, when rotating around the Z axis.

---

float angular_limit_z/lower_angle = 0.0 

- void set_param_z(param: Param, value: float)
- float get_param_z(param: Param) const

The minimum rotation in negative direction to break loose and rotate around the Z axis.

---

float angular_limit_z/restitution = 0.0 

- void set_param_z(param: Param, value: float)
- float get_param_z(param: Param) const

The amount of rotational restitution across the Z axis. The lower, the more restitution occurs.

---

float angular_limit_z/softness = 0.5 

- void set_param_z(param: Param, value: float)
- float get_param_z(param: Param) const

The speed of all rotations across the Z axis.

---

float angular_limit_z/upper_angle = 0.0 

- void set_param_z(param: Param, value: float)
- float get_param_z(param: Param) const

The minimum rotation in positive direction to break loose and rotate around the Z axis.

---

bool angular_motor_x/enabled = false 

- void set_flag_x(flag: Flag, value: bool)
- bool get_flag_x(flag: Flag) const

If true, a rotating motor at the X axis is enabled.

---

float angular_motor_x/force_limit = 300.0 

- void set_param_x(param: Param, value: float)
- float get_param_x(param: Param) const

Maximum acceleration for the motor at the X axis.

---

float angular_motor_x/target_velocity = 0.0 

- void set_param_x(param: Param, value: float)
- float get_param_x(param: Param) const

Target speed for the motor at the X axis.

---

bool angular_motor_y/enabled = false 

- void set_flag_y(flag: Flag, value: bool)
- bool get_flag_y(flag: Flag) const

If true, a rotating motor at the Y axis is enabled.

---

float angular_motor_y/force_limit = 300.0 

- void set_param_y(param: Param, value: float)
- float get_param_y(param: Param) const

Maximum acceleration for the motor at the Y axis.

---

float angular_motor_y/target_velocity = 0.0 

- void set_param_y(param: Param, value: float)
- float get_param_y(param: Param) const

Target speed for the motor at the Y axis.

---

bool angular_motor_z/enabled = false 

- void set_flag_z(flag: Flag, value: bool)
- bool get_flag_z(flag: Flag) const

If true, a rotating motor at the Z axis is enabled.

---

float angular_motor_z/force_limit = 300.0 

- void set_param_z(param: Param, value: float)
- float get_param_z(param: Param) const

Maximum acceleration for the motor at the Z axis.

---

float angular_motor_z/target_velocity = 0.0 

- void set_param_z(param: Param, value: float)
- float get_param_z(param: Param) const

Target speed for the motor at the Z axis.

---

float angular_spring_x/damping = 0.0 

- void set_param_x(param: Param, value: float)
- float get_param_x(param: Param) const

There is currently no description for this property. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

bool angular_spring_x/enabled = false 

- void set_flag_x(flag: Flag, value: bool)
- bool get_flag_x(flag: Flag) const

There is currently no description for this property. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

float angular_spring_x/equilibrium_point = 0.0 

- void set_param_x(param: Param, value: float)
- float get_param_x(param: Param) const

There is currently no description for this property. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

float angular_spring_x/stiffness = 0.0 

- void set_param_x(param: Param, value: float)
- float get_param_x(param: Param) const

There is currently no description for this property. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

float angular_spring_y/damping = 0.0 

- void set_param_y(param: Param, value: float)
- float get_param_y(param: Param) const

There is currently no description for this property. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

bool angular_spring_y/enabled = false 

- void set_flag_y(flag: Flag, value: bool)
- bool get_flag_y(flag: Flag) const

There is currently no description for this property. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

float angular_spring_y/equilibrium_point = 0.0 

- void set_param_y(param: Param, value: float)
- float get_param_y(param: Param) const

There is currently no description for this property. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

float angular_spring_y/stiffness = 0.0 

- void set_param_y(param: Param, value: float)
- float get_param_y(param: Param) const

There is currently no description for this property. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

float angular_spring_z/damping = 0.0 

- void set_param_z(param: Param, value: float)
- float get_param_z(param: Param) const

There is currently no description for this property. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

bool angular_spring_z/enabled = false 

- void set_flag_z(flag: Flag, value: bool)
- bool get_flag_z(flag: Flag) const

There is currently no description for this property. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

float angular_spring_z/equilibrium_point = 0.0 

- void set_param_z(param: Param, value: float)
- float get_param_z(param: Param) const

There is currently no description for this property. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

float angular_spring_z/stiffness = 0.0 

- void set_param_z(param: Param, value: float)
- float get_param_z(param: Param) const

There is currently no description for this property. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

float linear_limit_x/damping = 1.0 

- void set_param_x(param: Param, value: float)
- float get_param_x(param: Param) const

The amount of damping that happens at the X motion.

---

bool linear_limit_x/enabled = true 

- void set_flag_x(flag: Flag, value: bool)
- bool get_flag_x(flag: Flag) const

If true, the linear motion across the X axis is limited.

---

float linear_limit_x/lower_distance = 0.0 

- void set_param_x(param: Param, value: float)
- float get_param_x(param: Param) const

The minimum difference between the pivot points' X axis.

---

float linear_limit_x/restitution = 0.5 

- void set_param_x(param: Param, value: float)
- float get_param_x(param: Param) const

The amount of restitution on the X axis movement. The lower, the more momentum gets lost.

---

float linear_limit_x/softness = 0.7 

- void set_param_x(param: Param, value: float)
- float get_param_x(param: Param) const

A factor applied to the movement across the X axis. The lower, the slower the movement.

---

float linear_limit_x/upper_distance = 0.0 

- void set_param_x(param: Param, value: float)
- float get_param_x(param: Param) const

The maximum difference between the pivot points' X axis.

---

float linear_limit_y/damping = 1.0 

- void set_param_y(param: Param, value: float)
- float get_param_y(param: Param) const

The amount of damping that happens at the Y motion.

---

bool linear_limit_y/enabled = true 

- void set_flag_y(flag: Flag, value: bool)
- bool get_flag_y(flag: Flag) const

If true, the linear motion across the Y axis is limited.

---

float linear_limit_y/lower_distance = 0.0 

- void set_param_y(param: Param, value: float)
- float get_param_y(param: Param) const

The minimum difference between the pivot points' Y axis.

---

float linear_limit_y/restitution = 0.5 

- void set_param_y(param: Param, value: float)
- float get_param_y(param: Param) const

The amount of restitution on the Y axis movement. The lower, the more momentum gets lost.

---

float linear_limit_y/softness = 0.7 

- void set_param_y(param: Param, value: float)
- float get_param_y(param: Param) const

A factor applied to the movement across the Y axis. The lower, the slower the movement.

---

float linear_limit_y/upper_distance = 0.0 

- void set_param_y(param: Param, value: float)
- float get_param_y(param: Param) const

The maximum difference between the pivot points' Y axis.

---

float linear_limit_z/damping = 1.0 

- void set_param_z(param: Param, value: float)
- float get_param_z(param: Param) const

The amount of damping that happens at the Z motion.

---

bool linear_limit_z/enabled = true 

- void set_flag_z(flag: Flag, value: bool)
- bool get_flag_z(flag: Flag) const

If true, the linear motion across the Z axis is limited.

---

float linear_limit_z/lower_distance = 0.0 

- void set_param_z(param: Param, value: float)
- float get_param_z(param: Param) const

The minimum difference between the pivot points' Z axis.

---

float linear_limit_z/restitution = 0.5 

- void set_param_z(param: Param, value: float)
- float get_param_z(param: Param) const

The amount of restitution on the Z axis movement. The lower, the more momentum gets lost.

---

float linear_limit_z/softness = 0.7 

- void set_param_z(param: Param, value: float)
- float get_param_z(param: Param) const

A factor applied to the movement across the Z axis. The lower, the slower the movement.

---

float linear_limit_z/upper_distance = 0.0 

- void set_param_z(param: Param, value: float)
- float get_param_z(param: Param) const

The maximum difference between the pivot points' Z axis.

---

bool linear_motor_x/enabled = false 

- void set_flag_x(flag: Flag, value: bool)
- bool get_flag_x(flag: Flag) const

If true, then there is a linear motor on the X axis. It will attempt to reach the target velocity while staying within the force limits.

---

float linear_motor_x/force_limit = 0.0 

- void set_param_x(param: Param, value: float)
- float get_param_x(param: Param) const

The maximum force the linear motor can apply on the X axis while trying to reach the target velocity.

---

float linear_motor_x/target_velocity = 0.0 

- void set_param_x(param: Param, value: float)
- float get_param_x(param: Param) const

The speed that the linear motor will attempt to reach on the X axis.

---

bool linear_motor_y/enabled = false 

- void set_flag_y(flag: Flag, value: bool)
- bool get_flag_y(flag: Flag) const

If true, then there is a linear motor on the Y axis. It will attempt to reach the target velocity while staying within the force limits.

---

float linear_motor_y/force_limit = 0.0 

- void set_param_y(param: Param, value: float)
- float get_param_y(param: Param) const

The maximum force the linear motor can apply on the Y axis while trying to reach the target velocity.

---

float linear_motor_y/target_velocity = 0.0 

- void set_param_y(param: Param, value: float)
- float get_param_y(param: Param) const

The speed that the linear motor will attempt to reach on the Y axis.

---

bool linear_motor_z/enabled = false 

- void set_flag_z(flag: Flag, value: bool)
- bool get_flag_z(flag: Flag) const

If true, then there is a linear motor on the Z axis. It will attempt to reach the target velocity while staying within the force limits.

---

float linear_motor_z/force_limit = 0.0 

- void set_param_z(param: Param, value: float)
- float get_param_z(param: Param) const

The maximum force the linear motor can apply on the Z axis while trying to reach the target velocity.

---

float linear_motor_z/target_velocity = 0.0 

- void set_param_z(param: Param, value: float)
- float get_param_z(param: Param) const

The speed that the linear motor will attempt to reach on the Z axis.

---

float linear_spring_x/damping = 0.01 

- void set_param_x(param: Param, value: float)
- float get_param_x(param: Param) const

There is currently no description for this property. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

bool linear_spring_x/enabled = false 

- void set_flag_x(flag: Flag, value: bool)
- bool get_flag_x(flag: Flag) const

There is currently no description for this property. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

float linear_spring_x/equilibrium_point = 0.0 

- void set_param_x(param: Param, value: float)
- float get_param_x(param: Param) const

There is currently no description for this property. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

float linear_spring_x/stiffness = 0.01 

- void set_param_x(param: Param, value: float)
- float get_param_x(param: Param) const

There is currently no description for this property. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

float linear_spring_y/damping = 0.01 

- void set_param_y(param: Param, value: float)
- float get_param_y(param: Param) const

There is currently no description for this property. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

bool linear_spring_y/enabled = false 

- void set_flag_y(flag: Flag, value: bool)
- bool get_flag_y(flag: Flag) const

There is currently no description for this property. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

float linear_spring_y/equilibrium_point = 0.0 

- void set_param_y(param: Param, value: float)
- float get_param_y(param: Param) const

There is currently no description for this property. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

float linear_spring_y/stiffness = 0.01 

- void set_param_y(param: Param, value: float)
- float get_param_y(param: Param) const

There is currently no description for this property. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

float linear_spring_z/damping = 0.01 

- void set_param_z(param: Param, value: float)
- float get_param_z(param: Param) const

There is currently no description for this property. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

bool linear_spring_z/enabled = false 

- void set_flag_z(flag: Flag, value: bool)
- bool get_flag_z(flag: Flag) const

There is currently no description for this property. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

float linear_spring_z/equilibrium_point = 0.0 

- void set_param_z(param: Param, value: float)
- float get_param_z(param: Param) const

There is currently no description for this property. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

float linear_spring_z/stiffness = 0.01 

- void set_param_z(param: Param, value: float)
- float get_param_z(param: Param) const

There is currently no description for this property. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

## Method Descriptions

bool get_flag_x(flag: Flag) const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

bool get_flag_y(flag: Flag) const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

bool get_flag_z(flag: Flag) const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

float get_param_x(param: Param) const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

float get_param_y(param: Param) const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

float get_param_z(param: Param) const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void set_flag_x(flag: Flag, value: bool) 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void set_flag_y(flag: Flag, value: bool) 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void set_flag_z(flag: Flag, value: bool) 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void set_param_x(param: Param, value: float) 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void set_param_y(param: Param, value: float) 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void set_param_z(param: Param, value: float) 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!
