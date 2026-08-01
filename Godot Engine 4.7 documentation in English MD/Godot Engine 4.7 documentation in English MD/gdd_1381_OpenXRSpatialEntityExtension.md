# OpenXRSpatialEntityExtension

Experimental: This class may be changed or removed in future versions.

Inherits: OpenXRExtensionWrapper < Object

OpenXR extension that handles spatial entities.

## Description

OpenXR extension that handles spatial entities and, when enabled, allows querying those spatial entities. This extension will also automatically manage XRTracker objects for static entities.

## Methods

RID | add_spatial_entity(spatial_context: RID, entity_id: int, entity: int)
OpenXRFutureResult | create_spatial_context(capability_configurations: Array[OpenXRSpatialCapabilityConfigurationBaseHeader], next: OpenXRStructureBase = null, user_callback: Callable = Callable())
OpenXRFutureResult | discover_spatial_entities(spatial_context: RID, component_types: PackedInt64Array, next: OpenXRStructureBase = null, user_callback: Callable = Callable())
OpenXRFutureResult | discover_spatial_entities_with_component_data(spatial_context: RID, component_data: Array[OpenXRSpatialComponentData], next: OpenXRStructureBase = null, user_callback: Callable = Callable())
RID | find_spatial_entity(entity_id: int)
void | free_spatial_context(spatial_context: RID)
void | free_spatial_entity(entity: RID)
void | free_spatial_snapshot(spatial_snapshot: RID)
PackedFloat32Array | get_float_buffer(spatial_snapshot: RID, buffer_id: int) const
int | get_spatial_context_handle(spatial_context: RID) const
bool | get_spatial_context_ready(spatial_context: RID) const
RID | get_spatial_entity_context(entity: RID) const
int | get_spatial_entity_id(entity: RID) const
RID | get_spatial_snapshot_context(spatial_snapshot: RID) const
int | get_spatial_snapshot_handle(spatial_snapshot: RID) const
String | get_string(spatial_snapshot: RID, buffer_id: int) const
PackedByteArray | get_uint8_buffer(spatial_snapshot: RID, buffer_id: int) const
PackedInt32Array | get_uint16_buffer(spatial_snapshot: RID, buffer_id: int) const
PackedInt32Array | get_uint32_buffer(spatial_snapshot: RID, buffer_id: int) const
PackedVector2Array | get_vector2_buffer(spatial_snapshot: RID, buffer_id: int) const
PackedVector3Array | get_vector3_buffer(spatial_snapshot: RID, buffer_id: int) const
RID | make_spatial_entity(spatial_context: RID, entity_id: int)
bool | query_snapshot(spatial_snapshot: RID, component_data: Array[OpenXRSpatialComponentData], next: OpenXRStructureBase = null)
bool | supports_capability(capability: Capability)
bool | supports_component_type(capability: Capability, component_type: ComponentType)
RID | update_spatial_entities(spatial_context: RID, entities: Array[RID], component_types: PackedInt64Array, next: OpenXRStructureBase = null)

---

## Signals

spatial_discovery_recommended(spatial_context: RID) 

Emitted when OpenXR recommends running a discovery query because entities managed by this spatial context have (likely) changed.

---

## Enumerations

enum Capability
Capability CAPABILITY_PLANE_TRACKING = 1000741000

Plane tracking capability.

Capability CAPABILITY_MARKER_TRACKING_QR_CODE = 1000743000

QR code based marker tracking capability.

Capability CAPABILITY_MARKER_TRACKING_MICRO_QR_CODE = 1000743001

Micro QR code based marker tracking capability.

Capability CAPABILITY_MARKER_TRACKING_ARUCO_MARKER = 1000743002

Aruco marker based marker tracking capability.

Capability CAPABILITY_MARKER_TRACKING_APRIL_TAG = 1000743003

April tag based marker tracking capability.

Capability CAPABILITY_ANCHOR = 1000762000

Anchor capability.

---

enum ComponentType
ComponentType COMPONENT_TYPE_BOUNDED_2D = 1

Component that provides the 2D bounds for a spatial entity. The corresponding list structure is XrSpatialComponentBounded2DListEXT; the corresponding data structure is XrSpatialBounded2DDataEXT.

ComponentType COMPONENT_TYPE_BOUNDED_3D = 2

