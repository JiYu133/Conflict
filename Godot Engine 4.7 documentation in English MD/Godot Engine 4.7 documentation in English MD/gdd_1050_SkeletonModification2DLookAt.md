# SkeletonModification2DLookAt

Experimental: This class may be changed or removed in future versions.

Inherits: SkeletonModification2D < Resource < RefCounted < Object

A modification that rotates a Bone2D node to look at a target.

## Description

This SkeletonModification2D rotates a bone to look a target. This is extremely helpful for moving character's head to look at the player, rotating a turret to look at a target, or any other case where you want to make a bone rotate towards something quickly and easily.

## Properties

NodePath | bone2d_node | NodePath("")
int | bone_index | -1
NodePath | target_nodepath | NodePath("")

## Methods

float | get_additional_rotation() const
bool | get_constraint_angle_invert() const
float | get_constraint_angle_max() const
float | get_constraint_angle_min() const
bool | get_enable_constraint() const
void | set_additional_rotation(rotation: float)
void | set_constraint_angle_invert(invert: bool)
void | set_constraint_angle_max(angle_max: float)
void | set_constraint_angle_min(angle_min: float)
void | set_enable_constraint(enable_constraint: bool)

---

## Property Descriptions

NodePath bone2d_node = NodePath("") 

- void set_bone2d_node(value: NodePath)
- NodePath get_bone2d_node()

The Bone2D node that the modification will operate on.

---

int bone_index = -1 

- void set_bone_index(value: int)
- int get_bone_index()

The index of the Bone2D node that the modification will operate on.

---

NodePath target_nodepath = NodePath("") 

- void set_target_node(value: NodePath)
- NodePath get_target_node()

The NodePath to the node that is the target for the LookAt modification. This node is what the modification will rotate the Bone2D to.

---

## Method Descriptions

float get_additional_rotation() const 

Returns the amount of additional rotation that is applied after the LookAt modification executes.

---

bool get_constraint_angle_invert() const 

Returns whether the constraints to this modification are inverted or not.

---

float get_constraint_angle_max() const 

Returns the constraint's maximum allowed angle.

---

float get_constraint_angle_min() const 

Returns the constraint's minimum allowed angle.

---

bool get_enable_constraint() const 

Returns true if the LookAt modification is using constraints.

---

void set_additional_rotation(rotation: float) 

Sets the amount of additional rotation that is to be applied after executing the modification. This allows for offsetting the results by the inputted rotation amount.

---

void set_constraint_angle_invert(invert: bool) 

When true, the modification will use an inverted joint constraint.

An inverted joint constraint only constraints the Bone2D to the angles outside of the inputted minimum and maximum angles. For this reason, it is referred to as an inverted joint constraint, as it constraints the joint to the outside of the inputted values.

---

void set_constraint_angle_max(angle_max: float) 

Sets the constraint's maximum allowed angle.

---

void set_constraint_angle_min(angle_min: float) 

Sets the constraint's minimum allowed angle.

---

void set_enable_constraint(enable_constraint: bool) 

Sets whether this modification will use constraints or not. When true, constraints will be applied when solving the LookAt modification.
