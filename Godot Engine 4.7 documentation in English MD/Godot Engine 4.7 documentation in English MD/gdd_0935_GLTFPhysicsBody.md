# GLTFPhysicsBody

Inherits: Resource < RefCounted < Object

Represents a glTF physics body.

## Description

Represents a physics body as an intermediary between the OMI_physics_body glTF data and Godot's nodes, and it's abstracted in a way that allows adding support for different glTF physics extensions in the future.

## Tutorials

- Runtime file loading and saving
- OMI_physics_body glTF extension [https://github.com/omigroup/gltf-extensions/tree/main/extensions/2.0/OMI_physics_body]

## Properties

Vector3 | angular_velocity | Vector3(0, 0, 0)
String | body_type | "rigid"
Vector3 | center_of_mass | Vector3(0, 0, 0)
Vector3 | inertia_diagonal | Vector3(0, 0, 0)
Quaternion | inertia_orientation | Quaternion(0, 0, 0, 1)
Basis | inertia_tensor | Basis(0, 0, 0, 0, 0, 0, 0, 0, 0)
Vector3 | linear_velocity | Vector3(0, 0, 0)
float | mass | 1.0

## Methods

GLTFPhysicsBody | from_dictionary(dictionary: Dictionary) static
GLTFPhysicsBody | from_node(body_node: CollisionObject3D) static
Dictionary | to_dictionary() const
CollisionObject3D | to_node() const

---

## Property Descriptions

Vector3 angular_velocity = Vector3(0, 0, 0) 

- void set_angular_velocity(value: Vector3)
- Vector3 get_angular_velocity()

The angular velocity of the physics body, in radians per second. This is only used when the body type is "rigid" or "vehicle".

---

String body_type = "rigid" 

- void set_body_type(value: String)
- String get_body_type()

The type of the body.

When importing, this controls what type of CollisionObject3D node Godot should generate. Valid values are "static", "animatable", "character", "rigid", "vehicle", and "trigger".

When exporting, this will be squashed down to one of "static", "kinematic", or "dynamic" motion types, or the "trigger" property.

---

Vector3 center_of_mass = Vector3(0, 0, 0) 

- void set_center_of_mass(value: Vector3)
- Vector3 get_center_of_mass()

The center of mass of the body, in meters. This is in local space relative to the body. By default, the center of the mass is the body's origin.

---

Vector3 inertia_diagonal = Vector3(0, 0, 0) 

- void set_inertia_diagonal(value: Vector3)
- Vector3 get_inertia_diagonal()

The inertia strength of the physics body, in kilogram meter squared (kg⋅m²). This represents the inertia around the principle axes, the diagonal of the inertia tensor matrix. This is only used when the body type is "rigid" or "vehicle".

When converted to a Godot RigidBody3D node, if this value is zero, then the inertia will be calculated automatically.

---

Quaternion inertia_orientation = Quaternion(0, 0, 0, 1) 

- void set_inertia_orientation(value: Quaternion)
- Quaternion get_inertia_orientation()

The inertia orientation of the physics body. This defines the rotation of the inertia's principle axes relative to the object's local axes. This is only used when the body type is "rigid" or "vehicle" and inertia_diagonal is set to a non-zero value.

---

Basis inertia_tensor = Basis(0, 0, 0, 0, 0, 0, 0, 0, 0) 

- void set_inertia_tensor(value: Basis)
- Basis get_inertia_tensor()

Deprecated: This property may be changed or removed in future versions.

The inertia tensor of the physics body, in kilogram meter squared (kg⋅m²). This is only used when the body type is "rigid" or "vehicle".

When converted to a Godot RigidBody3D node, if this value is zero, then the inertia will be calculated automatically.

---

Vector3 linear_velocity = Vector3(0, 0, 0) 

- void set_linear_velocity(value: Vector3)
- Vector3 get_linear_velocity()

The linear velocity of the physics body, in meters per second. This is only used when the body type is "rigid" or "vehicle".

---

float mass = 1.0 

- void set_mass(value: float)
- float get_mass()

The mass of the physics body, in kilograms. This is only used when the body type is "rigid" or "vehicle".

---

## Method Descriptions

GLTFPhysicsBody from_dictionary(dictionary: Dictionary) static 

Creates a new GLTFPhysicsBody instance by parsing the given Dictionary in the OMI_physics_body glTF extension format.

---

GLTFPhysicsBody from_node(body_node: CollisionObject3D) static 

Creates a new GLTFPhysicsBody instance from the given Godot CollisionObject3D node.

---

Dictionary to_dictionary() const 

Serializes this GLTFPhysicsBody instance into a Dictionary. It will be in the format expected by the OMI_physics_body glTF extension.

---

CollisionObject3D to_node() const 

Converts this GLTFPhysicsBody instance into a Godot CollisionObject3D node.
