# FontFile

Inherits: Font < Resource < RefCounted < Object

Holds font source data and prerendered glyph cache, imported from a dynamic or a bitmap font.

## Description

FontFile contains a set of glyphs to represent Unicode characters imported from a font file, as well as a cache of rasterized glyphs, and a set of fallback Fonts to use.

Use FontVariation to access specific OpenType variation of the font, create simulated bold / slanted version, and draw lines of text.

For more complex text processing, use FontVariation in conjunction with TextLine or TextParagraph.

Supported font formats:

- Dynamic font importer: TrueType (.ttf), TrueType collection (.ttc), OpenType (.otf), OpenType collection (.otc), WOFF (.woff), WOFF2 (.woff2), Type 1 (.pfb, .pfm).
- Bitmap font importer: AngelCode BMFont (.fnt, .font), text and binary (version 3) format variants.
- Monospace image font importer: All supported image formats.

Note: A character is a symbol that represents an item (letter, digit etc.) in an abstract way.

Note: A glyph is a bitmap or a shape used to draw one or more characters in a context-dependent manner. Glyph indices are bound to the specific font data source.

Note: If none of the font data sources contain glyphs for a character used in a string, the character in question will be replaced with a box displaying its hexadecimal code.

```
var f = load("res://BarlowCondensed-Bold.ttf")
$Label.add_theme_font_override("font", f)
$Label.add_theme_font_size_override("font_size", 64)
```

```
var f = ResourceLoader.Load("res://BarlowCondensed-Bold.ttf");
GetNode("Label").AddThemeFontOverride("font", f);
GetNode("Label").AddThemeFontSizeOverride("font_size", 64);
```

## Tutorials

- Runtime file loading and saving

## Properties

bool | allow_system_fallback | true
FontAntialiasing | antialiasing | 1
PackedByteArray | data | PackedByteArray()
bool | disable_embedded_bitmaps | true
int | fixed_size | 0
FixedSizeScaleMode | fixed_size_scale_mode | 0
String | font_name | ""
int | font_stretch | 100
BitField[FontStyle] | font_style | 0
int | font_weight | 400
bool | force_autohinter | false
bool | generate_mipmaps | false
Hinting | hinting | 1
bool | keep_rounding_remainders | true
bool | modulate_color_glyphs | false
int | msdf_pixel_range | 16
int | msdf_size | 48
bool | multichannel_signed_distance_field | false
Dictionary | opentype_feature_overrides | {}
float | oversampling | 0.0
String | style_name | ""
SubpixelPositioning | subpixel_positioning | 1

## Methods

