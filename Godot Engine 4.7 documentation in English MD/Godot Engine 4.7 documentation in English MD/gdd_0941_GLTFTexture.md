# GLTFTexture

Inherits: Resource < RefCounted < Object

GLTFTexture represents a texture in a glTF file.

## Tutorials

- Runtime file loading and saving

## Properties

int | sampler | -1
int | src_image | -1

---

## Property Descriptions

int sampler = -1 

- void set_sampler(value: int)
- int get_sampler()

ID of the texture sampler to use when sampling the image. If -1, then the default texture sampler is used (linear filtering, and repeat wrapping in both axes).

---

int src_image = -1 

- void set_src_image(value: int)
- int get_src_image()

The index of the image associated with this texture, see GLTFState.get_images(). If -1, then this texture does not have an image assigned.
