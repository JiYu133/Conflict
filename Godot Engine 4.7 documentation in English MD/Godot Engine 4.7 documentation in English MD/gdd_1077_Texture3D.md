# Texture3D

Inherits: Texture < Resource < RefCounted < Object

Inherited By: CompressedTexture3D, ImageTexture3D, NoiseTexture3D, PlaceholderTexture3D, Texture3DRD

Base class for 3-dimensional textures.

## Description

Base class for ImageTexture3D and CompressedTexture3D. Cannot be used directly, but contains all the functions necessary for accessing the derived resource types. Texture3D is the base class for all 3-dimensional texture types. See also TextureLayered.

All images need to have the same width, height and number of mipmap levels.

To create such a texture file yourself, reimport your image files using the Godot Editor import presets.

## Methods

Array[Image] | _get_data() virtual required const
int | _get_depth() virtual required const
Format | _get_format() virtual required const
int | _get_height() virtual required const
int | _get_width() virtual required const
bool | _has_mipmaps() virtual required const
Resource | create_placeholder() const
Array[Image] | get_data() const
int | get_depth() const
Format | get_format() const
int | get_height() const
int | get_width() const
bool | has_mipmaps() const

---

## Method Descriptions

Array[Image] _get_data() virtual required const 

Called when the Texture3D's data is queried.

---

int _get_depth() virtual required const 

Called when the Texture3D's depth is queried.

---

Format _get_format() virtual required const 

Called when the Texture3D's format is queried.

---

int _get_height() virtual required const 

Called when the Texture3D's height is queried.

---

int _get_width() virtual required const 

Called when the Texture3D's width is queried.

---

bool _has_mipmaps() virtual required const 

Called when the presence of mipmaps in the Texture3D is queried.

---

Resource create_placeholder() const 

Creates a placeholder version of this resource (PlaceholderTexture3D).

---

Array[Image] get_data() const 

Returns the Texture3D's data as an array of Images. Each Image represents a slice of the Texture3D, with different slices mapping to different depth (Z axis) levels.

---

int get_depth() const 

Returns the Texture3D's depth in pixels. Depth is typically represented by the Z axis (a dimension not present in Texture2D).

---

Format get_format() const 

Returns the current format being used by this texture.

---

int get_height() const 

Returns the Texture3D's height in pixels. Width is typically represented by the Y axis.

---

int get_width() const 

Returns the Texture3D's width in pixels. Width is typically represented by the X axis.

---

bool has_mipmaps() const 

Returns true if the Texture3D has generated mipmaps.
