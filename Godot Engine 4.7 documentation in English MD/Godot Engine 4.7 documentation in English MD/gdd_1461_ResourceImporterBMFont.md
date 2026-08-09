# ResourceImporterBMFont

Inherits: ResourceImporter < RefCounted < Object

Imports a bitmap font in the BMFont (.fnt) format.

## Description

The BMFont format is a format created by the BMFont [https://www.angelcode.com/products/bmfont/] program. Many BMFont-compatible programs also exist, like BMGlyph [https://www.bmglyph.com/].

Compared to ResourceImporterImageFont, ResourceImporterBMFont supports bitmap fonts with varying glyph widths/heights.

See also ResourceImporterDynamicFont.

## Tutorials

- Bitmap fonts - Using fonts

## Properties

bool | compress | true
Array | fallbacks | []
int | scaling_mode | 2

---

## Property Descriptions

bool compress = true 

If true, uses lossless compression for the resulting font.

---

Array fallbacks = [] 

List of font fallbacks to use if a glyph isn't found in this bitmap font. Fonts at the beginning of the array are attempted first.

---

int scaling_mode = 2 

Font scaling mode.
