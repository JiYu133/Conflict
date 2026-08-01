# XRHandTracker

Inherits: XRPositionalTracker < XRTracker < RefCounted < Object

A tracked hand in XR.

## Description

A hand tracking system will create an instance of this object and add it to the XRServer. This tracking system will then obtain skeleton data, convert it to the Godot Humanoid hand skeleton and store this data on the XRHandTracker object.

Use XRHandModifier3D to animate a hand mesh using hand tracking data.

## Tutorials

- XR documentation index

## Properties

TrackerHand | hand | 1 (overrides XRPositionalTracker)
HandTrackingSource | hand_tracking_source | 0
bool | has_tracking_data | false
TrackerType | type | 16 (overrides XRTracker)

## Methods

Vector3 | get_hand_joint_angular_velocity(joint: HandJoint) const
BitField[HandJointFlags] | get_hand_joint_flags(joint: HandJoint) const
Vector3 | get_hand_joint_linear_velocity(joint: HandJoint) const
float | get_hand_joint_radius(joint: HandJoint) const
Transform3D | get_hand_joint_transform(joint: HandJoint) const
void | set_hand_joint_angular_velocity(joint: HandJoint, angular_velocity: Vector3)
void | set_hand_joint_flags(joint: HandJoint, flags: BitField[HandJointFlags])
void | set_hand_joint_linear_velocity(joint: HandJoint, linear_velocity: Vector3)
void | set_hand_joint_radius(joint: HandJoint, radius: float)
void | set_hand_joint_transform(joint: HandJoint, transform: Transform3D)

---

## Enumerations

enum HandTrackingSource
HandTrackingSource HAND_TRACKING_SOURCE_UNKNOWN = 0

The source of hand tracking data is unknown.

HandTrackingSource HAND_TRACKING_SOURCE_UNOBSTRUCTED = 1

The source of hand tracking data is unobstructed, meaning that an accurate method of hand tracking is used. These include optical hand tracking, data gloves, etc.

HandTrackingSource HAND_TRACKING_SOURCE_CONTROLLER = 2

The source of hand tracking data is a controller, meaning that joint positions are inferred from controller inputs.

HandTrackingSource HAND_TRACKING_SOURCE_NOT_TRACKED = 3

No hand tracking data is tracked, this either means the hand is obscured, the controller is turned off, or tracking is not supported for the current input type.

HandTrackingSource HAND_TRACKING_SOURCE_MAX = 4

Represents the size of the HandTrackingSource enum.

---

enum HandJoint
HandJoint HAND_JOINT_PALM = 0

Palm joint.

HandJoint HAND_JOINT_WRIST = 1

Wrist joint.

HandJoint HAND_JOINT_THUMB_METACARPAL = 2

Thumb metacarpal joint.

HandJoint HAND_JOINT_THUMB_PHALANX_PROXIMAL = 3

Thumb phalanx proximal joint.

HandJoint HAND_JOINT_THUMB_PHALANX_DISTAL = 4

Thumb phalanx distal joint.

HandJoint HAND_JOINT_THUMB_TIP = 5

Thumb tip joint.

HandJoint HAND_JOINT_INDEX_FINGER_METACARPAL = 6

Index finger metacarpal joint.

HandJoint HAND_JOINT_INDEX_FINGER_PHALANX_PROXIMAL = 7

Index finger phalanx proximal joint.

HandJoint HAND_JOINT_INDEX_FINGER_PHALANX_INTERMEDIATE = 8

Index finger phalanx intermediate joint.

HandJoint HAND_JOINT_INDEX_FINGER_PHALANX_DISTAL = 9

Index finger phalanx distal joint.

HandJoint HAND_JOINT_INDEX_FINGER_TIP = 10

Index finger tip joint.

HandJoint HAND_JOINT_MIDDLE_FINGER_METACARPAL = 11

Middle finger metacarpal joint.

HandJoint HAND_JOINT_MIDDLE_FINGER_PHALANX_PROXIMAL = 12

Middle finger phalanx proximal joint.

HandJoint HAND_JOINT_MIDDLE_FINGER_PHALANX_INTERMEDIATE = 13

Middle finger phalanx intermediate joint.

HandJoint HAND_JOINT_MIDDLE_FINGER_PHALANX_DISTAL = 14

