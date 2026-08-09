# BlitMaterial

Inherits: Material < Resource < RefCounted < Object

A material that processes blit calls to a DrawableTexture.

## Description

A material resource that can be used by DrawableTextures when processing blit calls to draw.

## Properties

BlendMode | blend_mode | 0

---

## Enumerations

enum BlendMode
BlendMode BLEND_MODE_MIX = 0

Mix blending mode. Colors are assumed to be independent of the alpha (opacity) value.

BlendMode BLEND_MODE_ADD = 1

Additive blending mode.

BlendMode BLEND_MODE_SUB = 2

Subtractive blending mode.

BlendMode BLEND_MODE_MUL = 3

Multiplicative blending mode.

BlendMode BLEND_MODE_DISABLED = 4

No blending mode, direct color copy.

---

## Property Descriptions

BlendMode blend_mode = 0 

- void set_blend_mode(value: BlendMode)
- BlendMode get_blend_mode()

The manner in which the newly blitted texture is blended with the original DrawableTexture.
