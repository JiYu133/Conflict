# SpringBoneCollision3D

Inherits: Node3D < Node < Object

Inherited By: SpringBoneCollisionCapsule3D, SpringBoneCollisionPlane3D, SpringBoneCollisionSphere3D

A base class of the collision that interacts with SpringBoneSimulator3D.

## Description

A collision can be a child of SpringBoneSimulator3D. If it is not a child of SpringBoneSimulator3D, it has no effect.

The colliding and sliding are done in the SpringBoneSimulator3D's modification process in order of its collision list which is set by SpringBoneSimulator3D.set_collision_path(). If SpringBoneSimulator3D.are_all_child_collisions_enabled() is true, the order matches SceneTree.

If bone is set, it synchronizes with the bone pose of the ancestor Skeleton3D, which is done in before the SpringBoneSimulator3D's modification process as the pre-process.

Warning: A scaled SpringBoneCollision3D will likely not behave as expected. Make sure that the parent Skeleton3D and its bones are not scaled.

## Properties

int | bone | -1
String | bone_name | ""
Vector3 | position_offset |
Quaternion | rotation_offset |

## Methods

Skeleton3D | get_skeleton() const

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

---

Vector3 position_offset 

- void set_position_offset(value: Vector3)
- Vector3 get_position_offset()

The offset of the position from Skeleton3D's bone pose position.

---

Quaternion rotation_offset 

- void set_rotation_offset(value: Quaternion)
- Quaternion get_rotation_offset()

The offset of the rotation from Skeleton3D's bone pose rotation.

---

## Method Descriptions

Skeleton3D get_skeleton() const 

Get parent Skeleton3D node of the parent SpringBoneSimulator3D if found.
