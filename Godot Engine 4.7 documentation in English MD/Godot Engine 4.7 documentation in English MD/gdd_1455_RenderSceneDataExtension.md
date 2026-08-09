# RenderSceneDataExtension

Inherits: RenderSceneData < Object

This class allows for a RenderSceneData implementation to be made in GDExtension.

## Description

This class allows for a RenderSceneData implementation to be made in GDExtension.

## Methods

Projection | _get_cam_projection() virtual const
Transform3D | _get_cam_transform() virtual const
RID | _get_uniform_buffer() virtual const
int | _get_view_count() virtual const
Vector3 | _get_view_eye_offset(view: int) virtual const
Projection | _get_view_projection(view: int) virtual const

---

## Method Descriptions

Projection _get_cam_projection() virtual const 

Implement this in GDExtension to return the camera Projection.

---

Transform3D _get_cam_transform() virtual const 

Implement this in GDExtension to return the camera Transform3D.

---

RID _get_uniform_buffer() virtual const 

Implement this in GDExtension to return the RID of the uniform buffer containing the scene data as a UBO.

---

int _get_view_count() virtual const 

Implement this in GDExtension to return the view count.

---

Vector3 _get_view_eye_offset(view: int) virtual const 

Implement this in GDExtension to return the eye offset for the given view.

---

Projection _get_view_projection(view: int) virtual const 

Implement this in GDExtension to return the view Projection for the given view.
