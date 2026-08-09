# OpenXRSpatialEntityTracker

Experimental: This class may be changed or removed in future versions.

Inherits: XRPositionalTracker < XRTracker < RefCounted < Object

Inherited By: OpenXRAnchorTracker, OpenXRMarkerTracker, OpenXRPlaneTracker

Base class for Positional trackers managed by OpenXR's spatial entity extensions.

## Description

These are trackers created and managed by OpenXR's spatial entity extensions that give access to specific data related to OpenXR's spatial entities. They will always be of type TRACKER_ANCHOR.

## Properties

RID | entity | RID()
EntityTrackingState | spatial_tracking_state | 2
TrackerType | type | 8 (overrides XRTracker)

## Methods

void | add_next(next: OpenXRStructureBase)
OpenXRStructureBase | get_next() const
RID | get_spatial_context() const
void | remove_next(next: OpenXRStructureBase)
void | set_spatial_context(spatial_context: RID)

---

## Signals

next_changed() 

Emitted when the next-chain changes, from either add_next() or remove_next().

---

spatial_tracking_state_changed(spatial_tracking_state: int) 

There is currently no description for this signal. Please help us by contributing one [https://contributing.godotengine.org/en/latest/documentation/class_reference.html]!

---

## Enumerations

enum EntityTrackingState
EntityTrackingState ENTITY_TRACKING_STATE_STOPPED = 1

This anchor has stopped tracking.

EntityTrackingState ENTITY_TRACKING_STATE_PAUSED = 2

Tracking is currently paused.

EntityTrackingState ENTITY_TRACKING_STATE_TRACKING = 3

This anchor is currently being tracked.

---

## Property Descriptions

RID entity = RID() 

- void set_entity(value: RID)
- RID get_entity()

The spatial entity associated with this tracker.

---

EntityTrackingState spatial_tracking_state = 2 

- void set_spatial_tracking_state(value: EntityTrackingState)
- EntityTrackingState get_spatial_tracking_state()

The spatial tracking state for this tracker.

---

## Method Descriptions

void add_next(next: OpenXRStructureBase) 

Adds a new OpenXRStructureBase to the next-chain.

get_next() will return this next until either add_next() is called again or it's removed in remove_next().

---

OpenXRStructureBase get_next() const 

Gets the head OpenXRStructureBase in the next-chain.

See also add_next() and remove_next().

---

RID get_spatial_context() const 

Gets the spatial context used to create this OpenXRSpatialEntityTracker.

---

void remove_next(next: OpenXRStructureBase) 

Removes a next object previously added in add_next() from the next-chain.

---

void set_spatial_context(spatial_context: RID) 

Sets the spatial context used to create this tracker.
