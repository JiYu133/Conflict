# ChainIK3D

Inherits: IKModifier3D < SkeletonModifier3D < Node3D < Node < Object

Inherited By: IterateIK3D, SplineIK3D

A SkeletonModifier3D to apply inverse kinematics to bone chains containing an arbitrary number of bones.

## Description

Base class of SkeletonModifier3D that automatically generates a joint list from the bones between the root bone and the end bone.

Note: All the methods in this class take an index parameter. This parameter specifies which setting list entry to return if the IK has multiple entries (e.g. settings//root_bone_name).

## Methods

int | get_end_bone(index: int) const
BoneDirection | get_end_bone_direction(index: int) const
float | get_end_bone_length(index: int) const
String | get_end_bone_name(index: int) const
int | get_joint_bone(index: int, joint: int) const
String | get_joint_bone_name(index: int, joint: int) const
int | get_joint_count(index: int) const
int | get_root_bone(index: int) const
String | get_root_bone_name(index: int) const
bool | is_end_bone_extended(index: int) const
void | set_end_bone(index: int, bone: int)
void | set_end_bone_direction(index: int, bone_direction: BoneDirection)
void | set_end_bone_length(index: int, length: float)
void | set_end_bone_name(index: int, bone_name: String)
void | set_extend_end_bone(index: int, enabled: bool)
void | set_root_bone(index: int, bone: int)
void | set_root_bone_name(index: int, bone_name: String)

---

## Method Descriptions

int get_end_bone(index: int) const 

Returns the end bone index of the bone chain.

---

BoneDirection get_end_bone_direction(index: int) const 

Returns the tail direction of the end bone of the bone chain when is_end_bone_extended() is true.

---

float get_end_bone_length(index: int) const 

Returns the end bone tail length of the bone chain when is_end_bone_extended() is true.

---

String get_end_bone_name(index: int) const 

Returns the end bone name of the bone chain.

---

int get_joint_bone(index: int, joint: int) const 

Returns the bone index at joint in the bone chain's joint list.

---

String get_joint_bone_name(index: int, joint: int) const 

Returns the bone name at joint in the bone chain's joint list.

---

int get_joint_count(index: int) const 

Returns the joint count of the bone chain's joint list.

---

int get_root_bone(index: int) const 

Returns the root bone index of the bone chain.

---

String get_root_bone_name(index: int) const 

Returns the root bone name of the bone chain.

---

bool is_end_bone_extended(index: int) const 

Returns true if the end bone is extended to have a tail.

---

void set_end_bone(index: int, bone: int) 

Sets the end bone index of the bone chain.

---

void set_end_bone_direction(index: int, bone_direction: BoneDirection) 

Sets the end bone tail direction of the bone chain when is_end_bone_extended() is true.

---

void set_end_bone_length(index: int, length: float) 

Sets the end bone tail length of the bone chain when is_end_bone_extended() is true.

---

void set_end_bone_name(index: int, bone_name: String) 

Sets the end bone name of the bone chain.

Note: The end bone must be the root bone or a child of the root bone. If they are the same, the tail must be extended by set_extend_end_bone() to modify the bone.

---

void set_extend_end_bone(index: int, enabled: bool) 

If enabled is true, the end bone is extended to have a tail.

The extended tail config is allocated to the last element in the joint list. In other words, if you set enabled to false, the config of the last element in the joint list has no effect in the simulated result.

---

void set_root_bone(index: int, bone: int) 

Sets the root bone index of the bone chain.

---

void set_root_bone_name(index: int, bone_name: String) 

Sets the root bone name of the bone chain.
