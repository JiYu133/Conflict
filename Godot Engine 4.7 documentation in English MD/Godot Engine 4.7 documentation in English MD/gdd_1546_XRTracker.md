# XRTracker

Inherits: RefCounted < Object

Inherited By: XRFaceTracker, XRPositionalTracker

A tracked object.

## Description

This object is the base of all XR trackers.

## Tutorials

- XR documentation index

## Properties

String | description | ""
StringName | name | &"Unknown"
TrackerType | type | 128

---

## Property Descriptions

String description = "" 

- void set_tracker_desc(value: String)
- String get_tracker_desc()

The description of this tracker.

---

StringName name = &"Unknown" 

- void set_tracker_name(value: StringName)
- StringName get_tracker_name()

The unique name of this tracker. The trackers that are available differ between various XR runtimes and can often be configured by the user. Godot maintains a number of reserved names that it expects the XRInterface to implement if applicable:

- "head" identifies the XRPositionalTracker of the player's head
- "left_hand" identifies the XRControllerTracker in the player's left hand
- "right_hand" identifies the XRControllerTracker in the player's right hand
- "/user/hand_tracker/left" identifies the XRHandTracker for the player's left hand
- "/user/hand_tracker/right" identifies the XRHandTracker for the player's right hand
- "/user/body_tracker" identifies the XRBodyTracker for the player's body
- "/user/face_tracker" identifies the XRFaceTracker for the player's face

---

TrackerType type = 128 

- void set_tracker_type(value: TrackerType)
- TrackerType get_tracker_type()

The type of tracker.
