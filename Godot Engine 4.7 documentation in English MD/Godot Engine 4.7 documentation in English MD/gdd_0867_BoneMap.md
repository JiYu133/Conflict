# BoneMap

Inherits: Resource < RefCounted < Object

Describes a mapping of bone names for retargeting Skeleton3D into common names defined by a SkeletonProfile.

## Description

This class contains a dictionary that uses a list of bone names in SkeletonProfile as key names.

By assigning the actual Skeleton3D bone name as the key value, it maps the Skeleton3D to the SkeletonProfile.

## Tutorials

- Retargeting 3D Skeletons

## Properties

SkeletonProfile | profile

## Methods

StringName | find_profile_bone_name(skeleton_bone_name: StringName) const
StringName | get_skeleton_bone_name(profile_bone_name: StringName) const
void | set_skeleton_bone_name(profile_bone_name: StringName, skeleton_bone_name: StringName)

---

## Signals

bone_map_updated() 

This signal is emitted when change the key value in the BoneMap. This is used to validate mapping and to update BoneMap editor.

---

profile_updated() 

This signal is emitted when change the value in profile or change the reference of profile. This is used to update key names in the BoneMap and to redraw the BoneMap editor.

---

## Property Descriptions

SkeletonProfile profile 

- void set_profile(value: SkeletonProfile)
- SkeletonProfile get_profile()

A SkeletonProfile of the mapping target. Key names in the BoneMap are synchronized with it.

---

## Method Descriptions

StringName find_profile_bone_name(skeleton_bone_name: StringName) const 

Returns a profile bone name having skeleton_bone_name. If not found, an empty StringName will be returned.

In the retargeting process, the returned bone name is the bone name of the target skeleton.

---

StringName get_skeleton_bone_name(profile_bone_name: StringName) const 

Returns a skeleton bone name is mapped to profile_bone_name.

In the retargeting process, the returned bone name is the bone name of the source skeleton.

---

void set_skeleton_bone_name(profile_bone_name: StringName, skeleton_bone_name: StringName) 

Maps a skeleton bone name to profile_bone_name.

In the retargeting process, the setting bone name is the bone name of the source skeleton.
