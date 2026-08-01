# OpenXRSpatialComponentData

Experimental: This class may be changed or removed in future versions.

Inherits: RefCounted < Object

Inherited By: OpenXRSpatialComponentAnchorList, OpenXRSpatialComponentBounded2DList, OpenXRSpatialComponentBounded3DList, OpenXRSpatialComponentMarkerList, OpenXRSpatialComponentMesh2DList, OpenXRSpatialComponentMesh3DList, OpenXRSpatialComponentParentList, OpenXRSpatialComponentPersistenceList, OpenXRSpatialComponentPlaneAlignmentList, OpenXRSpatialComponentPlaneSemanticLabelList, OpenXRSpatialComponentPolygon2DList, OpenXRSpatialQueryResultData

Object for storing OpenXR spatial entity component data.

## Description

Object for storing OpenXR spatial entity component data.

## Methods

int | _get_component_type() virtual const
int | _get_structure_data(next: int) virtual
void | _set_capacity(capacity: int) virtual
int | get_component_type() const
void | set_capacity(capacity: int)

---

## Method Descriptions

int _get_component_type() virtual const 

Return the component type for the component we store data for.

---

int _get_structure_data(next: int) virtual 

Return a pointer to the structure data that will be submitted along with the snapshot query. This pointer must remain valid as long as this object is instantiated.

---

void _set_capacity(capacity: int) virtual 

Sets the expected capacity as provided by the spatial entities query system. Buffers should be initialized with the correct storage.

---

int get_component_type() const 

Gets this OpenXRSpatialComponentData's XrSpatialComponentTypeEXT.

---

void set_capacity(capacity: int) 

Sets the expected capacity as provided by the spatial entities query system. Buffers should be initialized with the correct storage.
