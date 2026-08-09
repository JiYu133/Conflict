# SkeletonModification2DPhysicalBones

Experimental: Physical bones may be changed in the future to perform the position update of Bone2D on their own, without needing this resource.

Inherits: SkeletonModification2D < Resource < RefCounted < Object

A modification that applies the transforms of PhysicalBone2D nodes to Bone2D nodes.

## Description

This modification takes the transforms of PhysicalBone2D nodes and applies them to Bone2D nodes. This allows the Bone2D nodes to react to physics thanks to the linked PhysicalBone2D nodes.

## Properties

int | physical_bone_chain_length | 0

## Methods

void | fetch_physical_bones()
NodePath | get_physical_bone_node(joint_idx: int) const
void | set_physical_bone_node(joint_idx: int, physicalbone2d_node: NodePath)
void | start_simulation(bones: Array[StringName] = [])
void | stop_simulation(bones: Array[StringName] = [])

---

## Property Descriptions

int physical_bone_chain_length = 0 

- void set_physical_bone_chain_length(value: int)
- int get_physical_bone_chain_length()

The number of PhysicalBone2D nodes linked in this modification.

---

## Method Descriptions

void fetch_physical_bones() 

Empties the list of PhysicalBone2D nodes and populates it with all PhysicalBone2D nodes that are children of the Skeleton2D.

---

NodePath get_physical_bone_node(joint_idx: int) const 

Returns the PhysicalBone2D node at joint_idx.

---

void set_physical_bone_node(joint_idx: int, physicalbone2d_node: NodePath) 

Sets the PhysicalBone2D node at joint_idx.

Note: This is just the index used for this modification, not the bone index used in the Skeleton2D.

---

void start_simulation(bones: Array[StringName] = []) 

Tell the PhysicalBone2D nodes to start simulating and interacting with the physics world.

Optionally, an array of bone names can be passed to this function, and that will cause only PhysicalBone2D nodes with those names to start simulating.

---

void stop_simulation(bones: Array[StringName] = []) 

Tell the PhysicalBone2D nodes to stop simulating and interacting with the physics world.

Optionally, an array of bone names can be passed to this function, and that will cause only PhysicalBone2D nodes with those names to stop simulating.
