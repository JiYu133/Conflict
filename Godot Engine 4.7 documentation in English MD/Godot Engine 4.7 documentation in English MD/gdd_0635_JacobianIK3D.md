# JacobianIK3D

Inherits: IterateIK3D < ChainIK3D < IKModifier3D < SkeletonModifier3D < Node3D < Node < Object

Jacobian transpose based inverse kinematics solver.

## Description

JacobianIK3D calculates rotations for all joints simultaneously, producing natural and smooth movement. It is particularly suited for biological animations.

The resulting twist around the forward vector will always be kept from the previous pose.

Note: It converges more slowly than other IK solvers, leading to gentler and less immediate tracking of targets.
