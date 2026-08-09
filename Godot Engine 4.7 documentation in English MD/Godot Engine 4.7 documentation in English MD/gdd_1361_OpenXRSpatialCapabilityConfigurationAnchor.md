# OpenXRSpatialCapabilityConfigurationAnchor

Experimental: This class may be changed or removed in future versions.

Inherits: OpenXRSpatialCapabilityConfigurationBaseHeader < RefCounted < Object

Configuration header for spatial anchors.

## Description

Configuration header for spatial anchors. Pass this to OpenXRSpatialEntityExtension.create_spatial_context() to create a spatial context with spatial anchor capabilities.

## Methods

PackedInt64Array | get_enabled_components() const

---

## Method Descriptions

PackedInt64Array get_enabled_components() const 

Returns the components enabled by this configuration.

Note: Only valid after this configuration was used to create a spatial context.
