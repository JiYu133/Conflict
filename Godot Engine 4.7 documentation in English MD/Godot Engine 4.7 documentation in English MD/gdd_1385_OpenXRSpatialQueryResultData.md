# OpenXRSpatialQueryResultData

Experimental: This class may be changed or removed in future versions.

Inherits: OpenXRSpatialComponentData < RefCounted < Object

Object for storing the main query result data.

## Description

Object for storing the main query result data when calling OpenXRSpatialEntityExtension.query_snapshot(). This must always be the first component requested.

## Methods

int | get_capacity() const
int | get_entity_id(index: int) const
EntityTrackingState | get_entity_state(index: int) const

---

## Method Descriptions

int get_capacity() const 

Returns the number of entities that were retrieved.

---

int get_entity_id(index: int) const 

Returns the entity id (XrSpatialEntityIdEXT) for the entity at this index.

---

EntityTrackingState get_entity_state(index: int) const 

Returns the entity state for the entity at this index.
