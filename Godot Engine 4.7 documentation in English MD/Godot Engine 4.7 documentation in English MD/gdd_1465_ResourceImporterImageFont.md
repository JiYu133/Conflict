# ResourceImporterImageFont

Inherits: ResourceImporter < RefCounted < Object

Imports a bitmap font where all glyphs have the same width and height.

## Description

This image-based workflow can be easier to use than ResourceImporterBMFont, but it requires all glyphs to have the same width and height, glyph advances and drawing offsets can be customized. This makes ResourceImporterImageFont most suited to fixed-width fonts.

See also ResourceImporterDynamicFont.

## Tutorials

- Bitmap fonts - Using fonts

## Properties

int | ascent | 0
Rect2i | character_margin | Rect2i(0, 0, 0, 0)
PackedStringArray | character_ranges | PackedStringArray()
int | columns | 1
bool | compress | true
int | descent | 0
Array | fallbacks | []
Rect2i | image_margin | Rect2i(0, 0, 0, 0)
PackedStringArray | kerning_pairs | PackedStringArray()
int | rows | 1
int | scaling_mode | 2

---

## Property Descriptions

int ascent = 0 

Font ascent (number of pixels above the baseline). If set to 0, half of the character height is used.

---

Rect2i character_margin = Rect2i(0, 0, 0, 0) 

Margin applied around every imported glyph. If your font image contains guides (in the form of lines between glyphs) or if spacing between characters appears incorrect, try adjusting character_margin.

---

PackedStringArray character_ranges = PackedStringArray() 

The character ranges to import from the font image. This is an array that maps each position on the image (in tile coordinates, not pixels). The font atlas is traversed from left to right and top to bottom. Characters can be specified with decimal numbers (126), hexadecimal numbers (0x007e or U+007e), or between single quotes ('~'). Ranges can be specified with a hyphen between characters.

For example, 0-127 represents the full ASCII range. It can also be written as 0x0000-0x007f (or U+0000-U+007f). As another example, ' '-'~' is equivalent to 32-126 and represents the range of printable (visible) ASCII characters.

For any range, the character advance and offset can be customized by appending three space-separated integer values (additional advance, x offset, y offset) to the end. For example 'a'-'b' 4 5 2 sets the advance to char_width + 4 and offset to Vector2(5, 2) for both a and b characters.

Note: The overall number of characters must not exceed the number of columns multiplied by rows. Otherwise, the font will fail to import.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedStringArray for more details.

---

int columns = 1 

Number of columns in the font image. See also rows.

---

bool compress = true 

If true, uses lossless compression for the resulting font.

---

int descent = 0 

Font descent (number of pixels below the baseline). If set to 0, half of the character height is used.

---

Array fallbacks = [] 

List of font fallbacks to use if a glyph isn't found in this bitmap font. Fonts at the beginning of the array are attempted first.

---

Rect2i image_margin = Rect2i(0, 0, 0, 0) 

Margin to cut on the sides of the entire image. This can be used to cut parts of the image that contain attribution information or similar.

---

PackedStringArray kerning_pairs = PackedStringArray() 

Kerning pairs for the font. Kerning pair adjust the spacing between two characters.

Each string consist of three space separated values: "from" string, "to" string and integer offset. Each combination form the two string for a kerning pair, e.g, ab cd -3 will create kerning pairs ac, ad, bc, and bd with offset -3. \uXXXX escape sequences can be used to add Unicode characters.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedStringArray for more details.

---

int rows = 1 

Number of rows in the font image. See also columns.

---

int scaling_mode = 2 

Font scaling mode.
