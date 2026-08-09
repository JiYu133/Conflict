# OpenXRSpatialComponentMarkerList

Experimental: This class may be changed or removed in future versions.

Inherits: OpenXRSpatialComponentData < RefCounted < Object

Object for storing the queries marker result data.

## Description

Object for storing the queries marker result data when calling OpenXRSpatialEntityExtension.query_snapshot().

## Methods

Variant | get_marker_data(snapshot: RID, index: int) const
int | get_marker_id(index: int) const
MarkerType | get_marker_type(index: int) const

---

## Enumerations

enum MarkerType
MarkerType MARKER_TYPE_UNKNOWN = 0

Unknown or unset marker type.

MarkerType MARKER_TYPE_QRCODE = 1

Marker based on a QR code.

MarkerType MARKER_TYPE_MICRO_QRCODE = 2

Marker based on a micro QR code.

MarkerType MARKER_TYPE_ARUCO = 3

Marker based on an Aruco code.

MarkerType MARKER_TYPE_APRIL_TAG = 4

Marker based on an April Tag.

MarkerType MARKER_TYPE_MAX = 5

Maximum value for this enum.

---

## Method Descriptions

Variant get_marker_data(snapshot: RID, index: int) const 

Returns either a String or a PackedByteArray buffer with data for the marker at this index. Only applicable for QR code markers.

---

int get_marker_id(index: int) const 

Returns the marker ID for the marker at this index. Only applicable for Aruco or April Tag markers.

---

MarkerType get_marker_type(index: int) const 

Returns the marker type for the marker at this index.
