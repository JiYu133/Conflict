# CopyTransformModifier3D

Inherits: BoneConstraint3D < SkeletonModifier3D < Node3D < Node < Object

A SkeletonModifier3D that apply transform to the bone which copied from reference.

## Description

Apply the copied transform of the bone set by BoneConstraint3D.set_reference_bone() to the bone set by BoneConstraint3D.set_apply_bone() with processing it with some masks and options.

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

## Properties

int | setting_count | 0

## Methods

BitField[AxisFlag] | get_axis_flags(index: int) const
BitField[TransformFlag] | get_copy_flags(index: int) const
BitField[AxisFlag] | get_invert_flags(index: int) const
bool | is_additive(index: int) const
bool | is_axis_x_enabled(index: int) const
bool | is_axis_x_inverted(index: int) const
bool | is_axis_y_enabled(index: int) const
bool | is_axis_y_inverted(index: int) const
bool | is_axis_z_enabled(index: int) const
bool | is_axis_z_inverted(index: int) const
bool | is_position_copying(index: int) const
bool | is_relative(index: int) const
bool | is_rotation_copying(index: int) const
bool | is_scale_copying(index: int) const
void | set_additive(index: int, enabled: bool)
void | set_axis_flags(index: int, axis_flags: BitField[AxisFlag])
void | set_axis_x_enabled(index: int, enabled: bool)
void | set_axis_x_inverted(index: int, enabled: bool)
void | set_axis_y_enabled(index: int, enabled: bool)
void | set_axis_y_inverted(index: int, enabled: bool)
void | set_axis_z_enabled(index: int, enabled: bool)
void | set_axis_z_inverted(index: int, enabled: bool)
void | set_copy_flags(index: int, copy_flags: BitField[TransformFlag])
void | set_copy_position(index: int, enabled: bool)
void | set_copy_rotation(index: int, enabled: bool)
void | set_copy_scale(index: int, enabled: bool)
void | set_invert_flags(index: int, axis_flags: BitField[AxisFlag])
void | set_relative(index: int, enabled: bool)

---

## Enumerations

flags TransformFlag: 

TransformFlag TRANSFORM_FLAG_POSITION = 1

If set, allows to copy the position.

TransformFlag TRANSFORM_FLAG_ROTATION = 2

If set, allows to copy the rotation.

TransformFlag TRANSFORM_FLAG_SCALE = 4

If set, allows to copy the scale.

TransformFlag TRANSFORM_FLAG_ALL = 7

If set, allows to copy the position/rotation/scale.

---

flags AxisFlag: 

AxisFlag AXIS_FLAG_X = 1

If set, allows to process the X-axis.

AxisFlag AXIS_FLAG_Y = 2

If set, allows to process the Y-axis.

AxisFlag AXIS_FLAG_Z = 4

If set, allows to process the Z-axis.

AxisFlag AXIS_FLAG_ALL = 7

If set, allows to process the all axes.

---

## Property Descriptions

int setting_count = 0 

- void set_setting_count(value: int)
- int get_setting_count()

The number of settings in the modifier.

---

## Method Descriptions

BitField[AxisFlag] get_axis_flags(index: int) const 

Returns the axis flags of the setting at index.

---

BitField[TransformFlag] get_copy_flags(index: int) const 

Returns the copy flags of the setting at index.

---

BitField[AxisFlag] get_invert_flags(index: int) const 

Returns the invert flags of the setting at index.

---

bool is_additive(index: int) const 

Returns true if the additive option is enabled in the setting at index.

---

bool is_axis_x_enabled(index: int) const 

Returns true if the enable flags has the flag for the X-axis in the setting at index. See also set_axis_flags().

---

bool is_axis_x_inverted(index: int) const 

Returns true if the invert flags has the flag for the X-axis in the setting at index. See also set_invert_flags().

---

bool is_axis_y_enabled(index: int) const 

Returns true if the enable flags has the flag for the Y-axis in the setting at index. See also set_axis_flags().

---

bool is_axis_y_inverted(index: int) const 

Returns true if the invert flags has the flag for the Y-axis in the setting at index. See also set_invert_flags().

---

bool is_axis_z_enabled(index: int) const 

Returns true if the enable flags has the flag for the Z-axis in the setting at index. See also set_axis_flags().

---

bool is_axis_z_inverted(index: int) const 

Returns true if the invert flags has the flag for the Z-axis in the setting at index. See also set_invert_flags().

---

bool is_position_copying(index: int) const 

Returns true if the copy flags has the flag for the position in the setting at index. See also set_copy_flags().

---

bool is_relative(index: int) const 

Returns true if the relative option is enabled in the setting at index.

---

bool is_rotation_copying(index: int) const 

Returns true if the copy flags has the flag for the rotation in the setting at index. See also set_copy_flags().

---

bool is_scale_copying(index: int) const 

Returns true if the copy flags has the flag for the scale in the setting at index. See also set_copy_flags().

---

void set_additive(index: int, enabled: bool) 

Sets additive option in the setting at index to enabled. This mainly affects the process of applying transform to the BoneConstraint3D.set_apply_bone().

If sets enabled to true, the processed transform is added to the pose of the current apply bone.

If sets enabled to false, the pose of the current apply bone is replaced with the processed transform. However, if set set_relative() to true, the transform is relative to rest.

---

void set_axis_flags(index: int, axis_flags: BitField[AxisFlag]) 

Sets the flags to copy axes. If the flag is valid, the axis is copied.

---

void set_axis_x_enabled(index: int, enabled: bool) 

If sets enabled to true, the X-axis will be copied.

---

void set_axis_x_inverted(index: int, enabled: bool) 

If sets enabled to true, the X-axis will be inverted.

---

void set_axis_y_enabled(index: int, enabled: bool) 

If sets enabled to true, the Y-axis will be copied.

---

void set_axis_y_inverted(index: int, enabled: bool) 

If sets enabled to true, the Y-axis will be inverted.

---

void set_axis_z_enabled(index: int, enabled: bool) 

If sets enabled to true, the Z-axis will be copied.

---

void set_axis_z_inverted(index: int, enabled: bool) 

If sets enabled to true, the Z-axis will be inverted.

---

void set_copy_flags(index: int, copy_flags: BitField[TransformFlag]) 

Sets the flags to process the transform operations. If the flag is valid, the transform operation is processed.

Note: If the rotation is valid for only one axis, it respects the roll of the valid axis. If the rotation is valid for two axes, it discards the roll of the invalid axis.

---

void set_copy_position(index: int, enabled: bool) 

If sets enabled to true, the position will be copied.

---

void set_copy_rotation(index: int, enabled: bool) 

If sets enabled to true, the rotation will be copied.

---

void set_copy_scale(index: int, enabled: bool) 

If sets enabled to true, the scale will be copied.

---

void set_invert_flags(index: int, axis_flags: BitField[AxisFlag]) 

Sets the flags to inverte axes. If the flag is valid, the axis is copied.

Note: An inverted scale means an inverse number, not a negative scale. For example, inverting 2.0 means 0.5.

Note: An inverted rotation flips the elements of the quaternion. For example, a two-axis inversion will flip the roll of each axis, and a three-axis inversion will flip the final orientation. However, be aware that flipping only one axis may cause unintended rotation by the unflipped axes, due to the characteristics of the quaternion.

---

void set_relative(index: int, enabled: bool) 

Sets relative option in the setting at index to enabled.

If sets enabled to true, the extracted and applying transform is relative to the rest.

If sets enabled to false, the extracted transform is absolute.
