# OpenXRRenderModelExtension

Inherits: OpenXRExtensionWrapper < Object

This class implements the OpenXR Render Model Extension.

## Description

This class implements the OpenXR Render Model Extension, if enabled it will maintain a list of active render models and provides an interface to the render model data.

## Methods

bool | is_active() const
RID | render_model_create(render_model_id: int)
void | render_model_destroy(render_model: RID)
Array[RID] | render_model_get_all()
int | render_model_get_animatable_node_count(render_model: RID) const
String | render_model_get_animatable_node_name(render_model: RID, index: int) const
Transform3D | render_model_get_animatable_node_transform(render_model: RID, index: int) const
TrackingConfidence | render_model_get_confidence(render_model: RID) const
Transform3D | render_model_get_root_transform(render_model: RID) const
PackedStringArray | render_model_get_subaction_paths(render_model: RID)
String | render_model_get_top_level_path(render_model: RID) const
bool | render_model_is_animatable_node_visible(render_model: RID, index: int) const
Node3D | render_model_new_scene_instance(render_model: RID) const

---

## Signals

render_model_added(render_model: RID) 

Emitted when a new render model is added.

---

render_model_removed(render_model: RID) 

Emitted when a render model is removed.

---

render_model_top_level_path_changed(render_model: RID) 

Emitted when the top level path associated with a render model changed.

---

## Method Descriptions

bool is_active() const 

Returns true if OpenXR's render model extension is supported and enabled.

Note: This only returns a valid value after OpenXR has been initialized.

---

RID render_model_create(render_model_id: int) 

Creates a render model object within OpenXR using a render model id.

Note: This function is exposed for dependent OpenXR extensions that provide render model ids to be used with the render model extension.

---

void render_model_destroy(render_model: RID) 

Destroys a render model object within OpenXR that was previously created with render_model_create().

Note: This function is exposed for dependent OpenXR extensions that provide render model ids to be used with the render model extension.

---

Array[RID] render_model_get_all() 

Returns an array of all currently active render models registered with this extension.

---

int render_model_get_animatable_node_count(render_model: RID) const 

Returns the number of animatable nodes this render model has.

---

String render_model_get_animatable_node_name(render_model: RID, index: int) const 

Returns the name of the given animatable node.

---

Transform3D render_model_get_animatable_node_transform(render_model: RID, index: int) const 

Returns the current local transform for an animatable node. This is updated every frame.

---

TrackingConfidence render_model_get_confidence(render_model: RID) const 

Returns the tracking confidence of the tracking data for the render model.

---

Transform3D render_model_get_root_transform(render_model: RID) const 

Returns the root transform of a render model. This is the tracked position relative to our XROrigin3D node.

---

PackedStringArray render_model_get_subaction_paths(render_model: RID) 

Returns a list of active subaction paths for this render_model.

Note: If different devices are bound to your actions than available in suggested interaction bindings, this information shows paths related to the interaction bindings being mimicked by that device.

---

String render_model_get_top_level_path(render_model: RID) const 

Returns the top level path associated with this render_model. If provided this identifies whether the render model is associated with the player's hands or other body part.

---

bool render_model_is_animatable_node_visible(render_model: RID, index: int) const 

Returns true if this animatable node should be visible.

---

Node3D render_model_new_scene_instance(render_model: RID) const 

Returns an instance of a subscene that contains all MeshInstance3D nodes that allow you to visualize the render model.
