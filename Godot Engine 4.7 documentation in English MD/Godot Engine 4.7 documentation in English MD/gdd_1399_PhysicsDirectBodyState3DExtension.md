# PhysicsDirectBodyState3DExtension

Inherits: PhysicsDirectBodyState3D < Object

Provides virtual methods that can be overridden to create custom PhysicsDirectBodyState3D implementations.

## Description

This class extends PhysicsDirectBodyState3D by providing additional virtual methods that can be overridden. When these methods are overridden, they will be called instead of the internal methods of the physics server.

Intended for use with GDExtension to create custom implementations of PhysicsDirectBodyState3D.

## Methods

void | _add_constant_central_force(force: Vector3) virtual required
void | _add_constant_force(force: Vector3, position: Vector3) virtual required
void | _add_constant_torque(torque: Vector3) virtual required
void | _apply_central_force(force: Vector3) virtual required
void | _apply_central_impulse(impulse: Vector3) virtual required
void | _apply_force(force: Vector3, position: Vector3) virtual required
void | _apply_impulse(impulse: Vector3, position: Vector3) virtual required
void | _apply_torque(torque: Vector3) virtual required
void | _apply_torque_impulse(impulse: Vector3) virtual required
Vector3 | _get_angular_velocity() virtual required const
Vector3 | _get_center_of_mass() virtual required const
Vector3 | _get_center_of_mass_local() virtual required const
int | _get_collision_layer() virtual required const
int | _get_collision_mask() virtual required const
Vector3 | _get_constant_force() virtual required const
Vector3 | _get_constant_torque() virtual required const
RID | _get_contact_collider(contact_idx: int) virtual required const
int | _get_contact_collider_id(contact_idx: int) virtual required const
Object | _get_contact_collider_object(contact_idx: int) virtual required const
Vector3 | _get_contact_collider_position(contact_idx: int) virtual required const
int | _get_contact_collider_shape(contact_idx: int) virtual required const
Vector3 | _get_contact_collider_velocity_at_position(contact_idx: int) virtual required const
int | _get_contact_count() virtual required const
Vector3 | _get_contact_impulse(contact_idx: int) virtual required const
Vector3 | _get_contact_local_normal(contact_idx: int) virtual required const
Vector3 | _get_contact_local_position(contact_idx: int) virtual required const
int | _get_contact_local_shape(contact_idx: int) virtual required const
Vector3 | _get_contact_local_velocity_at_position(contact_idx: int) virtual required const
Vector3 | _get_inverse_inertia() virtual required const
Basis | _get_inverse_inertia_tensor() virtual required const
float | _get_inverse_mass() virtual required const
Vector3 | _get_linear_velocity() virtual required const
Basis | _get_principal_inertia_axes() virtual required const
PhysicsDirectSpaceState3D | _get_space_state() virtual required
float | _get_step() virtual required const
float | _get_total_angular_damp() virtual required const
Vector3 | _get_total_gravity() virtual required const
float | _get_total_linear_damp() virtual required const
Transform3D | _get_transform() virtual required const
Vector3 | _get_velocity_at_local_position(local_position: Vector3) virtual required const
void | _integrate_forces() virtual required
bool | _is_sleeping() virtual required const
void | _set_angular_velocity(velocity: Vector3) virtual required
void | _set_collision_layer(layer: int) virtual required
void | _set_collision_mask(mask: int) virtual required
void | _set_constant_force(force: Vector3) virtual required
void | _set_constant_torque(torque: Vector3) virtual required
void | _set_linear_velocity(velocity: Vector3) virtual required
void | _set_sleep_state(enabled: bool) virtual required
void | _set_transform(transform: Transform3D) virtual required

---

## Method Descriptions

void _add_constant_central_force(force: Vector3) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _add_constant_force(force: Vector3, position: Vector3) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _add_constant_torque(torque: Vector3) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _apply_central_force(force: Vector3) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _apply_central_impulse(impulse: Vector3) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _apply_force(force: Vector3, position: Vector3) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _apply_impulse(impulse: Vector3, position: Vector3) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _apply_torque(torque: Vector3) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _apply_torque_impulse(impulse: Vector3) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Vector3 _get_angular_velocity() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Vector3 _get_center_of_mass() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Vector3 _get_center_of_mass_local() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

int _get_collision_layer() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

int _get_collision_mask() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Vector3 _get_constant_force() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Vector3 _get_constant_torque() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

RID _get_contact_collider(contact_idx: int) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

int _get_contact_collider_id(contact_idx: int) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Object _get_contact_collider_object(contact_idx: int) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Vector3 _get_contact_collider_position(contact_idx: int) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

int _get_contact_collider_shape(contact_idx: int) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Vector3 _get_contact_collider_velocity_at_position(contact_idx: int) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

int _get_contact_count() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Vector3 _get_contact_impulse(contact_idx: int) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Vector3 _get_contact_local_normal(contact_idx: int) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Vector3 _get_contact_local_position(contact_idx: int) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

int _get_contact_local_shape(contact_idx: int) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Vector3 _get_contact_local_velocity_at_position(contact_idx: int) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Vector3 _get_inverse_inertia() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Basis _get_inverse_inertia_tensor() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

float _get_inverse_mass() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Vector3 _get_linear_velocity() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Basis _get_principal_inertia_axes() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

PhysicsDirectSpaceState3D _get_space_state() virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

float _get_step() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

float _get_total_angular_damp() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Vector3 _get_total_gravity() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

float _get_total_linear_damp() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Transform3D _get_transform() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

Vector3 _get_velocity_at_local_position(local_position: Vector3) virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _integrate_forces() virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

bool _is_sleeping() virtual required const 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _set_angular_velocity(velocity: Vector3) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _set_collision_layer(layer: int) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _set_collision_mask(mask: int) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _set_constant_force(force: Vector3) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _set_constant_torque(torque: Vector3) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _set_linear_velocity(velocity: Vector3) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _set_sleep_state(enabled: bool) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

void _set_transform(transform: Transform3D) virtual required 

There is currently no description for this method. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!
