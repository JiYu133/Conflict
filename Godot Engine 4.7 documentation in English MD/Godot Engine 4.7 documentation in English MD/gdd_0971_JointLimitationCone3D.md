# JointLimitationCone3D

Inherits: JointLimitation3D < Resource < RefCounted < Object

A cone shape limitation that interacts with ChainIK3D.

## Description

A cone shape limitation that interacts with ChainIK3D.

## Properties

float | angle | 1.5707964

---

## Property Descriptions

float angle = 1.5707964 

- void set_angle(value: float)
- float get_angle()

The radius range of the hole made by the cone.

0 degrees makes a sphere without hole, 180 degrees makes a hemisphere, and 360 degrees become empty (no limitation).
