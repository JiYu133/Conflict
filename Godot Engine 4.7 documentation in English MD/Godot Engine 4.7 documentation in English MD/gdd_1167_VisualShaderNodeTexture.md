# VisualShaderNodeTexture

Inherits: VisualShaderNode < Resource < RefCounted < Object

Performs a 2D texture lookup within the visual shader graph.

## Description

Performs a lookup operation on the provided texture, with support for multiple texture sources to choose from.

## Properties

Source | source | 0
Texture2D | texture |
TextureType | texture_type | 0

---

## Enumerations

enum Source
Source SOURCE_TEXTURE = 0

Use the texture given as an argument for this function.

Source SOURCE_SCREEN = 1

Use the current viewport's texture as the source.

Source SOURCE_2D_TEXTURE = 2

Use the texture from this shader's texture built-in (e.g. a texture of a Sprite2D).

Source SOURCE_2D_NORMAL = 3

Use the texture from this shader's normal map built-in.

Source SOURCE_DEPTH = 4

Use the depth texture captured during the depth prepass. Only available when the depth prepass is used (i.e. in spatial shaders and in the forward_plus or gl_compatibility renderers).

Source SOURCE_PORT = 5

Use the texture provided in the input port for this function.

Source SOURCE_3D_NORMAL = 6

Use the normal buffer captured during the depth prepass. Only available when the normal-roughness buffer is available (i.e. in spatial shaders and in the forward_plus renderer).

Source SOURCE_ROUGHNESS = 7

Use the roughness buffer captured during the depth prepass. Only available when the normal-roughness buffer is available (i.e. in spatial shaders and in the forward_plus renderer).

Source SOURCE_MAX = 8

Represents the size of the Source enum.

---

enum TextureType
TextureType TYPE_DATA = 0

No hints are added to the uniform declaration.

TextureType TYPE_COLOR = 1

Adds source_color as hint to the uniform declaration for proper conversion from nonlinear sRGB encoding to linear encoding.

TextureType TYPE_NORMAL_MAP = 2

Adds hint_normal as hint to the uniform declaration, which internally converts the texture for proper usage as normal map.

TextureType TYPE_MAX = 3

Represents the size of the TextureType enum.

---

## Property Descriptions

Source source = 0 

- void set_source(value: Source)
- Source get_source()

Determines the source for the lookup.

---

Texture2D texture 

- void set_texture(value: Texture2D)
- Texture2D get_texture()

The source texture, if needed for the selected source.

---

TextureType texture_type = 0 

- void set_texture_type(value: TextureType)
- TextureType get_texture_type()

Specifies the type of the texture if source is set to SOURCE_TEXTURE.
