# SkeletonModification2DTwoBoneIK

Experimental: This class may be changed or removed in future versions.

Inherits: SkeletonModification2D < Resource < RefCounted < Object

A modification that rotates two bones using the law of cosines to reach the target.

## Description

This SkeletonModification2D uses an algorithm typically called TwoBoneIK. This algorithm works by leveraging the law of cosines and the lengths of the bones to figure out what rotation the bones currently have, and what rotation they need to make a complete triangle, where the first bone, the second bone, and the target form the three vertices of the triangle. Because the algorithm works by making a triangle, it can only operate on two bones.

TwoBoneIK is great for arms, legs, and really any joints that can be represented by just two bones that bend to reach a target. This solver is more lightweight than SkeletonModification2DFABRIK, but gives similar, natural looking results.

## Properties

bool | flip_bend_direction | false
float | target_maximum_distance | 0.0
float | target_minimum_distance | 0.0
NodePath | target_nodepath | NodePath("")

## Methods

NodePath | get_joint_one_bone2d_node() const
int | get_joint_one_bone_idx() const
NodePath | get_joint_two_bone2d_node() const
int | get_joint_two_bone_idx() const
void | set_joint_one_bone2d_node(bone2d_node: NodePath)
void | set_joint_one_bone_idx(bone_idx: int)
void | set_joint_two_bone2d_node(bone2d_node: NodePath)
void | set_joint_two_bone_idx(bone_idx: int)

---

## Property Descriptions

bool flip_bend_direction = false 

- void set_flip_bend_direction(value: bool)
- bool get_flip_bend_direction()

If true, the bones in the modification will bend outward as opposed to inwards when contracting. If false, the bones will bend inwards when contracting.

---

float target_maximum_distance = 0.0 

- void set_target_maximum_distance(value: float)
- float get_target_maximum_distance()

The maximum distance the target can be at. If the target is farther than this distance, the modification will solve as if it's at this maximum distance. When set to 0, the modification will solve without distance constraints.

---

float target_minimum_distance = 0.0 

- void set_target_minimum_distance(value: float)
- float get_target_minimum_distance()

The minimum distance the target can be at. If the target is closer than this distance, the modification will solve as if it's at this minimum distance. When set to 0, the modification will solve without distance constraints.

---

NodePath target_nodepath = NodePath("") 

- void set_target_node(value: NodePath)
- NodePath get_target_node()

The NodePath to the node that is the target for the TwoBoneIK modification. This node is what the modification will use when bending the Bone2D nodes.

---

## Method Descriptions

NodePath get_joint_one_bone2d_node() const 

Returns the Bone2D node that is being used as the first bone in the TwoBoneIK modification.

---

int get_joint_one_bone_idx() const 

Returns the index of the Bone2D node that is being used as the first bone in the TwoBoneIK modification.

---

NodePath get_joint_two_bone2d_node() const 

Returns the Bone2D node that is being used as the second bone in the TwoBoneIK modification.

---

int get_joint_two_bone_idx() const 

Returns the index of the Bone2D node that is being used as the second bone in the TwoBoneIK modification.

---

void set_joint_one_bone2d_node(bone2d_node: NodePath) 

Sets the Bone2D node that is being used as the first bone in the TwoBoneIK modification.

---

void set_joint_one_bone_idx(bone_idx: int) 

Sets the index of the Bone2D node that is being used as the first bone in the TwoBoneIK modification.

---

void set_joint_two_bone2d_node(bone2d_node: NodePath) 

Sets the Bone2D node that is being used as the second bone in the TwoBoneIK modification.

---

void set_joint_two_bone_idx(bone_idx: int) 

Sets the index of the Bone2D node that is being used as the second bone in the TwoBoneIK modification.
