# AimModifier3D

Inherits: BoneConstraint3D < SkeletonModifier3D < Node3D < Node < Object

The AimModifier3D rotates a bone to look at a reference bone.

## Description

This is a simple version of LookAtModifier3D that only allows bone to the reference without advanced options such as angle limitation or time-based interpolation.

The feature is simplified, but instead it is implemented with smooth tracking without euler, see set_use_euler().

## Properties

int | setting_count | 0

## Methods

BoneAxis | get_forward_axis(index: int) const
Axis | get_primary_rotation_axis(index: int) const
bool | is_relative(index: int) const
bool | is_using_euler(index: int) const
bool | is_using_secondary_rotation(index: int) const
void | set_forward_axis(index: int, axis: BoneAxis)
void | set_primary_rotation_axis(index: int, axis: Axis)
void | set_relative(index: int, enabled: bool)
void | set_use_euler(index: int, enabled: bool)
void | set_use_secondary_rotation(index: int, enabled: bool)

---

## Property Descriptions

int setting_count = 0 

- void set_setting_count(value: int)
- int get_setting_count()

The number of settings in the modifier.

---

## Method Descriptions

BoneAxis get_forward_axis(index: int) const 

Returns the forward axis of the bone.

---

Axis get_primary_rotation_axis(index: int) const 

Returns the axis of the first rotation. It is enabled only if is_using_euler() is true.

---

bool is_relative(index: int) const 

Returns true if the relative option is enabled in the setting at index.

---

bool is_using_euler(index: int) const 

Returns true if it provides rotation with using euler.

---

bool is_using_secondary_rotation(index: int) const 

Returns true if it provides rotation by two axes. It is enabled only if is_using_euler() is true.

---

void set_forward_axis(index: int, axis: BoneAxis) 

Sets the forward axis of the bone.

---

void set_primary_rotation_axis(index: int, axis: Axis) 

Sets the axis of the first rotation. It is enabled only if is_using_euler() is true.

---

void set_relative(index: int, enabled: bool) 

Sets relative option in the setting at index to enabled.

If sets enabled to true, the rotation is applied relative to the pose.

If sets enabled to false, the rotation is applied relative to the rest. It means to replace the current pose with the AimModifier3D's result.

---

void set_use_euler(index: int, enabled: bool) 

If sets enabled to true, it provides rotation with using euler.

If sets enabled to false, it provides rotation with using rotation by arc generated from the forward axis vector and the vector toward the reference.

---

void set_use_secondary_rotation(index: int, enabled: bool) 

If sets enabled to true, it provides rotation by two axes. It is enabled only if is_using_euler() is true.
