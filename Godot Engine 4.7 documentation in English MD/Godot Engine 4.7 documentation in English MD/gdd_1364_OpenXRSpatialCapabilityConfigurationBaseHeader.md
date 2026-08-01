# OpenXRSpatialCapabilityConfigurationBaseHeader

Experimental: This class may be changed or removed in future versions.

Inherits: RefCounted < Object

Inherited By: OpenXRSpatialCapabilityConfigurationAnchor, OpenXRSpatialCapabilityConfigurationAprilTag, OpenXRSpatialCapabilityConfigurationAruco, OpenXRSpatialCapabilityConfigurationMicroQrCode, OpenXRSpatialCapabilityConfigurationPlaneTracking, OpenXRSpatialCapabilityConfigurationQrCode

Wrapper base class for OpenXR Spatial Capability Configuration headers.

## Description

Wrapper base class for OpenXR Spatial Capability Configuration headers. This class needs to be implemented for each capability configuration structure usable within OpenXR's spatial entities system.

## Methods

int | _get_configuration() virtual
bool | _has_valid_configuration() virtual const
int | get_configuration()
bool | has_valid_configuration() const

---

## Method Descriptions

int _get_configuration() virtual 

Return a pointer (encoded as an int64_t) to a struct holding the spatial capability configuration data. The memory for this struct should remain accessible as long as this object remains instantiated.

---

bool _has_valid_configuration() virtual const 

Return true if this object contains a valid configuration that can be retrieved when calling _get_configuration().

---

int get_configuration() 

Gets a pointer to the XrSpatialCapabilityConfigurationBaseHeaderEXT struct.

Note: This method is intended to be used from GDExtensions.

---

bool has_valid_configuration() const 

Returns true if this object contains a valid configuration that can be used when calling OpenXRSpatialEntityExtension.create_spatial_context().
