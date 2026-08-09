# OpenXRMarkerTracker

Experimental: This class may be changed or removed in future versions.

Inherits: OpenXRSpatialEntityTracker < XRPositionalTracker < XRTracker < RefCounted < Object

Spatial entity tracker for our spatial entity marker tracking extension.

## Description

Spatial entity tracker for our OpenXR spatial entity marker tracking extension. These trackers identify entities in our real space detected by a visual marker such as a QRCode or Aruco code, and map their location to our virtual space.

## Properties

Vector2 | bounds_size | Vector2(0, 0)
int | marker_id | 0
MarkerType | marker_type | 0

## Methods

Variant | get_marker_data() const
void | set_marker_data(marker_data: Variant)

---

## Property Descriptions

Vector2 bounds_size = Vector2(0, 0) 

- void set_bounds_size(value: Vector2)
- Vector2 get_bounds_size()

The bounds size for this marker.

---

int marker_id = 0 

- void set_marker_id(value: int)
- int get_marker_id()

The marker ID for this marker, this is only returned for Aruco and April Tag markers. Call get_marker_data() for QRCode markers.

---

MarkerType marker_type = 0 

- void set_marker_type(value: MarkerType)
- MarkerType get_marker_type()

The type of marker.

---

## Method Descriptions

Variant get_marker_data() const 

Returns the marker data for this marker. This can return a String or PackedByteArray. Only applicable to QR Code based markers.

---

void set_marker_data(marker_data: Variant) 

Sets the marker data for this marker.

Note: This should only be set by marker discovery logic.