Component that provides the 3D bounds for a spatial entity. The corresponding list structure is XrSpatialComponentBounded3DListEXT; the corresponding data structure is XrBoxf.

ComponentType COMPONENT_TYPE_PARENT = 3

Component that provides the XrSpatialEntityIdEXT of the parent for a spatial entity. The corresponding list structure is XrSpatialComponentParentListEXT; the corresponding data structure is XrSpatialEntityIdEXT.

ComponentType COMPONENT_TYPE_MESH_3D = 4

Component that provides a 3D mesh for a spatial entity. The corresponding list structure is XrSpatialComponentMesh3DListEXT; the corresponding data structure is XrSpatialMeshDataEXT.

ComponentType COMPONENT_TYPE_PLANE_ALIGNMENT = 1000741000

Component that provides the plane alignment enum for a spatial entity. The corresponding list structure is XrSpatialComponentPlaneAlignmentListEXT; the corresponding data structure is XrSpatialPlaneAlignmentEXT (Added by the XR_EXT_spatial_plane_tracking extension).

ComponentType COMPONENT_TYPE_MESH_2D = 1000741001

Component that provides a 2D mesh for a spatial entity. The corresponding list structure is XrSpatialComponentMesh2DListEXT; the corresponding data structure is XrSpatialMeshDataEXT (Added by the XR_EXT_spatial_plane_tracking extension).

ComponentType COMPONENT_TYPE_POLYGON_2D = 1000741002

Component that provides a 2D boundary polygon for a spatial entity. The corresponding list structure is XrSpatialComponentPolygon2DListEXT; the corresponding data structure is XrSpatialPolygon2DDataEXT (Added by the XR_EXT_spatial_plane_tracking extension).

ComponentType COMPONENT_TYPE_PLANE_SEMANTIC_LABEL = 1000741003

Component that provides a semantic label for a plane. The corresponding list structure is XrSpatialComponentPlaneSemanticLabelListEXT; the corresponding data structure is XrSpatialPlaneSemanticLabelEXT (Added by the XR_EXT_spatial_plane_tracking extension).

ComponentType COMPONENT_TYPE_MARKER = 1000743000

A component describing the marker type, ID and location. The corresponding list structure is XrSpatialComponentMarkerListEXT; the corresponding data structure is XrSpatialMarkerDataEXT (Added by the XR_EXT_spatial_marker_tracking extension).

ComponentType COMPONENT_TYPE_ANCHOR = 1000762000

Component that provides the location for an anchor. The corresponding list structure is XrSpatialComponentAnchorListEXT; the corresponding data structure is XrPosef (Added by the XR_EXT_spatial_anchor extension).

ComponentType COMPONENT_TYPE_PERSISTENCE = 1000763000

Component that provides the persisted UUID for a spatial entity. The corresponding list structure is XrSpatialComponentPersistenceListEXT; the corresponding data structure is [code]XrSpatialPersistenceDataEXT (Added by the XR_EXT_spatial_persistence extension).

---

## Method Descriptions

RID add_spatial_entity(spatial_context: RID, entity_id: int, entity: int) 

Registers an entity that was created directly on the OpenXR runtime.

---

OpenXRFutureResult create_spatial_context(capability_configurations: Array[OpenXRSpatialCapabilityConfigurationBaseHeader], next: OpenXRStructureBase = null, user_callback: Callable = Callable()) 

Creates a new spatial context that handles entities for the provided capability configurations. capability_configurations is an array of OpenXRSpatialCapabilityConfigurationBaseHeader with the needed capability configuration data.

next is an optional parameter that can contain additional information for creating our spatial context.

Note: This is an asynchronous method and returns an OpenXRFutureResult object with which to track the status, discarding this object will not cancel the creation process. On success user_callback will be called if specified. The result data for this function is the RID for our spatial context.

---

OpenXRFutureResult discover_spatial_entities(spatial_context: RID, component_types: PackedInt64Array, next: OpenXRStructureBase = null, user_callback: Callable = Callable()) 

Starts a new discovery query, this will gather all objects tracked by the spatial_context that have at least one of the component types specified in component_types.

next is an optional parameter that can contain additional information for executing the discovery query.

Note: This is an asynchronous method and returns an OpenXRFutureResult object with which to track the status, discarding this object will not cancel the discovery process. On success user_callback will be called if specified. The result data for this function is the RID for our snapshot.

