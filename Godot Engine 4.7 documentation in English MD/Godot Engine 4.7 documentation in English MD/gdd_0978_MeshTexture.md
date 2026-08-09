# MeshTexture

Inherits: Texture2D < Texture < Resource < RefCounted < Object

Simple texture that uses a mesh to draw itself.

## Description

Simple texture that uses a mesh to draw itself. It's limited because flags can't be changed and region drawing is not supported.

## Properties

Texture2D | base_texture |
Vector2 | image_size | Vector2(0, 0)
Mesh | mesh |
bool | resource_local_to_scene | false (overrides Resource)

---

## Property Descriptions

Texture2D base_texture 

- void set_base_texture(value: Texture2D)
- Texture2D get_base_texture()

Sets the base texture that the Mesh will use to draw.

---

Vector2 image_size = Vector2(0, 0) 

- void set_image_size(value: Vector2)
- Vector2 get_image_size()

Sets the size of the image, needed for reference.

---

Mesh mesh 

- void set_mesh(value: Mesh)
- Mesh get_mesh()

Sets the mesh used to draw. It must be a mesh using 2D vertices.
