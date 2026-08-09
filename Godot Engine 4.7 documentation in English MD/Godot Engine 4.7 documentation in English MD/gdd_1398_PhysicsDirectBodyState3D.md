# PhysicsDirectBodyState3D

Inherits: Object

Inherited By: PhysicsDirectBodyState3DExtension

Provides direct access to a physics body in the PhysicsServer3D.

## Description

Provides direct access to a physics body in the PhysicsServer3D, allowing safe changes to physics properties. This object is passed via the direct state callback of RigidBody3D, and is intended for changing the direct state of that body. See RigidBody3D._integrate_forces().

## Tutorials

- Physics introduction
- Ray-casting

## Properties

Vector3 | angular_velocity
Vector3 | center_of_mass
Vector3 | center_of_mass_local
int | collision_layer
int | collision_mask
Vector3 | inverse_inertia
Basis | inverse_inertia_tensor
float | inverse_mass
Vector3 | linear_velocity
Basis | principal_inertia_axes
bool | sleeping
float | step
float | total_angular_damp
Vector3 | total_gravity
float | total_linear_damp
Transform3D | transform

## Methods

void | add_constant_central_force(force: Vector3 = Vector3(0, 0, 0))
void | add_constant_force(force: Vector3, position: Vector3 = Vector3(0, 0, 0))
void | add_constant_torque(torque: Vector3)
void | apply_central_force(force: Vector3 = Vector3(0, 0, 0))
void | apply_central_impulse(impulse: Vector3 = Vector3(0, 0, 0))
void | apply_force(force: Vector3, position: Vector3 = Vector3(0, 0, 0))
void | apply_impulse(impulse: Vector3, position: Vector3 = Vector3(0, 0, 0))
void | apply_torque(torque: Vector3)
void | apply_torque_impulse(impulse: Vector3)
Vector3 | get_constant_force() const
Vector3 | get_constant_torque() const
RID | get_contact_collider(contact_idx: int) const
int | get_contact_collider_id(contact_idx: int) const
Object | get_contact_collider_object(contact_idx: int) const
Vector3 | get_contact_collider_position(contact_idx: int) const
int | get_contact_collider_shape(contact_idx: int) const
Vector3 | get_contact_collider_velocity_at_position(contact_idx: int) const
int | get_contact_count() const
Vector3 | get_contact_impulse(contact_idx: int) const
Vector3 | get_contact_local_normal(contact_idx: int) const
Vector3 | get_contact_local_position(contact_idx: int) const
int | get_contact_local_shape(contact_idx: int) const
Vector3 | get_contact_local_velocity_at_position(contact_idx: int) const
PhysicsDirectSpaceState3D | get_space_state()
Vector3 | get_velocity_at_local_position(local_position: Vector3) const
void | integrate_forces()
void | set_constant_force(force: Vector3)
void | set_constant_torque(torque: Vector3)

---

## Property Descriptions

Vector3 angular_velocity 

- void set_angular_velocity(value: Vector3)
- Vector3 get_angular_velocity()

The body's rotational velocity in radians per second.

---

Vector3 center_of_mass 

- Vector3 get_center_of_mass()

The body's center of mass position relative to the body's center in the global coordinate system.

---

Vector3 center_of_mass_local 

- Vector3 get_center_of_mass_local()

The body's center of mass position in the body's local coordinate system.

---

int collision_layer 

- void set_collision_layer(value: int)
- int get_collision_layer()

The body's collision layer.

---

int collision_mask 

- void set_collision_mask(value: int)
- int get_collision_mask()

The body's collision mask.

---

Vector3 inverse_inertia 

- Vector3 get_inverse_inertia()

The inverse of the inertia of the body.

---

Basis inverse_inertia_tensor 

- Basis get_inverse_inertia_tensor()

The inverse of the inertia tensor of the body.

---

float inverse_mass 

- float get_inverse_mass()

The inverse of the mass of the body.

---

Vector3 linear_velocity 

- void set_linear_velocity(value: Vector3)
- Vector3 get_linear_velocity()

The body's linear velocity in units per second.

---

Basis principal_inertia_axes 

- Basis get_principal_inertia_axes()

There is currently no description for this property. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

bool sleeping 

- void set_sleep_state(value: bool)
- bool is_sleeping()

If true, this body is currently sleeping (not active).

---

float step 

- float get_step()

The timestep (delta) used for the simulation.

---

float total_angular_damp 

- float get_total_angular_damp()

The rate at which the body stops rotating, if there are not any other forces moving it.

---

Vector3 total_gravity 

- Vector3 get_total_gravity()

The total gravity vector being currently applied to this body.

---

float total_linear_damp 

- float get_total_linear_damp()

The rate at which the body stops moving, if there are not any other forces moving it.

---

Transform3D transform 

- void set_transform(value: Transform3D)
- Transform3D get_transform()

The body's transformation matrix.

---

## Method Descriptions

