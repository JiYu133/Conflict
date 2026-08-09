# BoneTwistDisperser3D

Inherits: SkeletonModifier3D < Node3D < Node < Object

A node that propagates and disperses the child bone's twist to the parent bones.

## Description

This BoneTwistDisperser3D allows for smooth twist interpolation between multiple bones by dispersing the end bone's twist to the parents. This only changes the twist without changing the global position of each joint.

This is useful for smoothly twisting bones in combination with CopyTransformModifier3D and IK.

Note: If an extracted twist is greater than 180 degrees, flipping occurs. This is similar to ConvertTransformModifier3D.

Note: Most methods in this class take an index parameter. This parameter specifies which setting list entry to return if the IK has multiple entries (e.g. settings//root_bone_name).

## Properties

bool | mutable_bone_axes | true
int | setting_count | 0

## Methods

void | clear_settings()
Curve | get_damping_curve(index: int) const
DisperseMode | get_disperse_mode(index: int) const
int | get_end_bone(index: int) const
BoneDirection | get_end_bone_direction(index: int) const
String | get_end_bone_name(index: int) const
int | get_joint_bone(index: int, joint: int) const
String | get_joint_bone_name(index: int, joint: int) const
int | get_joint_count(index: int) const
float | get_joint_twist_amount(index: int, joint: int) const
int | get_reference_bone(index: int) const
String | get_reference_bone_name(index: int) const
int | get_root_bone(index: int) const
String | get_root_bone_name(index: int) const
Quaternion | get_twist_from(index: int) const
float | get_weight_position(index: int) const
bool | is_end_bone_extended(index: int) const
bool | is_twist_from_rest(index: int) const
void | set_damping_curve(index: int, curve: Curve)
void | set_disperse_mode(index: int, disperse_mode: DisperseMode)
void | set_end_bone(index: int, bone: int)
void | set_end_bone_direction(index: int, bone_direction: BoneDirection)
void | set_end_bone_name(index: int, bone_name: String)
void | set_extend_end_bone(index: int, enabled: bool)
void | set_joint_twist_amount(index: int, joint: int, twist_amount: float)
void | set_root_bone(index: int, bone: int)
void | set_root_bone_name(index: int, bone_name: String)
void | set_twist_from(index: int, from: Quaternion)
void | set_twist_from_rest(index: int, enabled: bool)
void | set_weight_position(index: int, weight_position: float)

---

## Enumerations

enum DisperseMode
DisperseMode DISPERSE_MODE_EVEN = 0

Assign amounts so that they monotonically increase from 0.0 to 1.0, ensuring all weights are equal. For example, with five joints, the amounts would be 0.2, 0.4, 0.6, 0.8, and 1.0 starting from the root bone.

DisperseMode DISPERSE_MODE_WEIGHTED = 1

Assign amounts so that they monotonically increase from 0.0 to 1.0, based on the length of the bones between joint segments. See also set_weight_position().

DisperseMode DISPERSE_MODE_CUSTOM = 2

You can assign arbitrary amounts to the joint list. See also set_joint_twist_amount().

When is_end_bone_extended() is false, a child of the reference bone exists solely to determine the twist axis, so its custom amount has absolutely no effect at all.

---

## Property Descriptions

bool mutable_bone_axes = true 

- void set_mutable_bone_axes(value: bool)
- bool are_bone_axes_mutable()

If true, the solver retrieves the bone axis from the bone pose every frame.

If false, the solver retrieves the bone axis from the bone rest and caches it.

---

int setting_count = 0 

- void set_setting_count(value: int)
- int get_setting_count()

The number of settings.

---

## Method Descriptions

void clear_settings() 

Clears all settings.

---

Curve get_damping_curve(index: int) const 

Returns the damping curve when get_disperse_mode() is DISPERSE_MODE_CUSTOM.

---

DisperseMode get_disperse_mode(index: int) const 

Returns whether to use automatic amount assignment or to allow manual assignment.

---

int get_end_bone(index: int) const 

Returns the end bone index of the bone chain.

---

BoneDirection get_end_bone_direction(index: int) const 

Returns the tail direction of the end bone of the bone chain when is_end_bone_extended() is true.

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

float get_joint_twist_amount(index: int, joint: int) const 

Returns the twist amount at joint in the bone chain's joint list when get_disperse_mode() is DISPERSE_MODE_CUSTOM.

---

int get_reference_bone(index: int) const 

Returns the reference bone to extract twist of the setting at index.

This bone is either the end of the chain or its parent, depending on is_end_bone_extended().

---

String get_reference_bone_name(index: int) const 

Returns the reference bone name to extract twist of the setting at index.

This bone is either the end of the chain or its parent, depending on is_end_bone_extended().

---

int get_root_bone(index: int) const 

Returns the root bone index of the bone chain.

---

String get_root_bone_name(index: int) const 

Returns the root bone name of the bone chain.

---

Quaternion get_twist_from(index: int) const 

Returns the rotation to an arbitrary state before twisting for the current bone pose to extract the twist when is_twist_from_rest() is false.

---

float get_weight_position(index: int) const 

Returns the position at which to divide the segment between joints for weight assignment when get_disperse_mode() is DISPERSE_MODE_WEIGHTED.

---

bool is_end_bone_extended(index: int) const 

Returns true if the end bone is extended to have a tail.

---

bool is_twist_from_rest(index: int) const 

Returns true if extracting the twist amount from the difference between the bone rest and the current bone pose.

---

void set_damping_curve(index: int, curve: Curve) 

Sets the damping curve when get_disperse_mode() is DISPERSE_MODE_CUSTOM.

---

void set_disperse_mode(index: int, disperse_mode: DisperseMode) 

Sets whether to use automatic amount assignment or to allow manual assignment.

---

void set_end_bone(index: int, bone: int) 

Sets the end bone index of the bone chain.

---

void set_end_bone_direction(index: int, bone_direction: BoneDirection) 

Sets the end bone tail direction of the bone chain when is_end_bone_extended() is true.

---

void set_end_bone_name(index: int, bone_name: String) 

Sets the end bone name of the bone chain.

Note: The end bone must be a child of the root bone.

---

void set_extend_end_bone(index: int, enabled: bool) 

If enabled is true, the end bone is extended to have a tail.

If enabled is false, get_reference_bone() becomes a parent of the end bone and it uses the vector to the end bone as a twist axis.

---

void set_joint_twist_amount(index: int, joint: int, twist_amount: float) 

Sets the twist amount at joint in the bone chain's joint list when get_disperse_mode() is DISPERSE_MODE_CUSTOM.

---

void set_root_bone(index: int, bone: int) 

Sets the root bone index of the bone chain.

---

void set_root_bone_name(index: int, bone_name: String) 

Sets the root bone name of the bone chain.

---

void set_twist_from(index: int, from: Quaternion) 

Sets the rotation to an arbitrary state before twisting for the current bone pose to extract the twist when is_twist_from_rest() is false.

In other words, by calling set_twist_from() by SkeletonModifier3D.modification_processed of a specific SkeletonModifier3D, you can extract only the twists generated by modifiers processed after that but before this BoneTwistDisperser3D.

---

void set_twist_from_rest(index: int, enabled: bool) 

If enabled is true, it extracts the twist amount from the difference between the bone rest and the current bone pose.

If enabled is false, it extracts the twist amount from the difference between get_twist_from() and the current bone pose. See also set_twist_from().

---

void set_weight_position(index: int, weight_position: float) 

Sets the position at which to divide the segment between joints for weight assignment when get_disperse_mode() is DISPERSE_MODE_WEIGHTED.

For example, when weight_position is 0.5, if two bone segments with a length of 1.0 exist between three joints, weights are assigned to each joint from root to end at ratios of 0.5, 1.0, and 0.5. Then amounts become 0.25, 0.75, and 1.0 respectively.
