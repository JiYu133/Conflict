# ModifierBoneTarget3D

Inherits: SkeletonModifier3D < Node3D < Node < Object

А node that dynamically copies the 3D transform of a bone in its parent Skeleton3D.

## Description

This node selects a bone in a Skeleton3D and attaches to it. This means that the ModifierBoneTarget3D node will dynamically copy the 3D transform of the selected bone.

The functionality is similar to BoneAttachment3D, but this node adopts the SkeletonModifier3D cycle and is intended to be used as another SkeletonModifier3D's target.

## Properties

int | bone | -1
String | bone_name | ""

---

## Property Descriptions

int bone = -1 

- void set_bone(value: int)
- int get_bone()

The index of the attached bone.

---

String bone_name = "" 

- void set_bone_name(value: String)
- String get_bone_name()

The name of the attached bone.
