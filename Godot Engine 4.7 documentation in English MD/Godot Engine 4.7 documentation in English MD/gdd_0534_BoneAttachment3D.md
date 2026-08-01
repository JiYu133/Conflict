# BoneAttachment3D

Inherits: Node3D < Node < Object

А node that dynamically copies or overrides the 3D transform of a bone in its parent Skeleton3D.

## Description

This node selects a bone in a Skeleton3D and attaches to it. This means that the BoneAttachment3D node will either dynamically copy or override the 3D transform of the selected bone.

## Properties

int | bone_idx | -1
String | bone_name | ""
NodePath | external_skeleton |
bool | override_pose | false
PhysicsInterpolationMode | physics_interpolation_mode | 2 (overrides Node)
bool | use_external_skeleton | false

## Methods

Skeleton3D | get_skeleton()
void | on_skeleton_update()

---

## Property Descriptions

int bone_idx = -1 

- void set_bone_idx(value: int)
- int get_bone_idx()

The index of the attached bone.

---

String bone_name = "" 

- void set_bone_name(value: String)
- String get_bone_name()

The name of the attached bone.

---

NodePath external_skeleton 

- void set_external_skeleton(value: NodePath)
- NodePath get_external_skeleton()

The NodePath to the external Skeleton3D node.

---

bool override_pose = false 

- void set_override_pose(value: bool)
- bool get_override_pose()

Whether the BoneAttachment3D node will override the bone pose of the bone it is attached to. When set to true, the BoneAttachment3D node can change the pose of the bone. When set to false, the BoneAttachment3D will always be set to the bone's transform.

Note: This override performs interruptively in the skeleton update process using signals due to the old design. It may cause unintended behavior when used at the same time with SkeletonModifier3D.

---

bool use_external_skeleton = false 

- void set_use_external_skeleton(value: bool)
- bool get_use_external_skeleton()

Whether the BoneAttachment3D node will use an external Skeleton3D node rather than attempting to use its parent node as the Skeleton3D. When set to true, the BoneAttachment3D node will use the external Skeleton3D node set in external_skeleton.

---

## Method Descriptions

Skeleton3D get_skeleton() 

Returns the parent or external Skeleton3D node if it exists, otherwise returns null.

---

void on_skeleton_update() 

A function that is called automatically when the Skeleton3D is updated. This function is where the BoneAttachment3D node updates its position so it is correctly bound when it is not set to override the bone pose.