void add_constant_central_force(force: Vector3 = Vector3(0, 0, 0)) 

Adds a constant directional force without affecting rotation that keeps being applied over time until cleared with constant_force = Vector3(0, 0, 0).

This is equivalent to using add_constant_force() at the body's center of mass.

---

void add_constant_force(force: Vector3, position: Vector3 = Vector3(0, 0, 0)) 

Adds a constant positioned force to the body that keeps being applied over time until cleared with constant_force = Vector3(0, 0, 0).

position is the offset from the body origin in global coordinates.

---

void add_constant_torque(torque: Vector3) 

Adds a constant rotational force without affecting position that keeps being applied over time until cleared with constant_torque = Vector3(0, 0, 0).

---

void apply_central_force(force: Vector3 = Vector3(0, 0, 0)) 

Applies a directional force without affecting rotation. A force is time dependent and meant to be applied every physics update.

This is equivalent to using apply_force() at the body's center of mass.

---

void apply_central_impulse(impulse: Vector3 = Vector3(0, 0, 0)) 

Applies a directional impulse without affecting rotation.

An impulse is time-independent! Applying an impulse every frame would result in a framerate-dependent force. For this reason, it should only be used when simulating one-time impacts (use the "_force" functions otherwise).

This is equivalent to using apply_impulse() at the body's center of mass.

---

void apply_force(force: Vector3, position: Vector3 = Vector3(0, 0, 0)) 

Applies a positioned force to the body. A force is time dependent and meant to be applied every physics update.

position is the offset from the body origin in global coordinates.

---

void apply_impulse(impulse: Vector3, position: Vector3 = Vector3(0, 0, 0)) 

Applies a positioned impulse to the body.

An impulse is time-independent! Applying an impulse every frame would result in a framerate-dependent force. For this reason, it should only be used when simulating one-time impacts (use the "_force" functions otherwise).

position is the offset from the body origin in global coordinates.

---

void apply_torque(torque: Vector3) 

Applies a rotational force without affecting position. A force is time dependent and meant to be applied every physics update.

Note: inverse_inertia is required for this to work. To have inverse_inertia, an active CollisionShape3D must be a child of the node, or you can manually set inverse_inertia.

---

void apply_torque_impulse(impulse: Vector3) 

Applies a rotational impulse to the body without affecting the position.

An impulse is time-independent! Applying an impulse every frame would result in a framerate-dependent force. For this reason, it should only be used when simulating one-time impacts (use the "_force" functions otherwise).

Note: inverse_inertia is required for this to work. To have inverse_inertia, an active CollisionShape3D must be a child of the node, or you can manually set inverse_inertia.

---

Vector3 get_constant_force() const 

Returns the body's total constant positional forces applied during each physics update.

See add_constant_force() and add_constant_central_force().

---

Vector3 get_constant_torque() const 

Returns the body's total constant rotational forces applied during each physics update.

See add_constant_torque().

---

RID get_contact_collider(contact_idx: int) const 

Returns the collider's RID.

---

int get_contact_collider_id(contact_idx: int) const 

Returns the collider's object id.

---

Object get_contact_collider_object(contact_idx: int) const 

Returns the collider object.

---

Vector3 get_contact_collider_position(contact_idx: int) const 

Returns the position of the contact point on the collider in the global coordinate system.

---

int get_contact_collider_shape(contact_idx: int) const 

Returns the collider's shape index.

---

Vector3 get_contact_collider_velocity_at_position(contact_idx: int) const 

Returns the linear velocity vector at the collider's contact point.

---

int get_contact_count() const 

Returns the number of contacts this body has with other bodies.

Note: By default, this returns 0 unless bodies are configured to monitor contacts. See RigidBody3D.contact_monitor.

---

Vector3 get_contact_impulse(contact_idx: int) const 

Impulse created by the contact.

---

Vector3 get_contact_local_normal(contact_idx: int) const 

Returns the local normal at the contact point.

---

Vector3 get_contact_local_position(contact_idx: int) const 

Returns the position of the contact point on the body in the global coordinate system.

---

int get_contact_local_shape(contact_idx: int) const 

Returns the local shape index of the collision.

---

Vector3 get_contact_local_velocity_at_position(contact_idx: int) const 

Returns the linear velocity vector at the body's contact point.

---

PhysicsDirectSpaceState3D get_space_state() 

Returns the current state of the space, useful for queries.

---

Vector3 get_velocity_at_local_position(local_position: Vector3) const 

Returns the body's velocity at the given relative position.

local_position is the offset from the body origin in global coordinates.

---

void integrate_forces() 

Updates the body's linear and angular velocity by applying gravity and damping for the equivalent of one physics tick.

---

void set_constant_force(force: Vector3) 

Sets the body's total constant positional forces applied during each physics update.

See add_constant_force() and add_constant_central_force().

---

void set_constant_torque(torque: Vector3) 

Sets the body's total constant rotational forces applied during each physics update.

See add_constant_torque().
