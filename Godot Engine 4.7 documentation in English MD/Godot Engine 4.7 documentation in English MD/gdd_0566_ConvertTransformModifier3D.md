# ConvertTransformModifier3D

Inherits: BoneConstraint3D < SkeletonModifier3D < Node3D < Node < Object

A SkeletonModifier3D that apply transform to the bone which converted from reference.

## Description

Apply the copied transform of the bone set by BoneConstraint3D.set_reference_bone() to the bone set by BoneConstraint3D.set_apply_bone() about the specific axis with remapping it with some options.

There are 4 ways to apply the transform, depending on the combination of set_relative() and set_additive().

Relative + Additive:

- Extract reference pose relative to the rest and add it to the apply bone's pose.

Relative + Not Additive:

- Extract reference pose relative to the rest and add it to the apply bone's rest.

Not Relative + Additive:

- Extract reference pose absolutely and add it to the apply bone's pose.

Not Relative + Not Additive:

- Extract reference pose absolutely and the apply bone's pose is replaced with it.

Note: Relative option is available only in the case BoneConstraint3D.get_reference_type() is BoneConstraint3D.REFERENCE_TYPE_BONE. See also ReferenceType.

Note: If there is a rotation greater than 180 degrees with constrained axes, flipping may occur.

## Properties

int | setting_count | 0

## Methods

Axis | get_apply_axis(index: int) const
float | get_apply_range_max(index: int) const
float | get_apply_range_min(index: int) const
TransformMode | get_apply_transform_mode(index: int) const
Axis | get_reference_axis(index: int) const
float | get_reference_range_max(index: int) const
float | get_reference_range_min(index: int) const
TransformMode | get_reference_transform_mode(index: int) const
bool | is_additive(index: int) const
bool | is_relative(index: int) const
void | set_additive(index: int, enabled: bool)
void | set_apply_axis(index: int, axis: Axis)
void | set_apply_range_max(index: int, range_max: float)
void | set_apply_range_min(index: int, range_min: float)
void | set_apply_transform_mode(index: int, transform_mode: TransformMode)
void | set_reference_axis(index: int, axis: Axis)
void | set_reference_range_max(index: int, range_max: float)
void | set_reference_range_min(index: int, range_min: float)
void | set_reference_transform_mode(index: int, transform_mode: TransformMode)
void | set_relative(index: int, enabled: bool)

---

## Enumerations

enum TransformMode
TransformMode TRANSFORM_MODE_POSITION = 0

Convert with position. Transfer the difference.

TransformMode TRANSFORM_MODE_ROTATION = 1

Convert with rotation. The angle is the roll for the specified axis.

TransformMode TRANSFORM_MODE_SCALE = 2

Convert with scale. Transfers the ratio, not the difference.

---

## Property Descriptions

int setting_count = 0 

- void set_setting_count(value: int)
- int get_setting_count()

The number of settings in the modifier.

---

## Method Descriptions

Axis get_apply_axis(index: int) const 

Returns the axis of the remapping destination transform.

---

float get_apply_range_max(index: int) const 

Returns the maximum value of the remapping destination range.

---

float get_apply_range_min(index: int) const 

Returns the minimum value of the remapping destination range.

---

TransformMode get_apply_transform_mode(index: int) const 

Returns the operation of the remapping destination transform.

---

Axis get_reference_axis(index: int) const 

Returns the axis of the remapping source transform.

---

float get_reference_range_max(index: int) const 

Returns the maximum value of the remapping source range.

---

float get_reference_range_min(index: int) const 

Returns the minimum value of the remapping source range.

---

TransformMode get_reference_transform_mode(index: int) const 

Returns the operation of the remapping source transform.

---

bool is_additive(index: int) const 

Returns true if the additive option is enabled in the setting at index.

---

bool is_relative(index: int) const 

Returns true if the relative option is enabled in the setting at index.

---

void set_additive(index: int, enabled: bool) 

Sets additive option in the setting at index to enabled. This mainly affects the process of applying transform to the BoneConstraint3D.set_apply_bone().

If sets enabled to true, the processed transform is added to the pose of the current apply bone.

If sets enabled to false, the pose of the current apply bone is replaced with the processed transform. However, if set set_relative() to true, the transform is relative to rest.

---

void set_apply_axis(index: int, axis: Axis) 

Sets the axis of the remapping destination transform.

---

void set_apply_range_max(index: int, range_max: float) 

Sets the maximum value of the remapping destination range.

---

void set_apply_range_min(index: int, range_min: float) 

Sets the minimum value of the remapping destination range.

---

void set_apply_transform_mode(index: int, transform_mode: TransformMode) 

Sets the operation of the remapping destination transform.

---

void set_reference_axis(index: int, axis: Axis) 

Sets the axis of the remapping source transform.

---

void set_reference_range_max(index: int, range_max: float) 

Sets the maximum value of the remapping source range.

---

void set_reference_range_min(index: int, range_min: float) 

Sets the minimum value of the remapping source range.

---

void set_reference_transform_mode(index: int, transform_mode: TransformMode) 

Sets the operation of the remapping source transform.

---

void set_relative(index: int, enabled: bool) 

Sets relative option in the setting at index to enabled.

If sets enabled to true, the extracted and applying transform is relative to the rest.

If sets enabled to false, the extracted transform is absolute.
