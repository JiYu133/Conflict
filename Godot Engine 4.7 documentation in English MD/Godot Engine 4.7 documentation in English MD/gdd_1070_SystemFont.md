# SystemFont

Inherits: Font < Resource < RefCounted < Object

A font loaded from a system font. Falls back to a default theme font if not implemented on the host OS.

## Description

SystemFont loads a font from a system font with the first matching name from font_names.

It will attempt to match font style, but it's not guaranteed.

The returned font might be part of a font collection or be a variable font with OpenType "weight", "width" and/or "italic" features set.

You can create FontVariation of the system font for precise control over its features.

Note: This class is implemented on iOS, Linux, macOS and Windows, on other platforms it will fallback to default theme font.

## Properties

bool | allow_system_fallback | true
FontAntialiasing | antialiasing | 1
bool | disable_embedded_bitmaps | true
bool | font_italic | false
PackedStringArray | font_names | PackedStringArray()
int | font_stretch | 100
int | font_weight | 400
bool | force_autohinter | false
bool | generate_mipmaps | false
Hinting | hinting | 1
bool | keep_rounding_remainders | true
bool | modulate_color_glyphs | false
int | msdf_pixel_range | 16
int | msdf_size | 48
bool | multichannel_signed_distance_field | false
float | oversampling | 0.0
SubpixelPositioning | subpixel_positioning | 1

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

bool disable_embedded_bitmaps = true 

- void set_disable_embedded_bitmaps(value: bool)
- bool get_disable_embedded_bitmaps()

If set to true, embedded font bitmap loading is disabled (bitmap-only and color fonts ignore this property).

---

bool font_italic = false 

- void set_font_italic(value: bool)
- bool get_font_italic()

If set to true, italic or oblique font is preferred.

---

PackedStringArray font_names = PackedStringArray() 

- void set_font_names(value: PackedStringArray)
- PackedStringArray get_font_names()

Array of font family names to search, first matching font found is used.

Note: The returned array is copied and any changes to it will not update the original property value. See PackedStringArray for more details.

---

int font_stretch = 100 

- void set_font_stretch(value: int)
- int get_font_stretch()

Preferred font stretch amount, compared to a normal width. A percentage value between 50% and 200%.

---

int font_weight = 400 

- void set_font_weight(value: int)
- int get_font_weight()

Preferred weight (boldness) of the font. A value in the 100...999 range, normal font weight is 400, bold font weight is 700.

---

bool force_autohinter = false 

- void set_force_autohinter(value: bool)
- bool is_force_autohinter()

If set to true, auto-hinting is supported and preferred over font built-in hinting.

---

bool generate_mipmaps = false 

- void set_generate_mipmaps(value: bool)
- bool get_generate_mipmaps()

If set to true, generate mipmaps for the font textures.

---

Hinting hinting = 1 

- void set_hinting(value: Hinting)
- Hinting get_hinting()

Font hinting mode.

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

If set to true, glyphs of all sizes are rendered using single multichannel signed distance field generated from the dynamic font vector data.

---

float oversampling = 0.0 

- void set_oversampling(value: float)
- float get_oversampling()

If set to a positive value, overrides the oversampling factor of the viewport this font is used in. See Viewport.oversampling. This value doesn't override the oversampling parameter of draw_* methods.

---

SubpixelPositioning subpixel_positioning = 1 

- void set_subpixel_positioning(value: SubpixelPositioning)
- SubpixelPositioning get_subpixel_positioning()

Font glyph subpixel positioning mode. Subpixel positioning provides shaper text and better kerning for smaller font sizes, at the cost of memory usage and font rasterization speed. Use TextServer.SUBPIXEL_POSITIONING_AUTO to automatically enable it based on the font size.
