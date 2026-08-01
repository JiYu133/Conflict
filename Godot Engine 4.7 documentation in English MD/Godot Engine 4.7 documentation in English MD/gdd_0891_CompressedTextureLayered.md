# CompressedTextureLayered

Inherits: TextureLayered < Texture < Resource < RefCounted < Object

Inherited By: CompressedCubemap, CompressedCubemapArray, CompressedTexture2DArray

Base class for texture arrays that can optionally be compressed.

## Description

Base class for CompressedTexture2DArray and CompressedTexture3D. Cannot be used directly, but contains all the functions necessary for accessing the derived resource types. See also TextureLayered.

## Properties

String | load_path | ""

## Methods

Error | load(path: String)

---

## Property Descriptions

String load_path = "" 

- Error load(path: String)
- String get_load_path()

The path the texture should be loaded from.

---

## Method Descriptions

Error load(path: String) 

Loads the texture at path.
