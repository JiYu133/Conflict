# OpenXRSpatialAnchorCapability

Experimental: This class may be changed or removed in future versions.

Inherits: OpenXRExtensionWrapper < Object

Implementation for handling spatial entity anchor logic.

## Description

This is an internal class that handles the OpenXR anchor spatial entity extension.

## Methods

OpenXRFutureResult | create_default_persistence_context(user_callback: Callable = Callable())
OpenXRAnchorTracker | create_new_anchor(transform: Transform3D, spatial_context: RID = RID(), next: OpenXRStructureBase = null)
OpenXRFutureResult | create_persistence_context(scope: PersistenceScope, user_callback: Callable = Callable())
void | do_entity_update(spatial_context: RID, component_data: Array[OpenXRSpatialComponentData], next_snapshot_create: OpenXRStructureBase = null, next_snapshot_query: OpenXRStructureBase = null)
void | free_persistence_context(persistence_context: RID)
int | get_persistence_context_handle(persistence_context: RID) const
bool | is_persistence_scope_supported(scope: PersistenceScope)
bool | is_spatial_anchor_supported()
bool | is_spatial_persistence_supported()
OpenXRFutureResult | persist_anchor(anchor_tracker: OpenXRAnchorTracker, persistence_context: RID = RID(), user_callback: Callable = Callable())
void | remove_anchor(anchor_tracker: OpenXRAnchorTracker)
OpenXRFutureResult | start_entity_discovery(spatial_context: RID, component_data: Array[OpenXRSpatialComponentData], next_snapshot_create: OpenXRStructureBase = null, next_snapshot_query: OpenXRStructureBase = null, user_callback: Callable = Callable())
OpenXRFutureResult | unpersist_anchor(anchor_tracker: OpenXRAnchorTracker, persistence_context: RID = RID(), user_callback: Callable = Callable())

---

## Enumerations

enum PersistenceScope
PersistenceScope PERSISTENCE_SCOPE_SYSTEM_MANAGED = 1

Provides the application with read-only access (i.e. application cannot modify this scope) to spatial entities persisted and managed by the system. The application can use the UUID in the persistence component for this scope to correlate entities across spatial contexts and device reboots.

PersistenceScope PERSISTENCE_SCOPE_LOCAL_ANCHORS = 1000781000

Persistence operations and data access is limited to spatial anchors, on the same device, for the same user and same app (using persist_anchor() and unpersist_anchor() functions)

---

## Method Descriptions

OpenXRFutureResult create_default_persistence_context(user_callback: Callable = Callable()) 

Calls create_persistence_context() with a configuration that likely works with the XR runtime.

user_callback is called when the context is created.

---

OpenXRAnchorTracker create_new_anchor(transform: Transform3D, spatial_context: RID = RID(), next: OpenXRStructureBase = null) 

Creates a new anchor that will be tracked by the XR runtime. The transform should be a transform in the local space of your XROrigin3D node. If spatial_context is not specified the default will be used, this requires ProjectSettings.xr/openxr/extensions/spatial_entity/enable_builtin_anchor_detection to be set. The returned tracker will track the location in case our reference space changes.

next must be a valid next object for the XrSpatialAnchorCreateInfoEXT chain.

---

OpenXRFutureResult create_persistence_context(scope: PersistenceScope, user_callback: Callable = Callable()) 

Creates a new persistence context for storing persistent data.

Note: This is an asynchronous method and returns an OpenXRFutureResult object with which to track the status, discarding this object will not cancel the creation process. On success user_callback will be called if specified. The result value for this function is the RID for our persistence context.

---

void do_entity_update(spatial_context: RID, component_data: Array[OpenXRSpatialComponentData], next_snapshot_create: OpenXRStructureBase = null, next_snapshot_query: OpenXRStructureBase = null) 

Calls OpenXRSpatialEntityExtension.update_spatial_entities() and OpenXRSpatialEntityExtension.query_snapshot() with the anchor entities associated with spatial_context.

component_data are the OpenXRSpatialComponentDatas to update for this anchor capability.

If next_snapshot_create is non-null, then pass this to the next parameter in OpenXRSpatialEntityExtension.update_spatial_entities().

If next_snapshot_query is non-null, then pass this to the next parameter in OpenXRSpatialEntityExtension.query_snapshot().

---

void free_persistence_context(persistence_context: RID) 

Frees a persistence context previously created with create_persistence_context().

---

int get_persistence_context_handle(persistence_context: RID) const 

Returns the internal handle for this persistence context.

Note: For GDExtension implementations.

---

bool is_persistence_scope_supported(scope: PersistenceScope) 

Returns true if this persistence scope is supported by our spatial anchor capability.

Note: Only valid after an OpenXR instance has been created.

---

bool is_spatial_anchor_supported() 

Returns true if spatial anchors are supported by the hardware. Only returns a valid value after OpenXR has been initialized.

---

bool is_spatial_persistence_supported() 

Returns true if persistent spatial anchors are supported by the hardware. Only returns a valid value after OpenXR has been initialized.

---

OpenXRFutureResult persist_anchor(anchor_tracker: OpenXRAnchorTracker, persistence_context: RID = RID(), user_callback: Callable = Callable()) 

Changes this anchor into a persistent anchor. This means its location will be stored on the device and the anchor will be restored the next time your application starts. If persistence_context is not specified the default will be used, this requires ProjectSettings.xr/openxr/extensions/spatial_entity/enable_builtin_anchor_detection to be set.

Note: This is an asynchronous method and returns an OpenXRFutureResult object with which to track the status, discarding this object will not cancel the creation process. On success user_callback will be called if specified. The result value for this function is a boolean which will be set to true on successful completion.

---

void remove_anchor(anchor_tracker: OpenXRAnchorTracker) 

Remove an anchor previously created with create_new_anchor(). If this anchor was persistent you must first call unpersist_anchor() and await its callback.

---

OpenXRFutureResult start_entity_discovery(spatial_context: RID, component_data: Array[OpenXRSpatialComponentData], next_snapshot_create: OpenXRStructureBase = null, next_snapshot_query: OpenXRStructureBase = null, user_callback: Callable = Callable()) 

Calls OpenXRSpatialEntityExtension.discover_spatial_entities() and OpenXRSpatialEntityExtension.query_snapshot() with the anchor entities associated with spatial_context.

component_data are the OpenXRSpatialComponentDatas to discover for this anchor capability.

If next_snapshot_create is non-null, then pass this to the next parameter in OpenXRSpatialEntityExtension.discover_spatial_entities().

If next_snapshot_query is non-null, then pass this to the next parameter in OpenXRSpatialEntityExtension.query_snapshot().

user_callback, when non-null, is called with two parameters usually twice. The first parameter is the RID of the discovery snapshot and the second parameter is a boolean where false indicates the discovery snapshot is about to be processed, and true indicates the discovery snapshot has been processed and component_data has valid data. The second call is skipped if an error was encountered.

The returned OpenXRFutureResult is identical to the return from OpenXRSpatialEntityExtension.discover_spatial_entities().

---

OpenXRFutureResult unpersist_anchor(anchor_tracker: OpenXRAnchorTracker, persistence_context: RID = RID(), user_callback: Callable = Callable()) 

Removes the persistent data from this anchor. The runtime will not recreate the anchor when your application restarts. If persistence_context is not specified the default will be used, this requires ProjectSettings.xr/openxr/extensions/spatial_entity/enabled to be set.

Note: This is an asynchronous method and returns an OpenXRFutureResult object with which to track the status, discarding this object will not cancel the creation process. On success user_callback will be called if specified. The result value for this function is a boolean which will be set to true on successful completion.
