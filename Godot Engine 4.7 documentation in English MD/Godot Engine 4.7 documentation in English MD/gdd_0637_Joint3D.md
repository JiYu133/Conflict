# Joint3D

Inherits: Node3D < Node < Object

Inherited By: ConeTwistJoint3D, Generic6DOFJoint3D, HingeJoint3D, PinJoint3D, SliderJoint3D

Abstract base class for all 3D physics joints.

## Description

Abstract base class for all joints in 3D physics. 3D joints bind together two physics bodies (node_a and node_b) and apply a constraint. If only one body is defined, it is attached to a fixed StaticBody3D without collision shapes.

## Tutorials

- 3D Truck Town Demo [https://godotengine.org/asset-library/asset/2752]

## Properties

bool | exclude_nodes_from_collision | true
NodePath | node_a | NodePath("")
NodePath | node_b | NodePath("")
int | solver_priority | 1

## Methods

RID | get_rid() const

---

## Property Descriptions

bool exclude_nodes_from_collision = true 

- void set_exclude_nodes_from_collision(value: bool)
- bool get_exclude_nodes_from_collision()

If true, the two bodies bound together do not collide with each other.

---

NodePath node_a = NodePath("") 

- void set_node_a(value: NodePath)
- NodePath get_node_a()

Path to the first node (A) attached to the joint. The node must inherit PhysicsBody3D.

If left empty and node_b is set, the body is attached to a fixed StaticBody3D without collision shapes.

---

NodePath node_b = NodePath("") 

- void set_node_b(value: NodePath)
- NodePath get_node_b()

Path to the second node (B) attached to the joint. The node must inherit PhysicsBody3D.

If left empty and node_a is set, the body is attached to a fixed StaticBody3D without collision shapes.

---

int solver_priority = 1 

- void set_solver_priority(value: int)
- int get_solver_priority()

The priority used to define which solver is executed first for multiple joints. The lower the value, the higher the priority.

Note: Only supported when using GodotPhysics3D. This property is ignored when using Jolt Physics.

---

## Method Descriptions

RID get_rid() const 

Returns the joint's internal RID from the PhysicsServer3D.