void | clear_cache()
void | clear_glyphs(cache_index: int, size: Vector2i)
void | clear_kerning_map(cache_index: int, size: int)
void | clear_size_cache(cache_index: int)
void | clear_textures(cache_index: int, size: Vector2i)
float | get_cache_ascent(cache_index: int, size: int) const
int | get_cache_count() const
float | get_cache_descent(cache_index: int, size: int) const
float | get_cache_scale(cache_index: int, size: int) const
float | get_cache_underline_position(cache_index: int, size: int) const
float | get_cache_underline_thickness(cache_index: int, size: int) const
int | get_char_from_glyph_index(size: int, glyph_index: int) const
float | get_embolden(cache_index: int) const
float | get_extra_baseline_offset(cache_index: int) const
int | get_extra_spacing(cache_index: int, spacing: SpacingType) const
int | get_face_index(cache_index: int) const
Vector2 | get_glyph_advance(cache_index: int, size: int, glyph: int) const
int | get_glyph_index(size: int, char: int, variation_selector: int) const
PackedInt32Array | get_glyph_list(cache_index: int, size: Vector2i) const
Vector2 | get_glyph_offset(cache_index: int, size: Vector2i, glyph: int) const
Vector2 | get_glyph_size(cache_index: int, size: Vector2i, glyph: int) const
int | get_glyph_texture_idx(cache_index: int, size: Vector2i, glyph: int) const
Rect2 | get_glyph_uv_rect(cache_index: int, size: Vector2i, glyph: int) const
Vector2 | get_kerning(cache_index: int, size: int, glyph_pair: Vector2i) const
Array[Vector2i] | get_kerning_list(cache_index: int, size: int) const
bool | get_language_support_override(language: String) const
PackedStringArray | get_language_support_overrides() const
bool | get_script_support_override(script: String) const
PackedStringArray | get_script_support_overrides() const
Array[Vector2i] | get_size_cache_list(cache_index: int) const
int | get_texture_count(cache_index: int, size: Vector2i) const
Image | get_texture_image(cache_index: int, size: Vector2i, texture_index: int) const
PackedInt32Array | get_texture_offsets(cache_index: int, size: Vector2i, texture_index: int) const
Transform2D | get_transform(cache_index: int) const
Dictionary | get_variation_coordinates(cache_index: int) const
Error | load_bitmap_font(path: String)
Error | load_dynamic_font(path: String)
void | remove_cache(cache_index: int)
void | remove_glyph(cache_index: int, size: Vector2i, glyph: int)
void | remove_kerning(cache_index: int, size: int, glyph_pair: Vector2i)
void | remove_language_support_override(language: String)
void | remove_script_support_override(script: String)
void | remove_size_cache(cache_index: int, size: Vector2i)
void | remove_texture(cache_index: int, size: Vector2i, texture_index: int)
void | render_glyph(cache_index: int, size: Vector2i, index: int)
void | render_range(cache_index: int, size: Vector2i, start: int, end: int)
void | set_cache_ascent(cache_index: int, size: int, ascent: float)
void | set_cache_descent(cache_index: int, size: int, descent: float)
void | set_cache_scale(cache_index: int, size: int, scale: float)
void | set_cache_underline_position(cache_index: int, size: int, underline_position: float)
void | set_cache_underline_thickness(cache_index: int, size: int, underline_thickness: float)
void | set_embolden(cache_index: int, strength: float)
void | set_extra_baseline_offset(cache_index: int, baseline_offset: float)
void | set_extra_spacing(cache_index: int, spacing: SpacingType, value: int)
void | set_face_index(cache_index: int, face_index: int)
void | set_glyph_advance(cache_index: int, size: int, glyph: int, advance: Vector2)
void | set_glyph_offset(cache_index: int, size: Vector2i, glyph: int, offset: Vector2)
void | set_glyph_size(cache_index: int, size: Vector2i, glyph: int, gl_size: Vector2)
void | set_glyph_texture_idx(cache_index: int, size: Vector2i, glyph: int, texture_idx: int)
void | set_glyph_uv_rect(cache_index: int, size: Vector2i, glyph: int, uv_rect: Rect2)
void | set_kerning(cache_index: int, size: int, glyph_pair: Vector2i, kerning: Vector2)
void | set_language_support_override(language: String, supported: bool)
void | set_script_support_override(script: String, supported: bool)
void | set_texture_image(cache_index: int, size: Vector2i, texture_index: int, image: Image)
void | set_texture_offsets(cache_index: int, size: Vector2i, texture_index: int, offset: PackedInt32Array)
void | set_transform(cache_index: int, transform: Transform2D)
void | set_variation_coordinates(cache_index: int, variation_coordinates: Dictionary)

---

## Property Descriptions

bool allow_system_fallback = true 

- void set_allow_system_fallback(value: bool)
- bool is_allow_system_fallback()

If set to true, system fonts can be automatically used as fallbacks.

---

FontAntialiasing antialiasing = 1 

- void set_antialiasing(value: FontAntialiasing)
- FontAntialiasing get_antialiasing()

Font anti-aliasing mode.

---

PackedByteArray data = PackedByteArray() 

- void set_data(value: PackedByteArray)
- PackedByteArray get_data()

Contents of the dynamic font source file.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedByteArray for more details.

---

bool disable_embedded_bitmaps = true 

- void set_disable_embedded_bitmaps(value: bool)
- bool get_disable_embedded_bitmaps()

If set to true, embedded font bitmap loading is disabled (bitmap-only and color fonts ignore this property).

---

int fixed_size = 0 

- void set_fixed_size(value: int)
- int get_fixed_size()

Font size, used only for the bitmap fonts.

---

FixedSizeScaleMode fixed_size_scale_mode = 0 

- void set_fixed_size_scale_mode(value: FixedSizeScaleMode)
- FixedSizeScaleMode get_fixed_size_scale_mode()

Scaling mode, used only for the bitmap fonts with fixed_size greater than zero.

---

String font_name = "" 

- void set_font_name(value: String)
- String get_font_name()

Font family name.

---

int font_stretch = 100 

- void set_font_stretch(value: int)
- int get_font_stretch()

Font stretch amount, compared to a normal width. A percentage value between 50% and 200%.

---

BitField[FontStyle] font_style = 0 

