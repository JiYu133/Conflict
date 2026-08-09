# OpenXRRenderModel

Inherits: Node3D < Node < Object

This node will display an OpenXR render model.

## Description

This node will display an OpenXR render model by accessing the associated GLTF and processes all animation data (if supported by the XR runtime).

Render models were introduced to allow showing the correct model for the controller (or other device) the user has in hand, since the OpenXR action map does not provide information about the hardware used by the user. Note that while the controller (or device) can be somewhat inferred by the bound action map profile, this is a dangerous approach as the user may be using hardware not known at time of development and OpenXR will simply simulate an available interaction profile.

## Properties

RID | render_model | RID()

## Methods

String | get_top_level_path() const

---

## Signals

render_model_top_level_path_changed() 

Emitted when the top level path of this render model has changed.

---

## Property Descriptions

RID render_model = RID() 

- void set_render_model(value: RID)
- RID get_render_model()

The render model RID for the render model to load, as returned by OpenXRRenderModelExtension.render_model_create() or OpenXRRenderModelExtension.render_model_get_all().

---

## Method Descriptions

String get_top_level_path() const 

Returns the top level path related to this render model.
