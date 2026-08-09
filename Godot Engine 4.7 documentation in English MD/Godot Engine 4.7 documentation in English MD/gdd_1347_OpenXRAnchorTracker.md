# OpenXRAnchorTracker

Experimental: This class may be changed or removed in future versions.

Inherits: OpenXRSpatialEntityTracker < XRPositionalTracker < XRTracker < RefCounted < Object

Positional tracker for our spatial entity anchor extension.

## Description

Positional tracker for our OpenXR spatial entity anchor extension, it tracks a user defined location in real space and maps it to our virtual space.

## Properties

String | uuid | ""

## Methods

bool | has_uuid() const

---

## Signals

uuid_changed() 

Emitted when the UUID for this anchor was changed.

---

## Property Descriptions

String uuid = "" 

- void set_uuid(value: String)
- String get_uuid()

The UUID provided for persistent anchors.

---

## Method Descriptions

bool has_uuid() const 

Returns true if a non-zero UUID is set.