- void set_font_style(value: BitField[FontStyle])
- BitField[FontStyle] get_font_style()

Font style flags.

---

int font_weight = 400 

- void set_font_weight(value: int)
- int get_font_weight()

Weight (boldness) of the font. A value in the 100...999 range, normal font weight is 400, bold font weight is 700.

---

bool force_autohinter = false 

- void set_force_autohinter(value: bool)
- bool is_force_autohinter()

If set to true, auto-hinting is supported and preferred over font built-in hinting. Used by dynamic fonts only (MSDF fonts don't support hinting).

---

bool generate_mipmaps = false 

- void set_generate_mipmaps(value: bool)
- bool get_generate_mipmaps()

If set to true, generate mipmaps for the font textures.

---

Hinting hinting = 1 

- void set_hinting(value: Hinting)
- Hinting get_hinting()

Font hinting mode. Used by dynamic fonts only.

---

bool keep_rounding_remainders = true 

- void set_keep_rounding_remainders(value: bool)
- bool get_keep_rounding_remainders()

If set to true, when aligning glyphs to the pixel boundaries rounding remainders are accumulated to ensure more uniform glyph distribution. This setting has no effect if subpixel positioning is enabled.

---

bool modulate_color_glyphs = false 

- void set_modulate_color_glyphs(value: bool)
- bool is_modulate_color_glyphs()

If set to true, color modulation is applied when drawing colored glyphs, otherwise it's applied to the monochrome glyphs only.

---

int msdf_pixel_range = 16 

- void set_msdf_pixel_range(value: int)
- int get_msdf_pixel_range()

The width of the range around the shape between the minimum and maximum representable signed distance. If using font outlines, msdf_pixel_range must be set to at least twice the size of the largest font outline. The default msdf_pixel_range value of 16 allows outline sizes up to 8 to look correct.

---

int msdf_size = 48 

- void set_msdf_size(value: int)
- int get_msdf_size()

Source font size used to generate MSDF textures. Higher values allow for more precision, but are slower to render and require more memory. Only increase this value if you notice a visible lack of precision in glyph rendering.

---

bool multichannel_signed_distance_field = false 

- void set_multichannel_signed_distance_field(value: bool)
- bool is_multichannel_signed_distance_field()

If set to true, glyphs of all sizes are rendered using single multichannel signed distance field (MSDF) generated from the dynamic font vector data. Since this approach does not rely on rasterizing the font every time its size changes, this allows for resizing the font in real-time without any performance penalty. Text will also not look grainy for Controls that are scaled down (or for Label3Ds viewed from a long distance). As a downside, font hinting is not available with MSDF. The lack of font hinting may result in less crisp and less readable fonts at small sizes.

Note: If using font outlines, msdf_pixel_range must be set to at least twice the size of the largest font outline.

Note: MSDF font rendering does not render glyphs with overlapping shapes correctly. Overlapping shapes are not valid per the OpenType standard, but are still commonly found in many font files, especially those converted by Google Fonts. To avoid issues with overlapping glyphs, consider downloading the font file directly from the type foundry instead of relying on Google Fonts.

---

Dictionary opentype_feature_overrides = {} 

- void set_opentype_feature_overrides(value: Dictionary)
- Dictionary get_opentype_feature_overrides()

Font OpenType feature set override.

---

float oversampling = 0.0 

- void set_oversampling(value: float)
- float get_oversampling()

If set to a positive value, overrides the oversampling factor of the viewport this font is used in. See Viewport.oversampling. This value doesn't override the oversampling parameter of draw_* methods.

---

String style_name = "" 

- void set_font_style_name(value: String)
- String get_font_style_name()

Font style name.

---

SubpixelPositioning subpixel_positioning = 1 

- void set_subpixel_positioning(value: SubpixelPositioning)
- SubpixelPositioning get_subpixel_positioning()

Font glyph subpixel positioning mode. Subpixel positioning provides shaper text and better kerning for smaller font sizes, at the cost of higher memory usage and lower font rasterization speed. Use TextServer.SUBPIXEL_POSITIONING_AUTO to automatically enable it based on the font size.

---

## Method Descriptions

void clear_cache() 

Removes all font cache entries.

---

void clear_glyphs(cache_index: int, size: Vector2i) 

Removes all rendered glyph information from the cache entry.

Note: This function will not remove textures associated with the glyphs, use remove_texture() to remove them manually.

---

void clear_kerning_map(cache_index: int, size: int) 

Removes all kerning overrides.

---

void clear_size_cache(cache_index: int) 

Removes all font sizes from the cache entry.

---

void clear_textures(cache_index: int, size: Vector2i) 

Removes all textures from font cache entry.

Note: This function will not remove glyphs associated with the texture, use remove_glyph() to remove them manually.

---

float get_cache_ascent(cache_index: int, size: int) const 

Returns the font ascent (number of pixels above the baseline).

---

int get_cache_count() const 

Returns number of the font cache entries.

---

float get_cache_descent(cache_index: int, size: int) const 

Returns the font descent (number of pixels below the baseline).

---

float get_cache_scale(cache_index: int, size: int) const 

Returns scaling factor of the color bitmap font.

---

float get_cache_underline_position(cache_index: int, size: int) const 

Returns pixel offset of the underline below the baseline.

---

float get_cache_underline_thickness(cache_index: int, size: int) const 

Returns thickness of the underline in pixels.

---

int get_char_from_glyph_index(size: int, glyph_index: int) const 

Returns character code associated with glyph_index, or 0 if glyph_index is invalid. See get_glyph_index().

---

float get_embolden(cache_index: int) const 

Returns embolden strength, if is not equal to zero, emboldens the font outlines. Negative values reduce the outline thickness.

---

float get_extra_baseline_offset(cache_index: int) const 

Returns extra baseline offset (as a fraction of font height).

---

int get_extra_spacing(cache_index: int, spacing: SpacingType) const 

Returns spacing for spacing in pixels (not relative to the font size).

---

int get_face_index(cache_index: int) const 

Returns an active face index in the TrueType / OpenType collection.

---

Vector2 get_glyph_advance(cache_index: int, size: int, glyph: int) const 

Returns glyph advance (offset of the next glyph).

Note: Advance for glyphs outlines is the same as the base glyph advance and is not saved.

---

int get_glyph_index(size: int, char: int, variation_selector: int) const 

Returns the glyph index of a char, optionally modified by the variation_selector.

---

PackedInt32Array get_glyph_list(cache_index: int, size: Vector2i) const 

Returns list of rendered glyphs in the cache entry.

---

Vector2 get_glyph_offset(cache_index: int, size: Vector2i, glyph: int) const 

Returns glyph offset from the baseline.

---

Vector2 get_glyph_size(cache_index: int, size: Vector2i, glyph: int) const 

Returns glyph size.

---

int get_glyph_texture_idx(cache_index: int, size: Vector2i, glyph: int) const 

Returns index of the cache texture containing the glyph.

---

Rect2 get_glyph_uv_rect(cache_index: int, size: Vector2i, glyph: int) const 

Returns rectangle in the cache texture containing the glyph.

---

Vector2 get_kerning(cache_index: int, size: int, glyph_pair: Vector2i) const 

Returns kerning for the pair of glyphs.

---

Array[Vector2i] get_kerning_list(cache_index: int, size: int) const 

Returns list of the kerning overrides.

---

bool get_language_support_override(language: String) const 

Returns true if support override is enabled for the language.

---

PackedStringArray get_language_support_overrides() const 

Returns list of language support overrides.

---

bool get_script_support_override(script: String) const 

Returns true if support override is enabled for the script.

---

PackedStringArray get_script_support_overrides() const 

Returns list of script support overrides.

---

Array[Vector2i] get_size_cache_list(cache_index: int) const 

Returns list of the font sizes in the cache. Each size is Vector2i with font size and outline size.

---

int get_texture_count(cache_index: int, size: Vector2i) const 

Returns number of textures used by font cache entry.

---

Image get_texture_image(cache_index: int, size: Vector2i, texture_index: int) const 

Returns a copy of the font cache texture image.

---

PackedInt32Array get_texture_offsets(cache_index: int, size: Vector2i, texture_index: int) const 

Returns a copy of the array containing glyph packing data.

---

Transform2D get_transform(cache_index: int) const 

Returns 2D transform, applied to the font outlines, can be used for slanting, flipping and rotating glyphs.

---

Dictionary get_variation_coordinates(cache_index: int) const 

Returns variation coordinates for the specified font cache entry. See Font.get_supported_variation_list() for more info.

---

Error load_bitmap_font(path: String) 

Loads an AngelCode BMFont (.fnt, .font) bitmap font from file path.

Warning: This method should only be used in the editor or in cases when you need to load external fonts at run-time, such as fonts located at the user:// directory.

---

Error load_dynamic_font(path: String) 

Loads a TrueType (.ttf), OpenType (.otf), WOFF (.woff), WOFF2 (.woff2) or Type 1 (.pfb, .pfm) dynamic font from file path.

Warning: This method should only be used in the editor or in cases when you need to load external fonts at run-time, such as fonts located at the user:// directory.

---

void remove_cache(cache_index: int) 

Removes specified font cache entry.

---

void remove_glyph(cache_index: int, size: Vector2i, glyph: int) 

Removes specified rendered glyph information from the cache entry.

Note: This function will not remove textures associated with the glyphs, use remove_texture() to remove them manually.

---

void remove_kerning(cache_index: int, size: int, glyph_pair: Vector2i) 

Removes kerning override for the pair of glyphs.

---

void remove_language_support_override(language: String) 

Remove language support override.

---

void remove_script_support_override(script: String) 

Removes script support override.

---

void remove_size_cache(cache_index: int, size: Vector2i) 

Removes specified font size from the cache entry.

---

void remove_texture(cache_index: int, size: Vector2i, texture_index: int) 

Removes specified texture from the cache entry.

Note: This function will not remove glyphs associated with the texture. Remove them manually using remove_glyph().

---

void render_glyph(cache_index: int, size: Vector2i, index: int) 

Renders specified glyph to the font cache texture.

---

void render_range(cache_index: int, size: Vector2i, start: int, end: int) 

Renders the range of characters to the font cache texture.

---

void set_cache_ascent(cache_index: int, size: int, ascent: float) 

Sets the font ascent (number of pixels above the baseline).

---

void set_cache_descent(cache_index: int, size: int, descent: float) 

Sets the font descent (number of pixels below the baseline).

---

void set_cache_scale(cache_index: int, size: int, scale: float) 

Sets scaling factor of the color bitmap font.

---

void set_cache_underline_position(cache_index: int, size: int, underline_position: float) 

Sets pixel offset of the underline below the baseline.

---

void set_cache_underline_thickness(cache_index: int, size: int, underline_thickness: float) 

Sets thickness of the underline in pixels.

---

void set_embolden(cache_index: int, strength: float) 

Sets embolden strength, if is not equal to zero, emboldens the font outlines. Negative values reduce the outline thickness.

---

void set_extra_baseline_offset(cache_index: int, baseline_offset: float) 

Sets extra baseline offset (as a fraction of font height).

---

void set_extra_spacing(cache_index: int, spacing: SpacingType, value: int) 

Sets the spacing for spacing to value in pixels (not relative to the font size).

---

void set_face_index(cache_index: int, face_index: int) 

Sets an active face index in the TrueType / OpenType collection.

---

void set_glyph_advance(cache_index: int, size: int, glyph: int, advance: Vector2) 

Sets glyph advance (offset of the next glyph).

Note: Advance for glyphs outlines is the same as the base glyph advance and is not saved.

---

void set_glyph_offset(cache_index: int, size: Vector2i, glyph: int, offset: Vector2) 

Sets glyph offset from the baseline.

---

void set_glyph_size(cache_index: int, size: Vector2i, glyph: int, gl_size: Vector2) 

Sets glyph size.

---

void set_glyph_texture_idx(cache_index: int, size: Vector2i, glyph: int, texture_idx: int) 

Sets index of the cache texture containing the glyph.

---

void set_glyph_uv_rect(cache_index: int, size: Vector2i, glyph: int, uv_rect: Rect2) 

Sets rectangle in the cache texture containing the glyph.

---

void set_kerning(cache_index: int, size: int, glyph_pair: Vector2i, kerning: Vector2) 

Sets kerning for the pair of glyphs.

---

void set_language_support_override(language: String, supported: bool) 

Adds override for Font.is_language_supported().

---

void set_script_support_override(script: String, supported: bool) 

Adds override for Font.is_script_supported().

---

void set_texture_image(cache_index: int, size: Vector2i, texture_index: int, image: Image) 

Sets font cache texture image.

---

void set_texture_offsets(cache_index: int, size: Vector2i, texture_index: int, offset: PackedInt32Array) 

Sets array containing glyph packing data.

---

void set_transform(cache_index: int, transform: Transform2D) 

Sets 2D transform, applied to the font outlines, can be used for slanting, flipping, and rotating glyphs.

---

void set_variation_coordinates(cache_index: int, variation_coordinates: Dictionary) 

Sets variation coordinates for the specified font cache entry. See Font.get_supported_variation_list() for more info.
