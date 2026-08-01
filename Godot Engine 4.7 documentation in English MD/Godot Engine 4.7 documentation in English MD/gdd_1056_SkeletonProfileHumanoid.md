# SkeletonProfileHumanoid

Inherits: SkeletonProfile < Resource < RefCounted < Object

A humanoid SkeletonProfile preset.

## Description

A SkeletonProfile as a preset that is optimized for the human form. This exists for standardization, so all parameters are read-only.

A humanoid skeleton profile contains 56 bones divided into 4 groups: "Body", "Face", "LeftHand", and "RightHand". It is structured as follows:

```
Root
└─ Hips
    ├─ LeftUpperLeg
    │  └─ LeftLowerLeg
    │     └─ LeftFoot
    │        └─ LeftToes
    ├─ RightUpperLeg
    │  └─ RightLowerLeg
    │     └─ RightFoot
    │        └─ RightToes
    └─ Spine
        └─ Chest
            └─ UpperChest
                ├─ Neck
                │   └─ Head
                │       ├─ Jaw
                │       ├─ LeftEye
                │       └─ RightEye
                ├─ LeftShoulder
                │  └─ LeftUpperArm
                │     └─ LeftLowerArm
                │        └─ LeftHand
                │           ├─ LeftThumbMetacarpal
                │           │  └─ LeftThumbProximal
                │           │    └─ LeftThumbDistal
                │           ├─ LeftIndexProximal
                │           │  └─ LeftIndexIntermediate
                │           │    └─ LeftIndexDistal
                │           ├─ LeftMiddleProximal
                │           │  └─ LeftMiddleIntermediate
                │           │    └─ LeftMiddleDistal
                │           ├─ LeftRingProximal
                │           │  └─ LeftRingIntermediate
                │           │    └─ LeftRingDistal
                │           └─ LeftLittleProximal
                │              └─ LeftLittleIntermediate
                │                └─ LeftLittleDistal
                └─ RightShoulder
                   └─ RightUpperArm
                      └─ RightLowerArm
                         └─ RightHand
                            ├─ RightThumbMetacarpal
                            │  └─ RightThumbProximal
                            │     └─ RightThumbDistal
                            ├─ RightIndexProximal
                            │  └─ RightIndexIntermediate
                            │     └─ RightIndexDistal
                            ├─ RightMiddleProximal
                            │  └─ RightMiddleIntermediate
                            │     └─ RightMiddleDistal
                            ├─ RightRingProximal
                            │  └─ RightRingIntermediate
                            │     └─ RightRingDistal
                            └─ RightLittleProximal
                               └─ RightLittleIntermediate
                                 └─ RightLittleDistal
```

## Tutorials

- Retargeting 3D Skeletons

## Properties

int | bone_size | 56 (overrides SkeletonProfile)
int | group_size | 4 (overrides SkeletonProfile)
StringName | root_bone | &"Root" (overrides SkeletonProfile)
StringName | scale_base_bone | &"Hips" (overrides SkeletonProfile)
