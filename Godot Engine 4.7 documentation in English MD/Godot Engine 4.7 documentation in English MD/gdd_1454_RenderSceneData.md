# RenderSceneData

Inherits: Object

Inherited By: RenderSceneDataExtension, RenderSceneDataRD

Abstract render data object, holds scene data related to rendering a single frame of a viewport.

## Description

Abstract scene data object, exists for the duration of rendering a single viewport. See also RenderSceneDataRD, RenderData, and RenderDataRD.

Note: This is an internal rendering server object. Do not instantiate this class from a script.

## Methods

Projection | get_cam_projection() const
Transform3D | get_cam_transform() const
RID | get_uniform_buffer() const
int | get_view_count() const
Vector3 | get_view_eye_offset(view: int) const
Projection | get_view_projection(view: int) const

---

## Method Descriptions

Projection get_cam_projection() const 

Returns the camera projection used to render this frame.

Note: If more than one view is rendered, this will return a combined projection.

---

Transform3D get_cam_transform() const 

Returns the camera transform used to render this frame.

Note: If more than one view is rendered, this will return a centered transform.

---

RID get_uniform_buffer() const 

Return the RID of the uniform buffer containing the scene data as a UBO.

---

int get_view_count() const 

Returns the number of views being rendered.

---

Vector3 get_view_eye_offset(view: int) const 

Returns the eye offset per view used to render this frame. This is the offset between our camera transform and the eye transform.

---

Projection get_view_projection(view: int) const 

Returns the view projection per view used to render this frame.

Note: If a single view is rendered, this returns the camera projection. If more than one view is rendered, this will return a projection for the given view including the eye offset.
