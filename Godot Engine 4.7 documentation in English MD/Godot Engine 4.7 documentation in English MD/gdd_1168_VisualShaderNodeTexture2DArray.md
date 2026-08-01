# VisualShaderNodeTexture2DArray

Inherits: VisualShaderNodeSample3D < VisualShaderNode < Resource < RefCounted < Object

A 2D texture uniform array to be used within the visual shader graph.

## Description

Translated to uniform sampler2DArray in the shader language.

## Properties

TextureLayered | texture_array

---

## Property Descriptions

TextureLayered texture_array 

- void set_texture_array(value: TextureLayered)
- TextureLayered get_texture_array()

A source texture array. Used if VisualShaderNodeSample3D.source is set to VisualShaderNodeSample3D.SOURCE_TEXTURE.
