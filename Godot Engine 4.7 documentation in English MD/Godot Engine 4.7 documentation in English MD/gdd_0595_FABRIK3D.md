# FABRIK3D

Inherits: IterateIK3D < ChainIK3D < IKModifier3D < SkeletonModifier3D < Node3D < Node < Object

Position based forward and backward reaching inverse kinematics solver.

## Description

FABRIK3D is position based IK, allowing precise and accurate tracking of targets. It's ideal for simple chains without limitations.

The resulting twist around the forward vector will always be kept from the previous pose.

Note: When the target is close to the root, it tends to produce zig-zag patterns, resulting in unnatural visual movement.

## Tutorials

- Inverse Kinematics Returns to Godot 4.6 - IKModifier3D [https://godotengine.org/article/inverse-kinematics-returns-to-godot-4-6/#ikmodifier3d-and-7-child-classes]
