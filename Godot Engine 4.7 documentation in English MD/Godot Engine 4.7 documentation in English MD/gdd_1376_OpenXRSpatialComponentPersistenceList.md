# OpenXRSpatialComponentPersistenceList

Experimental: This class may be changed or removed in future versions.

Inherits: OpenXRSpatialComponentData < RefCounted < Object

Object for storing the query persistence result data.

## Description

Object for storing the query persistence result data when calling OpenXRSpatialEntityExtension.query_snapshot().

## Methods

int | get_persistent_state(index: int) const
String | get_persistent_uuid(index: int) const

---

## Method Descriptions

int get_persistent_state(index: int) const 

Returns the persistent state (XrSpatialPersistenceStateEXT) for the entity at this index.

---

String get_persistent_uuid(index: int) const 

Returns the persistent uuid for the entity at this index.
