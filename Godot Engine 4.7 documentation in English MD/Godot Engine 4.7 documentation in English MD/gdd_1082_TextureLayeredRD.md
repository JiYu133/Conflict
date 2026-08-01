# TextureLayeredRD

Inherits: TextureLayered < Texture < Resource < RefCounted < Object

Inherited By: Texture2DArrayRD, TextureCubemapArrayRD, TextureCubemapRD

Abstract base class for layered texture RD types.

## Description

Base class for Texture2DArrayRD, TextureCubemapRD and TextureCubemapArrayRD. Cannot be used directly, but contains all the functions necessary for accessing the derived resource types.

Note: TextureLayeredRD is intended for low-level usage with RenderingDevice. For most use cases, use TextureLayered instead.

## Tutorials

- Compute Texture demo [https://godotengine.org/asset-library/asset/2764]

## Properties

RID | texture_rd_rid

---

## Property Descriptions

RID texture_rd_rid 

- void set_texture_rd_rid(value: RID)
- RID get_texture_rd_rid()

The RID of the texture object created on the RenderingDevice.
