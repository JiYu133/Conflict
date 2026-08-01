# OpenXRSpatialCapabilityConfigurationAprilTag

Experimental: This class may be changed or removed in future versions.

Inherits: OpenXRSpatialCapabilityConfigurationBaseHeader < RefCounted < Object

Configuration header for April tag markers.

## Description

Configuration header for April tag markers. Pass this to OpenXRSpatialEntityExtension.create_spatial_context() to create a spatial context that can detect April tags.

## Properties

AprilTagDict | april_dict | 4

## Methods

PackedInt64Array | get_enabled_components() const

---

## Enumerations

enum AprilTagDict
AprilTagDict APRIL_TAG_DICT_16H5 = 1

4 by 4 bits, minimum Hamming distance between any two codes = 5, 30 codes.

AprilTagDict APRIL_TAG_DICT_25H9 = 2

5 by 5 bits, minimum Hamming distance between any two codes = 9, 35 codes.

AprilTagDict APRIL_TAG_DICT_36H10 = 3

6 by 6 bits, minimum Hamming distance between any two codes = 10, 2320 codes.

AprilTagDict APRIL_TAG_DICT_36H11 = 4

6 by 6 bits, minimum Hamming distance between any two codes = 11, 587 codes.

---

## Property Descriptions

AprilTagDict april_dict = 4 

- void set_april_dict(value: AprilTagDict)
- AprilTagDict get_april_dict()

Dictionary to use to decode April tags.

Note: Must be set before using this configuration to create a spatial context.

---

## Method Descriptions

PackedInt64Array get_enabled_components() const 

Returns the components enabled by this configuration.

Note: Only valid after this configuration was used to create a spatial context.
