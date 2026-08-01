# XRHandModifier3D

Inherits: SkeletonModifier3D < Node3D < Node < Object

A node for driving hand meshes from XRHandTracker data.

## Description

This node uses hand tracking data from an XRHandTracker to pose the skeleton of a hand mesh.

Positioning of hands is performed by creating an XRNode3D ancestor of the hand mesh driven by the same XRHandTracker.

The hand tracking position-data is scaled by Skeleton3D.motion_scale when applied to the skeleton, which can be used to adjust the tracked hand to match the scale of the hand model.

## Tutorials

- XR documentation index

## Properties

BoneUpdate | bone_update | 0
StringName | hand_tracker | &"/user/hand_tracker/left"

---

## Enumerations

enum BoneUpdate
BoneUpdate BONE_UPDATE_FULL = 0

The skeleton's bones are fully updated (both position and rotation) to match the tracked bones.

BoneUpdate BONE_UPDATE_ROTATION_ONLY = 1

The skeleton's bones are only rotated to align with the tracked bones, preserving bone length.

BoneUpdate BONE_UPDATE_MAX = 2

Represents the size of the BoneUpdate enum.

---

## Property Descriptions

BoneUpdate bone_update = 0 

- void set_bone_update(value: BoneUpdate)
- BoneUpdate get_bone_update()

Specifies the type of updates to perform on the bones.

---

StringName hand_tracker = &"/user/hand_tracker/left" 

- void set_hand_tracker(value: StringName)
- StringName get_hand_tracker()

The name of the XRHandTracker registered with XRServer to obtain the hand tracking data from.
