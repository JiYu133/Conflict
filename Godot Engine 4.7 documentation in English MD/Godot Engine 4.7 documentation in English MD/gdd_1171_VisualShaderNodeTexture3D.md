# VisualShaderNodeTexture3D

Inherits: VisualShaderNodeSample3D < VisualShaderNode < Resource < RefCounted < Object

Performs a 3D texture lookup within the visual shader graph.

## Description

Performs a lookup operation on the provided texture, with support for multiple texture sources to choose from.

## Properties

Texture3D | texture

---

## Property Descriptions

Texture3D texture 

- void set_texture(value: Texture3D)
- Texture3D get_texture()

A source texture. Used if VisualShaderNodeSample3D.source is set to VisualShaderNodeSample3D.SOURCE_TEXTURE.
