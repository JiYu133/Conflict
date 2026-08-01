# Texture2DRD

Inherits: Texture2D < Texture < Resource < RefCounted < Object

Texture for 2D that is bound to a texture created on the RenderingDevice.

## Description

This texture class allows you to use a 2D texture created directly on the RenderingDevice as a texture for materials, meshes, etc.

Note: Texture2DRD is intended for low-level usage with RenderingDevice. For most use cases, use Texture2D instead.

## Tutorials

- Compute Texture demo [https://godotengine.org/asset-library/asset/2764]

## Properties

bool | resource_local_to_scene | false (overrides Resource)
RID | texture_rd_rid |

---

## Property Descriptions

RID texture_rd_rid 

- void set_texture_rd_rid(value: RID)
- RID get_texture_rd_rid()

The RID of the texture object created on the RenderingDevice.
