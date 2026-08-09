# BoneConstraint3D

Inherits: SkeletonModifier3D < Node3D < Node < Object

Inherited By: AimModifier3D, ConvertTransformModifier3D, CopyTransformModifier3D

A node that may modify Skeleton3D's bone with associating the two bones.

## Description

Base class of SkeletonModifier3D that modifies the bone set in set_apply_bone() based on the transform of the bone retrieved by get_reference_bone().

Note: Most methods in this class take an index parameter. This parameter specifies which setting list entry to return if the IK has multiple entries (e.g. settings//amount).

## Methods

void | clear_setting()
float | get_amount(index: int) const
int | get_apply_bone(index: int) const
String | get_apply_bone_name(index: int) const
int | get_reference_bone(index: int) const
String | get_reference_bone_name(index: int) const
NodePath | get_reference_node(index: int) const
ReferenceType | get_reference_type(index: int) const
int | get_setting_count() const
void | set_amount(index: int, amount: float)
void | set_apply_bone(index: int, bone: int)
void | set_apply_bone_name(index: int, bone_name: String)
void | set_reference_bone(index: int, bone: int)
void | set_reference_bone_name(index: int, bone_name: String)
void | set_reference_node(index: int, node: NodePath)
void | set_reference_type(index: int, type: ReferenceType)
void | set_setting_count(count: int)

---

## Enumerations

enum ReferenceType
ReferenceType REFERENCE_TYPE_BONE = 0

The reference target is a bone. In this case, the reference target spaces is local space.

ReferenceType REFERENCE_TYPE_NODE = 1

The reference target is a Node3D. In this case, the reference target spaces is model space.

In other words, the reference target's coordinates are treated as if it were placed directly under Skeleton3D which parent of the BoneConstraint3D.

---

## Method Descriptions

void clear_setting() 

Clear all settings.

---

float get_amount(index: int) const 

Returns the apply amount of the setting at index.

---

int get_apply_bone(index: int) const 

Returns the apply bone of the setting at index. This bone will be modified.

---

String get_apply_bone_name(index: int) const 

Returns the apply bone name of the setting at index. This bone will be modified.

---

int get_reference_bone(index: int) const 

Returns the reference bone of the setting at index.

This bone will be only referenced and not modified by this modifier.

---

String get_reference_bone_name(index: int) const 

Returns the reference bone name of the setting at index.

This bone will be only referenced and not modified by this modifier.

---

NodePath get_reference_node(index: int) const 

Returns the reference node path of the setting at index.

This node will be only referenced and not modified by this modifier.

---

ReferenceType get_reference_type(index: int) const 

Returns the reference target type of the setting at index. See also ReferenceType.

---

int get_setting_count() const 

Returns the number of settings in the modifier.

---

void set_amount(index: int, amount: float) 

Sets the apply amount of the setting at index to amount.

---

void set_apply_bone(index: int, bone: int) 

Sets the apply bone of the setting at index to bone. This bone will be modified.

---

void set_apply_bone_name(index: int, bone_name: String) 

Sets the apply bone of the setting at index to bone_name. This bone will be modified.

---

void set_reference_bone(index: int, bone: int) 

Sets the reference bone of the setting at index to bone.

This bone will be only referenced and not modified by this modifier.

---

void set_reference_bone_name(index: int, bone_name: String) 

Sets the reference bone of the setting at index to bone_name.

This bone will be only referenced and not modified by this modifier.

---

void set_reference_node(index: int, node: NodePath) 

Sets the reference node path of the setting at index to node.

This node will be only referenced and not modified by this modifier.

---

void set_reference_type(index: int, type: ReferenceType) 

Sets the reference target type of the setting at index to type. See also ReferenceType.

---

void set_setting_count(count: int) 

Sets the number of settings in the modifier.
