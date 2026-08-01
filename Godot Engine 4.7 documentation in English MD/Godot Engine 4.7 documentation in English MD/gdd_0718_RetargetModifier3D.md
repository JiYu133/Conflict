# RetargetModifier3D

Inherits: SkeletonModifier3D < Node3D < Node < Object

A modifier to transfer parent skeleton poses (or global poses) to child skeletons in model space with different rests.

## Description

Retrieves the pose (or global pose) relative to the parent Skeleton's rest in model space and transfers it to the child Skeleton.

This modifier rewrites the pose of the child skeleton directly in the parent skeleton's update process. This means that it overwrites the mapped bone pose set in the normal process on the target skeleton. If you want to set the target skeleton bone pose after retargeting, you will need to add a SkeletonModifier3D child to the target skeleton and thereby modify the pose.

Note: When the use_global_pose is enabled, even if it is an unmapped bone, it can cause visual problems because the global pose is applied ignoring the parent bone's pose if it has mapped bone children. See also use_global_pose.

## Properties

BitField[TransformFlag] | enable | 7
SkeletonProfile | profile |
bool | use_global_pose | false

## Methods

bool | is_position_enabled() const
bool | is_rotation_enabled() const
bool | is_scale_enabled() const
void | set_position_enabled(enabled: bool)
void | set_rotation_enabled(enabled: bool)
void | set_scale_enabled(enabled: bool)

---

## Enumerations

flags TransformFlag: 

TransformFlag TRANSFORM_FLAG_POSITION = 1

If set, allows to retarget the position.

TransformFlag TRANSFORM_FLAG_ROTATION = 2

If set, allows to retarget the rotation.

TransformFlag TRANSFORM_FLAG_SCALE = 4

If set, allows to retarget the scale.

TransformFlag TRANSFORM_FLAG_ALL = 7

If set, allows to retarget the position/rotation/scale.

---

## Property Descriptions

BitField[TransformFlag] enable = 7 

- void set_enable_flags(value: BitField[TransformFlag])
- BitField[TransformFlag] get_enable_flags()

Flags to control the process of the transform elements individually when use_global_pose is disabled.

---

SkeletonProfile profile 

- void set_profile(value: SkeletonProfile)
- SkeletonProfile get_profile()

SkeletonProfile for retargeting bones with names matching the bone list.

---

bool use_global_pose = false 

- void set_use_global_pose(value: bool)
- bool is_using_global_pose()

If false, in case the target skeleton has fewer bones than the source skeleton, the source bone parent's transform will be ignored.

Instead, it is possible to retarget between models with different body shapes, and position, rotation, and scale can be retargeted separately.

If true, retargeting is performed taking into account global pose.

In case the target skeleton has fewer bones than the source skeleton, the source bone parent's transform is taken into account. However, bone length between skeletons must match exactly, if not, the bones will be forced to expand or shrink.

This is useful for using dummy bone with length 0 to match postures when retargeting between models with different number of bones.

---

## Method Descriptions

bool is_position_enabled() const 

Returns true if enable has TRANSFORM_FLAG_POSITION.

---

bool is_rotation_enabled() const 

Returns true if enable has TRANSFORM_FLAG_ROTATION.

---

bool is_scale_enabled() const 

Returns true if enable has TRANSFORM_FLAG_SCALE.

---

void set_position_enabled(enabled: bool) 

Sets TRANSFORM_FLAG_POSITION into enable.

---

void set_rotation_enabled(enabled: bool) 

Sets TRANSFORM_FLAG_ROTATION into enable.

---

void set_scale_enabled(enabled: bool) 

Sets TRANSFORM_FLAG_SCALE into enable.
