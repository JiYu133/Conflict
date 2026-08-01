# VisualShaderNodeBillboard

Inherits: VisualShaderNode < Resource < RefCounted < Object

A node that controls how the object faces the camera to be used within the visual shader graph.

## Description

The output port of this node needs to be connected to Model View Matrix port of VisualShaderNodeOutput.

## Properties

BillboardType | billboard_type | 1
bool | keep_scale | false

---

## Enumerations

enum BillboardType
BillboardType BILLBOARD_TYPE_DISABLED = 0

Billboarding is disabled and the node does nothing.

BillboardType BILLBOARD_TYPE_ENABLED = 1

A standard billboarding algorithm is enabled.

BillboardType BILLBOARD_TYPE_FIXED_Y = 2

A billboarding algorithm to rotate around Y-axis is enabled.

BillboardType BILLBOARD_TYPE_PARTICLES = 3

A billboarding algorithm designed to use on particles is enabled.

BillboardType BILLBOARD_TYPE_MAX = 4

Represents the size of the BillboardType enum.

---

## Property Descriptions

BillboardType billboard_type = 1 

- void set_billboard_type(value: BillboardType)
- BillboardType get_billboard_type()

Controls how the object faces the camera.

---

bool keep_scale = false 

- void set_keep_scale_enabled(value: bool)
- bool is_keep_scale_enabled()

If true, the shader will keep the scale set for the mesh. Otherwise, the scale is lost when billboarding.
