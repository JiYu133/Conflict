# RenderData

Inherits: Object

Inherited By: RenderDataExtension, RenderDataRD

Abstract render data object, holds frame data related to rendering a single frame of a viewport.

## Description

Abstract render data object, exists for the duration of rendering a single viewport. See also RenderDataRD, RenderSceneData, and RenderSceneDataRD.

Note: This is an internal rendering server object. Do not instantiate this class from a script.

## Methods

RID | get_camera_attributes() const
RID | get_environment() const
RenderSceneBuffers | get_render_scene_buffers() const
RenderSceneData | get_render_scene_data() const

---

## Method Descriptions

RID get_camera_attributes() const 

Returns the RID of the camera attributes object in the RenderingServer being used to render this viewport.

---

RID get_environment() const 

Returns the RID of the environment object in the RenderingServer being used to render this viewport.

---

RenderSceneBuffers get_render_scene_buffers() const 

Returns the RenderSceneBuffers object managing the scene buffers for rendering this viewport.

---

RenderSceneData get_render_scene_data() const 

Returns the RenderSceneData object managing this frames scene data.
