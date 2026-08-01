# SkeletonProfile

Inherits: Resource < RefCounted < Object

Inherited By: SkeletonProfileHumanoid

Base class for a profile of a virtual skeleton used as a target for retargeting.

## Description

This resource is used in EditorScenePostImport. Some parameters are referring to bones in Skeleton3D, Skin, Animation, and some other nodes are rewritten based on the parameters of SkeletonProfile.

Note: These parameters need to be set only when creating a custom profile. In SkeletonProfileHumanoid, they are defined internally as read-only values.

## Tutorials

- Retargeting 3D Skeletons

## Properties

int | bone_size | 0
int | group_size | 0
StringName | root_bone | &""
StringName | scale_base_bone | &""

## Methods

int | find_bone(bone_name: StringName) const
StringName | get_bone_name(bone_idx: int) const
StringName | get_bone_parent(bone_idx: int) const
StringName | get_bone_tail(bone_idx: int) const
StringName | get_group(bone_idx: int) const
StringName | get_group_name(group_idx: int) const
Vector2 | get_handle_offset(bone_idx: int) const
Transform3D | get_reference_pose(bone_idx: int) const
TailDirection | get_tail_direction(bone_idx: int) const
Texture2D | get_texture(group_idx: int) const
bool | is_required(bone_idx: int) const
void | set_bone_name(bone_idx: int, bone_name: StringName)
void | set_bone_parent(bone_idx: int, bone_parent: StringName)
void | set_bone_tail(bone_idx: int, bone_tail: StringName)
void | set_group(bone_idx: int, group: StringName)
void | set_group_name(group_idx: int, group_name: StringName)
void | set_handle_offset(bone_idx: int, handle_offset: Vector2)
void | set_reference_pose(bone_idx: int, bone_name: Transform3D)
void | set_required(bone_idx: int, required: bool)
void | set_tail_direction(bone_idx: int, tail_direction: TailDirection)
void | set_texture(group_idx: int, texture: Texture2D)

---

## Signals

profile_updated() 

This signal is emitted when change the value in profile. This is used to update key name in the BoneMap and to redraw the BoneMap editor.

Note: This signal is not connected directly to editor to simplify the reference, instead it is passed on to editor through the BoneMap.

---

## Enumerations

enum TailDirection
TailDirection TAIL_DIRECTION_AVERAGE_CHILDREN = 0

Direction to the average coordinates of bone children.

TailDirection TAIL_DIRECTION_SPECIFIC_CHILD = 1

Direction to the coordinates of specified bone child.

TailDirection TAIL_DIRECTION_END = 2

Direction is not calculated.

---

## Property Descriptions

int bone_size = 0 

- void set_bone_size(value: int)
- int get_bone_size()

The amount of bones in retargeting section's BoneMap editor. For example, SkeletonProfileHumanoid has 56 bones.

The size of elements in BoneMap updates when changing this property in it's assigned SkeletonProfile.

---

int group_size = 0 

- void set_group_size(value: int)
- int get_group_size()

The amount of groups of bones in retargeting section's BoneMap editor. For example, SkeletonProfileHumanoid has 4 groups.

This property exists to separate the bone list into several sections in the editor.

---

StringName root_bone = &"" 

- void set_root_bone(value: StringName)
- StringName get_root_bone()

A bone name that will be used as the root bone in AnimationTree. This should be the bone of the parent of hips that exists at the world origin.

---

StringName scale_base_bone = &"" 

- void set_scale_base_bone(value: StringName)
- StringName get_scale_base_bone()

A bone name which will use model's height as the coefficient for normalization. For example, SkeletonProfileHumanoid defines it as Hips.

---

## Method Descriptions

int find_bone(bone_name: StringName) const 

Returns the bone index that matches bone_name as its name.

---

StringName get_bone_name(bone_idx: int) const 

Returns the name of the bone at bone_idx that will be the key name in the BoneMap.

In the retargeting process, the returned bone name is the bone name of the target skeleton.

---

StringName get_bone_parent(bone_idx: int) const 

Returns the name of the bone which is the parent to the bone at bone_idx. The result is empty if the bone has no parent.

---

StringName get_bone_tail(bone_idx: int) const 

Returns the name of the bone which is the tail of the bone at bone_idx.

---

StringName get_group(bone_idx: int) const 

Returns the group of the bone at bone_idx.

---

StringName get_group_name(group_idx: int) const 

Returns the name of the group at group_idx that will be the drawing group in the BoneMap editor.

---

Vector2 get_handle_offset(bone_idx: int) const 

Returns the offset of the bone at bone_idx that will be the button position in the BoneMap editor.

This is the offset with origin at the top left corner of the square.

---

Transform3D get_reference_pose(bone_idx: int) const 

Returns the reference pose transform for bone bone_idx.

---

TailDirection get_tail_direction(bone_idx: int) const 

Returns the tail direction of the bone at bone_idx.

---

Texture2D get_texture(group_idx: int) const 

Returns the texture of the group at group_idx that will be the drawing group background image in the BoneMap editor.

---

bool is_required(bone_idx: int) const 

Returns whether the bone at bone_idx is required for retargeting.

This value is used by the bone map editor. If this method returns true, and no bone is assigned, the handle color will be red on the bone map editor.

---

void set_bone_name(bone_idx: int, bone_name: StringName) 

Sets the name of the bone at bone_idx that will be the key name in the BoneMap.

In the retargeting process, the setting bone name is the bone name of the target skeleton.

---

void set_bone_parent(bone_idx: int, bone_parent: StringName) 

Sets the bone with name bone_parent as the parent of the bone at bone_idx. If an empty string is passed, then the bone has no parent.

---

void set_bone_tail(bone_idx: int, bone_tail: StringName) 

Sets the bone with name bone_tail as the tail of the bone at bone_idx.

---

void set_group(bone_idx: int, group: StringName) 

Sets the group of the bone at bone_idx.

---

void set_group_name(group_idx: int, group_name: StringName) 

Sets the name of the group at group_idx that will be the drawing group in the BoneMap editor.

---

void set_handle_offset(bone_idx: int, handle_offset: Vector2) 

Sets the offset of the bone at bone_idx that will be the button position in the BoneMap editor.

This is the offset with origin at the top left corner of the square.

---

void set_reference_pose(bone_idx: int, bone_name: Transform3D) 

Sets the reference pose transform for bone bone_idx.

---

void set_required(bone_idx: int, required: bool) 

Sets the required status for bone bone_idx to required.

---

void set_tail_direction(bone_idx: int, tail_direction: TailDirection) 

Sets the tail direction of the bone at bone_idx.

Note: This only specifies the method of calculation. The actual coordinates required should be stored in an external skeleton, so the calculation itself needs to be done externally.

---

void set_texture(group_idx: int, texture: Texture2D) 

Sets the texture of the group at group_idx that will be the drawing group background image in the BoneMap editor.
