# Skeleton2D

Inherits: Node2D < CanvasItem < Node < Object

The parent of a hierarchy of Bone2Ds, used to create a 2D skeletal animation.

## Description

Skeleton2D parents a hierarchy of Bone2D nodes. It holds a reference to each Bone2D's rest pose and acts as a single point of access to its bones.

To set up different types of inverse kinematics for the given Skeleton2D, a SkeletonModificationStack2D should be created. The inverse kinematics be applied by increasing SkeletonModificationStack2D.modification_count and creating the desired number of modifications.

## Tutorials

- 2D skeletons

## Methods

void | execute_modifications(delta: float, execution_mode: int)
Bone2D | get_bone(idx: int)
int | get_bone_count() const
Transform2D | get_bone_local_pose_override(bone_idx: int)
SkeletonModificationStack2D | get_modification_stack() const
RID | get_skeleton() const
void | set_bone_local_pose_override(bone_idx: int, override_pose: Transform2D, strength: float, persistent: bool)
void | set_modification_stack(modification_stack: SkeletonModificationStack2D)

---

## Signals

bone_setup_changed() 

Emitted when the Bone2D setup attached to this skeletons changes. This is primarily used internally within the skeleton.

---

## Method Descriptions

void execute_modifications(delta: float, execution_mode: int) 

Executes all the modifications on the SkeletonModificationStack2D, if the Skeleton2D has one assigned.

---

Bone2D get_bone(idx: int) 

Returns a Bone2D from the node hierarchy parented by Skeleton2D. The object to return is identified by the parameter idx. Bones are indexed by descending the node hierarchy from top to bottom, adding the children of each branch before moving to the next sibling.

---

int get_bone_count() const 

Returns the number of Bone2D nodes in the node hierarchy parented by Skeleton2D.

---

Transform2D get_bone_local_pose_override(bone_idx: int) 

Returns the local pose override transform for bone_idx.

---

SkeletonModificationStack2D get_modification_stack() const 

Returns the SkeletonModificationStack2D attached to this skeleton, if one exists.

---

RID get_skeleton() const 

Returns the RID of a Skeleton2D instance.

---

void set_bone_local_pose_override(bone_idx: int, override_pose: Transform2D, strength: float, persistent: bool) 

Sets the local pose transform, override_pose, for the bone at bone_idx.

strength is the interpolation strength that will be used when applying the pose, and persistent determines if the applied pose will remain.

Note: The pose transform needs to be a local transform relative to the Bone2D node at bone_idx!

---

void set_modification_stack(modification_stack: SkeletonModificationStack2D) 

Sets the SkeletonModificationStack2D attached to this skeleton.
