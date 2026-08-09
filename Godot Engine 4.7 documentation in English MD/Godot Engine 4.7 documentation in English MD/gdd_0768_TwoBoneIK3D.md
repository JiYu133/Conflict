# TwoBoneIK3D

Inherits: IKModifier3D < SkeletonModifier3D < Node3D < Node < Object

Rotation based intersection of two circles inverse kinematics solver.

## Description

This IKModifier3D requires a pole target. It provides deterministic results by constructing a plane from each joint and pole target and finding the intersection of two circles (disks in 3D).

This IK can handle twist by setting the pole direction. If there are more than one bone between each set bone, their rotations are ignored, and the straight line connecting the root-middle and middle-end joints are treated as virtual bones.

Note: All the methods in this class take an index parameter. This parameter specifies which setting list entry to return if the IK has multiple entries (e.g. settings//root_bone_name).

## Properties

int | setting_count | 0

## Methods

int | get_end_bone(index: int) const
BoneDirection | get_end_bone_direction(index: int) const
float | get_end_bone_length(index: int) const
String | get_end_bone_name(index: int) const
int | get_middle_bone(index: int) const
String | get_middle_bone_name(index: int) const
SecondaryDirection | get_pole_direction(index: int) const
Vector3 | get_pole_direction_vector(index: int) const
NodePath | get_pole_node(index: int) const
int | get_root_bone(index: int) const
String | get_root_bone_name(index: int) const
NodePath | get_target_node(index: int) const
bool | is_end_bone_extended(index: int) const
bool | is_using_virtual_end(index: int) const
void | set_end_bone(index: int, bone: int)
void | set_end_bone_direction(index: int, bone_direction: BoneDirection)
void | set_end_bone_length(index: int, length: float)
void | set_end_bone_name(index: int, bone_name: String)
void | set_extend_end_bone(index: int, enabled: bool)
void | set_middle_bone(index: int, bone: int)
void | set_middle_bone_name(index: int, bone_name: String)
void | set_pole_direction(index: int, direction: SecondaryDirection)
void | set_pole_direction_vector(index: int, vector: Vector3)
void | set_pole_node(index: int, pole_node: NodePath)
void | set_root_bone(index: int, bone: int)
void | set_root_bone_name(index: int, bone_name: String)
void | set_target_node(index: int, target_node: NodePath)
void | set_use_virtual_end(index: int, enabled: bool)

---

## Property Descriptions

int setting_count = 0 

- void set_setting_count(value: int)
- int get_setting_count()

The number of settings.

---

## Method Descriptions

int get_end_bone(index: int) const 

Returns the end bone index.

---

BoneDirection get_end_bone_direction(index: int) const 

Returns the end bone's tail direction when is_end_bone_extended() is true.

---

float get_end_bone_length(index: int) const 

Returns the end bone tail length of the bone chain when is_end_bone_extended() is true.

---

String get_end_bone_name(index: int) const 

Returns the end bone name.

---

int get_middle_bone(index: int) const 

Returns the middle bone index.

---

String get_middle_bone_name(index: int) const 

Returns the middle bone name.

---

SecondaryDirection get_pole_direction(index: int) const 

Returns the pole direction.

---

Vector3 get_pole_direction_vector(index: int) const 

Returns the pole direction vector.

If get_pole_direction() is SkeletonModifier3D.SECONDARY_DIRECTION_NONE, this method returns Vector3(0, 0, 0).

---

NodePath get_pole_node(index: int) const 

Returns the pole target node that constructs a plane which the joints are all on and the pole is trying to direct.

---

int get_root_bone(index: int) const 

Returns the root bone index.

---

String get_root_bone_name(index: int) const 

Returns the root bone name.

---

NodePath get_target_node(index: int) const 

Returns the target node that the end bone is trying to reach.

---

bool is_end_bone_extended(index: int) const 

Returns true if the end bone is extended to have a tail.

---

bool is_using_virtual_end(index: int) const 

Returns true if the end bone is extended from the middle bone as a virtual bone.

---

void set_end_bone(index: int, bone: int) 

Sets the end bone index.

---

void set_end_bone_direction(index: int, bone_direction: BoneDirection) 

Sets the end bone tail direction when is_end_bone_extended() is true.

---

void set_end_bone_length(index: int, length: float) 

Sets the end bone tail length when is_end_bone_extended() is true.

---

void set_end_bone_name(index: int, bone_name: String) 

Sets the end bone name.

Note: The end bone must be a child of the middle bone.

---

void set_extend_end_bone(index: int, enabled: bool) 

If enabled is true, the end bone is extended to have a tail.

---

void set_middle_bone(index: int, bone: int) 

Sets the middle bone index.

---

void set_middle_bone_name(index: int, bone_name: String) 

Sets the middle bone name.

Note: The middle bone must be a child of the root bone.

---

void set_pole_direction(index: int, direction: SecondaryDirection) 

Sets the pole direction.

The pole is on the middle bone and will direct to the pole target.

The rotation axis is a vector that is orthogonal to this and the forward vector.

Note: The pole direction and the forward vector shouldn't be colinear to avoid unintended rotation.

---

void set_pole_direction_vector(index: int, vector: Vector3) 

Sets the pole direction vector.

This vector is normalized by an internal process.

If the vector length is 0, it is considered synonymous with SkeletonModifier3D.SECONDARY_DIRECTION_NONE.

---

void set_pole_node(index: int, pole_node: NodePath) 

Sets the pole target node that constructs a plane which the joints are all on and the pole is trying to direct.

---

void set_root_bone(index: int, bone: int) 

Sets the root bone index.

---

void set_root_bone_name(index: int, bone_name: String) 

Sets the root bone name.

---

void set_target_node(index: int, target_node: NodePath) 

Sets the target node that the end bone is trying to reach.

---

void set_use_virtual_end(index: int, enabled: bool) 

If enabled is true, the end bone is extended from the middle bone as a virtual bone.
