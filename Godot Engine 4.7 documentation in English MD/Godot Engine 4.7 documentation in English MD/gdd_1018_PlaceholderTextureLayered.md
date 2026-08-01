# PlaceholderTextureLayered

Inherits: TextureLayered < Texture < Resource < RefCounted < Object

Inherited By: PlaceholderCubemap, PlaceholderCubemapArray, PlaceholderTexture2DArray

Placeholder class for a 2-dimensional texture array.

## Description

This class is used when loading a project that uses a TextureLayered subclass in 2 conditions:

- When running the project exported in dedicated server mode, only the texture's dimensions are kept (as they may be relied upon for gameplay purposes or positioning of other elements). This allows reducing the exported PCK's size significantly.
- When this subclass is missing due to using a different engine version or build (e.g. modules disabled).

Note: This is not intended to be used as an actual texture for rendering. It is not guaranteed to work like one in shaders or materials (for example when calculating UV).

## Properties

int | layers | 1
Vector2i | size | Vector2i(1, 1)

---

## Property Descriptions

int layers = 1 

- void set_layers(value: int)
- int get_layers()

The number of layers in the texture array.

---

Vector2i size = Vector2i(1, 1) 

- void set_size(value: Vector2i)
- Vector2i get_size()

The size of each texture layer (in pixels).
