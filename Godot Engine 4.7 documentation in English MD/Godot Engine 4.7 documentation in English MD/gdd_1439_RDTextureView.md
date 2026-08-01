# RDTextureView

Inherits: RefCounted < Object

Texture view (used by RenderingDevice).

## Description

This object is used by RenderingDevice.

## Properties

DataFormat | format_override | 232
TextureSwizzle | swizzle_a | 6
TextureSwizzle | swizzle_b | 5
TextureSwizzle | swizzle_g | 4
TextureSwizzle | swizzle_r | 3

---

## Property Descriptions

DataFormat format_override = 232 

- void set_format_override(value: DataFormat)
- DataFormat get_format_override()

Optional override for the data format to return sampled values in. The corresponding RDTextureFormat must have had this added as a shareable format. The default value of RenderingDevice.DATA_FORMAT_MAX does not override the format.

---

TextureSwizzle swizzle_a = 6 

- void set_swizzle_a(value: TextureSwizzle)
- TextureSwizzle get_swizzle_a()

The channel to sample when sampling the alpha channel.

---

TextureSwizzle swizzle_b = 5 

- void set_swizzle_b(value: TextureSwizzle)
- TextureSwizzle get_swizzle_b()

The channel to sample when sampling the blue color channel.

---

TextureSwizzle swizzle_g = 4 

- void set_swizzle_g(value: TextureSwizzle)
- TextureSwizzle get_swizzle_g()

The channel to sample when sampling the green color channel.

---

TextureSwizzle swizzle_r = 3 

- void set_swizzle_r(value: TextureSwizzle)
- TextureSwizzle get_swizzle_r()

The channel to sample when sampling the red color channel.
