# LimitAngularVelocityModifier3D

Inherits: SkeletonModifier3D < Node3D < Node < Object

Limit bone rotation angular velocity.

## Description

This modifier limits bone rotation angular velocity by comparing poses between previous and current frame.

You can add bone chains by specifying their root and end bones, then add the bones between them to a list. Modifier processes either that list or the bones excluding those in the list depending on the option exclude.

Note: Most methods in this class take an index parameter. This parameter specifies which setting list entry to return if the IK has multiple entries (e.g. settings//root_bone_name).

## Properties

int | chain_count | 0
bool | exclude | false
int | joint_count | 0
float | max_angular_velocity | 6.2831855

## Methods

void | clear_chains()
int | get_end_bone(index: int) const
String | get_end_bone_name(index: int) const
int | get_root_bone(index: int) const
String | get_root_bone_name(index: int) const
void | reset()
void | set_end_bone(index: int, bone: int)
void | set_end_bone_name(index: int, bone_name: String)
void | set_root_bone(index: int, bone: int)
void | set_root_bone_name(index: int, bone_name: String)

---

## Property Descriptions

int chain_count = 0 

- void set_chain_count(value: int)
- int get_chain_count()

The number of chains.

---

bool exclude = false 

- void set_exclude(value: bool)
- bool is_exclude()

If true, the modifier processes bones not included in the bone list.

If false, the bones processed by the modifier are equal to the bone list.

---

int joint_count = 0 

The number of joints in the list which created by chains dynamically.

---

float max_angular_velocity = 6.2831855 

- void set_max_angular_velocity(value: float)
- float get_max_angular_velocity()

The maximum angular velocity per second.

---

## Method Descriptions

void clear_chains() 

Clear all chains.

---

int get_end_bone(index: int) const 

Returns the end bone index of the bone chain.

---

String get_end_bone_name(index: int) const 

Returns the end bone name of the bone chain.

---

int get_root_bone(index: int) const 

Returns the root bone index of the bone chain.

---

String get_root_bone_name(index: int) const 

Returns the root bone name of the bone chain.

---

void reset() 

Sets the reference pose for angle comparison to the current pose with the influence of constraints removed. This function is automatically triggered when joints change or upon activation.

---

void set_end_bone(index: int, bone: int) 

Sets the end bone index of the bone chain.

---

void set_end_bone_name(index: int, bone_name: String) 

Sets the end bone name of the bone chain.

Note: End bone must be the root bone or a child of the root bone.

---

void set_root_bone(index: int, bone: int) 

Sets the root bone index of the bone chain.

---

void set_root_bone_name(index: int, bone_name: String) 

Sets the root bone name of the bone chain.
