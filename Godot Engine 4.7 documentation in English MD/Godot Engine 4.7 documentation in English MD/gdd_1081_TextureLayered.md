# TextureLayered

Inherits: Texture < Resource < RefCounted < Object

Inherited By: CompressedTextureLayered, ImageTextureLayered, PlaceholderTextureLayered, TextureLayeredRD

Base class for texture types which contain the data of multiple Images. Each image is of the same size and format.

## Description

Base class for ImageTextureLayered and CompressedTextureLayered. Cannot be used directly, but contains all the functions necessary for accessing the derived resource types. See also Texture3D.

Data is set on a per-layer basis. For Texture2DArrays, the layer specifies the array layer.

All images need to have the same width, height and number of mipmap levels.

A TextureLayered can be loaded with ResourceLoader.load().

Internally, Godot maps these files to their respective counterparts in the target rendering driver (Vulkan, OpenGL3).

## Methods

Format | _get_format() virtual required const
int | _get_height() virtual required const
Image | _get_layer_data(layer_index: int) virtual required const
int | _get_layered_type() virtual required const
int | _get_layers() virtual required const
int | _get_width() virtual required const
bool | _has_mipmaps() virtual required const
Format | get_format() const
int | get_height() const
Image | get_layer_data(layer: int) const
LayeredType | get_layered_type() const
int | get_layers() const
int | get_width() const
bool | has_mipmaps() const

---

## Enumerations

enum LayeredType
LayeredType LAYERED_TYPE_2D_ARRAY = 0

Texture is a generic Texture2DArray.

LayeredType LAYERED_TYPE_CUBEMAP = 1

Texture is a Cubemap, with each side in its own layer (6 in total).

LayeredType LAYERED_TYPE_CUBEMAP_ARRAY = 2

Texture is a CubemapArray, with each cubemap being made of 6 layers.

---

## Method Descriptions

Format _get_format() virtual required const 

Called when the TextureLayered's format is queried.

---

int _get_height() virtual required const 

Called when the TextureLayered's height is queried.

---

Image _get_layer_data(layer_index: int) virtual required const 

Called when the data for a layer in the TextureLayered is queried.

---

int _get_layered_type() virtual required const 

Called when the layers' type in the TextureLayered is queried.

---

int _get_layers() virtual required const 

Called when the number of layers in the TextureLayered is queried.

---

int _get_width() virtual required const 

Called when the TextureLayered's width queried.

---

bool _has_mipmaps() virtual required const 

Called when the presence of mipmaps in the TextureLayered is queried.

---

Format get_format() const 

Returns the current format being used by this texture.

---

int get_height() const 

Returns the height of the texture in pixels. Height is typically represented by the Y axis.

---

Image get_layer_data(layer: int) const 

Returns an Image resource with the data from specified layer.

---

LayeredType get_layered_type() const 

Returns the TextureLayered's type. The type determines how the data is accessed, with cubemaps having special types.

---

int get_layers() const 

Returns the number of referenced Images.

---

int get_width() const 

Returns the width of the texture in pixels. Width is typically represented by the X axis.

---

bool has_mipmaps() const 

Returns true if the layers have generated mipmaps.
