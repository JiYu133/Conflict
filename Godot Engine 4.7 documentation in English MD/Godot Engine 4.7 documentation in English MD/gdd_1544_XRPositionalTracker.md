# XRPositionalTracker

Inherits: XRTracker < RefCounted < Object

Inherited By: OpenXRSpatialEntityTracker, XRBodyTracker, XRControllerTracker, XRHandTracker

A tracked object.

## Description

An instance of this object represents a device that is tracked, such as a controller or anchor point. HMDs aren't represented here as they are handled internally.

As controllers are turned on and the XRInterface detects them, instances of this object are automatically added to this list of active tracking objects accessible through the XRServer.

The XRNode3D and XRAnchor3D both consume objects of this type and should be used in your project. The positional trackers are just under-the-hood objects that make this all work. These are mostly exposed so that GDExtension-based interfaces can interact with them.

## Tutorials

- XR documentation index

## Properties

TrackerHand | hand | 0
String | profile | ""

## Methods

Variant | get_input(name: StringName) const
XRPose | get_pose(name: StringName) const
bool | has_pose(name: StringName) const
void | invalidate_pose(name: StringName)
void | set_input(name: StringName, value: Variant)
void | set_pose(name: StringName, transform: Transform3D, linear_velocity: Vector3, angular_velocity: Vector3, tracking_confidence: TrackingConfidence)

---

## Signals

button_pressed(action_name: String) 

Emitted when a button on this tracker is pressed. Note that many XR runtimes allow other inputs to be mapped to buttons.

---

button_released(action_name: String) 

Emitted when a button on this tracker is released.

---

input_float_changed(action_name: String, value: float) 

Emitted when a trigger or similar input on this tracker changes value.

---

input_vector2_changed(action_name: String, vector: Vector2) 

Emitted when a thumbstick or thumbpad on this tracker moves.

---

pose_changed(pose: XRPose) 

Emitted when the state of a pose tracked by this tracker changes.

---

pose_lost_tracking(pose: XRPose) 

Emitted when a pose tracked by this tracker stops getting updated tracking data.

---

profile_changed(role: String) 

Emitted when the profile of our tracker changes.

---

## Enumerations

enum TrackerHand
TrackerHand TRACKER_HAND_UNKNOWN = 0

The hand this tracker is held in is unknown or not applicable.

TrackerHand TRACKER_HAND_LEFT = 1

This tracker is the left hand controller.

TrackerHand TRACKER_HAND_RIGHT = 2

This tracker is the right hand controller.

TrackerHand TRACKER_HAND_MAX = 3

Represents the size of the TrackerHand enum.

---

## Property Descriptions

TrackerHand hand = 0 

- void set_tracker_hand(value: TrackerHand)
- TrackerHand get_tracker_hand()

Defines which hand this tracker relates to.

---

String profile = "" 

- void set_tracker_profile(value: String)
- String get_tracker_profile()

The profile associated with this tracker, interface dependent but will indicate the type of controller being tracked.

---

## Method Descriptions

Variant get_input(name: StringName) const 

Deprecated: Use through XRControllerTracker.

Returns an input for this tracker. It can return a boolean, float or Vector2 value depending on whether the input is a button, trigger or thumbstick/thumbpad.

---

XRPose get_pose(name: StringName) const 

Returns the current XRPose state object for the bound name pose.

---

bool has_pose(name: StringName) const 

Returns true if the tracker is available and is currently tracking the bound name pose.

---

void invalidate_pose(name: StringName) 

Marks this pose as invalid, we don't clear the last reported state but it allows users to decide if trackers need to be hidden if we lose tracking or just remain at their last known position.

---

void set_input(name: StringName, value: Variant) 

Deprecated: Use through XRControllerTracker.

Changes the value for the given input. This method is called by an XRInterface implementation and should not be used directly.

---

void set_pose(name: StringName, transform: Transform3D, linear_velocity: Vector3, angular_velocity: Vector3, tracking_confidence: TrackingConfidence) 

Sets the transform, linear velocity, angular velocity and tracking confidence for the given pose. This method is called by an XRInterface implementation and should not be used directly.