Middle finger phalanx distal joint.

HandJoint HAND_JOINT_MIDDLE_FINGER_TIP = 15

Middle finger tip joint.

HandJoint HAND_JOINT_RING_FINGER_METACARPAL = 16

Ring finger metacarpal joint.

HandJoint HAND_JOINT_RING_FINGER_PHALANX_PROXIMAL = 17

Ring finger phalanx proximal joint.

HandJoint HAND_JOINT_RING_FINGER_PHALANX_INTERMEDIATE = 18

Ring finger phalanx intermediate joint.

HandJoint HAND_JOINT_RING_FINGER_PHALANX_DISTAL = 19

Ring finger phalanx distal joint.

HandJoint HAND_JOINT_RING_FINGER_TIP = 20

Ring finger tip joint.

HandJoint HAND_JOINT_PINKY_FINGER_METACARPAL = 21

Pinky finger metacarpal joint.

HandJoint HAND_JOINT_PINKY_FINGER_PHALANX_PROXIMAL = 22

Pinky finger phalanx proximal joint.

HandJoint HAND_JOINT_PINKY_FINGER_PHALANX_INTERMEDIATE = 23

Pinky finger phalanx intermediate joint.

HandJoint HAND_JOINT_PINKY_FINGER_PHALANX_DISTAL = 24

Pinky finger phalanx distal joint.

HandJoint HAND_JOINT_PINKY_FINGER_TIP = 25

Pinky finger tip joint.

HandJoint HAND_JOINT_MAX = 26

Represents the size of the HandJoint enum.

---

flags HandJointFlags: 

HandJointFlags HAND_JOINT_FLAG_ORIENTATION_VALID = 1

The hand joint's orientation data is valid.

HandJointFlags HAND_JOINT_FLAG_ORIENTATION_TRACKED = 2

The hand joint's orientation is actively tracked. May not be set if tracking has been temporarily lost.

HandJointFlags HAND_JOINT_FLAG_POSITION_VALID = 4

The hand joint's position data is valid.

HandJointFlags HAND_JOINT_FLAG_POSITION_TRACKED = 8

The hand joint's position is actively tracked. May not be set if tracking has been temporarily lost.

HandJointFlags HAND_JOINT_FLAG_LINEAR_VELOCITY_VALID = 16

The hand joint's linear velocity data is valid.

HandJointFlags HAND_JOINT_FLAG_ANGULAR_VELOCITY_VALID = 32

The hand joint's angular velocity data is valid.

---

## Property Descriptions

HandTrackingSource hand_tracking_source = 0 

- void set_hand_tracking_source(value: HandTrackingSource)
- HandTrackingSource get_hand_tracking_source()

The source of the hand tracking data.

---

bool has_tracking_data = false 

- void set_has_tracking_data(value: bool)
- bool get_has_tracking_data()

If true, the hand tracking data is valid.

---

## Method Descriptions

Vector3 get_hand_joint_angular_velocity(joint: HandJoint) const 

Returns the angular velocity for the given hand joint.

---

BitField[HandJointFlags] get_hand_joint_flags(joint: HandJoint) const 

Returns flags about the validity of the tracking data for the given hand joint.

---

Vector3 get_hand_joint_linear_velocity(joint: HandJoint) const 

Returns the linear velocity for the given hand joint.

---

float get_hand_joint_radius(joint: HandJoint) const 

Returns the radius of the given hand joint.

---

Transform3D get_hand_joint_transform(joint: HandJoint) const 

Returns the transform for the given hand joint.

---

void set_hand_joint_angular_velocity(joint: HandJoint, angular_velocity: Vector3) 

Sets the angular velocity for the given hand joint.

---

void set_hand_joint_flags(joint: HandJoint, flags: BitField[HandJointFlags]) 

Sets flags about the validity of the tracking data for the given hand joint.

---

void set_hand_joint_linear_velocity(joint: HandJoint, linear_velocity: Vector3) 

Sets the linear velocity for the given hand joint.

---

void set_hand_joint_radius(joint: HandJoint, radius: float) 

Sets the radius of the given hand joint.

---

void set_hand_joint_transform(joint: HandJoint, transform: Transform3D) 

Sets the transform for the given hand joint.
