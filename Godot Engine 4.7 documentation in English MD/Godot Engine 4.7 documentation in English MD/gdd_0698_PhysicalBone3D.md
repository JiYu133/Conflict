# PhysicalBone3D

Inherits: PhysicsBody3D < CollisionObject3D < Node3D < Node < Object

A physics body used to make bones in a Skeleton3D react to physics.

## Description

The PhysicalBone3D node is a physics body that can be used to make bones in a Skeleton3D react to physics.

Note: In order to detect physical bones with raycasts, the SkeletonModifier3D.active property of the parent PhysicalBoneSimulator3D must be true and the Skeleton3D's bone must be assigned to PhysicalBone3D correctly; it means that get_bone_id() should return a valid id (>= 0).

## Tutorials

- Ragdoll System

## Properties

float | angular_damp | 0.0
DampMode | angular_damp_mode | 0
Vector3 | angular_velocity | Vector3(0, 0, 0)
Transform3D | body_offset | Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0)
float | bounce | 0.0
bool | can_sleep | true
bool | custom_integrator | false
float | friction | 1.0
float | gravity_scale | 1.0
Transform3D | joint_offset | Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0)
Vector3 | joint_rotation | Vector3(0, 0, 0)
JointType | joint_type | 0
float | linear_damp | 0.0
DampMode | linear_damp_mode | 0
Vector3 | linear_velocity | Vector3(0, 0, 0)
float | mass | 1.0

## Methods

void | _integrate_forces(state: PhysicsDirectBodyState3D) virtual
void | apply_central_impulse(impulse: Vector3)
void | apply_impulse(impulse: Vector3, position: Vector3 = Vector3(0, 0, 0))
int | get_bone_id() const
bool | get_simulate_physics()
bool | is_simulating_physics()

---

## Enumerations

enum DampMode
DampMode DAMP_MODE_COMBINE = 0

In this mode, the body's damping value is added to any value set in areas or the default value.

DampMode DAMP_MODE_REPLACE = 1

In this mode, the body's damping value replaces any value set in areas or the default value.

---

enum JointType
JointType JOINT_TYPE_NONE = 0

No joint is applied to the PhysicsBone3D.

JointType JOINT_TYPE_PIN = 1

A pin joint is applied to the PhysicsBone3D.

JointType JOINT_TYPE_CONE = 2

A cone joint is applied to the PhysicsBone3D.

JointType JOINT_TYPE_HINGE = 3

A hinge joint is applied to the PhysicsBone3D.

JointType JOINT_TYPE_SLIDER = 4

A slider joint is applied to the PhysicsBone3D.

JointType JOINT_TYPE_6DOF = 5

A 6 degrees of freedom joint is applied to the PhysicsBone3D.

---

## Property Descriptions

float angular_damp = 0.0 

- void set_angular_damp(value: float)
- float get_angular_damp()

Damps the body's rotation. By default, the body will use the ProjectSettings.physics/3d/default_angular_damp project setting or any value override set by an Area3D the body is in. Depending on angular_damp_mode, you can set angular_damp to be added to or to replace the body's damping value.

See ProjectSettings.physics/3d/default_angular_damp for more details about damping.

---

DampMode angular_damp_mode = 0 

- void set_angular_damp_mode(value: DampMode)
- DampMode get_angular_damp_mode()

Defines how angular_damp is applied.

---

Vector3 angular_velocity = Vector3(0, 0, 0) 

- void set_angular_velocity(value: Vector3)
- Vector3 get_angular_velocity()

The PhysicalBone3D's rotational velocity in radians per second.

---

Transform3D body_offset = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0) 

- void set_body_offset(value: Transform3D)
- Transform3D get_body_offset()

Sets the body's transform.

---

float bounce = 0.0 

- void set_bounce(value: float)
- float get_bounce()

The body's bounciness. Values range from 0 (no bounce) to 1 (full bounciness).

Note: Even with bounce set to 1.0, some energy will be lost over time due to linear and angular damping. To have a PhysicalBone3D that preserves all its energy over time, set bounce to 1.0, linear_damp_mode to DAMP_MODE_REPLACE, linear_damp to 0.0, angular_damp_mode to DAMP_MODE_REPLACE, and angular_damp to 0.0.

