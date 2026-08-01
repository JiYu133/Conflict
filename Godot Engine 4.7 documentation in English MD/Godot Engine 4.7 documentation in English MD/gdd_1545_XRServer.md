# XRServer

Inherits: Object

Server for AR and VR features.

## Description

The AR/VR server is the heart of our Advanced and Virtual Reality solution and handles all the processing.

## Tutorials

- XR documentation index

## Properties

bool | camera_locked_to_origin | false
XRInterface | primary_interface |
Transform3D | world_origin | Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0)
float | world_scale | 1.0

## Methods

void | add_interface(interface: XRInterface)
void | add_tracker(tracker: XRTracker)
void | center_on_hmd(rotation_mode: RotationMode, keep_height: bool)
void | clear_reference_frame()
XRInterface | find_interface(name: String) const
Transform3D | get_hmd_transform()
XRInterface | get_interface(idx: int) const
int | get_interface_count() const
Array[Dictionary] | get_interfaces() const
Transform3D | get_reference_frame() const
XRTracker | get_tracker(tracker_name: StringName) const
Dictionary | get_trackers(tracker_types: int)
void | remove_interface(interface: XRInterface)
void | remove_tracker(tracker: XRTracker)

---

## Signals

interface_added(interface_name: StringName) 

Emitted when a new interface has been added.

---

interface_removed(interface_name: StringName) 

Emitted when an interface is removed.

---

reference_frame_changed() 

Emitted when the reference frame transform changes.

---

tracker_added(tracker_name: StringName, type: int) 

Emitted when a new tracker has been added. If you don't use a fixed number of controllers or if you're using XRAnchor3Ds for an AR solution, it is important to react to this signal to add the appropriate XRController3D or XRAnchor3D nodes related to this new tracker.

---

tracker_removed(tracker_name: StringName, type: int) 

Emitted when a tracker is removed. You should remove any XRController3D or XRAnchor3D points if applicable. This is not mandatory, the nodes simply become inactive and will be made active again when a new tracker becomes available (i.e. a new controller is switched on that takes the place of the previous one).

---

tracker_updated(tracker_name: StringName, type: int) 

Emitted when an existing tracker has been updated. This can happen if the user switches controllers.

---

world_origin_changed() 

Emitted when the world origin transform changes.

---

## Enumerations

enum TrackerType
TrackerType TRACKER_HEAD = 1

The tracker tracks the location of the player's head. This is usually a location centered between the player's eyes. Note that for handheld AR devices this can be the current location of the device.

TrackerType TRACKER_CONTROLLER = 2

The tracker tracks the location of a controller.

TrackerType TRACKER_BASESTATION = 4

The tracker tracks the location of a base station.

TrackerType TRACKER_ANCHOR = 8

The tracker tracks the location and size of an AR anchor.

TrackerType TRACKER_HAND = 16

The tracker tracks the location and joints of a hand.

TrackerType TRACKER_BODY = 32

The tracker tracks the location and joints of a body.

TrackerType TRACKER_FACE = 64

The tracker tracks the expressions of a face.

TrackerType TRACKER_ANY_KNOWN = 127

Used internally to filter trackers of any known type.

TrackerType TRACKER_UNKNOWN = 128

Used internally if we haven't set the tracker type yet.

TrackerType TRACKER_ANY = 255

Used internally to select all trackers.

---

enum RotationMode
RotationMode RESET_FULL_ROTATION = 0

Fully reset the orientation of the HMD. Regardless of what direction the user is looking to in the real world. The user will look dead ahead in the virtual world.

RotationMode RESET_BUT_KEEP_TILT = 1

Resets the orientation but keeps the tilt of the device. So if we're looking down, we keep looking down but heading will be reset.

RotationMode DONT_RESET_ROTATION = 2

Does not reset the orientation of the HMD, only the position of the player gets centered.

---

## Property Descriptions

bool camera_locked_to_origin = false 

- void set_camera_locked_to_origin(value: bool)
- bool is_camera_locked_to_origin()

If set to true, the scene will be rendered as if the camera is locked to the XROrigin3D.

Note: This doesn't provide a very comfortable experience for users. This setting exists for doing benchmarking or automated testing, where you want to control what is rendered via code.

---

XRInterface primary_interface 

- void set_primary_interface(value: XRInterface)
- XRInterface get_primary_interface()

The primary XRInterface currently bound to the XRServer.

---

Transform3D world_origin = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0) 

- void set_world_origin(value: Transform3D)
- Transform3D get_world_origin()

The current origin of our tracking space in the virtual world. This is used by the renderer to properly position the camera with new tracking data.

Note: This property is managed by the current XROrigin3D node. It is exposed for access from GDExtensions.

---

float world_scale = 1.0 

- void set_world_scale(value: float)
- float get_world_scale()

The scale of the game world compared to the real world. By default, most AR/VR platforms assume that 1 game unit corresponds to 1 real world meter.

---

## Method Descriptions

void add_interface(interface: XRInterface) 

Registers an XRInterface object.

---

void add_tracker(tracker: XRTracker) 

Registers a new XRTracker that tracks a physical object.

---

void center_on_hmd(rotation_mode: RotationMode, keep_height: bool) 

This is an important function to understand correctly. AR and VR platforms all handle positioning slightly differently.

For platforms that do not offer spatial tracking, our origin point (0, 0, 0) is the location of our HMD, but you have little control over the direction the player is facing in the real world.

For platforms that do offer spatial tracking, our origin point depends very much on the system. For OpenVR, our origin point is usually the center of the tracking space, on the ground. For other platforms, it's often the location of the tracking camera.

This method allows you to center your tracker on the location of the HMD. It will take the current location of the HMD and use that to adjust all your tracking data; in essence, realigning the real world to your player's current position in the game world.

For this method to produce usable results, tracking information must be available. This often takes a few frames after starting your game.

You should call this method after a few seconds have passed. For example, when the user requests a realignment of the display holding a designated button on a controller for a short period of time, or when implementing a teleport mechanism.

---

void clear_reference_frame() 

Clears the reference frame that was set by previous calls to center_on_hmd().

---

XRInterface find_interface(name: String) const 

Finds an interface by its name. For example, if your project uses capabilities of an AR/VR platform, you can find the interface for that platform by name and initialize it.

---

Transform3D get_hmd_transform() 

Returns the primary interface's transformation.

---

XRInterface get_interface(idx: int) const 

Returns the interface registered at the given idx index in the list of interfaces.

---

int get_interface_count() const 

Returns the number of interfaces currently registered with the AR/VR server. If your project supports multiple AR/VR platforms, you can look through the available interface, and either present the user with a selection or simply try to initialize each interface and use the first one that returns true.

---

Array[Dictionary] get_interfaces() const 

Returns a list of available interfaces the ID and name of each interface.

---

Transform3D get_reference_frame() const 

Returns the reference frame transform. Mostly used internally and exposed for GDExtension build interfaces.

---

XRTracker get_tracker(tracker_name: StringName) const 

Returns the positional tracker with the given tracker_name.

---

Dictionary get_trackers(tracker_types: int) 

Returns a dictionary of trackers for tracker_types.

---

void remove_interface(interface: XRInterface) 

Removes this interface.

---

void remove_tracker(tracker: XRTracker) 

Removes this tracker.