---

OpenXRFutureResult discover_spatial_entities_with_component_data(spatial_context: RID, component_data: Array[OpenXRSpatialComponentData], next: OpenXRStructureBase = null, user_callback: Callable = Callable()) 

Convenience method when the caller only has an Array of OpenXRSpatialComponentData and needs to discover spatial entities.

---

RID find_spatial_entity(entity_id: int) 

Returns the RID for the specified spatial entity ID.

---

void free_spatial_context(spatial_context: RID) 

Frees a spatial context previously created when calling create_spatial_context(). If the spatial context creation is still ongoing, the asynchronous process is cancelled.

---

void free_spatial_entity(entity: RID) 

Frees an entity previously created when calling add_spatial_entity() or make_spatial_entity().

---

void free_spatial_snapshot(spatial_snapshot: RID) 

Frees a spatial snapshot previously created when calling discover_spatial_entities(). If the spatial snapshot creation is still ongoing, the asynchronous process is cancelled.

---

PackedFloat32Array get_float_buffer(spatial_snapshot: RID, buffer_id: int) const 

Returns a buffer with floats from a buffer that was retrieved when taking a snapshot.

---

int get_spatial_context_handle(spatial_context: RID) const 

Returns the OpenXR spatial context handle for this snapshot.

Note: This method is intended to be used from GDExtensions that implement spatial entity capability handlers.

---

bool get_spatial_context_ready(spatial_context: RID) const 

Returns true if the spatial context finished its creation and is ready to be used.

---

RID get_spatial_entity_context(entity: RID) const 

Returns the spatial context for this entity.

---

int get_spatial_entity_id(entity: RID) const 

Returns the internal XrSpatialEntityIdEXT associated with the entity.

---

RID get_spatial_snapshot_context(spatial_snapshot: RID) const 

Returns the spatial context related to this spatial snapshot.

---

int get_spatial_snapshot_handle(spatial_snapshot: RID) const 

Returns the OpenXR spatial snapshot handle for this snapshot.

Note: This method is intended to be used from GDExtensions that implement spatial entity capability handlers.

---

String get_string(spatial_snapshot: RID, buffer_id: int) const 

Returns a string from a buffer that was retrieved when taking a snapshot.

---

PackedByteArray get_uint8_buffer(spatial_snapshot: RID, buffer_id: int) const 

Returns a buffer with 8 bit ints from a buffer that was retrieved when taking a snapshot.

---

PackedInt32Array get_uint16_buffer(spatial_snapshot: RID, buffer_id: int) const 

Returns a buffer with 16 bit ints from a buffer that was retrieved when taking a snapshot.

---

PackedInt32Array get_uint32_buffer(spatial_snapshot: RID, buffer_id: int) const 

Returns a buffer with 32 bit ints from a buffer that was retrieved when taking a snapshot.

---

PackedVector2Array get_vector2_buffer(spatial_snapshot: RID, buffer_id: int) const 

Returns a buffer with Vector2 entries from a buffer that was retrieved when taking a snapshot.

---

PackedVector3Array get_vector3_buffer(spatial_snapshot: RID, buffer_id: int) const 

Returns a buffer with Vector3 entries from a buffer that was retrieved when taking a snapshot.

---

RID make_spatial_entity(spatial_context: RID, entity_id: int) 

Creates a new entity for this entity_id. The spatial_context should match the context that discovered the entity.

---

bool query_snapshot(spatial_snapshot: RID, component_data: Array[OpenXRSpatialComponentData], next: OpenXRStructureBase = null) 

Queries the snapshot data. This will find all entities in the snapshot that contain all requested components in component_data. The objects held within component_data will then be populated with the queried data. component_data must always have an object of OpenXRSpatialQueryResultData as the first entry.

next is an optional parameter that can contain additional information passed when setting our query conditions.

---

bool supports_capability(capability: Capability) 

Returns true if this spatial entity capability is supported by the hardware used.

---

bool supports_component_type(capability: Capability, component_type: ComponentType) 

Returns true if this capability supports the component_type.

---

RID update_spatial_entities(spatial_context: RID, entities: Array[RID], component_types: PackedInt64Array, next: OpenXRStructureBase = null) 

Performs a snapshot for a limited number of entities. This is NOT an asynchronous method and will return the snapshot immediately.
