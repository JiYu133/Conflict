# Joint2D

Inherits: Node2D < CanvasItem < Node < Object

Inherited By: DampedSpringJoint2D, GrooveJoint2D, PinJoint2D

Abstract base class for all 2D physics joints.

## Description

Abstract base class for all joints in 2D physics. 2D joints bind together two physics bodies (node_a and node_b) and apply a constraint.

## Properties

float | bias | 0.0
bool | disable_collision | true
NodePath | node_a | NodePath("")
NodePath | node_b | NodePath("")

## Methods

RID | get_rid() const

---

## Property Descriptions

float bias = 0.0 

- void set_bias(value: float)
- float get_bias()

When node_a and node_b move in different directions the bias controls how fast the joint pulls them back to their original position. The lower the bias the more the two bodies can pull on the joint.

When set to 0, the default value from ProjectSettings.physics/2d/solver/default_constraint_bias is used.

---

bool disable_collision = true 

- void set_exclude_nodes_from_collision(value: bool)
- bool get_exclude_nodes_from_collision()

If true, the two bodies bound together do not collide with each other.

---

NodePath node_a = NodePath("") 

- void set_node_a(value: NodePath)
- NodePath get_node_a()

Path to the first body (A) attached to the joint. The node must inherit PhysicsBody2D.

---

NodePath node_b = NodePath("") 

- void set_node_b(value: NodePath)
- NodePath get_node_b()

Path to the second body (B) attached to the joint. The node must inherit PhysicsBody2D.

---

## Method Descriptions

RID get_rid() const 

Returns the joint's internal RID from the PhysicsServer2D.
