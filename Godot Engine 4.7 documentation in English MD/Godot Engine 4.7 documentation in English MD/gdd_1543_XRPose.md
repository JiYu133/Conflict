# XRPose

Inherits: RefCounted < Object

This object contains all data related to a pose on a tracked object.

## Description

XR runtimes often identify multiple locations on devices such as controllers that are spatially tracked.

Orientation, location, linear velocity and angular velocity are all provided for each pose by the XR runtime. This object contains this state of a pose.

## Tutorials

- XR documentation index

## Properties

Vector3 | angular_velocity | Vector3(0, 0, 0)
bool | has_tracking_data | false
Vector3 | linear_velocity | Vector3(0, 0, 0)
StringName | name | &""
TrackingConfidence | tracking_confidence | 0
Transform3D | transform | Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0)

## Methods

Transform3D | get_adjusted_transform() const

---

## Enumerations

enum TrackingConfidence
TrackingConfidence XR_TRACKING_CONFIDENCE_NONE = 0

No tracking information is available for this pose.

TrackingConfidence XR_TRACKING_CONFIDENCE_LOW = 1

Tracking information may be inaccurate or estimated. For example, with inside out tracking this would indicate a controller may be (partially) obscured.

TrackingConfidence XR_TRACKING_CONFIDENCE_HIGH = 2

Tracking information is considered accurate and up to date.

---

## Property Descriptions

Vector3 angular_velocity = Vector3(0, 0, 0) 

- void set_angular_velocity(value: Vector3)
- Vector3 get_angular_velocity()

The angular velocity for this pose.

---

bool has_tracking_data = false 

- void set_has_tracking_data(value: bool)
- bool get_has_tracking_data()

If true our tracking data is up to date. If false we're no longer receiving new tracking data and our state is whatever that last valid state was.

---

Vector3 linear_velocity = Vector3(0, 0, 0) 

- void set_linear_velocity(value: Vector3)
- Vector3 get_linear_velocity()

The linear velocity of this pose.

---

StringName name = &"" 

- void set_name(value: StringName)
- StringName get_name()

The name of this pose. Usually, this name is derived from an action map set up by the user. Godot also suggests some pose names that XRInterface objects are expected to implement:

- root is the root location, often used for tracked objects that do not have further nodes.
- aim is the tip of a controller with its orientation pointing outwards, often used for raycasts.
- grip is the location where the user grips the controller.
- skeleton is the root location for a hand mesh, when using hand tracking and an animated skeleton is supplied by the XR runtime.

---

TrackingConfidence tracking_confidence = 0 

- void set_tracking_confidence(value: TrackingConfidence)
- TrackingConfidence get_tracking_confidence()

The tracking confidence for this pose, provides insight on how accurate the spatial positioning of this record is.

---

Transform3D transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0) 

- void set_transform(value: Transform3D)
- Transform3D get_transform()

The transform containing the original and transform as reported by the XR runtime.

---

## Method Descriptions

Transform3D get_adjusted_transform() const 

Returns the transform with world scale and our reference frame applied. This is the transform used to position XRNode3D objects.