---

bool can_sleep = true 

- void set_can_sleep(value: bool)
- bool is_able_to_sleep()

If true, the body is deactivated when there is no movement, so it will not take part in the simulation until it is awakened by an external force.

---

bool custom_integrator = false 

- void set_use_custom_integrator(value: bool)
- bool is_using_custom_integrator()

If true, the standard force integration (like gravity or damping) will be disabled for this body. Other than collision response, the body will only move as determined by the _integrate_forces() method, if that virtual method is overridden.

Setting this property will call the method PhysicsServer3D.body_set_omit_force_integration() internally.

---

float friction = 1.0 

- void set_friction(value: float)
- float get_friction()

The body's friction, from 0 (frictionless) to 1 (max friction).

---

float gravity_scale = 1.0 

- void set_gravity_scale(value: float)
- float get_gravity_scale()

This is multiplied by ProjectSettings.physics/3d/default_gravity to produce this body's gravity. For example, a value of 1.0 will apply normal gravity, 2.0 will apply double the gravity, and 0.5 will apply half the gravity to this body.

---

Transform3D joint_offset = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0) 

- void set_joint_offset(value: Transform3D)
- Transform3D get_joint_offset()

Sets the joint's transform.

---

Vector3 joint_rotation = Vector3(0, 0, 0) 

- void set_joint_rotation(value: Vector3)
- Vector3 get_joint_rotation()

Sets the joint's rotation in radians.

---

JointType joint_type = 0 

- void set_joint_type(value: JointType)
- JointType get_joint_type()

Sets the joint type.

---

float linear_damp = 0.0 

- void set_linear_damp(value: float)
- float get_linear_damp()

Damps the body's movement. By default, the body will use ProjectSettings.physics/3d/default_linear_damp or any value override set by an Area3D the body is in. Depending on linear_damp_mode, linear_damp may be added to or replace the body's damping value.

See ProjectSettings.physics/3d/default_linear_damp for more details about damping.

---

DampMode linear_damp_mode = 0 

- void set_linear_damp_mode(value: DampMode)
- DampMode get_linear_damp_mode()

Defines how linear_damp is applied.

---

Vector3 linear_velocity = Vector3(0, 0, 0) 

- void set_linear_velocity(value: Vector3)
- Vector3 get_linear_velocity()

The body's linear velocity in units per second. Can be used sporadically, but don't set this every frame, because physics may run in another thread and runs at a different granularity. Use _integrate_forces() as your process loop for precise control of the body state.

---

float mass = 1.0 

- void set_mass(value: float)
- float get_mass()

The body's mass.

---

## Method Descriptions

void _integrate_forces(state: PhysicsDirectBodyState3D) virtual 

Called during physics processing, allowing you to read and safely modify the simulation state for the object. By default, it is called before the standard force integration, but the custom_integrator property allows you to disable the standard force integration and do fully custom force integration for a body.

---

void apply_central_impulse(impulse: Vector3) 

Applies a directional impulse without affecting rotation.

An impulse is time-independent! Applying an impulse every frame would result in a framerate-dependent force. For this reason, it should only be used when simulating one-time impacts (use the "_integrate_forces" functions otherwise).

This is equivalent to using apply_impulse() at the body's center of mass.

---

void apply_impulse(impulse: Vector3, position: Vector3 = Vector3(0, 0, 0)) 

Applies a positioned impulse to the PhysicsBone3D.

An impulse is time-independent! Applying an impulse every frame would result in a framerate-dependent force. For this reason, it should only be used when simulating one-time impacts (use the "_integrate_forces" functions otherwise).

position is the offset from the PhysicsBone3D origin in global coordinates.

---

int get_bone_id() const 

Returns the unique identifier of the PhysicsBone3D.

---

bool get_simulate_physics() 

Returns true if the PhysicsBone3D is allowed to simulate physics.

---

bool is_simulating_physics() 

Returns true if the PhysicsBone3D is currently simulating physics.
