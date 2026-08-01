# OpenXRSpatialCapabilityConfigurationQrCode

Experimental: This class may be changed or removed in future versions.

Inherits: OpenXRSpatialCapabilityConfigurationBaseHeader < RefCounted < Object

Configuration header for micro QR code markers.

## Description

Configuration header for micro QR code markers. Pass this to OpenXRSpatialEntityExtension.create_spatial_context() to create a spatial context that can detect micro QR code markers.

## Methods

PackedInt64Array | get_enabled_components() const

---

## Method Descriptions

PackedInt64Array get_enabled_components() const 

Returns the components enabled by this configuration.

Note: Only valid after this configuration was used to create a spatial context.
