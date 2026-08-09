# OpenXRSpatialCapabilityConfigurationPlaneTracking

Experimental: This class may be changed or removed in future versions.

Inherits: OpenXRSpatialCapabilityConfigurationBaseHeader < RefCounted < Object

Configuration header for plane tracking.

## Description

Configuration header for plane tracking. Pass this to OpenXRSpatialEntityExtension.create_spatial_context() to create a spatial context with plane tracking capabilities.

## Methods

PackedInt64Array | get_enabled_components() const
bool | supports_labels()
bool | supports_mesh_2d()
bool | supports_polygons()

---

## Method Descriptions

PackedInt64Array get_enabled_components() const 

Returns the components enabled by this configuration.

Note: Only valid after this configuration was used to create a spatial context.

---

bool supports_labels() 

Returns true if we support the plane semantic label component (only valid after the OpenXR session has started). You can query these using the OpenXRSpatialComponentPlaneSemanticLabelList data object.

---

bool supports_mesh_2d() 

Returns true if we support the mesh 2D component (only valid after the OpenXR session has started). You can query these using the OpenXRSpatialComponentMesh2DList data object.

---

bool supports_polygons() 

Returns true if we support the polygon 2D component (only valid after the OpenXR session has started). You can query these using the OpenXRSpatialComponentPolygon2DList data object.
